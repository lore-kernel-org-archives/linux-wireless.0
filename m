Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:46096 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3AQQem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 11:34:42 -0500
Received: by mail-bk0-f45.google.com with SMTP id jk13so1472179bkc.4
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2013 08:34:41 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ivdoorn@gmail.com,
	gwingerde@gmail.com, stf_xl@wp.pl, andihartmann@01019freenet.de,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Improve TX status handling for BlockAckReq frames
Date: Thu, 17 Jan 2013 17:34:32 +0100
Message-Id: <1358440472-26678-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20130117_173446_872626_35BE87A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since rt2800 hardware isn't capable of reporting the TX status of
BlockAckReq frames implement the TX status handling of BARs in
rt2x00lib. We keep track of all BARs that are send out and try to
match incoming BAs to the appropriate BARs. This allows us to report a
more or less accurate TX status for BAR frames which in turn improves
BA session stability.

This is loosley based on Christian Lamparter's patch for carl9170
"carl9170: fix HT peer BA session corruption".

We have to walk the list of pending BARs for every rx'red BA even
though most BAs don't belong to any of these BARs as they are just
acknowledging an AMPDU. To keep that overhead low use RCU which allows
us to walk the list of pending BARs without the need to acquire a lock.
This however requires us to _copy_ relevant information from the BAR
(RA, TA, control field, start sequence number) into our BAR list entry.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c   |    6 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |   20 ++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |  101 ++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   47 +++++++++++++
 4 files changed, 169 insertions(+), 5 deletions(-)

Andreas, if you like you can add your tested-by ...

Thanks,
Helmut

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f139a91..a5c694f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1296,8 +1296,7 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			   !(filter_flags & FIF_CONTROL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PSPOLL,
 			   !(filter_flags & FIF_PSPOLL));
-	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA,
-			   !(filter_flags & FIF_CONTROL));
+	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA, 0);
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR,
 			   !(filter_flags & FIF_CONTROL));
 	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
@@ -5146,8 +5145,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK |
 	    IEEE80211_HW_AMPDU_AGGREGATION |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-	    IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL;
+	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0751b35..b52512b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1016,6 +1016,26 @@ struct rt2x00_dev {
 	 * Protect the interrupt mask register.
 	 */
 	spinlock_t irqmask_lock;
+
+	/*
+	 * List of BlockAckReq TX entries that need driver BlockAck processing.
+	 */
+	struct list_head bar_list;
+	spinlock_t bar_list_lock;
+};
+
+struct rt2x00_bar_list_entry {
+	struct list_head list;
+	struct rcu_head head;
+
+	struct queue_entry *entry;
+	int block_acked;
+
+	/* Relevant parts of the IEEE80211 BAR header */
+	__u8 ra[6];
+	__u8 ta[6];
+	__le16 control;
+	__le16 start_seq_num;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 44f8b3f..b40a538 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -271,6 +271,50 @@ void rt2x00lib_dmadone(struct queue_entry *entry)
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_dmadone);
 
+static inline int rt2x00lib_txdone_bar_status(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct ieee80211_bar *bar = (void *) entry->skb->data;
+	struct rt2x00_bar_list_entry *bar_entry;
+	int ret;
+
+	if (likely(!ieee80211_is_back_req(bar->frame_control)))
+		return 0;
+
+	/*
+	 * Unlike all other frames, the status report for BARs does
+	 * not directly come from the hardware as it is incapable of
+	 * matching a BA to a previously send BAR. The hardware will
+	 * report all BARs as if they weren't acked at all.
+	 *
+	 * Instead the RX-path will scan for incoming BAs and set the
+	 * block_acked flag if it sees one that was likely caused by
+	 * a BAR from us.
+	 *
+	 * Remove remaining BARs here and return their status for
+	 * TX done processing.
+	 */
+	ret = 0;
+	rcu_read_lock();
+	list_for_each_entry_rcu(bar_entry, &rt2x00dev->bar_list, list) {
+		if (bar_entry->entry != entry)
+			continue;
+
+		spin_lock_bh(&rt2x00dev->bar_list_lock);
+		/* Return whether this BAR was blockacked or not */
+		ret = bar_entry->block_acked;
+		/* Remove the BAR from our checklist */
+		list_del_rcu(&bar_entry->list);
+		spin_unlock_bh(&rt2x00dev->bar_list_lock);
+		kfree_rcu(bar_entry, head);
+
+		break;
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 void rt2x00lib_txdone(struct queue_entry *entry,
 		      struct txdone_entry_desc *txdesc)
 {
@@ -324,9 +368,12 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
 
 	/*
-	 * Determine if the frame has been successfully transmitted.
+	 * Determine if the frame has been successfully transmitted and
+	 * remove BARs from our check list while checking for their
+	 * TX status.
 	 */
 	success =
+	    rt2x00lib_txdone_bar_status(entry) ||
 	    test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
 	    test_bit(TXDONE_UNKNOWN, &txdesc->flags);
 
@@ -491,6 +538,50 @@ static void rt2x00lib_sleep(struct work_struct *work)
 				 IEEE80211_CONF_CHANGE_PS);
 }
 
+static void rt2x00lib_rxdone_check_ba(struct rt2x00_dev *rt2x00dev,
+				      struct sk_buff *skb,
+				      struct rxdone_entry_desc *rxdesc)
+{
+	struct rt2x00_bar_list_entry *entry;
+	struct ieee80211_bar *ba = (void *)skb->data;
+
+	if (likely(!ieee80211_is_back(ba->frame_control)))
+		return;
+
+	if (rxdesc->size < sizeof(*ba) + FCS_LEN)
+		return;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(entry, &rt2x00dev->bar_list, list) {
+
+		if (ba->start_seq_num != entry->start_seq_num)
+			continue;
+
+#define TID_CHECK(a, b) (						\
+	((a) & cpu_to_le16(IEEE80211_BAR_CTRL_TID_INFO_MASK)) ==	\
+	((b) & cpu_to_le16(IEEE80211_BAR_CTRL_TID_INFO_MASK)))		\
+
+		if (!TID_CHECK(ba->control, entry->control))
+			continue;
+
+#undef TID_CHECK
+
+		if (compare_ether_addr(ba->ra, entry->ta))
+			continue;
+
+		if (compare_ether_addr(ba->ta, entry->ra))
+			continue;
+
+		/* Mark BAR since we received the according BA */
+		spin_lock_bh(&rt2x00dev->bar_list_lock);
+		entry->block_acked = 1;
+		spin_unlock_bh(&rt2x00dev->bar_list_lock);
+		break;
+	}
+	rcu_read_unlock();
+
+}
+
 static void rt2x00lib_rxdone_check_ps(struct rt2x00_dev *rt2x00dev,
 				      struct sk_buff *skb,
 				      struct rxdone_entry_desc *rxdesc)
