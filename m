Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38374 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab1CaIHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:21 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so1636292fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 01:07:20 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 3/5] wl12xx: Clean up the dummy packet mechanism
Date: Thu, 31 Mar 2011 10:06:59 +0200
Message-Id: <1301558821-17787-4-git-send-email-ido@wizery.com>
In-Reply-To: <1301558821-17787-1-git-send-email-ido@wizery.com>
References: <1301558821-17787-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current implementation allocates a skb each time one is requested by
the firmware. Since dummy packets are handled differently than regular
packets, the skb needs to be marked. Currently, this is done by
setting the pkt_type member to 5. This might not be safe, as we cannot
be sure that there won't be any other packets with this pkt_type value.

Since the packet does not change from one request to another, we can
simply allocate a dummy packet template and always send it. All changes
to the skb done during packet preparation must be reverted, so the same
skb can be reused.

The dummy packets are not transmitted, therefore there's no need to set
the BSSID or our own MAC address.

In addition, the header portion of the packet was zeroed by mistake, so
fix that as well.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   79 +++++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/tx.c     |   43 +++++++++++++-----
 drivers/net/wireless/wl12xx/tx.h     |    2 -
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ++-
 4 files changed, 90 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 960e993..dea26a9 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1212,20 +1212,46 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 }
 
-#define TX_DUMMY_PACKET_SIZE 1400
 int wl1271_tx_dummy_packet(struct wl1271 *wl)
 {
-	struct sk_buff *skb = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	set_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags);
+	wl->tx_queue_count++;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	/* The FW is low on RX memory blocks, so send the dummy packet asap */
+	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags))
+		wl1271_tx_work_locked(wl);
+
+	/*
+	 * If the FW TX is busy, TX work will be scheduled by the threaded
+	 * interrupt handler function
+	 */
+	return 0;
+}
+
+/*
+ * The size of the dummy packet should be at least 1400 bytes. However, in
+ * order to minimize the number of bus transactions, aligning it to 512 bytes
+ * boundaries could be beneficial, performance wise
+ */
+#define TOTAL_TX_DUMMY_PACKET_SIZE (ALIGN(1400, 512))
+
+struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
+{
+	struct sk_buff *skb;
 	struct ieee80211_hdr_3addr *hdr;
-	int ret = 0;
+	unsigned int dummy_packet_size;
+
+	dummy_packet_size = TOTAL_TX_DUMMY_PACKET_SIZE -
+			    sizeof(struct wl1271_tx_hw_descr) - sizeof(*hdr);
 
-	skb = dev_alloc_skb(
-		sizeof(struct wl1271_tx_hw_descr) + sizeof(*hdr) +
-		TX_DUMMY_PACKET_SIZE);
+	skb = dev_alloc_skb(TOTAL_TX_DUMMY_PACKET_SIZE);
 	if (!skb) {
-		wl1271_warning("failed to allocate buffer for dummy packet");
-		ret = -ENOMEM;
-		goto out;
+		wl1271_warning("Failed to allocate a dummy packet skb");
+		return NULL;
 	}
 
 	skb_reserve(skb, sizeof(struct wl1271_tx_hw_descr));
@@ -1233,29 +1259,22 @@ int wl1271_tx_dummy_packet(struct wl1271 *wl)
 	hdr = (struct ieee80211_hdr_3addr *) skb_put(skb, sizeof(*hdr));
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
-					 IEEE80211_FCTL_TODS  |
-					 IEEE80211_STYPE_NULLFUNC);
-
-	memcpy(hdr->addr1, wl->bssid, ETH_ALEN);
-	memcpy(hdr->addr2, wl->mac_addr, ETH_ALEN);
-	memcpy(hdr->addr3, wl->bssid, ETH_ALEN);
+					 IEEE80211_STYPE_NULLFUNC |
+					 IEEE80211_FCTL_TODS);
 
-	skb_put(skb, TX_DUMMY_PACKET_SIZE);
+	memset(skb_put(skb, dummy_packet_size), 0, dummy_packet_size);
 
-	memset(skb->data, 0, TX_DUMMY_PACKET_SIZE);
-
-	skb->pkt_type = TX_PKT_TYPE_DUMMY_REQ;
 	/* Dummy packets require the TID to be management */
 	skb->priority = WL1271_TID_MGMT;
-	/* CONF_TX_AC_VO */
-	skb->queue_mapping = 0;
 
-	wl1271_op_tx(wl->hw, skb);
+	/* Initialize all fields that might be used */
+	skb->queue_mapping = 0;
+	memset(IEEE80211_SKB_CB(skb), 0, sizeof(struct ieee80211_tx_info));
 
-out:
-	return ret;
+	return skb;
 }
 
+
 static struct notifier_block wl1271_dev_notifier = {
 	.notifier_call = wl1271_dev_notify,
 };
@@ -3623,11 +3642,17 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 		goto err_hw;
 	}
 
+	wl->dummy_packet = wl12xx_alloc_dummy_packet(wl);
+	if (!wl->dummy_packet) {
+		ret = -ENOMEM;
+		goto err_aggr;
+	}
+
 	/* Register platform device */
 	ret = platform_device_register(wl->plat_dev);
 	if (ret) {
 		wl1271_error("couldn't register platform device");
-		goto err_aggr;
+		goto err_dummy_packet;
 	}
 	dev_set_drvdata(&wl->plat_dev->dev, wl);
 
@@ -3653,6 +3678,9 @@ err_bt_coex_state:
 err_platform:
 	platform_device_unregister(wl->plat_dev);
 
+err_dummy_packet:
+	dev_kfree_skb(wl->dummy_packet);
+
 err_aggr:
 	free_pages((unsigned long)wl->aggr_buf, order);
 
