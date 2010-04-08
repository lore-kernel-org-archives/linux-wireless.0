Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:3173 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933184Ab0DHVur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 17:50:47 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville <linville"@tuxdriver.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/9] rt2x00: Align rt2800 register initialization with vendor driver.
Date: Thu,  8 Apr 2010 23:50:33 +0200
Message-Id: <1270763437-29526-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align the rt2800 register initializations with the latest versions of the
Ralink vendor driver.
This patch is also preparation for the addition of support for RT3070 /
RT3071 / RT3090 / RT3390 based devices.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  155 +++++++++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2800pci.c |   13 ---
 2 files changed, 114 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d15b230..51e6ca8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -359,11 +359,6 @@ static int rt2800_blink_set(struct led_classdev *led_cdev,
 	rt2800_register_read(led->rt2x00dev, LED_CFG, &reg);
 	rt2x00_set_field32(&reg, LED_CFG_ON_PERIOD, *delay_on);
 	rt2x00_set_field32(&reg, LED_CFG_OFF_PERIOD, *delay_off);
-	rt2x00_set_field32(&reg, LED_CFG_SLOW_BLINK_PERIOD, 3);
-	rt2x00_set_field32(&reg, LED_CFG_R_LED_MODE, 3);
-	rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, 3);
-	rt2x00_set_field32(&reg, LED_CFG_Y_LED_MODE, 3);
-	rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, 1);
 	rt2800_register_write(led->rt2x00dev, LED_CFG, reg);
 
 	return 0;
@@ -531,12 +526,8 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_PLCPFAIL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_TO_ME,
 			   !(filter_flags & FIF_PROMISC_IN_BSS));
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_MY_BSSD, 0);
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_VER_ERROR, 1);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_MULTICAST,
 			   !(filter_flags & FIF_ALLMULTI));
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BROADCAST, 0);
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_DUPLICATE, 1);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CF_END_ACK,
 			   !(filter_flags & FIF_CONTROL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CF_END,
@@ -549,8 +540,6 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_CONTROL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PSPOLL,
 			   !(filter_flags & FIF_PSPOLL));
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA, 1);
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
 			   !(filter_flags & FIF_CONTROL));
 	rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);
@@ -609,10 +598,6 @@ void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp)
 {
 	u32 reg;
 
-	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_RX_ACK_TIMEOUT, 0x20);
-	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
-
 	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_BAC_ACK_POLICY,
 			   !!erp->short_preamble);
@@ -631,15 +616,12 @@ void rt2800_config_erp(struct rt2x00_dev *rt2x00dev, struct rt2x00lib_erp *erp)
 
 	rt2800_register_read(rt2x00dev, BKOFF_SLOT_CFG, &reg);
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_SLOT_TIME, erp->slot_time);
-	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
 	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, erp->sifs);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, erp->sifs);
-	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_XIFS_TIME, 4);
 	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, erp->eifs);
-	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
 	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
@@ -984,10 +966,6 @@ static void rt2800_config_retry_limit(struct rt2x00_dev *rt2x00dev,
 			   libconf->conf->short_frame_max_tx_count);
 	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_LIMIT,
 			   libconf->conf->long_frame_max_tx_count);
-	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_THRE, 2000);
-	rt2x00_set_field32(&reg, TX_RTY_CFG_NON_AGG_RTY_MODE, 0);
-	rt2x00_set_field32(&reg, TX_RTY_CFG_AGG_RTY_MODE, 0);
-	rt2x00_set_field32(&reg, TX_RTY_CFG_TX_AUTO_FB_ENABLE, 1);
 	rt2800_register_write(rt2x00dev, TX_RTY_CFG, reg);
 }
 
@@ -1111,6 +1089,14 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 	unsigned int i;
 
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+
 	if (rt2x00_is_usb(rt2x00dev)) {
 		/*
 		 * Wait until BBP and RF are ready.
@@ -1130,8 +1116,25 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
 		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL,
 				      reg & ~0x00002000);
-	} else if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
+	} else if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
+		/*
+		 * Reset DMA indexes
+		 */
+		rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
+		rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+
+		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
+		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+
 		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	}
 
 	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
@@ -1176,6 +1179,31 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
+	rt2800_register_read(rt2x00dev, RX_FILTER_CFG, &reg);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CRC_ERROR, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PHY_ERROR, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_TO_ME, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_MY_BSSD, 0);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_VER_ERROR, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_MULTICAST, 0);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BROADCAST, 0);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_DUPLICATE, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CF_END_ACK, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CF_END, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_ACK, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CTS, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_RTS, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PSPOLL, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA, 1);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL, 1);
+	rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);
+
+	rt2800_register_read(rt2x00dev, BKOFF_SLOT_CFG, &reg);
+	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_SLOT_TIME, 9);
+	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
+	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
+
 	if (rt2x00_is_usb(rt2x00dev) &&
 	    rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) == 0x0200) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
@@ -1199,6 +1227,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG, &reg);
 	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_MPDU_LIFETIME, 9);
+	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_RX_ACK_TIMEOUT, 32);
 	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_TX_OP_TIMEOUT, 10);
 	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
 
@@ -1214,38 +1243,61 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
 	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
 
+	rt2800_register_read(rt2x00dev, LED_CFG, &reg);
+	rt2x00_set_field32(&reg, LED_CFG_ON_PERIOD, 70);
+	rt2x00_set_field32(&reg, LED_CFG_OFF_PERIOD, 30);
+	rt2x00_set_field32(&reg, LED_CFG_SLOW_BLINK_PERIOD, 3);
+	rt2x00_set_field32(&reg, LED_CFG_R_LED_MODE, 3);
+	rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, 3);
+	rt2x00_set_field32(&reg, LED_CFG_Y_LED_MODE, 3);
+	rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, 1);
+	rt2800_register_write(rt2x00dev, LED_CFG, reg);
+
 	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
 
