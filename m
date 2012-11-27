Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47006 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab2K0Gpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:38 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3808120wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:37 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 17/20] wlcore: count packets held per AC in each vif
Date: Tue, 27 Nov 2012 08:44:58 +0200
Message-Id: <1353998701-18171-18-git-send-email-arik@wizery.com> (sfid-20121127_074550_525608_BA3551A6)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This accounting will help find a vif that has data in a specific AC.
Otherwise we have to traverse all the links, which can be lengthy for
the AP case.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c  |    4 ++++
 drivers/net/wireless/ti/wlcore/main.c     |    2 ++
 drivers/net/wireless/ti/wlcore/ps.c       |    8 ++++++--
 drivers/net/wireless/ti/wlcore/tx.c       |   16 ++++++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    3 +++
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index e61fc2b..f115fba 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -577,6 +577,10 @@ static ssize_t vifs_state_read(struct file *file, char __user *user_buf,
 			VIF_STATE_PRINT_INT(ap.ucast_rate_idx[3]);
 		}
 		VIF_STATE_PRINT_INT(last_tx_hlid);
+		VIF_STATE_PRINT_INT(tx_queue_count[0]);
+		VIF_STATE_PRINT_INT(tx_queue_count[1]);
+		VIF_STATE_PRINT_INT(tx_queue_count[2]);
+		VIF_STATE_PRINT_INT(tx_queue_count[3]);
 		VIF_STATE_PRINT_LHEX(links_map[0]);
 		VIF_STATE_PRINT_NSTR(ssid, wlvif->ssid_len);
 		VIF_STATE_PRINT_INT(band);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3ced59b..d858deb 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1221,6 +1221,8 @@ static void wl1271_op_tx(struct ieee80211_hw *hw,
 	skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
 
 	wl->tx_queue_count[q]++;
+	if (wlvif)
+		wlvif->tx_queue_count[q]++;
 
 	/*
 	 * The workqueue is slow to process the tx_queue and we need stop
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index ffcd843..9b7b6e2 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -239,11 +239,12 @@ static void wl1271_ps_filter_frames(struct wl1271 *wl, u8 hlid)
 	struct ieee80211_tx_info *info;
 	unsigned long flags;
 	int filtered[NUM_TX_QUEUES];
+	struct wl1271_link *lnk = &wl->links[hlid];
 
 	/* filter all frames currently in the low level queues for this hlid */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		filtered[i] = 0;
-		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
+		while ((skb = skb_dequeue(&lnk->tx_queue[i]))) {
 			filtered[i]++;
 
 			if (WARN_ON(wl12xx_is_dummy_packet(wl, skb)))
@@ -257,8 +258,11 @@ static void wl1271_ps_filter_frames(struct wl1271 *wl, u8 hlid)
 	}
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	for (i = 0; i < NUM_TX_QUEUES; i++)
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		wl->tx_queue_count[i] -= filtered[i];
+		if (lnk->wlvif)
+			lnk->wlvif->tx_queue_count[i] -= filtered[i];
+	}
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	wl1271_handle_tx_low_watermark(wl);
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 2e91a37..a5fa54d 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -509,6 +509,10 @@ static struct sk_buff *wl12xx_lnk_skb_dequeue(struct wl1271 *wl,
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		WARN_ON_ONCE(wl->tx_queue_count[q] <= 0);
 		wl->tx_queue_count[q]--;
+		if (lnk->wlvif) {
+			WARN_ON_ONCE(lnk->wlvif->tx_queue_count[q] <= 0);
+			lnk->wlvif->tx_queue_count[q]--;
+		}
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 
@@ -623,6 +627,8 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	wl->tx_queue_count[q]++;
+	if (wlvif)
+		wlvif->tx_queue_count[q]++;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
@@ -972,10 +978,11 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 	unsigned long flags;
 	struct ieee80211_tx_info *info;
 	int total[NUM_TX_QUEUES];
+	struct wl1271_link *lnk = &wl->links[hlid];
 
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		total[i] = 0;
-		while ((skb = skb_dequeue(&wl->links[hlid].tx_queue[i]))) {
+		while ((skb = skb_dequeue(&lnk->tx_queue[i]))) {
 			wl1271_debug(DEBUG_TX, "link freeing skb 0x%p", skb);
 
 			if (!wl12xx_is_dummy_packet(wl, skb)) {
@@ -990,8 +997,11 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 	}
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	for (i = 0; i < NUM_TX_QUEUES; i++)
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
 		wl->tx_queue_count[i] -= total[i];
+		if (lnk->wlvif)
+			lnk->wlvif->tx_queue_count[i] -= total[i];
+	}
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	wl1271_handle_tx_low_watermark(wl);
@@ -1015,6 +1025,8 @@ void wl12xx_tx_reset_wlvif(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 	wlvif->last_tx_hlid = 0;
 
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		wlvif->tx_queue_count[i] = 0;
 }
 /* caller must hold wl->mutex and TX must be stopped */
 void wl12xx_tx_reset(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index f86c716..e9fd879 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -370,6 +370,9 @@ struct wl12xx_vif {
 	/* the hlid of the last transmitted skb */
 	int last_tx_hlid;
 
+	/* counters of packets per AC, across all links in the vif */
+	int tx_queue_count[NUM_TX_QUEUES];
+
 	unsigned long links_map[BITS_TO_LONGS(WL12XX_MAX_LINKS)];
 
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
-- 
1.7.9.5

