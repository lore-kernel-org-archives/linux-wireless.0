Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:57694 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932962Ab2DKTxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:53:53 -0400
Received: by lban1 with SMTP id n1so1049331lba.40
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:50 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 02/24] wlcore/wl12xx: change GEM Tx-spare blocks per-vif
Date: Wed, 11 Apr 2012 22:53:18 +0300
Message-Id: <1334174020-18957-3-git-send-email-coelho@ti.com> (sfid-20120411_215410_076717_4BADEDCC)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The number of spare Tx blocks must be changed when the GEM cipher is
engaged. Track set_key() operations to see if this is the case and
change the Tx HW spare block count accordingly. Set the number of spare
blocks for each operating mode from the low level driver.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c    |    6 ++++++
 drivers/net/wireless/ti/wlcore/debugfs.c |    1 +
 drivers/net/wireless/ti/wlcore/main.c    |   24 +++++++++++-------------
 drivers/net/wireless/ti/wlcore/tx.c      |    9 ++++-----
 drivers/net/wireless/ti/wlcore/tx.h      |    1 -
 drivers/net/wireless/ti/wlcore/wl12xx.h  |    3 +++
 drivers/net/wireless/ti/wlcore/wlcore.h  |    7 ++++---
 7 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 57c70a4..3447cef 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -34,6 +34,10 @@
 
 #include "reg.h"
 
+#define WL12XX_TX_HW_BLOCK_SPARE_DEFAULT        1
+#define WL12XX_TX_HW_BLOCK_GEM_SPARE            2
+
+
 static struct wlcore_partition_set wl12xx_ptable[PART_TABLE_LEN] = {
 	[PART_DOWN] = {
 		.mem = {
@@ -675,6 +679,8 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->ptable = wl12xx_ptable;
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = 16;
+	wl->normal_tx_spare = WL12XX_TX_HW_BLOCK_SPARE_DEFAULT;
+	wl->gem_tx_spare = WL12XX_TX_HW_BLOCK_GEM_SPARE;
 
 	return wlcore_probe(wl, pdev);
 }
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 9db0813..d5aea1f 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -647,6 +647,7 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 		VIF_STATE_PRINT_INT(last_rssi_event);
 		VIF_STATE_PRINT_INT(ba_support);
 		VIF_STATE_PRINT_INT(ba_allowed);
+		VIF_STATE_PRINT_INT(is_gem);
 		VIF_STATE_PRINT_LLHEX(tx_security_seq);
 		VIF_STATE_PRINT_INT(tx_security_last_seq_lsb);
 	}
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 7b39a86..b56bbc3 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1858,7 +1858,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->tx_results_count = 0;
 	wl->tx_packets_count = 0;
 	wl->time_offset = 0;
-	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->ap_fw_ps_map = 0;
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
@@ -2912,6 +2911,17 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	int ret;
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 
+	/*
+	 * A role set to GEM cipher requires different Tx settings (namely
+	 * spare blocks). Note when we are in this mode so the HW can adjust.
+	 */
+	if (key_type == KEY_GEM) {
+		if (action == KEY_ADD_OR_REPLACE)
+			wlvif->is_gem = true;
+		else if (action == KEY_REMOVE)
+			wlvif->is_gem = false;
+	}
+
 	if (is_ap) {
 		struct wl1271_station *wl_sta;
 		u8 hlid;
@@ -2950,17 +2960,6 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			0xff, 0xff, 0xff, 0xff, 0xff, 0xff
 		};
 
-		/*
-		 * A STA set to GEM cipher requires 2 tx spare blocks.
-		 * Return to default value when GEM cipher key is removed
-		 */
-		if (key_type == KEY_GEM) {
-			if (action == KEY_ADD_OR_REPLACE)
-				wl->tx_spare_blocks = 2;
-			else if (action == KEY_REMOVE)
-				wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
-		}
-
 		addr = sta ? sta->addr : bcast_addr;
 
 		if (is_zero_ether_addr(addr)) {
@@ -5259,7 +5258,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	wl->quirks = 0;
 	wl->platform_quirks = 0;
 	wl->sched_scanning = false;
-	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->active_sta_count = 0;
 	wl->fwlog_size = 0;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 815d0ac..3306990 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -190,7 +190,7 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY, ac;
-	u32 spare_blocks = wl->tx_spare_blocks;
+	u32 spare_blocks = wl->normal_tx_spare;
 	bool is_dummy = false;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
@@ -205,11 +205,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	   in the firmware */
 	len = wl12xx_calc_packet_alignment(wl, total_len);
 
-	/* in case of a dummy packet, use default amount of spare mem blocks */
-	if (unlikely(wl12xx_is_dummy_packet(wl, skb))) {
+	if (unlikely(wl12xx_is_dummy_packet(wl, skb)))
 		is_dummy = true;
-		spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
-	}
+	else if (wlvif->is_gem)
+		spare_blocks = wl->gem_tx_spare;
 
 	total_blocks = (len + TX_HW_BLOCK_SIZE - 1) / TX_HW_BLOCK_SIZE +
 		spare_blocks;
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 5cf8c32..2ad7705 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -25,7 +25,6 @@
 #ifndef __TX_H__
 #define __TX_H__
 
-#define TX_HW_BLOCK_SPARE_DEFAULT        1
 #define TX_HW_BLOCK_SIZE                 252
 
 #define TX_HW_MGMT_PKT_LIFETIME_TU       2000
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
index 1516622..b09c9ed 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx.h
@@ -375,6 +375,9 @@ struct wl12xx_vif {
 	struct work_struct rx_streaming_disable_work;
 	struct timer_list rx_streaming_timer;
 
+	/* does the current role use GEM for encryption (AP or STA) */
+	bool is_gem;
+
 	/*
 	 * This struct must be last!
 	 * data that has to be saved acrossed reconfigs (e.g. recovery)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index a4f576d..2fb713a 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -150,9 +150,6 @@ struct wl1271 {
 	u32 tx_allocated_blocks;
 	u32 tx_results_count;
 
-	/* amount of spare TX blocks to use */
-	u32 tx_spare_blocks;
-
 	/* Accounting for allocated / available Tx packets in HW */
 	u32 tx_pkts_freed[NUM_TX_QUEUES];
 	u32 tx_allocated_pkts[NUM_TX_QUEUES];
@@ -309,6 +306,10 @@ struct wl1271 {
 
 	/* number of TX descriptors the HW supports. */
 	u32 num_tx_desc;
+
+	/* spare Tx blocks for normal/GEM operating modes */
+	u32 normal_tx_spare;
+	u32 gem_tx_spare;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.5.4

