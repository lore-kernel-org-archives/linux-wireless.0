Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZC0Jr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 05:47:59 -0400
Subject: Re: [PATCH] mac80211: add driver ops debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238066858.4331.30.camel@johannes.local> (sfid-20090326_122819_843243_E02404BE)
References: <1238066858.4331.30.camel@johannes.local>
	 (sfid-20090326_122819_843243_E02404BE)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-q5CBFTeCMv3PrlALE5ty"
Date: Fri, 27 Mar 2009 10:47:23 +0100
Message-Id: <1238147243.4331.101.camel@johannes.local> (sfid-20090327_104802_276637_15B04076)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q5CBFTeCMv3PrlALE5ty
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-26 at 12:27 +0100, Johannes Berg wrote:
> This patch adds (optional) debugging for each driver call
> (except tx) that can print out the call, its parameters and
> the return value from the driver. I did this by adding static
> inlines for each driver operation and integrating debugging
> into them, thus all driver calls are now written as
>=20
> 	drv_<op>(local, ...);
>=20
> instead of
>=20
> 	local->ops-><op>(&local->hw, ...);
>=20
> Some of the inlines have also gotten the existence check and
> default return values for the call integrated into them.

This patch dropped some output for the no-conf_tx case that Jouni
explicitly added for that case, I have a new version on my homepage but
am looking into ftrace right now.

johannes

--=-q5CBFTeCMv3PrlALE5ty
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzKCpAAoJEKVg1VMiehFYHj8P/3ua7Z88VxEWMqretO2oqbiS
0N3pvGjlVRX3kTDX+pkXrLuaxOb9AtruJKFCnQd0YYp6bYo95Py4ATuYT55brAs6
KimHHQ9FaAJqsRounauXvpg1mgDIROBocXb4rde3U32CKa3I8Gubho72QbOE9F6K
3a7bpWjO8UouynO6dSN5xbv0i17hQAF7faco2VcohOg+vRGedtXaGsNQgc1nB6Du
vogwFF2n+5TrfmOFVPdYmH1/C29WRAiZ94ub4PKbKHE8p5RLRlulFXvGWDxM7UaJ
+HJYKGlklX3aBexlSVhAbepBRvNEP6bGn6R8TGboC4bk4WrvcJ+htLyUsobj8/XQ
HVAcut+7DPHcDRBhSMUTOLtwGRkOlmeZMkga0bHzZGCyG0/yP0b1ibzr2tUsgFlo
Hu53m3DPkQaNoZUz0eFN/azSg11iz8P5zMLbtUdN++EjnuY3f+BvKnARVieuhNE9
EXhsd2XOWQEOCCKrwX/pG05BELWxaSPJ9ttLDVlkZ4hakd4zzc9YMJvIlJ4wMi6C
gXMK3YMxORknH32xsW5fIKp3/R9KjAMwIqZdIegQAwz2T95K5H0r7E48zFyTbdLm
dfrvOVRiXiRzxKIAyzAMqj7hnb6e2U2g03hjNim5qeUE6GuVUbuwhU+2hiuDp2iF
75bgB/K9ZY3azH81Nj0h
=fjhT
-----END PGP SIGNATURE-----

--=-q5CBFTeCMv3PrlALE5ty--

