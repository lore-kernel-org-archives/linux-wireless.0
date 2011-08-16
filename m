Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1HPQvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 12:51:11 -0400
Received: by fxh19 with SMTP id 19so106075fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 09:51:10 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v3] wl12xx: use 2 spare TX blocks for GEM cipher
Date: Tue, 16 Aug 2011 19:49:12 +0300
Message-Id: <1313513352-32316-1-git-send-email-guy@wizery.com> (sfid-20110816_185113_587943_E0FA65EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tx_spare_blocks member to the wl1271 struct
for more generic configuration of the amount
of spare TX blocks that should be used.
The default value is 1.
In case GEM cipher is used by the STA, we need
2 spare TX blocks instead of just 1.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   13 +++++++++++++
 drivers/net/wireless/wl12xx/tx.c     |    8 +++++---
 drivers/net/wireless/wl12xx/tx.h     |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 1c56137..e8d02e9 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2110,6 +2110,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->vif = NULL;
 	wl->filters = 0;
+	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl1271_free_ap_keys(wl);
 	memset(wl->ap_hlid_map, 0, sizeof(wl->ap_hlid_map));
 	wl->ap_fw_ps_map = 0;
@@ -2736,6 +2737,17 @@ static int wl1271_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 			0xff, 0xff, 0xff, 0xff, 0xff, 0xff
 		};
 
+		/*
+		 * A STA set to GEM cipher requires 2 tx spare blocks.
+		 * Return to default value when GEM cipher key is removed
+		 */
+		if (key_type == KEY_GEM) {
+			if (action == KEY_ADD_OR_REPLACE)
+				wl->tx_spare_blocks = 2;
+			else if (action == KEY_REMOVE)
+				wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
+		}
+
 		addr = sta ? sta->addr : bcast_addr;
 
 		if (is_zero_ether_addr(addr)) {
@@ -4916,6 +4928,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_security_seq = 0;
 	wl->tx_security_last_seq_lsb = 0;
 	wl->active_sta_count = 0;
+	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 367809e..8823c1f 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -200,9 +200,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY, ac;
-
-	/* we use 1 spare block */
-	u32 spare_blocks = 1;
+	u32 spare_blocks = wl->tx_spare_blocks;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
 		return -EAGAIN;
@@ -216,6 +214,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 	   in the firmware */
 	len = wl12xx_calc_packet_alignment(wl, total_len);
 
+	/* in case of a dummy packet, use default amount of spare mem blocks */
+	if (unlikely(wl12xx_is_dummy_packet(wl, skb)))
+		spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
+
 	total_blocks = (len + TX_HW_BLOCK_SIZE - 1) / TX_HW_BLOCK_SIZE +
 		spare_blocks;
 
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index e2f9150..bdbae8d 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -25,6 +25,7 @@
 #ifndef __TX_H__
 #define __TX_H__
 
+#define TX_HW_BLOCK_SPARE_DEFAULT        1
 #define TX_HW_BLOCK_SIZE                 252
 
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index f528f61..3d847b5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -459,6 +459,9 @@ struct wl1271 {
 	u32 tx_allocated_blocks;
 	u32 tx_results_count;
 
+	/* amount of spare TX blocks to use */
+	u32 tx_spare_blocks;
+
 	/* Accounting for allocated / available Tx packets in HW */
 	u32 tx_pkts_freed[NUM_TX_QUEUES];
 	u32 tx_allocated_pkts[NUM_TX_QUEUES];
-- 
1.7.4.1

