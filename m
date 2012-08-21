Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37896 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2HUPBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 11:01:51 -0400
Received: by mail-yx0-f174.google.com with SMTP id l14so5892751yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2012 08:01:51 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Li Chaoming <chaoming_li@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/6] rtlwifi: rtl8192ce: Update for new vendor driver version
Date: Tue, 21 Aug 2012 10:00:54 -0500
Message-Id: <1345561255-10349-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120821_170202_333072_4280C16C)
In-Reply-To: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Li Chaoming <chaoming_li@realsil.com.cn>

Realtek driver version rtl_92ce_92se_92de_linux_mac80211_0005.1230.2011
includes a number of changes in rtl8192ce. The main differences are as
follows:

1. Include code for a number of new versions.
2. Update the signal strength reporting.
3. Update to handle 802.11w encryption correctly.

Signed-off-by: Li Chaoming <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h |   12 ++-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |  106 +++++++++++++++++++++-----
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |   70 +++++++++++++++--
 5 files changed, 164 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
index 04c3aef..3e0432b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -115,8 +115,18 @@
 #define	GET_C2H_CMD_FEEDBACK_CCX_SEQ(__pcmdfbhdr)	\
 	LE_BITS_TO_4BYTE(((__pcmdfbhdr) + 4), 20, 12)
 
-#define CHIP_VER_B			BIT(4)
+#define CHIP_BONDING_IDENTIFIER(_value)	(((_value) >> 22) & 0x3)
+#define	CHIP_BONDING_92C_1T2R		0x1
+
 #define CHIP_92C_BITMASK		BIT(0)
+#define RF_TYPE_1T2R			BIT(1)
+#define NORMAL_CHIP			BIT(4)
+#define CHIP_VENDOR_UMC			BIT(5)
+#define CHIP_VENDOR_UMC_B_CUT	BIT(6) /* Chip version for ECO */
+#define CHIP_UNKNOW			BIT(7)
+#define CUT_VERSION_MASK		(BIT(6)|BIT(7))
+#define RF_TYPE_MASK			(BIT(0)|BIT(1))
+#define CHIP_VER_B			BIT(4)
 #define CHIP_92C_1T2R			0x03
 #define CHIP_92C			0x01
 #define CHIP_88C			0x00
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index cc89582..a088ecd 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -896,7 +896,6 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	static bool iqk_initialized; /* initialized to false */
 	bool rtstatus = true;
 	bool is92c;
 	int err;
@@ -921,9 +920,29 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 
 	rtlhal->last_hmeboxnum = 0;
 	rtl92c_phy_mac_config(hw);
+	/* because last function modify RCR, we update
+	 * rcr var here, or TP will unstable for receive_config
+	 * is wrong, RX RCR_ACRC32 will cause TP unstabel & Rx
+	 * RCR_APP_ICV will cause mac80211 unassoc for Cisco 1252 */
+	rtlpci->receive_config = rtl_read_dword(rtlpriv, REG_RCR);
+	rtlpci->receive_config &= ~(RCR_ACRC32 | RCR_AICV);
+	rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
+
 	rtl92c_phy_bb_config(hw);
 	rtlphy->rf_mode = RF_OP_BY_SW_3WIRE;
 	rtl92c_phy_rf_config(hw);
