Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:28480 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbYAFWjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:39:52 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071045ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:39:51 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/12] rt2x00: Always call ieee80211_stop_queue() when return NETDEV_TX_BUSY
Date: Sun, 6 Jan 2008 23:38:34 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062338.34687.IvDoorn@gmail.com> (sfid-20080106_224007_168817_5412784C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently it was possible that ieee80211_stop_queue() was not full while
NETDEV_TX_BUSY was being reported back. I think that is what causing the WARN_ON().
This moves all calls to ieee80211_stop_queue() in rt2x00mac.c where it is easier
to determine if the queue should be halted.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   17 +++++++++++++----
 drivers/net/wireless/rt2x00/rt2x00pci.c |    8 +-------
 drivers/net/wireless/rt2x00/rt2x00usb.c |    8 +-------
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 86b6a33..978cffb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -84,7 +84,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 */
 	if (!test_bit(DEVICE_PRESENT, &rt2x00dev->flags)) {
 		ieee80211_stop_queues(hw);
-		return 0;
+		return NETDEV_TX_OK;
 	}
 
 	/*
@@ -110,15 +110,24 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (!is_rts_frame(frame_control) && !is_cts_frame(frame_control) &&
 	    (control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
 			       IEEE80211_TXCTL_USE_CTS_PROTECT))) {
-		if (rt2x00_ring_free(ring) <= 1)
+		if (rt2x00_ring_free(ring) <= 1) {
+			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
 			return NETDEV_TX_BUSY;
+		}
 
-		if (rt2x00mac_tx_rts_cts(rt2x00dev, ring, skb, control))
+		if (rt2x00mac_tx_rts_cts(rt2x00dev, ring, skb, control)) {
+			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
 			return NETDEV_TX_BUSY;
+		}
 	}
 
-	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, ring, skb, control))
+	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, ring, skb, control)) {
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
 		return NETDEV_TX_BUSY;
+	}
+
+	if (rt2x00_ring_full(ring))
+		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
 
 	if (rt2x00dev->ops->lib->kick_tx_queue)
 		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index abeffdb..70cb81c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -86,10 +86,8 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	struct skb_desc *desc;
 	u32 word;
 
-	if (rt2x00_ring_full(ring)) {
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+	if (rt2x00_ring_full(ring))
 		return -EINVAL;
-	}
 
 	rt2x00_desc_read(txd, 0, &word);
 
@@ -99,7 +97,6 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
 		      control->queue, DRV_PROJECT);
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
 		return -EINVAL;
 	}
 
@@ -119,9 +116,6 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_ring_index_inc(ring);
 
-	if (rt2x00_ring_full(ring))
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 82e95b9..7aba357 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -179,17 +179,14 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	struct skb_desc *desc;
 	u32 length;
 
-	if (rt2x00_ring_full(ring)) {
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
+	if (rt2x00_ring_full(ring))
 		return -EINVAL;
-	}
 
 	if (test_bit(ENTRY_OWNER_NIC, &entry->flags)) {
 		ERROR(rt2x00dev,
 		      "Arrived at non-free entry in the non-full queue %d.\n"
 		      "Please file bug report to %s.\n",
 		      control->queue, DRV_PROJECT);
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
 		return -EINVAL;
 	}
 
@@ -229,9 +226,6 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_ring_index_inc(ring);
 
-	if (rt2x00_ring_full(ring))
-		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_write_tx_data);
-- 
1.5.3.7

