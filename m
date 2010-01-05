Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:28999 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab0AET5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 14:57:15 -0500
Received: by ey-out-2122.google.com with SMTP id 22so490219eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 11:57:14 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------u9tGwRiojEVRRu0yYG62Um
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Tue, 05 Jan 2010 20:58:33 +0100
Subject: [PATCH 1/2] b43: N-PHY: update TODOs in init part
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u52sfuw79lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------u9tGwRiojEVRRu0yYG62Um
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

Replace TODOs based on old specs with more current ones.



 From 328cf91018178723574031585b447bb849ccddba Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Rafa=3DC5=3D82=3D20Mi=3DC5=3D82ecki?=3D <zajec5@gmail.=
com>
Date: Tue, 5 Jan 2010 20:35:48 +0100
Subject: [PATCH 1/2] b43: N-PHY: update TODOs in init part
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com
---
  drivers/net/wireless/b43/phy_n.c |   71 ++++++++++++++++++++++++------=
-------
  drivers/net/wireless/b43/phy_n.h |   12 ++++++
  2 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43=
/phy_n.c
index 015da44..6479d6e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -425,8 +425,10 @@ int b43_phy_initn(struct b43_wldev *dev)
  	struct ssb_bus *bus =3D dev->dev->bus;
  	struct b43_phy *phy =3D &dev->phy;
  	struct b43_phy_n *nphy =3D phy->n;
+	u8 tx_pwr_state;
  	u16 tmp;
  	enum ieee80211_band tmp2;
+	bool do_rssi_cal;

  	u16 clip[2];
  	bool do_cal =3D false;
@@ -503,35 +505,54 @@ int b43_phy_initn(struct b43_wldev *dev)
  	}

  	b43_nphy_workarounds(dev);
-	b43_nphy_reset_cca(dev);

-	ssb_write32(dev->dev, SSB_TMSLOW,
-		    ssb_read32(dev->dev, SSB_TMSLOW) | B43_TMSLOW_MACPHYCLKEN);
+	//TODO N PHY BMAC Clock FGC with argument 1
+	b43_nphy_reset_cca(dev);
+	//TODO N PHY BMAC Clock FGC with argument 0
+	//TODO N PHY MAC PHY Clock Set with argument 1
+	//TODO Disable PA Override
  	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);
  	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
+	//TODO Turn on PA override
+	//TODO N PHY Classifier with arguments 0 and 0
+	//TODO N PHY Det Clip with 0 and the clip array as arguments
+	tx_pwr_state =3D nphy->txpwrctrl;
+	//TODO N PHY TX power control with argument 0 (turning off power contr=
ol)
+	//TODO Fix the TX Power Settings
+	//TODO N PHY TX Power Control Idle TSSI
+	//TODO N PHY TX Power Control Setup
+
+	if (phy->rev >=3D 3) {
+		//TODO
+	} else {
+		//TODO Write an N PHY table with ID 26, length 128, offset 192, width=
 32, and the data from Rev 2 TX Power Control Table
+		//TODO Write an N PHY table with ID 27, length 128, offset 192, width=
 32, and the data from Rev 2 TX Power Control Table
+	}
+
+	if (nphy->phyrxchain !=3D 3)
+		//TODO N PHY RX Core Set State with phyrxchain as argument
+	if (nphy->mphase_cal_phase_id > 0)
+		//TODO PHY Periodic Calibration Multi-Phase Restart
+
+	do_rssi_cal =3D false;
+	if (phy->rev >=3D 3) {
+		//TODO
+	} else {
+		//TODO
+	}
+
+	if (!((nphy->measure_hold & 0x6) !=3D 0)) {
+		//TODO
+	}

