Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:16760 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab2JCXVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 19:21:15 -0400
Date: Thu, 4 Oct 2012 01:20:41 +0200
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>
Subject: [PATCH] rt2x00/rt3352: Fix lnagain assignment to use register 66.
Message-ID: <20121003232034.GA19388@localhost.arig> (sfid-20121004_012119_333563_21A97D5C)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This should be register 66 instead of 62.
(probably happened by copy&past'ing from the lines below)

Signed-off-by: Daniel Golle <dgolle@allnet.de>

---
 drivers/net/wireless/rt2x00/rt2800lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless=
/rt2x00/rt2800lib.c
index 540c94f..01dc889 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2252,9 +2252,9 @@ static void rt2800_config_channel(struct rt2x00_dev *=
rt2x00dev,
 	 */
 	if (rt2x00_rt(rt2x00dev, RT3352)) {
 		rt2800_bbp_write(rt2x00dev, 27, 0x0);
-		rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 66, 0x26 + rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 27, 0x20);
-		rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 66, 0x26 + rt2x00dev->lna_gain);
 	} else {
 		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
--=20
1.7.12.2


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQbMhCAAoJEDy9cKN/1Et05QgP/jXYoeNac/JhiiY7LHKU4Clm
5weev7GM5AehQquPV1tSWD1tjsRFcE4+DeBtRekcz11s6A4MDa/9KqUnGdtIPj78
4h6/gGP5aVd3shbgop6DTytP+TAFc6SqWdZ97KV9EsnVN4wVcidh7Q2Tk0lTxpMo
KPXMfdVK8LjMAQpMsbvxojOlQwzR6UBP+SizDeqSCqPXruSWwMZyBj63Qp5xcSgG
qWZ0QPhlpNYQWng46ihxabGbyaFlf5fri6R3xDoq4ZGqnjvkP1FcDv9DVXz43jeo
jmbNAcFZuTusmgdtmAE0dl2NBDnjjKaebKws3Pzu012VskcBL/LmXOSx6LUQjkA9
75iTvg6kpcu5EmSksIqXFf4QlD2cbP+q6GgpbKWuBpQbr/12zMwEjUQNeXMFYBH2
Sp0N4eVdeqOj4KkwoS7o/79MT8I4ymccjPD3HI6LgAsEWXd8/xz2YD0RagC7KMql
20HNuTmcKFG3V4yZi6nSyco2ruIZZsFHXw9GQH7o85yow4bpsw63pNzIg9A6bAv1
UesigLvw/m/DMMlgoOE8vlhelXtAEPiCpFuBG4v5HBifGGG6Td/eB3CI11x1uwkp
htZhRTUML5GoKEdOAwWQiLF9GB/N7USgBDgcpEhnd9+rER1DsJet9QCiVTErHYpy
M7T5fvSc78ZnCLL2HbZ3
=zKYU
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
