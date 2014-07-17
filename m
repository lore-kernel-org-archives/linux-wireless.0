Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:50401 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaGQRcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 13:32:54 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so3469702wes.28
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 10:32:51 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/6] b43: N-PHY: complete 0x2057 radio init calibration
Date: Thu, 17 Jul 2014 19:31:03 +0200
Message-Id: <1405618266-20200-3-git-send-email-zajec5@gmail.com> (sfid-20140717_193309_172368_13EE8F0C)
In-Reply-To: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
References: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 86 +++++++++++++++++++++++++++++++++++-----
 drivers/net/wireless/b43/phy_n.h |  2 +
 2 files changed, 79 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3da02ff..2c55832 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -820,13 +820,62 @@ static void b43_radio_2057_setup(struct b43_wldev *dev,
 static u8 b43_radio_2057_rcal(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
+	u16 saved_regs_phy[12];
+	u16 saved_regs_phy_rf[6];
+	u16 saved_regs_radio[2] = { };
+	static const u16 phy_to_store[] = {
+		B43_NPHY_RFCTL_RSSIO1, B43_NPHY_RFCTL_RSSIO2,
+		B43_NPHY_RFCTL_LUT_TRSW_LO1, B43_NPHY_RFCTL_LUT_TRSW_LO2,
+		B43_NPHY_RFCTL_RXG1, B43_NPHY_RFCTL_RXG2,
+		B43_NPHY_RFCTL_TXG1, B43_NPHY_RFCTL_TXG2,
+		B43_NPHY_REV7_RF_CTL_MISC_REG3, B43_NPHY_REV7_RF_CTL_MISC_REG4,
+		B43_NPHY_REV7_RF_CTL_MISC_REG5, B43_NPHY_REV7_RF_CTL_MISC_REG6,
+	};
+	static const u16 phy_to_store_rf[] = {
+		B43_NPHY_REV3_RFCTL_OVER0, B43_NPHY_REV3_RFCTL_OVER1,
+		B43_NPHY_REV7_RF_CTL_OVER3, B43_NPHY_REV7_RF_CTL_OVER4,
+		B43_NPHY_REV7_RF_CTL_OVER5, B43_NPHY_REV7_RF_CTL_OVER6,
+	};
 	u16 tmp;
+	int i;
 
-	if (phy->radio_rev == 5) {
-		b43_phy_mask(dev, 0x342, ~0x2);
+	/* Save */
+	for (i = 0; i < ARRAY_SIZE(phy_to_store); i++)
+		saved_regs_phy[i] = b43_phy_read(dev, phy_to_store[i]);
+	for (i = 0; i < ARRAY_SIZE(phy_to_store_rf); i++)
+		saved_regs_phy_rf[i] = b43_phy_read(dev, phy_to_store_rf[i]);
+
+	/* Set */
+	for (i = 0; i < ARRAY_SIZE(phy_to_store); i++)
+		b43_phy_write(dev, phy_to_store[i], 0);
+	b43_phy_write(dev, B43_NPHY_REV3_RFCTL_OVER0, 0x07ff);
+	b43_phy_write(dev, B43_NPHY_REV3_RFCTL_OVER1, 0x07ff);
+	b43_phy_write(dev, B43_NPHY_REV7_RF_CTL_OVER3, 0x07ff);
+	b43_phy_write(dev, B43_NPHY_REV7_RF_CTL_OVER4, 0x07ff);
+	b43_phy_write(dev, B43_NPHY_REV7_RF_CTL_OVER5, 0x007f);
+	b43_phy_write(dev, B43_NPHY_REV7_RF_CTL_OVER6, 0x007f);
+
+	switch (phy->radio_rev) {
+	case 5:
+		b43_phy_mask(dev, B43_NPHY_REV7_RF_CTL_OVER3, ~0x2);
 		udelay(10);
 		b43_radio_set(dev, R2057_IQTEST_SEL_PU, 0x1);
-		b43_radio_maskset(dev, 0x1ca, ~0x2, 0x1);
+		b43_radio_maskset(dev, R2057v7_IQTEST_SEL_PU2, ~0x2, 0x1);
+		break;
+	case 9:
+		b43_phy_set(dev, B43_NPHY_REV7_RF_CTL_OVER3, 0x2);
+		b43_phy_set(dev, B43_NPHY_REV7_RF_CTL_MISC_REG3, 0x2);
+		saved_regs_radio[0] = b43_radio_read(dev, R2057_IQTEST_SEL_PU);
+		b43_radio_write(dev, R2057_IQTEST_SEL_PU, 0x11);
+		break;
+	case 14:
+		saved_regs_radio[0] = b43_radio_read(dev, R2057_IQTEST_SEL_PU);
+		saved_regs_radio[1] = b43_radio_read(dev, R2057v7_IQTEST_SEL_PU2);
+		b43_phy_set(dev, B43_NPHY_REV7_RF_CTL_MISC_REG3, 0x2);
+		b43_phy_set(dev, B43_NPHY_REV7_RF_CTL_OVER3, 0x2);
+		b43_radio_write(dev, R2057v7_IQTEST_SEL_PU2, 0x2);
+		b43_radio_write(dev, R2057_IQTEST_SEL_PU, 0x1);
+		break;
 	}
 
 	/* Enable */
@@ -850,14 +899,30 @@ static u8 b43_radio_2057_rcal(struct b43_wldev *dev)
 	/* Disable */
 	b43_radio_mask(dev, R2057_RCAL_CONFIG, ~0x1);
 
-	if (phy->radio_rev == 5) {
-		b43_radio_mask(dev, R2057_IPA2G_CASCONV_CORE0, ~0x1);
-		b43_radio_mask(dev, 0x1ca, ~0x2);
-	}
-	if (phy->radio_rev <= 4 || phy->radio_rev == 6) {
+	/* Restore */
+	for (i = 0; i < ARRAY_SIZE(phy_to_store_rf); i++)
+		b43_phy_write(dev, phy_to_store_rf[i], saved_regs_phy_rf[i]);
+	for (i = 0; i < ARRAY_SIZE(phy_to_store); i++)
+		b43_phy_write(dev, phy_to_store[i], saved_regs_phy[i]);
+
+	switch (phy->radio_rev) {
+	case 0 ... 4:
+	case 6:
 		b43_radio_maskset(dev, R2057_TEMPSENSE_CONFIG, ~0x3C, tmp);
 		b43_radio_maskset(dev, R2057_BANDGAP_RCAL_TRIM, ~0xF0,
 				  tmp << 2);
+		break;
+	case 5:
+		b43_radio_mask(dev, R2057_IPA2G_CASCONV_CORE0, ~0x1);
+		b43_radio_mask(dev, R2057v7_IQTEST_SEL_PU2, ~0x2);
+		break;
+	case 9:
+		b43_radio_write(dev, R2057_IQTEST_SEL_PU, saved_regs_radio[0]);
+		break;
+	case 14:
+		b43_radio_write(dev, R2057_IQTEST_SEL_PU, saved_regs_radio[0]);
+		b43_radio_write(dev, R2057v7_IQTEST_SEL_PU2, saved_regs_radio[1]);
+		break;
 	}
 
 	return tmp & 0x3e;
@@ -879,7 +944,7 @@ static u16 b43_radio_2057_rccal(struct b43_wldev *dev)
 		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xC0);
 	} else {
 		b43_radio_write(dev, R2057v7_RCCAL_MASTER, 0x61);
-		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xE1);
+		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xE9);
 	}
 	b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
 
