Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:46980 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946292Ab3BHLq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 06:46:29 -0500
Date: Fri, 8 Feb 2013 12:46:23 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2] mac80211: explicitly copy channels to VLANs where
 needed
Message-ID: <20130208114623.GA30933@pandem0nium> (sfid-20130208_124636_490601_D714A1FD)
References: <1360322072-17239-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
In-Reply-To: <1360322072-17239-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Johannes,

On Fri, Feb 08, 2013 at 12:14:32PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> Currently the code assigns channel contexts to VLANs
> (for use by the TX/RX code) when the AP master gets
> its channel context assigned. This works fine, but
> in the upcoming radar detection work the VLANs don't
> require a channel context (during radar detection)
> and assigning one to them anyway causes issues with
> locking and also inconsistencies -- a VLAN interface
> that is added before radar detection would get the
> channel context, while one added during it wouldn't.
>=20
> Fix these issues moving the channel context copying
> to a new explicit operation that will not be used
> in the radar detection code.

Thanks for taking care of this! This looks so much
better than my humble attempt to solve this locking issue...

I'll drop my patch then and remove the remaining locks
in the DFS patchset then.

Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
>=20
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/cfg.c         |  2 ++
>  net/mac80211/chan.c        | 52 ++++++++++++++++++++++++++++++----------=
------
>  net/mac80211/ieee80211_i.h |  2 ++
>  3 files changed, 38 insertions(+), 18 deletions(-)
>=20
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 799e706..68eca17 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -933,6 +933,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, st=
ruct net_device *dev,
>  					IEEE80211_CHANCTX_SHARED);
>  	if (err)
>  		return err;
> +	ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
> =20
>  	/*
>  	 * Apply control port protocol, this allows us to
> @@ -1047,6 +1048,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, s=
truct net_device *dev)
>  	local->total_ps_buffered -=3D skb_queue_len(&sdata->u.ap.ps.bc_buf);
>  	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
> =20
> +	ieee80211_vif_copy_chanctx_to_vlans(sdata, true);
>  	ieee80211_vif_release_channel(sdata);
> =20
>  	return 0;
> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index ad35185..bf10da6 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -211,15 +211,6 @@ static void __ieee80211_vif_release_channel(struct i=
eee80211_sub_if_data *sdata)
> =20
>  	ctx =3D container_of(conf, struct ieee80211_chanctx, conf);
> =20
> -	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP) {
> -		struct ieee80211_sub_if_data *vlan;
> -
> -		/* for the VLAN list */
> -		ASSERT_RTNL();
> -		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
> -			rcu_assign_pointer(vlan->vif.chanctx_conf, NULL);
> -	}
> -
>  	ieee80211_unassign_vif_chanctx(sdata, ctx);
>  	if (ctx->refcount =3D=3D 0)
>  		ieee80211_free_chanctx(local, ctx);
> @@ -339,15 +330,6 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_i=
f_data *sdata,
>  		goto out;
>  	}
> =20
> -	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP) {
> -		struct ieee80211_sub_if_data *vlan;
> -
> -		/* for the VLAN list */
> -		ASSERT_RTNL();
> -		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
> -			rcu_assign_pointer(vlan->vif.chanctx_conf, &ctx->conf);
> -	}
> -
>  	ieee80211_recalc_smps_chanctx(local, ctx);
>   out:
>  	mutex_unlock(&local->chanctx_mtx);
> @@ -430,6 +412,40 @@ void ieee80211_vif_vlan_copy_chanctx(struct ieee8021=
1_sub_if_data *sdata)
>  	mutex_unlock(&local->chanctx_mtx);
>  }
> =20
> +void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *s=
data,
> +					 bool clear)
> +{
> +	struct ieee80211_local *local =3D sdata->local;
> +	struct ieee80211_sub_if_data *vlan;
> +	struct ieee80211_chanctx_conf *conf;
> +
> +	ASSERT_RTNL();
> +
> +	if (WARN_ON(sdata->vif.type !=3D NL80211_IFTYPE_AP))
> +		return;
> +
> +	mutex_lock(&local->chanctx_mtx);
> +
> +	/*
> +	 * Check that conf exists, even when clearing this function
> +	 * must be called with the AP's channel context still there
> +	 * as it would otherwise cause VLANs to have an invalid
> +	 * channel context pointer for a while, possibly pointing
> +	 * to a channel context that has already been freed.
> +	 */
> +	conf =3D rcu_dereference_protected(sdata->vif.chanctx_conf,
> +				lockdep_is_held(&local->chanctx_mtx));
> +	WARN_ON(!conf);
> +
> +	if (clear)
> +		conf =3D NULL;
> +
> +	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
> +		rcu_assign_pointer(vlan->vif.chanctx_conf, conf);
> +
> +	mutex_unlock(&local->chanctx_mtx);
> +}
> +
>  void ieee80211_iter_chan_contexts_atomic(
>  	struct ieee80211_hw *hw,
>  	void (*iter)(struct ieee80211_hw *hw,
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 816bebb..f016507 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -1614,6 +1614,8 @@ ieee80211_vif_change_bandwidth(struct ieee80211_sub=
_if_data *sdata,
>  			       const struct cfg80211_chan_def *chandef);
>  void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
>  void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata=
);
> +void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *s=
data,
> +					 bool clear);
> =20
>  void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
>  				   struct ieee80211_chanctx *chanctx);
> --=20
> 1.8.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEU5Y8ACgkQrzg/fFk7axanFgCdEp0ugNDuLtDi27vN3nwPhPb9
n80An2A8Mk8kj+XlrWM4CLWIcoYvyHWM
=Gc5r
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
