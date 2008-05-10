Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:55975 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYEJMKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:41 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148406fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:40 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 4/5] rt2x00: Convert rt2x00 to read control info from skb->cb
Date: Sat, 10 May 2008 13:51:11 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101349.19481.IvDoorn@gmail.com>
In-Reply-To: <200805101349.19481.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101351.11467.IvDoorn@gmail.com> (sfid-20080510_141529_355681_04F8EF44)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert rt2x00lib and all drivers to support the mac80211 change
to move the tx_control and tx_status information into skb->cb

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   14 ++++--
 drivers/net/wireless/rt2x00/rt2500pci.c   |   14 ++++--
 drivers/net/wireless/rt2x00/rt2500usb.c   |   15 ++++--
 drivers/net/wireless/rt2x00/rt2x00.h      |   10 +---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   49 +++++++++----------
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   72 +++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt2x00pci.c   |    8 +--
 drivers/net/wireless/rt2x00/rt2x00pci.h   |    6 +--
 drivers/net/wireless/rt2x00/rt2x00queue.c |   35 +++++++-------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   31 +++++++++----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    9 +--
 drivers/net/wireless/rt2x00/rt2x00usb.h   |    9 +---
 drivers/net/wireless/rt2x00/rt61pci.c     |   14 ++++--
 drivers/net/wireless/rt2x00/rt73usb.c     |   14 ++++--
 14 files changed, 156 insertions(+), 144 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index f5551e5..dffe9a5 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1485,11 +1485,11 @@ static u64 rt2400pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				   struct ieee80211_tx_control *control)
+static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
@@ -1505,14 +1505,18 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index c159da1..0fa057e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1799,11 +1799,11 @@ static u64 rt2500pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				   struct ieee80211_tx_control *control)
+static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
@@ -1820,14 +1820,18 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index a006eb0..85611d3 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1666,13 +1666,12 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 /*
  * IEEE80211 stack callback functions.
  */
-static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
-				   struct sk_buff *skb,
-				   struct ieee80211_tx_control *control)
+static int rt2500usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_usb_bcn *bcn_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
@@ -1691,7 +1690,12 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1704,7 +1708,6 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
 	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
 	skbdesc->desc = skb->data;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1900d4c..5c7220e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -542,8 +542,7 @@ struct rt2x00lib_ops {
 			       struct sk_buff *skb,
 			       struct txentry_desc *txdesc);
 	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
-			      struct data_queue *queue, struct sk_buff *skb,
-			      struct ieee80211_tx_control *control);
+			      struct data_queue *queue, struct sk_buff *skb);
 	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
@@ -930,7 +929,6 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
  * rt2x00queue_create_tx_descriptor - Create TX descriptor from mac80211 input
  * @entry: The entry which will be used to transfer the TX frame.
  * @txdesc: rt2x00 TX descriptor which will be initialized by this function.
- * @control: mac80211 TX control structure from where we read the information.
  *
  * This function will initialize the &struct txentry_desc based on information
  * from mac80211. This descriptor can then be used by rt2x00lib and the drivers
@@ -943,8 +941,7 @@ static inline u16 get_duration_res(const unsigned int size, const u8 rate)
  * the &struct txentry_desc structure.
  */
 void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
-				      struct txentry_desc *txdesc,
-				      struct ieee80211_tx_control *control);
+				      struct txentry_desc *txdesc);
 
 /**
  * rt2x00queue_write_tx_descriptor - Write TX descriptor to hardware
@@ -1001,8 +998,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 /*
  * mac80211 handlers.
  */
-int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		 struct ieee80211_tx_control *control);
+int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
 int rt2x00mac_start(struct ieee80211_hw *hw);
 void rt2x00mac_stop(struct ieee80211_hw *hw);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 30109b3..e35babd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -415,7 +415,6 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 	struct rt2x00_dev *rt2x00dev = data;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct sk_buff *skb;
-	struct ieee80211_tx_control control;
 	struct ieee80211_bss_conf conf;
 	int delayed_flags;
 
@@ -433,9 +432,9 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 	spin_unlock(&intf->lock);
 
 	if (delayed_flags & DELAYED_UPDATE_BEACON) {
-		skb = ieee80211_beacon_get(rt2x00dev->hw, vif, &control);
-		if (skb && rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw,
-							     skb, &control))
+		skb = ieee80211_beacon_get(rt2x00dev->hw, vif);
+		if (skb &&
+		    rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, skb))
 			dev_kfree_skb(skb);
 	}
 
