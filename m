Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37843 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYLWRGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 12:06:06 -0500
Subject: Re: [PATCH] mac80211: Scale down to non-HT association with
	TKIP/WEP as pairwise cipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1230048051-4522-1-git-send-email-vasanth@atheros.com> (sfid-20081223_170302_986885_CDE99298)
References: <1230048051-4522-1-git-send-email-vasanth@atheros.com>
	 (sfid-20081223_170302_986885_CDE99298)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/oMZy//ioFap9ohQZAW7"
Date: Tue, 23 Dec 2008 18:06:08 +0100
Message-Id: <1230051968.31228.0.camel@johannes> (sfid-20081223_180616_641770_22275D45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/oMZy//ioFap9ohQZAW7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-23 at 21:30 +0530, Vasanthakumar Thiagarajan wrote:
> As TKIP is not updated to new security needs which arise when
> TKIP is used to encrypt A-MPDU aggregated data frames, IEEE802.11n
> does not allow any cipher other than CCMP (Which has new extensions
> defined) as pairwise cipher between HT peers.
>=20
> When such configuration (TKIP/WEP in HT) is forced, we still
> associate in non-HT mode (11a/b/g).
>=20
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Ok, we'll revisit this when we do normal key config in cfg80211, until
then this looks good to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/iface.c       |    3 ++-
>  net/mac80211/mlme.c        |    9 ++++++++-
>  net/mac80211/wext.c        |   12 +++++++++++-
>  4 files changed, 22 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index f3eec98..5f8ad88 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -258,6 +258,7 @@ struct mesh_preq_queue {
>  #define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
>  #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
>  #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
> +#define IEEE80211_STA_TKIP_WEP_USED	BIT(14)
>  /* flags for MLME request */
>  #define IEEE80211_STA_REQ_SCAN 0
>  #define IEEE80211_STA_REQ_DIRECT_PROBE 1
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 5abbc3f..19cfc0a 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -459,7 +459,8 @@ static int ieee80211_stop(struct net_device *dev)
>  		synchronize_rcu();
>  		skb_queue_purge(&sdata->u.sta.skb_queue);
> =20
> -		sdata->u.sta.flags &=3D ~IEEE80211_STA_PRIVACY_INVOKED;
> +		sdata->u.sta.flags &=3D ~(IEEE80211_STA_PRIVACY_INVOKED |
> +					IEEE80211_STA_TKIP_WEP_USED);
>  		kfree(sdata->u.sta.extra_ie);
>  		sdata->u.sta.extra_ie =3D NULL;
>  		sdata->u.sta.extra_ie_len =3D 0;
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index c75d0ea..4998dc5 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -391,10 +391,17 @@ static void ieee80211_send_assoc(struct ieee80211_s=
ub_if_data *sdata,
>  	}
> =20
>  	/* wmm support is a must to HT */
> +	/*
> +	 * IEEE802.11n does not allow TKIP/WEP as pairwise
> +	 * ciphers in HT mode. We still associate in non-ht
> +	 * mode (11a/b/g) if any one of these ciphers is
> +	 * configured as pairwise.
> +	 */
>  	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
>  	    sband->ht_cap.ht_supported &&
>  	    (ht_ie =3D ieee80211_bss_get_ie(bss, WLAN_EID_HT_INFORMATION)) &&
> -	    ht_ie[1] >=3D sizeof(struct ieee80211_ht_info)) {
> +	    ht_ie[1] >=3D sizeof(struct ieee80211_ht_info) &&
> +	    (!(ifsta->flags & IEEE80211_STA_TKIP_WEP_USED))) {
>  		struct ieee80211_ht_info *ht_info =3D
>  			(struct ieee80211_ht_info *)(ht_ie + 2);
>  		u16 cap =3D sband->ht_cap.cap;
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 7162d58..011592f 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -903,12 +903,22 @@ static int ieee80211_ioctl_siwauth(struct net_devic=
e *dev,
> =20
>  	switch (data->flags & IW_AUTH_INDEX) {
>  	case IW_AUTH_WPA_VERSION:
> -	case IW_AUTH_CIPHER_PAIRWISE:
>  	case IW_AUTH_CIPHER_GROUP:
>  	case IW_AUTH_WPA_ENABLED:
>  	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
>  	case IW_AUTH_KEY_MGMT:
>  		break;
> +	case IW_AUTH_CIPHER_PAIRWISE:
> +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> +			if (data->value & (IW_AUTH_CIPHER_WEP40 |
> +			    IW_AUTH_CIPHER_WEP104 | IW_AUTH_CIPHER_TKIP))
> +				sdata->u.sta.flags |=3D
> +					IEEE80211_STA_TKIP_WEP_USED;
> +			else
> +				sdata->u.sta.flags &=3D
> +					~IEEE80211_STA_TKIP_WEP_USED;
> +		}
> +		break;
>  	case IW_AUTH_DROP_UNENCRYPTED:
>  		sdata->drop_unencrypted =3D !!data->value;
>  		break;

--=-/oMZy//ioFap9ohQZAW7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJURp8AAoJEKVg1VMiehFYHBsP/3O5v7I+Kk9wTdcLILeD3Mbh
J8NLI/B4E0m7TetHwAGpmzoKNeYcanFS5jpUMO2O4s7WE2TVRpi2TA6b5Jiquygr
d2mXnR6Cf6dPVGuK/V9ejNOWMCp2nnHrvxzlCE6jExbW5itWslPWMseXtBzw/KAX
YWjAdIfpl4KuVo8lvAq8L0qODJruy5Od8O52f8eJ/E7o/YCzHJg9s1+2HVK8SSKx
kbj3Sfwr6VeWdBNmCKENWfVfITn7qd4ULrJwoSa0TzskbuWPdl0Aq2q+0olBMbkE
VuDK1BfJ5hyV5jvOvTvBukZsYWmU+K3suW6wfznwZF1k/goZgPcxMXHQpkBcf5vd
X/PEmZkl4vmD2kaWAdpt5Tq8RBnda0PuiaPGaxWZNZFdpDbbc5o1WJcLUcF68GW7
aeGLzCo8/ppiZFfZjkO3lynNgHOvArl9iBZdEJ4WTPT1lPEgtIZuBdEzD98sko4r
bJY6UqwzC7ciKGcoAm2yEZ11kCeMkUUnwhG45v40Lo5EEVz3AabjsnFnrL6hv1Zi
56QVOUPmWu7Wjad+s00ehVN1vam/c7A/ax2TyZas6HUt+oaK82nD0tbEttvzntJF
GOOmz7GxgPqcCn9RJ39S7W+tcuqpwKm86mF76TUg5Wiq5aFXfQ1qOsa6KkjDG06v
uC32Tpol3Itag/tUCy2+
=yWnh
-----END PGP SIGNATURE-----

--=-/oMZy//ioFap9ohQZAW7--

