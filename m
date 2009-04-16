Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbZDPPwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 11:52:32 -0400
Subject: Re: [PATCH] mac80211: Allow scan to be requested in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090416154453.GA7311@jm.kir.nu>
References: <20090416154453.GA7311@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AWliAMEf/aLGnNxiOoSz"
Date: Thu, 16 Apr 2009 17:51:57 +0200
Message-Id: <1239897117.14169.8.camel@johannes.local> (sfid-20090416_175235_332231_9DE1F4A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AWliAMEf/aLGnNxiOoSz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 18:44 +0300, Jouni Malinen wrote:
> We can allow scan requests in AP mode as long as the interface has not
> yet been configured to send out Beacon frames (or if beaconing has
> been disabled prior to the scan request). This makes it easier to scan
> for neighboring BSSes during AP initialization and makes it possible
> to run a scan without setting the interface down, if needed. Without
> this change, the only available option would be to set the interface
> down, move into station mode, and set the interface up, prior to
> requesting the scan.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>=20
> ---
>  net/mac80211/cfg.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> --- uml.orig/net/mac80211/cfg.c	2009-04-16 18:20:19.000000000 +0300
> +++ uml/net/mac80211/cfg.c	2009-04-16 18:33:44.000000000 +0300
> @@ -1167,7 +1167,8 @@ static int ieee80211_scan(struct wiphy *
> =20
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION &&
>  	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
> -	    sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> +	    sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT &&
> +	    (sdata->vif.type !=3D NL80211_IFTYPE_AP || sdata->u.ap.beacon))
>  		return -EOPNOTSUPP;

Should this return a different error code for AP then? Maybe -EBUSY for
AP && beacon? Then again, EBUSY is already returned for "already
scanning". hmm.

johannes

--=-AWliAMEf/aLGnNxiOoSz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ51QbAAoJEKVg1VMiehFYRlgP/164Hc/VCU7sN5215UxgcLTf
NYG1dGeTGrlCk2sEUsCMtjL9PYP2+4N9vd4h2cShI/SFvVN7V+90ZkA1BjAyD3om
b/5Y8GfVsQV6Slu/T3tUx0BlB0aNbkYLbiWWFdMiITD1+h9Ac79HR64Yd0w3Cr6W
j+3L5xsW4SCaAWQwJiRohorgeesjCW/rTEvej+Vnq5cpszfxxE6dJLSR7JB6mt8a
kXS9Ud2hXcQfzO4XJW7BEAVeRjLTYJcXEaz5+wdgYTkSSk9KMo769YxD3jYQnsdn
88joZov6Gzjs83updlcKmFhDUux0VS/TduDIwp8vtLlIDmC+0Y4k422iYzgzZr9b
gwuUZIHeC47e9yyTBAx+5GxGs30I4Qfai6jqeQ0gce2nOUEE9TbQ8tTEffGLo5+6
xJnhKpfm6iBqdnWwkiw4lZPtohQnxl5wyEmiDNyWuzkmwg+MqnZZNWL2clJHZTuo
+5WC8r1Ac+IAyr4bQcNJXdFL2SUuFllg2JS5WNyFIe771sOSoyXqtaJIT9tIrhuD
JtdRpO3TL0t55COZDZ9p9lj6iflLSypsxiI+lT5B8NOelaQyzC5yOJQ40YetURYd
BlCDG1Xdttl7dgJKHsS+G0sg6+PCu/dVFD4/jj2LGDDAayK+XuJBDiE9QgwrLy7u
BJ0bp7xeEiyQP3IrFuy1
=c5PA
-----END PGP SIGNATURE-----

--=-AWliAMEf/aLGnNxiOoSz--