+	rt2800_register_read(rt2x00dev, TX_RTY_CFG, &reg);
+	rt2x00_set_field32(&reg, TX_RTY_CFG_SHORT_RTY_LIMIT, 15);
+	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_LIMIT, 31);
+	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_THRE, 2000);
+	rt2x00_set_field32(&reg, TX_RTY_CFG_NON_AGG_RTY_MODE, 0);
+	rt2x00_set_field32(&reg, TX_RTY_CFG_AGG_RTY_MODE, 0);
+	rt2x00_set_field32(&reg, TX_RTY_CFG_TX_AUTO_FB_ENABLE, 1);
+	rt2800_register_write(rt2x00dev, TX_RTY_CFG, reg);
+
 	rt2800_register_read(rt2x00dev, AUTO_RSP_CFG, &reg);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AUTORESPONDER, 1);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_BAC_ACK_POLICY, 1);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MMODE, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_CTS_40_MREF, 0);
+	rt2x00_set_field32(&reg, AUTO_RSP_CFG_AR_PREAMBLE, 1);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_DUAL_CTS_EN, 0);
 	rt2x00_set_field32(&reg, AUTO_RSP_CFG_ACK_CTS_PSM_BIT, 0);
 	rt2800_register_write(rt2x00dev, AUTO_RSP_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, CCK_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_RATE, 8);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_RATE, 3);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_PROTECT_NAV, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM40, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_MM40, 0);
 	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_TX_OP_ALLOW_GF40, 0);
+	rt2x00_set_field32(&reg, CCK_PROT_CFG_RTS_TH_EN, 1);
 	rt2800_register_write(rt2x00dev, CCK_PROT_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, OFDM_PROT_CFG, &reg);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_RATE, 8);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_RATE, 3);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_PROTECT_NAV, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM20, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM40, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_MM40, 0);
 	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF20, 1);
-	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_TX_OP_ALLOW_GF40, 0);
+	rt2x00_set_field32(&reg, OFDM_PROT_CFG_RTS_TH_EN, 1);
 	rt2800_register_write(rt2x00dev, OFDM_PROT_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, MM20_PROT_CFG, &reg);
@@ -1258,11 +1310,15 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
+	rt2x00_set_field32(&reg, MM20_PROT_CFG_RTS_TH_EN, 0);
 	rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, MM40_PROT_CFG, &reg);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
-	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
+	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 1);
+	else if (rt2x00_is_usb(rt2x00dev))
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
@@ -1270,6 +1326,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+	rt2x00_set_field32(&reg, MM40_PROT_CFG_RTS_TH_EN, 0);
 	rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, GF20_PROT_CFG, &reg);
@@ -1282,6 +1339,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, GF20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
+	rt2x00_set_field32(&reg, GF20_PROT_CFG_RTS_TH_EN, 0);
 	rt2800_register_write(rt2x00dev, GF20_PROT_CFG, reg);
 
 	rt2800_register_read(rt2x00dev, GF40_PROT_CFG, &reg);
@@ -1294,6 +1352,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
 	rt2x00_set_field32(&reg, GF40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+	rt2x00_set_field32(&reg, GF40_PROT_CFG_RTS_TH_EN, 0);
 	rt2800_register_write(rt2x00dev, GF40_PROT_CFG, reg);
 
 	if (rt2x00_is_usb(rt2x00dev)) {
@@ -1323,6 +1382,15 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
 
 	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
+
+	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
+	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, 32);
+	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, 32);
+	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_XIFS_TIME, 4);
+	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, 314);
+	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
+	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
+
 	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
 	/*
@@ -1472,26 +1540,31 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
-	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+
+	if (rt2x00_rt(rt2x00dev, RT2860) && rt2x00_rev(rt2x00dev) == 0x0100) {
+		rt2800_bbp_write(rt2x00dev, 69, 0x16);
+		rt2800_bbp_write(rt2x00dev, 73, 0x12);
+	} else {
+		rt2800_bbp_write(rt2x00dev, 69, 0x12);
+		rt2800_bbp_write(rt2x00dev, 73, 0x10);
+	}
+
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
-	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 	rt2800_bbp_write(rt2x00dev, 81, 0x37);
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
-	rt2800_bbp_write(rt2x00dev, 84, 0x99);
+
+	if (rt2x00_rev(rt2x00dev) == 0x101)
+		rt2800_bbp_write(rt2x00dev, 84, 0x19);
+	else
+		rt2800_bbp_write(rt2x00dev, 84, 0x99);
+
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 	rt2800_bbp_write(rt2x00dev, 103, 0x00);
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
-
-	if (rt2x00_rt(rt2x00dev, RT2860) && rt2x00_rev(rt2x00dev) == 0x0100) {
-		rt2800_bbp_write(rt2x00dev, 69, 0x16);
-		rt2800_bbp_write(rt2x00dev, 73, 0x12);
-	}
-
-	if (rt2x00_rt(rt2x00dev, RT2860) && rt2x00_rev(rt2x00dev) > 0x0101)
-		rt2800_bbp_write(rt2x00dev, 84, 0x19);
+	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 
 	if (rt2x00_is_usb(rt2x00dev) &&
 	    rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) == 0x0200) {
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index a2b37d3..2131f8f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -347,19 +347,6 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	struct queue_entry_priv_pci *entry_priv;
 	u32 reg;
 
-	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
-
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
-
 	/*
 	 * Initialize registers.
 	 */
-- 
1.7.0.4

