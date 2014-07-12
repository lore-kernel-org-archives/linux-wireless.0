Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:40421 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaGLKf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 06:35:28 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so2132923wes.40
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 03:35:26 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: add missing TX gain table for radio 0x2057 rev 5
Date: Sat, 12 Jul 2014 12:34:46 +0200
Message-Id: <1405161286-11586-1-git-send-email-zajec5@gmail.com> (sfid-20140712_123533_618348_4C135426)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: this patch has been developed on top of:
[PATCH 7/7] b43: enable radio 0x2057 rev 9 (AKA BCM43228) support
---
 drivers/net/wireless/b43/tables_nphy.c | 58 +++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 3a5cd90..b39a8dd 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2692,6 +2692,42 @@ static const u32 b43_ntab_tx_gain_ipa_rev6_2g[] = {
 	0x00f70028, 0x00f70027, 0x00f70026, 0x00f70025,
 };
 
+/* Copied from brcmsmac (5.75.11): nphy_tpc_txgain_ipa_2g_2057rev5 */
+static const u32 b43_ntab_tx_gain_ipa_2057_rev5_2g[] = {
+	0x30ff0031, 0x30e70031, 0x30e7002e, 0x30cf002e,
+	0x30bf002e, 0x30af002e, 0x309f002f, 0x307f0033,
+	0x307f0031, 0x307f002e, 0x3077002e, 0x306f002e,
+	0x3067002e, 0x305f002f, 0x30570030, 0x3057002d,
+	0x304f002e, 0x30470031, 0x3047002e, 0x3047002c,
+	0x30470029, 0x303f002c, 0x303f0029, 0x3037002d,
+	0x3037002a, 0x30370028, 0x302f002c, 0x302f002a,
+	0x302f0028, 0x302f0026, 0x3027002c, 0x30270029,
+	0x30270027, 0x30270025, 0x30270023, 0x301f002c,
+	0x301f002a, 0x301f0028, 0x301f0025, 0x301f0024,
+	0x301f0022, 0x301f001f, 0x3017002d, 0x3017002b,
+	0x30170028, 0x30170026, 0x30170024, 0x30170022,
+	0x30170020, 0x3017001e, 0x3017001d, 0x3017001b,
+	0x3017001a, 0x30170018, 0x30170017, 0x30170015,
+	0x300f002c, 0x300f0029, 0x300f0027, 0x300f0024,
+	0x300f0022, 0x300f0021, 0x300f001f, 0x300f001d,
+	0x300f001b, 0x300f001a, 0x300f0018, 0x300f0017,
+	0x300f0016, 0x300f0015, 0x300f0115, 0x300f0215,
+	0x300f0315, 0x300f0415, 0x300f0515, 0x300f0615,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+	0x300f0715, 0x300f0715, 0x300f0715, 0x300f0715,
+};
+
 /* Extracted from MMIO dump of 6.30.223.141 */
 static const u32 b43_ntab_tx_gain_ipa_2057_rev9_2g[] = {
 	0x60ff0031, 0x60e7002c, 0x60cf002a, 0x60c70029,
@@ -3550,6 +3586,11 @@ static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 		case 16:
 			if (phy->radio_rev == 9)
 				return b43_ntab_tx_gain_ipa_2057_rev9_2g;
+			break;
+		case 8:
+			if (phy->radio_rev == 5)
+				return b43_ntab_tx_gain_ipa_2057_rev5_2g;
+			break;
 		case 6:
 			if (dev->dev->chip_id == BCMA_CHIP_ID_BCM47162)
 				return b43_ntab_tx_gain_ipa_rev5_2g;
@@ -3559,23 +3600,24 @@ static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 		case 4:
 		case 3:
 			return b43_ntab_tx_gain_ipa_rev3_2g;
-		default:
-			b43err(dev->wl,
-			       "No 2GHz IPA gain table available for this device\n");
-			return NULL;
 		}
+
+		b43err(dev->wl,
+		       "No 2GHz IPA gain table available for this device\n");
+		return NULL;
 	} else {
 		switch (phy->rev) {
 		case 16:
 			if (phy->radio_rev == 9)
 				return b43_ntab_tx_gain_ipa_2057_rev9_5g;
+			break;
 		case 3 ... 6:
 			return b43_ntab_tx_gain_ipa_rev3_5g;
-		default:
-			b43err(dev->wl,
-			       "No 5GHz IPA gain table available for this device\n");
-			return NULL;
 		}
+
+		b43err(dev->wl,
+		       "No 5GHz IPA gain table available for this device\n");
+		return NULL;
 	}
 }
 
-- 
1.8.4.5