-	b43_phy_read(dev, B43_NPHY_CLASSCTL); /* dummy read */
-	//TODO read core1/2 clip1 thres regs
-
-	if (1 /* FIXME Band is 2.4GHz */)
-		b43_nphy_bphy_init(dev);
-	//TODO disable TX power control
-	//TODO Fix the TX power settings
-	//TODO Init periodic calibration with reason 3
-	b43_nphy_rssi_cal(dev, 2);
-	b43_nphy_rssi_cal(dev, 0);
-	b43_nphy_rssi_cal(dev, 1);
-	//TODO get TX gain
-	//TODO init superswitch
-	//TODO calibrate LO
-	//TODO idle TSSI TX pctl
-	//TODO TX power control power setup
-	//TODO table writes
-	//TODO TX power control coefficients
-	//TODO enable TX power control
-	//TODO control antenna selection
-	//TODO init radar detection
-	//TODO reset channel if changed
+	//TODO N PHY TX Power Control Coef Setup
+	//TODO N PHY TX Power Control Enable with argument tx_pwr_state
+	b43_phy_write(dev, B43_NPHY_TXMACIF_HOLDOFF, 0x0015);
+	b43_phy_write(dev, B43_NPHY_TXMACDELAY, 0x0320);
+	if (phy->rev >=3D 3 && phy->rev <=3D 6)
+		b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x0014);
+	//TODO N PHY TX LP FBW
+	//TODO N PHY Spur Workaround

  	b43err(dev->wl, "IEEE 802.11n devices are not supported, yet.\n");
  	return 0;
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43=
/phy_n.h
index 8f174b7..e5e402a 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -925,7 +925,19 @@
  struct b43_wldev;

  struct b43_phy_n {
+	u8 txpwrctrl;
+	u8 measure_hold;
+	u8 phyrxchain;
+	u8 mphase_cal_phase_id;
  	u32 deaf_count;
+	bool mute;
+
+	u8 iqcal_chanspec_2G;
+	u8 rssical_chanspec_2G;
+
+	u8 iqcal_chanspec_5G;
+	u8 rssical_chanspec_5G;
+
  	bool crsminpwr_adjusted;
  	bool noisevars_adjusted;

-- =

1.6.4.2
------------u9tGwRiojEVRRu0yYG62Um
Content-Disposition: attachment; filename=0001-b43-N-PHY-update-TODOs-in-init-part.patch
Content-Type: application/octet-stream; name=0001-b43-N-PHY-update-TODOs-in-init-part.patch
Content-Transfer-Encoding: Base64

RnJvbSAzMjhjZjkxMDE4MTc4NzIzNTc0MDMxNTg1YjQ0N2JiODQ5Y2NkZGJhIE1v
biBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04
Mj0yME1pPUM1PTgyZWNraT89IDx6YWplYzVAZ21haWwuY29tPgpEYXRlOiBUdWUs
IDUgSmFuIDIwMTAgMjA6MzU6NDggKzAxMDAKU3ViamVjdDogW1BBVENIIDEvMl0g
YjQzOiBOLVBIWTogdXBkYXRlIFRPRE9zIGluIGluaXQgcGFydApNSU1FLVZlcnNp
b246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgK
Q29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKU2lnbmVkLW9mZi1ieTog
UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tCi0tLQogZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMgfCAgIDcxICsrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9w
aHlfbi5oIHwgICAxMiArKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgNTggaW5zZXJ0
aW9ucygrKSwgMjUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9i
NDMvcGh5X24uYwppbmRleCAwMTVkYTQ0Li42NDc5ZDZlIDEwMDY0NAotLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5X24uYworKysgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9iNDMvcGh5X24uYwpAQCAtNDI1LDggKzQyNSwxMCBAQCBpbnQg
YjQzX3BoeV9pbml0bihzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYpCiAJc3RydWN0IHNz
Yl9idXMgKmJ1cyA9IGRldi0+ZGV2LT5idXM7CiAJc3RydWN0IGI0M19waHkgKnBo
eSA9ICZkZXYtPnBoeTsKIAlzdHJ1Y3QgYjQzX3BoeV9uICpucGh5ID0gcGh5LT5u
OworCXU4IHR4X3B3cl9zdGF0ZTsKIAl1MTYgdG1wOwogCWVudW0gaWVlZTgwMjEx
X2JhbmQgdG1wMjsKKwlib29sIGRvX3Jzc2lfY2FsOwogCiAJdTE2IGNsaXBbMl07
CiAJYm9vbCBkb19jYWwgPSBmYWxzZTsKQEAgLTUwMywzNSArNTA1LDU0IEBAIGlu
dCBiNDNfcGh5X2luaXRuKHN0cnVjdCBiNDNfd2xkZXYgKmRldikKIAl9CiAKIAli
NDNfbnBoeV93b3JrYXJvdW5kcyhkZXYpOwotCWI0M19ucGh5X3Jlc2V0X2NjYShk
ZXYpOwogCi0Jc3NiX3dyaXRlMzIoZGV2LT5kZXYsIFNTQl9UTVNMT1csCi0JCSAg
ICBzc2JfcmVhZDMyKGRldi0+ZGV2LCBTU0JfVE1TTE9XKSB8IEI0M19UTVNMT1df
TUFDUEhZQ0xLRU4pOworCS8vVE9ETyBOIFBIWSBCTUFDIENsb2NrIEZHQyB3aXRo
IGFyZ3VtZW50IDEKKwliNDNfbnBoeV9yZXNldF9jY2EoZGV2KTsKKwkvL1RPRE8g
TiBQSFkgQk1BQyBDbG9jayBGR0Mgd2l0aCBhcmd1bWVudCAwIAorCS8vVE9ETyBO
IFBIWSBNQUMgUEhZIENsb2NrIFNldCB3aXRoIGFyZ3VtZW50IDEKKwkvL1RPRE8g
RGlzYWJsZSBQQSBPdmVycmlkZSAKIAliNDNfbnBoeV9mb3JjZV9yZl9zZXF1ZW5j
ZShkZXYsIEI0M19SRlNFUV9SWDJUWCk7CiAJYjQzX25waHlfZm9yY2VfcmZfc2Vx
dWVuY2UoZGV2LCBCNDNfUkZTRVFfUkVTRVQyUlgpOworCS8vVE9ETyBUdXJuIG9u
IFBBIG92ZXJyaWRlCisJLy9UT0RPIE4gUEhZIENsYXNzaWZpZXIgd2l0aCBhcmd1
bWVudHMgMCBhbmQgMCAKKwkvL1RPRE8gTiBQSFkgRGV0IENsaXAgd2l0aCAwIGFu
ZCB0aGUgY2xpcCBhcnJheSBhcyBhcmd1bWVudHMKKwl0eF9wd3Jfc3RhdGUgPSBu
cGh5LT50eHB3cmN0cmw7CisJLy9UT0RPIE4gUEhZIFRYIHBvd2VyIGNvbnRyb2wg
d2l0aCBhcmd1bWVudCAwICh0dXJuaW5nIG9mZiBwb3dlciBjb250cm9sKSAKKwkv
L1RPRE8gRml4IHRoZSBUWCBQb3dlciBTZXR0aW5ncyAKKwkvL1RPRE8gTiBQSFkg
VFggUG93ZXIgQ29udHJvbCBJZGxlIFRTU0kgCisJLy9UT0RPIE4gUEhZIFRYIFBv
d2VyIENvbnRyb2wgU2V0dXAKKworCWlmIChwaHktPnJldiA+PSAzKSB7CisJCS8v
VE9ETworCX0gZWxzZSB7CisJCS8vVE9ETyBXcml0ZSBhbiBOIFBIWSB0YWJsZSB3
aXRoIElEIDI2LCBsZW5ndGggMTI4LCBvZmZzZXQgMTkyLCB3aWR0aCAzMiwgYW5k
IHRoZSBkYXRhIGZyb20gUmV2IDIgVFggUG93ZXIgQ29udHJvbCBUYWJsZSAKKwkJ
Ly9UT0RPIFdyaXRlIGFuIE4gUEhZIHRhYmxlIHdpdGggSUQgMjcsIGxlbmd0aCAx
MjgsIG9mZnNldCAxOTIsIHdpZHRoIDMyLCBhbmQgdGhlIGRhdGEgZnJvbSBSZXYg
MiBUWCBQb3dlciBDb250cm9sIFRhYmxlCisJfQorCisJaWYgKG5waHktPnBoeXJ4
Y2hhaW4gIT0gMykKKwkJLy9UT0RPIE4gUEhZIFJYIENvcmUgU2V0IFN0YXRlIHdp
dGggcGh5cnhjaGFpbiBhcyBhcmd1bWVudAorCWlmIChucGh5LT5tcGhhc2VfY2Fs
X3BoYXNlX2lkID4gMCkKKwkJLy9UT0RPIFBIWSBQZXJpb2RpYyBDYWxpYnJhdGlv
biBNdWx0aS1QaGFzZSBSZXN0YXJ0CisKKwlkb19yc3NpX2NhbCA9IGZhbHNlOwor
CWlmIChwaHktPnJldiA+PSAzKSB7CisJCS8vVE9ETworCX0gZWxzZSB7CisJCS8v
VE9ETworCX0KKworCWlmICghKChucGh5LT5tZWFzdXJlX2hvbGQgJiAweDYpICE9
IDApKSB7CisJCS8vVE9ETworCX0KIAotCWI0M19waHlfcmVhZChkZXYsIEI0M19O
UEhZX0NMQVNTQ1RMKTsgLyogZHVtbXkgcmVhZCAqLwotCS8vVE9ETyByZWFkIGNv
cmUxLzIgY2xpcDEgdGhyZXMgcmVncwotCi0JaWYgKDEgLyogRklYTUUgQmFuZCBp
cyAyLjRHSHogKi8pCi0JCWI0M19ucGh5X2JwaHlfaW5pdChkZXYpOwotCS8vVE9E
TyBkaXNhYmxlIFRYIHBvd2VyIGNvbnRyb2wKLQkvL1RPRE8gRml4IHRoZSBUWCBw
b3dlciBzZXR0aW5ncwotCS8vVE9ETyBJbml0IHBlcmlvZGljIGNhbGlicmF0aW9u
IHdpdGggcmVhc29uIDMKLQliNDNfbnBoeV9yc3NpX2NhbChkZXYsIDIpOwotCWI0
M19ucGh5X3Jzc2lfY2FsKGRldiwgMCk7Ci0JYjQzX25waHlfcnNzaV9jYWwoZGV2
LCAxKTsKLQkvL1RPRE8gZ2V0IFRYIGdhaW4KLQkvL1RPRE8gaW5pdCBzdXBlcnN3
aXRjaAotCS8vVE9ETyBjYWxpYnJhdGUgTE8KLQkvL1RPRE8gaWRsZSBUU1NJIFRY
IHBjdGwKLQkvL1RPRE8gVFggcG93ZXIgY29udHJvbCBwb3dlciBzZXR1cAotCS8v
VE9ETyB0YWJsZSB3cml0ZXMKLQkvL1RPRE8gVFggcG93ZXIgY29udHJvbCBjb2Vm
ZmljaWVudHMKLQkvL1RPRE8gZW5hYmxlIFRYIHBvd2VyIGNvbnRyb2wKLQkvL1RP
RE8gY29udHJvbCBhbnRlbm5hIHNlbGVjdGlvbgotCS8vVE9ETyBpbml0IHJhZGFy
IGRldGVjdGlvbgotCS8vVE9ETyByZXNldCBjaGFubmVsIGlmIGNoYW5nZWQKKwkv
L1RPRE8gTiBQSFkgVFggUG93ZXIgQ29udHJvbCBDb2VmIFNldHVwIAorCS8vVE9E
TyBOIFBIWSBUWCBQb3dlciBDb250cm9sIEVuYWJsZSB3aXRoIGFyZ3VtZW50IHR4
X3B3cl9zdGF0ZSAKKwliNDNfcGh5X3dyaXRlKGRldiwgQjQzX05QSFlfVFhNQUNJ
Rl9IT0xET0ZGLCAweDAwMTUpOworCWI0M19waHlfd3JpdGUoZGV2LCBCNDNfTlBI
WV9UWE1BQ0RFTEFZLCAweDAzMjApOworCWlmIChwaHktPnJldiA+PSAzICYmIHBo
eS0+cmV2IDw9IDYpCisJCWI0M19waHlfd3JpdGUoZGV2LCBCNDNfTlBIWV9QTE9B
RF9DU0VOU0VfRVhUTEVOLCAweDAwMTQpOworCS8vVE9ETyBOIFBIWSBUWCBMUCBG
QlcgCisJLy9UT0RPIE4gUEhZIFNwdXIgV29ya2Fyb3VuZAogCiAJYjQzZXJyKGRl
di0+d2wsICJJRUVFIDgwMi4xMW4gZGV2aWNlcyBhcmUgbm90IHN1cHBvcnRlZCwg
eWV0LlxuIik7CiAJcmV0dXJuIDA7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9iNDMvcGh5X24uaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9w
aHlfbi5oCmluZGV4IDhmMTc0YjcuLmU1ZTQwMmEgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5oCisrKyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2I0My9waHlfbi5oCkBAIC05MjUsNyArOTI1LDE5IEBACiBzdHJ1Y3Qg
YjQzX3dsZGV2OwogCiBzdHJ1Y3QgYjQzX3BoeV9uIHsKKwl1OCB0eHB3cmN0cmw7
CisJdTggbWVhc3VyZV9ob2xkOworCXU4IHBoeXJ4Y2hhaW47CisJdTggbXBoYXNl
X2NhbF9waGFzZV9pZDsKIAl1MzIgZGVhZl9jb3VudDsKKwlib29sIG11dGU7CisK
Kwl1OCBpcWNhbF9jaGFuc3BlY18yRzsKKwl1OCByc3NpY2FsX2NoYW5zcGVjXzJH
OworCisJdTggaXFjYWxfY2hhbnNwZWNfNUc7CisJdTggcnNzaWNhbF9jaGFuc3Bl
Y181RzsKKwogCWJvb2wgY3JzbWlucHdyX2FkanVzdGVkOwogCWJvb2wgbm9pc2V2
YXJzX2FkanVzdGVkOwogCi0tIAoxLjYuNC4yCgo=

------------u9tGwRiojEVRRu0yYG62Um--

