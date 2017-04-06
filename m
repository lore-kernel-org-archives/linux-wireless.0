Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35613 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755387AbdDFUUN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 16:20:13 -0400
Received: by mail-oi0-f66.google.com with SMTP id d2so8884961oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 13:20:13 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 11/11] rtlwifi: btcoex: 23b 2ant: some hi-prio pkt will cause hid_exist
Date: Thu,  6 Apr 2017 15:19:58 -0500
Message-Id: <20170406201958.25642-12-Larry.Finger@lwfinger.net> (sfid-20170406_222543_540870_B0DB6C1D)
In-Reply-To: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
References: <20170406201958.25642-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Clear the hid_exist flag by monitoring the packet counter.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 1c823a71ce9f..2f3946be4ce2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -4329,6 +4329,7 @@ void ex_btc8723b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], ==========================Periodical===========================\n");
@@ -4352,6 +4353,13 @@ void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 	btc8723b2ant_monitor_bt_ctr(btcoexist);
 	btc8723b2ant_monitor_wifi_ctr(btcoexist);
 
+	/* for some BT speakers that High-Priority pkts appear before
+	 * playing, this will cause HID exist
+	 */
+	if ((coex_sta->high_priority_tx + coex_sta->high_priority_rx < 50) &&
+	    (bt_link_info->hid_exist))
+		bt_link_info->hid_exist = false;
+
 	if (btc8723b2ant_is_wifi_status_changed(btcoexist) ||
 	    coex_dm->auto_tdma_adjust)
 		btc8723b2ant_run_coexist_mechanism(btcoexist);
-- 
2.12.0
