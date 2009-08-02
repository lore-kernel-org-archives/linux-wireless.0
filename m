Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZHBIeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 04:34:05 -0400
Subject: Re: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrick Simmons <linuxrocks123@netscape.net>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
In-Reply-To: <4A754D31.7010709@netscape.net>
References: <1249029583.29587.46.camel@johannes.local>
	 <20090731.222350.254918321.davem@davemloft.net>
	 <200908011240.17229.mb@bu3sch.de>
	 <20090801.091207.217317135.davem@davemloft.net>
	 <4A74EEB2.6040400@netscape.net> <1249199441.2007.7.camel@johannes.local>
	 <4A754D31.7010709@netscape.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-77nURVT71mSvzQ971W9S"
Date: Sun, 02 Aug 2009 10:34:00 +0200
Message-Id: <1249202040.2007.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-77nURVT71mSvzQ971W9S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-08-02 at 02:24 -0600, Patrick Simmons wrote:

> It does look wrong, now that I look at it further, but I'm pretty sure=20
> that what was happening was that only the lower 8 bits of the=20
> dereferenced value were being accessed.=20

Yes, you're right, because buffer is a "u8 *", I initially thought that
it didn't take a pointer, but that wouldn't work, of course.

>  What's odd is that it works on=20
> my machine, though.  Whatever.  Your version is clearer, in any case.
>=20
> What follows is hopefully the last version of this patch.

Looks good, but I think you should resubmit with
 * a changed subject (e.g. "zd1211rw: fix unaligned access in zd_mac_rx")
 * a standalone patch description so John doesn't have to pick it out of
   your first patch etc.


Thanks!
johannes

> Signed-off-by: Patrick Simmons <linuxrocks123@netscape.net>
>=20
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -694,7 +694,7 @@
>                         && !mac->pass_ctrl)
>                 return 0;
> =20
> -       fc =3D *(__le16 *)buffer;
> +       fc =3D get_unaligned((__le16*)buffer);
>         need_padding =3D ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc)=
;
> =20
>         skb =3D dev_alloc_skb(length + (need_padding ? 2 : 0));
>=20
> --Patrick
>=20
>=20


--=-77nURVT71mSvzQ971W9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdU90AAoJEODzc/N7+Qmaa78P/2df4R+UN54fxwIMzgzu/1/Y
Tf71Wf+RJxvGWFJIpPn3QMaYBj64mmcJilq868NXF7IZV15A+Ug73eR9MyjRdZIq
06afy7DE6Lq5hXK2feawzEj/dVSE1jMRTP/SN3Al5wCCN+GhrKU7qiv1hddYZSRp
bSWGlCnY9t1CKtkVPJLhgCce8T0l9/pDPUYe+6LAZKMJDHUmE5h0Wc5KMzA4W7e1
OPKSjyBczq4F3uqugjh8etgNeCLxruO2jW3MkdxNuJ7nwqxQfb3K+JS5aMDhXljz
GwawPUvg/dB5NP2TZSivDgGhQcmJk/5YxCD0y+6XMWJ2+y+AOUuryfMyMfaY6z1r
JWUiJIlp1htQfYoY8+FiklD1a06tYj/a9lGHSl8h59Dr8oFI4WWXuikyXcvet8y2
9vTq5WIHDlUuIittlMcwdb1OJHxTe1hUMUySJq/MxB6WHlIVbJix0CNM7qyBdVcW
chBaBrml0n2vHpSnPsWq2IbTDlSGQ+u6Ms8QNPu61QrhN+lr3IcjoBsd6iTptske
cD4I3JjYWdhkTXN9lib8EgGxyU1EepPNyw5uihmE7wNURImitkeFzmPz81t4aJTg
gEO1pX/PVtWNFSIU9tYtCvWJ3WpNL1evO45MrtfO/WIDklCfRxKToyATwKUcHQz2
QKfyXgOMq+qWG0gePkom
=Ik2m
-----END PGP SIGNATURE-----

--=-77nURVT71mSvzQ971W9S--