@@ -494,8 +493,13 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc;
-	struct ieee80211_tx_status tx_status;
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(entry->skb);
+
+	/*
+	 * Send frame to debugfs immediately, after this call is completed
+	 * we are going to overwrite the skb->cb array.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
 
 	/*
 	 * Update TX statistics.
@@ -508,21 +512,20 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	/*
 	 * Initialize TX status
 	 */
-	tx_status.flags = 0;
-	tx_status.ack_signal = 0;
-	tx_status.excessive_retries =
+	memset(&tx_info->status, 0, sizeof(tx_info->status));
+	tx_info->status.ack_signal = 0;
+	tx_info->status.excessive_retries =
 	    test_bit(TXDONE_EXCESSIVE_RETRY, &txdesc->flags);
-	tx_status.retry_count = txdesc->retry;
-	memcpy(&tx_status.control, txdesc->control, sizeof(*txdesc->control));
+	tx_info->status.retry_count = txdesc->retry;
 
-	if (!(tx_status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
+	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
-			tx_status.flags |= IEEE80211_TX_STATUS_ACK;
+			tx_info->flags |= IEEE80211_TX_STAT_ACK;
 		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}
 
-	if (tx_status.control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+	if (tx_info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
 		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
 		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
@@ -530,19 +533,13 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	}
 
 	/*
-	 * Send the tx_status to debugfs. Only send the status report
-	 * to mac80211 when the frame originated from there. If this was
-	 * a extra frame coming through a mac80211 library call (RTS/CTS)
-	 * then we should not send the status report back.
-	 * If send to mac80211, mac80211 will clean up the skb structure,
-	 * otherwise we have to do it ourself.
+	 * Only send the status report to mac80211 when the frame
+	 * originated from there. If this was a extra frame coming through
+	 * a mac80211 library call (RTS/CTS) then we should not send the
+	 * status report back.
 	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
-
-	skbdesc = get_skb_frame_desc(entry->skb);
-	if (!(skbdesc->flags & FRAME_DESC_DRIVER_GENERATED))
-		ieee80211_tx_status_irqsafe(rt2x00dev->hw,
-					    entry->skb, &tx_status);
+	if (tx_info->flags & IEEE80211_TX_CTL_READY_FOR_TX)
+		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
 	else
 		dev_kfree_skb_irq(entry->skb);
 	entry->skb = NULL;
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index fe952f0..3791a6c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -31,14 +31,14 @@
 
 static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 				struct data_queue *queue,
-				struct sk_buff *frag_skb,
-				struct ieee80211_tx_control *control)
+				struct sk_buff *frag_skb)
 {
-	struct skb_frame_desc *skbdesc;
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(frag_skb);
+	struct ieee80211_tx_info *rts_info;
 	struct sk_buff *skb;
 	int size;
 
-	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
 		size = sizeof(struct ieee80211_cts);
 	else
 		size = sizeof(struct ieee80211_rts);
@@ -52,23 +52,36 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	skb_reserve(skb, rt2x00dev->hw->extra_tx_headroom);
 	skb_put(skb, size);
 
-	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
-		ieee80211_ctstoself_get(rt2x00dev->hw, control->vif,
-					frag_skb->data, frag_skb->len, control,
+	/*
+	 * Copy TX information over from original frame to
+	 * RTS/CTS frame. Note that we set the no encryption flag
+	 * since we don't want this frame to be encrypted.
+	 * RTS frames should be acked, while CTS-to-self frames
+	 * should not. The ready for TX flag is cleared to prevent
+	 * it being automatically send when the descriptor is
+	 * written to the hardware.
+	 */
+	memcpy(skb->cb, frag_skb->cb, sizeof(skb->cb));
+	rts_info = get_skb_tx_info(skb);
+	rts_info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	rts_info->flags &= ~IEEE80211_TX_CTL_USE_CTS_PROTECT;
+	rts_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
+
+	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+		rts_info->flags |= IEEE80211_TX_CTL_NO_ACK;
+	else
+		rts_info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
+
+	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+		ieee80211_ctstoself_get(rt2x00dev->hw, tx_info->control.vif,
+					frag_skb->data, size, tx_info,
 					(struct ieee80211_cts *)(skb->data));
 	else
-		ieee80211_rts_get(rt2x00dev->hw, control->vif,
-				  frag_skb->data, frag_skb->len, control,
+		ieee80211_rts_get(rt2x00dev->hw, tx_info->control.vif,
+				  frag_skb->data, size, tx_info,
 				  (struct ieee80211_rts *)(skb->data));
 
-	/*
-	 * Initialize skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
-
-	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb, control)) {
+	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb)) {
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
 		return NETDEV_TX_BUSY;
 	}
@@ -76,14 +89,13 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	return NETDEV_TX_OK;
 }
 
-int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		 struct ieee80211_tx_control *control)
+int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
 	struct data_queue *queue;
-	struct skb_frame_desc *skbdesc;
 	u16 frame_control;
 
 	/*
@@ -100,7 +112,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	/*
 	 * Determine which queue to put packet on.
 	 */
-	if (control->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM &&
+	if (tx_info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM &&
 	    test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
 		queue = rt2x00queue_get_queue(rt2x00dev, QID_ATIM);
 	else
@@ -125,27 +137,21 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if (!is_rts_frame(frame_control) && !is_cts_frame(frame_control) &&
-	    (control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
-			       IEEE80211_TXCTL_USE_CTS_PROTECT)) &&
+	    (tx_info->flags & (IEEE80211_TX_CTL_USE_RTS_CTS |
+			       IEEE80211_TX_CTL_USE_CTS_PROTECT)) &&
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
 		if (rt2x00queue_available(queue) <= 1) {
 			ieee80211_stop_queue(rt2x00dev->hw, qid);
 			return NETDEV_TX_BUSY;
 		}
 
-		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb, control)) {
+		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb)) {
 			ieee80211_stop_queue(rt2x00dev->hw, qid);
 			return NETDEV_TX_BUSY;
 		}
 	}
 
-	/*
-	 * Initialize skb descriptor
-	 */
-	skbdesc = get_skb_frame_desc(skb);
-	memset(skbdesc, 0, sizeof(*skbdesc));
-
-	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb, control)) {
+	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb)) {
 		ieee80211_stop_queue(rt2x00dev->hw, qid);
 		return NETDEV_TX_BUSY;
 	}
