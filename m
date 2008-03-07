Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:49673 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYCGOvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 09:51:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add TX statistics debugging counters
Date: Fri, 7 Mar 2008 15:50:02 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200803071550.03185.mb@bu3sch.de> (sfid-20080307_145144_764061_99548691)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a few debugging counters, that are useful for debugging the
"card does not transmit" or "connection is unstable" kind of problems.
It's also useful for tuning an RC algorithm.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-03-06 16:30:32.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-03-07 15:42:18.000000000 +0100
@@ -35,12 +35,13 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/etherdevice.h>
+#include <asm/div64.h>
 
 
 /* 32bit DMA ops. */
 static
 struct b43_dmadesc_generic *op32_idx2desc(struct b43_dmaring *ring,
 					  int slot,
@@ -875,22 +876,58 @@ struct b43_dmaring *b43_setup_dmaring(st
       err_kfree_ring:
 	kfree(ring);
 	ring = NULL;
 	goto out;
 }
 
+#define divide(a, b)	({	\
+	typeof(a) __a = a;	\
+	do_div(__a, b);		\
+	__a;			\
+  })
+
+#define modulo(a, b)	({	\
+	typeof(a) __a = a;	\
+	do_div(__a, b);		\
+  })
+
 /* Main cleanup function. */
 static void b43_destroy_dmaring(struct b43_dmaring *ring,
 				const char *ringname)
 {
 	if (!ring)
 		return;
 
-	b43dbg(ring->dev->wl, "DMA-%u %s max used slots: %d/%d\n",
-	       (unsigned int)(ring->type), ringname,
-	       ring->max_used_slots, ring->nr_slots);
+#ifdef CONFIG_B43_DEBUG
+	{
+		/* Print some statistics. */
+		u64 failed_packets = ring->nr_failed_tx_packets;
+		u64 succeed_packets = ring->nr_succeed_tx_packets;
+		u64 nr_packets = failed_packets + succeed_packets;
+		u64 permille_failed = 0, average_tries = 0;
+
+		if (nr_packets)
+			permille_failed = divide(failed_packets * 1000, nr_packets);
+		if (nr_packets)
+			average_tries = divide(ring->nr_total_packet_tries * 100, nr_packets);
+
+		b43dbg(ring->dev->wl, "DMA-%u %s: "
+		       "Used slots %d/%d, Failed frames %llu/%llu = %llu.%01llu%%, "
+		       "Average tries %llu.%02llu\n",
+		       (unsigned int)(ring->type), ringname,
+		       ring->max_used_slots,
+		       ring->nr_slots,
+		       (unsigned long long)failed_packets,
+		       (unsigned long long)succeed_packets,
+		       (unsigned long long)divide(permille_failed, 10),
+		       (unsigned long long)modulo(permille_failed, 10),
+		       (unsigned long long)divide(average_tries, 100),
+		       (unsigned long long)modulo(average_tries, 100));
+	}
+#endif /* DEBUG */
+
 	/* Device IRQs are disabled prior entering this function,
 	 * so no need to take care of concurrency with rx handler stuff.
 	 */
 	dmacontroller_cleanup(ring);
 	free_all_descbuffers(ring);
 	free_ringmemory(ring);
@@ -1267,12 +1304,44 @@ int b43_dma_tx(struct b43_wldev *dev,
 out_unlock:
 	spin_unlock_irqrestore(&ring->lock, flags);
 
 	return err;
 }
 
+static void b43_fill_txstatus_report(struct b43_dmaring *ring,
+				    struct ieee80211_tx_status *report,
+				    const struct b43_txstatus *status)
+{
+	bool frame_failed = 0;
+
+	if (status->acked) {
+		/* The frame was ACKed. */
+		report->flags |= IEEE80211_TX_STATUS_ACK;
+	} else {
+		/* The frame was not ACKed... */
+		if (!(report->control.flags & IEEE80211_TXCTL_NO_ACK)) {
+			/* ...but we expected an ACK. */
+			frame_failed = 1;
+			report->excessive_retries = 1;
+		}
+	}
+	if (status->frame_count == 0) {
+		/* The frame was not transmitted at all. */
+		report->retry_count = 0;
+	} else {
+		report->retry_count = status->frame_count - 1;
+#ifdef CONFIG_B43_DEBUG
+		if (frame_failed)
+			ring->nr_failed_tx_packets++;
+		else
+			ring->nr_succeed_tx_packets++;
+		ring->nr_total_packet_tries += status->frame_count;
+#endif /* DEBUG */
+	}
+}
+
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status)
 {
 	const struct b43_dma_ops *ops;
 	struct b43_dmaring *ring;
 	struct b43_dmadesc_generic *desc;
@@ -1301,24 +1370,13 @@ void b43_dma_handle_txstatus(struct b43_
 		if (meta->is_last_fragment) {
 			B43_WARN_ON(!meta->skb);
 			/* Call back to inform the ieee80211 subsystem about the
 			 * status of the transmission.
 			 * Some fields of txstat are already filled in dma_tx().
 			 */
-			if (status->acked) {
-				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
-			} else {
-				if (!(meta->txstat.control.flags
-				      & IEEE80211_TXCTL_NO_ACK))
-					meta->txstat.excessive_retries = 1;
-			}
-			if (status->frame_count == 0) {
-				/* The frame was not transmitted at all. */
-				meta->txstat.retry_count = 0;
-			} else
-				meta->txstat.retry_count = status->frame_count - 1;
+			b43_fill_txstatus_report(ring, &(meta->txstat), status);
 			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb,
 						    &(meta->txstat));
 			/* skb is freed by ieee80211_tx_status_irqsafe() */
 			meta->skb = NULL;
 		} else {
 			/* No need to call free_descriptor_buffer here, as
Index: wireless-testing/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2008-03-06 16:15:23.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2008-03-06 20:09:46.000000000 +0100
@@ -253,13 +253,19 @@ struct b43_dmaring {
 	struct b43_wldev *dev;
 #ifdef CONFIG_B43_DEBUG
 	/* Maximum number of used slots. */
 	int max_used_slots;
 	/* Last time we injected a ring overflow. */
 	unsigned long last_injected_overflow;
-#endif				/* CONFIG_B43_DEBUG */
+	/* Statistics: Number of successfully transmitted packets */
+	u64 nr_succeed_tx_packets;
+	/* Statistics: Number of failed TX packets */
+	u64 nr_failed_tx_packets;
+	/* Statistics: Total number of TX plus all retries. */
+	u64 nr_total_packet_tries;
+#endif /* CONFIG_B43_DEBUG */
 };
 
 static inline u32 b43_dma_read(struct b43_dmaring *ring, u16 offset)
 {
 	return b43_read32(ring->dev, ring->mmio_base + offset);
 }
