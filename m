Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:57294 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbeA2D07 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Jan 2018 22:26:59 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 01/10] rtlwifi: enable mac80211 fast-tx support
Date: Mon, 29 Jan 2018 11:26:32 +0800
Message-ID: <20180129032641.17841-2-pkshih@realtek.com> (sfid-20180129_042721_293124_A7F69BA2)
In-Reply-To: <20180129032641.17841-1-pkshih@realtek.com>
References: <20180129032641.17841-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Enable the mac80211 fast-tx feature, since our driver already support
hw_flags required by fast-tx and is able to let mac80211 stack to transmit
packet through fast-xmit path.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index d6c03bd5cc65..e461eed32699 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -397,6 +397,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
 	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
+	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 
 	/* swlps or hwlps has been set in diff chip in init_sw_vars */
 	if (rtlpriv->psc.swctrl_lps) {
-- 
2.15.1
