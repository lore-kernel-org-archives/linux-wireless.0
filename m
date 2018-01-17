Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54058 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbeAQGPw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 01:15:52 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 05/10] rtlwifi: Support A-MSDU in A-MPDU capability
Date: Wed, 17 Jan 2018 14:15:25 +0800
Message-ID: <20180117061530.30049-6-pkshih@realtek.com> (sfid-20180117_071556_882827_4AD10564)
In-Reply-To: <20180117061530.30049-1-pkshih@realtek.com>
References: <20180117061530.30049-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Steven Ting <steventing@realtek.com>

Due to the fact that A-MSDU deaggregation is done in software,
we set this flag to support the A-MSDU in A-MPDU

Signed-off-by: Steven Ting <steventing@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index e902cd7adbfe..07b91bc9adf9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -397,6 +397,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
 	ieee80211_hw_set(hw, SUPPORTS_TX_FRAG);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
 
 	/* swlps or hwlps has been set in diff chip in init_sw_vars */
 	if (rtlpriv->psc.swctrl_lps) {
-- 
2.15.1
