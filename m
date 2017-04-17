Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34284 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932452AbdDQALh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:37 -0400
Received: by mail-oi0-f65.google.com with SMTP id t14so15969531oif.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:37 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 22/27] rtlwifi: btcoex: 23b 1ant: Add coex_table_type to log
Date: Sun, 16 Apr 2017 19:11:06 -0500
Message-Id: <20170417001111.29384-23-Larry.Finger@lwfinger.net> (sfid-20170417_021158_098800_2CD53868)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Display coex_table_type in log.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 5 +++++
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index b41a338478aa..8a1fe5c75d4f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -541,6 +541,8 @@ static void halbtc8723b1ant_coex_table(struct btc_coexist *btcoexist,
 static void halbtc8723b1ant_coex_table_with_type(struct btc_coexist *btcoexist,
 						 bool force_exec, u8 type)
 {
+	coex_sta->coex_table_type = type;
+
 	switch (type) {
 	case 0:
 		halbtc8723b1ant_coex_table(btcoexist, force_exec, 0x55555555,
@@ -2493,6 +2495,9 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 			   coex_dm->error_condition);
 	}
 
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d",
+		 "Coex Table Type", coex_sta->coex_table_type);
+
 	/* Hw setting */
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
 		 "============[Hw setting]============");
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index fca78bc7a945..36e0a6b5ec58 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -174,6 +174,7 @@ struct coex_sta_8723b_1ant {
 	u8 bt_info_ext;
 	u8 scan_ap_num;
 	bool cck_ever_lock;
+	u8 coex_table_type;
 	bool force_lps_on;
 	u32 pop_event_cnt;
 
-- 
2.12.0
