Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35019 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756597AbdDPTEs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 15:04:48 -0400
Received: by mail-oi0-f66.google.com with SMTP id a21so8126927oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 12:04:48 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/10] rtlwifi: btcoex: 21a 2ant: remove unused antenna detection variables
Date: Sun, 16 Apr 2017 14:04:28 -0500
Message-Id: <20170416190428.23857-11-Larry.Finger@lwfinger.net> (sfid-20170416_210453_612620_11E4BF89)
In-Reply-To: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
References: <20170416190428.23857-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

PSD and LNA are for antenna detection, but we do not use them for 8821A.
Remove them and the corresponding display messages.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 13 -------------
 .../wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  4 ----
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index e61016f660a8..3b4c892fc233 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3747,14 +3747,6 @@ void ex_btc8821a2ant_display_coex_info(struct btc_coexist *btcoexist)
 		    ((BTC_WIFI_TRAFFIC_TX == wifi_traffic_dir) ?
 		     "uplink" : "downlink")));
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "\r\n %-35s = [%s/ %d/ %d] ", "BT [status/ rssi/ retryCnt]",
-		   ((coex_sta->c2h_bt_inquiry_page) ? ("inquiry/page scan") :
-		    ((BT_8821A_2ANT_BT_STATUS_IDLE == coex_dm->bt_status)
-		     ? "idle" : ((BT_8821A_2ANT_BT_STATUS_CON_IDLE ==
-		     coex_dm->bt_status) ? "connected-idle" : "busy"))),
-		    coex_sta->bt_rssi, coex_sta->bt_retry_cnt);
-
 	if (stack_info->profile_notified) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 			 "\r\n %-35s = %d / %d / %d / %d", "SCO/HID/PAN/A2DP",
@@ -3790,11 +3782,6 @@ void ex_btc8821a2ant_display_coex_info(struct btc_coexist *btcoexist)
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
 		 "============[Sw mechanism]============");
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "\r\n %-35s = %d/ %d/ %d/ %d ",
-		 "SM1[ShRf/ LpRA/ LimDig/ btLna]",
-		 coex_dm->cur_rf_rx_lpf_shrink, coex_dm->cur_low_penalty_ra,
-		 coex_dm->limited_dig, coex_dm->cur_bt_lna_constrain);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		 "\r\n %-35s = %d/ %d/ %d(0x%x) ",
 		 "SM2[AgcT/ AdcB/ SwDacSwing(lvl)]",
 		 coex_dm->cur_agc_table_en, coex_dm->cur_adc_back_off,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index 74edfd75875a..a1603e2d44e3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -79,10 +79,6 @@ struct coex_dm_8821a_2ant {
 	/* fw mechanism */
 	bool		pre_dec_bt_pwr_lvl;
 	bool		cur_dec_bt_pwr_lvl;
-	bool		pre_bt_lna_constrain;
-	bool		cur_bt_lna_constrain;
-	u8		pre_bt_psd_mode;
-	u8		cur_bt_psd_mode;
 	u8		pre_fw_dac_swing_lvl;
 	u8		cur_fw_dac_swing_lvl;
 	bool		cur_ignore_wlan_act;
-- 
2.12.0
