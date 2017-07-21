Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36289 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdGUEYv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:51 -0400
Received: by mail-oi0-f67.google.com with SMTP id c135so3403539oih.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/10] rtlwifi: define radio_mask for RF, and extend bw
Date: Thu, 20 Jul 2017 23:24:32 -0500
Message-Id: <20170721042440.15839-3-Larry.Finger@lwfinger.net> (sfid-20170721_062517_832251_C7414D75)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add rf mask definition (0x01, 0x02, 0x04, ...). which differ from the
rf path definition (0, 1, 2, ...). These masks will soon be needed in
the driver code, and it is cheaper to create them at compile time.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 55fe365418be..42e77e07bbb3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -277,6 +277,13 @@ enum radio_path {
 	RF90_PATH_D = 3,
 };
 
+enum radio_mask {
+	RF_MASK_A = BIT(0),
+	RF_MASK_B = BIT(1),
+	RF_MASK_C = BIT(2),
+	RF_MASK_D = BIT(3),
+};
+
 enum regulation_txpwr_lmt {
 	TXPWR_LMT_FCC = 0,
 	TXPWR_LMT_MKK = 1,
@@ -570,6 +577,7 @@ enum ht_channel_width {
 	HT_CHANNEL_WIDTH_20 = 0,
 	HT_CHANNEL_WIDTH_20_40 = 1,
 	HT_CHANNEL_WIDTH_80 = 2,
+	HT_CHANNEL_WIDTH_MAX,
 };
 
 /* Ref: 802.11i sepc D10.0 7.3.2.25.1
-- 
2.12.3
