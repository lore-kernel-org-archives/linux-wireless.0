Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53691 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaIJHIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 03:08:15 -0400
Received: by mail-wi0-f169.google.com with SMTP id cc10so474832wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2014 00:08:14 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: HT-PHY: Set MAC frequency to correct values
Date: Wed, 10 Sep 2014 09:07:13 +0200
Message-Id: <1410332833-4568-1-git-send-email-zajec5@gmail.com> (sfid-20140910_090819_749599_D6B55AE9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I misunderstood original Broadcom comment and used wrong values.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Comment in original brcm80211 patch was like this:
+ * HTPHY Formula is 2^26/freq(MHz) e.g.
+ * For spuron2 - 126MHz -> 2^26/126 = 532610.0
+ *  - 532610 = 0x82082 => tsf_clk_frac_h = 0x8, tsf_clk_frac_l = 0x2082
+ * For spuron: 123MHz -> 2^26/123    = 545600.5
+ *  - 545601 = 0x85341 => tsf_clk_frac_h = 0x8, tsf_clk_frac_l = 0x5341
+ * For spur off: 120MHz -> 2^26/120    = 559240.5
+ *  - 559241 = 0x88889 => tsf_clk_frac_h = 0x8, tsf_clk_frac_l = 0x8889

But it appears BCM4331 uses 168, 164 and 160 MHz freqs. MMIO dump proof:

[spuravoid == 0]
write32 0xf7c03660 <- 0x00000000
write32 0xf7c03664 <- 0x11100014 ← this means spuravoid 0
write32 0xf7c03660 <- 0x00000002
write32 0xf7c03664 <- 0x03000a08 ← this means spuravoid 0
(...)
write16 0xf7c0062e <- 0x6666	B43_MMIO_TSF_CLK_FRAC_LOW
write16 0xf7c00630 <- 0x0006	B43_MMIO_TSF_CLK_FRAC_HIGH

[spuravoid == 1]
write32 0xf7c03660 <- 0x00000000
write32 0xf7c03664 <- 0x11500014 ← this means spuravoid 1 or 2
write32 0xf7c03660 <- 0x00000002
write32 0xf7c03664 <- 0x0f600a08 ← this means spuravoid 1
 (...)
write16 0xf7c0062e <- 0x3e70	B43_MMIO_TSF_CLK_FRAC_LOW
write16 0xf7c00630 <- 0x0006	B43_MMIO_TSF_CLK_FRAC_HIGH
---
 drivers/net/wireless/b43/main.c   | 17 ++++++++++++++++-
 drivers/net/wireless/b43/phy_ht.c | 16 +---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 66ff718..165dbc3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2985,7 +2985,22 @@ void b43_mac_switch_freq(struct b43_wldev *dev, u8 spurmode)
 {
 	u16 chip_id = dev->dev->chip_id;
 
-	if (chip_id == BCMA_CHIP_ID_BCM43131 ||
+	if (chip_id == BCMA_CHIP_ID_BCM4331) {
+		switch (spurmode) {
+		case 2: /* 168 Mhz: 2^26/168 = 0x61862 */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x1862);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x6);
+			break;
+		case 1: /* 164 Mhz: 2^26/164 = 0x63e70 */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x3e70);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x6);
+			break;
+		default: /* 160 Mhz: 2^26/160 = 0x66666 */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x6666);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x6);
+			break;
+		}
+	} else if (chip_id == BCMA_CHIP_ID_BCM43131 ||
 	    chip_id == BCMA_CHIP_ID_BCM43217 ||
 	    chip_id == BCMA_CHIP_ID_BCM43222 ||
 	    chip_id == BCMA_CHIP_ID_BCM43224 ||
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index de52d48..a379602 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -728,7 +728,6 @@ static void b43_phy_ht_spur_avoid(struct b43_wldev *dev,
 {
 	struct bcma_device *core = dev->dev->bdev;
 	int spuravoid = 0;
-	u16 tmp;
 
 	/* Check for 13 and 14 is just a guess, we don't have enough logs. */
 	if (new_channel->hw_value == 13 || new_channel->hw_value == 14)
@@ -741,20 +740,7 @@ static void b43_phy_ht_spur_avoid(struct b43_wldev *dev,
 			  B43_BCMA_CLKCTLST_80211_PLL_ST |
 			  B43_BCMA_CLKCTLST_PHY_PLL_ST, false);
 
-	/* Values has been taken from wlc_bmac_switch_macfreq comments */
-	switch (spuravoid) {
-	case 2: /* 126MHz */
-		tmp = 0x2082;
-		break;
-	case 1: /* 123MHz */
-		tmp = 0x5341;
-		break;
-	default: /* 120MHz */
-		tmp = 0x8889;
-	}
-
-	b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, tmp);
-	b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
+	b43_mac_switch_freq(dev, spuravoid);
 
 	/* TODO: reset PLL */
 
-- 
1.8.4.5

