Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1EWBtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:49:53 -0400
Date: Sun, 22 May 2011 20:49:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Message-ID: <4dd9bd3e.wtj56KiDWIzs7RUR%Larry.Finger@lwfinger.net> (sfid-20110523_034956_900446_92C11E3F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 4.6.0 warnings for rtlwifi:

  CC [M]  drivers/net/wireless/rtlwifi/base.o
drivers/net/wireless/rtlwifi/base.c: In function ‘rtl_tx_agg_stop’:
drivers/net/wireless/rtlwifi/base.c:891:23: warning: variable ‘tid_data’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/base.c: In function ‘rtl_tx_agg_oper’:
drivers/net/wireless/rtlwifi/base.c:921:23: warning: variable ‘tid_data’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/efuse.o
drivers/net/wireless/rtlwifi/efuse.c: In function ‘efuse_pg_packet_write’:
drivers/net/wireless/rtlwifi/efuse.c:928:24: warning: variable ‘dataempty’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/efuse.c: In function ‘efuse_get_current_size’:
drivers/net/wireless/rtlwifi/efuse.c:1179:5: warning: variable ‘hoffset’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/ps.o
drivers/net/wireless/rtlwifi/ps.c: In function ‘rtl_ps_set_rf_state’:
drivers/net/wireless/rtlwifi/ps.c:85:19: warning: variable ‘rtstate’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/regd.o
drivers/net/wireless/rtlwifi/regd.c: In function ‘_rtl_dump_channel_map’:
drivers/net/wireless/rtlwifi/regd.c:310:28: warning: variable ‘ch’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/rtlwifi/usb.o
drivers/net/wireless/rtlwifi/usb.c: In function ‘_rtl_usb_transmit’:
drivers/net/wireless/rtlwifi/usb.c:826:21: warning: variable ‘urb_list’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/rtlwifi/usb.c:825:23: warning: variable ‘skb_list’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -888,7 +888,6 @@ int rtl_tx_agg_stop(struct ieee80211_hw
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	struct rtl_tid_data *tid_data;
 	struct rtl_sta_info *sta_entry = NULL;
 
 	if (sta == NULL)
@@ -906,7 +905,6 @@ int rtl_tx_agg_stop(struct ieee80211_hw
 		return -EINVAL;
 
 	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
-	tid_data = &sta_entry->tids[tid];
 	sta_entry->tids[tid].agg.agg_state = RTL_AGG_STOP;
 
 	ieee80211_stop_tx_ba_cb_irqsafe(mac->vif, sta->addr, tid);
@@ -918,7 +916,6 @@ int rtl_tx_agg_oper(struct ieee80211_hw
 		struct ieee80211_sta *sta, u16 tid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_tid_data *tid_data;
 	struct rtl_sta_info *sta_entry = NULL;
 
 	if (sta == NULL)
@@ -936,7 +933,6 @@ int rtl_tx_agg_oper(struct ieee80211_hw
 		return -EINVAL;
 
 	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
-	tid_data = &sta_entry->tids[tid];
 	sta_entry->tids[tid].agg.agg_state = RTL_AGG_OPERATIONAL;
 
 	return 0;
Index: wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/efuse.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/efuse.c
@@ -925,7 +925,7 @@ static int efuse_pg_packet_write(struct
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct pgpkt_struct target_pkt;
 	u8 write_state = PG_STATE_HEADER;
-	int continual = true, dataempty = true, result = true;
+	int continual = true, result = true;
 	u16 efuse_addr = 0;
 	u8 efuse_data;
 	u8 target_word_cnts = 0;
@@ -953,7 +953,6 @@ static int efuse_pg_packet_write(struct
 	       (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES))) {
 
 		if (write_state == PG_STATE_HEADER) {
-			dataempty = true;
 			badworden = 0x0F;
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 				("efuse PG_STATE_HEADER\n"));
@@ -1176,13 +1175,12 @@ static u16 efuse_get_current_size(struct
 {
 	int continual = true;
 	u16 efuse_addr = 0;
-	u8 hoffset, hworden;
+	u8 hworden;
 	u8 efuse_data, word_cnts;
 
 	while (continual && efuse_one_byte_read(hw, efuse_addr, &efuse_data)
 	       && (efuse_addr < EFUSE_MAX_SIZE)) {
 		if (efuse_data != 0xFF) {
-			hoffset = (efuse_data >> 4) & 0x0F;
 			hworden = efuse_data & 0x0F;
 			word_cnts = efuse_calculate_word_cnts(hworden);
 			efuse_addr = efuse_addr + (word_cnts * 2) + 1;
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -82,7 +82,6 @@ bool rtl_ps_set_rf_state(struct ieee8021
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	enum rf_pwrstate rtstate;
 	bool actionallowed = false;
 	u16 rfwait_cnt = 0;
 	unsigned long flag;
@@ -129,8 +128,6 @@ bool rtl_ps_set_rf_state(struct ieee8021
 	}
 
 no_protect:
-	rtstate = ppsc->rfpwr_state;
-
 	switch (state_toset) {
 	case ERFON:
 		ppsc->rfoff_reason &= (~changesource);
Index: wireless-testing/drivers/net/wireless/rtlwifi/regd.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/regd.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/regd.c
@@ -303,22 +303,6 @@ static void _rtl_reg_apply_world_flags(s
 	return;
 }
 
-static void _rtl_dump_channel_map(struct wiphy *wiphy)
-{
-	enum ieee80211_band band;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *ch;
-	unsigned int i;
-
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		if (!wiphy->bands[band])
-			continue;
-		sband = wiphy->bands[band];
-		for (i = 0; i < sband->n_channels; i++)
-			ch = &sband->channels[i];
-	}
-}
-
 static int _rtl_reg_notifier_apply(struct wiphy *wiphy,
 				   struct regulatory_request *request,
 				   struct rtl_regulatory *reg)
@@ -336,8 +320,6 @@ static int _rtl_reg_notifier_apply(struc
 		break;
 	}
 
-	_rtl_dump_channel_map(wiphy);
-
 	return 0;
 }
 

