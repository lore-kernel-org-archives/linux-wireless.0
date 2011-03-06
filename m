Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44359 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab1CFO2Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:24 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 12/15] wl12xx: 1281/1283 support - Use 1 spare blocks for 128x STA, and 2 for the rest
Date: Sun,  6 Mar 2011 16:32:17 +0200
Message-Id: <1299421940-26292-13-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

All FW except for 127x AP use 1 spare blocks for TX. Reflect this in
the code.
In case of GEM need 2 spare blocks in STA.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/tx.c |   20 +++++++++++++++++++-
 drivers/net/wireless/wl12xx/tx.h |    3 ++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 441c7de..9c0ec06 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -130,6 +130,7 @@ u8 wl1271_tx_get_hlid(struct sk_buff *skb)
 static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 				u32 buf_offset, u8 hlid)
 {
+	struct ieee80211_tx_info *info;
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 total_blocks;
@@ -154,7 +155,24 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 		total_blocks = total_len + TX_HW_BLOCK_SIZE - 1;
 	}
 
-	total_blocks = total_blocks / TX_HW_BLOCK_SIZE + TX_HW_BLOCK_SPARE;
+	total_blocks = total_blocks / TX_HW_BLOCK_SIZE;
+
+	/* 127x AP works with 2 spare block. Everything else must use 1 */
+	if ((wl->chip.id != CHIP_ID_1283_PG20) &&
+	    (wl->bss_type == BSS_TYPE_AP_BSS)) {
+		total_blocks += TX_HW_BLOCK_WL127X_AP_SPARE;
+	} else {
+		total_blocks += TX_HW_BLOCK_SPARE;
+
+		info = IEEE80211_SKB_CB(skb);
+
+		/* In case of GEM need 2 spare blocks in STA */
+		if (info->control.hw_key &&
+		    info->control.hw_key->cipher == WL1271_CIPHER_SUITE_GEM &&
+		    wl->bss_type != BSS_TYPE_AP_BSS)
+			total_blocks += 1;
+	}
+
 	if (total_blocks <= wl->tx_blocks_available) {
 		desc = (struct wl1271_tx_hw_descr *)skb_push(
 			skb, total_len - skb->len);
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 0dbd8f5..b2f9e67 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -25,7 +25,8 @@
 #ifndef __TX_H__
 #define __TX_H__
 
-#define TX_HW_BLOCK_SPARE                2
+#define TX_HW_BLOCK_WL127X_AP_SPARE      2
+#define TX_HW_BLOCK_SPARE                1
 #define TX_HW_BLOCK_SIZE                 252
 
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
-- 
1.7.0.4

