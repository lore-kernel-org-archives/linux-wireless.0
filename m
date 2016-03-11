Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbcCKT5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 14:57:36 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 7/7] rtl8xxxu: Use enums for chip version numbers
Date: Fri, 11 Mar 2016 14:57:34 -0500
Message-Id: <1457726254-28178-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160311_205749_920204_F5B25408)
In-Reply-To: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

With support for more chips being added, use an enum to specify the
chip version.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 84 ++++++++++++------------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 26 +++++++-
 2 files changed, 67 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index ad280cf..3857669 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1574,7 +1574,7 @@ static void rtl8723a_enable_rf(struct rtl8xxxu_priv *priv)
 	val32 &= ~OFDM_RF_PATH_TX_MASK;
 	if (priv->tx_paths == 2)
 		val32 |= OFDM_RF_PATH_TX_A | OFDM_RF_PATH_TX_B;
-	else if (priv->rtlchip == 0x8192c || priv->rtlchip == 0x8191c)
+	else if (priv->rtl_chip == RTL8192C || priv->rtl_chip == RTL8191C)
 		val32 |= OFDM_RF_PATH_TX_B;
 	else
 		val32 |= OFDM_RF_PATH_TX_A;
@@ -2199,11 +2199,11 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	if (val32 & SYS_CFG_BT_FUNC) {
 		if (priv->chip_cut >= 3) {
 			sprintf(priv->chip_name, "8723BU");
-			priv->rtlchip = 0x8723b;
+			priv->rtl_chip = RTL8723B;
 		} else {
 			sprintf(priv->chip_name, "8723AU");
 			priv->usb_interrupts = 1;
-			priv->rtlchip = 0x8723a;
+			priv->rtl_chip = RTL8723A;
 		}
 
 		priv->rf_paths = 1;
@@ -2227,13 +2227,13 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 				priv->rf_paths = 2;
 				priv->rx_paths = 2;
 				priv->tx_paths = 1;
-				priv->rtlchip = 0x8191e;
+				priv->rtl_chip = RTL8191E;
 			} else {
 				sprintf(priv->chip_name, "8192EU");
 				priv->rf_paths = 2;
 				priv->rx_paths = 2;
 				priv->tx_paths = 2;
-				priv->rtlchip = 0x8192e;
+				priv->rtl_chip = RTL8192E;
 			}
 		} else if (bonding == HPON_FSM_BONDING_1T2R) {
 			sprintf(priv->chip_name, "8191CU");
@@ -2241,14 +2241,14 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 			priv->rx_paths = 2;
 			priv->tx_paths = 1;
 			priv->usb_interrupts = 1;
-			priv->rtlchip = 0x8191c;
+			priv->rtl_chip = RTL8191C;
 		} else {
 			sprintf(priv->chip_name, "8192CU");
 			priv->rf_paths = 2;
 			priv->rx_paths = 2;
 			priv->tx_paths = 2;
 			priv->usb_interrupts = 1;
-			priv->rtlchip = 0x8192c;
+			priv->rtl_chip = RTL8192C;
 		}
 		priv->has_wifi = 1;
 	} else {
@@ -2256,15 +2256,15 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		priv->rf_paths = 1;
 		priv->rx_paths = 1;
 		priv->tx_paths = 1;
-		priv->rtlchip = 0x8188c;
+		priv->rtl_chip = RTL8188C;
 		priv->usb_interrupts = 1;
 		priv->has_wifi = 1;
 	}
 
