Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:37178 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752802AbeARB0e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 20:26:34 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] rtlwifi: Support A-MSDU in A-MPDU capability
Date: Thu, 18 Jan 2018 09:26:14 +0800
Message-ID: <20180118012614.6724-1-pkshih@realtek.com> (sfid-20180118_022652_856302_51D95AE5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Due to the fact that A-MSDU deaggregation is done in software,
we set this flag to support the A-MSDU in A-MPDU

Signed-off-by: Steven Ting <steventing@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
Rebase to resolve conflict due to the patch 'fast-tx' is dropped.
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 89ec318598ea..c8ebf738cb2b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -395,6 +395,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
 
 	/* swlps or hwlps has been set in diff chip in init_sw_vars */
 	if (rtlpriv->psc.swctrl_lps) {
-- 
2.15.1
