Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22559 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab0BVGlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:32 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 19/22] wl1271: Clean up firmware block allocation calculation
Date: Mon, 22 Feb 2010 08:38:39 +0200
Message-Id: <1266820722-20202-20-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch simplifies the required block count calculation. Though it
introduces a division operator, it greatly simplifies the formula.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |   10 +++-------
 drivers/net/wireless/wl12xx/wl1271_tx.h |    2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index a32d301..d3ed63e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -46,7 +46,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
-	u32 total_blocks, excluded;
+	u32 total_blocks;
 	int id, ret = -EBUSY;
 
 	/* allocate free identifier for the packet */
@@ -56,12 +56,8 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
 
 	/* approximate the number of blocks required for this packet
 	   in the firmware */
-	/* FIXME: try to figure out what is done here and make it cleaner */
-	total_blocks = (total_len + 20) >> TX_HW_BLOCK_SHIFT_DIV;
-	excluded = (total_blocks << 2) + ((total_len + 20) & 0xff) + 34;
-	total_blocks += (excluded > 252) ? 2 : 1;
-	total_blocks += TX_HW_BLOCK_SPARE;
-
+	total_blocks = total_len + TX_HW_BLOCK_SIZE - 1;
+	total_blocks = total_blocks / TX_HW_BLOCK_SIZE + TX_HW_BLOCK_SPARE;
 	if (total_blocks <= wl->tx_blocks_available) {
 		desc = (struct wl1271_tx_hw_descr *)skb_push(
 			skb, total_len - skb->len);
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index ca92bd8..8b9f6b4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -26,7 +26,7 @@
 #define __WL1271_TX_H__
 
 #define TX_HW_BLOCK_SPARE                2
-#define TX_HW_BLOCK_SHIFT_DIV            8
+#define TX_HW_BLOCK_SIZE                 252
 
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
 /* The chipset reference driver states, that the "aid" value 1
-- 
1.6.3.3