@@ -674,6 +765,12 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	rt2x00lib_rxdone_check_ps(rt2x00dev, entry->skb, &rxdesc);
 
 	/*
+	 * Check for incoming BlockAcks to match to the BlockAckReqs
+	 * we've send out.
+	 */
+	rt2x00lib_rxdone_check_ba(rt2x00dev, entry->skb, &rxdesc);
+
+	/*
 	 * Update extra components
 	 */
 	rt2x00link_update_stats(rt2x00dev, entry->skb, &rxdesc);
@@ -1183,6 +1280,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 
 	spin_lock_init(&rt2x00dev->irqmask_lock);
 	mutex_init(&rt2x00dev->csr_mutex);
+	INIT_LIST_HEAD(&rt2x00dev->bar_list);
+	spin_lock_init(&rt2x00dev->bar_list_lock);
 
 	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e488b94..f35d85a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -582,6 +582,48 @@ static void rt2x00queue_kick_tx_queue(struct data_queue *queue,
 		queue->rt2x00dev->ops->lib->kick_queue(queue);
 }
 
+static void rt2x00queue_bar_check(struct queue_entry *entry)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct ieee80211_bar *bar = (void *) (entry->skb->data +
+				    rt2x00dev->ops->extra_tx_headroom);
+	struct rt2x00_bar_list_entry *bar_entry;
+
+	if (likely(!ieee80211_is_back_req(bar->frame_control)))
+		return;
+
+	bar_entry = kmalloc(sizeof(*bar_entry), GFP_ATOMIC);
+
+	/*
+	 * If the alloc fails we still send the BAR out but just don't track
+	 * it in our bar list. And as a result we will report it to mac80211
+	 * back as failed.
+	 */
+	if (!bar_entry)
+		return;
+
+	bar_entry->entry = entry;
+	bar_entry->block_acked = 0;
+
+	/*
+	 * Copy the relevant parts of the 802.11 BAR into out check list
+	 * such that we can use RCU for less-overhead in the RX path since
+	 * sending BARs and processing the according BlockAck should be
+	 * the exception.
+	 */
+	memcpy(bar_entry->ra, bar->ra, sizeof(bar->ra));
+	memcpy(bar_entry->ta, bar->ta, sizeof(bar->ta));
+	bar_entry->control = bar->control;
+	bar_entry->start_seq_num = bar->start_seq_num;
+
+	/*
+	 * Insert BAR into our BAR check list.
+	 */
+	spin_lock_bh(&rt2x00dev->bar_list_lock);
+	list_add_tail_rcu(&bar_entry->list, &rt2x00dev->bar_list);
+	spin_unlock_bh(&rt2x00dev->bar_list_lock);
+}
+
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 			       bool local)
 {
@@ -680,6 +722,11 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 		goto out;
 	}
 
+	/*
+	 * Put BlockAckReqs into our check list for driver BA processing.
+	 */
+	rt2x00queue_bar_check(entry);
+
 	set_bit(ENTRY_DATA_PENDING, &entry->flags);
 
 	rt2x00queue_index_inc(entry, Q_INDEX);
-- 
1.7.7

