Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZKSKyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 05:54:39 -0500
Subject: Re: [PATCH 2/3] cfg80211: introduce capability for 4addr mode
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
In-Reply-To: <20091118235737.696300447@sipsolutions.net>
References: <20091118235627.209099206@sipsolutions.net>
	 <20091118235737.696300447@sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UhGRLO+zBmpDX2Z1kiTU"
Date: Thu, 19 Nov 2009 11:54:12 +0100
Message-ID: <1258628052.7094.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UhGRLO+zBmpDX2Z1kiTU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-19 at 00:56 +0100, Johannes Berg wrote:

> -	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN && !sdata->use_4addr =
&&
> -	    ieee80211_has_a4(hdr->frame_control))
> +	if (ieee80211_has_a4(hdr->frame_control) &&
> +	    sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN && !sdata->u.vlan.sta=
)
>  		return -1;
> -	if (sdata->use_4addr && is_multicast_ether_addr(hdr->addr1))
> +
> +	if (is_multicast_ether_addr(hdr->addr1) &&
> +	    ((sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN && !sdata->u.vlan.s=
ta) ||
> +	     (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION && !sdata->u.mgd.us=
e_4addr)))
>  		return -1;

This is wrong, of course. Felix, can you explain what this actually
does?

johannes

--=-UhGRLO+zBmpDX2Z1kiTU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBSPQAAoJEODzc/N7+Qma10YP/jmem79VQlxa/FKsbhdO9r3k
7k2hp86C5vb//HX5atC8EvIVRbQ0/fO70zK9UvkSrmsuwOLrSKCat6F1Iv7ut1FE
S8qo7rj9vDSJVjzPWRlJyIsUoDnTmIq7lcVKSl4g2YtvJZqLeKowA0QRyVm43fkj
S0rC6t2Y1P1gdZUCk1Cywn0HSeIL5SEGONSxMK5my2tKMkcNwhtxIfcvEM5fj1ZY
JRApvQ6XdOrxdESuaIl9y70nTdj/H37BQ5yS5VwGA3lGrksnDpnmDIjjgyXvQi3a
vF0hcwRHUHfpoMrm/J2IsEBcm6vwNc6yZzVcoUtF9Jtrfo3PlgnOoyRlZE4+FDlL
DcfpDGeIz3uc9kGndLTbx0US+Tuuogb1vVa73P3LsdHLOwWhhFE+B/J10IxGPEHc
OhIGnXOWB6K6Tcalb4zEy8m4I/pmru/lKSqhBNuAkwKBWZ4Mkll4Wb2XYgghLBoU
g2pIcQw5eYfn8pd4IiNilAckHU9L06ZK9J565VROASR0Hi8+TD5o4z/XiIY+5DCQ
SRBxvlZwJWk/KtlrmoY78nUMVWywI17Cq3uaZklzscXVuRapRl3RF9A9IEJ4m4cX
JrHR4CGyA416ReALbiB/FfB6TGhtgLGC78DnJEqBCtxdj6jxNZHzuMVQyBcuyM44
7KZKeBc1ubgikl2G97xM
=m00M
-----END PGP SIGNATURE-----

--=-UhGRLO+zBmpDX2Z1kiTU--

