Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671Ab1DYRxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:53:39 -0400
Date: Mon, 25 Apr 2011 12:53:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/18] rtlwifi: rtl8192c-common: Convert common dynamic
 management routines for addition of rtl8192se and rtl8192de
Message-ID: <4db5b51f.ghQtUk0byIufUEPx%Larry.Finger@lwfinger.net> (sfid-20110425_195342_570037_57D68F67)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Convert common dynamic management routines for addition of RTL8192SE
and RTL8192DE code.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 dm_common.c |  468 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 dm_common.h |    4 
 2 files changed, 451 insertions(+), 21 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -28,10 +28,26 @@
  *****************************************************************************/
 
 #include "dm_common.h"
+#include "phy_common.h"
+#include "../pci.h"
+#include "../base.h"
 
 struct dig_t dm_digtable;
 static struct ps_t dm_pstable;
 
+#define BT_RSSI_STATE_NORMAL_POWER	BIT_OFFSET_LEN_MASK_32(0, 1)
+#define BT_RSSI_STATE_AMDPU_OFF		BIT_OFFSET_LEN_MASK_32(1, 1)
+#define BT_RSSI_STATE_SPECIAL_LOW	BIT_OFFSET_LEN_MASK_32(2, 1)
+#define BT_RSSI_STATE_BG_EDCA_LOW	BIT_OFFSET_LEN_MASK_32(3, 1)
+#define BT_RSSI_STATE_TXPOWER_LOW	BIT_OFFSET_LEN_MASK_32(4, 1)
+
+#define RTLPRIV			(struct rtl_priv *)
+#define GET_UNDECORATED_AVERAGE_RSSI(_priv)	\
+	((RTLPRIV(_priv))->mac80211.opmode == \
+			     NL80211_IFTYPE_ADHOC) ?	\
+	((RTLPRIV(_priv))->dm.entry_min_undecoratedsmoothed_pwdb) : \
+	((RTLPRIV(_priv))->dm.undecorated_smoothed_pwdb)
+
 static const u32 ofdmswing_table[OFDM_TABLE_SIZE] = {
 	0x7f8001fe,
 	0x788001e2,
@@ -461,10 +477,7 @@ static void rtl92c_dm_ctrl_initgain_by_t
 	if (mac->act_scanning == true)
 		return;
 
-	if ((mac->link_state > MAC80211_NOLINK) &&
-	    (mac->link_state < MAC80211_LINKED))
-		dm_digtable.cursta_connectctate = DIG_STA_BEFORE_CONNECT;
-	else if (mac->link_state >= MAC80211_LINKED)
+	if (mac->link_state >= MAC80211_LINKED)
 		dm_digtable.cursta_connectctate = DIG_STA_CONNECT;
 	else
 		dm_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
@@ -562,23 +575,42 @@ EXPORT_SYMBOL(rtl92c_dm_init_edca_turbo)
 static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+
 	static u64 last_txok_cnt;
 	static u64 last_rxok_cnt;
-	u64 cur_txok_cnt;
-	u64 cur_rxok_cnt;
+	static u32 last_bt_edca_ul;
+	static u32 last_bt_edca_dl;
+	u64 cur_txok_cnt = 0;
+	u64 cur_rxok_cnt = 0;
 	u32 edca_be_ul = 0x5ea42b;
 	u32 edca_be_dl = 0x5ea42b;
+	bool bt_change_edca = false;
 
-	if (mac->opmode == NL80211_IFTYPE_ADHOC)
-		goto dm_checkedcaturbo_exit;
+	if ((last_bt_edca_ul != rtlpcipriv->bt_coexist.bt_edca_ul) ||
+	    (last_bt_edca_dl != rtlpcipriv->bt_coexist.bt_edca_dl)) {
+		rtlpriv->dm.current_turbo_edca = false;
+		last_bt_edca_ul = rtlpcipriv->bt_coexist.bt_edca_ul;
+		last_bt_edca_dl = rtlpcipriv->bt_coexist.bt_edca_dl;
+	}
+
+	if (rtlpcipriv->bt_coexist.bt_edca_ul != 0) {
+		edca_be_ul = rtlpcipriv->bt_coexist.bt_edca_ul;
+		bt_change_edca = true;
+	}
+
+	if (rtlpcipriv->bt_coexist.bt_edca_dl != 0) {
+		edca_be_ul = rtlpcipriv->bt_coexist.bt_edca_dl;
+		bt_change_edca = true;
+	}
 
 	if (mac->link_state != MAC80211_LINKED) {
 		rtlpriv->dm.current_turbo_edca = false;
 		return;
 	}
 
-	if (!mac->ht_enable) {	/*FIX MERGE */
+	if ((!mac->ht_enable) && (!rtlpcipriv->bt_coexist.bt_coexistence)) {
 		if (!(edca_be_ul & 0xffff0000))
 			edca_be_ul |= 0x005e0000;
 
@@ -586,10 +618,12 @@ static void rtl92c_dm_check_edca_turbo(s
 			edca_be_dl |= 0x005e0000;
 	}
 
-	if ((!rtlpriv->dm.is_any_nonbepkts) &&
-	    (!rtlpriv->dm.disable_framebursting)) {
+	if ((bt_change_edca) || ((!rtlpriv->dm.is_any_nonbepkts) &&
+	     (!rtlpriv->dm.disable_framebursting))) {
+
 		cur_txok_cnt = rtlpriv->stats.txbytesunicast - last_txok_cnt;
 		cur_rxok_cnt = rtlpriv->stats.rxbytesunicast - last_rxok_cnt;
+
 		if (cur_rxok_cnt > 4 * cur_txok_cnt) {
 			if (!rtlpriv->dm.is_cur_rdlstate ||
 			    !rtlpriv->dm.current_turbo_edca) {
@@ -618,7 +652,6 @@ static void rtl92c_dm_check_edca_turbo(s
 		}
 	}
 
-dm_checkedcaturbo_exit:
 	rtlpriv->dm.is_any_nonbepkts = false;
 	last_txok_cnt = rtlpriv->stats.txbytesunicast;
 	last_rxok_cnt = rtlpriv->stats.rxbytesunicast;
@@ -633,7 +666,7 @@ static void rtl92c_dm_txpower_tracking_c
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 thermalvalue, delta, delta_lck, delta_iqk;
 	long ele_a, ele_d, temp_cck, val_x, value32;
-	long val_y, ele_c;
+	long val_y, ele_c = 0;
 	u8 ofdm_index[2], cck_index = 0, ofdm_index_old[2], cck_index_old = 0;
 	int i;
 	bool is2t = IS_92C_SERIAL(rtlhal->version);
@@ -683,7 +716,6 @@ static void rtl92c_dm_txpower_tracking_c
 			for (i = 0; i < OFDM_TABLE_LENGTH; i++) {
 				if (ele_d == (ofdmswing_table[i] &
 				    MASKOFDM_D)) {
-					ofdm_index_old[1] = (u8) i;
 
 					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
 					   DBG_LOUD,
@@ -1132,6 +1164,7 @@ static void rtl92c_dm_refresh_rate_adapt
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rate_adaptive *p_ra = &(rtlpriv->ra);
 	u32 low_rssithresh_for_ra, high_rssithresh_for_ra;
+	struct ieee80211_sta *sta = NULL;
 
 	if (is_hal_stop(rtlhal)) {
 		RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
@@ -1145,8 +1178,8 @@ static void rtl92c_dm_refresh_rate_adapt
 		return;
 	}
 
-	if (mac->link_state == MAC80211_LINKED) {
-
+	if (mac->link_state == MAC80211_LINKED &&
+	    mac->opmode == NL80211_IFTYPE_STATION) {
 		switch (p_ra->pre_ratr_state) {
 		case DM_RATR_STA_HIGH:
 			high_rssithresh_for_ra = 50;
@@ -1185,10 +1218,13 @@ static void rtl92c_dm_refresh_rate_adapt
 				 ("PreState = %d, CurState = %d\n",
 				  p_ra->pre_ratr_state, p_ra->ratr_state));
 
-			rtlpriv->cfg->ops->update_rate_mask(hw,
+			rcu_read_lock();
+			sta = ieee80211_find_sta(mac->vif, mac->bssid);
+			rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
 					p_ra->ratr_state);
 
 			p_ra->pre_ratr_state = p_ra->ratr_state;
+			rcu_read_unlock();
 		}
 	}
 }
@@ -1202,7 +1238,7 @@ static void rtl92c_dm_init_dynamic_bb_po
 	dm_pstable.rssi_val_min = 0;
 }
 
-static void rtl92c_dm_1r_cca(struct ieee80211_hw *hw)
+void rtl92c_dm_1r_cca(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -1352,7 +1388,9 @@ static void rtl92c_dm_dynamic_bb_powersa
 	}
 
 	if (IS_92C_SERIAL(rtlhal->version))
-		rtl92c_dm_1r_cca(hw);
+		;/* rtl92c_dm_1r_cca(hw); */
+	else
+		rtl92c_dm_rf_saving(hw, false);
 }
 
 void rtl92c_dm_init(struct ieee80211_hw *hw)
@@ -1369,6 +1407,84 @@ void rtl92c_dm_init(struct ieee80211_hw
 }
 EXPORT_SYMBOL(rtl92c_dm_init);
 
+void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	long undecorated_smoothed_pwdb;
+
+	if (!rtlpriv->dm.dynamic_txpower_enable)
+		return;
+
+	if (rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) {
+		rtlpriv->dm.dynamic_txhighpower_lvl = TXHIGHPWRLEVEL_NORMAL;
+		return;
+	}
+
+	if ((mac->link_state < MAC80211_LINKED) &&
+	    (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb == 0)) {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
+			 ("Not connected to any\n"));
+
+		rtlpriv->dm.dynamic_txhighpower_lvl = TXHIGHPWRLEVEL_NORMAL;
+
+		rtlpriv->dm.last_dtp_lvl = TXHIGHPWRLEVEL_NORMAL;
+		return;
+	}
+
+	if (mac->link_state >= MAC80211_LINKED) {
+		if (mac->opmode == NL80211_IFTYPE_ADHOC) {
+			undecorated_smoothed_pwdb =
+			    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				 ("AP Client PWDB = 0x%lx\n",
+				  undecorated_smoothed_pwdb));
+		} else {
+			undecorated_smoothed_pwdb =
+			    rtlpriv->dm.undecorated_smoothed_pwdb;
+			RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+				 ("STA Default Port PWDB = 0x%lx\n",
+				  undecorated_smoothed_pwdb));
+		}
+	} else {
+		undecorated_smoothed_pwdb =
+		    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
+
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 ("AP Ext Port PWDB = 0x%lx\n",
+			  undecorated_smoothed_pwdb));
+	}
+
+	if (undecorated_smoothed_pwdb >= TX_POWER_NEAR_FIELD_THRESH_LVL2) {
+		rtlpriv->dm.dynamic_txhighpower_lvl = TXHIGHPWRLEVEL_LEVEL1;
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 ("TXHIGHPWRLEVEL_LEVEL1 (TxPwr=0x0)\n"));
+	} else if ((undecorated_smoothed_pwdb <
+		    (TX_POWER_NEAR_FIELD_THRESH_LVL2 - 3)) &&
+		   (undecorated_smoothed_pwdb >=
+		    TX_POWER_NEAR_FIELD_THRESH_LVL1)) {
+
+		rtlpriv->dm.dynamic_txhighpower_lvl = TXHIGHPWRLEVEL_LEVEL1;
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 ("TXHIGHPWRLEVEL_LEVEL1 (TxPwr=0x10)\n"));
+	} else if (undecorated_smoothed_pwdb <
+		   (TX_POWER_NEAR_FIELD_THRESH_LVL1 - 5)) {
+		rtlpriv->dm.dynamic_txhighpower_lvl = TXHIGHPWRLEVEL_NORMAL;
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 ("TXHIGHPWRLEVEL_NORMAL\n"));
+	}
+
+	if ((rtlpriv->dm.dynamic_txhighpower_lvl != rtlpriv->dm.last_dtp_lvl)) {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 ("PHY_SetTxPowerLevel8192S() Channel = %d\n",
+			  rtlphy->current_channel));
+		rtl92c_phy_set_txpower_level(hw, rtlphy->current_channel);
+	}
+
+	rtlpriv->dm.last_dtp_lvl = rtlpriv->dm.dynamic_txhighpower_lvl;
+}
+
 void rtl92c_dm_watchdog(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -1388,11 +1504,321 @@ void rtl92c_dm_watchdog(struct ieee80211
 		rtl92c_dm_dig(hw);
 		rtl92c_dm_false_alarm_counter_statistics(hw);
 		rtl92c_dm_dynamic_bb_powersaving(hw);
-		rtlpriv->cfg->ops->dm_dynamic_txpower(hw);
+		rtl92c_dm_dynamic_txpower(hw);
 		rtl92c_dm_check_txpower_tracking(hw);
 		rtl92c_dm_refresh_rate_adaptive_mask(hw);
+		rtl92c_dm_bt_coexist(hw);
 		rtl92c_dm_check_edca_turbo(hw);
-
 	}
 }
 EXPORT_SYMBOL(rtl92c_dm_watchdog);