@@ -380,9 +386,7 @@ int rt2x00mac_config_interface(struct ieee80211_hw *hw,
 	if (conf->type != IEEE80211_IF_TYPE_AP || !conf->beacon)
 		return 0;
 
-	status = rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw,
-						   conf->beacon,
-						   conf->beacon_control);
+	status = rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, conf->beacon);
 	if (status)
 		dev_kfree_skb(conf->beacon);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index e9b16f5..70a3d13 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -35,8 +35,7 @@
  * TX data handlers.
  */
 int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control)
+			    struct data_queue *queue, struct sk_buff *skb)
 {
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
@@ -64,19 +63,19 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	 * for our information.
 	 */
 	entry->skb = skb;
-	rt2x00queue_create_tx_descriptor(entry, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(entry, &txdesc);
 
 	/*
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
-	memcpy(&entry_priv->control, control, sizeof(entry_priv->control));
 	memcpy(entry_priv->data, skb->data, skb->len);
 
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
@@ -167,7 +166,6 @@ void rt2x00pci_txdone(struct rt2x00_dev *rt2x00dev, struct queue_entry *entry,
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	u32 word;
 
-	txdesc->control = &entry_priv->control;
 	rt2x00lib_txdone(entry, txdesc);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 557d15a..37c851e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -91,8 +91,7 @@ rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
  * TX data handlers.
  */
 int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control);
+			    struct data_queue *queue, struct sk_buff *skb);
 
 /**
  * struct queue_entry_priv_pci: Per entry PCI specific information
@@ -101,7 +100,6 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
  * @desc_dma: DMA pointer to &desc.
  * @data: Pointer to device's entry memory.
  * @data_dma: DMA pointer to &data.
- * @control: mac80211 control structure used to transmit data.
  */
 struct queue_entry_priv_pci {
 	__le32 *desc;
@@ -109,8 +107,6 @@ struct queue_entry_priv_pci {
 
 	void *data;
 	dma_addr_t data_dma;
-
-	struct ieee80211_tx_control control;
 };
 
 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5cf4c2f..94e0b8b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -30,13 +30,13 @@
 #include "rt2x00lib.h"
 
 void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
-				      struct txentry_desc *txdesc,
-				      struct ieee80211_tx_control *control)
+				      struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(entry->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
 	struct ieee80211_rate *rate =
-	    ieee80211_get_tx_rate(rt2x00dev->hw, control);
+	    ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
 	const struct rt2x00_rate *hwrate;
 	unsigned int data_length;
 	unsigned int duration;
@@ -64,7 +64,7 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	/*
 	 * Check whether this frame is to be acked.
 	 */
-	if (!(control->flags & IEEE80211_TXCTL_NO_ACK))
+	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK))
 		__set_bit(ENTRY_TXD_ACK, &txdesc->flags);
 
 	/*
@@ -72,23 +72,20 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 */
 	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
 		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
