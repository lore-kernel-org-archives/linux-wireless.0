Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52456 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbeB1DHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 22:07:40 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/15] rtlwifi: btcoex: Add rate table for the use of btcoex
Date: Wed, 28 Feb 2018 11:07:09 +0800
Message-ID: <20180228030718.19510-7-pkshih@realtek.com> (sfid-20180228_040803_950248_F75079A4)
In-Reply-To: <20180228030718.19510-1-pkshih@realtek.com>
References: <20180228030718.19510-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The btcoex use the rate to rsolve IOT issue that some APs reduce TX
rate quickly, so it uses the RX rate as a clue to decide TDMA.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       | 94 ++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index fe793b787716..bc2388f3f953 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -437,6 +437,100 @@ enum btc_notify_type_stack_operation {
 	BTC_STACK_OP_MAX
 };
 
+enum {
+	BTC_CCK_1,
+	BTC_CCK_2,
+	BTC_CCK_5_5,
+	BTC_CCK_11,
+	BTC_OFDM_6,
+	BTC_OFDM_9,
+	BTC_OFDM_12,
+	BTC_OFDM_18,
+	BTC_OFDM_24,
+	BTC_OFDM_36,
+	BTC_OFDM_48,
+	BTC_OFDM_54,
+	BTC_MCS_0,
+	BTC_MCS_1,
+	BTC_MCS_2,
+	BTC_MCS_3,
+	BTC_MCS_4,
+	BTC_MCS_5,
+	BTC_MCS_6,
+	BTC_MCS_7,
+	BTC_MCS_8,
+	BTC_MCS_9,
+	BTC_MCS_10,
+	BTC_MCS_11,
+	BTC_MCS_12,
+	BTC_MCS_13,
+	BTC_MCS_14,
+	BTC_MCS_15,
+	BTC_MCS_16,
+	BTC_MCS_17,
+	BTC_MCS_18,
+	BTC_MCS_19,
+	BTC_MCS_20,
+	BTC_MCS_21,
+	BTC_MCS_22,
+	BTC_MCS_23,
+	BTC_MCS_24,
+	BTC_MCS_25,
+	BTC_MCS_26,
+	BTC_MCS_27,
+	BTC_MCS_28,
+	BTC_MCS_29,
+	BTC_MCS_30,
+	BTC_MCS_31,
+	BTC_VHT_1SS_MCS_0,
+	BTC_VHT_1SS_MCS_1,
+	BTC_VHT_1SS_MCS_2,
+	BTC_VHT_1SS_MCS_3,
+	BTC_VHT_1SS_MCS_4,
+	BTC_VHT_1SS_MCS_5,
+	BTC_VHT_1SS_MCS_6,
+	BTC_VHT_1SS_MCS_7,
+	BTC_VHT_1SS_MCS_8,
+	BTC_VHT_1SS_MCS_9,
+	BTC_VHT_2SS_MCS_0,
+	BTC_VHT_2SS_MCS_1,
+	BTC_VHT_2SS_MCS_2,
+	BTC_VHT_2SS_MCS_3,
+	BTC_VHT_2SS_MCS_4,
+	BTC_VHT_2SS_MCS_5,
+	BTC_VHT_2SS_MCS_6,
+	BTC_VHT_2SS_MCS_7,
+	BTC_VHT_2SS_MCS_8,
+	BTC_VHT_2SS_MCS_9,
+	BTC_VHT_3SS_MCS_0,
+	BTC_VHT_3SS_MCS_1,
+	BTC_VHT_3SS_MCS_2,
+	BTC_VHT_3SS_MCS_3,
+	BTC_VHT_3SS_MCS_4,
+	BTC_VHT_3SS_MCS_5,
+	BTC_VHT_3SS_MCS_6,
+	BTC_VHT_3SS_MCS_7,
+	BTC_VHT_3SS_MCS_8,
+	BTC_VHT_3SS_MCS_9,
+	BTC_VHT_4SS_MCS_0,
+	BTC_VHT_4SS_MCS_1,
+	BTC_VHT_4SS_MCS_2,
+	BTC_VHT_4SS_MCS_3,
+	BTC_VHT_4SS_MCS_4,
+	BTC_VHT_4SS_MCS_5,
+	BTC_VHT_4SS_MCS_6,
+	BTC_VHT_4SS_MCS_7,
+	BTC_VHT_4SS_MCS_8,
+	BTC_VHT_4SS_MCS_9,
+	BTC_MCS_32,
+	BTC_UNKNOWN,
+	BTC_PKT_MGNT,
+	BTC_PKT_CTRL,
+	BTC_PKT_UNKNOWN,
+	BTC_PKT_NOT_FOR_ME,
+	BTC_RATE_MAX
+};
+
 enum {
 	BTC_MULTIPORT_SCC,
 	BTC_MULTIPORT_MCC_2CHANNEL,
-- 
2.15.1
