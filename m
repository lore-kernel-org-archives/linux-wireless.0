Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843AbZHDRhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 13:37:19 -0400
Subject: Re: mac80211 TX frame alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200908041905.11632.IvDoorn@gmail.com>
References: <200908041905.11632.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OrK0kGazuIFBSYNIUE21"
Date: Tue, 04 Aug 2009 19:37:16 +0200
Message-Id: <1249407436.24787.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OrK0kGazuIFBSYNIUE21
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

> Do you know if for outgoing frames the header should always
> be 4-byte aligned?

I know that there's no alignment guarantee.

> I have a bugreport from users claiming that master mode
> is failing for rt2500pci because the beacons passed to the
> driver are not 4-byte aligned which causes the device not
> to send out the beacons correctly.
>=20
> I'm just wondering if this is something that should be fixed
> in the driver or in mac80211.

I don't think we can fix that in mac80211, since we don't know whether
or not any alignment is required. We could align beacon frames, I
suppose, since those are created on the fly, but not data frames.

johannes

--=-OrK0kGazuIFBSYNIUE21
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeHHGAAoJEODzc/N7+Qma9dMP/1/EAsQ0tanuV3rg1qRoKXv0
+kGBOcTQjuHyyi2lUqv0CrlcuBAR5CHPDyyIT3dFag9ci+OLU2YW1n5IzmAUrFR7
cjzJ3j2+d4M+MjhTn354FN/PcLk9uUGIGzKFWWjF9MYLSClsLyaFssBXzmWRKQtD
5zqisoxERBr0Z2SOAic6OqD2W0OtIL6gIq8UvGQRjQDiMxkTFc1EOOE9HO/IDLt5
G7U9kBMWbvy/dLnmB8FqC4Gx++hWzLiHCaGvh7CtFoqjUSkcuNHycG4WFAos+zcG
730YT4iGQqN2tcrB6TMVuxsTXNYpM91KSsfjPA87nN5z0ECqaxpoSkHMY2tP88pZ
nfEJMTjGlZz1XONIPIrAexg+Rue7Q+Rnmmn46orGKuXhPF5/ywJkrG46e+1qZoPB
ysFoINQeuiCfTkBCjiJVC3y0434nu7Kt0wJIO7titn6oxDjA10Qdvex+TgY49Y7l
0fZ8kX+1woaAa/wsNAtBwmi1AUMOu4FliOBtobLjdN3Y0ltY5CU7rCEp9woXv/mH
qOTYGGey8W3EHsZDTfBL8+kbppyGEhr66WozvZO6SFovngrBtisYzihLwdjUWx6I
PVPHTJN5Y0xvCRu+ePnwtr1DLO+MkDwKnR0A10SVLd2k+QdEbI7cihND8YyUWWWz
2aklv2j21ofUf15uMOhE
=Ydhe
-----END PGP SIGNATURE-----

--=-OrK0kGazuIFBSYNIUE21--

