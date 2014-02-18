Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57516 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaBRXjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 18:39:02 -0500
Received: by mail-pb0-f48.google.com with SMTP id rr13so17377666pbb.7
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 15:39:01 -0800 (PST)
Date: Tue, 18 Feb 2014 15:38:56 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH v3 3/6] cfg80211: Enable GO operation on additional
 channels
Message-ID: <20140218233852.GC14296@garbanzo.do-not-panic.com> (sfid-20140219_003908_258559_D3F1F1BA)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-4-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
In-Reply-To: <1390818118-27261-4-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 12:21:55PM +0200, Ilan Peer wrote:
> Allow GO operation on a channel marked with IEEE80211_CHAN_GO_CONCURRENT
> iff there is an active station interface that is associated to
> an AP operating on the same channel in 2.4 or the same UNII band in 5.2
> (assuming that the AP is an authorized master)
>=20
> Note that this is a permissive approach to the FCC definitions,
> that require a clear assessment that the device operating the AP is
> an authorized master, i.e., with radar detection and DFS capabilities.

OK It seems here you are clarifying that the feature is only when
you can verify the AP is DFS-capable. How can you verify that?

> It is assumed that such restrictions are enforced by user space.
> Furthermore, it is assumed, that if the conditions that allowed for
> the operation of the GO on such a channel change, i.e., the station
> interface disconnected from the AP, it is the responsibility of user
> space to evacuate the GO from the channel.

This is a pretty important piece of information as well. Once
these patches go in I really want to make it clear that we should
update the documentation the wiki as noted before.

> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> ---
>  include/net/cfg80211.h   |    4 ++-
>  include/net/regulatory.h |    4 +++
>  net/mac80211/ibss.c      |    9 ++++--
>  net/wireless/Kconfig     |   14 ++++++++++
>  net/wireless/chan.c      |   68 ++++++++++++++++++++++++++++++++++++++++=
++++--
>  net/wireless/mesh.c      |    3 +-
>  net/wireless/nl80211.c   |   11 +++++---
>  net/wireless/reg.c       |   26 ++++++++++++++++++
>  net/wireless/reg.h       |   12 ++++++++
>  net/wireless/trace.h     |   11 +++++---
>  10 files changed, 146 insertions(+), 16 deletions(-)
>=20
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index dbc5490..317bd06 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -4520,12 +4520,14 @@ void cfg80211_report_obss_beacon(struct wiphy *wi=
phy,
>   * cfg80211_reg_can_beacon - check if beaconing is allowed
>   * @wiphy: the wiphy
>   * @chandef: the channel definition
> + * @iftype: interface type
>   *
>   * Return: %true if there is no secondary channel or the secondary chann=
el(s)
>   * can be used for beaconing (i.e. is not a radar channel etc.)
>   */
>  bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
> -			     struct cfg80211_chan_def *chandef);
> +			     struct cfg80211_chan_def *chandef,
> +			     enum nl80211_iftype iftype);
> =20
>  /*
>   * cfg80211_ch_switch_notify - update wdev channel and notify userspace
> diff --git a/include/net/regulatory.h b/include/net/regulatory.h
> index b07cdc9..fab0c37 100644
> --- a/include/net/regulatory.h
> +++ b/include/net/regulatory.h
> @@ -131,6 +131,9 @@ struct regulatory_request {
>   * 	all country IE information processed by the regulatory core. This wi=
ll
>   * 	override %REGULATORY_COUNTRY_IE_FOLLOW_POWER as all country IEs will
>   * 	be ignored.
> + * @REGULATORY_DISABLE_RELAX_NO_IR: for devices that do not wish to allo=
w the
> + *      NO_IR relaxation, which enables transmissions on channels on whi=
ch
> + *      otherwise initiating radiation is not allowed.

Please provide an example. A read of this documentation likely
cannot guess the available relaxations available, and this is
only obvious to the reader of this patch series. If you are
adding a Kconfig entry you can refer to it, or you can refer
to the channel flags as pointers to further documentation.

> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 81c05e4..6335590 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -102,6 +102,20 @@ config CFG80211_REG_CELLULAR_HINTS
>  	  This option adds support for drivers that can receive regulatory
>  	  hints from cellular base stations
> =20
> +config CFG80211_REG_RELAX_NO_IR
> +	bool "cfg80211 support for NO_IR relaxation"
> +	depends on CFG80211_CERTIFICATION_ONUS
> +	---help---
> +	  This option enables relaxation of the NO_IR flag. The relaxation
> +	  allows initiating radiation on channels that are marked with the
> +	  NO_IR flag which forbids transmissions on the channel.
> +
> +	  For example, enabling this option allows the operation of a P2P
> +	  group owner on channels marked with NO_IR if there is an additional
> +	  BSS interface which is connected to an AP which is assumed to be
> +	  an authorized master, i.e., with radar detection support and DFS
> +	  capabilities

Please use:

This option enables support for relaxation of the NO_IR flag
for situations that certain regulatory bodies have provided
clarifications on how relaxation can occur. This feature
has an inherent dependency on userspace features which must
have been properly tested and as such is not enabled by
default.

A relaxation feature example is allowing the operation of a P2P
group owner (GO) on channels marked with NO_IR if there is an
additional BSS interface which associated to an AP which
userspace assumes or confirems to be an authorized master,
i.e., with radar detection support and DFS capabilities.


Ilan, also extend the above with language similar to the one
I provided on the cellular base station hints if you ended
up adding a device feature capability.

> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 78559b5..87a9d0e 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -605,15 +605,77 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>  }
>  EXPORT_SYMBOL(cfg80211_chandef_usable);
> =20
> +/*
> + * For GO only, check if the channel can be used under permissive condit=
ions
> + * mandated by the some regulatory bodies, i.e., the channel is marked w=
ith
> + * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station inter=
face
> + * associated to an AP on the same channel or on the same UNII band
> + * (assuming that the AP is an authorized master).
> + */
> +static bool cfg80211_go_permissive_chan(struct cfg80211_registered_devic=
e *rdev,
> +					struct ieee80211_channel *chan)
> +{
> +	struct wireless_dev *wdev_iter;
> +
> +	ASSERT_RTNL();

You can simplify the check that calls this by having the
config_enabled() check here. You can also add the check
for REGULATORY_DISABLE_RELAX_NO_IR here.

> +
> +	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
> +		return false;
> +
> +	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
> +		struct ieee80211_channel *other_chan =3D NULL;
> +		int r1, r2;
> +
> +		if (wdev_iter->iftype !=3D NL80211_IFTYPE_STATION ||
> +		    !netif_running(wdev_iter->netdev))
> +				continue;
> +
> +		wdev_lock(wdev_iter);
> +		if (wdev_iter->current_bss)
> +			other_chan =3D wdev_iter->current_bss->pub.channel;
> +		wdev_unlock(wdev_iter);

Please wrap this up into a helper either for this series or after.
Just a friendly reminder :)