+	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
+	    !IS_92C_SERIAL(rtlhal->version)) {
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_RX_G1, MASKDWORD, 0x30255);
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_RX_G2, MASKDWORD, 0x50a00);
+	} else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version)) {
+		rtl_set_rfreg(hw, RF90_PATH_A, 0x0C, MASKDWORD, 0x894AE);
+		rtl_set_rfreg(hw, RF90_PATH_A, 0x0A, MASKDWORD, 0x1AF31);
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_IPA, MASKDWORD, 0x8F425);
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_SYN_G2, MASKDWORD, 0x4F200);
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_RCK1, MASKDWORD, 0x44053);
+		rtl_set_rfreg(hw, RF90_PATH_A, RF_RCK2, MASKDWORD, 0x80201);
+	}
 	rtlphy->rfreg_chnlval[0] = rtl_get_rfreg(hw, (enum radio_path)0,
 						 RF_CHNLBW, RFREG_OFFSET_MASK);
 	rtlphy->rfreg_chnlval[1] = rtl_get_rfreg(hw, (enum radio_path)1,
@@ -945,11 +964,11 @@ int rtl92ce_hw_init(struct ieee80211_hw *hw)
 
 	if (ppsc->rfpwr_state == ERFON) {
 		rtl92c_phy_set_rfpath_switch(hw, 1);
-		if (iqk_initialized) {
+		if (rtlphy->iqk_initialized) {
 			rtl92c_phy_iq_calibrate(hw, true);
 		} else {
 			rtl92c_phy_iq_calibrate(hw, false);
-			iqk_initialized = true;
+			rtlphy->iqk_initialized = true;
 		}
 
 		rtl92c_dm_check_txpower_tracking(hw);
@@ -987,38 +1006,79 @@ static enum version_8192c _rtl92ce_read_chip_version(struct ieee80211_hw *hw)
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	enum version_8192c version = VERSION_UNKNOWN;
 	u32 value32;
-	const char *versionid;
 
 	value32 = rtl_read_dword(rtlpriv, REG_SYS_CFG);
 	if (value32 & TRP_VAUX_EN) {
 		version = (value32 & TYPE_ID) ? VERSION_A_CHIP_92C :
 			   VERSION_A_CHIP_88C;
 	} else {
-		version = (value32 & TYPE_ID) ? VERSION_B_CHIP_92C :
-			   VERSION_B_CHIP_88C;
+		version = (enum version_8192c) NORMAL_CHIP;
+		version = (enum version_8192c) (version |
+			  ((value32 & TYPE_ID) ? CHIP_92C_BITMASK : 0));
+		version = (enum version_8192c) (version |
+			  ((value32 & VENDOR_ID) ? CHIP_VENDOR_UMC : 0));
+		if ((!IS_CHIP_VENDOR_UMC(version)) &&
+		    (value32 & CHIP_VER_RTL_MASK)) {
+			version = (enum version_8192c)(version |
+				  ((((value32 & CHIP_VER_RTL_MASK) == BIT(12))
+				  ? CHIP_VENDOR_UMC_B_CUT : CHIP_UNKNOW) |
+				  CHIP_VENDOR_UMC));
+		}
+		if (IS_92C_SERIAL(version)) {
+			value32 = rtl_read_dword(rtlpriv, REG_HPON_FSM);
+			version = (enum version_8192c)(version |
+				  ((CHIP_BONDING_IDENTIFIER(value32)
+				  == CHIP_BONDING_92C_1T2R) ?
+				  RF_TYPE_1T2R : 0));
+		}
 	}
 
 	switch (version) {
 	case VERSION_B_CHIP_92C:
-		versionid = "B_CHIP_92C";
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_B_CHIP_92C.\n");
 		break;
 	case VERSION_B_CHIP_88C:
-		versionid = "B_CHIP_88C";
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_B_CHIP_88C.\n");
 		break;
 	case VERSION_A_CHIP_92C:
-		versionid = "A_CHIP_92C";
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_A_CHIP_92C.\n");
 		break;
 	case VERSION_A_CHIP_88C:
-		versionid = "A_CHIP_88C";
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_A_CHIP_88C.\n");
+		break;
+	case VERSION_NORMAL_UMC_CHIP_92C_1T2R_A_CUT:
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_NORMAL_UMC_CHIP_92C_1T2R_A_CUT.\n");
+		break;
+	case VERSION_NORMAL_UMC_CHIP_92C_A_CUT:
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_NORMAL_UMC_CHIP_92C_A_CUT.\n");
+		break;
+	case VERSION_NORMAL_UMC_CHIP_88C_A_CUT:
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_NORMAL_UMC_CHIP_88C_A_CUT.\n");
+		break;
+	case VERSION_NORMAL_UMC_CHIP_92C_1T2R_B_CUT:
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_NORMAL_UMC_CHIP_92C_1T2R_B_CUT.\n");
+		break;
+	case VERSION_NORMAL_UMC_CHIP_92C_B_CUT:
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_NORMAL_UMC_CHIP_92C_B_CUT.\n");
+		break;
+	case VERSION_NORMAL_UMC_CHIP_88C_B_CUT:
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+			 "Chip Version ID: VERSION_NORMAL_UMC_CHIP_88C_B_CUT.\n");
 		break;
 	default:
-		versionid = "Unknown. Bug?";
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Chip Version ID: Unknown. Bug?\n");
 		break;
 	}
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-		 "Chip Version ID: %s\n", versionid);
-
 	switch (version & 0x3) {
 	case CHIP_88C:
 		rtlphy->rf_type = RF_1T1R;
@@ -1189,6 +1249,7 @@ static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 u1b_tmp;
 	u32 u4b_tmp;
 
@@ -1217,7 +1278,8 @@ static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
 	rtl_write_word(rtlpriv, REG_GPIO_IO_SEL, 0x0790);
 	rtl_write_word(rtlpriv, REG_LEDCFG0, 0x8080);
 	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL, 0x80);
-	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x23);
+	if (!IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
+		rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x23);
 	if (rtlpcipriv->bt_coexist.bt_coexistence) {
 		u4b_tmp = rtl_read_dword(rtlpriv, REG_AFE_XTAL_CTRL);
 		u4b_tmp |= 0x03824800;
@@ -1246,6 +1308,9 @@ void rtl92ce_card_disable(struct ieee80211_hw *hw)
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_OFF);
 	RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 	_rtl92ce_poweroff_adapter(hw);
