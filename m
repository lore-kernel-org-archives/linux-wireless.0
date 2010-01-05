Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55412 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0AET5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 14:57:48 -0500
Received: by ewy19 with SMTP id 19so8837298ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 11:57:46 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------G8HmDKqLbARmxvS7Zyj8cM
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Tue, 05 Jan 2010 20:59:06 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 2/2] b43: N-PHY: update reset_cca operation and add rssi_cal
 calls
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u52sgse59lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------G8HmDKqLbARmxvS7Zyj8cM
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

Update b43_nphy_reset_cca to match current specs and add rssi_cal calls =
to init code.



 From 71c10442cd0b1b277f483a81db7f2e8f579b3d59 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Rafa=3DC5=3D82=3D20Mi=3DC5=3D82ecki?=3D <zajec5@gmail.=
com>
Date: Tue, 5 Jan 2010 20:52:43 +0100
Subject: [PATCH 2/2] b43: N-PHY: update reset_cca operation and add rssi=
_cal calls
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   49 +++++++++++++++++++++++++++---=
-------
  1 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43=
/phy_n.c
index 6479d6e..ceb429a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -343,16 +343,9 @@ static void b43_nphy_workarounds(struct b43_wldev *=
dev)

  static void b43_nphy_reset_cca(struct b43_wldev *dev)
  {
-	u16 bbcfg;
-
-	ssb_write32(dev->dev, SSB_TMSLOW,
-		    ssb_read32(dev->dev, SSB_TMSLOW) | SSB_TMSLOW_FGC);
-	bbcfg =3D b43_phy_read(dev, B43_NPHY_BBCFG);
-	b43_phy_set(dev, B43_NPHY_BBCFG, B43_NPHY_BBCFG_RSTCCA);
-	b43_phy_write(dev, B43_NPHY_BBCFG,
-		      bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
-	ssb_write32(dev->dev, SSB_TMSLOW,
-		    ssb_read32(dev->dev, SSB_TMSLOW) & ~SSB_TMSLOW_FGC);
+	u16 bbcfg =3D b43_phy_read(dev, B43_NPHY_BBCFG);
+	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg | B43_NPHY_BBCFG_RSTCCA);
+	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
  }

  enum b43_nphy_rf_sequence {
@@ -411,8 +404,30 @@ static void b43_nphy_bphy_init(struct b43_wldev *de=
v)
  	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
  }

+static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
+{
+	//TODO
+}
+
+static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
+{
+	//TODO
+}
+
  /* RSSI Calibration */
-static void b43_nphy_rssi_cal(struct b43_wldev *dev, u8 type)
+static void b43_nphy_rssi_cal(struct b43_wldev *dev)
+{
+	if (dev->phy.rev >=3D 3) {
+		b43_nphy_rev3_rssi_cal(dev);
+	} else {
+		b43_nphy_rev2_rssi_cal(dev, 2);
+		b43_nphy_rev2_rssi_cal(dev, 0);
+		b43_nphy_rev2_rssi_cal(dev, 1);
+	}
+}
+
+/* Restore RSSI Calibration */
+static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
  {
  	//TODO
  }