> +
> +		if (!other_chan)
> +			continue;
> +
> +		if (chan =3D=3D other_chan)
> +			return true;

This seems to me to indicate that we have allowed here
daisy chaining / trust on another GO who also trusted
its AP. That is, we are leaving it up to the kernel for
the above few lines of code to check if the STA was
associated to an AP that had DFS support. How do we
know the AP the STA was associated to was not another
GO that ran through this permissive check? Is the FCC
happy with that?

Also to be clear, you check for IEEE80211_CHAN_GO_CONCURRENT
only on the caller's channel, not the STA's device, is that
OK ? Lets consider the case case of two different types of
interfaces on the same system. I am aware of at least one
802.11 AP company selling devices with one 802.11 vendor as
the AP and another as the STA. I don't consider this rare
anymore now, as such please think about this case as well.

> +
> +		if (chan->band !=3D IEEE80211_BAND_5GHZ)
> +			continue;
> +
> +		r1 =3D cfg80211_get_unii(chan->center_freq);
> +		r2 =3D cfg80211_get_unii(other_chan->center_freq);
> +
> +		if (r1 !=3D -EINVAL && r1 =3D=3D r2)
> +			return true;

Looks good, the same concern about IEEE80211_CHAN_GO_CONCURRENT
on the other_chan applies here.

