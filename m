Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbYEUPin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 11:38:43 -0400
Subject: Re: [PATCH 1/1] mac80211: fix ieee80211_rx_bss_put/get imbalance
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1211383025-1004-1-git-send-email-tomas.winkler@intel.com>
References: <1211383025-1004-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VQ9LY3Wg04pO27WICLXt"
Date: Wed, 21 May 2008 17:37:43 +0200
Message-Id: <1211384263.13667.16.camel@johannes.berg> (sfid-20080521_173848_679768_D5C3A2D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VQ9LY3Wg04pO27WICLXt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-21 at 18:17 +0300, Tomas Winkler wrote:
> This patch fixes iee80211_rx_bss_put/get imbalance
> introduced by 'mac80211: enable IBSS merging' patch.
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Looks correct to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

John, when will you start merging real work again? :)


> ---
>  net/mac80211/mlme.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7cfd12e..0ef5993 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2479,8 +2479,6 @@ static int ieee80211_sta_join_ibss(struct net_devic=
e *dev,
>  	ifsta->state =3D IEEE80211_IBSS_JOINED;
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
> =20
> -	ieee80211_rx_bss_put(dev, bss);
> -
>  	return res;
>  }
> =20
> @@ -3523,6 +3521,7 @@ static int ieee80211_sta_create_ibss(struct net_dev=
ice *dev,
>  	struct ieee80211_supported_band *sband;
>  	u8 bssid[ETH_ALEN], *pos;
>  	int i;
> +	int ret;
>  	DECLARE_MAC_BUF(mac);
> =20
>  #if 0
> @@ -3567,7 +3566,9 @@ static int ieee80211_sta_create_ibss(struct net_dev=
ice *dev,
>  		*pos++ =3D (u8) (rate / 5);
>  	}
> =20
> -	return ieee80211_sta_join_ibss(dev, ifsta, bss);
> +	ret =3D ieee80211_sta_join_ibss(dev, ifsta, bss);
> +	ieee80211_rx_bss_put(dev, bss);
> +	return ret;
>  }
> =20
>=20
> @@ -3615,10 +3616,13 @@ static int ieee80211_sta_find_ibss(struct net_dev=
ice *dev,
>  	    (bss =3D ieee80211_rx_bss_get(dev, bssid,
>  					local->hw.conf.channel->center_freq,
>  					ifsta->ssid, ifsta->ssid_len))) {
> +		int ret;
>  		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
>  		       " based on configured SSID\n",
>  		       dev->name, print_mac(mac, bssid));
> -		return ieee80211_sta_join_ibss(dev, ifsta, bss);
> +		ret =3D ieee80211_sta_join_ibss(dev, ifsta, bss);
> +		ieee80211_rx_bss_put(dev, bss);
> +		return ret;
>  	}
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
>  	printk(KERN_DEBUG "   did not try to join ibss\n");

--=-VQ9LY3Wg04pO27WICLXt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDRBxqVg1VMiehFYAQIPCQ/+I+6suCwgsoYxy8vD6umKipYeoyiq1KTy
WyvHyI1e+NUa4lZDINhnhJCNmFdRkE/e4vNSMj4eQPoKIlmL5iz304Y6g8xAR7fB
+MvJBQDaC9XDSYr5kYD+Bh8JCbs7bBAdFD3VSl8HHFUSX4gc9QPVNbVWPHKE/grj
IHqyEH3VXXeE6YcIAlwLT2jokbQbkSWiuTYhHzG+2ww/B+gjwxQBncbGCqxmESK5
VvCYr3Ot2b3dqqJuqVKTqdv0j6+GWUHdC4j8s0er1+B+PGabQqpScZMsTilkba8H
4oGC1Lvy4m2eUvNgESIAZIWvpbqz8sCpEk3Ay09ygvKfCa2JEL9FPstCcGFd88yp
CY1+xFlZ8+BQQPGsX6P2mugbWmTLP6XX0uKI2jvkvSMYJOIhnHm9vkEs6+Ltm22+
yvK3TSWrJwlhz8nT1PJ058pYJ9Z0vR7ze7+VtX/7kCUlBCUUP0uum5yonlw50HBL
t/40qSJTywqSiM4mRwNHzcc5JlNiXU9pkEje6qfUPOJMDQctdmFogWUhsnA/iFlr
4fwdKDV1vpZRVlKlmyREy3NHMe6pFsXAtCslwe8nc6V4i/xR4euPxsDo62QG1t4E
3Afp1h+kgJl/cny2TMufaoeCC1R8rqDE99R2Yy21QCDM940OvXoPMMRLtLxrMCBR
BWPgSxcjtDQ=
=DR80
-----END PGP SIGNATURE-----

--=-VQ9LY3Wg04pO27WICLXt--

