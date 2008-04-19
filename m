Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:50251 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbYDSPts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 11:49:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix all-ones boardflags
Date: Sat, 19 Apr 2008 17:49:03 +0200
Cc: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>,
	Larry.Finger@lwfinger.net, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200804191749.04393.mb@bu3sch.de> (sfid-20080419_164951_882569_C39817A0)
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wRhCIAcr9BWF+mp"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_wRhCIAcr9BWF+mp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom: Larry Finger <Larry.Finger@lwfinger.net>

In the SSB SPROM a field set to all ones means the value
is not defined in the SPROM.
In case of the boardflags, we need to set them to zero
to avoid confusing drivers. Drivers will only check the
flags by ANDing.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

=2D--

John,

This is 2.6.26 material.


diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 904b1a8..57c4ccf 100644
=2D-- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -484,6 +484,11 @@ static int sprom_extract(struct ssb_bus *bus,
struct ssb_sprom *out,
 			goto unsupported;
 	}

+	if (out->boardflags_lo =3D=3D 0xFFFF)
+		out->boardflags_lo =3D 0;  /* per specs */
+	if (out->boardflags_hi =3D=3D 0xFFFF)
+		out->boardflags_hi =3D 0;  /* per specs */
+
 	return 0;
 unsupported:
 	ssb_printk(KERN_WARNING PFX "Unsupported SPROM revision %d "

=2D-=20
Greetings Michael.

--Boundary-00=_wRhCIAcr9BWF+mp
Content-Type: text/x-patch;
  name="ssb-fix-unset-boardflags.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=ssb-fix-unset-boardflags.patch

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3NiL3BjaS5jIGIvZHJpdmVycy9zc2IvcGNpLmMKaW5kZXgg
OTA0YjFhOC4uNTdjNGNjZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zc2IvcGNpLmMKKysrIGIvZHJp
dmVycy9zc2IvcGNpLmMKQEAgLTQ4NCw2ICs0ODQsMTEgQEAgc3RhdGljIGludCBzcHJvbV9leHRy
YWN0KHN0cnVjdCBzc2JfYnVzICpidXMsIHN0cnVjdCBzc2Jfc3Byb20gKm91dCwKIAkJCWdvdG8g
dW5zdXBwb3J0ZWQ7CiAJfQogCisJaWYgKG91dC0+Ym9hcmRmbGFnc19sbyA9PSAweEZGRkYpCisJ
CW91dC0+Ym9hcmRmbGFnc19sbyA9IDA7ICAvKiBwZXIgc3BlY3MgKi8KKwlpZiAob3V0LT5ib2Fy
ZGZsYWdzX2hpID09IDB4RkZGRikKKwkJb3V0LT5ib2FyZGZsYWdzX2hpID0gMDsgIC8qIHBlciBz
cGVjcyAqLworCiAJcmV0dXJuIDA7CiB1bnN1cHBvcnRlZDoKIAlzc2JfcHJpbnRrKEtFUk5fV0FS
TklORyBQRlggIlVuc3VwcG9ydGVkIFNQUk9NIHJldmlzaW9uICVkICIK
--Boundary-00=_wRhCIAcr9BWF+mp--