> +	}
> +
> +	return false;
> +}
> +
>  bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
> -			     struct cfg80211_chan_def *chandef)
> +			     struct cfg80211_chan_def *chandef,
> +			     enum nl80211_iftype iftype)
>  {
> +	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
>  	bool res;
>  	u32 prohibited_flags =3D IEEE80211_CHAN_DISABLED |
> -			       IEEE80211_CHAN_NO_IR |
>  			       IEEE80211_CHAN_RADAR;
> =20
> -	trace_cfg80211_reg_can_beacon(wiphy, chandef);
> +	trace_cfg80211_reg_can_beacon(wiphy, chandef, iftype);
> +
> +	/*
> +	 * Under certain conditions suggested by the some regulatory bodies
> +	 * a GO can operate on channels marked with IEEE80211_NO_IR
> +	 * so set this flag only if such relaxations are not enabled and
> +	 * the conditions are not met.
> +	 */
> +	if (iftype !=3D NL80211_IFTYPE_P2P_GO ||
> +	    !config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
> +	    (wiphy->regulatory_flags & REGULATORY_DISABLE_RELAX_NO_IR) ||
> +	    !cfg80211_go_permissive_chan(rdev, chandef->chan))

This is the check I was saying you could simplify by tossing the
config checks and wiphy->regulatory_flags check there.

> +		prohibited_flags |=3D IEEE80211_CHAN_NO_IR;
> =20
>  	if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
>  	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
> diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
> index 8858624..93c4d42 100644
> --- a/net/wireless/mesh.c
> +++ b/net/wireless/mesh.c
> @@ -175,7 +175,8 @@ int __cfg80211_join_mesh(struct cfg80211_registered_d=
evice *rdev,
>  							       scan_width);
>  	}
> =20
> -	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
> +	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef,
> +				     NL80211_IFTYPE_MESH_POINT))
>  		return -EINVAL;
> =20
>  	err =3D cfg80211_chandef_dfs_required(wdev->wiphy, &setup->chandef);
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 3c1587f..b37b36e 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1914,7 +1914,7 @@ static int __nl80211_set_channel(struct cfg80211_re=
gistered_device *rdev,
>  			result =3D -EBUSY;
>  			break;
>  		}
> -		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef)) {
> +		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef, iftype)) {
>  			result =3D -EINVAL;
>  			break;
>  		}
> @@ -3263,7 +3263,8 @@ static int nl80211_start_ap(struct sk_buff *skb, st=
ruct genl_info *info)
>  	} else if (!nl80211_get_ap_channel(rdev, &params))
>  		return -EINVAL;
> =20
> -	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
> +	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
> +				     wdev->iftype))
>  		return -EINVAL;
> =20
>  	err =3D cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
> @@ -5852,7 +5853,8 @@ skip_beacons:
>  	if (err)
>  		return err;
> =20
> -	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
> +	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
> +				     wdev->iftype))
>  		return -EINVAL;
> =20
>  	if (dev->ieee80211_ptr->iftype =3D=3D NL80211_IFTYPE_AP ||
> @@ -6623,7 +6625,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, s=
truct genl_info *info)
>  	if (err)
>  		return err;
> =20
> -	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
> +	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef,
> +				     NL80211_IFTYPE_ADHOC))
>  		return -EINVAL;
> =20
>  	switch (ibss.chandef.width) {
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 8a81913..ec38f5d 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2489,6 +2489,32 @@ static void reg_timeout_work(struct work_struct *w=
ork)
>  	rtnl_unlock();
>  }
> =20
>
> +int cfg80211_get_unii(int freq)

A reference to where this is documented would be good.

> +{
> +	/* UNII-1 */
> +	if (freq >=3D 5150 && freq <=3D 5250)
> +		return 0;
> +
> +	/* UNII-2A */
> +	if (freq > 5250 && freq <=3D 5350)
> +		return 1;
> +
> +	/* UNII-2B */
> +	if (freq > 5350 && freq <=3D 5470)
> +		return 2;
> +
> +	/* UNII-2C */
> +	if (freq > 5470 && freq <=3D 5725)
> +		return 3;
> +
> +	/* UNII-3 */
> +	if (freq > 5725 && freq <=3D 5825)
> +		return 4;
> +
> +	WARN_ON(1);

probably best to avoid that warning -- there are some
4 GHz channels used out there, and pretty sure we'll hit
this fast.

  Luis

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTA+8MAAoJEKwtdpJg+MHGAgkQALCtMmp9kjeccZM1Gi9EebOL
5b9iZFDc1XtM5r3lT12wDw/Au8012ThUiV7Wz6BjwPeBeLNNCeQMABzaHDXvm1Ih
h0R8J70FuBtE+H2zm6fDL4i/oJUWohSIdf3hz9A2/Zfn6jG0ba9GEeulLpm91i8r
nGYja2IhlVc//iNB8TIBbX0knxkI6SuNKqumRxPQYbgVhoIzYfw0QXjWh8ibf3h/
OzO/Kv4Nru/FsYMeAw16BMCMpEw2PO4bg0jv0IETQ4Xza9F2+kR9MkQxNNLg5tNo
UlRS8gHhDjnCsyOspZEq8e5GquGIVi9f+KCEEJB7Cu9Z5mijQZHz0Ye4aoPjfSsO
6B3CRNDIY7Q2BSNpJdYmk8IByWtTJ9Ty9iSTzTjCV+/CM9GXJtl1KPQSf8s7bd79
mbHxr3ReaNk3Czf8Pcd0p53ixZRUWd/9215ldcLhAvXo3LNVc/AdcULviT0uAQIY
36UU8Yy6xc6OUIx1xfsyCQkalicW4amtRlKETP1tHWV5Wdd7zmJwXeDkp41mnK1F
PkIVSBo5JtBlmUgG80bWE/NvRtR3ozbb65WEEmLDc638vPG1oU1wXg+eex4hGjlf
iyZbrpWJlHDc505iNYIeuQRjbYzYmkdh0F1003qQ8HlNMLY643dXHVli4YtjXp/a
8u1mOuO4l0RVxe+iw+jT
=JiS9
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
