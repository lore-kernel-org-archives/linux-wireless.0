Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:45373 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753155AbeERJai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:30:38 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/14] rtlwifi: remove CONNECTION_MONITOR flag
Date: Fri, 18 May 2018 17:29:55 +0800
Message-ID: <20180518093007.23594-3-pkshih@realtek.com> (sfid-20180518_113222_197714_6DE77D52)
In-Reply-To: <20180518093007.23594-1-pkshih@realtek.com>
References: <20180518093007.23594-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

To use keep-alive mechanism in mac80211 stack, since driver supports
reporting accurate nullfunc frame tx ack now.

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 6620c6842b91..759a802ccbee 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -396,7 +396,6 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
-	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
 	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
-- 
2.15.1
