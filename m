Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33033 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdDCBOf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Apr 2017 21:14:35 -0400
Received: by mail-oi0-f68.google.com with SMTP id f193so17404129oib.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Apr 2017 18:14:35 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 04/12] rtlwifi: btcoex: 23b 2ant: detect if bt is slave, and modify tdma
Date: Sun,  2 Apr 2017 20:14:14 -0500
Message-Id: <20170403011428.6156-4-Larry.Finger@lwfinger.net> (sfid-20170403_031453_472924_A3E0BA72)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

if the bt is slave, it may receive packet at any time, so we
need to mark them as high priority packets to avoid packet loss.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - No changes.
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 91 +++++++++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  1 +
 2 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index fe4af218ff18..1361788cf150 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -266,6 +266,7 @@ void btc8723b2ant_limited_rx(struct btc_coexist *btcoexist, bool force_exec,
 static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0;
 	u32 reg_lp_tx = 0, reg_lp_rx = 0;
@@ -286,6 +287,17 @@ static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 	coex_sta->low_priority_tx = reg_lp_tx;
 	coex_sta->low_priority_rx = reg_lp_rx;
 
+	if ((coex_sta->low_priority_tx > 1050) &&
+	    (!coex_sta->c2h_bt_inquiry_page))
+		coex_sta->pop_event_cnt++;
+
+	if ((coex_sta->low_priority_rx >= 950) &&
+	    (coex_sta->low_priority_rx >= coex_sta->low_priority_tx) &&
+	    (!coex_sta->under_ips))
+		bt_link_info->slave_role = true;
+	else
+		bt_link_info->slave_role = false;
+
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], High Priority Tx/Rx(reg 0x%x)=0x%x(%d)/0x%x(%d)\n",
 		 reg_hp_txrx, reg_hp_tx, reg_hp_tx, reg_hp_rx, reg_hp_rx);
@@ -1084,6 +1096,8 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 				 bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	u8 tdma_byte4_modify = 0x0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn %s PS TDMA, type=%d\n",
@@ -1104,75 +1118,92 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 		    (coex_dm->pre_ps_tdma == coex_dm->cur_ps_tdma))
 			return;
 	}
+
+	if ((bt_link_info->slave_role) && (bt_link_info->a2dp_exist))
+		/* 0x778 = 0x1 at wifi slot (no blocking BT Low-Pri pkts) */
+		tdma_byte4_modify = 0x1;
+
 	if (turn_on) {
 		switch (type) {
 		case 1:
 		default:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x3c,
+				0x03, 0xf1, 0x90 | tdma_byte4_modify);
 			break;
 		case 2:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0xe1, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x2d,
+				0x03, 0xf1, 0x90 | tdma_byte4_modify);
 			break;
 		case 3:
-			/* This call breaks BT when wireless is active -
-			 * comment it out for now until a better fix is found:
-			 * btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
-			 *			    0x3, 0xf1, 0x90);
-			 */
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
+						    0x3, 0xf1,
+						    0x90 | tdma_byte4_modify);
 			break;
 		case 4:
 			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x10,
-						    0x03, 0xf1, 0x90);
+						    0x03, 0xf1,
+						    0x90 | tdma_byte4_modify);
 			break;
 		case 5:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0x60, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x3c,
+				0x3, 0x70, 0x90 | tdma_byte4_modify);
 			break;
 		case 6:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0x60, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x2d,
+				0x3, 0x70, 0x90 | tdma_byte4_modify);
 			break;
 		case 7:
 			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
-						    0x3, 0x70, 0x90);
+						    0x3, 0x70,
+						    0x90 | tdma_byte4_modify);
 			break;
 		case 8:
 			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xa3, 0x10,
-						    0x3, 0x70, 0x90);
+						    0x3, 0x70,
+						    0x90 | tdma_byte4_modify);
 			break;
 		case 9:
 			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
 						    0x1a, 0xe1, 0x90);
 			break;
 		case 10:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0xe1, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x2d,
+				0x03, 0xf1, 0x90 | tdma_byte4_modify);
 			break;
 		case 11:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0xa,
-						    0xa, 0xe1, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
+						    0x3, 0xf1,
+						    0x90 | tdma_byte4_modify);
 			break;
 		case 12:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
-						    0x5, 0xe1, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x10,
+						    0x3, 0xf1,
+						    0x90 | tdma_byte4_modify);
 			break;
 		case 13:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0x60, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x3c,
+				0x3, 0x70, 0x90 | tdma_byte4_modify);
 			break;
 		case 14:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0x60, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(
+				btcoexist, 0xe3, 0x2d,
+				0x3, 0x70, 0x90 | tdma_byte4_modify);
 			break;
 		case 15:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0xa,
-						    0xa, 0x60, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
+						    0x3, 0x70,
+						    0x90 | tdma_byte4_modify);
 			break;
 		case 16:
-			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
-						    0x5, 0x60, 0x90);
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x10,
+						    0x3, 0x70,
+						    0x90 | tdma_byte4_modify);
 			break;
 		case 17:
 			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xa3, 0x2f,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index f74864f54edb..d7ba6ad1e66f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -459,6 +459,7 @@ struct btc_bt_link_info {
 	bool hid_only;
 	bool pan_exist;
 	bool pan_only;
+	bool slave_role;
 };
 
 enum btc_antenna_pos {
-- 
2.12.0