-		if (is_rts_frame(frame_control)) {
+		if (is_rts_frame(frame_control))
 			__set_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags);
-			__set_bit(ENTRY_TXD_ACK, &txdesc->flags);
-		} else {
+		else
 			__set_bit(ENTRY_TXD_CTS_FRAME, &txdesc->flags);
-			__clear_bit(ENTRY_TXD_ACK, &txdesc->flags);
-		}
-		if (control->rts_cts_rate_idx >= 0)
+		if (tx_info->control.rts_cts_rate_idx >= 0)
 			rate =
-			    ieee80211_get_rts_cts_rate(rt2x00dev->hw, control);
+			    ieee80211_get_rts_cts_rate(rt2x00dev->hw, tx_info);
 	}
 
 	/*
 	 * Determine retry information.
 	 */
-	txdesc->retry_limit = control->retry_limit;
-	if (control->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
+	txdesc->retry_limit = tx_info->control.retry_limit;
+	if (tx_info->flags & IEEE80211_TX_CTL_LONG_RETRY_LIMIT)
 		__set_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags);
 
 	/*
@@ -113,7 +110,7 @@ void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 */
 	if (test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags)) {
 		txdesc->ifs = IFS_SIFS;
-	} else if (control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT) {
+	} else if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT) {
 		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags);
 		txdesc->ifs = IFS_BACKOFF;
 	} else {
@@ -167,7 +164,7 @@ void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 				     struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(entry->skb);
 
 	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry->skb, txdesc);
 
