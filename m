Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1FJQF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 12:05:26 -0400
Date: Fri, 10 Jun 2011 11:05:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix warnings on parisc arch
Message-ID: <4df240c3.BgRQeXajX5EsNump%Larry.Finger@lwfinger.net> (sfid-20110610_180531_491323_FED6033A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In "Build regressions/improvements in v3.0-rc2", Geert Uytterhoeven
reports a number of warnings that occur for parisc builds of rtlwifi
and dependents.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This material is for 3.0, but it is not of high priority. None
of these warnings are indications of an actual bug.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -516,7 +516,7 @@ static u8 _rtl92se_rf_onoff_detect(struc
 	mdelay(10);
 
 	/* check GPIO3 */
-	u1tmp = rtl_read_byte(rtlpriv, GPIO_IN);
+	u1tmp = rtl_read_byte(rtlpriv, GPIO_IN_SE);
 	retval = (u1tmp & HAL_8192S_HW_GPIO_OFF_BIT) ? ERFON : ERFOFF;
 
 	return retval;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/reg.h
@@ -248,12 +248,8 @@
 #define	PSTIME					0x02E0
 #define	TIMER0					0x02E4
 #define	TIMER1					0x02E8
-#define	GPIO_CTRL				0x02EC
-#define	GPIO_IN					0x02EC
-#define	GPIO_OUT				0x02ED
+#define	GPIO_IN_SE				0x02EC
 #define	GPIO_IO_SEL				0x02EE
-#define	GPIO_MOD				0x02EF
-#define	GPIO_INTCTRL				0x02F0
 #define	MAC_PINMUX_CFG				0x02F1
 #define	LEDCFG					0x02F2
 #define	PHY_REG					0x02F3
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
@@ -650,7 +650,7 @@ static void rtl_op_bss_info_changed(stru
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 ("BSS_CHANGED_HT\n"));
 		rcu_read_lock();
-		sta = get_sta(hw, vif, (u8 *)bss_conf->bssid);
+		sta = get_sta(hw, vif, bss_conf->bssid);
 		if (sta) {
 			if (sta->ht_cap.ampdu_density >
 			    mac->current_ampdu_density)
@@ -685,7 +685,7 @@ static void rtl_op_bss_info_changed(stru
 		rtlpriv->cfg->ops->set_network_type(hw, vif->type);
 
 		rcu_read_lock();
-		sta = get_sta(hw, vif, (u8 *)bss_conf->bssid);
+		sta = get_sta(hw, vif, bss_conf->bssid);
 		if (!sta) {
 			rcu_read_unlock();
 			goto out;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -670,7 +670,7 @@ static void rtl92c_dm_txpower_tracking_c
 	u8 ofdm_index[2], cck_index = 0, ofdm_index_old[2], cck_index_old = 0;
 	int i;
 	bool is2t = IS_92C_SERIAL(rtlhal->version);
-	u8 txpwr_level[2] = {0, 0};
+	s8 txpwr_level[2] = {0, 0};
 	u8 ofdm_min_index = 6, rf;
 
 	rtlpriv->dm.txpower_trackinginit = true;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -225,7 +225,7 @@ static void _rtl92ce_query_rxphystatus(s
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct phy_sts_cck_8192s_t *cck_buf;
-	s8 rx_pwr_all, rx_pwr[4];
+	s8 rx_pwr_all = 0, rx_pwr[4];
 	u8 evm, pwdb_all, rf_rx_num = 0;
 	u8 i, max_spatial_stream;
 	u32 rssi, total_rssi = 0;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/wifi.h
@@ -1980,7 +1980,7 @@ static inline u16 rtl_get_tid(struct sk_
 
 static inline struct ieee80211_sta *get_sta(struct ieee80211_hw *hw,
 					    struct ieee80211_vif *vif,
-					    u8 *bssid)
+					    const u8 *bssid)
 {
 	return ieee80211_find_sta(vif, bssid);
 }
