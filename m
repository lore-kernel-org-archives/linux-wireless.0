Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:35848 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0AFPj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 10:39:27 -0500
Received: by ey-out-2122.google.com with SMTP id 4so204805eyf.5
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 07:39:26 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------otmKYxLsQPoPJMRu1io0b4
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 06 Jan 2010 16:40:47 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 2/5] b43: N-PHY: b43_nphy_get_tx_gains
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u54a59c89lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------otmKYxLsQPoPJMRu1io0b4
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

b43: N-PHY: b43_nphy_get_tx_gains


 From 5c96b3de80f7d044c42808e8123ae3f50916d6fc Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Rafa=3DC5=3D82=3D20Mi=3DC5=3D82ecki?=3D <zajec5@gmail.=
com>
Date: Wed, 6 Jan 2010 15:25:14 +0100
Subject: [PATCH 2/5] b43: N-PHY: b43_nphy_get_tx_gains
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   75 ++++++++++++++++++++++++++++++=
++++++++
  drivers/net/wireless/b43/phy_n.h |    1 +
  2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43=
/phy_n.c
index 40d7b73..249caf0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -30,6 +30,8 @@
  #include "tables_nphy.h"


+struct nphy_txgains { u16 txgm[2]; u16 pga[2]; u16 pad[2]; u16 ipa[2]; =
};
+
  void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
  {//TODO
  }
@@ -405,6 +407,79 @@ static void b43_nphy_stay_carrier_search(struct b43=
_wldev *dev, bool enable)
  	}
  }

+static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)=

