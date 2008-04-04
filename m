Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbYDDOov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 10:44:51 -0400
Subject: Re: [PATCH] mac80211: notify upper layers after lower
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com>
References: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hlPnpZH2pLiLBbg1x3Ly"
Date: Fri, 04 Apr 2008 16:44:44 +0200
Message-Id: <1207320284.19189.27.camel@johannes.berg> (sfid-20080404_154454_090130_AA66B75D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hlPnpZH2pLiLBbg1x3Ly
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-04-03 at 16:08 -0700, Reinette Chatre wrote:
> When drivers receive change notification they may do work that
> will enable the changes to take effect. For example, if new association
> the device needs to be programmed with this information.
> Give the driver chance to make the changes before notifying the
> upper layer - thus preventing race condition where upper layer
> attempts to utilize state that may not be configured yet.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Looks good to me

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_sta.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index be2ce24..f3c8a21 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -545,13 +545,13 @@ static void ieee80211_set_associated(struct net_dev=
ice *dev,
> =20
>  		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
>  	}
> -	wrqu.ap_addr.sa_family =3D ARPHRD_ETHER;
> -	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
>  	ifsta->last_probe =3D jiffies;
>  	ieee80211_led_assoc(local, assoc);
> =20
>  	sdata->bss_conf.assoc =3D assoc;
>  	ieee80211_bss_info_change_notify(sdata, changed);
> +	wrqu.ap_addr.sa_family =3D ARPHRD_ETHER;
> +	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
>  }
> =20
>  static void ieee80211_set_disassoc(struct net_device *dev,

--=-hlPnpZH2pLiLBbg1x3Ly
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Y+26Vg1VMiehFYAQLMjg/8C/LZEQMJm/vZ4aQcf+aUOd3G3IEY0+ZD
kHCpVTOd9ztySdgNHUHZDJyiOVgxNrVrPIm5AGWYZoBvCvnv6UlyRB+BOmBCsCjD
yP6ZPTX0Ppvo/TVDcNbJWjwoBl1euW0aN4LBd9SfjLh7VjXEfJpq9GkfMd+SO6bT
buU+x1CJL/mhDf/CHlHSjtD3qDqb1ZdduTftBTohJEhp81RdWMZcXPascqST752W
IOkIXPQ2+/1DhR4QTCYiNMk7NxswCmz3lBOFCjy3iEkjB7igjei/go/bhhgI+hwS
D0osVTxKPk8HKRE7xzTHe5ooXjdYDeZ+x+T0Ez0cRFODpLzXCKJ3rqZoQqJ/Ev1i
dMQxIOiM080tCshVmMKJsNM9++gSRw9B5ff05F7WmljW4vF/7f2qUZ1Qb4zWVwOL
1D9JYMauqQOdXM3lY4PdGKmZb4gkQRKeSJNDCc/vMlaWVl9L2xgGB79k9byBr0Tl
t3ocwRAXaZSEhGUlxtodMBr20XEaDaLyNtu8B+tfW0EVPL1nUjFXCNH5tBH7y+DY
n5o3YwF24wUrI4Q4SsPh8n1Xxxhssv06muN+r2mbXrEDPOupxaFWCkVVVeqPCNBb
hEZvP12WGngJSfxjhxqwX/O9zZTuMFcVcWQPKYsnjb7HD70wTjkA3zJWQC2uwh7i
FZ3BuYYhH6M=
=L145
-----END PGP SIGNATURE-----

--=-hlPnpZH2pLiLBbg1x3Ly--