+
+static u8 rtl92c_bt_rssi_state_change(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+	long undecorated_smoothed_pwdb;
+	u8 curr_bt_rssi_state = 0x00;
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
+		undecorated_smoothed_pwdb =
+				 GET_UNDECORATED_AVERAGE_RSSI(rtlpriv);
+	} else {
+		if (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb == 0)
+			undecorated_smoothed_pwdb = 100;
+		else
+			undecorated_smoothed_pwdb =
+				rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
+	}
+
+	/* Check RSSI to determine HighPower/NormalPower state for
+	 * BT coexistence. */
+	if (undecorated_smoothed_pwdb >= 67)
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_NORMAL_POWER);
+	else if (undecorated_smoothed_pwdb < 62)
+		curr_bt_rssi_state |= BT_RSSI_STATE_NORMAL_POWER;
+
+	/* Check RSSI to determine AMPDU setting for BT coexistence. */
+	if (undecorated_smoothed_pwdb >= 40)
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_AMDPU_OFF);
+	else if (undecorated_smoothed_pwdb <= 32)
+		curr_bt_rssi_state |= BT_RSSI_STATE_AMDPU_OFF;
+
+	/* Marked RSSI state. It will be used to determine BT coexistence
+	 * setting later. */
+	if (undecorated_smoothed_pwdb < 35)
+		curr_bt_rssi_state |=  BT_RSSI_STATE_SPECIAL_LOW;
+	else
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_SPECIAL_LOW);
+
+	/* Set Tx Power according to BT status. */
+	if (undecorated_smoothed_pwdb >= 30)
+		curr_bt_rssi_state |=  BT_RSSI_STATE_TXPOWER_LOW;
+	else if (undecorated_smoothed_pwdb < 25)
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_TXPOWER_LOW);
+
+	/* Check BT state related to BT_Idle in B/G mode. */
+	if (undecorated_smoothed_pwdb < 15)
+		curr_bt_rssi_state |=  BT_RSSI_STATE_BG_EDCA_LOW;
+	else
+		curr_bt_rssi_state &= (~BT_RSSI_STATE_BG_EDCA_LOW);
+
+	if (curr_bt_rssi_state != rtlpcipriv->bt_coexist.bt_rssi_state) {
+		rtlpcipriv->bt_coexist.bt_rssi_state = curr_bt_rssi_state;
+		return true;
+	} else {
+		return false;
+	}
+}
+
+static bool rtl92c_bt_state_change(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	u32 polling, ratio_tx, ratio_pri;
+	u32 bt_tx, bt_pri;
+	u8 bt_state;
+	u8 cur_service_type;
+
+	if (rtlpriv->mac80211.link_state < MAC80211_LINKED)
+		return false;
+
+	bt_state = rtl_read_byte(rtlpriv, 0x4fd);
+	bt_tx = rtl_read_dword(rtlpriv, 0x488);
+	bt_tx = bt_tx & 0x00ffffff;
+	bt_pri = rtl_read_dword(rtlpriv, 0x48c);
+	bt_pri = bt_pri & 0x00ffffff;
+	polling = rtl_read_dword(rtlpriv, 0x490);
+
+	if (bt_tx == 0xffffffff && bt_pri == 0xffffffff &&
+	    polling == 0xffffffff && bt_state == 0xff)
+		return false;
+
+	bt_state &= BIT_OFFSET_LEN_MASK_32(0, 1);
+	if (bt_state != rtlpcipriv->bt_coexist.bt_cur_state) {
+		rtlpcipriv->bt_coexist.bt_cur_state = bt_state;
+
+		if (rtlpcipriv->bt_coexist.reg_bt_sco == 3) {
+			rtlpcipriv->bt_coexist.bt_service = BT_IDLE;
+
+			bt_state = bt_state |
+			  ((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+			  0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
+			  BIT_OFFSET_LEN_MASK_32(2, 1);
+			rtl_write_byte(rtlpriv, 0x4fd, bt_state);
+		}
+		return true;
+	}
+
+	ratio_tx = bt_tx * 1000 / polling;
+	ratio_pri = bt_pri * 1000 / polling;
+	rtlpcipriv->bt_coexist.ratio_tx = ratio_tx;
+	rtlpcipriv->bt_coexist.ratio_pri = ratio_pri;
+
+	if (bt_state && rtlpcipriv->bt_coexist.reg_bt_sco == 3) {
+
+		if ((ratio_tx < 30)  && (ratio_pri < 30))
+			cur_service_type = BT_IDLE;
+		else if ((ratio_pri > 110) && (ratio_pri < 250))
+			cur_service_type = BT_SCO;
+		else if ((ratio_tx >= 200) && (ratio_pri >= 200))
+			cur_service_type = BT_BUSY;
+		else if ((ratio_tx >= 350) && (ratio_tx < 500))
+			cur_service_type = BT_OTHERBUSY;
+		else if (ratio_tx >= 500)
+			cur_service_type = BT_PAN;
+		else
+			cur_service_type = BT_OTHER_ACTION;
+
+		if (cur_service_type != rtlpcipriv->bt_coexist.bt_service) {
+			rtlpcipriv->bt_coexist.bt_service = cur_service_type;
+			bt_state = bt_state |
+			   ((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+			   0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
+			   ((rtlpcipriv->bt_coexist.bt_service != BT_IDLE) ?
+			   0 : BIT_OFFSET_LEN_MASK_32(2, 1));
+
+			/* Add interrupt migration when bt is not ini
+			 * idle state (no traffic). */
+			if (rtlpcipriv->bt_coexist.bt_service != BT_IDLE) {
+				rtl_write_word(rtlpriv, 0x504, 0x0ccc);
+				rtl_write_byte(rtlpriv, 0x506, 0x54);
+				rtl_write_byte(rtlpriv, 0x507, 0x54);
+			} else {
+				rtl_write_byte(rtlpriv, 0x506, 0x00);
+				rtl_write_byte(rtlpriv, 0x507, 0x00);
+			}
+
+			rtl_write_byte(rtlpriv, 0x4fd, bt_state);
+			return true;
+		}
+	}
+
+	return false;
+
+}
+
+static bool rtl92c_bt_wifi_connect_change(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	static bool media_connect;
+
+	if (rtlpriv->mac80211.link_state < MAC80211_LINKED) {
+		media_connect = false;
+	} else {
+		if (!media_connect) {
+			media_connect = true;
+			return true;
+		}
+		media_connect = true;
+	}
+
+	return false;
+}
+
+static void rtl92c_bt_set_normal(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+
+	if (rtlpcipriv->bt_coexist.bt_service == BT_OTHERBUSY) {
+		rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea72b;
+		rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea72b;
+	} else if (rtlpcipriv->bt_coexist.bt_service == BT_BUSY) {
+		rtlpcipriv->bt_coexist.bt_edca_ul = 0x5eb82f;
+		rtlpcipriv->bt_coexist.bt_edca_dl = 0x5eb82f;
+	} else if (rtlpcipriv->bt_coexist.bt_service == BT_SCO) {
+		if (rtlpcipriv->bt_coexist.ratio_tx > 160) {
+			rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea72f;
+			rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea72f;
+		} else {
+			rtlpcipriv->bt_coexist.bt_edca_ul = 0x5ea32b;
+			rtlpcipriv->bt_coexist.bt_edca_dl = 0x5ea42b;
+		}
+	} else {
+		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
+		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+	}
+
+	if ((rtlpcipriv->bt_coexist.bt_service != BT_IDLE) &&
+	     (rtlpriv->mac80211.mode == WIRELESS_MODE_G ||
+	     (rtlpriv->mac80211.mode == (WIRELESS_MODE_G | WIRELESS_MODE_B))) &&
+	     (rtlpcipriv->bt_coexist.bt_rssi_state &
+	     BT_RSSI_STATE_BG_EDCA_LOW)) {
+		rtlpcipriv->bt_coexist.bt_edca_ul = 0x5eb82b;
+		rtlpcipriv->bt_coexist.bt_edca_dl = 0x5eb82b;
+	}
+}
+
+static void rtl92c_bt_ant_isolation(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+
+	/* Only enable HW BT coexist when BT in "Busy" state. */
+	if (rtlpriv->mac80211.vendor == PEER_CISCO &&
+	    rtlpcipriv->bt_coexist.bt_service == BT_OTHER_ACTION) {
+		rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
+	} else {
+		if ((rtlpcipriv->bt_coexist.bt_service == BT_BUSY) &&
+		    (rtlpcipriv->bt_coexist.bt_rssi_state &
+		     BT_RSSI_STATE_NORMAL_POWER)) {
+			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
+		} else if ((rtlpcipriv->bt_coexist.bt_service ==
+			    BT_OTHER_ACTION) && (rtlpriv->mac80211.mode <
+			    WIRELESS_MODE_N_24G) &&
+			    (rtlpcipriv->bt_coexist.bt_rssi_state &
+			    BT_RSSI_STATE_SPECIAL_LOW)) {
+			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
+		} else if (rtlpcipriv->bt_coexist.bt_service == BT_PAN) {
+			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0x00);
+		} else {
+			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0x00);
+		}
+	}
+
+	if (rtlpcipriv->bt_coexist.bt_service == BT_PAN)
+		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x10100);
+	else
+		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x0);
+
+	if (rtlpcipriv->bt_coexist.bt_rssi_state &
+	    BT_RSSI_STATE_NORMAL_POWER) {
+		rtl92c_bt_set_normal(hw);
+	} else {
+		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
+		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+	}
+
+	if (rtlpcipriv->bt_coexist.bt_service != BT_IDLE) {
+		rtlpriv->cfg->ops->set_rfreg(hw,
+				 RF90_PATH_A,
+				 0x1e,
+				 0xf0, 0xf);
+	} else {
+		rtlpriv->cfg->ops->set_rfreg(hw,
+		     RF90_PATH_A, 0x1e, 0xf0,
+		     rtlpcipriv->bt_coexist.bt_rfreg_origin_1e);
+	}
+
+	if (!rtlpriv->dm.dynamic_txpower_enable) {
+		if (rtlpcipriv->bt_coexist.bt_service != BT_IDLE) {
+			if (rtlpcipriv->bt_coexist.bt_rssi_state &
+				BT_RSSI_STATE_TXPOWER_LOW) {
+				rtlpriv->dm.dynamic_txhighpower_lvl =
+							TXHIGHPWRLEVEL_BT2;
+			} else {
+				rtlpriv->dm.dynamic_txhighpower_lvl =
+					TXHIGHPWRLEVEL_BT1;
+			}
+		} else {
+			rtlpriv->dm.dynamic_txhighpower_lvl =
+				TXHIGHPWRLEVEL_NORMAL;
+		}
+		rtl92c_phy_set_txpower_level(hw,
+			rtlpriv->phy.current_channel);
+	}
+}
+
+static void rtl92c_check_bt_change(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	if (rtlpcipriv->bt_coexist.bt_cur_state) {
+		if (rtlpcipriv->bt_coexist.bt_ant_isolation)
+			rtl92c_bt_ant_isolation(hw);
+	} else {
+		rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0x00);
+		rtlpriv->cfg->ops->set_rfreg(hw, RF90_PATH_A, 0x1e, 0xf0,
+				rtlpcipriv->bt_coexist.bt_rfreg_origin_1e);
+
+		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
+		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+	}
+}
+
+void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	bool wifi_connect_change;
+	bool bt_state_change;
+	bool rssi_state_change;
+
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+
+		wifi_connect_change = rtl92c_bt_wifi_connect_change(hw);
+		bt_state_change = rtl92c_bt_state_change(hw);
+		rssi_state_change = rtl92c_bt_rssi_state_change(hw);
+
+		if (wifi_connect_change || bt_state_change || rssi_state_change)
+			rtl92c_check_bt_change(hw);
+	}
+}
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
@@ -200,5 +200,9 @@ void rtl92c_dm_rf_saving(struct ieee8021
 void rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw, char delta);
 void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw);
 void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery);
+void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw);
+void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw);
 
 #endif
+
+
