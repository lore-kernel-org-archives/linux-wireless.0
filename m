Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34157 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2G0HLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 03:11:41 -0400
Received: by mail-we0-f174.google.com with SMTP id x8so1876605wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 00:11:41 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] wlcore: don't get the hlid from a queued skb
Date: Fri, 27 Jul 2012 10:11:32 +0300
Message-Id: <1343373093-10065-2-git-send-email-arik@wizery.com> (sfid-20120727_091144_876748_44F9E2E3)
In-Reply-To: <1343373093-10065-1-git-send-email-arik@wizery.com>
References: <1343373093-10065-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a bug hiding here since the hlid was sometimes inferred from
the sta, which might be invalid at this point.

Instead, propagate the hlid from the skb-queue where we got the skb
in the first place.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/tx.c |   46 ++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index c1d9320..da4a329 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -344,13 +344,12 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 /* caller must hold wl->mutex */
 static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-				   struct sk_buff *skb, u32 buf_offset)
+				   struct sk_buff *skb, u32 buf_offset, u8 hlid)
 {
 	struct ieee80211_tx_info *info;
 	u32 extra = 0;
 	int ret = 0;
 	u32 total_len;
-	u8 hlid;
 	bool is_dummy;
 	bool is_gem = false;
 
@@ -359,9 +358,13 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		return -EINVAL;
 	}
 
+	if (hlid == WL12XX_INVALID_LINK_ID) {
+		wl1271_error("invalid hlid. dropping skb 0x%p", skb);
+		return -EINVAL;
+	}
+
 	info = IEEE80211_SKB_CB(skb);
 
-	/* TODO: handle dummy packets on multi-vifs */
 	is_dummy = wl12xx_is_dummy_packet(wl, skb);
 
 	if ((wl->quirks & WLCORE_QUIRK_TKIP_HEADER_SPACE) &&
@@ -386,11 +389,6 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 		is_gem = (cipher == WL1271_CIPHER_SUITE_GEM);
 	}
-	hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
-	if (hlid == WL12XX_INVALID_LINK_ID) {
-		wl1271_error("invalid hlid. dropping skb 0x%p", skb);
-		return -EINVAL;
-	}
 
 	ret = wl1271_tx_allocate(wl, wlvif, skb, extra, buf_offset, hlid,
 				 is_gem);
@@ -517,7 +515,8 @@ static struct sk_buff *wl12xx_lnk_skb_dequeue(struct wl1271 *wl,
 }
 
 static struct sk_buff *wl12xx_vif_skb_dequeue(struct wl1271 *wl,
-					      struct wl12xx_vif *wlvif)
+					      struct wl12xx_vif *wlvif,
+					      u8 *hlid)
 {
 	struct sk_buff *skb = NULL;
 	int i, h, start_hlid;
@@ -544,10 +543,11 @@ static struct sk_buff *wl12xx_vif_skb_dequeue(struct wl1271 *wl,
 	if (!skb)
 		wlvif->last_tx_hlid = 0;
 
+	*hlid = wlvif->last_tx_hlid;
 	return skb;
 }
 
-static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
+static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl, u8 *hlid)
 {
 	unsigned long flags;
 	struct wl12xx_vif *wlvif = wl->last_wlvif;
@@ -556,7 +556,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 	/* continue from last wlvif (round robin) */
 	if (wlvif) {
 		wl12xx_for_each_wlvif_continue(wl, wlvif) {
-			skb = wl12xx_vif_skb_dequeue(wl, wlvif);
+			skb = wl12xx_vif_skb_dequeue(wl, wlvif, hlid);
 			if (skb) {
 				wl->last_wlvif = wlvif;
 				break;
@@ -565,13 +565,15 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 	}
 
 	/* dequeue from the system HLID before the restarting wlvif list */
-	if (!skb)
+	if (!skb) {
 		skb = wl12xx_lnk_skb_dequeue(wl, &wl->links[wl->system_hlid]);
+		*hlid = wl->system_hlid;
+	}
 
 	/* do a new pass over the wlvif list */
 	if (!skb) {
 		wl12xx_for_each_wlvif(wl, wlvif) {
-			skb = wl12xx_vif_skb_dequeue(wl, wlvif);
+			skb = wl12xx_vif_skb_dequeue(wl, wlvif, hlid);
 			if (skb) {
 				wl->last_wlvif = wlvif;
 				break;
@@ -591,6 +593,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 		int q;
 
 		skb = wl->dummy_packet;
+		*hlid = wl->system_hlid;
 		q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		WARN_ON_ONCE(wl->tx_queue_count[q] <= 0);
@@ -602,7 +605,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 }
 
 static void wl1271_skb_queue_head(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-				  struct sk_buff *skb)
+				  struct sk_buff *skb, u8 hlid)
 {
 	unsigned long flags;
 	int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
@@ -610,7 +613,6 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (wl12xx_is_dummy_packet(wl, skb)) {
 		set_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags);
 	} else {
-		u8 hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
 		skb_queue_head(&wl->links[hlid].tx_queue[q], skb);
 
 		/* make sure we dequeue the same packet next time */
@@ -686,26 +688,30 @@ int wlcore_tx_work_locked(struct wl1271 *wl)
 	unsigned long active_hlids[BITS_TO_LONGS(WL12XX_MAX_LINKS)] = {0};
 	int ret = 0;
 	int bus_ret = 0;
+	u8 hlid;
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		return 0;
 
-	while ((skb = wl1271_skb_dequeue(wl))) {
+	while ((skb = wl1271_skb_dequeue(wl, &hlid))) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		bool has_data = false;
 
 		wlvif = NULL;
 		if (!wl12xx_is_dummy_packet(wl, skb) && info->control.vif)
 			wlvif = wl12xx_vif_to_data(info->control.vif);
+		else
+			hlid = wl->system_hlid;
 
 		has_data = wlvif && wl1271_tx_is_data_present(skb);
-		ret = wl1271_prepare_tx_frame(wl, wlvif, skb, buf_offset);
+		ret = wl1271_prepare_tx_frame(wl, wlvif, skb, buf_offset,
+					      hlid);
 		if (ret == -EAGAIN) {
 			/*
 			 * Aggregation buffer is full.
 			 * Flush buffer and try again.
 			 */
-			wl1271_skb_queue_head(wl, wlvif, skb);
+			wl1271_skb_queue_head(wl, wlvif, skb, hlid);
 
 			buf_offset = wlcore_hw_pre_pkt_send(wl, buf_offset,
 							    last_len);
@@ -722,7 +728,7 @@ int wlcore_tx_work_locked(struct wl1271 *wl)
 			 * Firmware buffer is full.
 			 * Queue back last skb, and stop aggregating.
 			 */
-			wl1271_skb_queue_head(wl, wlvif, skb);
+			wl1271_skb_queue_head(wl, wlvif, skb, hlid);
 			/* No work left, avoid scheduling redundant tx work */
 			set_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 			goto out_ack;
@@ -732,7 +738,7 @@ int wlcore_tx_work_locked(struct wl1271 *wl)
 				 * fw still expects dummy packet,
 				 * so re-enqueue it
 				 */
-				wl1271_skb_queue_head(wl, wlvif, skb);
+				wl1271_skb_queue_head(wl, wlvif, skb, hlid);
 			else
 				ieee80211_free_txskb(wl->hw, skb);
 			goto out_ack;
-- 
1.7.9.5