-	switch (priv->rtlchip) {
-	case 0x8188e:
-	case 0x8192e:
-	case 0x8723b:
+	switch (priv->rtl_chip) {
+	case RTL8188E:
+	case RTL8192E:
+	case RTL8723B:
 		switch (val32 & SYS_CFG_VENDOR_EXT_MASK) {
 		case SYS_CFG_VENDOR_ID_TSMC:
 			sprintf(priv->chip_vendor, "TSMC");
@@ -2814,7 +2814,7 @@ static int rtl8xxxu_start_firmware(struct rtl8xxxu_priv *priv)
 	/*
 	 * Init H2C command
 	 */
-	if (priv->rtlchip == 0x8723b)
+	if (priv->rtl_chip == RTL8723B)
 		rtl8xxxu_write8(priv, REG_HMTFR, 0x0f);
 exit:
 	return ret;
@@ -2997,7 +2997,7 @@ static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
 
 	if (!priv->vendor_umc)
 		fw_name = "rtlwifi/rtl8192cufw_TMSC.bin";
-	else if (priv->chip_cut || priv->rtlchip == 0x8192c)
+	else if (priv->chip_cut || priv->rtl_chip == RTL8192C)
 		fw_name = "rtlwifi/rtl8192cufw_B.bin";
 	else
 		fw_name = "rtlwifi/rtl8192cufw_A.bin";
@@ -3108,7 +3108,7 @@ rtl8xxxu_init_mac(struct rtl8xxxu_priv *priv, struct rtl8xxxu_reg8val *array)
 		}
 	}
 
-	if (priv->rtlchip != 0x8723b)
+	if (priv->rtl_chip != RTL8723B)
 		rtl8xxxu_write8(priv, REG_MAX_AGGR_NUM, 0x0a);
 
 	return 0;
@@ -3154,7 +3154,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 	 *       addresses, which is initialized here. Do we need this?
 	 */
 
-	if (priv->rtlchip == 0x8723b) {
+	if (priv->rtl_chip == RTL8723B) {
 		val16 = rtl8xxxu_read16(priv, REG_SYS_FUNC);
 		val16 |= SYS_FUNC_BB_GLB_RSTN | SYS_FUNC_BBRSTB |
 			SYS_FUNC_DIO_RF;
@@ -3176,7 +3176,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write16(priv, REG_SYS_FUNC, val16);
 	}
 
-	if (priv->rtlchip != 0x8723b) {
+	if (priv->rtl_chip != RTL8723B) {
 		/* AFE_XTAL_RF_GATE (bit 14) if addressing as 32 bit register */
 		val32 = rtl8xxxu_read32(priv, REG_AFE_XTAL_CTRL);
 		val32 &= ~AFE_XTAL_RF_GATE;
@@ -3193,7 +3193,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_init_phy_regs(priv, rtl8188ru_phy_1t_highpa_table);
 	else if (priv->tx_paths == 2)
 		rtl8xxxu_init_phy_regs(priv, rtl8192cu_phy_2t_init_table);
-	else if (priv->rtlchip == 0x8723b) {
+	else if (priv->rtl_chip == RTL8723B) {
 		/*
 		 * Why?
 		 */
@@ -3204,7 +3204,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_init_phy_regs(priv, rtl8723a_phy_1t_init_table);
 
 
-	if (priv->rtlchip == 0x8188c && priv->hi_pa &&
+	if (priv->rtl_chip == RTL8188C && priv->hi_pa &&
 	    priv->vendor_umc && priv->chip_cut == 1)
 		rtl8xxxu_write8(priv, REG_OFDM0_AGC_PARM1 + 2, 0x50);
 
@@ -3266,7 +3266,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_TX_TO_TX, val32);
 	}
 
-	if (priv->rtlchip == 0x8723b)
+	if (priv->rtl_chip == RTL8723B)
 		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_8723bu_table);
 	else if (priv->hi_pa)
 		rtl8xxxu_init_phy_regs(priv, rtl8xxx_agc_highpa_table);
@@ -3283,7 +3283,7 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_MAC_PHY_CTRL, val32);
 	}
 
-	if (priv->rtlchip != 0x8723bu) {
+	if (priv->rtl_chip != RTL8723B) {
 		ldoa15 = LDOA15_ENABLE | LDOA15_OBUF;
 		ldov12d = LDOV12D_ENABLE | BIT(2) | (2 << LDOV12D_VADJ_SHIFT);
 		ldohci12 = 0x57;
@@ -5955,7 +5955,7 @@ static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
 	/*
 	 * Workaround for 8188RU LNA power leakage problem.
 	 */
-	if (priv->rtlchip == 0x8188c && priv->hi_pa) {
+	if (priv->rtl_chip == RTL8188C && priv->hi_pa) {
 		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XCD_RF_PARM);
 		val32 &= ~BIT(1);
 		rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_PARM, val32);
@@ -6020,7 +6020,7 @@ static void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 	/*
 	 * Workaround for 8188RU LNA power leakage problem.
 	 */
-	if (priv->rtlchip == 0x8188c && priv->hi_pa) {
+	if (priv->rtl_chip == RTL8188C && priv->hi_pa) {
 		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XCD_RF_PARM);
 		val32 |= BIT(1);
 		rtl8xxxu_write32(priv, REG_FPGA0_XCD_RF_PARM, val32);
@@ -6313,7 +6313,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		 * Presumably this is for 8188EU as well
 		 * Enable TX report and TX report timer
 		 */
-		if (priv->rtlchip == 0x8723bu) {
+		if (priv->rtl_chip == RTL8723B) {
 			val8 = rtl8xxxu_read8(priv, REG_TX_REPORT_CTRL);
 			val8 |= TX_REPORT_CTRL_TIMER_ENABLE;
 			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
@@ -6340,9 +6340,9 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	/* Solve too many protocol error on USB bus */
 	/* Can't do this for 8188/8192 UMC A cut parts */
-	if (priv->rtlchip == 0x8723a ||
-	    ((priv->rtlchip == 0x8192c || priv->rtlchip == 0x8191c ||
-	      priv->rtlchip == 0x8188c) &&
+	if (priv->rtl_chip == RTL8723A ||
+	    ((priv->rtl_chip == RTL8192C || priv->rtl_chip == RTL8191C ||
+	      priv->rtl_chip == RTL8188C) &&
 	     (priv->chip_cut || !priv->vendor_umc))) {
 		rtl8xxxu_write8(priv, 0xfe40, 0xe6);
 		rtl8xxxu_write8(priv, 0xfe41, 0x94);
@@ -6361,7 +6361,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write8(priv, 0xfe42, 0x80);
 	}
 
-	if (priv->rtlchip == 0x8192e) {
+	if (priv->rtl_chip == RTL8192E) {
 		rtl8xxxu_write32(priv, REG_HIMR0, 0x00);
 		rtl8xxxu_write32(priv, REG_HIMR1, 0x00);
 	}
@@ -6369,7 +6369,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (priv->fops->phy_init_antenna_selection)
 		priv->fops->phy_init_antenna_selection(priv);
 
-	if (priv->rtlchip == 0x8723b)
+	if (priv->rtl_chip == RTL8723B)
 		ret = rtl8xxxu_init_mac(priv, rtl8723b_mac_init_table);
 	else
 		ret = rtl8xxxu_init_mac(priv, rtl8723a_mac_init_table);
@@ -6383,12 +6383,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	switch(priv->rtlchip) {
-	case 0x8723a:
+	switch(priv->rtl_chip) {
+	case RTL8723A:
 		rftable = rtl8723au_radioa_1t_init_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
 		break;
-	case 0x8723b:
+	case RTL8723B:
 		rftable = rtl8723bu_radioa_1t_init_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
 		/*
@@ -6399,18 +6399,18 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		msleep(200);
 		rtl8xxxu_write_rfreg(priv, RF_A, 0xb0, 0xdffe0);
 		break;
-	case 0x8188c:
+	case RTL8188C:
 		if (priv->hi_pa)
 			rftable = rtl8188ru_radioa_1t_highpa_table;
 		else
 			rftable = rtl8192cu_radioa_1t_init_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
 		break;
-	case 0x8191c:
+	case RTL8191C:
 		rftable = rtl8192cu_radioa_1t_init_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
 		break;
-	case 0x8192c:
+	case RTL8192C:
 		rftable = rtl8192cu_radioa_2t_init_table;
 		ret = rtl8xxxu_init_phy_rf(priv, rftable, RF_A);
 		if (ret)
@@ -6428,7 +6428,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Chip specific quirks
 	 */
-	if (priv->rtlchip == 0x8723a) {
+	if (priv->rtl_chip == RTL8723A) {
 		/* Fix USB interface interference issue */
 		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
 		rtl8xxxu_write8(priv, 0xfe41, 0x8d);
@@ -6468,7 +6468,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		 */
 		val8 = TX_TOTAL_PAGE_NUM + 1;
 
-		if (priv->rtlchip == 0x8723b)
+		if (priv->rtl_chip == RTL8723B)
 			val8 -= 1;
 
 		rtl8xxxu_write8(priv, REG_TXPKTBUF_BCNQ_BDNY, val8);
@@ -6484,7 +6484,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		goto exit;
 
 	/* RFSW Control - clear bit 14 ?? */
-	if (priv->rtlchip != 0x8723b)
+	if (priv->rtl_chip != RTL8723B)
 		rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
 	/* 0x07000760 */
 	val32 = FPGA0_RF_TRSW | FPGA0_RF_TRSWB | FPGA0_RF_ANTSW |
@@ -6501,14 +6501,14 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Set RX page boundary
 	 */
-	if (priv->rtlchip == 0x8723b)
+	if (priv->rtl_chip == RTL8723B)
 		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3f7f);
 	else
 		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
 	/*
 	 * Transfer page size is always 128
 	 */
-	if (priv->rtlchip == 0x8723b)
+	if (priv->rtl_chip == RTL8723B)
 		val8 = (PBP_PAGE_SIZE_256 << PBP_PAGE_SIZE_RX_SHIFT) |
 			(PBP_PAGE_SIZE_256 << PBP_PAGE_SIZE_TX_SHIFT);
 	else
@@ -6600,7 +6600,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Initialize burst parameters
 	 */
-	if (priv->rtlchip == 0x8723b) {
+	if (priv->rtl_chip == RTL8723B) {
 		/*
 		 * For USB high speed set 512B packets
 		 */
@@ -6682,7 +6682,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	val8 = ((30000 + NAV_UPPER_UNIT - 1) / NAV_UPPER_UNIT);
 	rtl8xxxu_write8(priv, REG_NAV_UPPER, val8);
 
-	if (priv->rtlchip == 0x8723a) {
+	if (priv->rtl_chip == RTL8723A) {
 		/*
 		 * 2011/03/09 MH debug only, UMC-B cut pass 2500 S5 test,
 		 * but we need to find root cause.
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index f211c5d..455e112 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -65,6 +65,30 @@
 #define EFUSE_BT_MAP_LEN_8723A		1024
 #define EFUSE_MAX_WORD_UNIT		4
 
+enum rtl8xxxu_rtl_chip {
+	RTL8192S = 0x81920,
+	RTL8191S = 0x81910,
+	RTL8192C = 0x8192c,
+	RTL8191C = 0x8191c,
+	RTL8188C = 0x8188c,
+	RTL8188R = 0x81889,
+	RTL8192D = 0x8192d,
+	RTL8723A = 0x8723a,
+	RTL8188E = 0x8188e,
+	RTL8812  = 0x88120,
+	RTL8821  = 0x88210,
+	RTL8192E = 0x8192e,
+	RTL8191E = 0x8191e,
+	RTL8723B = 0x8723b,
+	RTL8814A = 0x8814a,
+	RTL8881A = 0x8881a,
+	RTL8821B = 0x8821b,
+	RTL8822B = 0x8822b,
+	RTL8703B = 0x8703b,
+	RTL8195A = 0x8195a,
+	RTL8188F = 0x8188f
+};
+
 enum rtl8xxxu_rx_type {
 	RX_TYPE_DATA_PKT = 0,
 	RX_TYPE_C2H = 1,
@@ -1236,7 +1260,7 @@ struct rtl8xxxu_priv {
 	u32 mac_backup[RTL8XXXU_MAC_REGS];
 	u32 bb_backup[RTL8XXXU_BB_REGS];
 	u32 bb_recovery_backup[RTL8XXXU_BB_REGS];
-	u32 rtlchip;
+	enum rtl8xxxu_rtl_chip rtl_chip;
 	u8 pi_enabled:1;
 	u8 int_buf[USB_INTR_CONTENT_LENGTH];
 };
-- 
2.5.0

