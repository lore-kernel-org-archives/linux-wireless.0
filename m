Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbYGBWe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 18:34:28 -0400
Subject: Re: [PATCH 1/1] mac80211: call bss_info_change only once upon
	disassociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1215037633-27975-1-git-send-email-tomas.winkler@intel.com>
References: <1215037633-27975-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JmeS3eKCo+U1nn4Yp/t2"
Date: Thu, 03 Jul 2008 00:33:40 +0200
Message-Id: <1215038020.13270.13.camel@johannes.berg> (sfid-20080703_003432_321315_17526F83)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JmeS3eKCo+U1nn4Yp/t2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 01:27 +0300, Tomas Winkler wrote:
> This patch removes call of ieee80211_bss_info_change_notify from within
> ieee80211_reset_erp_info. This allows gathering all bss info changes
> into one call to the driver in the disassociation flow.

Seems sane to me.

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_i.h |    2 +-
>  net/mac80211/main.c        |   12 ++++++------
>  net/mac80211/mlme.c        |    2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 775d5e8..c916c2f 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -892,7 +892,7 @@ int ieee80211_sta_deauthenticate(struct net_device *d=
ev, u16 reason);
>  int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
>  void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdat=
a,
>  				      u32 changed);
> -void ieee80211_reset_erp_info(struct net_device *dev);
> +u32 ieee80211_reset_erp_info(struct net_device *dev);
>  int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
>  				   struct ieee80211_ht_info *ht_info);
>  int ieee80211_ht_addt_info_ie_to_ht_bss_info(
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 074f71a..cc756e9 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -182,10 +182,11 @@ static int ieee80211_open(struct net_device *dev)
>  {
>  	struct ieee80211_sub_if_data *sdata, *nsdata;
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> +	struct sta_info *sta;
>  	struct ieee80211_if_init_conf conf;
> +	u32 changed =3D 0;
>  	int res;
>  	bool need_hw_reconfig =3D 0;
> -	struct sta_info *sta;
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> @@ -329,7 +330,8 @@ static int ieee80211_open(struct net_device *dev)
>  			goto err_stop;
> =20
>  		ieee80211_if_config(dev);
> -		ieee80211_reset_erp_info(dev);
> +		changed |=3D ieee80211_reset_erp_info(dev);
> +		ieee80211_bss_info_change_notify(sdata, changed);
>  		ieee80211_enable_keys(sdata);
> =20
>  		if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA &&
> @@ -1190,15 +1192,13 @@ void ieee80211_bss_info_change_notify(struct ieee=
80211_sub_if_data *sdata,
>  					     changed);
>  }
> =20
> -void ieee80211_reset_erp_info(struct net_device *dev)
> +u32 ieee80211_reset_erp_info(struct net_device *dev)
>  {
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
>  	sdata->bss_conf.use_cts_prot =3D 0;
>  	sdata->bss_conf.use_short_preamble =3D 0;
> -	ieee80211_bss_info_change_notify(sdata,
> -					 BSS_CHANGED_ERP_CTS_PROT |
> -					 BSS_CHANGED_ERP_PREAMBLE);
> +	return BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_ERP_PREAMBLE;
>  }
> =20
>  void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 2a92708..37ea04f 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -573,7 +573,7 @@ static void ieee80211_set_associated(struct net_devic=
e *dev,
>  		ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid);
>  		ifsta->flags &=3D ~IEEE80211_STA_ASSOCIATED;
>  		netif_carrier_off(dev);
> -		ieee80211_reset_erp_info(dev);
> +		changed |=3D ieee80211_reset_erp_info(dev);
> =20
>  		sdata->bss_conf.assoc_ht =3D 0;
>  		sdata->bss_conf.ht_conf =3D NULL;

--=-JmeS3eKCo+U1nn4Yp/t2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbAJBAAoJEKVg1VMiehFYdRMP/1RJKb+xlrisZrgolDVXjV8a
syNXUjIpJ023WbjTpki5ycbXi1rkvk//YnTJgpN4hvVDJczYfu/SvfpuUpQKEfLI
NAvmC6EAZMjV7j5wdYasfJjMieIilZ0GgryeBV5GY+kn51mqKT52ce5/9viqeluJ
J3DGEsdG43cOdRm1h10s3gUZbh+52557D4Ylm0Dyb+qV8Ys4Ff74c2EvocYRB08h
cgQGbJPy2MqK20zB0rMpV5NYrdobocsW8v3AQd6u5V9z6aRhPcdzc5t2bLaVGhk1
ZF2/p/OdypmVcKHZxMiXQW3tRFA7AfWL9RYmvmvsz9Qe6VmuXerr4tyrBJIfAmim
Z0Iow/7Snw7KuPiekq0sWFej4D72jKhkyZDIoFg/iV42Jiwe8t/YuWiB2icJ08ss
mTnZ0Mrf/gtDEptxLqqpvMcHJNnNjahHmvEtPrQ59ASJlNguj0swwPpc61wV+5qh
9VyIlTpynG70lIWO1SlRxzVbwtveQPDNdhPJPYJZx+qP+cXnht/GVhPlU8679ct/
peDiCv8789m5SS2iD8EGmso4jgi74xGyTyNSHDG3FMHcw4hvp/7GVIItDHmZuKJq
pINQuQctxt1g6wRlPgbmbVIiEzGNvPLPeYqfyFJ/H4bvb9IkcWCpz0cMUrrl/iBL
9K4k1tNRlqpMXF+ATHka
=rfDE
-----END PGP SIGNATURE-----

--=-JmeS3eKCo+U1nn4Yp/t2--

