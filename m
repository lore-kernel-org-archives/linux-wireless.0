Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:55976 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaGBUnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 16:43:37 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so11773034wes.9
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2014 13:43:36 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: add TX gains tables for radio 0x2057 rev 9
Date: Wed,  2 Jul 2014 22:42:46 +0200
Message-Id: <1404333766-19248-2-git-send-email-zajec5@gmail.com> (sfid-20140702_224343_046994_6E9DEB07)
In-Reply-To: <1404333766-19248-1-git-send-email-zajec5@gmail.com>
References: <1404333766-19248-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Tables were extracted from MMIO dumps from the following parts:


[2 GHz]
write32 0xfaafc160 <- 0x00010028
 read32 0xfaafc160 -> 0x00010028
write16 0xfaafc164 <- 0x0001
(...)
phy_write(0x0072) <- 0x68c0
phy_write(0x0074) <- 0x60ff
phy_write(0x0073) <- 0x0031
phy_write(0x0074) <- 0x60e7
phy_write(0x0073) <- 0x002c
phy_write(0x0074) <- 0x60cf
phy_write(0x0073) <- 0x002a
(...)
phy_write(0x0074) <- 0x600f
phy_write(0x0073) <- 0x0715


[5 GHz]
write32 0xfaafc160 <- 0x00010028
 read32 0xfaafc160 -> 0x00010028
write16 0xfaafc164 <- 0x0124
(...)
phy_write(0x0072) <- 0x68c0
phy_write(0x0074) <- 0x7f7f
phy_write(0x0073) <- 0x0053
phy_write(0x0074) <- 0x7f7f
phy_write(0x0073) <- 0x004b
phy_write(0x0074) <- 0x7f7f
phy_write(0x0073) <- 0x0044
(...)
phy_write(0x0074) <- 0x707f
phy_write(0x0073) <- 0x0001
---
 drivers/net/wireless/b43/tables_nphy.c | 78 ++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 3d6dda7..b28dce9 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2622,6 +2622,42 @@ static const u32 b43_ntab_tx_gain_ipa_rev6_2g[] = {
 	0x00f70028, 0x00f70027, 0x00f70026, 0x00f70025,
 };
 
