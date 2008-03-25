Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbYCYPbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:31:12 -0400
Subject: mac80211 mesh code - not checking mesh config validity?
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eRnnG88n/2XSyTSLoYcy"
Date: Tue, 25 Mar 2008 15:37:54 +0100
Message-Id: <1206455874.16475.283.camel@johannes.berg> (sfid-20080325_153116_319477_F12F4561)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eRnnG88n/2XSyTSLoYcy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just looked at some MLME stuff and noticed that apparently the
mesh-config IE is never checked for having a correct length so if it is
less than 17 bytes long we could even overrun the SKB when memcpy'ing
the data into bss->mesh_cfg.

Maybe a (packed) structure should be used for the bss->mesh_cfg member
so access to it is easier?

Could you take a look and fix this if necessary?

johannes

--=-eRnnG88n/2XSyTSLoYcy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+kOQaVg1VMiehFYAQIuVQ/+Ph/Mx97FnZW1R3I8re+ToswzmVKVJFFX
0OwRmb8FSdeGwpMmMUX3424HE5BNcVKwlxxymYE+5kr4Vxh6sH4AobkJkqkIpsbU
5zKnUMHzEsaDPobAnSghDySUOM93EFYy0PU/owkJHI5ROYfaP3p+IyO+IT8ncQnx
Cg3sG226dLT6dQtRX1P7CzdZnOfaSEl/HoJy0Y7CFb9nsg9/E1Gqh5ETCcFr8g/9
zh40zRIBdcI2YZu91nSiSWj5oVaogHpJ9mIkqrqf8lIqfYhYUF2ybd4celR4B4DP
ktUzpB270xci3nrP83ztc9QIQzMe8AKmN/PwBtj32J8Nuf//pIqRoIjN7ccR0R5M
oTog3ZDduu62BfGdY4/PVaxrz6f6w+guuhAciCTtLDlcv6wOWTM1252nQ4adrilu
jIEaul1XaapGTaj7K2drN7W7kQPiXRsHpjQnfp5Ea33IDAoTWPEs9SzphV/wLn7+
BtzM6VmBnCxnaoOYu1m3fmMsYIjqnZ35ityBUK3wBQZuFPqOTIonrmZ47SDLUnJW
mzs7Van7kb0hcyr3DTThBaNZuCsbmy2LXBue83nEUrLdc5JIvV5soxCeJTMJqY1I
MU7l16ZZlFLOos5u9DeRfqjcy143N/YiT3BlCCj9wydfWMGGHTJH8ak4faun4swS
wf7HKfsZQns=
=J4Ce
-----END PGP SIGNATURE-----

--=-eRnnG88n/2XSyTSLoYcy--

