Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35239 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbdDJQXY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:24 -0400
Received: by mail-oi0-f66.google.com with SMTP id g204so13131313oib.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 04/14] rtlwifi: btcoex: 21a 1ant: mask profile bit for connect-ilde
Date: Mon, 10 Apr 2017 11:23:00 -0500
Message-Id: <20170410162310.7515-5-Larry.Finger@lwfinger.net> (sfid-20170410_182336_319340_5794A223)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Mask out the connect-idle bit.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 3a117eaf1b21..88bf70f27669 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2606,7 +2606,12 @@ void ex_btc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 	btc8821a1ant_update_bt_link_info(btcoexist);
 
-	if (!(bt_info&BT_INFO_8821A_1ANT_B_CONNECTION)) {
+	/* mask profile bit for connect-ilde identification
+	 * (for CSR case: A2DP idle --> 0x41)
+	 */
+	bt_info = bt_info & 0x1f;
+
+	if (!(bt_info & BT_INFO_8821A_1ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
-- 
2.12.0