+
+	/* after power off we should do iqk again */
+	rtlpriv->phy.iqk_initialized = false;
 }
 
 void rtl92ce_interrupt_recognized(struct ieee80211_hw *hw,
@@ -1710,6 +1775,8 @@ static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
 		ratr_value = sta->supp_rates[1] << 4;
 	else
 		ratr_value = sta->supp_rates[0];
+	if (mac->opmode == NL80211_IFTYPE_ADHOC)
+		ratr_value = 0xfff;
 	ratr_value |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
@@ -1814,6 +1881,8 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 		ratr_bitmap = sta->supp_rates[1] << 4;
 	else
 		ratr_bitmap = sta->supp_rates[0];
+	if (mac->opmode == NL80211_IFTYPE_ADHOC)
+		ratr_bitmap = 0xfff;
 	ratr_bitmap |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
@@ -1904,6 +1973,8 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 			ratr_bitmap &= 0x0f0ff0ff;
 		break;
 	}
+	sta_entry->ratr_index = ratr_index;
+
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
 		 "ratr_bitmap :%x\n", ratr_bitmap);
 	*(u32 *)&rate_mask = (ratr_bitmap & 0x0fffffff) |
@@ -1915,9 +1986,6 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 		 rate_mask[0], rate_mask[1], rate_mask[2], rate_mask[3],
 		 rate_mask[4]);
 	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