@@ -959,6 +1024,9 @@ static void b43_radio_2057_init_post(struct b43_wldev *dev)
 {
 	b43_radio_set(dev, R2057_XTALPUOVR_PINCTRL, 0x1);
 
+	if (0) /* FIXME: Is this BCM43217 specific? */
+		b43_radio_set(dev, R2057_XTALPUOVR_PINCTRL, 0x2);
+
 	b43_radio_set(dev, R2057_RFPLL_MISC_CAL_RESETN, 0x78);
 	b43_radio_set(dev, R2057_XTAL_CONFIG2, 0x80);
 	mdelay(2);
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 7fd5d5f..474bf75 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -366,11 +366,13 @@
 #define B43_NPHY_TXF_40CO_B1S0			B43_PHY_N(0x0E5) /* TX filter 40 coeff B1 stage 0 */
 #define B43_NPHY_TXF_40CO_B32S1			B43_PHY_N(0x0E6) /* TX filter 40 coeff B32 stage 1 */
 #define B43_NPHY_TXF_40CO_B1S1			B43_PHY_N(0x0E7) /* TX filter 40 coeff B1 stage 1 */
+#define B43_NPHY_REV3_RFCTL_OVER0		B43_PHY_N(0x0E7)
 #define B43_NPHY_TXF_40CO_B32S2			B43_PHY_N(0x0E8) /* TX filter 40 coeff B32 stage 2 */
 #define B43_NPHY_TXF_40CO_B1S2			B43_PHY_N(0x0E9) /* TX filter 40 coeff B1 stage 2 */
 #define B43_NPHY_BIST_STAT2			B43_PHY_N(0x0EA) /* BIST status 2 */
 #define B43_NPHY_BIST_STAT3			B43_PHY_N(0x0EB) /* BIST status 3 */
 #define B43_NPHY_RFCTL_OVER			B43_PHY_N(0x0EC) /* RF control override */
+#define B43_NPHY_REV3_RFCTL_OVER1		B43_PHY_N(0x0EC)
 #define B43_NPHY_MIMOCFG			B43_PHY_N(0x0ED) /* MIMO config */
 #define  B43_NPHY_MIMOCFG_GFMIX			0x0004 /* Greenfield or mixed mode */
 #define  B43_NPHY_MIMOCFG_AUTO			0x0100 /* Greenfield/mixed mode auto */
-- 
1.8.4.5