@@ -536,9 +551,17 @@ int b43_phy_initn(struct b43_wldev *dev)

  	do_rssi_cal =3D false;
  	if (phy->rev >=3D 3) {
-		//TODO
+		if (b43_current_band(dev->wl) =3D=3D IEEE80211_BAND_2GHZ)
+			do_rssi_cal =3D (nphy->rssical_chanspec_2G =3D=3D 0);
+		else
+			do_rssi_cal =3D (nphy->rssical_chanspec_5G =3D=3D 0);
+
+		if (do_rssi_cal)
+			b43_nphy_rssi_cal(dev);
+		else
+			b43_nphy_restore_rssi_cal(dev);
  	} else {
-		//TODO
+		b43_nphy_rssi_cal(dev);
  	}

  	if (!((nphy->measure_hold & 0x6) !=3D 0)) {
-- =

1.6.4.2
------------G8HmDKqLbARmxvS7Zyj8cM
Content-Disposition: attachment; filename*0="0002-b43-N-PHY-update-reset_cca-operatio";
 filename*1="n-and-add-rssi_ca.patch"
Content-Type: application/octet-stream; name*0="0002-b43-N-PHY-update-reset_cca-operatio";
 name*1="n-and-add-rssi_ca.patch"
Content-Transfer-Encoding: Base64

RnJvbSA3MWMxMDQ0MmNkMGIxYjI3N2Y0ODNhODFkYjdmMmU4ZjU3OWIzZDU5IE1v
biBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04
Mj0yME1pPUM1PTgyZWNraT89IDx6YWplYzVAZ21haWwuY29tPgpEYXRlOiBUdWUs
IDUgSmFuIDIwMTAgMjA6NTI6NDMgKzAxMDAKU3ViamVjdDogW1BBVENIIDIvMl0g
YjQzOiBOLVBIWTogdXBkYXRlIHJlc2V0X2NjYSBvcGVyYXRpb24gYW5kIGFkZCBy
c3NpX2NhbCBjYWxscwpNSU1FLVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6IHRl
eHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zlci1FbmNvZGlu
ZzogOGJpdAoKU2lnbmVkLW9mZi1ieTogUmFmYcWCIE1pxYJlY2tpIDx6YWplYzVA
Z21haWwuY29tPgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5j
IHwgICA0OSArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tCiAx
IGZpbGVzIGNoYW5nZWQsIDM2IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMKaW5kZXggNjQ3OWQ2
ZS4uY2ViNDI5YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQz
L3BoeV9uLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMK
QEAgLTM0MywxNiArMzQzLDkgQEAgc3RhdGljIHZvaWQgYjQzX25waHlfd29ya2Fy
b3VuZHMoc3RydWN0IGI0M193bGRldiAqZGV2KQogCiBzdGF0aWMgdm9pZCBiNDNf
bnBoeV9yZXNldF9jY2Eoc3RydWN0IGI0M193bGRldiAqZGV2KQogewotCXUxNiBi
YmNmZzsKLQotCXNzYl93cml0ZTMyKGRldi0+ZGV2LCBTU0JfVE1TTE9XLAotCQkg
ICAgc3NiX3JlYWQzMihkZXYtPmRldiwgU1NCX1RNU0xPVykgfCBTU0JfVE1TTE9X
X0ZHQyk7Ci0JYmJjZmcgPSBiNDNfcGh5X3JlYWQoZGV2LCBCNDNfTlBIWV9CQkNG
Ryk7Ci0JYjQzX3BoeV9zZXQoZGV2LCBCNDNfTlBIWV9CQkNGRywgQjQzX05QSFlf
QkJDRkdfUlNUQ0NBKTsKLQliNDNfcGh5X3dyaXRlKGRldiwgQjQzX05QSFlfQkJD
RkcsCi0JCSAgICAgIGJiY2ZnICYgfkI0M19OUEhZX0JCQ0ZHX1JTVENDQSk7Ci0J
c3NiX3dyaXRlMzIoZGV2LT5kZXYsIFNTQl9UTVNMT1csCi0JCSAgICBzc2JfcmVh
ZDMyKGRldi0+ZGV2LCBTU0JfVE1TTE9XKSAmIH5TU0JfVE1TTE9XX0ZHQyk7CisJ
dTE2IGJiY2ZnID0gYjQzX3BoeV9yZWFkKGRldiwgQjQzX05QSFlfQkJDRkcpOwor
CWI0M19waHlfd3JpdGUoZGV2LCBCNDNfTlBIWV9CQkNGRywgYmJjZmcgfCBCNDNf
TlBIWV9CQkNGR19SU1RDQ0EpOworCWI0M19waHlfd3JpdGUoZGV2LCBCNDNfTlBI
WV9CQkNGRywgYmJjZmcgJiB+QjQzX05QSFlfQkJDRkdfUlNUQ0NBKTsKIH0KIAog
ZW51bSBiNDNfbnBoeV9yZl9zZXF1ZW5jZSB7CkBAIC00MTEsOCArNDA0LDMwIEBA
IHN0YXRpYyB2b2lkIGI0M19ucGh5X2JwaHlfaW5pdChzdHJ1Y3QgYjQzX3dsZGV2
ICpkZXYpCiAJYjQzX3BoeV93cml0ZShkZXYsIEI0M19QSFlfTl9CTU9ERSgweDM4
KSwgMHg2NjgpOwogfQogCitzdGF0aWMgdm9pZCBiNDNfbnBoeV9yZXYyX3Jzc2lf
Y2FsKHN0cnVjdCBiNDNfd2xkZXYgKmRldiwgdTggdHlwZSkKK3sKKwkvL1RPRE8K
K30KKworc3RhdGljIHZvaWQgYjQzX25waHlfcmV2M19yc3NpX2NhbChzdHJ1Y3Qg
YjQzX3dsZGV2ICpkZXYpCit7CisJLy9UT0RPCit9CisKIC8qIFJTU0kgQ2FsaWJy
YXRpb24gKi8KLXN0YXRpYyB2b2lkIGI0M19ucGh5X3Jzc2lfY2FsKHN0cnVjdCBi
NDNfd2xkZXYgKmRldiwgdTggdHlwZSkKK3N0YXRpYyB2b2lkIGI0M19ucGh5X3Jz
c2lfY2FsKHN0cnVjdCBiNDNfd2xkZXYgKmRldikKK3sKKwlpZiAoZGV2LT5waHku
cmV2ID49IDMpIHsKKwkJYjQzX25waHlfcmV2M19yc3NpX2NhbChkZXYpOworCX0g
ZWxzZSB7CisJCWI0M19ucGh5X3JldjJfcnNzaV9jYWwoZGV2LCAyKTsKKwkJYjQz
X25waHlfcmV2Ml9yc3NpX2NhbChkZXYsIDApOworCQliNDNfbnBoeV9yZXYyX3Jz
c2lfY2FsKGRldiwgMSk7CisJfQorfQorCisvKiBSZXN0b3JlIFJTU0kgQ2FsaWJy
YXRpb24gKi8KK3N0YXRpYyB2b2lkIGI0M19ucGh5X3Jlc3RvcmVfcnNzaV9jYWwo
c3RydWN0IGI0M193bGRldiAqZGV2KQogewogCS8vVE9ETwogfQpAQCAtNTM2LDkg
KzU1MSwxNyBAQCBpbnQgYjQzX3BoeV9pbml0bihzdHJ1Y3QgYjQzX3dsZGV2ICpk
ZXYpCiAKIAlkb19yc3NpX2NhbCA9IGZhbHNlOwogCWlmIChwaHktPnJldiA+PSAz
KSB7Ci0JCS8vVE9ETworCQlpZiAoYjQzX2N1cnJlbnRfYmFuZChkZXYtPndsKSA9
PSBJRUVFODAyMTFfQkFORF8yR0haKQorCQkJZG9fcnNzaV9jYWwgPSAobnBoeS0+
cnNzaWNhbF9jaGFuc3BlY18yRyA9PSAwKTsKKwkJZWxzZQorCQkJZG9fcnNzaV9j
YWwgPSAobnBoeS0+cnNzaWNhbF9jaGFuc3BlY181RyA9PSAwKTsKKworCQlpZiAo
ZG9fcnNzaV9jYWwpCisJCQliNDNfbnBoeV9yc3NpX2NhbChkZXYpOworCQllbHNl
CisJCQliNDNfbnBoeV9yZXN0b3JlX3Jzc2lfY2FsKGRldik7CiAJfSBlbHNlIHsK
LQkJLy9UT0RPCisJCWI0M19ucGh5X3Jzc2lfY2FsKGRldik7CiAJfQogCiAJaWYg
KCEoKG5waHktPm1lYXN1cmVfaG9sZCAmIDB4NikgIT0gMCkpIHsKLS0gCjEuNi40
LjIKCg==

------------G8HmDKqLbARmxvS7Zyj8cM--

