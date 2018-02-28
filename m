Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52452 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbeB1DHj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 22:07:39 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/15] rtlwifi: remove redundant statement found by static checker
Date: Wed, 28 Feb 2018 11:07:05 +0800
Message-ID: <20180228030718.19510-3-pkshih@realtek.com> (sfid-20180228_040744_412953_EF7AF014)
In-Reply-To: <20180228030718.19510-1-pkshih@realtek.com>
References: <20180228030718.19510-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

smatch reports "rtl_is_special_data() warn: inconsistent indenting", but
it is an obvious redundant statement so remove it.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 6db3389e2ced..762a29cdf7ad 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1549,7 +1549,6 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 		/* EAPOL is seens as in-4way */
 		rtlpriv->btcoexist.btc_info.in_4way = true;
 		rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
-	rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
 
 		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
 			 "802.1X %s EAPOL pkt!!\n", (is_tx) ? "Tx" : "Rx");
-- 
2.15.1
