Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43842 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1BUKyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 05:54:54 -0500
Received: by eyx24 with SMTP id 24so181344eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 02:54:53 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] wl12xx: use standard ALIGN() macro
Date: Mon, 21 Feb 2011 12:54:49 +0200
Message-Id: <1298285690-11596-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/rx.h |    4 ----
 drivers/net/wireless/wl12xx/tx.c |    4 ++--
 drivers/net/wireless/wl12xx/tx.h |    2 --
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 4cef8fa..75fabf8 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -30,10 +30,6 @@
 #define WL1271_RX_MAX_RSSI -30
 #define WL1271_RX_MIN_RSSI -95
 
-#define WL1271_RX_ALIGN_TO 4
-#define WL1271_RX_ALIGN(len) (((len) + WL1271_RX_ALIGN_TO - 1) & \
-			     ~(WL1271_RX_ALIGN_TO - 1))
-
 #define SHORT_PREAMBLE_BIT   BIT(0)
 #define OFDM_RATE_BIT        BIT(6)
 #define PBCC_RATE_BIT        BIT(7)
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 67a0094..94ff3fa 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -185,7 +185,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	desc->reserved = 0;
 
 	/* align the length (and store in terms of words) */
-	pad = WL1271_TX_ALIGN(skb->len);
+	pad = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
 	desc->length = cpu_to_le16(pad >> 2);
 
 	/* calculate number of padding bytes */
@@ -245,7 +245,7 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	 * pad the skb data to make sure its length is aligned.
 	 * The number of padding bytes is computed and set in wl1271_tx_fill_hdr
 	 */
-	total_len = WL1271_TX_ALIGN(skb->len);
+	total_len = ALIGN(skb->len, WL1271_TX_ALIGN_TO);
 	memcpy(wl->aggr_buf + buf_offset, skb->data, skb->len);
 	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
 
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 05722a5..db88f58 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -53,8 +53,6 @@
 #define TX_HW_RESULT_QUEUE_LEN_MASK      0xf
 
 #define WL1271_TX_ALIGN_TO 4
-#define WL1271_TX_ALIGN(len) (((len) + WL1271_TX_ALIGN_TO - 1) & \
-			     ~(WL1271_TX_ALIGN_TO - 1))
 #define WL1271_TKIP_IV_SPACE 4
 
 struct wl1271_tx_hw_descr {
-- 
1.7.0.4