+/* Extracted from MMIO dump of 6.30.223.141 */
+static const u32 b43_ntab_tx_gain_ipa_2057_rev9_2g[] = {
+	0x60ff0031, 0x60e7002c, 0x60cf002a, 0x60c70029,
+	0x60b70029, 0x60a70029, 0x609f002a, 0x6097002b,
+	0x6087002e, 0x60770031, 0x606f0032, 0x60670034,
+	0x60670031, 0x605f0033, 0x605f0031, 0x60570033,
+	0x60570030, 0x6057002d, 0x6057002b, 0x604f002d,
+	0x604f002b, 0x604f0029, 0x604f0026, 0x60470029,
+	0x60470027, 0x603f0029, 0x603f0027, 0x603f0025,
+	0x60370029, 0x60370027, 0x60370024, 0x602f002a,
+	0x602f0028, 0x602f0026, 0x602f0024, 0x6027002a,
+	0x60270028, 0x60270026, 0x60270024, 0x60270022,
+	0x601f002b, 0x601f0029, 0x601f0027, 0x601f0024,
+	0x601f0022, 0x601f0020, 0x601f001f, 0x601f001d,
+	0x60170029, 0x60170027, 0x60170025, 0x60170023,
+	0x60170021, 0x6017001f, 0x6017001d, 0x6017001c,
+	0x6017001a, 0x60170018, 0x60170018, 0x60170016,
+	0x60170015, 0x600f0029, 0x600f0027, 0x600f0025,
+	0x600f0023, 0x600f0021, 0x600f001f, 0x600f001d,
+	0x600f001c, 0x600f001a, 0x600f0019, 0x600f0018,
+	0x600f0016, 0x600f0015, 0x600f0115, 0x600f0215,
+	0x600f0315, 0x600f0415, 0x600f0515, 0x600f0615,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+	0x600f0715, 0x600f0715, 0x600f0715, 0x600f0715,
+};
+
 /* IPA 2 5Hz */
 
 static const u32 b43_ntab_tx_gain_ipa_rev3_5g[] = {
@@ -2659,6 +2695,42 @@ static const u32 b43_ntab_tx_gain_ipa_rev3_5g[] = {
 	0x70f70021, 0x70f70020, 0x70f70020, 0x70f7001f,
 };
 
+/* Extracted from MMIO dump of 6.30.223.141 */
+static const u32 b43_ntab_tx_gain_ipa_2057_rev9_5g[] = {
+	0x7f7f0053, 0x7f7f004b, 0x7f7f0044, 0x7f7f003f,
+	0x7f7f0039, 0x7f7f0035, 0x7f7f0032, 0x7f7f0030,
+	0x7f7f002d, 0x7e7f0030, 0x7e7f002d, 0x7d7f0032,
+	0x7d7f002f, 0x7d7f002c, 0x7c7f0032, 0x7c7f0030,
+	0x7c7f002d, 0x7b7f0030, 0x7b7f002e, 0x7b7f002b,
+	0x7a7f0032, 0x7a7f0030, 0x7a7f002d, 0x7a7f002b,
+	0x797f0030, 0x797f002e, 0x797f002b, 0x797f0029,
+	0x787f0030, 0x787f002d, 0x787f002b, 0x777f0032,
+	0x777f0030, 0x777f002d, 0x777f002b, 0x767f0031,
+	0x767f002f, 0x767f002c, 0x767f002a, 0x757f0031,
+	0x757f002f, 0x757f002c, 0x757f002a, 0x747f0030,
+	0x747f002d, 0x747f002b, 0x737f0032, 0x737f002f,
+	0x737f002c, 0x737f002a, 0x727f0030, 0x727f002d,
+	0x727f002b, 0x727f0029, 0x717f0030, 0x717f002d,
+	0x717f002b, 0x707f0031, 0x707f002f, 0x707f002c,
+	0x707f002a, 0x707f0027, 0x707f0025, 0x707f0023,
+	0x707f0021, 0x707f001f, 0x707f001d, 0x707f001c,
+	0x707f001a, 0x707f0019, 0x707f0017, 0x707f0016,
+	0x707f0015, 0x707f0014, 0x707f0012, 0x707f0012,
+	0x707f0011, 0x707f0010, 0x707f000f, 0x707f000e,
+	0x707f000d, 0x707f000d, 0x707f000c, 0x707f000b,
+	0x707f000a, 0x707f000a, 0x707f0009, 0x707f0008,
+	0x707f0008, 0x707f0008, 0x707f0008, 0x707f0007,
+	0x707f0007, 0x707f0006, 0x707f0006, 0x707f0006,
+	0x707f0005, 0x707f0005, 0x707f0005, 0x707f0004,
+	0x707f0004, 0x707f0004, 0x707f0003, 0x707f0003,
+	0x707f0003, 0x707f0003, 0x707f0003, 0x707f0003,
+	0x707f0003, 0x707f0003, 0x707f0003, 0x707f0003,
+	0x707f0002, 0x707f0002, 0x707f0002, 0x707f0002,
+	0x707f0002, 0x707f0002, 0x707f0002, 0x707f0002,
+	0x707f0002, 0x707f0001, 0x707f0001, 0x707f0001,
+	0x707f0001, 0x707f0001, 0x707f0001, 0x707f0001,
+};
+
 const s8 b43_ntab_papd_pga_gain_delta_ipa_2g[] = {
 	-114, -108, -98, -91, -84, -78, -70, -62,
 	-54, -46, -39, -31, -23, -15, -8, 0
@@ -3405,6 +3477,9 @@ static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		switch (phy->rev) {
+		case 16:
+			if (phy->radio_rev == 9)
+				return b43_ntab_tx_gain_ipa_2057_rev9_2g;
 		case 6:
 			if (dev->dev->chip_id == BCMA_CHIP_ID_BCM47162)
 				return b43_ntab_tx_gain_ipa_rev5_2g;
@@ -3421,6 +3496,9 @@ static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 		}
 	} else {
 		switch (phy->rev) {
+		case 16:
+			if (phy->radio_rev == 9)
+				return b43_ntab_tx_gain_ipa_2057_rev9_5g;
 		case 3 ... 6:
 			return b43_ntab_tx_gain_ipa_rev3_5g;
 		default:
-- 
1.8.4.5