-
-	if (macid != 0)
-		sta_entry->ratr_index = ratr_index;
 }
 
 void rtl92ce_update_hal_rate_tbl(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
index e4d738f..bd4aef7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -544,6 +544,7 @@
 #define	IMR_WLANOFF				BIT(0)
 
 #define EFUSE_REAL_CONTENT_LEN			512
+#define EFUSE_OOB_PROTECT_BYTES			15
 
 #define	EEPROM_DEFAULT_TSSI			0x0
 #define EEPROM_DEFAULT_TXPOWERDIFF		0x0
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 60451ee..8f853f0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -278,6 +278,7 @@ static struct rtl_hal_cfg rtl92ce_hal_cfg = {
 	.maps[EFUSE_HWSET_MAX_SIZE] = HWSET_MAX_SIZE,
 	.maps[EFUSE_MAX_SECTION_MAP] = EFUSE_MAX_SECTION,
 	.maps[EFUSE_REAL_CONTENT_SIZE] = EFUSE_REAL_CONTENT_LEN,
+	.maps[EFUSE_OOB_PROTECT_BYTES_LEN] = EFUSE_OOB_PROTECT_BYTES,
 
 	.maps[RWCAM] = REG_CAMCMD,
 	.maps[WCAMI] = REG_CAMWRITE,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 5216664..64cde4a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -42,7 +42,7 @@ static u8 _rtl92ce_map_hwqueue_to_fwqueue(struct sk_buff *skb, u8 hw_queue)
 
 	if (unlikely(ieee80211_is_beacon(fc)))
 		return QSLT_BEACON;
-	if (ieee80211_is_mgmt(fc))
+	if (ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc))
 		return QSLT_MGNT;
 
 	return skb->priority;
@@ -127,13 +127,14 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct phy_sts_cck_8192s_t *cck_buf;
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
 	s8 rx_pwr_all = 0, rx_pwr[4];
 	u8 evm, pwdb_all, rf_rx_num = 0;
 	u8 i, max_spatial_stream;
 	u32 rssi, total_rssi = 0;
-	bool in_powersavemode = false;
 	bool is_cck_rate;
 
+	/* Save data for next packet processing */
 	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
 	pstats->packet_matchbssid = packet_match_bssid;
 	pstats->packet_toself = packet_toself;
@@ -145,9 +146,14 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 
 	if (is_cck_rate) {
 		u8 report, cck_highpwr;
+
+		/* CCK info is not the same as OFDM */
 		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
 
-		if (!in_powersavemode)
+		/* (1)Hardware does not provide RSSI for CCK */
+		/* (2)PWDB, Average PWDB cacluated by
+		 * hardware (for rate adaptive) */
+		if (ppsc->rfpwr_state == ERFON)
 			cck_highpwr = (u8) rtl_get_bbreg(hw,
 						 RFPGA0_XA_HSSIPARAMETER2,
 						 BIT(9));
@@ -193,9 +199,26 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 		}
 
 		pwdb_all = _rtl92c_query_rxpwrpercentage(rx_pwr_all);
+		/* CCK gain is smaller than OFDM/MCS gain,
+		 * so we add gain diff by experiences,
+		 * the val is 6 */
+		pwdb_all += 6;
+		if (pwdb_all > 100)
+			pwdb_all = 100;
+		/* modify the offset to make the same
+		 * gain index with OFDM. */
+		if (pwdb_all > 34 && pwdb_all <= 42)
+			pwdb_all -= 2;
+		else if (pwdb_all > 26 && pwdb_all <= 34)
+			pwdb_all -= 6;
+		else if (pwdb_all > 14 && pwdb_all <= 26)
+			pwdb_all -= 8;
+		else if (pwdb_all > 4 && pwdb_all <= 14)
+			pwdb_all -= 4;
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->recvsignalpower = rx_pwr_all;
 
+		/* (3) Get Signal Quality (EVM) */
 		if (packet_match_bssid) {
 			u8 sq;
 			if (pstats->rx_pwdb_all > 40)
@@ -217,27 +240,39 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 	} else {
 		rtlpriv->dm.rfpath_rxenable[0] =
 		    rtlpriv->dm.rfpath_rxenable[1] = true;
+
+		/* (1)Get RSSI for HT rate */
 		for (i = RF90_PATH_A; i < RF90_PATH_MAX; i++) {
+
+			/* we will judge RF RX path now. */
 			if (rtlpriv->dm.rfpath_rxenable[i])
 				rf_rx_num++;
 
 			rx_pwr[i] =
 			    ((p_drvinfo->gain_trsw[i] & 0x3f) * 2) - 110;
+
+			/* Translate DBM to percentage. */
 			rssi = _rtl92c_query_rxpwrpercentage(rx_pwr[i]);
 			total_rssi += rssi;
+
+			/* Get Rx snr value in DB */
 			rtlpriv->stats.rx_snr_db[i] =
 			    (long)(p_drvinfo->rxsnr[i] / 2);
 
+			/* Record Signal Strength for next packet */
 			if (packet_match_bssid)
 				pstats->rx_mimo_signalstrength[i] = (u8) rssi;
 		}
 
+		/* (2)PWDB, Average PWDB cacluated by
+		 * hardware (for rate adaptive) */
 		rx_pwr_all = ((p_drvinfo->pwdb_all >> 1) & 0x7f) - 110;
 		pwdb_all = _rtl92c_query_rxpwrpercentage(rx_pwr_all);
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->rxpower = rx_pwr_all;
 		pstats->recvsignalpower = rx_pwr_all;
 
+		/* (3)EVM of HT rate */
 		if (pdesc->rxht && pdesc->rxmcs >= DESC92_RATEMCS8 &&
 		    pdesc->rxmcs <= DESC92_RATEMCS15)
 			max_spatial_stream = 2;
@@ -248,6 +283,8 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 			evm = _rtl92c_evm_db_to_percentage(p_drvinfo->rxevm[i]);
 
 			if (packet_match_bssid) {
+				/* Fill value in RFD, Get the first
+				 * spatial stream only */
 				if (i == 0)
 					pstats->signalquality =
 					    (u8) (evm & 0xff);
@@ -257,6 +294,8 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 		}
 	}
 
+	/* UI BSS List signal strength(in percentage),
+	 * make it good looking, from 0~100. */
 	if (is_cck_rate)
 		pstats->signalstrength =
 		    (u8) (_rtl92ce_signal_scale_mapping(hw, pwdb_all));
@@ -534,6 +573,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 {
 	struct rx_fwinfo_92c *p_drvinfo;
 	struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
+	struct ieee80211_hdr *hdr;
 
 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
 	stats->length = (u16) GET_RX_DESC_PKT_LEN(pdesc);
@@ -558,7 +598,10 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	if (GET_RX_DESC_CRC32(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (!GET_RX_DESC_SWDEC(pdesc))
+	hdr = (struct ieee80211_hdr *)(skb->data + stats->rx_drvinfo_size
+			+ stats->rx_bufshift);
+
+	if (stats->crc)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 
 	if (GET_RX_DESC_BW(pdesc))
@@ -569,9 +612,24 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
-	if (stats->decrypted)
-		rx_status->flag |= RX_FLAG_DECRYPTED;
+	/* hw will set status->decrypted true, if it finds the
+	 * frame is open data frame or mgmt frame.
+	 * Thus hw will not decrypt robust managment frame
+	 * for IEEE80211w but still set status->decrypted
+	 * true, so here we should set it back to undecrypted
+	 * for IEEE80211w frame, and mac80211 sw will help
+	 * to decrypt it */
+	if (stats->decrypted) {
+		if ((ieee80211_is_robust_mgmt_frame(hdr)) &&
+		    (ieee80211_has_protected(hdr->frame_control)))
+			rx_status->flag &= ~RX_FLAG_DECRYPTED;
+		else
+			rx_status->flag |= RX_FLAG_DECRYPTED;
+	}
 
+	/* rate_idx: index of data rate into band's
+	 * supported rates or MCS index if HT rates
+	 * are in use (RX_FLAG_HT)*/
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
 				(bool)GET_RX_DESC_RXHT(pdesc),
 				(u8)GET_RX_DESC_RXMCS(pdesc),
-- 
1.7.10.4

