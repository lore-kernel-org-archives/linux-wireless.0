Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZBMHVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:21:23 -0500
Subject: Re: orinoco: fix broken make allyesconfig due to multiple defs of
	michael_mic
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p8oizU1y+Aj9Jen0FbUd"
Date: Fri, 13 Feb 2009 08:21:20 +0100
Message-Id: <1234509680.1327.30.camel@johannes.local> (sfid-20090213_082126_840714_62058B83)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p8oizU1y+Aj9Jen0FbUd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I don't think the fix is correct:

-       priv->tx_tfm_mic =3D crypto_alloc_hash("michael_mic", 0, 0);
+       priv->tx_tfm_mic =3D crypto_alloc_hash("orinoco_mic", 0, 0);

that'll never find anything. Renaming the function name was a good plan,
but not changing the string here :)

johannes

--=-p8oizU1y+Aj9Jen0FbUd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlR9tAAoJEKVg1VMiehFY1hcP/3qqzUADDxbtCESnTRJd1g2w
AW5sjxUfMcYgKmZhjeauWkQY+twwagkab1m9S1wc7NvHCYJlfqk4wNMlOSgQIza+
kCQqzK6p7w5QuzFie8s/Q/NVigOUrTklS+rjGKzeRoRiwVrjlfVDfmNLG8q0g6Ay
aGwgKld3YeAICD/zB/CUByGduX6UUmv/U67Z/6vmCPOddRYhqpZP1JfTw/u/aM7W
+MPM1hITw/NHwXBIG1mOWkD6/SJOwC0t89lb8XvFpKJ9x9Dra8AFqnl24uaZ3MeE
LClQ1CckWV1F5PJvkHFJjhBfhec0fKWwj79rj2/mN/IrRgTH8vdC8JjBsKw8DzRr
ZCy5Ugx91QiXmIl3z4Fps0N1sU1U3Kix7gwY7I/3vAswD3n8VQw9f5Ztv2cAhVw9
Gr3bNlax6BFcdzXUaN19L9PPoC1DvhlzL4lSD/4JYdR4yUwTtTt7be16yP0L0vs/
3MeUcImm2nTShuSH66G/3PSyXo6cNiRQ/1s70XOAv/eV9OleHdBDq0+Cy97Q11dE
UJdhhLoaGN39bNfYHUcbfMYP+ll1cerm7rRWlMvpXnViy/ViUKG2Bd6AbNg8tswr
yiOh354Qc0bD/+sqllQDWaPcH8nwxuh1LarRnZEx7lhyRQeo/d1fOoEchFK/t7N8
HJt36d84ijPoPq8brjJP
=Ga3l
-----END PGP SIGNATURE-----

--=-p8oizU1y+Aj9Jen0FbUd--

