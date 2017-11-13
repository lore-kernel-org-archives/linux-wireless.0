Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:40099 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdKMJk4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:40:56 -0500
From: <pkshih@realtek.com>
To: <Larry.Finger@lwfinger.net>, <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <steventing@realtek.com>,
        <yhchuang@realtek.com>
Subject: [PATCH 1/3] rtlwifi: Reduce IO in RX interrupt to boost throughput
Date: Mon, 13 Nov 2017 17:39:33 +0800
Message-ID: <20171113093935.20431-2-pkshih@realtek.com> (sfid-20171113_104059_855297_AEB2BAD7)
In-Reply-To: <20171113093935.20431-1-pkshih@realtek.com>
References: <20171113093935.20431-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Check remaining count of RX packets cost a lot of CPU time, so only update
when the counter decreases to zero. In old flow, the counter was updated
once a RX packet is received.

Signed-off-by: Steven Ting <steventing@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index c2575b0b9440..ca3f4716c1b6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -747,7 +747,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 	u8 tmp_one;
 	bool unicast = false;
 	u8 hw_queue = 0;
-	unsigned int rx_remained_cnt;
+	unsigned int rx_remained_cnt = 0;
 	struct rtl_stats stats = {
 		.signal = 0,
 		.rate = 0,
@@ -768,7 +768,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		struct sk_buff *new_skb;
 
 		if (rtlpriv->use_new_trx_flow) {
-			rx_remained_cnt =
+			if (rx_remained_cnt == 0)
+				rx_remained_cnt =
 				rtlpriv->cfg->ops->rx_desc_buff_remained_cnt(hw,
 								      hw_queue);
 			if (rx_remained_cnt == 0)
-- 
2.14.1