@@ -3672,6 +3700,7 @@ EXPORT_SYMBOL_GPL(wl1271_alloc_hw);
 int wl1271_free_hw(struct wl1271 *wl)
 {
 	platform_device_unregister(wl->plat_dev);
+	dev_kfree_skb(wl->dummy_packet);
 	free_pages((unsigned long)wl->aggr_buf,
 			get_order(WL1271_AGGR_BUFFER_SIZE));
 	kfree(wl->plat_dev);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index d422f12..18d9655 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -197,6 +197,11 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 	return ret;
 }
 
+static bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb)
+{
+	return wl->dummy_packet == skb;
+}
+
 static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 			      u32 extra, struct ieee80211_tx_info *control,
 			      u8 hlid)
@@ -231,7 +236,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 	desc->tid = skb->priority;
 
-	if (skb->pkt_type == TX_PKT_TYPE_DUMMY_REQ) {
+	if (wl12xx_is_dummy_packet(wl, skb)) {
 		/*
 		 * FW expects the dummy packet to have an invalid session id -
 		 * any session id that is different than the one set in the join
@@ -372,6 +377,10 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	memcpy(wl->aggr_buf + buf_offset, skb->data, skb->len);
 	memset(wl->aggr_buf + buf_offset + skb->len, 0, total_len - skb->len);
 
+	/* Revert side effects in the dummy packet skb, so it can be reused */
+	if (wl12xx_is_dummy_packet(wl, skb))
+		skb_pull(skb, sizeof(struct wl1271_tx_hw_descr));
+
 	return total_len;
 }
 
@@ -484,10 +493,23 @@ out:
 
 static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
 {
+	unsigned long flags;
+	struct sk_buff *skb = NULL;
+
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
-		return wl1271_ap_skb_dequeue(wl);
+		skb = wl1271_ap_skb_dequeue(wl);
+	else
+		skb = wl1271_sta_skb_dequeue(wl);
 
-	return wl1271_sta_skb_dequeue(wl);
+	if (!skb &&
+	    test_and_clear_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags)) {
+		skb = wl->dummy_packet;
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		wl->tx_queue_count--;
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+	}
+
+	return skb;
 }
 
 static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
@@ -495,7 +517,9 @@ static void wl1271_skb_queue_head(struct wl1271 *wl, struct sk_buff *skb)
 	unsigned long flags;
 	int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS) {
+	if (wl12xx_is_dummy_packet(wl, skb)) {
+		set_bit(WL1271_FLAG_DUMMY_PACKET_PENDING, &wl->flags);
+	} else if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		u8 hlid = wl1271_tx_get_hlid(skb);
 		skb_queue_head(&wl->links[hlid].tx_queue[q], skb);
 
@@ -608,8 +632,7 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
 	skb = wl->tx_frames[id];
 	info = IEEE80211_SKB_CB(skb);
 
-	if (skb->pkt_type == TX_PKT_TYPE_DUMMY_REQ) {
-		dev_kfree_skb(skb);
+	if (wl12xx_is_dummy_packet(wl, skb)) {
 		wl1271_free_tx_id(wl, id);
 		return;
 	}
@@ -744,9 +767,7 @@ void wl1271_tx_reset(struct wl1271 *wl)
 				wl1271_debug(DEBUG_TX, "freeing skb 0x%p",
 					     skb);
 
-				if (skb->pkt_type == TX_PKT_TYPE_DUMMY_REQ) {
-					dev_kfree_skb(skb);
-				} else {
+				if (!wl12xx_is_dummy_packet(wl, skb)) {
 					info = IEEE80211_SKB_CB(skb);
 					info->status.rates[0].idx = -1;
 					info->status.rates[0].count = 0;
@@ -772,9 +793,7 @@ void wl1271_tx_reset(struct wl1271 *wl)
 		wl1271_free_tx_id(wl, i);
 		wl1271_debug(DEBUG_TX, "freeing skb 0x%p", skb);
 
-		if (skb->pkt_type == TX_PKT_TYPE_DUMMY_REQ) {
-			dev_kfree_skb(skb);
-		} else {
+		if (!wl12xx_is_dummy_packet(wl, skb)) {
 			/*
 			 * Remove private headers before passing the skb to
 			 * mac80211
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index d6b05d9..fc7835c 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -42,8 +42,6 @@
 #define TX_HW_ATTR_TX_CMPLT_REQ          BIT(12)
 #define TX_HW_ATTR_TX_DUMMY_REQ          BIT(13)
 
-#define TX_PKT_TYPE_DUMMY_REQ            5
-
 #define TX_HW_ATTR_OFST_SAVE_RETRIES     0
 #define TX_HW_ATTR_OFST_HEADER_PAD       1
 #define TX_HW_ATTR_OFST_SESSION_COUNTER  2
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 14b8bc6..87e96ba 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -353,7 +353,8 @@ enum wl12xx_flags {
 	WL1271_FLAG_PSPOLL_FAILURE,
 	WL1271_FLAG_STA_STATE_SENT,
 	WL1271_FLAG_FW_TX_BUSY,
-	WL1271_FLAG_AP_STARTED
+	WL1271_FLAG_AP_STARTED,
+	WL1271_FLAG_DUMMY_PACKET_PENDING,
 };
 
 struct wl1271_link {
@@ -459,6 +460,9 @@ struct wl1271 {
 	/* Intermediate buffer, used for packet aggregation */
 	u8 *aggr_buf;
 
+	/* Reusable dummy packet template */
+	struct sk_buff *dummy_packet;
+
 	/* Network stack work  */
 	struct work_struct netstack_work;
 
-- 
1.7.1

