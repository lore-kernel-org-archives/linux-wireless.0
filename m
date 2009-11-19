Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZKSAIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 19:08:53 -0500
Subject: [PATCH] mac80211: request TX status where needed
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 01:08:30 +0100
Message-ID: <1258589310.30511.91.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right now all frames mac80211 hands to the driver
have the IEEE80211_TX_CTL_REQ_TX_STATUS flag set to
request TX status. This isn't really necessary, only
the injected frames need TX status (the latter for
hostapd) so move setting this flag.

The rate control algorithms also need TX status, but
they don't require it.

Also, rt2x00 uses that bit for its own purposes and
seems to require it being set for all frames, but
that can be fixed in rt2x00.

This doesn't really change anything for any drivers
but in the future drivers using hw-rate control may
opt to not report TX status for frames that don't
have the IEEE80211_TX_CTL_REQ_TX_STATUS flag set.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com> [rt2x00 bits]
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   11 ++++++-----
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    4 +++-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    5 ++---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    5 ++++-
 include/net/mac80211.h                    |    2 +-
 net/mac80211/tx.c                         |    4 ++--
 7 files changed, 23 insertions(+), 14 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-11-19 01:05:45.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-19 01:05:47.000000000 +0100
@@ -1443,8 +1443,6 @@ static void ieee80211_xmit(struct ieee80
 		        msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
-	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-
 	rcu_read_lock();
 
 	if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
@@ -1575,6 +1573,8 @@ netdev_tx_t ieee80211_monitor_start_xmit
 
 	memset(info, 0, sizeof(*info));
 
+	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+
 	/* pass the radiotap header up to xmit */
 	ieee80211_xmit(IEEE80211_DEV_TO_SUB_IF(dev), skb);
 	return NETDEV_TX_OK;
--- wireless-testing.orig/include/net/mac80211.h	2009-11-19 01:05:44.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-19 01:05:47.000000000 +0100
@@ -219,7 +219,7 @@ struct ieee80211_bss_conf {
  *
  * These flags are used with the @flags member of &ieee80211_tx_info.
  *
- * @IEEE80211_TX_CTL_REQ_TX_STATUS: request TX status callback for this frame.
+ * @IEEE80211_TX_CTL_REQ_TX_STATUS: require TX status callback for this frame.
  * @IEEE80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
  *	number to this frame, taking care of not overwriting the fragment
  *	number and increasing the sequence number only when the
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2009-11-19 01:05:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00dev.c	2009-11-19 01:05:47.000000000 +0100
@@ -205,6 +205,7 @@ void rt2x00lib_txdone(struct queue_entry
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	unsigned int header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
 	u8 rate_idx, rate_flags, retry_rates;
+	u8 skbdesc_flags = skbdesc->flags;
 	unsigned int i;
 	bool success;
 
@@ -287,12 +288,12 @@ void rt2x00lib_txdone(struct queue_entry
 	}
 
 	/*
-	 * Only send the status report to mac80211 when TX status was
-	 * requested by it. If this was a extra frame coming through
-	 * a mac80211 library call (RTS/CTS) then we should not send the
-	 * status report back.
+	 * Only send the status report to mac80211 when it's a frame
+	 * that originated in mac80211. If this was a extra frame coming
+	 * through a mac80211 library call (RTS/CTS) then we should not
+	 * send the status report back.
 	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
+	if (!(skbdesc_flags & SKBDESC_NOT_MAC80211))
 		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb);
 	else
 		dev_kfree_skb_irq(entry->skb);
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00lib.h	2009-11-19 01:05:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00lib.h	2009-11-19 01:05:47.000000000 +0100
@@ -162,8 +162,10 @@ void rt2x00queue_remove_l2pad(struct sk_
  * rt2x00queue_write_tx_frame - Write TX frame to hardware
  * @queue: Queue over which the frame should be send
  * @skb: The skb to send
+ * @local: frame is not from mac80211
  */
-int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb);
+int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
+			       bool local);
 
 /**
  * rt2x00queue_update_beacon - Send new beacon from mac80211 to hardware
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-11-19 01:05:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00mac.c	2009-11-19 01:06:59.000000000 +0100
@@ -66,7 +66,6 @@ static int rt2x00mac_tx_rts_cts(struct r
 	rts_info = IEEE80211_SKB_CB(skb);
 	rts_info->control.rates[0].flags &= ~IEEE80211_TX_RC_USE_RTS_CTS;
 	rts_info->control.rates[0].flags &= ~IEEE80211_TX_RC_USE_CTS_PROTECT;
-	rts_info->flags &= ~IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
 		rts_info->flags |= IEEE80211_TX_CTL_NO_ACK;
@@ -91,7 +90,7 @@ static int rt2x00mac_tx_rts_cts(struct r
 				  frag_skb->data, data_length, tx_info,
 				  (struct ieee80211_rts *)(skb->data));
 
-	retval = rt2x00queue_write_tx_frame(queue, skb);
+	retval = rt2x00queue_write_tx_frame(queue, skb, true);
 	if (retval) {
 		dev_kfree_skb_any(skb);
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
@@ -153,7 +152,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 			goto exit_fail;
 	}
 
-	if (rt2x00queue_write_tx_frame(queue, skb))
+	if (rt2x00queue_write_tx_frame(queue, skb, false))
 		goto exit_fail;
 
 	if (rt2x00queue_threshold(queue))
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00queue.c	2009-11-19 01:05:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00queue.c	2009-11-19 01:05:47.000000000 +0100
@@ -454,7 +454,8 @@ static void rt2x00queue_write_tx_descrip
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, queue->qid);
 }
 
-int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
+int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
+			       bool local)
 {
 	struct ieee80211_tx_info *tx_info;
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
@@ -495,6 +496,9 @@ int rt2x00queue_write_tx_frame(struct da
 	skbdesc->tx_rate_idx = rate_idx;
 	skbdesc->tx_rate_flags = rate_flags;
 
+	if (local)
+		skbdesc->flags |= SKBDESC_NOT_MAC80211;
+
 	/*
 	 * When hardware encryption is supported, and this frame
 	 * is to be encrypted, we should strip the IV/EIV data from
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2x00queue.h	2009-11-19 01:05:43.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2x00queue.h	2009-11-19 01:05:47.000000000 +0100
@@ -94,12 +94,15 @@ enum data_queue_qid {
  *	mac80211 but was stripped for processing by the driver.
  * @SKBDESC_L2_PADDED: Payload has been padded for 4-byte alignment,
  *	the padded bytes are located between header and payload.
+ * @SKBDESC_NOT_MAC80211: Frame didn't originate from mac80211,
+ *	don't try to pass it back.
  */
 enum skb_frame_desc_flags {
 	SKBDESC_DMA_MAPPED_RX = 1 << 0,
 	SKBDESC_DMA_MAPPED_TX = 1 << 1,
 	SKBDESC_IV_STRIPPED = 1 << 2,
-	SKBDESC_L2_PADDED = 1 << 3
+	SKBDESC_L2_PADDED = 1 << 3,
+	SKBDESC_NOT_MAC80211 = 1 << 4,
 };
 
 /**


