Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57117 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbdKCOJ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 10:09:28 -0400
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: remove redundant pointer tid_data
Date: Fri,  3 Nov 2017 14:09:22 +0000
Message-Id: <20171103140922.8926-1-colin.king@canonical.com> (sfid-20171103_150947_853277_73A8AFE7)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

tid_data is assigned but never read, hence it is redundant
and can be removed. Cleans up clang warning:

drivers/net/wireless/realtek/rtlwifi/base.c:1581:2: warning: Value
stored to 'tid_data' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 7e3107f9e37f..cad2272ae21b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1630,7 +1630,6 @@ int rtl_tx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta, u16 tid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_tid_data *tid_data;
 	struct rtl_sta_info *sta_entry = NULL;
 
 	if (sta == NULL)
@@ -1643,7 +1642,6 @@ int rtl_tx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		return -EINVAL;
 
 	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
-	tid_data = &sta_entry->tids[tid];
 	sta_entry->tids[tid].agg.agg_state = RTL_AGG_STOP;
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-- 
2.14.1
