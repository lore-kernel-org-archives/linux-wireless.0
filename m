Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:45384 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753327AbeERJai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:30:38 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/14] rtlwifi: remove dummy hal_op rx_command_packet from rtl8188ee and rtl8723ae
Date: Fri, 18 May 2018 17:30:00 +0800
Message-ID: <20180518093007.23594-8-pkshih@realtek.com> (sfid-20180518_113222_763750_4F120E06)
In-Reply-To: <20180518093007.23594-1-pkshih@realtek.com>
References: <20180518093007.23594-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The caller of hal_op rx_command_packet will assert function pointer
before calling, so we can remove dummy functions safely.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c  | 2 --
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 7 -------
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c  | 1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 7 -------
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h | 3 ---
 6 files changed, 24 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index 82681b96ef93..8c15ffd3568b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -263,8 +263,6 @@ static struct rtl_hal_ops rtl8188ee_hal_ops = {
 	.get_rfreg = rtl88e_phy_query_rf_reg,
 	.set_rfreg = rtl88e_phy_set_rf_reg,
 	.get_btc_status = rtl88e_get_btc_status,
-	.rx_command_packet = rtl88ee_rx_command_packet,
-
 };
 
 static struct rtl_mod_params rtl88ee_mod_params = {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index 9670732b2bc6..4c1f8b08fc10 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -850,10 +850,3 @@ void rtl88ee_tx_polling(struct ieee80211_hw *hw, u8 hw_queue)
 			       BIT(0) << (hw_queue));
 	}
 }
-
-u32 rtl88ee_rx_command_packet(struct ieee80211_hw *hw,
-			      const struct rtl_stats *status,
-			      struct sk_buff *skb)
-{
-	return 0;
-}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
index f902d6769aa8..127ba977206f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
@@ -790,8 +790,4 @@ void rtl88ee_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl88ee_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 			     bool firstseg, bool lastseg,
 			     struct sk_buff *skb);
-u32 rtl88ee_rx_command_packet(struct ieee80211_hw *hw,
-			      const struct rtl_stats *status,
-			      struct sk_buff *skb);
-
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index a545ea317323..07b82700d1de 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -260,7 +260,6 @@ static struct rtl_hal_ops rtl8723e_hal_ops = {
 	.bt_coex_off_before_lps =
 		rtl8723e_dm_bt_turn_off_bt_coexist_before_enter_lps,
 	.get_btc_status = rtl8723e_get_btc_status,
-	.rx_command_packet = rtl8723e_rx_command_packet,
 	.is_fw_header = is_fw_header,
 };
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index 23485602a9a1..d461d0c9631f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -709,10 +709,3 @@ void rtl8723e_tx_polling(struct ieee80211_hw *hw, u8 hw_queue)
 			       BIT(0) << (hw_queue));
 	}
 }
-
-u32 rtl8723e_rx_command_packet(struct ieee80211_hw *hw,
-			       const struct rtl_stats *status,
-			       struct sk_buff *skb)
-{
-	return 0;
-}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h
index 985ce0b77ea5..d592b08d4ac8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h
@@ -716,7 +716,4 @@ void rtl8723e_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 			      bool firstseg, bool lastseg,
 			      struct sk_buff *skb);
-u32 rtl8723e_rx_command_packet(struct ieee80211_hw *hw,
-			       const struct rtl_stats *status,
-			       struct sk_buff *skb);
 #endif
-- 
2.15.1
