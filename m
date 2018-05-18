Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:45393 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753381AbeERJal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:30:41 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/14] rtlwifi: fix btmpinfo timeout while processing C2H_BT_INFO
Date: Fri, 18 May 2018 17:30:07 +0800
Message-ID: <20180518093007.23594-15-pkshih@realtek.com> (sfid-20180518_113100_081069_53557335)
In-Reply-To: <20180518093007.23594-1-pkshih@realtek.com>
References: <20180518093007.23594-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

In former patch, I enqueu all C2H commands and processed by a workqueue.
In case C2H_BT_INFO will issue a H2C command to set BT reg, and wait for
a C2H ack. But it is totally impossible that C2H workqueue waits for a
C2H command, so kernel log warn
	rtlwifi: :<0> btmpinfo wait (req_num=0) timeout

Since the C2H ack command C2H_BT_MP can be safely processed in interrupt
context, add a fast command path to deal with the command.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index a5939ddfa9cb..39c817eddd78 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2262,11 +2262,33 @@ void rtl_fwevt_wq_callback(void *data)
 	rtlpriv->cfg->ops->c2h_command_handle(hw);
 }
 
+static void rtl_c2h_content_parsing(struct ieee80211_hw *hw,
+				    struct sk_buff *skb);
+
+static bool rtl_c2h_fast_cmd(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	u8 cmd_id = GET_C2H_CMD_ID(skb->data);
+
+	switch (cmd_id) {
+	case C2H_BT_MP:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 void rtl_c2hcmd_enqueue(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned long flags;
 
+	if (rtl_c2h_fast_cmd(hw, skb)) {
+		rtl_c2h_content_parsing(hw, skb);
+		return;
+	}
+
 	/* enqueue */
 	spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
 
-- 
2.15.1
