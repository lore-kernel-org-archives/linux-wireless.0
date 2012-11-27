Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42408 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab2K0Gpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:41 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so4054043wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:41 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 19/20] wlcore: improved Tx scheduling algorithm
Date: Tue, 27 Nov 2012 08:45:00 +0200
Message-Id: <1353998701-18171-20-git-send-email-arik@wizery.com> (sfid-20121127_074552_348304_0378141E)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prioritize EDCA by choosing the AC before anything else. Use the
fast/slow link bitmap in FW to improve the scheduling algorithm for
the multi-link scenario.

Set packet thresholds to determine if a given link is high or low
priority according to its speed. A slow link will be given high priority
if the amount of packets queued for it in the FW is lower than the
slow-threshold. Similarly, a fast link will be given high priority if
the number of its packets queued in FW is smaller than the high-threshold.

The improved algorithm:
1. Choose optimal AC according to FW utilization
2. Traversing the VIFs in a round-robin fashion, try to choose a high
   priority link. Links are traversed in a round-robin fashion inside a
   VIF.
3. If no high priority links are found, choose the first non-empty
   (low priority) link found in the round robin.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    2 +
 drivers/net/wireless/ti/wl18xx/main.c   |    2 +
 drivers/net/wireless/ti/wlcore/conf.h   |   14 +++-
 drivers/net/wireless/ti/wlcore/main.c   |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c     |  124 ++++++++++++++++++++++---------
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +
 6 files changed, 112 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d997cdc..9ac042b 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -210,6 +210,8 @@ static struct wlcore_conf wl12xx_conf = {
 		.tmpl_short_retry_limit      = 10,
 		.tmpl_long_retry_limit       = 10,
 		.tx_watchdog_timeout         = 5000,
+		.slow_link_thold             = 3,
+		.fast_link_thold             = 10,
 	},
 	.conn = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 8fd13f3..53f4ba8 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -337,6 +337,8 @@ static struct wlcore_conf wl18xx_conf = {
 		.tmpl_short_retry_limit      = 10,
 		.tmpl_long_retry_limit       = 10,
 		.tx_watchdog_timeout         = 5000,
+		.slow_link_thold             = 3,
+		.fast_link_thold             = 30,
 	},
 	.conn = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index b3894ef..e07d74d 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -674,6 +674,18 @@ struct conf_tx_settings {
 
 	/* Time in ms for Tx watchdog timer to expire */
 	u32 tx_watchdog_timeout;
+
+	/*
+	 * when a slow link has this much packets pending, it becomes a low
+	 * priority link, scheduling-wise
+	 */
+	u8 slow_link_thold;
+
+	/*
+	 * when a fast link has this much packets pending, it becomes a low
+	 * priority link, scheduling-wise
+	 */
+	u8 fast_link_thold;
 } __packed;
 
 enum {
@@ -1281,7 +1293,7 @@ struct conf_recovery_settings {
  * version, the two LSB are the lower driver's private conf
  * version.
  */
-#define WLCORE_CONF_VERSION	(0x0004 << 16)
+#define WLCORE_CONF_VERSION	(0x0005 << 16)
 #define WLCORE_CONF_MASK	0xffff0000
 #define WLCORE_CONF_SIZE	(sizeof(struct wlcore_conf_header) +	\
 				 sizeof(struct wlcore_conf))
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c557678..3834e9d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -377,8 +377,6 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 	u32 cur_fw_ps_map;
 	u8 hlid;
 
-	/* TODO: also use link_fast_bitmap here */
-
 	cur_fw_ps_map = le32_to_cpu(status->link_ps_bitmap);
 	if (wl->ap_fw_ps_map != cur_fw_ps_map) {
 		wl1271_debug(DEBUG_PSM,
@@ -494,6 +492,8 @@ static int wlcore_fw_status(struct wl1271 *wl,
 	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
 		(s64)le32_to_cpu(status_2->fw_localtime);
 
+	wl->fw_fast_lnk_map = le32_to_cpu(status_2->link_fast_bitmap);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 5ce6248..dd05fab 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -462,8 +462,7 @@ void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 	}
 }
 
-static struct sk_buff_head *wl1271_select_queue(struct wl1271 *wl,
-						struct sk_buff_head *queues)
+static int wlcore_select_ac(struct wl1271 *wl)
 {
 	int i, q = -1, ac;
 	u32 min_pkts = 0xffffffff;
@@ -477,33 +476,24 @@ static struct sk_buff_head *wl1271_select_queue(struct wl1271 *wl,
 	 */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		ac = wl1271_tx_get_queue(i);
-		if (!skb_queue_empty(&queues[ac]) &&
-		    (wl->tx_allocated_pkts[ac] < min_pkts)) {
+		if (wl->tx_queue_count[ac] &&
+		    wl->tx_allocated_pkts[ac] < min_pkts) {
 			q = ac;
 			min_pkts = wl->tx_allocated_pkts[q];
 		}
 	}
 
-	if (q == -1)
-		return NULL;
-
-	return &queues[q];
+	return q;
 }
 
-static struct sk_buff *wl12xx_lnk_skb_dequeue(struct wl1271 *wl,
-					      struct wl1271_link *lnk)
+static struct sk_buff *wlcore_lnk_dequeue(struct wl1271 *wl,
+					  struct wl1271_link *lnk, u8 q)
 {
 	struct sk_buff *skb;
 	unsigned long flags;
-	struct sk_buff_head *queue;
 
-	queue = wl1271_select_queue(wl, lnk->tx_queue);
-	if (!queue)
-		return NULL;
-
-	skb = skb_dequeue(queue);
+	skb = skb_dequeue(&lnk->tx_queue[q]);
 	if (skb) {
-		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		WARN_ON_ONCE(wl->tx_queue_count[q] <= 0);
 		wl->tx_queue_count[q]--;
@@ -517,9 +507,41 @@ static struct sk_buff *wl12xx_lnk_skb_dequeue(struct wl1271 *wl,
 	return skb;
 }
 
-static struct sk_buff *wl12xx_vif_skb_dequeue(struct wl1271 *wl,
-					      struct wl12xx_vif *wlvif,
-					      u8 *hlid)
+static bool wlcore_lnk_high_prio(struct wl1271 *wl, u8 hlid,
+				 struct wl1271_link *lnk)
+{
+	u8 thold;
+
+	if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
+		thold = wl->conf.tx.fast_link_thold;
+	else
+		thold = wl->conf.tx.slow_link_thold;
+
+	return lnk->allocated_pkts < thold;
+}
+
+static struct sk_buff *wlcore_lnk_dequeue_high_prio(struct wl1271 *wl,
+						    u8 hlid, u8 ac,
+						    u8 *low_prio_hlid)
+{
+	struct wl1271_link *lnk = &wl->links[hlid];
+
+	if (!wlcore_lnk_high_prio(wl, hlid, lnk)) {
+		if (*low_prio_hlid == WL12XX_INVALID_LINK_ID &&
+		    !skb_queue_empty(&lnk->tx_queue[ac]))
+			/* we found the first non-empty low priority queue */
+			*low_prio_hlid = hlid;
+
+		return NULL;
+	}
+
+	return wlcore_lnk_dequeue(wl, lnk, ac);
+}
+
+static struct sk_buff *wlcore_vif_dequeue_high_prio(struct wl1271 *wl,
+						    struct wl12xx_vif *wlvif,
+						    u8 ac, u8 *hlid,
+						    u8 *low_prio_hlid)
 {
 	struct sk_buff *skb = NULL;
 	int i, h, start_hlid;
@@ -535,7 +557,8 @@ static struct sk_buff *wl12xx_vif_skb_dequeue(struct wl1271 *wl,
 		if (!test_bit(h, wlvif->links_map))
 			continue;
 
-		skb = wl12xx_lnk_skb_dequeue(wl, &wl->links[h]);
+		skb = wlcore_lnk_dequeue_high_prio(wl, h, ac,
+						   low_prio_hlid);
 		if (!skb)
 			continue;
 
@@ -555,42 +578,74 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl, u8 *hlid)
 	unsigned long flags;
 	struct wl12xx_vif *wlvif = wl->last_wlvif;
 	struct sk_buff *skb = NULL;
+	int ac;
+	u8 low_prio_hlid = WL12XX_INVALID_LINK_ID;
+
+	ac = wlcore_select_ac(wl);
+	if (ac < 0)
+		goto out;
 
 	/* continue from last wlvif (round robin) */
 	if (wlvif) {
 		wl12xx_for_each_wlvif_continue(wl, wlvif) {
-			skb = wl12xx_vif_skb_dequeue(wl, wlvif, hlid);
-			if (skb) {
-				wl->last_wlvif = wlvif;
-				break;
-			}
+			if (!wlvif->tx_queue_count[ac])
+				continue;
+
+			skb = wlcore_vif_dequeue_high_prio(wl, wlvif, ac, hlid,
+							   &low_prio_hlid);
+			if (!skb)
+				continue;
+
+			wl->last_wlvif = wlvif;
+			break;
 		}
 	}
 
 	/* dequeue from the system HLID before the restarting wlvif list */
 	if (!skb) {
-		skb = wl12xx_lnk_skb_dequeue(wl, &wl->links[wl->system_hlid]);
-		*hlid = wl->system_hlid;
+		skb = wlcore_lnk_dequeue_high_prio(wl, wl->system_hlid,
+						   ac, &low_prio_hlid);
+		if (skb) {
+			*hlid = wl->system_hlid;
+			wl->last_wlvif = NULL;
+		}
 	}
 
-	/* do a new pass over the wlvif list */
+	/* Do a new pass over the wlvif list. But no need to continue
+	 * after last_wlvif. The previous pass should have found it. */
 	if (!skb) {
 		wl12xx_for_each_wlvif(wl, wlvif) {
-			skb = wl12xx_vif_skb_dequeue(wl, wlvif, hlid);
+			if (!wlvif->tx_queue_count[ac])
+				goto next;
+
+			skb = wlcore_vif_dequeue_high_prio(wl, wlvif, ac, hlid,
+							   &low_prio_hlid);
 			if (skb) {
 				wl->last_wlvif = wlvif;
 				break;
 			}
 
-			/*
-			 * No need to continue after last_wlvif. The previous
-			 * pass should have found it.
-			 */
+next:
 			if (wlvif == wl->last_wlvif)
 				break;
 		}
 	}
 
+	/* no high priority skbs found - but maybe a low priority one? */
+	if (!skb && low_prio_hlid != WL12XX_INVALID_LINK_ID) {
+		struct wl1271_link *lnk = &wl->links[low_prio_hlid];
+		skb = wlcore_lnk_dequeue(wl, lnk, ac);
+
+		WARN_ON(!skb); /* we checked this before */
+		*hlid = low_prio_hlid;
+
+		/* ensure proper round robin in the vif/link levels */
+		wl->last_wlvif = lnk->wlvif;
+		if (lnk->wlvif)
+			lnk->wlvif->last_tx_hlid = low_prio_hlid;
+
+	}
+
 	if (!skb &&
 	    test_and_clear_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags)) {
 		int q;
@@ -604,6 +659,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl, u8 *hlid)
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 
+out:
 	return skb;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 8417ee2..71137aa 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -361,6 +361,9 @@ struct wl1271 {
 	 */
 	struct wl1271_link links[WL12XX_MAX_LINKS];
 
+	/* Fast/slow links bitmap according to FW */
+	u32 fw_fast_lnk_map;
+
 	/* AP-mode - a bitmap of links currently in PS mode according to FW */
 	u32 ap_fw_ps_map;
 
-- 
1.7.9.5

