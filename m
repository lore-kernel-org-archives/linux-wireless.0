Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36493 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754203AbdGCSkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Jul 2017 14:40:53 -0400
Received: by mail-oi0-f68.google.com with SMTP id n2so12756275oig.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jul 2017 11:40:53 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 08/11] rtlwifi: Add RSSI and RF type to wifi.h for phydm
Date: Mon,  3 Jul 2017 13:40:35 -0500
Message-Id: <20170703184038.24669-9-Larry.Finger@lwfinger.net> (sfid-20170703_204104_593593_E0B82BC7)
In-Reply-To: <20170703184038.24669-1-Larry.Finger@lwfinger.net>
References: <20170703184038.24669-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

These definition will be used by phydm later.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 8d8e104507d6..4dbce5f4c2db 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -560,6 +560,11 @@ enum rf_type {
 	RF_1T2R = 1,
 	RF_2T2R = 2,
 	RF_2T2R_GREEN = 3,
+	RF_2T3R = 4,
+	RF_2T4R = 5,
+	RF_3T3R = 6,
+	RF_3T4R = 7,
+	RF_4T4R = 8,
 };
 
 enum ht_channel_width {
@@ -1329,6 +1334,7 @@ struct rtl_sta_info {
 	struct rtl_tid_data tids[MAX_TID_COUNT];
 	/* just used for ap adhoc or mesh*/
 	struct rssi_sta rssi_stat;
+	u8 rssi_level;
 	u16 wireless_mode;
 	u8 ratr_index;
 	u8 mimo_ps;
-- 
2.12.3