+{
+	struct b43_phy_n *nphy =3D dev->phy.n;
+
+	u16 curr_gain[2];
+	struct nphy_txgains target;
+	u32 *table =3D NULL;
+
+	if (nphy->txpwrctrl =3D=3D 0) {
+		int i;
+
+		if (nphy->hang_avoid)
+			b43_nphy_stay_carrier_search(dev, true);
+		//TODO: Read an N PHY Table with ID 7, length 2, offset 0x110, width =
16, and curr_gain
+		if (nphy->hang_avoid)
+			b43_nphy_stay_carrier_search(dev, false);
+
+		for (i =3D 0; i < 2; ++i) {
+			if (dev->phy.rev >=3D 3) {
+				target.ipa[i] =3D curr_gain[i] & 0x000F;
+				target.pad[i] =3D (curr_gain[i] & 0x00F0) >> 4;
+				target.pga[i] =3D (curr_gain[i] & 0x0F00) >> 8;
+				target.txgm[i] =3D (curr_gain[i] & 0x7000) >> 12;
+			} else {
+				target.ipa[i] =3D curr_gain[i] & 0x0003;
+				target.pad[i] =3D (curr_gain[i] & 0x000C) >> 2;
+				target.pga[i] =3D (curr_gain[i] & 0x0070) >> 4;
+				target.txgm[i] =3D (curr_gain[i] & 0x0380) >> 7;
+			}
+		}
+	} else {
+		int i;
+		u16 index[2];
+	=

+		for (i =3D 0; i < 2; ++i) {
+			if (dev->phy.rev >=3D 3) {
+				enum ieee80211_band band =3D
+					b43_current_band(dev->wl);
+
+				if ((nphy->ipa2g_on && band =3D=3D IEEE80211_BAND_2GHZ) ||
+				    (nphy->ipa5g_on && band =3D=3D IEEE80211_BAND_5GHZ)) {
+					table =3D NULL; //FIXME: =3D output of N PHY Get IPA GainTbl
+				} else {
+					if (band =3D=3D IEEE80211_BAND_5GHZ) {
+						if (dev->phy.rev =3D=3D 3)
+							table =3D NULL; //FIXME: N PHY TX Power Control - TX Gain Table =
Rev >=3D 3 (5 GHz)
+						else if (dev->phy.rev =3D=3D 4)
+							table =3D NULL; //FIXME: N PHY TX Power Control - TX Gain Table =
Rev 4 (5 GHz)
+						else
+							table =3D NULL; //FIXME: N PHY TX Power Control - TX Gain Table =
Rev 5 (5 GHz)
+					} else {
+						table =3D NULL; //FIXME: N PHY TX Power Control - TX Gain Table R=
ev >=3D 3 (2.4 GHz)
+					}
+				}
+
+				target.ipa[i] =3D (table[index[i]] >> 16) & 0xF;
+				target.pad[i] =3D (table[index[i]] >> 20) & 0xF;
+				target.pga[i] =3D (table[index[i]] >> 24) & 0xF;
+				target.txgm[i] =3D (table[index[i]] >> 28) & 0xF;
+			} else {
+				table =3D NULL; //FIXME: N PHY TX Power Control - TX Gain Table Rev=
 <=3D 2
+
+				target.ipa[i] =3D (table[index[i]] >> 16) & 0x3;
+				target.pad[i] =3D (table[index[i]] >> 18) & 0x3;
+				target.pga[i] =3D (table[index[i]] >> 20) & 0x7;
+				target.txgm[i] =3D (table[index[i]] >> 23) & 0x7;
+			}
+		}
+	}
+
+	return target;
+}
+
  enum b43_nphy_rf_sequence {
  	B43_RFSEQ_RX2TX,
  	B43_RFSEQ_TX2RX,
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43=
/phy_n.h
index 6ab07fc..e63c371 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -930,6 +930,7 @@ struct b43_phy_n {
  	u8 phyrxchain;
  	u8 mphase_cal_phase_id;
  	u32 deaf_count;
+	bool hang_avoid;
  	bool mute;

  	u16 classifier_state;
-- =

1.6.4.2
------------otmKYxLsQPoPJMRu1io0b4
Content-Disposition: attachment; filename=0002-b43-N-PHY-b43_nphy_get_tx_gains.patch
Content-Type: application/octet-stream; name=0002-b43-N-PHY-b43_nphy_get_tx_gains.patch
Content-Transfer-Encoding: Base64

RnJvbSA1Yzk2YjNkZTgwZjdkMDQ0YzQyODA4ZTgxMjNhZTNmNTA5MTZkNmZjIE1v
biBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04
Mj0yME1pPUM1PTgyZWNraT89IDx6YWplYzVAZ21haWwuY29tPgpEYXRlOiBXZWQs
IDYgSmFuIDIwMTAgMTU6MjU6MTQgKzAxMDAKU3ViamVjdDogW1BBVENIIDIvNV0g
YjQzOiBOLVBIWTogYjQzX25waHlfZ2V0X3R4X2dhaW5zCk1JTUUtVmVyc2lvbjog
MS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1VVEYtOApDb250
ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0CgpTaWduZWQtb2ZmLWJ5OiBSYWZh
xYIgTWnFgmVja2kgPHphamVjNUBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9uZXQv
d2lyZWxlc3MvYjQzL3BoeV9uLmMgfCAgIDc1ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrCiBkcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5
X24uaCB8ICAgIDEgKwogMiBmaWxlcyBjaGFuZ2VkLCA3NiBpbnNlcnRpb25zKCsp
LCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2I0My9waHlfbi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9u
LmMKaW5kZXggNDBkN2I3My4uMjQ5Y2FmMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYjQzL3BoeV9uLmMKQEAgLTMwLDYgKzMwLDggQEAKICNpbmNsdWRlICJ0YWJs
ZXNfbnBoeS5oIgogCiAKK3N0cnVjdCBucGh5X3R4Z2FpbnMgeyB1MTYgdHhnbVsy
XTsgdTE2IHBnYVsyXTsgdTE2IHBhZFsyXTsgdTE2IGlwYVsyXTsgfTsKKwogdm9p
ZCBiNDNfbnBoeV9zZXRfcnhhbnRlbm5hKHN0cnVjdCBiNDNfd2xkZXYgKmRldiwg
aW50IGFudGVubmEpCiB7Ly9UT0RPCiB9CkBAIC00MDUsNiArNDA3LDc5IEBAIHN0
YXRpYyB2b2lkIGI0M19ucGh5X3N0YXlfY2Fycmllcl9zZWFyY2goc3RydWN0IGI0
M193bGRldiAqZGV2LCBib29sIGVuYWJsZSkKIAl9CiB9CiAKK3N0YXRpYyBzdHJ1
Y3QgbnBoeV90eGdhaW5zIGI0M19ucGh5X2dldF90eF9nYWlucyhzdHJ1Y3QgYjQz
X3dsZGV2ICpkZXYpCit7CisJc3RydWN0IGI0M19waHlfbiAqbnBoeSA9IGRldi0+
cGh5Lm47CisKKwl1MTYgY3Vycl9nYWluWzJdOworCXN0cnVjdCBucGh5X3R4Z2Fp
bnMgdGFyZ2V0OworCXUzMiAqdGFibGUgPSBOVUxMOworCisJaWYgKG5waHktPnR4
cHdyY3RybCA9PSAwKSB7CisJCWludCBpOworCisJCWlmIChucGh5LT5oYW5nX2F2
b2lkKQorCQkJYjQzX25waHlfc3RheV9jYXJyaWVyX3NlYXJjaChkZXYsIHRydWUp
OworCQkvL1RPRE86IFJlYWQgYW4gTiBQSFkgVGFibGUgd2l0aCBJRCA3LCBsZW5n
dGggMiwgb2Zmc2V0IDB4MTEwLCB3aWR0aCAxNiwgYW5kIGN1cnJfZ2FpbiAKKwkJ
aWYgKG5waHktPmhhbmdfYXZvaWQpCisJCQliNDNfbnBoeV9zdGF5X2NhcnJpZXJf
c2VhcmNoKGRldiwgZmFsc2UpOworCisJCWZvciAoaSA9IDA7IGkgPCAyOyArK2kp
IHsKKwkJCWlmIChkZXYtPnBoeS5yZXYgPj0gMykgeworCQkJCXRhcmdldC5pcGFb
aV0gPSBjdXJyX2dhaW5baV0gJiAweDAwMEY7CisJCQkJdGFyZ2V0LnBhZFtpXSA9
IChjdXJyX2dhaW5baV0gJiAweDAwRjApID4+IDQ7CisJCQkJdGFyZ2V0LnBnYVtp
XSA9IChjdXJyX2dhaW5baV0gJiAweDBGMDApID4+IDg7CisJCQkJdGFyZ2V0LnR4
Z21baV0gPSAoY3Vycl9nYWluW2ldICYgMHg3MDAwKSA+PiAxMjsKKwkJCX0gZWxz
ZSB7CisJCQkJdGFyZ2V0LmlwYVtpXSA9IGN1cnJfZ2FpbltpXSAmIDB4MDAwMzsK
KwkJCQl0YXJnZXQucGFkW2ldID0gKGN1cnJfZ2FpbltpXSAmIDB4MDAwQykgPj4g
MjsKKwkJCQl0YXJnZXQucGdhW2ldID0gKGN1cnJfZ2FpbltpXSAmIDB4MDA3MCkg
Pj4gNDsKKwkJCQl0YXJnZXQudHhnbVtpXSA9IChjdXJyX2dhaW5baV0gJiAweDAz
ODApID4+IDc7CisJCQl9CisJCX0KKwl9IGVsc2UgeworCQlpbnQgaTsKKwkJdTE2
IGluZGV4WzJdOworCQorCQlmb3IgKGkgPSAwOyBpIDwgMjsgKytpKSB7CisJCQlp
ZiAoZGV2LT5waHkucmV2ID49IDMpIHsKKwkJCQllbnVtIGllZWU4MDIxMV9iYW5k
IGJhbmQgPQorCQkJCQliNDNfY3VycmVudF9iYW5kKGRldi0+d2wpOworCisJCQkJ
aWYgKChucGh5LT5pcGEyZ19vbiAmJiBiYW5kID09IElFRUU4MDIxMV9CQU5EXzJH
SFopIHx8CisJCQkJICAgIChucGh5LT5pcGE1Z19vbiAmJiBiYW5kID09IElFRUU4
MDIxMV9CQU5EXzVHSFopKSB7CisJCQkJCXRhYmxlID0gTlVMTDsgLy9GSVhNRTog
PSBvdXRwdXQgb2YgTiBQSFkgR2V0IElQQSBHYWluVGJsIAorCQkJCX0gZWxzZSB7
CisJCQkJCWlmIChiYW5kID09IElFRUU4MDIxMV9CQU5EXzVHSFopIHsKKwkJCQkJ
CWlmIChkZXYtPnBoeS5yZXYgPT0gMykKKwkJCQkJCQl0YWJsZSA9IE5VTEw7IC8v
RklYTUU6IE4gUEhZIFRYIFBvd2VyIENvbnRyb2wgLSBUWCBHYWluIFRhYmxlIFJl
diA+PSAzICg1IEdIeikgCisJCQkJCQllbHNlIGlmIChkZXYtPnBoeS5yZXYgPT0g
NCkKKwkJCQkJCQl0YWJsZSA9IE5VTEw7IC8vRklYTUU6IE4gUEhZIFRYIFBvd2Vy
IENvbnRyb2wgLSBUWCBHYWluIFRhYmxlIFJldiA0ICg1IEdIeikgCisJCQkJCQll
bHNlCisJCQkJCQkJdGFibGUgPSBOVUxMOyAvL0ZJWE1FOiBOIFBIWSBUWCBQb3dl
ciBDb250cm9sIC0gVFggR2FpbiBUYWJsZSBSZXYgNSAoNSBHSHopIAorCQkJCQl9
IGVsc2UgeworCQkJCQkJdGFibGUgPSBOVUxMOyAvL0ZJWE1FOiBOIFBIWSBUWCBQ
b3dlciBDb250cm9sIC0gVFggR2FpbiBUYWJsZSBSZXYgPj0gMyAoMi40IEdIeikK
KwkJCQkJfQorCQkJCX0KKworCQkJCXRhcmdldC5pcGFbaV0gPSAodGFibGVbaW5k
ZXhbaV1dID4+IDE2KSAmIDB4RjsKKwkJCQl0YXJnZXQucGFkW2ldID0gKHRhYmxl
W2luZGV4W2ldXSA+PiAyMCkgJiAweEY7CisJCQkJdGFyZ2V0LnBnYVtpXSA9ICh0
YWJsZVtpbmRleFtpXV0gPj4gMjQpICYgMHhGOworCQkJCXRhcmdldC50eGdtW2ld
ID0gKHRhYmxlW2luZGV4W2ldXSA+PiAyOCkgJiAweEY7CisJCQl9IGVsc2Ugewor
CQkJCXRhYmxlID0gTlVMTDsgLy9GSVhNRTogTiBQSFkgVFggUG93ZXIgQ29udHJv
bCAtIFRYIEdhaW4gVGFibGUgUmV2IDw9IDIgCisKKwkJCQl0YXJnZXQuaXBhW2ld
ID0gKHRhYmxlW2luZGV4W2ldXSA+PiAxNikgJiAweDM7CisJCQkJdGFyZ2V0LnBh
ZFtpXSA9ICh0YWJsZVtpbmRleFtpXV0gPj4gMTgpICYgMHgzOworCQkJCXRhcmdl
dC5wZ2FbaV0gPSAodGFibGVbaW5kZXhbaV1dID4+IDIwKSAmIDB4NzsKKwkJCQl0
YXJnZXQudHhnbVtpXSA9ICh0YWJsZVtpbmRleFtpXV0gPj4gMjMpICYgMHg3Owor
CQkJfQorCQl9CisJfQorCisJcmV0dXJuIHRhcmdldDsKK30KKwogZW51bSBiNDNf
bnBoeV9yZl9zZXF1ZW5jZSB7CiAJQjQzX1JGU0VRX1JYMlRYLAogCUI0M19SRlNF
UV9UWDJSWCwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9w
aHlfbi5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmgKaW5kZXgg
NmFiMDdmYy4uZTYzYzM3MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYjQzL3BoeV9uLmgKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3Bo
eV9uLmgKQEAgLTkzMCw2ICs5MzAsNyBAQCBzdHJ1Y3QgYjQzX3BoeV9uIHsKIAl1
OCBwaHlyeGNoYWluOwogCXU4IG1waGFzZV9jYWxfcGhhc2VfaWQ7CiAJdTMyIGRl
YWZfY291bnQ7CisJYm9vbCBoYW5nX2F2b2lkOwogCWJvb2wgbXV0ZTsKIAogCXUx
NiBjbGFzc2lmaWVyX3N0YXRlOwotLSAKMS42LjQuMgoK

------------otmKYxLsQPoPJMRu1io0b4--

