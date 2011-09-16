Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1IPKbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 06:31:12 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so1527867fxe.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 03:31:12 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/6] b43: LCN-PHY: set TX filters
Date: Fri, 16 Sep 2011 12:34:00 +0200
Message-Id: <1316169243-8808-3-git-send-email-zajec5@gmail.com> (sfid-20110916_123120_625775_A9F61143)
In-Reply-To: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
References: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |  107 +++++++++++++++++++++++++++++++++++-
 1 files changed, 106 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 06d8efc..7650364 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -37,6 +37,11 @@
 #include "tables_phy_lcn.h"
 #include "main.h"
 
+struct lcn_tx_iir_filter {
+	u8 type;
+	u16 values[16];
+};
+
 /**************************************************
  * Radio 2064.
  **************************************************/
@@ -282,6 +287,86 @@ static void b43_phy_lcn_sense_setup(struct b43_wldev *dev)
 	b43_radio_write(dev, 0x4a4, save_radio_4a4);
 }
 
+static bool b43_phy_lcn_load_tx_iir_cck_filter(struct b43_wldev *dev,
+					       u8 filter_type)
+{
+	int i, j;
+	u16 phy_regs[] = { 0x910, 0x91e, 0x91f, 0x924, 0x925, 0x926, 0x920,
+			   0x921, 0x927, 0x928, 0x929, 0x922, 0x923, 0x930,
+			   0x931, 0x932 };
+	/* Table is from brcmsmac, values for type 25 were outdated, probably
+	 * others need updating too */
+	struct lcn_tx_iir_filter tx_iir_filters_cck[] = {
+		{ 0,  { 1, 415, 1874, 64, 128, 64, 792, 1656, 64, 128, 64, 778,
+			1582, 64, 128, 64 } },
+		{ 1,  { 1, 402, 1847, 259, 59, 259, 671, 1794, 68, 54, 68, 608,
+			1863, 93, 167, 93 } },
+		{ 2,  { 1, 415, 1874, 64, 128, 64, 792, 1656, 192, 384, 192,
+			778, 1582, 64, 128, 64 } },
+		{ 3,  { 1, 302, 1841, 129, 258, 129, 658, 1720, 205, 410, 205,
+			754, 1760, 170, 340, 170 } },
+		{ 20, { 1, 360, 1884, 242, 1734, 242, 752, 1720, 205, 1845, 205,
+			767, 1760, 256, 185, 256 } },
+		{ 21, { 1, 360, 1884, 149, 1874, 149, 752, 1720, 205, 1883, 205,
+			767, 1760, 256, 273, 256 } },
+		{ 22, { 1, 360, 1884, 98, 1948, 98, 752, 1720, 205, 1924, 205,
+			767, 1760, 256, 352, 256 } },
+		{ 23, { 1, 350, 1884, 116, 1966, 116, 752, 1720, 205, 2008, 205,
+			767, 1760, 128, 233, 128 } },
+		{ 24, { 1, 325, 1884, 32, 40, 32, 756, 1720, 256, 471, 256, 766,
+			1760, 256, 1881, 256 } },
+		{ 25, { 1, 299, 1884, 51, 64, 51, 736, 1720, 256, 471, 256, 765,
+			1760, 262, 1878, 262 } },
+		/* brcmsmac version { 25, { 1, 299, 1884, 51, 64, 51, 736, 1720,
+		 * 256, 471, 256, 765, 1760, 256, 1881, 256 } }, */
+		{ 26, { 1, 277, 1943, 39, 117, 88, 637, 1838, 64, 192, 144, 614,
+			1864, 128, 384, 288 } },
+		{ 27, { 1, 245, 1943, 49, 147, 110, 626, 1838, 256, 768, 576,
+			613, 1864, 128, 384, 288 } },
+		{ 30, { 1, 302, 1841, 61, 122, 61, 658, 1720, 205, 410, 205,
+			754, 1760, 170, 340, 170 } },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(tx_iir_filters_cck); i++) {
+		if (tx_iir_filters_cck[i].type == filter_type) {
+			for (j = 0; j < 16; j++)
+				b43_phy_write(dev, phy_regs[j],
+					      tx_iir_filters_cck[i].values[j]);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool b43_phy_lcn_load_tx_iir_ofdm_filter(struct b43_wldev *dev,
+						u8 filter_type)
+{
+	int i, j;
+	u16 phy_regs[] = { 0x90f, 0x900, 0x901, 0x906, 0x907, 0x908, 0x902,
+			   0x903, 0x909, 0x90a, 0x90b, 0x904, 0x905, 0x90c,
+			   0x90d, 0x90e };
+	struct lcn_tx_iir_filter tx_iir_filters_ofdm[] = {
+		{ 0, { 0, 0xa2, 0x0, 0x100, 0x100, 0x0, 0x0, 0x0, 0x100, 0x0,
+		       0x0, 0x278, 0xfea0, 0x80, 0x100, 0x80 } },
+		{ 1, { 0, 374, 0xFF79, 16, 32, 16, 799, 0xFE74, 50, 32, 50, 750,
+		       0xFE2B, 212, 0xFFCE, 212 } },
+		{ 2, { 0, 375, 0xFF16, 37, 76, 37, 799, 0xFE74, 32, 20, 32, 748,
+		       0xFEF2, 128, 0xFFE2, 128 } },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(tx_iir_filters_ofdm); i++) {
+		if (tx_iir_filters_ofdm[i].type == filter_type) {
+			for (j = 0; j < 16; j++)
+				b43_phy_write(dev, phy_regs[j],
+					      tx_iir_filters_ofdm[i].values[j]);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**************************************************
  * Channel switching ops.
  **************************************************/
@@ -329,6 +414,12 @@ static int b43_phy_lcn_set_channel(struct b43_wldev *dev,
 				   struct ieee80211_channel *channel,
 				   enum nl80211_channel_type channel_type)
 {
+	static const u16 sfo_cfg[14][2] = {
+		{965, 1087}, {967, 1085}, {969, 1082}, {971, 1080}, {973, 1078},
+		{975, 1076}, {977, 1073}, {979, 1071}, {981, 1069}, {983, 1067},
+		{985, 1065}, {987, 1063}, {989, 1060}, {994, 1055},
+	};
+
 	b43_phy_lcn_set_channel_tweaks(dev, channel->hw_value);
 
 	b43_phy_set(dev, 0x44a, 0x44);
@@ -339,7 +430,21 @@ static int b43_phy_lcn_set_channel(struct b43_wldev *dev,
 
 	b43_phy_lcn_afe_set_unset(dev);
 
-	/* TODO */
+	b43_phy_write(dev, 0x657, sfo_cfg[channel->hw_value - 1][0]);
+	b43_phy_write(dev, 0x658, sfo_cfg[channel->hw_value - 1][1]);
+
+	if (channel->hw_value == 14) {
+		b43_phy_maskset(dev, 0x448, ~(0x3 << 8), (2) << 8);
+		b43_phy_lcn_load_tx_iir_cck_filter(dev, 3);
+	} else {
+		b43_phy_maskset(dev, 0x448, ~(0x3 << 8), (1) << 8);
+		/* brcmsmac uses filter_type 2, we follow wl with 25 */
+		b43_phy_lcn_load_tx_iir_cck_filter(dev, 25);
+	}
+	/* brcmsmac uses filter_type 2, we follow wl with 0 */
+	b43_phy_lcn_load_tx_iir_ofdm_filter(dev, 0);
+
+	b43_phy_maskset(dev, 0x4eb, ~(0x7 << 3), 0x1 << 3);
 
 	return 0;
 }
-- 
1.7.3.4

