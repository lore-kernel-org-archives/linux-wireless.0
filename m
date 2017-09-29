Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:45731 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbdI2TsO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 15:48:14 -0400
Received: by mail-oi0-f68.google.com with SMTP id f3so1108097oia.2
        for <linux-wireless@vger.kernel.org>; Fri, 29 Sep 2017 12:48:14 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/10] rtlwifi: Add RSSI and RF type to wifi.h for phydm
Date: Fri, 29 Sep 2017 14:47:57 -0500
Message-Id: <20170929194800.15617-8-Larry.Finger@lwfinger.net> (sfid-20170929_214818_117929_BD885E2B)
In-Reply-To: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
References: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

These definition will be used by phydm later.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index ceeca79acc56..5843aee5c921 100644
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
2.13.5
