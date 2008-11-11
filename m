Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:11458 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYKKXBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 18:01:43 -0500
Received: by nf-out-0910.google.com with SMTP id d3so71656nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 15:01:41 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix TX failure path
Date: Wed, 12 Nov 2008 00:01:37 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811120001.37837.IvDoorn@gmail.com> (sfid-20081112_000148_633622_3B3317C9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The callback function write_tx_data() can only fail
when our ENTRY_OWNER_DEVICE_DATA flag on a queue entry
failed to determine the entry was not available and
it is in fact still owned by the hardware.
This means that if that function fails the queue
must be stopped in mac80211.

When rt2x00queue_get_queue() returns NULL in the TX
path, it means mac80211 has passed us an invalid queue,
although this should be impossible, it shouldn't hurt
if we send mac80211 a signal to stop the queue either.

Both issues can simply be resolved by removing their
manual failure handler and making them use the failure path
provided in rt2x00mac_tx().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 48636b0..4c03957 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -132,8 +132,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		ERROR(rt2x00dev,
 		      "Attempt to send packet over invalid queue %d.\n"
 		      "Please file bug report to %s.\n", qid, DRV_PROJECT);
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
+		goto exit_fail;
 	}
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index d7752db..b8de9d2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -386,7 +386,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	u8 rate_idx, rate_flags;
 
 	if (unlikely(rt2x00queue_full(queue)))
-		return -EINVAL;
+		return -ENOBUFS;
 
 	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags)) {
 		ERROR(queue->rt2x00dev,
@@ -415,7 +415,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	tx_info = IEEE80211_SKB_CB(skb);
 	rate_idx = tx_info->control.rates[0].idx;
 	rate_flags = tx_info->control.rates[0].flags;
-	skbdesc = get_skb_frame_desc(entry->skb);
+	skbdesc = get_skb_frame_desc(skb);
 	memset(skbdesc, 0, sizeof(*skbdesc));
 	skbdesc->entry = entry;
 	skbdesc->tx_rate_idx = rate_idx;
@@ -427,20 +427,18 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	 * the frame so we can provide it to the driver seperately.
 	 */
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc.flags) &&
-	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags)) {
+	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags))
 		rt2x00crypto_tx_remove_iv(skb, iv_len);
-	}
 
 	/*
 	 * It could be possible that the queue was corrupted and this
-	 * call failed. Just drop the frame, we cannot rollback and pass
-	 * the frame to mac80211 because the skb->cb has now been tainted.
+	 * call failed. Since we always return NETDEV_TX_OK to mac80211,
+	 * this frame will simply be dropped.
 	 */
 	if (unlikely(queue->rt2x00dev->ops->lib->write_tx_data(entry))) {
 		clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
-		dev_kfree_skb_any(entry->skb);
 		entry->skb = NULL;
-		return 0;
+		return -EIO;
 	}
 
 	if (test_bit(DRIVER_REQUIRE_DMA, &queue->rt2x00dev->flags))
