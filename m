Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:37587 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbXHBPyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:54:09 -0400
Date: Thu, 02 Aug 2007 10:53:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 7/10] Port of bcm43xx from softmac to mac80211
Message-ID: <46b1fe11.Gsl6cDeg5nKUtdi+%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This if file 7 of 10 of the port of the bcm43xx driver from softmac
to mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_pio.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_pio.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_pio.c
@@ -4,7 +4,7 @@
 
   PIO Transmission
 
-  Copyright (c) 2005 Michael Buesch <mbuesch@freenet.de>
+  Copyright (c) 2005 Michael Buesch <mb@bu3sch.de>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -27,7 +27,6 @@
 #include "bcm43xx_pio.h"
 #include "bcm43xx_main.h"
 #include "bcm43xx_xmit.h"
-#include "bcm43xx_power.h"
 
 #include <linux/delay.h>
 
@@ -54,19 +53,20 @@ static void tx_octet(struct bcm43xx_pioq
 	}
 }
 
-static u16 tx_get_next_word(struct bcm43xx_txhdr *txhdr,
+static u16 tx_get_next_word(const u8 *txhdr,
 			    const u8 *packet,
+			    size_t txhdr_size,
 			    unsigned int *pos)
 {
 	const u8 *source;
 	unsigned int i = *pos;
 	u16 ret;
 
-	if (i < sizeof(*txhdr)) {
-		source = (const u8 *)txhdr;
+	if (i < txhdr_size) {
+		source = txhdr;
 	} else {
 		source = packet;
-		i -= sizeof(*txhdr);
+		i -= txhdr_size;
 	}
 	ret = le16_to_cpu( *((u16 *)(source + i)) );
 	*pos += 2;
@@ -75,7 +75,7 @@ static u16 tx_get_next_word(struct bcm43
 }
 
 static void tx_data(struct bcm43xx_pioqueue *queue,
-		    struct bcm43xx_txhdr *txhdr,
+		    u8 *txhdr,
 		    const u8 *packet,
 		    unsigned int octets)
 {
@@ -83,18 +83,21 @@ static void tx_data(struct bcm43xx_pioqu
 	unsigned int i = 0;
 
 	if (queue->need_workarounds) {
-		data = tx_get_next_word(txhdr, packet, &i);
+		data = tx_get_next_word(txhdr, packet,
+					sizeof(struct bcm43xx_txhdr_fw3), &i);
 		bcm43xx_pio_write(queue, BCM43xx_PIO_TXDATA, data);
 	}
 	bcm43xx_pio_write(queue, BCM43xx_PIO_TXCTL,
 			  BCM43xx_PIO_TXCTL_WRITELO |
 			  BCM43xx_PIO_TXCTL_WRITEHI);
 	while (i < octets - 1) {
-		data = tx_get_next_word(txhdr, packet, &i);
+		data = tx_get_next_word(txhdr, packet,
+					sizeof(struct bcm43xx_txhdr_fw3), &i);
 		bcm43xx_pio_write(queue, BCM43xx_PIO_TXDATA, data);
 	}
 	if (octets % 2)
-		tx_octet(queue, packet[octets - sizeof(*txhdr) - 1]);
+		tx_octet(queue, packet[octets -
+			 sizeof(struct bcm43xx_txhdr_fw3) - 1]);
 }
 
 static void tx_complete(struct bcm43xx_pioqueue *queue,
@@ -135,21 +138,21 @@ static u16 generate_cookie(struct bcm43x
 		cookie = 0x3000;
 		break;
 	default:
-		assert(0);
+		BCM43xx_WARN_ON(1);
 	}
 	packetindex = pio_txpacket_getindex(packet);
-	assert(((u16)packetindex & 0xF000) == 0x0000);
+	BCM43xx_WARN_ON(!(((u16)packetindex & 0xF000) == 0x0000));
 	cookie |= (u16)packetindex;
 
 	return cookie;
 }
 
 static
-struct bcm43xx_pioqueue * parse_cookie(struct bcm43xx_private *bcm,
+struct bcm43xx_pioqueue *parse_cookie(struct bcm43xx_wldev *dev,
 				       u16 cookie,
 				       struct bcm43xx_pio_txpacket **packet)
 {
-	struct bcm43xx_pio *pio = bcm43xx_current_pio(bcm);
+	struct bcm43xx_pio *pio = &dev->pio;
 	struct bcm43xx_pioqueue *queue = NULL;
 	int packetindex;
 
@@ -167,33 +170,42 @@ struct bcm43xx_pioqueue * parse_cookie(s
 		queue = pio->queue3;
 		break;
 	default:
-		assert(0);
+		BCM43xx_WARN_ON(1);
 	}
 	packetindex = (cookie & 0x0FFF);
-	assert(packetindex >= 0 && packetindex < BCM43xx_PIO_MAXTXPACKETS);
+	BCM43xx_WARN_ON(!(packetindex >= 0 && packetindex
+			  < BCM43xx_PIO_MAXTXPACKETS));
 	*packet = &(queue->tx_packets_cache[packetindex]);
 
 	return queue;
 }
 
+union txhdr_union {
+	struct bcm43xx_txhdr_fw3 txhdr_fw3;
+};
+
 static void pio_tx_write_fragment(struct bcm43xx_pioqueue *queue,
 				  struct sk_buff *skb,
-				  struct bcm43xx_pio_txpacket *packet)
+				  struct bcm43xx_pio_txpacket *packet,
+				  size_t txhdr_size)
 {
-	struct bcm43xx_txhdr txhdr;
+	union txhdr_union txhdr_data;
+	u8 *txhdr = NULL;
 	unsigned int octets;
 
-	assert(skb_shinfo(skb)->nr_frags == 0);
-	bcm43xx_generate_txhdr(queue->bcm,
-			       &txhdr, skb->data, skb->len,
-			       (packet->xmitted_frags == 0),
+	txhdr = (u8 *)(&txhdr_data.txhdr_fw3);
+
+	BCM43xx_WARN_ON(skb_shinfo(skb)->nr_frags != 0);
+	bcm43xx_generate_txhdr(queue->dev,
+			       txhdr, skb->data, skb->len,
+			       &packet->txstat.control,
 			       generate_cookie(queue, packet));
 
 	tx_start(queue);
-	octets = skb->len + sizeof(txhdr);
+	octets = skb->len + txhdr_size;
 	if (queue->need_workarounds)
 		octets--;
-	tx_data(queue, &txhdr, (u8 *)skb->data, octets);
+	tx_data(queue, txhdr, (u8 *)skb->data, octets);
 	tx_complete(queue, skb);
 }
 
@@ -202,52 +214,53 @@ static void free_txpacket(struct bcm43xx
 {
 	struct bcm43xx_pioqueue *queue = packet->queue;
 
-	ieee80211_txb_free(packet->txb);
+	if (packet->skb) {
+		if (irq_context)
+			dev_kfree_skb_irq(packet->skb);
+		else
+			dev_kfree_skb(packet->skb);
+	}
 	list_move(&packet->list, &queue->txfree);
 	queue->nr_txfree++;
-
-	assert(queue->tx_devq_used >= packet->xmitted_octets);
-	assert(queue->tx_devq_packets >= packet->xmitted_frags);
-	queue->tx_devq_used -= packet->xmitted_octets;
-	queue->tx_devq_packets -= packet->xmitted_frags;
 }
 
 static int pio_tx_packet(struct bcm43xx_pio_txpacket *packet)
 {
 	struct bcm43xx_pioqueue *queue = packet->queue;
-	struct ieee80211_txb *txb = packet->txb;
-	struct sk_buff *skb;
+	struct sk_buff *skb = packet->skb;
 	u16 octets;
-	int i;
 
-	for (i = packet->xmitted_frags; i < txb->nr_frags; i++) {
-		skb = txb->fragments[i];
-
-		octets = (u16)skb->len + sizeof(struct bcm43xx_txhdr);
-		assert(queue->tx_devq_size >= octets);
-		assert(queue->tx_devq_packets <= BCM43xx_PIO_MAXTXDEVQPACKETS);
-		assert(queue->tx_devq_used <= queue->tx_devq_size);
-		/* Check if there is sufficient free space on the device
-		 * TX queue. If not, return and let the TX tasklet
-		 * retry later.
-		 */
-		if (queue->tx_devq_packets == BCM43xx_PIO_MAXTXDEVQPACKETS)
-			return -EBUSY;
-		if (queue->tx_devq_used + octets > queue->tx_devq_size)
-			return -EBUSY;
-		/* Now poke the device. */
-		pio_tx_write_fragment(queue, skb, packet);
+	octets = (u16)skb->len + sizeof(struct bcm43xx_txhdr_fw3);
+	if (queue->tx_devq_size < octets) {
+		bcmwarn(queue->dev->wl, "PIO queue too small. "
+			"Dropping packet.\n");
+		/* Drop it silently (return success) */
+		free_txpacket(packet, 1);
+		return 0;
+	}
+	BCM43xx_WARN_ON(queue->tx_devq_packets > BCM43xx_PIO_MAXTXDEVQPACKETS);
+	BCM43xx_WARN_ON(queue->tx_devq_used > queue->tx_devq_size);
+	/* Check if there is sufficient free space on the device
+	 * TX queue. If not, return and let the TX tasklet
+	 * retry later.
+	 */
+	if (queue->tx_devq_packets == BCM43xx_PIO_MAXTXDEVQPACKETS)
+		return -EBUSY;
+	if (queue->tx_devq_used + octets > queue->tx_devq_size)
+		return -EBUSY;
+	/* Now poke the device. */
+	pio_tx_write_fragment(queue, skb, packet,
+			      sizeof(struct bcm43xx_txhdr_fw3));
 
-		/* Account for the packet size.
-		 * (We must not overflow the device TX queue)
-		 */
-		queue->tx_devq_packets++;
-		queue->tx_devq_used += octets;
+	/* Account for the packet size.
+	 * (We must not overflow the device TX queue)
+	 */
+	queue->tx_devq_packets++;
+	queue->tx_devq_used += octets;
 
-		assert(packet->xmitted_frags < packet->txb->nr_frags);
-		packet->xmitted_frags++;
-		packet->xmitted_octets += octets;
-	}
+	/* Transmission started, everything ok, move the
+	 * packet to the txrunning list.
+	 */
 	list_move_tail(&packet->list, &queue->txrunning);
 
 	return 0;
@@ -256,14 +269,13 @@ static int pio_tx_packet(struct bcm43xx_
 static void tx_tasklet(unsigned long d)
 {
 	struct bcm43xx_pioqueue *queue = (struct bcm43xx_pioqueue *)d;
-	struct bcm43xx_private *bcm = queue->bcm;
+	struct bcm43xx_wldev *dev = queue->dev;
 	unsigned long flags;
 	struct bcm43xx_pio_txpacket *packet, *tmp_packet;
 	int err;
 	u16 txctl;
 
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
 	if (queue->tx_frozen)
 		goto out_unlock;
 	txctl = bcm43xx_pio_read(queue, BCM43xx_PIO_TXCTL);
@@ -271,36 +283,19 @@ static void tx_tasklet(unsigned long d)
 		goto out_unlock;
 
 	list_for_each_entry_safe(packet, tmp_packet, &queue->txqueue, list) {
-		assert(packet->xmitted_frags < packet->txb->nr_frags);
-		if (packet->xmitted_frags == 0) {
-			int i;
-			struct sk_buff *skb;
-
-			/* Check if the device queue is big
-			 * enough for every fragment. If not, drop the
-			 * whole packet.
-			 */
-			for (i = 0; i < packet->txb->nr_frags; i++) {
-				skb = packet->txb->fragments[i];
-				if (unlikely(skb->len > queue->tx_devq_size)) {
-					dprintkl(KERN_ERR PFX "PIO TX device queue too small. "
-							      "Dropping packet.\n");
-					free_txpacket(packet, 1);
-					goto next_packet;
-				}
-			}
-		}
-		/* Try to transmit the packet.
-		 * This may not completely succeed.
+		/* Try to transmit the packet. This can fail, if
+		 * the device queue is full. In case of failure, the
+		 * packet is left in the txqueue.
+		 * If transmission succeed, the packet is moved to txrunning.
+		 * If it is impossible to transmit the packet, it
+		 * is dropped.
 		 */
 		err = pio_tx_packet(packet);
 		if (err)
 			break;
-	next_packet:
-		continue;
 	}
 out_unlock:
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
+	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 }
 
 static void setup_txqueues(struct bcm43xx_pioqueue *queue)
@@ -320,7 +315,7 @@ static void setup_txqueues(struct bcm43x
 }
 
 static
-struct bcm43xx_pioqueue * bcm43xx_setup_pioqueue(struct bcm43xx_private *bcm,
+struct bcm43xx_pioqueue *bcm43xx_setup_pioqueue(struct bcm43xx_wldev *dev,
 						 u16 pio_mmio_base)
 {
 	struct bcm43xx_pioqueue *queue;
@@ -331,9 +326,9 @@ struct bcm43xx_pioqueue * bcm43xx_setup_
 	if (!queue)
 		goto out;
 
-	queue->bcm = bcm;
+	queue->dev = dev;
 	queue->mmio_base = pio_mmio_base;
-	queue->need_workarounds = (bcm->current_core->rev < 3);
+	queue->need_workarounds = (dev->dev->id.revision < 3);
 
 	INIT_LIST_HEAD(&queue->txfree);
 	INIT_LIST_HEAD(&queue->txqueue);
@@ -341,19 +336,19 @@ struct bcm43xx_pioqueue * bcm43xx_setup_
 	tasklet_init(&queue->txtask, tx_tasklet,
 		     (unsigned long)queue);
 
-	value = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
+	value = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD);
 	value &= ~BCM43xx_SBF_XFER_REG_BYTESWAP;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD, value);
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD, value);
 
-	qsize = bcm43xx_read16(bcm, queue->mmio_base + BCM43xx_PIO_TXQBUFSIZE);
+	qsize = bcm43xx_read16(dev, queue->mmio_base + BCM43xx_PIO_TXQBUFSIZE);
 	if (qsize == 0) {
-		printk(KERN_ERR PFX "ERROR: This card does not support PIO "
-				    "operation mode. Please use DMA mode "
-				    "(module parameter pio=0).\n");
+		bcmerr(dev->wl, "This card does not support PIO "
+		       "operation mode. Please use DMA mode "
+		       "(module parameter pio=0).\n");
 		goto err_freequeue;
 	}
 	if (qsize <= BCM43xx_PIO_TXQADJUST) {
-		printk(KERN_ERR PFX "PIO tx device-queue too small (%u)\n",
+		bcmerr(dev->wl, "PIO tx device-queue too small (%u)\n",
 		       qsize);
 		goto err_freequeue;
 	}
@@ -375,7 +370,6 @@ static void cancel_transfers(struct bcm4
 {
 	struct bcm43xx_pio_txpacket *packet, *tmp_packet;
 
-	netif_tx_disable(queue->bcm->net_dev);
 	tasklet_disable(&queue->txtask);
 
 	list_for_each_entry_safe(packet, tmp_packet, &queue->txrunning, list)
@@ -393,13 +387,13 @@ static void bcm43xx_destroy_pioqueue(str
 	kfree(queue);
 }
 
-void bcm43xx_pio_free(struct bcm43xx_private *bcm)
+void bcm43xx_pio_free(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_pio *pio;
 
-	if (!bcm43xx_using_pio(bcm))
+	if (!bcm43xx_using_pio(dev))
 		return;
-	pio = bcm43xx_current_pio(bcm);
+	pio = &dev->pio;
 
 	bcm43xx_destroy_pioqueue(pio->queue3);
 	pio->queue3 = NULL;
@@ -411,36 +405,36 @@ void bcm43xx_pio_free(struct bcm43xx_pri
 	pio->queue0 = NULL;
 }
 
-int bcm43xx_pio_init(struct bcm43xx_private *bcm)
+int bcm43xx_pio_init(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_pio *pio = bcm43xx_current_pio(bcm);
+	struct bcm43xx_pio *pio = &dev->pio;
 	struct bcm43xx_pioqueue *queue;
 	int err = -ENOMEM;
 
-	queue = bcm43xx_setup_pioqueue(bcm, BCM43xx_MMIO_PIO1_BASE);
+	queue = bcm43xx_setup_pioqueue(dev, BCM43xx_MMIO_PIO1_BASE);
 	if (!queue)
 		goto out;
 	pio->queue0 = queue;
 
-	queue = bcm43xx_setup_pioqueue(bcm, BCM43xx_MMIO_PIO2_BASE);
+	queue = bcm43xx_setup_pioqueue(dev, BCM43xx_MMIO_PIO2_BASE);
 	if (!queue)
 		goto err_destroy0;
 	pio->queue1 = queue;
 
-	queue = bcm43xx_setup_pioqueue(bcm, BCM43xx_MMIO_PIO3_BASE);
+	queue = bcm43xx_setup_pioqueue(dev, BCM43xx_MMIO_PIO3_BASE);
 	if (!queue)
 		goto err_destroy1;
 	pio->queue2 = queue;
 
-	queue = bcm43xx_setup_pioqueue(bcm, BCM43xx_MMIO_PIO4_BASE);
+	queue = bcm43xx_setup_pioqueue(dev, BCM43xx_MMIO_PIO4_BASE);
 	if (!queue)
 		goto err_destroy2;
 	pio->queue3 = queue;
 
-	if (bcm->current_core->rev < 3)
-		bcm->irq_savedstate |= BCM43xx_IRQ_PIO_WORKAROUND;
+	if (dev->dev->id.revision < 3)
+		dev->irq_savedstate |= BCM43xx_IRQ_PIO_WORKAROUND;
 
-	dprintk(KERN_INFO PFX "PIO initialized\n");
+	bcmdbg(dev->wl, "PIO initialized\n");
 	err = 0;
 out:
 	return err;
@@ -457,48 +451,53 @@ err_destroy0:
 	goto out;
 }
 
-int bcm43xx_pio_tx(struct bcm43xx_private *bcm,
-		   struct ieee80211_txb *txb)
+int bcm43xx_pio_tx(struct bcm43xx_wldev *dev,
+		   struct sk_buff *skb,
+		   struct ieee80211_tx_control *ctl)
 {
-	struct bcm43xx_pioqueue *queue = bcm43xx_current_pio(bcm)->queue1;
+	struct bcm43xx_pioqueue *queue = dev->pio.queue1;
 	struct bcm43xx_pio_txpacket *packet;
 
-	assert(!queue->tx_suspended);
-	assert(!list_empty(&queue->txfree));
+	BCM43xx_WARN_ON(queue->tx_suspended);
+	BCM43xx_WARN_ON(list_empty(&queue->txfree));
 
 	packet = list_entry(queue->txfree.next, struct bcm43xx_pio_txpacket, list);
-	packet->txb = txb;
-	packet->xmitted_frags = 0;
-	packet->xmitted_octets = 0;
+	packet->skb = skb;
+
+	memset(&packet->txstat, 0, sizeof(packet->txstat));
+	memcpy(&packet->txstat.control, ctl, sizeof(*ctl));
+
 	list_move_tail(&packet->list, &queue->txqueue);
 	queue->nr_txfree--;
-	assert(queue->nr_txfree < BCM43xx_PIO_MAXTXPACKETS);
-
-	/* Suspend TX, if we are out of packets in the "free" queue. */
-	if (list_empty(&queue->txfree)) {
-		netif_stop_queue(queue->bcm->net_dev);
-		queue->tx_suspended = 1;
-	}
+	queue->nr_tx_packets++;
+	BCM43xx_WARN_ON(queue->nr_txfree >= BCM43xx_PIO_MAXTXPACKETS);
 
 	tasklet_schedule(&queue->txtask);
 
 	return 0;
 }
 
-void bcm43xx_pio_handle_xmitstatus(struct bcm43xx_private *bcm,
-				   struct bcm43xx_xmitstatus *status)
+void bcm43xx_pio_handle_txstatus(struct bcm43xx_wldev *dev,
+				 const struct bcm43xx_txstatus *status)
 {
 	struct bcm43xx_pioqueue *queue;
 	struct bcm43xx_pio_txpacket *packet;
 
-	queue = parse_cookie(bcm, status->cookie, &packet);
-	assert(queue);
+	queue = parse_cookie(dev, status->cookie, &packet);
+	BCM43xx_WARN_ON(!queue);
+
+	queue->tx_devq_packets--;
+	queue->tx_devq_used -= (packet->skb->len +
+				sizeof(struct bcm43xx_txhdr_fw3));
+
+	if (status->acked)
+		packet->txstat.flags |= IEEE80211_TX_STATUS_ACK;
+	packet->txstat.retry_count = status->frame_count - 1;
+	ieee80211_tx_status_irqsafe(dev->wl->hw, packet->skb,
+				    &(packet->txstat));
+	packet->skb = NULL;
 
 	free_txpacket(packet, 1);
-	if (queue->tx_suspended) {
-		queue->tx_suspended = 0;
-		netif_wake_queue(queue->bcm->net_dev);
-	}
 	/* If there are packets on the txqueue, poke the tasklet
 	 * to transmit them.
 	 */
@@ -506,17 +505,31 @@ void bcm43xx_pio_handle_xmitstatus(struc
 		tasklet_schedule(&queue->txtask);
 }
 
+void bcm43xx_pio_get_tx_stats(struct bcm43xx_wldev *dev,
+			      struct ieee80211_tx_queue_stats *stats)
+{
+	struct bcm43xx_pio *pio = &dev->pio;
+	struct bcm43xx_pioqueue *queue;
+	struct ieee80211_tx_queue_stats_data *data;
+
+	queue = pio->queue1;
+	data = &(stats->data[0]);
+	data->len = BCM43xx_PIO_MAXTXPACKETS - queue->nr_txfree;
+	data->limit = BCM43xx_PIO_MAXTXPACKETS;
+	data->count = queue->nr_tx_packets;
+}
+
 static void pio_rx_error(struct bcm43xx_pioqueue *queue,
 			 int clear_buffers,
 			 const char *error)
 {
 	int i;
 
-	printkl("PIO RX error: %s\n", error);
+	bcmerr(queue->dev->wl, "PIO RX error: %s\n", error);
 	bcm43xx_pio_write(queue, BCM43xx_PIO_RXCTL,
 			  BCM43xx_PIO_RXCTL_READY);
 	if (clear_buffers) {
-		assert(queue->mmio_base == BCM43xx_MMIO_PIO1_BASE);
+		BCM43xx_WARN_ON(queue->mmio_base != BCM43xx_MMIO_PIO1_BASE);
 		for (i = 0; i < 15; i++) {
 			/* Dummy read. */
 			bcm43xx_pio_read(queue, BCM43xx_PIO_RXDATA);
@@ -527,9 +540,12 @@ static void pio_rx_error(struct bcm43xx_
 void bcm43xx_pio_rx(struct bcm43xx_pioqueue *queue)
 {
 	u16 preamble[21] = { 0 };
-	struct bcm43xx_rxhdr *rxhdr;
-	u16 tmp, len, rxflags2;
-	int i, preamble_readwords;
+	struct bcm43xx_rxhdr_fw3 *rxhdr;
+	u16 tmp;
+	u16 len;
+	u16 macstat;
+	int i;
+	int preamble_readwords;
 	struct sk_buff *skb;
 
 	tmp = bcm43xx_pio_read(queue, BCM43xx_PIO_RXCTL);
@@ -544,7 +560,7 @@ void bcm43xx_pio_rx(struct bcm43xx_pioqu
 			goto data_ready;
 		udelay(10);
 	}
-	dprintkl(KERN_ERR PFX "PIO RX timed out\n");
+	bcmdbg(queue->dev->wl, "PIO RX timed out\n");
 	return;
 data_ready:
 
@@ -566,29 +582,20 @@ data_ready:
 		tmp = bcm43xx_pio_read(queue, BCM43xx_PIO_RXDATA);
 		preamble[i + 1] = cpu_to_le16(tmp);
 	}
-	rxhdr = (struct bcm43xx_rxhdr *)preamble;
-	rxflags2 = le16_to_cpu(rxhdr->flags2);
-	if (unlikely(rxflags2 & BCM43xx_RXHDR_FLAGS2_INVALIDFRAME)) {
+	rxhdr = (struct bcm43xx_rxhdr_fw3 *)preamble;
+	macstat = le16_to_cpu(rxhdr->mac_status);
+	if (macstat & BCM43xx_RX_MAC_FCSERR) {
 		pio_rx_error(queue,
 			     (queue->mmio_base == BCM43xx_MMIO_PIO1_BASE),
-			     "invalid frame");
+			     "Frame FCS error");
 		return;
 	}
 	if (queue->mmio_base == BCM43xx_MMIO_PIO4_BASE) {
 		/* We received an xmit status. */
-		struct bcm43xx_hwxmitstatus *hw;
-		struct bcm43xx_xmitstatus stat;
-
-		hw = (struct bcm43xx_hwxmitstatus *)(preamble + 1);
-		stat.cookie = le16_to_cpu(hw->cookie);
-		stat.flags = hw->flags;
-		stat.cnt1 = hw->cnt1;
-		stat.cnt2 = hw->cnt2;
-		stat.seq = le16_to_cpu(hw->seq);
-		stat.unknown = le16_to_cpu(hw->unknown);
+		struct bcm43xx_hwtxstatus *hw;
 
-		bcm43xx_debugfs_log_txstat(queue->bcm, &stat);
-		bcm43xx_pio_handle_xmitstatus(queue->bcm, &stat);
+		hw = (struct bcm43xx_hwtxstatus *)(preamble + 1);
+		bcm43xx_handle_hwtxstatus(queue->dev, hw);
 
 		return;
 	}
@@ -606,24 +613,13 @@ data_ready:
 	if (len % 2) {
 		tmp = bcm43xx_pio_read(queue, BCM43xx_PIO_RXDATA);
 		skb->data[len - 1] = (tmp & 0x00FF);
-/* The specs say the following is required, but
- * it is wrong and corrupts the PLCP. If we don't do
- * this, the PLCP seems to be correct. So ifdef it out for now.
- */
-#if 0
-		if (rxflags2 & BCM43xx_RXHDR_FLAGS2_TYPE2FRAME)
-			skb->data[2] = (tmp & 0xFF00) >> 8;
-		else
-			skb->data[0] = (tmp & 0xFF00) >> 8;
-#endif
 	}
-	skb_trim(skb, len - IEEE80211_FCS_LEN);
-	bcm43xx_rx(queue->bcm, skb, rxhdr);
+	bcm43xx_rx(queue->dev, skb, rxhdr);
 }
 
 void bcm43xx_pio_tx_suspend(struct bcm43xx_pioqueue *queue)
 {
-	bcm43xx_power_saving_ctl_bits(queue->bcm, -1, 1);
+	bcm43xx_power_saving_ctl_bits(queue->dev, -1, 1);
 	bcm43xx_pio_write(queue, BCM43xx_PIO_TXCTL,
 			  bcm43xx_pio_read(queue, BCM43xx_PIO_TXCTL)
 			  | BCM43xx_PIO_TXCTL_SUSPEND);
@@ -634,29 +630,28 @@ void bcm43xx_pio_tx_resume(struct bcm43x
 	bcm43xx_pio_write(queue, BCM43xx_PIO_TXCTL,
 			  bcm43xx_pio_read(queue, BCM43xx_PIO_TXCTL)
 			  & ~BCM43xx_PIO_TXCTL_SUSPEND);
-	bcm43xx_power_saving_ctl_bits(queue->bcm, -1, -1);
-	if (!list_empty(&queue->txqueue))
-		tasklet_schedule(&queue->txtask);
+	bcm43xx_power_saving_ctl_bits(queue->dev, -1, -1);
+	tasklet_schedule(&queue->txtask);
 }
 
-void bcm43xx_pio_freeze_txqueues(struct bcm43xx_private *bcm)
+void bcm43xx_pio_freeze_txqueues(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_pio *pio;
 
-	assert(bcm43xx_using_pio(bcm));
-	pio = bcm43xx_current_pio(bcm);
+	BCM43xx_WARN_ON(!bcm43xx_using_pio(dev));
+	pio = &dev->pio;
 	pio->queue0->tx_frozen = 1;
 	pio->queue1->tx_frozen = 1;
 	pio->queue2->tx_frozen = 1;
 	pio->queue3->tx_frozen = 1;
 }
 
-void bcm43xx_pio_thaw_txqueues(struct bcm43xx_private *bcm)
+void bcm43xx_pio_thaw_txqueues(struct bcm43xx_wldev *dev)
 {
 	struct bcm43xx_pio *pio;
 
-	assert(bcm43xx_using_pio(bcm));
-	pio = bcm43xx_current_pio(bcm);
+	BCM43xx_WARN_ON(!bcm43xx_using_pio(dev));
+	pio = &dev->pio;
 	pio->queue0->tx_frozen = 0;
 	pio->queue1->tx_frozen = 0;
 	pio->queue2->tx_frozen = 0;
@@ -670,5 +665,3 @@ void bcm43xx_pio_thaw_txqueues(struct bc
 	if (!list_empty(&pio->queue3->txqueue))
 		tasklet_schedule(&pio->queue3->txtask);
 }
-
-
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_pio.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_pio.h
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_pio.h
@@ -40,22 +40,21 @@ struct bcm43xx_xmitstatus;
 
 struct bcm43xx_pio_txpacket {
 	struct bcm43xx_pioqueue *queue;
-	struct ieee80211_txb *txb;
+	struct sk_buff *skb;
+	struct ieee80211_tx_status txstat;
 	struct list_head list;
-
-	u8 xmitted_frags;
-	u16 xmitted_octets;
 };
 
-#define pio_txpacket_getindex(packet) ((int)((packet) - (packet)->queue->tx_packets_cache)) 
+#define pio_txpacket_getindex(packet) ((int)((packet) - \
+			              (packet)->queue->tx_packets_cache))
 
 struct bcm43xx_pioqueue {
-	struct bcm43xx_private *bcm;
+	struct bcm43xx_wldev *dev;
 	u16 mmio_base;
 
-	u8 tx_suspended:1,
-	   tx_frozen:1,
-	   need_workarounds:1; /* Workarounds needed for core.rev < 3 */
+	bool tx_suspended;
+	bool tx_frozen;
+	bool need_workarounds; /* Workarounds needed for core.rev < 3 */
 
 	/* Adjusted size of the device internal TX buffer. */
 	u16 tx_devq_size;
@@ -88,54 +87,63 @@ static inline
 u16 bcm43xx_pio_read(struct bcm43xx_pioqueue *queue,
 		     u16 offset)
 {
-	return bcm43xx_read16(queue->bcm, queue->mmio_base + offset);
+	return bcm43xx_read16(queue->dev, queue->mmio_base + offset);
 }
 
 static inline
 void bcm43xx_pio_write(struct bcm43xx_pioqueue *queue,
 		       u16 offset, u16 value)
 {
-	bcm43xx_write16(queue->bcm, queue->mmio_base + offset, value);
+	bcm43xx_write16(queue->dev, queue->mmio_base + offset, value);
 	mmiowb();
 }
 
 
-int bcm43xx_pio_init(struct bcm43xx_private *bcm);
-void bcm43xx_pio_free(struct bcm43xx_private *bcm);
+int bcm43xx_pio_init(struct bcm43xx_wldev *dev);
+void bcm43xx_pio_free(struct bcm43xx_wldev *dev);
 
-int bcm43xx_pio_tx(struct bcm43xx_private *bcm,
-		   struct ieee80211_txb *txb);
-void bcm43xx_pio_handle_xmitstatus(struct bcm43xx_private *bcm,
-				   struct bcm43xx_xmitstatus *status);
+int bcm43xx_pio_tx(struct bcm43xx_wldev *dev,
+		   struct sk_buff *skb,
+		   struct ieee80211_tx_control *ctl);
+void bcm43xx_pio_handle_txstatus(struct bcm43xx_wldev *dev,
+				 const struct bcm43xx_txstatus *status);
+void bcm43xx_pio_get_tx_stats(struct bcm43xx_wldev *dev,
+			      struct ieee80211_tx_queue_stats *stats);
 void bcm43xx_pio_rx(struct bcm43xx_pioqueue *queue);
 
-/* Suspend a TX queue on hardware level. */
+/* Suspend TX queue in hardware. */
 void bcm43xx_pio_tx_suspend(struct bcm43xx_pioqueue *queue);
 void bcm43xx_pio_tx_resume(struct bcm43xx_pioqueue *queue);
 /* Suspend (freeze) the TX tasklet (software level). */
-void bcm43xx_pio_freeze_txqueues(struct bcm43xx_private *bcm);
-void bcm43xx_pio_thaw_txqueues(struct bcm43xx_private *bcm);
+void bcm43xx_pio_freeze_txqueues(struct bcm43xx_wldev *dev);
+void bcm43xx_pio_thaw_txqueues(struct bcm43xx_wldev *dev);
 
 #else /* CONFIG_BCM43XX_PIO */
 
 static inline
-int bcm43xx_pio_init(struct bcm43xx_private *bcm)
+int bcm43xx_pio_init(struct bcm43xx_wldev *dev)
 {
 	return 0;
 }
 static inline
-void bcm43xx_pio_free(struct bcm43xx_private *bcm)
+void bcm43xx_pio_free(struct bcm43xx_wldev *dev)
 {
 }
 static inline
-int bcm43xx_pio_tx(struct bcm43xx_private *bcm,
-		   struct ieee80211_txb *txb)
+int bcm43xx_pio_tx(struct bcm43xx_wldev *dev,
+		   struct sk_buff *skb,
+		   struct ieee80211_tx_control *ctl)
 {
 	return 0;
 }
 static inline
-void bcm43xx_pio_handle_xmitstatus(struct bcm43xx_private *bcm,
-				   struct bcm43xx_xmitstatus *status)
+void bcm43xx_pio_handle_txstatus(struct bcm43xx_wldev *dev,
+				 const struct bcm43xx_txstatus *status)
+{
+}
+static inline
+void bcm43xx_pio_get_tx_stats(struct bcm43xx_wldev *dev,
+			      struct ieee80211_tx_queue_stats *stats)
 {
 }
 static inline
@@ -151,11 +159,11 @@ void bcm43xx_pio_tx_resume(struct bcm43x
 {
 }
 static inline
-void bcm43xx_pio_freeze_txqueues(struct bcm43xx_private *bcm)
+void bcm43xx_pio_freeze_txqueues(struct bcm43xx_wldev *dev)
 {
 }
 static inline
-void bcm43xx_pio_thaw_txqueues(struct bcm43xx_private *bcm)
+void bcm43xx_pio_thaw_txqueues(struct bcm43xx_wldev *dev)
 {
 }
 