@@ -179,11 +176,13 @@ void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
 
 	/*
 	 * We are done writing the frame to the queue entry,
-	 * if this entry is a RTS of CTS-to-self frame we are done,
-	 * otherwise we need to kick the queue.
+	 * also kick the queue in case the correct flags are set,
+	 * note that this will automatically filter beacons and
+	 * RTS/CTS frames since those frames don't have this flag
+	 * set.
 	 */
 	if (rt2x00dev->ops->lib->kick_tx_queue &&
-	    !(skbdesc->flags & FRAME_DESC_DRIVER_GENERATED))
+	    (tx_info->flags & IEEE80211_TX_CTL_READY_FOR_TX))
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev,
 						   entry->queue->qid);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index ac52b9c..871020b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -82,18 +82,19 @@ enum data_queue_qid {
 /**
  * enum skb_frame_desc_flags: Flags for &struct skb_frame_desc
  *
- * @FRAME_DESC_DRIVER_GENERATED: Frame was generated inside driver
- *	and should not be reported back to mac80211 during txdone.
+ * No flags at this time
  */
+/*
 enum skb_frame_desc_flags {
-	FRAME_DESC_DRIVER_GENERATED = 1 << 0,
+
 };
+*/
 
 /**
  * struct skb_frame_desc: Descriptor information for the skb buffer
  *
- * This structure is placed over the skb->cb array, this means that
- * this structure should not exceed the size of that array (48 bytes).
+ * This structure is placed over the driver_data array, this means that
+ * this structure should not exceed the size of that array (40 bytes).
  *
  * @flags: Frame flags, see &enum skb_frame_desc_flags.
  * @data: Pointer to data part of frame (Start of ieee80211 header).
@@ -116,10 +117,24 @@ struct skb_frame_desc {
 	struct queue_entry *entry;
 };
 
+/**
+ * get_skb_tx_info - Obtain the mac80211 TX info from a sk_buff.
+ * @skb: &struct sk_buff from where we obtain the &struct ieee80211_tx_info
+ */
+static inline struct ieee80211_tx_info* get_skb_tx_info(struct sk_buff *skb)
+{
+	return (struct ieee80211_tx_info *)skb->cb;
+}
+
+/**
+ * get_skb_frame_desc - Obtain the rt2x00 frame descriptor from a sk_buff.
+ * @skb: &struct sk_buff from where we obtain the &struct skb_frame_desc
+ */
 static inline struct skb_frame_desc* get_skb_frame_desc(struct sk_buff *skb)
 {
-	BUILD_BUG_ON(sizeof(struct skb_frame_desc) > sizeof(skb->cb));
-	return (struct skb_frame_desc *)&skb->cb[0];
+	BUILD_BUG_ON(sizeof(struct skb_frame_desc) >
+		     IEEE80211_TX_INFO_DRIVER_DATA_SIZE);
+	return (struct skb_frame_desc *)&get_skb_tx_info(skb)->driver_data;
 }
 
 /**
@@ -176,12 +191,10 @@ enum txdone_entry_desc_flags {
  * Summary of information that has been read from the TX frame descriptor
  * after the device is done with transmission.
  *
- * @control: Control structure which was used to transmit the frame.
  * @flags: TX done flags (See &enum txdone_entry_desc_flags).
  * @retry: Retry count.
  */
 struct txdone_entry_desc {
-	struct ieee80211_tx_control *control;
 	unsigned long flags;
 	int retry;
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index e6ced50..ec6a749 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -129,7 +129,6 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 {
 	struct queue_entry *entry = (struct queue_entry *)urb->context;
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	struct txdone_entry_desc txdesc;
 	__le32 *txd = (__le32 *)entry->skb->data;
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
@@ -160,7 +159,6 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	else
 		__set_bit(TXDONE_FAILURE, &txdesc.flags);
 	txdesc.retry = 0;
-	txdesc.control = &entry_priv->control;
 
 	rt2x00lib_txdone(entry, &txdesc);
 
@@ -180,8 +178,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 }
 
 int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control)
+			    struct data_queue *queue, struct sk_buff *skb)
 {
 	struct usb_device *usb_dev = rt2x00dev_usb_dev(rt2x00dev);
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
@@ -207,7 +204,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	 * for our information.
 	 */
 	entry->skb = skb;
-	rt2x00queue_create_tx_descriptor(entry, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(entry, &txdesc);
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -219,13 +216,13 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	 * Fill in skb descriptor
 	 */
 	skbdesc = get_skb_frame_desc(skb);
+	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->data = skb->data + queue->desc_size;
 	skbdesc->data_len = skb->len - queue->desc_size;
 	skbdesc->desc = skb->data;
 	skbdesc->desc_len = queue->desc_size;
 	skbdesc->entry = entry;
 
-	memcpy(&entry_priv->control, control, sizeof(entry_priv->control));
 	rt2x00queue_write_tx_descriptor(entry, &txdesc);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 15b404a..26f53f8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -216,19 +216,15 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev);
  * TX data handlers.
  */
 int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
-			    struct data_queue *queue, struct sk_buff *skb,
-			    struct ieee80211_tx_control *control);
+			    struct data_queue *queue, struct sk_buff *skb);
 
 /**
  * struct queue_entry_priv_usb: Per entry USB specific information
  *
  * @urb: Urb structure used for device communication.
- * @control: mac80211 control structure used to transmit data.
  */
 struct queue_entry_priv_usb {
 	struct urb *urb;
-
-	struct ieee80211_tx_control control;
 };
 
 /**
@@ -239,15 +235,12 @@ struct queue_entry_priv_usb {
  * with beacons.
  *
  * @urb: Urb structure used for device communication.
- * @control: mac80211 control structure used to transmit data.
  * @guardian_data: Set to 0, used for sending the guardian data.
  * @guardian_urb: Urb structure used to send the guardian data.
  */
 struct queue_entry_priv_usb_bcn {
 	struct urb *urb;
 
-	struct ieee80211_tx_control control;
-
 	unsigned int guardian_data;
 	struct urb *guardian_urb;
 };
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ffd5a4c..4a09cc7 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2358,11 +2358,11 @@ static u64 rt61pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				 struct ieee80211_tx_control *control)
+static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct queue_entry_priv_pci *entry_priv;
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
@@ -2378,7 +2378,12 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	entry_priv = intf->beacon->priv_data;
 	memset(entry_priv->desc, 0, intf->beacon->queue->desc_size);
@@ -2388,7 +2393,6 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data;
 	skbdesc->data_len = skb->len;
 	skbdesc->desc = entry_priv->desc;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6d59d41..d3c55a0 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1949,11 +1949,11 @@ static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 #define rt73usb_get_tsf	NULL
 #endif
 
-static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
-				 struct ieee80211_tx_control *control)
+static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(control->vif);
+	struct ieee80211_tx_info *tx_info = get_skb_tx_info(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
 	unsigned int beacon_base;
@@ -1968,7 +1968,12 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * for our information.
 	 */
 	intf->beacon->skb = skb;
-	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc, control);
+	rt2x00queue_create_tx_descriptor(intf->beacon, &txdesc);
+
+	/*
+	 * Don't automatically kick the beacon queue.
+	 */
+	tx_info->flags &= ~IEEE80211_TX_CTL_READY_FOR_TX;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1981,7 +1986,6 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
-	skbdesc->flags |= FRAME_DESC_DRIVER_GENERATED;
 	skbdesc->data = skb->data + intf->beacon->queue->desc_size;
 	skbdesc->data_len = skb->len - intf->beacon->queue->desc_size;
 	skbdesc->desc = skb->data;
-- 
1.5.5.1

