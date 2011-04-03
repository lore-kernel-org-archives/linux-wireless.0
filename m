Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43125 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab1DCMjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Apr 2011 08:39:02 -0400
Received: by wwa36 with SMTP id 36so5551485wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Apr 2011 05:39:01 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: use 2 spare TX blocks for GEM cipher
Date: Sun,  3 Apr 2011 15:37:25 +0300
Message-Id: <1301834245-16679-1-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tx_spare_blocks member to the wl1271 struct
for more generic configuration of the amount
of spare TX blocks that should be used.
The default value is 1.
in case GEM cipher is used by the STA, we need
2 spare TX blocks instead of just 1.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   15 +++++++++++++++
 drivers/net/wireless/wl12xx/tx.c     |    4 +---
 drivers/net/wireless/wl12xx/tx.h     |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..f962e43 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1097,6 +1097,8 @@ int wl1271_plt_start(struct wl1271 *wl)
 		wl1271_notice("firmware booted in PLT mode (%s)",
 			      wl->chip.fw_ver_str);
 
+		wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
+
 		/* Check if any quirks are needed with older fw versions */
 		wl->quirks |= wl1271_get_fw_ver_quirks(wl);
 		goto out;
@@ -1379,6 +1381,8 @@ power_off:
 	strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
 		sizeof(wiphy->fw_version));
 
+	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
+
 	/* Check if any quirks are needed with older fw versions */
 	wl->quirks |= wl1271_get_fw_ver_quirks(wl);
 
@@ -2039,6 +2043,17 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			0xff, 0xff, 0xff, 0xff, 0xff, 0xff
 		};
 
+		/*
+		 * A STA set to GEM cipher requires 2 tx spare blocks.
+		 * Return to default value when GEM cipher key is removed
+		 */
+		if (key_type == KEY_GEM) {
+			if (action == KEY_ADD_OR_REPLACE)
+				wl->tx_spare_blocks = 2;
+			else
+				wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
+		}
+
 		addr = sta ? sta->addr : bcast_addr;
 
 		if (is_zero_ether_addr(addr)) {
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index db9e47e..2c79b6e 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -135,12 +135,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY;
-	u32 spare_blocks;
+	u32 spare_blocks = wl->tx_spare_blocks;
 
 	if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
 		spare_blocks = 2;
-	else
-		spare_blocks = 1;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
 		return -EAGAIN;
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index a3877ba..be3d940 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -25,6 +25,7 @@
 #ifndef __TX_H__
 #define __TX_H__
 
+#define TX_HW_BLOCK_SPARE_DEFAULT        1
 #define TX_HW_BLOCK_SIZE                 252
 
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b04481a..1a160a7 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -433,6 +433,9 @@ struct wl1271 {
 	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
 	int tx_queue_count;
 
+	/* amount of spare TX blocks to use */
+	int tx_spare_blocks;
+
 	/* Frames received, not handled yet by mac80211 */
 	struct sk_buff_head deferred_rx_queue;
 
-- 
1.7.1

