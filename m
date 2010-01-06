Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62106 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab0AFPoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 10:44:01 -0500
Received: by ewy19 with SMTP id 19so9729731ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 07:43:59 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------fbR8zzosiIgwDDnpLVX0TN
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 06 Jan 2010 16:45:20 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 5/5] b43: N-PHY: minor init code work
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u54bduin9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------fbR8zzosiIgwDDnpLVX0TN
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

b43: N-PHY: minor init code work


 From b17c3a6da3eff05d49c97c87d13740c0915a21aa Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Rafa=3DC5=3D82=3D20Mi=3DC5=3D82ecki?=3D <zajec5@gmail.=
com>
Date: Wed, 6 Jan 2010 16:36:56 +0100
Subject: [PATCH 5/5] b43: N-PHY: minor init code work
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   32 ++++++++++++++++++++++++++++++=
+-
  drivers/net/wireless/b43/phy_n.h |    3 +++
  2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43=
/phy_n.c
index 2b99d86..4e3565a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -668,7 +668,37 @@ int b43_phy_initn(struct b43_wldev *dev)
  	}

  	if (!((nphy->measure_hold & 0x6) !=3D 0)) {
-		//TODO
+		if (b43_current_band(dev->wl) =3D=3D IEEE80211_BAND_2GHZ)
+			do_cal =3D (nphy->iqcal_chanspec_2G =3D=3D 0);
+		else
+			do_cal =3D (nphy->iqcal_chanspec_5G =3D=3D 0);
+
+		if (nphy->mute)
+			do_cal =3D false;
+
+		if (do_cal) {
+			struct nphy_txgains target =3D
+				b43_nphy_get_tx_gains(dev);
+
+			if (nphy->antsel_type =3D=3D 2)
+				;//TODO N PHY Superswitch Init with argument 1
+			if (nphy->perical !=3D 2) {
+				b43_nphy_rssi_cal(dev);
+				if (phy->rev >=3D 3) {
+					//FIXME: nphy->cal_orig_pwr_idx[0] =3D nphy->txpwrindex[0].index_i=
nternal;
+					//FIXME: nphy->cal_orig_pwr_idx[1] =3D nphy->txpwrindex[1].index_i=
nternal;
+					//TODO N PHY Pre Calibrate TX Gain
+					target =3D b43_nphy_get_tx_gains(dev);
+				}
+				/* TODO: If the output of N PHY Cal TX Iqlo with target, 1 0 as arg=
uments is 0
+					If the output of N PHY Cal RX Iqlo with target, 2 0 as arguments i=
s 0
+						Call N PHY Save Cal */
+			} else if (nphy->mphase_cal_phase_id =3D=3D 0) {
+				//TODO N PHY Periodic Calibration with argument 3
+			}
+		} else {
+			//TODO N PHY Restore Calibration
+		}
  	}

  	//TODO N PHY TX Power Control Coef Setup
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43=
/phy_n.h
index e63c371..f90e905 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -926,9 +926,12 @@ struct b43_wldev;

  struct b43_phy_n {
  	u8 txpwrctrl;
+	u8 cal_orig_pwr_idx[2];
  	u8 measure_hold;
  	u8 phyrxchain;
+	u8 perical;
  	u8 mphase_cal_phase_id;
+	u8 antsel_type;
  	u32 deaf_count;
  	bool hang_avoid;
  	bool mute;
-- =

1.6.4.2
------------fbR8zzosiIgwDDnpLVX0TN
Content-Disposition: attachment; filename=0005-b43-N-PHY-minor-init-code-work.patch
Content-Type: application/octet-stream; name=0005-b43-N-PHY-minor-init-code-work.patch
Content-Transfer-Encoding: Base64

RnJvbSBiMTdjM2E2ZGEzZWZmMDVkNDljOTdjODdkMTM3NDBjMDkxNWEyMWFhIE1v
biBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04
Mj0yME1pPUM1PTgyZWNraT89IDx6YWplYzVAZ21haWwuY29tPgpEYXRlOiBXZWQs
IDYgSmFuIDIwMTAgMTY6MzY6NTYgKzAxMDAKU3ViamVjdDogW1BBVENIIDUvNV0g
YjQzOiBOLVBIWTogbWlub3IgaW5pdCBjb2RlIHdvcmsKTUlNRS1WZXJzaW9uOiAx
LjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04CkNvbnRl
bnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKClNpZ25lZC1vZmYtYnk6IFJhZmHF
giBNacWCZWNraSA8emFqZWM1QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93
aXJlbGVzcy9iNDMvcGh5X24uYyB8ICAgMzIgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5oIHwg
ICAgMyArKysKIDIgZmlsZXMgY2hhbmdlZCwgMzQgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9i
NDMvcGh5X24uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5jCmlu
ZGV4IDJiOTlkODYuLjRlMzU2NWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2I0My9waHlfbi5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0
My9waHlfbi5jCkBAIC02NjgsNyArNjY4LDM3IEBAIGludCBiNDNfcGh5X2luaXRu
KHN0cnVjdCBiNDNfd2xkZXYgKmRldikKIAl9CiAKIAlpZiAoISgobnBoeS0+bWVh
c3VyZV9ob2xkICYgMHg2KSAhPSAwKSkgewotCQkvL1RPRE8KKwkJaWYgKGI0M19j
dXJyZW50X2JhbmQoZGV2LT53bCkgPT0gSUVFRTgwMjExX0JBTkRfMkdIWikKKwkJ
CWRvX2NhbCA9IChucGh5LT5pcWNhbF9jaGFuc3BlY18yRyA9PSAwKTsKKwkJZWxz
ZQorCQkJZG9fY2FsID0gKG5waHktPmlxY2FsX2NoYW5zcGVjXzVHID09IDApOwor
CisJCWlmIChucGh5LT5tdXRlKQorCQkJZG9fY2FsID0gZmFsc2U7CisKKwkJaWYg
KGRvX2NhbCkgeworCQkJc3RydWN0IG5waHlfdHhnYWlucyB0YXJnZXQgPQorCQkJ
CWI0M19ucGh5X2dldF90eF9nYWlucyhkZXYpOworCisJCQlpZiAobnBoeS0+YW50
c2VsX3R5cGUgPT0gMikKKwkJCQk7Ly9UT0RPIE4gUEhZIFN1cGVyc3dpdGNoIElu
aXQgd2l0aCBhcmd1bWVudCAxIAorCQkJaWYgKG5waHktPnBlcmljYWwgIT0gMikg
eworCQkJCWI0M19ucGh5X3Jzc2lfY2FsKGRldik7CisJCQkJaWYgKHBoeS0+cmV2
ID49IDMpIHsKKwkJCQkJLy9GSVhNRTogbnBoeS0+Y2FsX29yaWdfcHdyX2lkeFsw
XSA9IG5waHktPnR4cHdyaW5kZXhbMF0uaW5kZXhfaW50ZXJuYWw7CisJCQkJCS8v
RklYTUU6IG5waHktPmNhbF9vcmlnX3B3cl9pZHhbMV0gPSBucGh5LT50eHB3cmlu
ZGV4WzFdLmluZGV4X2ludGVybmFsOworCQkJCQkvL1RPRE8gTiBQSFkgUHJlIENh
bGlicmF0ZSBUWCBHYWluCisJCQkJCXRhcmdldCA9IGI0M19ucGh5X2dldF90eF9n
YWlucyhkZXYpOworCQkJCX0KKwkJCQkvKiBUT0RPOiBJZiB0aGUgb3V0cHV0IG9m
IE4gUEhZIENhbCBUWCBJcWxvIHdpdGggdGFyZ2V0LCAxIDAgYXMgYXJndW1lbnRz
IGlzIDAgCisJCQkJCUlmIHRoZSBvdXRwdXQgb2YgTiBQSFkgQ2FsIFJYIElxbG8g
d2l0aCB0YXJnZXQsIDIgMCBhcyBhcmd1bWVudHMgaXMgMCAKKwkJCQkJCUNhbGwg
TiBQSFkgU2F2ZSBDYWwgKi8KKwkJCX0gZWxzZSBpZiAobnBoeS0+bXBoYXNlX2Nh
bF9waGFzZV9pZCA9PSAwKSB7CisJCQkJLy9UT0RPIE4gUEhZIFBlcmlvZGljIENh
bGlicmF0aW9uIHdpdGggYXJndW1lbnQgMyAKKwkJCX0KKwkJfSBlbHNlIHsKKwkJ
CS8vVE9ETyBOIFBIWSBSZXN0b3JlIENhbGlicmF0aW9uCisJCX0KIAl9CiAKIAkv
L1RPRE8gTiBQSFkgVFggUG93ZXIgQ29udHJvbCBDb2VmIFNldHVwIApkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmggYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9iNDMvcGh5X24uaAppbmRleCBlNjNjMzcxLi5mOTBlOTA1
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5X24uaAor
KysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5X24uaApAQCAtOTI2LDkg
KzkyNiwxMiBAQCBzdHJ1Y3QgYjQzX3dsZGV2OwogCiBzdHJ1Y3QgYjQzX3BoeV9u
IHsKIAl1OCB0eHB3cmN0cmw7CisJdTggY2FsX29yaWdfcHdyX2lkeFsyXTsKIAl1
OCBtZWFzdXJlX2hvbGQ7CiAJdTggcGh5cnhjaGFpbjsKKwl1OCBwZXJpY2FsOwog
CXU4IG1waGFzZV9jYWxfcGhhc2VfaWQ7CisJdTggYW50c2VsX3R5cGU7CiAJdTMy
IGRlYWZfY291bnQ7CiAJYm9vbCBoYW5nX2F2b2lkOwogCWJvb2wgbXV0ZTsKLS0g
CjEuNi40LjIKCg==

------------fbR8zzosiIgwDDnpLVX0TN--

