Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.36]:39453 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752615AbdFMUnL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 16:43:11 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 6A4D8124BE0B
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 15:43:03 -0500 (CDT)
Date: Tue, 13 Jun 2017 15:42:59 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] rtlwifi: rtl8821ae: remove unused variable
Message-ID: <20170613204259.GA9189@embeddedgus> (sfid-20170613_224337_148122_BAB0857E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused variable rtlhal.

Addresses-Coverity-ID: 1248810
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 2bc6bac..d158e34 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1360,7 +1360,6 @@ static bool _rtl8821ae_reset_pcie_interface_dma(struct ieee80211_hw *hw,
 static void _rtl8821ae_get_wakeup_reason(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
 	u8 fw_reason = 0;
 	struct timeval ts;
@@ -1372,8 +1371,6 @@ static void _rtl8821ae_get_wakeup_reason(struct ieee80211_hw *hw)
 
 	ppsc->wakeup_reason = 0;
 
-	rtlhal->last_suspend_sec = ts.tv_sec;
-
 	switch (fw_reason) {
 	case FW_WOW_V2_PTK_UPDATE_EVENT:
 		ppsc->wakeup_reason = WOL_REASON_PTK_UPDATE;
-- 
2.5.0
