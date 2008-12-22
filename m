Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33340 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbYLVRMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 12:12:48 -0500
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081223044424.GC11534@myhost.users.atheros.com> (sfid-20081222_161107_710545_E957B4A1)
References: <20081223044424.GC11534@myhost.users.atheros.com>
	 (sfid-20081222_161107_710545_E957B4A1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q8U8EVjXM1E5kNp+XPgU"
Date: Mon, 22 Dec 2008 18:12:50 +0100
Message-Id: <1229965970.4406.2.camel@johannes> (sfid-20081222_181253_029921_6CED2EB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q8U8EVjXM1E5kNp+XPgU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 20:44 -0800, Vivek Natarajan wrote:
> This patch enables mac80211 to send a null frame and also to
> check for tim in the beacon if power save is enabled.
>=20
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Looks good to me, to be sure, this is all dependent on !NO_STACK_PS,
right?

johannes

> ---
>  net/mac80211/ieee80211_i.h |    3 +++
>  net/mac80211/mlme.c        |   41 ++++++++++++++++++++++++++++++++++++++=
++-
>  net/mac80211/scan.c        |    2 +-
>  net/mac80211/wext.c        |   13 +++++++++----
>  4 files changed, 53 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index f3eec98..2038498 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -986,6 +986,9 @@ u64 ieee80211_mandatory_rates(struct ieee80211_local =
*local,
>  void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
>  void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
>  void ieee80211_dynamic_ps_timer(unsigned long data);
> +void ieee80211_send_nullfunc(struct ieee80211_local *local,
> +			     struct ieee80211_sub_if_data *sdata,
> +			     int powersave);
> =20
>  void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
>  				     enum queue_stop_reason reason);
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index b23e62b..ca22718 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -568,6 +568,30 @@ static void ieee80211_sta_wmm_params(struct ieee8021=
1_local *local,
>  	}
>  }
> =20
> +static bool check_tim(struct ieee802_11_elems *elems, u16 aid, bool *is_=
mc)
> +{
> +	u8 mask;
> +	u8 index, indexn1, indexn2;
> +	struct ieee80211_tim_ie *tim =3D (struct ieee80211_tim_ie *) elems->tim=
;
> +
> +	aid &=3D 0x3fff;
> +	index =3D aid / 8;
> +	mask  =3D 1 << (aid & 7);
> +
> +	if (tim->bitmap_ctrl & 0x01)
> +		*is_mc =3D true;
> +
> +	indexn1 =3D tim->bitmap_ctrl & 0xfe;
> +	indexn2 =3D elems->tim_len + indexn1 - 4;
> +
> +	if (index < indexn1 || index > indexn2)
> +		return false;
> +
> +	index -=3D indexn1;
> +
> +	return !!(tim->virtual_map[index] & mask);
> +}
> +
>  static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data =
*sdata,
>  					   u16 capab, bool erp_valid, u8 erp)
>  {
> @@ -752,6 +776,7 @@ static void ieee80211_set_associated(struct ieee80211=
_sub_if_data *sdata,
>  			mod_timer(&local->dynamic_ps_timer, jiffies +
>  				  msecs_to_jiffies(local->dynamic_ps_timeout));
>  		else {
> +			ieee80211_send_nullfunc(local, sdata, 1);
>  			conf->flags |=3D IEEE80211_CONF_PS;
>  			ieee80211_hw_config(local,
>  					    IEEE80211_CONF_CHANGE_PS);
> @@ -1729,7 +1754,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee802=
11_sub_if_data *sdata,
>  	struct ieee802_11_elems elems;
>  	struct ieee80211_local *local =3D sdata->local;
>  	u32 changed =3D 0;
> -	bool erp_valid;
> +	bool erp_valid, directed_tim, is_mc =3D false;
>  	u8 erp_value =3D 0;
> =20
>  	/* Process beacon from the current BSS */
> @@ -1752,6 +1777,18 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80=
211_sub_if_data *sdata,
>  	ieee80211_sta_wmm_params(local, ifsta, elems.wmm_param,
>  				 elems.wmm_param_len);
> =20
> +	if (!(local->hw.flags & IEEE80211_HW_NO_STACK_DYNAMIC_PS)) {
> +		directed_tim =3D check_tim(&elems, ifsta->aid, &is_mc);
> +
> +		if (directed_tim || is_mc) {
> +			if (local->hw.conf.flags && IEEE80211_CONF_PS) {
> +				local->hw.conf.flags &=3D ~IEEE80211_CONF_PS;
> +				ieee80211_hw_config(local,
> +						IEEE80211_CONF_CHANGE_PS);
> +				ieee80211_send_nullfunc(local, sdata, 0);
> +			}
> +		}
> +	}
> =20
>  	if (elems.erp_info && elems.erp_info_len >=3D 1) {
>  		erp_valid =3D true;
> @@ -2651,10 +2688,12 @@ void ieee80211_dynamic_ps_enable_work(struct work=
_struct *work)
>  	struct ieee80211_local *local =3D
>  		container_of(work, struct ieee80211_local,
>  			     dynamic_ps_enable_work);
> +	struct ieee80211_sub_if_data *sdata =3D local->scan_sdata;
> =20
>  	if (local->hw.conf.flags & IEEE80211_CONF_PS)
>  		return;
> =20
> +	ieee80211_send_nullfunc(local, sdata, 1);
>  	local->hw.conf.flags |=3D IEEE80211_CONF_PS;
> =20
>  	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index f5c7c33..a2caeed 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -395,7 +395,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata=
, struct sk_buff *skb,
>  	return RX_QUEUED;
>  }
> =20
> -static void ieee80211_send_nullfunc(struct ieee80211_local *local,
> +void ieee80211_send_nullfunc(struct ieee80211_local *local,
>  				    struct ieee80211_sub_if_data *sdata,
>  				    int powersave)
>  {
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 673c5d7..6470614 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -871,12 +871,17 @@ set:
>  			mod_timer(&local->dynamic_ps_timer, jiffies +
>  				  msecs_to_jiffies(local->dynamic_ps_timeout));
>  		else {
> -			if (local->powersave)
> +			if (local->powersave) {
> +				ieee80211_send_nullfunc(local, sdata, 1);
>  				conf->flags |=3D IEEE80211_CONF_PS;
> -			else
> +				ret =3D ieee80211_hw_config(local,
> +						IEEE80211_CONF_CHANGE_PS);
> +			} else {
>  				conf->flags &=3D ~IEEE80211_CONF_PS;
> -			ret =3D ieee80211_hw_config(local,
> -					IEEE80211_CONF_CHANGE_PS);
> +				ret =3D ieee80211_hw_config(local,
> +						IEEE80211_CONF_CHANGE_PS);
> +				ieee80211_send_nullfunc(local, sdata, 0);
> +			}
>  		}
>  	}
> =20

--=-q8U8EVjXM1E5kNp+XPgU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT8qPAAoJEKVg1VMiehFYSBwP/12uY9qT4BADCLCM+fSNezfu
GHLwCbCVAU5Y54eESxxjI/Gi4yV77O0cpylnOMkjkgRWiNTGQh+VZByI/tWXarQM
yOhl+zE7ypi7YmCrWwTlzqMI1ClMgwliSA1upF00hSE8xvjqpidwC8NjgF4P7ZCu
F1tJZPCkfCVtOrIJkI5hMLZmsdQ9GsvxJGnSZv6bQcFIOW2Mmg9P92OwlhVKwayt
kQTXcBZqnNFSLnnZ7S+PGNnvKD2PZFFnDjuzO9CyGTWaB7biKGscNmjW05XQ7Jcr
ZX0h6+Id8p+GTRM2o949xF06PvwD5QdoHcoLDZV65/P1KVGFLUPWbXf1xnxl5Gbr
KsN0fQR/GKJtuLBjUKaolVamTMaIrkgFfTxl/dWbdkRuzanb6ASO0MGKD/nps+PQ
RyosSnB5tIs0eimn658GY1UFqq36j3vAP67Ke9JZHoZjALaBOJue4KzVkSZp51hU
+yjYA+h1on+EIhJowtivnDYIwoXI+ZurmWU93akc4s4XGH+Qf27J8uX90lAToMVC
PrqYyshehOe7nz9JMjRNd2J+l+G+VEJrKPV42C8dj6fgEbExEdwlg+Nc+Gvc+g43
mexhZJN8ivxwJgD+zs/7IoKAeZJmNQqoJ+NeZaEmtkZpZLdkIelXgllDL9vrlM8w
R4lydi0CXQC/Y6kJRGxJ
=rnIa
-----END PGP SIGNATURE-----

--=-q8U8EVjXM1E5kNp+XPgU--

