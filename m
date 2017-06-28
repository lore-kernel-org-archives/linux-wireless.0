Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36188 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdF1Mci (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 08:32:38 -0400
Received: by mail-pg0-f65.google.com with SMTP id u36so8093774pgn.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jun 2017 05:32:38 -0700 (PDT)
Date: Wed, 28 Jun 2017 18:02:33 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Remove unused dummy function
Message-ID: <20170628123233.GA10039@symbol-HP-ZBook-15> (sfid-20170628_143242_655788_9EA87A09)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing unused dummy function

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c  |  2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 12 ------------
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h |  3 ---
 3 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index 96c923b..62d9214 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -173,7 +173,7 @@ static bool rtl92cu_get_btc_status(void)
 	.rx_urb_num = RTL92C_NUM_RX_URBS,
 	.rx_max_size = RTL92C_SIZE_MAX_RX_BUFFER,
 	.usb_rx_hdl = rtl8192cu_rx_hdl,
-	.usb_rx_segregate_hdl = NULL, /* rtl8192c_rx_segregate_hdl; */
+	.usb_rx_segregate_hdl = NULL,
 	/* tx */
 	.usb_tx_cleanup = rtl8192c_tx_cleanup,
 	.usb_tx_post_hdl = rtl8192c_tx_post_hdl,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index 41422e4..25a081c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -436,13 +436,6 @@ void  rtl8192cu_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb)
 	_rtl_rx_process(hw, skb);
 }

-void rtl8192c_rx_segregate_hdl(
-	struct ieee80211_hw *hw,
-	struct sk_buff *skb,
-	struct sk_buff_head *skb_list)
-{
-}
-
 /*----------------------------------------------------------------------
  *
  *	Tx handler
@@ -675,8 +668,3 @@ void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD, "H2C Tx Cmd Content",
 		      pdesc, RTL_TX_DESC_SIZE);
 }
-
-bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	return true;
-}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
index 487eec8..15a66c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
@@ -385,8 +385,6 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 			   struct ieee80211_rx_status *rx_status,
 			   u8 *p_desc, struct sk_buff *skb);
 void  rtl8192cu_rx_hdl(struct ieee80211_hw *hw, struct sk_buff * skb);
-void rtl8192c_rx_segregate_hdl(struct ieee80211_hw *, struct sk_buff *,
-			       struct sk_buff_head *);
 void rtl8192c_tx_cleanup(struct ieee80211_hw *hw, struct sk_buff  *skb);
 int rtl8192c_tx_post_hdl(struct ieee80211_hw *hw, struct urb *urb,
 			 struct sk_buff *skb);
@@ -404,6 +402,5 @@ void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
 void rtl92cu_tx_fill_cmddesc(struct ieee80211_hw *hw,
 			     u8 *pdesc, bool b_firstseg,
 			     bool b_lastseg, struct sk_buff *skb);
-bool rtl92cu_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb);

 #endif
--
1.9.1
