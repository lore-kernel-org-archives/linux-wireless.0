Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:17754 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbYGTPsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 11:48:53 -0400
Received: by ik-out-1112.google.com with SMTP id c28so716899ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 08:48:51 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: Fix QOS sequence counting
Date: Sun, 20 Jul 2008 18:03:38 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807201803.38957.IvDoorn@gmail.com> (sfid-20080720_174857_244868_4556AD63)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When IEEE80211_TX_CTL_ASSIGN_SEQ is not set,
the driver should disable hardware sequence counting
to make sure the mac80211 provided counter is used.
This fixes QOS sequence counting, since that is one
of the cases where mac80211 provides a seperate
sequence counter.

By moving the sequence counting code to rt2x00queue
we make sure that _all_ frames get the sequence counter,
including RTS/CTS and Beacon frames.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c   |   13 -------------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   26 ++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 drivers/net/wireless/rt2x00/rt61pci.c     |    3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c     |    3 ++-
 5 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 77af1df..16b72d9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -96,7 +96,6 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
-	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct data_queue *queue;
 	u16 frame_control;
 
@@ -152,18 +151,6 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 	}
 
-	/*
-	 * XXX: This is as wrong as the old mac80211 code was,
-	 *	due to beacons not getting sequence numbers assigned
-	 *	properly.
-	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			intf->seqno += 0x10;
-		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		ieee80211hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
-	}
-
 	if (rt2x00queue_write_tx_frame(queue, skb)) {
 		ieee80211_stop_queue(rt2x00dev->hw, qid);
 		return NETDEV_TX_BUSY;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7f44203..7b581a3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -120,6 +120,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
 	struct ieee80211_rate *rate =
 	    ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
@@ -200,6 +201,31 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	}
 
 	/*
+	 * Hardware should insert sequence counter.
+	 * FIXME: We insert a software sequence counter first for
+	 * hardware that doesn't support hardware sequence counting.
+	 *
+	 * This is wrong because beacons are not getting sequence
+	 * numbers assigned properly.
+	 *
+	 * A secondary problem exists for drivers that cannot toggle
+	 * sequence counting per-frame, since those will override the
+	 * sequence counter given by mac80211.
+	 */
+	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		spin_lock(&intf->lock);
+
+		if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
+			intf->seqno += 0x10;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
+
+		spin_unlock(&intf->lock);
+
+		__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
+	}
+
+	/*
 	 * PLCP setup
 	 * Length calculation depends on OFDM/CCK rate.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 8945945..a4a8c57 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -199,6 +199,7 @@ struct txdone_entry_desc {
  * @ENTRY_TXD_RTS_FRAME: This frame is a RTS frame.
  * @ENTRY_TXD_CTS_FRAME: This frame is a CTS-to-self frame.
  * @ENTRY_TXD_OFDM_RATE: This frame is send out with an OFDM rate.
+ * @ENTRY_TXD_GENERATE_SEQ: This frame requires sequence counter.
  * @ENTRY_TXD_FIRST_FRAGMENT: This is the first frame.
  * @ENTRY_TXD_MORE_FRAG: This frame is followed by another fragment.
  * @ENTRY_TXD_REQ_TIMESTAMP: Require timestamp to be inserted.
@@ -210,6 +211,7 @@ enum txentry_desc_flags {
 	ENTRY_TXD_RTS_FRAME,
 	ENTRY_TXD_CTS_FRAME,
 	ENTRY_TXD_OFDM_RATE,
+	ENTRY_TXD_GENERATE_SEQ,
 	ENTRY_TXD_FIRST_FRAGMENT,
 	ENTRY_TXD_MORE_FRAG,
 	ENTRY_TXD_REQ_TIMESTAMP,
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 70ef7bf..32ba479 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1544,7 +1544,8 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, 1);
+	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE,
+			   test_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W1_BUFFER_COUNT, 1);
 	rt2x00_desc_write(txd, 1, word);
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 0a689cd..029408f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1281,7 +1281,8 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W1_CWMIN, txdesc->cw_min);
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, txdesc->cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, 1);
+	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE,
+			   test_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags));
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
-- 
1.5.6.1

