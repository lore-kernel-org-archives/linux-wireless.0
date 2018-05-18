Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:45395 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753404AbeERJal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:30:41 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
Date: Fri, 18 May 2018 17:30:06 +0800
Message-ID: <20180518093007.23594-14-pkshih@realtek.com> (sfid-20180518_113059_518027_FCAE2B17)
In-Reply-To: <20180518093007.23594-1-pkshih@realtek.com>
References: <20180518093007.23594-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The format of C2H data is ID(1 byte) + Length(1 byte) + value, and it is
more readable to use macros to access C2H data.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 61f12f86fcd4..a5939ddfa9cb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2288,10 +2288,10 @@ static void rtl_c2h_content_parsing(struct ieee80211_hw *hw,
 	u8 cmd_id, cmd_seq, cmd_len;
 	u8 *cmd_buf = NULL;
 
-	cmd_id = skb->data[0];
-	cmd_seq = skb->data[1];
-	cmd_len = skb->len - 2;
-	cmd_buf = skb->data + 2;
+	cmd_id = GET_C2H_CMD_ID(skb->data);
+	cmd_seq = GET_C2H_SEQ(skb->data);
+	cmd_len = skb->len - C2H_DATA_OFFSET;
+	cmd_buf = GET_C2H_DATA_PTR(skb->data);
 
 	switch (cmd_id) {
 	case C2H_DBG:
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 9e620b943f8c..0f3b98c5227f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -177,6 +177,11 @@ enum rtl_c2h_evt_v2 {
 	C2H_V2_CCX_RPT = 0x0F,
 };
 
+#define GET_C2H_CMD_ID(c2h)	({u8 *__c2h = c2h; __c2h[0]; })
+#define GET_C2H_SEQ(c2h)	({u8 *__c2h = c2h; __c2h[1]; })
+#define C2H_DATA_OFFSET		2
+#define GET_C2H_DATA_PTR(c2h)	({u8 *__c2h = c2h; &__c2h[C2H_DATA_OFFSET]; })
+
 #define GET_TX_REPORT_SN_V1(c2h)	(c2h[6])
 #define GET_TX_REPORT_ST_V1(c2h)	(c2h[0] & 0xC0)
 #define GET_TX_REPORT_RETRY_V1(c2h)	(c2h[2] & 0x3F)
-- 
2.15.1
