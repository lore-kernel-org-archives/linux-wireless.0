Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYCIUY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 16:24:26 -0400
Subject: Re: [PATCH 1/2] tkip: remove unused function, other cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204946240.23455.19.camel@brick> (sfid-20080308_031744_226744_CE5F76EA)
References: <1204946240.23455.19.camel@brick>
	 (sfid-20080308_031744_226744_CE5F76EA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E8xIn94PseLRfFj8+7ql"
Date: Sat, 08 Mar 2008 07:52:36 +0100
Message-Id: <1204959156.6387.34.camel@johannes.berg> (sfid-20080309_202429_960874_0569C2A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E8xIn94PseLRfFj8+7ql
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -static inline u16 tkip_S(u16 val)
> +static u16 tkip_S(u16 val)
>  {
> -	u16 a =3D tkip_sbox[Hi8(val)];
> -
> -	return tkip_sbox[Lo8(val)] ^ Hi8(a) ^ (Lo8(a) << 8);
> +	return tkip_sbox[val & 0xff] ^ __swab16(tkip_sbox[val >> 8]);

What's wrong with using the non-underscored versions? This is pure
kernel code...

johannes

--=-E8xIn94PseLRfFj8+7ql
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9I3s6Vg1VMiehFYAQJemhAApdd1qSkLZXcjrbMpB6B9xt1cBVl/cP/B
znzZmckUnDaytHmLyp1CGFqt7VZw8l0DFgzs9ijQ3q44EcYuz5Y/c7Bh1f/pnay6
R4xGOrKpD1m/opVZ8yQghNPFr7nD5R8gUgHZJhqAP75yOGV0F+VwjE0boanxEvyM
OUFu1JINW8QVsgJXgstbxfxnunQweO4htF88nC3OxrEGE9xJ2ob04++TexrcoPnD
M9xmfSaSdUyxiUBLWIwN/YqSD1E8D5U2xaNAR6H+r2Evx1yNXxu/KbPyjiQnKrti
CP8XG0jl5Vv2M2NivNG4aVY8kPBCn824ReoyD2xsXx/dS3dt4GLcj05Ou3Gr8iQG
4dWoIOyxw/rppnaK8+vj0s2jDJjtKkAbqYNaXyUD09ASE+1kQ6703SMgL70lmtMM
forXfP4GXqUPKNS413wMSYVXDPkU9vkBaJBh5f9NjrXYvb7tC7ecGje3dQTdW1NM
bwN8EKEHLFjkLXwA1d3W6Do2PdDLXSQcSXpMEQ8l/jfhup5tGj3q03HAMf5SvtOZ
kYC8WLjHwWEw+hj2HE1vpl22C3ca/rnTd39WSR1Z5hNR5aB1wM2JcJFjsUdXFSjK
Jh+xZZlhAlDzhuPIxlJwOttNN4abkyhMjEfimVokSU9tkWemPNvWmyJMjyOfq2Xu
5OfuAxoF8zk=
=ZFIC
-----END PGP SIGNATURE-----

--=-E8xIn94PseLRfFj8+7ql--

