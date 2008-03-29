Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57378 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbYC2UCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 16:02:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add PIO support for PCMCIA devices
Date: Sat, 29 Mar 2008 21:01:16 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200803292101.16696.mb@bu3sch.de> (sfid-20080329_200236_826304_8681CDF1)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds PIO support back (D'oh!) for PCMCIA devices.
This is a complete rewrite of the old PIO code. It does actually work
and we get reasonable performance out of it on a modern machine.
On a PowerBook G4 I get a few MBit for TX and a few more for RX.
So it doesn't work as well as DMA (of course), but it's a _lot_ faster
than the old PIO code (only got a few kBit with that).

The limiting factor is the host CPU speed. So it will generate 100%
CPU usage when the network interface is heavily loaded. A voluntary preemption
point in the RX path makes sure Desktop Latency isn't hurt.

PIO is needed for 16bit PCMCIA devices, as we really don't want to poke with
the braindead DMA mechanisms on PCMCIA sockets. Additionally, not all
PCMCIA sockets do actually support DMA in 16bit mode (mine doesn't).

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for 2.6.26
With this patch (and the others I sent earlier) we can finally get
16bit PCMCIA and Compact Flash cards working.

Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2008-03-29 19:52:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/Kconfig	2008-03-29 19:52:35.000000000 +0100
@@ -59,12 +59,19 @@ config B43_PCMCIA
 	  CF b43 cards can sometimes be found in handheld PCs.
 
 	  It's safe to select Y here, even if you don't have a B43 PCMCIA device.
 
 	  If unsure, say N.
 
+# Data transfers to the device via PIO
+# This is only needed on PCMCIA devices. All others can do DMA properly.
+config B43_PIO
+	bool
+	depends on B43 && (B43_PCMCIA || B43_FORCE_PIO)
+	default y
+
 config B43_NPHY
 	bool "Pre IEEE 802.11n support (BROKEN)"
 	depends on B43 && EXPERIMENTAL
 	---help---
 	  Support for the IEEE 802.11n draft.
 
@@ -91,6 +98,16 @@ config B43_DEBUG
 	depends on B43
 	---help---
 	  Broadcom 43xx debugging messages.
 
 	  Say Y, if you want to find out why the driver does not
 	  work for you.
+
+config B43_FORCE_PIO
+	bool "Force usage of PIO instead of DMA"
+	depends on B43 && B43_DEBUG
+	---help---
+	  This will disable DMA and always enable PIO instead.
+
+	  Say N!
+	  This is only for debugging the PIO engine code. You do
+	  _NOT_ want to enable this.
Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2008-03-29 19:53:10.000000000 +0100
@@ -0,0 +1,835 @@
+/*
+
+  Broadcom B43 wireless driver
+
+  PIO data transfer
+
+  Copyright (c) 2005-2008 Michael Buesch <mb@bu3sch.de>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; see the file COPYING.  If not, write to
+  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
+  Boston, MA 02110-1301, USA.
+
+*/
+
+#include "b43.h"
+#include "pio.h"
+#include "dma.h"
+#include "main.h"
+#include "xmit.h"
+
+#include <linux/delay.h>
+
+
+static void b43_pio_rx_work(struct work_struct *work);
+
+
+static u16 generate_cookie(struct b43_pio_txqueue *q,
+			   struct b43_pio_txpacket *pack)
+{
+	u16 cookie;
+
+	/* Use the upper 4 bits of the cookie as
+	 * PIO controller ID and store the packet index number
+	 * in the lower 12 bits.
+	 * Note that the cookie must never be 0, as this
+	 * is a special value used in RX path.
+	 * It can also not be 0xFFFF because that is special
+	 * for multicast frames.
+	 */
+	cookie = (((u16)q->index + 1) << 12);
+	cookie |= pack->index;
+
+	return cookie;
+}
+
+static
+struct b43_pio_txqueue * parse_cookie(struct b43_wldev *dev,
+				      u16 cookie,
+				      struct b43_pio_txpacket **pack)
+{
+	struct b43_pio *pio = &dev->pio;
+	struct b43_pio_txqueue *q = NULL;
+	unsigned int pack_index;
+
+	switch (cookie & 0xF000) {
+	case 0x1000:
+		q = pio->tx_queue_AC_BK;
+		break;
+	case 0x2000:
+		q = pio->tx_queue_AC_BE;
+		break;
+	case 0x3000:
+		q = pio->tx_queue_AC_VI;
+		break;
+	case 0x4000:
+		q = pio->tx_queue_AC_VO;
+		break;
+	case 0x5000:
+		q = pio->tx_queue_mcast;
+		break;
+	}
+	if (B43_WARN_ON(!q))
+		return NULL;
+	pack_index = (cookie & 0x0FFF);
+	if (B43_WARN_ON(pack_index >= ARRAY_SIZE(q->packets)))
+		return NULL;
+	*pack = &q->packets[pack_index];
+
+	return q;
+}
+
+static u16 index_to_pioqueue_base(struct b43_wldev *dev,
+				  unsigned int index)
+{
+	static const u16 bases[] = {
+		B43_MMIO_PIO_BASE0,
+		B43_MMIO_PIO_BASE1,
+		B43_MMIO_PIO_BASE2,
+		B43_MMIO_PIO_BASE3,
+		B43_MMIO_PIO_BASE4,
+		B43_MMIO_PIO_BASE5,
+		B43_MMIO_PIO_BASE6,
+		B43_MMIO_PIO_BASE7,
+	};
+	static const u16 bases_rev11[] = {
+		B43_MMIO_PIO11_BASE0,
+		B43_MMIO_PIO11_BASE1,
+		B43_MMIO_PIO11_BASE2,
+		B43_MMIO_PIO11_BASE3,
+		B43_MMIO_PIO11_BASE4,
+		B43_MMIO_PIO11_BASE5,
+	};
+
+	if (dev->dev->id.revision >= 11) {
+		B43_WARN_ON(index >= ARRAY_SIZE(bases_rev11));
+		return bases_rev11[index];
+	}
+	B43_WARN_ON(index >= ARRAY_SIZE(bases));
+	return bases[index];
+}
+
+static u16 pio_txqueue_offset(struct b43_wldev *dev)
+{
+	if (dev->dev->id.revision >= 11)
+		return 0x18;
+	return 0;
+}
+
+static u16 pio_rxqueue_offset(struct b43_wldev *dev)
+{
+	if (dev->dev->id.revision >= 11)
+		return 0x38;
+	return 8;
+}
+
+static struct b43_pio_txqueue * b43_setup_pioqueue_tx(struct b43_wldev *dev,
+						      unsigned int index)
+{
+	struct b43_pio_txqueue *q;
+	struct b43_pio_txpacket *p;
+	unsigned int i;
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return NULL;
+	spin_lock_init(&q->lock);
+	q->dev = dev;
+	q->rev = dev->dev->id.revision;
+	q->mmio_base = index_to_pioqueue_base(dev, index) +
+		       pio_txqueue_offset(dev);
+	q->index = index;
+
+	q->free_packet_slots = B43_PIO_MAX_NR_TXPACKETS;
+	if (q->rev >= 8) {
+		q->buffer_size = 1920; //FIXME this constant is wrong.
+	} else {
+		q->buffer_size = b43_piotx_read16(q, B43_PIO_TXQBUFSIZE);
+		q->buffer_size -= 80;
+	}
+
+	INIT_LIST_HEAD(&q->packets_list);
+	for (i = 0; i < ARRAY_SIZE(q->packets); i++) {
+		p = &(q->packets[i]);
+		INIT_LIST_HEAD(&p->list);
+		p->index = i;
+		p->queue = q;
+		list_add(&p->list, &q->packets_list);
+	}
+
+	return q;
+}
+
+static struct b43_pio_rxqueue * b43_setup_pioqueue_rx(struct b43_wldev *dev,
+						      unsigned int index)
+{
+	struct b43_pio_rxqueue *q;
+
+	q = kzalloc(sizeof(*q), GFP_KERNEL);
+	if (!q)
+		return NULL;
+	spin_lock_init(&q->lock);
+	q->dev = dev;
+	q->rev = dev->dev->id.revision;
+	q->mmio_base = index_to_pioqueue_base(dev, index) +
+		       pio_rxqueue_offset(dev);
+	INIT_WORK(&q->rx_work, b43_pio_rx_work);
+
+	/* Enable Direct FIFO RX (PIO) on the engine. */
+	b43_dma_direct_fifo_rx(dev, index, 1);
+
+	return q;
+}
+
+static void b43_pio_cancel_tx_packets(struct b43_pio_txqueue *q)
+{
+	struct b43_pio_txpacket *pack;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(q->packets); i++) {
+		pack = &(q->packets[i]);
+		if (pack->skb) {
+			dev_kfree_skb_any(pack->skb);
+			pack->skb = NULL;
+		}
+	}
+}
+
+static void b43_destroy_pioqueue_tx(struct b43_pio_txqueue *q,
+				    const char *name)
+{
+	if (!q)
+		return;
+	b43_pio_cancel_tx_packets(q);
+	kfree(q);
+}
+
+static void b43_destroy_pioqueue_rx(struct b43_pio_rxqueue *q,
+				    const char *name)
+{
+	if (!q)
+		return;
+	kfree(q);
+}
+
+#define destroy_queue_tx(pio, queue) do {				\
+	b43_destroy_pioqueue_tx((pio)->queue, __stringify(queue));	\
+	(pio)->queue = NULL;						\
+  } while (0)
+
+#define destroy_queue_rx(pio, queue) do {				\
+	b43_destroy_pioqueue_rx((pio)->queue, __stringify(queue));	\
+	(pio)->queue = NULL;						\
+  } while (0)
+
+void b43_pio_free(struct b43_wldev *dev)
+{
+	struct b43_pio *pio;
+
+	if (!b43_using_pio_transfers(dev))
+		return;
+	pio = &dev->pio;
+
+	destroy_queue_rx(pio, rx_queue);
+	destroy_queue_tx(pio, tx_queue_mcast);
+	destroy_queue_tx(pio, tx_queue_AC_VO);
+	destroy_queue_tx(pio, tx_queue_AC_VI);
+	destroy_queue_tx(pio, tx_queue_AC_BE);
+	destroy_queue_tx(pio, tx_queue_AC_BK);
+}
+
+void b43_pio_stop(struct b43_wldev *dev)
+{
+	if (!b43_using_pio_transfers(dev))
+		return;
+	cancel_work_sync(&dev->pio.rx_queue->rx_work);
+}
+
+int b43_pio_init(struct b43_wldev *dev)
+{
+	struct b43_pio *pio = &dev->pio;
+	int err = -ENOMEM;
+
+	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
+		    & ~B43_MACCTL_BE);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_RXPADOFF, 0);
+
+	pio->tx_queue_AC_BK = b43_setup_pioqueue_tx(dev, 0);
+	if (!pio->tx_queue_AC_BK)
+		goto out;
+
+	pio->tx_queue_AC_BE = b43_setup_pioqueue_tx(dev, 1);
+	if (!pio->tx_queue_AC_BE)
+		goto err_destroy_bk;
+
+	pio->tx_queue_AC_VI = b43_setup_pioqueue_tx(dev, 2);
+	if (!pio->tx_queue_AC_VI)
+		goto err_destroy_be;
+
+	pio->tx_queue_AC_VO = b43_setup_pioqueue_tx(dev, 3);
+	if (!pio->tx_queue_AC_VO)
+		goto err_destroy_vi;
+
+	pio->tx_queue_mcast = b43_setup_pioqueue_tx(dev, 4);
+	if (!pio->tx_queue_mcast)
+		goto err_destroy_vo;
+
+	pio->rx_queue = b43_setup_pioqueue_rx(dev, 0);
+	if (!pio->rx_queue)
+		goto err_destroy_mcast;
+
+	b43dbg(dev->wl, "PIO initialized\n");
+	err = 0;
+out:
+	return err;
+
+err_destroy_mcast:
+	destroy_queue_tx(pio, tx_queue_mcast);
+err_destroy_vo:
+	destroy_queue_tx(pio, tx_queue_AC_VO);
+err_destroy_vi:
+	destroy_queue_tx(pio, tx_queue_AC_VI);
+err_destroy_be:
+	destroy_queue_tx(pio, tx_queue_AC_BE);
+err_destroy_bk:
+	destroy_queue_tx(pio, tx_queue_AC_BK);
+	return err;
+}
+
+/* Static mapping of mac80211's queues (priorities) to b43 PIO queues. */
+static struct b43_pio_txqueue * select_queue_by_priority(struct b43_wldev *dev,
+							 u8 queue_prio)
+{
+	struct b43_pio_txqueue *q;
+
+	if (b43_modparam_qos) {
+		/* 0 = highest priority */
+		switch (queue_prio) {
+		default:
+			B43_WARN_ON(1);
+			/* fallthrough */
+		case 0:
+			q = dev->pio.tx_queue_AC_VO;
+			break;
+		case 1:
+			q = dev->pio.tx_queue_AC_VI;
+			break;
+		case 2:
+			q = dev->pio.tx_queue_AC_BE;
+			break;
+		case 3:
+			q = dev->pio.tx_queue_AC_BK;
+			break;
+		}
+	} else
+		q = dev->pio.tx_queue_AC_BE;
+
+	return q;
+}
+
+static inline void tx_write_2byte_queue(struct b43_pio_txqueue *q,
+					u16 *ctl,
+					const void *_data,
+					unsigned int data_len)
+{
+	const u8 *data = _data;
+	unsigned int i;
+	u16 value;
+
+	*ctl |= B43_PIO_TXCTL_WRITELO | B43_PIO_TXCTL_WRITEHI;
+	b43_piotx_write16(q, B43_PIO_TXCTL, *ctl);
+	for (i = 0; i < data_len; i += 2) {
+		value = data[i];
+		if (i + 1 < data_len) {
+			value |= (u16)(data[i + 1]) << 8;
+		} else {
+			*ctl &= ~B43_PIO_TXCTL_WRITEHI;
+			b43_piotx_write16(q, B43_PIO_TXCTL, *ctl);
+		}
+		b43_piotx_write16(q, B43_PIO_TXDATA, value);
+	}
+}
+
+static void pio_tx_frame_2byte_queue(struct b43_pio_txpacket *pack,
+				     const u8 *hdr, unsigned int hdrlen)
+{
+	struct b43_pio_txqueue *q = pack->queue;
+	const char *frame = pack->skb->data;
+	unsigned int frame_len = pack->skb->len;
+	u16 ctl;
+
+	ctl = b43_piotx_read16(q, B43_PIO_TXCTL);
+	ctl |= B43_PIO_TXCTL_FREADY;
+	ctl &= ~B43_PIO_TXCTL_EOF;
+
+	/* Transfer the header data. */
+	tx_write_2byte_queue(q, &ctl, hdr, hdrlen);
+	/* Transfer the frame data. */
+	tx_write_2byte_queue(q, &ctl, frame, frame_len);
+
+	ctl |= B43_PIO_TXCTL_EOF;
+	b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
+}
+
+static inline void tx_write_4byte_queue(struct b43_pio_txqueue *q,
+					u32 *ctl,
+					const void *_data,
+					unsigned int data_len)
+{
+	const u8 *data = _data;
+	unsigned int i;
+	u32 value;
+	bool ctl_changed = 0;
+
+	*ctl |= B43_PIO8_TXCTL_0_7 | B43_PIO8_TXCTL_8_15 |
+		B43_PIO8_TXCTL_16_23 | B43_PIO8_TXCTL_24_31;
+	b43_piotx_write32(q, B43_PIO8_TXCTL, *ctl);
+	for (i = 0; i < data_len; i += 4) {
+		value = data[i];
+		if (i + 1 < data_len) {
+			value |= (u32)(data[i + 1]) << 8;
+		} else {
+			*ctl &= ~B43_PIO8_TXCTL_8_15;
+			ctl_changed = 1;
+		}
+		if (i + 2 < data_len) {
+			value |= (u32)(data[i + 2]) << 16;
+		} else {
+			*ctl &= ~B43_PIO8_TXCTL_16_23;
+			ctl_changed = 1;
+		}
+		if (i + 3 < data_len) {
+			value |= (u32)(data[i + 3]) << 24;
+		} else {
+			*ctl &= ~B43_PIO8_TXCTL_24_31;
+			ctl_changed = 1;
+		}
+		if (ctl_changed)
+			b43_piotx_write32(q, B43_PIO8_TXCTL, *ctl);
+		b43_piotx_write32(q, B43_PIO8_TXDATA, value);
+	}
+}
+
+static void pio_tx_frame_4byte_queue(struct b43_pio_txpacket *pack,
+				     const u8 *hdr, unsigned int hdrlen)
+{
+	struct b43_pio_txqueue *q = pack->queue;
+	const char *frame = pack->skb->data;
+	unsigned int frame_len = pack->skb->len;
+	u32 ctl;
+
+	ctl = b43_piotx_read32(q, B43_PIO8_TXCTL);
+	ctl |= B43_PIO8_TXCTL_FREADY;
+	ctl &= ~B43_PIO8_TXCTL_EOF;
+
+	/* Transfer the header data. */
+	tx_write_4byte_queue(q, &ctl, hdr, hdrlen);
+	/* Transfer the frame data. */
+	tx_write_4byte_queue(q, &ctl, frame, frame_len);
+
+	ctl |= B43_PIO8_TXCTL_EOF;
+	b43_piotx_write32(q, B43_PIO_TXCTL, ctl);
+}
+
+static int pio_tx_frame(struct b43_pio_txqueue *q,
+			struct sk_buff *skb,
+			struct ieee80211_tx_control *ctl)
+{
+	struct b43_pio_txpacket *pack;
+	struct b43_txhdr txhdr;
+	u16 cookie;
+	int err;
+	unsigned int hdrlen;
+
+	B43_WARN_ON(list_empty(&q->packets_list));
+	pack = list_entry(q->packets_list.next,
+			  struct b43_pio_txpacket, list);
+	memset(&pack->txstat, 0, sizeof(pack->txstat));
+	memcpy(&pack->txstat.control, ctl, sizeof(*ctl));
+
+	cookie = generate_cookie(q, pack);
+	hdrlen = b43_txhdr_size(q->dev);
+	err = b43_generate_txhdr(q->dev, (u8 *)&txhdr, skb->data,
+				 skb->len, ctl, cookie);
+	if (err)
+		return err;
+
+	if (ctl->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM) {
+		/* Tell the firmware about the cookie of the last
+		 * mcast frame, so it can clear the more-data bit in it. */
+		b43_shm_write16(q->dev, B43_SHM_SHARED,
+				B43_SHM_SH_MCASTCOOKIE, cookie);
+	}
+
+	pack->skb = skb;
+	if (q->rev >= 8)
+		pio_tx_frame_4byte_queue(pack, (const u8 *)&txhdr, hdrlen);
+	else
+		pio_tx_frame_2byte_queue(pack, (const u8 *)&txhdr, hdrlen);
+
+	/* Remove it from the list of available packet slots.
+	 * It will be put back when we receive the status report. */
+	list_del(&pack->list);
+
+	/* Update the queue statistics. */
+	q->buffer_used += roundup(skb->len + hdrlen, 4);
+	q->free_packet_slots -= 1;
+
+	return 0;
+}
+
+int b43_pio_tx(struct b43_wldev *dev,
+	       struct sk_buff *skb, struct ieee80211_tx_control *ctl)
+{
+	struct b43_pio_txqueue *q;
+	struct ieee80211_hdr *hdr;
+	unsigned long flags;
+	unsigned int hdrlen, total_len;
+	int err = 0;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (ctl->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM) {
+		/* The multicast queue will be sent after the DTIM. */
+		q = dev->pio.tx_queue_mcast;
+		/* Set the frame More-Data bit. Ucode will clear it
+		 * for us on the last frame. */
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	} else {
+		/* Decide by priority where to put this frame. */
+		q = select_queue_by_priority(dev, ctl->queue);
+	}
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	hdrlen = b43_txhdr_size(dev);
+	total_len = roundup(skb->len + hdrlen, 4);
+
+	if (unlikely(total_len > q->buffer_size)) {
+		err = -ENOBUFS;
+		b43dbg(dev->wl, "PIO: TX packet longer than queue.\n");
+		goto out_unlock;
+	}
+	if (unlikely(q->free_packet_slots == 0)) {
+		err = -ENOBUFS;
+		b43warn(dev->wl, "PIO: TX packet overflow.\n");
+		goto out_unlock;
+	}
+	B43_WARN_ON(q->buffer_used > q->buffer_size);
+
+	if (total_len > (q->buffer_size - q->buffer_used)) {
+		/* Not enough memory on the queue. */
+		err = -EBUSY;
+		ieee80211_stop_queue(dev->wl->hw, ctl->queue);
+		q->stopped = 1;
+		goto out_unlock;
+	}
+
+	/* Assign the queue number to the ring (if not already done before)
+	 * so TX status handling can use it. The mac80211-queue to b43-queue
+	 * mapping is static, so we don't need to store it per frame. */
+	q->queue_prio = ctl->queue;
+
+	err = pio_tx_frame(q, skb, ctl);
+	if (unlikely(err == -ENOKEY)) {
+		/* Drop this packet, as we don't have the encryption key
+		 * anymore and must not transmit it unencrypted. */
+		dev_kfree_skb_any(skb);
+		err = 0;
+		goto out_unlock;
+	}
+	if (unlikely(err)) {
+		b43err(dev->wl, "PIO transmission failure\n");
+		goto out_unlock;
+	}
+	q->nr_tx_packets++;
+
+	B43_WARN_ON(q->buffer_used > q->buffer_size);
+	if (((q->buffer_size - q->buffer_used) < roundup(2 + 2 + 6, 4)) ||
+	    (q->free_packet_slots == 0)) {
+		/* The queue is full. */
+		ieee80211_stop_queue(dev->wl->hw, ctl->queue);
+		q->stopped = 1;
+	}
+
+out_unlock:
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return err;
+}
+
+/* Called with IRQs disabled. */
+void b43_pio_handle_txstatus(struct b43_wldev *dev,
+			     const struct b43_txstatus *status)
+{
+	struct b43_pio_txqueue *q;
+	struct b43_pio_txpacket *pack = NULL;
+	unsigned int total_len;
+
+	q = parse_cookie(dev, status->cookie, &pack);
+	if (unlikely(!q))
+		return;
+	B43_WARN_ON(!pack);
+
+	spin_lock(&q->lock); /* IRQs are already disabled. */
+
+	b43_fill_txstatus_report(&(pack->txstat), status);
+
+	total_len = pack->skb->len + b43_txhdr_size(dev);
+	total_len = roundup(total_len, 4);
+	q->buffer_used -= total_len;
+	q->free_packet_slots += 1;
+
+	ieee80211_tx_status_irqsafe(dev->wl->hw, pack->skb,
+				    &(pack->txstat));
+	pack->skb = NULL;
+	list_add(&pack->list, &q->packets_list);
+
+	if (q->stopped) {
+		ieee80211_wake_queue(dev->wl->hw, q->queue_prio);
+		q->stopped = 0;
+	}
+
+	spin_unlock(&q->lock);
+}
+
+void b43_pio_get_tx_stats(struct b43_wldev *dev,
+			  struct ieee80211_tx_queue_stats *stats)
+{
+	const int nr_queues = dev->wl->hw->queues;
+	struct b43_pio_txqueue *q;
+	struct ieee80211_tx_queue_stats_data *data;
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < nr_queues; i++) {
+		data = &(stats->data[i]);
+		q = select_queue_by_priority(dev, i);
+
+		spin_lock_irqsave(&q->lock, flags);
+		data->len = B43_PIO_MAX_NR_TXPACKETS - q->free_packet_slots;
+		data->limit = B43_PIO_MAX_NR_TXPACKETS;
+		data->count = q->nr_tx_packets;
+		spin_unlock_irqrestore(&q->lock, flags);
+	}
+}
+
+/* Returns whether we should fetch another frame. */
+static bool pio_rx_frame(struct b43_pio_rxqueue *q)
+{
+	struct b43_rxhdr_fw4 rxhdr;
+	u16 len;
+	u32 macstat;
+	unsigned int i, padding;
+	struct sk_buff *skb;
+	const char *err_msg = NULL;
+
+	memset(&rxhdr, 0, sizeof(rxhdr));
+
+	/* Check if we have data and wait for it to get ready. */
+	if (q->rev >= 8) {
+		u32 ctl;
+
+		ctl = b43_piorx_read32(q, B43_PIO8_RXCTL);
+		if (!(ctl & B43_PIO8_RXCTL_FRAMERDY))
+			return 0;
+		b43_piorx_write32(q, B43_PIO8_RXCTL,
+				  B43_PIO8_RXCTL_FRAMERDY);
+		for (i = 0; i < 10; i++) {
+			ctl = b43_piorx_read32(q, B43_PIO8_RXCTL);
+			if (ctl & B43_PIO8_RXCTL_DATARDY)
+				goto data_ready;
+			udelay(10);
+		}
+	} else {
+		u16 ctl;
+
+		ctl = b43_piorx_read16(q, B43_PIO_RXCTL);
+		if (!(ctl & B43_PIO_RXCTL_FRAMERDY))
+			return 0;
+		b43_piorx_write16(q, B43_PIO_RXCTL,
+				  B43_PIO_RXCTL_FRAMERDY);
+		for (i = 0; i < 10; i++) {
+			ctl = b43_piorx_read16(q, B43_PIO_RXCTL);
+			if (ctl & B43_PIO_RXCTL_DATARDY)
+				goto data_ready;
+			udelay(10);
+		}
+	}
+	b43dbg(q->dev->wl, "PIO RX timed out\n");
+	return 1;
+data_ready:
+
+	/* Get the preamble (RX header) */
+	if (q->rev >= 8) {
+		u32 *preamble = (u32 *)&rxhdr;
+		u32 value;
+
+		for (i = 0; i < sizeof(rxhdr); i += 4) {
+			value = b43_piorx_read32(q, B43_PIO8_RXDATA);
+			preamble[i / 4] = cpu_to_le32(value);
+		}
+	} else {
+		u16 *preamble = (u16 *)&rxhdr;
+		u16 value;
+
+		for (i = 0; i < sizeof(rxhdr); i += 2) {
+			value = b43_piorx_read16(q, B43_PIO_RXDATA);
+			preamble[i / 2] = cpu_to_le16(value);
+		}
+	}
+	/* Sanity checks. */
+	len = le16_to_cpu(rxhdr.frame_len);
+	if (unlikely(len > 0x700)) {
+		err_msg = "len > 0x700";
+		goto rx_error;
+	}
+	if (unlikely(len == 0)) {
+		err_msg = "len == 0";
+		goto rx_error;
+	}
+
+	macstat = le32_to_cpu(rxhdr.mac_status);
+	if (macstat & B43_RX_MAC_FCSERR) {
+		if (!(q->dev->wl->filter_flags & FIF_FCSFAIL)) {
+			/* Drop frames with failed FCS. */
+			err_msg = "Frame FCS error";
+			goto rx_error;
+		}
+	}
+
+	/* We always pad 2 bytes, as that's what upstream code expects
+	 * due to the RX-header being 30 bytes. In case the frame is
+	 * unaligned, we pad another 2 bytes. */
+	padding = (macstat & B43_RX_MAC_PADDING) ? 2 : 0;
+	skb = dev_alloc_skb(len + padding + 2);
+	if (unlikely(!skb)) {
+		err_msg = "Out of memory";
+		goto rx_error;
+	}
+	skb_reserve(skb, 2);
+	skb_put(skb, len + padding);
+	if (q->rev >= 8) {
+		u32 value;
+
+		for (i = padding; i < len + padding; i += 4) {
+			value = b43_piorx_read32(q, B43_PIO8_RXDATA);
+			skb->data[i] = value;
+			if ((i + 1) < (len + padding))
+				skb->data[i + 1] = value >> 8;
+			if ((i + 2) < (len + padding))
+				skb->data[i + 2] = value >> 16;
+			if ((i + 3) < (len + padding))
+				skb->data[i + 3] = value >> 24;
+		}
+	} else {
+		u16 value;
+
+		for (i = padding; i < len + padding; i += 2) {
+			value = b43_piorx_read16(q, B43_PIO_RXDATA);
+			skb->data[i] = value;
+			if ((i + 1) < (len + padding))
+				skb->data[i + 1] = value >> 8;
+		}
+	}
+
+	b43_rx(q->dev, skb, &rxhdr);
+
+	return 1;
+
+rx_error:
+	if (err_msg)
+		b43dbg(q->dev->wl, "PIO RX error: %s\n", err_msg);
+	b43_piorx_write16(q, B43_PIO_RXCTL, B43_PIO_RXCTL_DATARDY);
+	return 1;
+}
+
+/* RX workqueue. We can sleep, yay! */
+static void b43_pio_rx_work(struct work_struct *work)
+{
+	struct b43_pio_rxqueue *q = container_of(work, struct b43_pio_rxqueue,
+						 rx_work);
+	unsigned int budget = 50;
+	bool stop;
+
+	do {
+		spin_lock_irq(&q->lock);
+		stop = (pio_rx_frame(q) == 0);
+		spin_unlock_irq(&q->lock);
+		cond_resched();
+		if (stop)
+			break;
+	} while (--budget);
+}
+
+/* Called with IRQs disabled. */
+void b43_pio_rx(struct b43_pio_rxqueue *q)
+{
+	/* Due to latency issues we must run the RX path in
+	 * a workqueue to be able to schedule between packets. */
+	queue_work(q->dev->wl->hw->workqueue, &q->rx_work);
+}
+
+static void b43_pio_tx_suspend_queue(struct b43_pio_txqueue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (q->rev >= 8) {
+		b43_piotx_write32(q, B43_PIO8_TXCTL,
+				  b43_piotx_read32(q, B43_PIO8_TXCTL)
+				  | B43_PIO8_TXCTL_SUSPREQ);
+	} else {
+		b43_piotx_write16(q, B43_PIO_TXCTL,
+				  b43_piotx_read16(q, B43_PIO_TXCTL)
+				  | B43_PIO_TXCTL_SUSPREQ);
+	}
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+
+static void b43_pio_tx_resume_queue(struct b43_pio_txqueue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (q->rev >= 8) {
+		b43_piotx_write32(q, B43_PIO8_TXCTL,
+				  b43_piotx_read32(q, B43_PIO8_TXCTL)
+				  & ~B43_PIO8_TXCTL_SUSPREQ);
+	} else {
+		b43_piotx_write16(q, B43_PIO_TXCTL,
+				  b43_piotx_read16(q, B43_PIO_TXCTL)
+				  & ~B43_PIO_TXCTL_SUSPREQ);
+	}
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+
+void b43_pio_tx_suspend(struct b43_wldev *dev)
+{
+	b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
+	b43_pio_tx_suspend_queue(dev->pio.tx_queue_AC_BK);
+	b43_pio_tx_suspend_queue(dev->pio.tx_queue_AC_BE);
+	b43_pio_tx_suspend_queue(dev->pio.tx_queue_AC_VI);
+	b43_pio_tx_suspend_queue(dev->pio.tx_queue_AC_VO);
+	b43_pio_tx_suspend_queue(dev->pio.tx_queue_mcast);
+}
+
+void b43_pio_tx_resume(struct b43_wldev *dev)
+{
+	b43_pio_tx_resume_queue(dev->pio.tx_queue_mcast);
+	b43_pio_tx_resume_queue(dev->pio.tx_queue_AC_VO);
+	b43_pio_tx_resume_queue(dev->pio.tx_queue_AC_VI);
+	b43_pio_tx_resume_queue(dev->pio.tx_queue_AC_BE);
+	b43_pio_tx_resume_queue(dev->pio.tx_queue_AC_BK);
+	b43_power_saving_ctl_bits(dev, 0);
+}
Index: wireless-testing/drivers/net/wireless/b43/pio.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/net/wireless/b43/pio.h	2008-03-29 19:52:35.000000000 +0100
@@ -0,0 +1,220 @@
+#ifndef B43_PIO_H_
+#define B43_PIO_H_
+
+#include "b43.h"
+
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/list.h>
+#include <linux/skbuff.h>
+
+
+/*** Registers for PIO queues up to revision 7. ***/
+/* TX queue. */
+#define B43_PIO_TXCTL			0x00
+#define  B43_PIO_TXCTL_WRITELO		0x0001
+#define  B43_PIO_TXCTL_WRITEHI		0x0002
+#define  B43_PIO_TXCTL_EOF		0x0004
+#define  B43_PIO_TXCTL_FREADY		0x0008
+#define  B43_PIO_TXCTL_FLUSHREQ		0x0020
+#define  B43_PIO_TXCTL_FLUSHPEND	0x0040
+#define  B43_PIO_TXCTL_SUSPREQ		0x0080
+#define  B43_PIO_TXCTL_QSUSP		0x0100
+#define  B43_PIO_TXCTL_COMMCNT		0xFC00
+#define  B43_PIO_TXCTL_COMMCNT_SHIFT	10
+#define B43_PIO_TXDATA			0x02
+#define B43_PIO_TXQBUFSIZE		0x04
+/* RX queue. */
+#define B43_PIO_RXCTL			0x00
+#define  B43_PIO_RXCTL_FRAMERDY		0x0001
+#define  B43_PIO_RXCTL_DATARDY		0x0002
+#define B43_PIO_RXDATA			0x02
+
+/*** Registers for PIO queues revision 8 and later. ***/
+/* TX queue */
+#define B43_PIO8_TXCTL			0x00
+#define  B43_PIO8_TXCTL_0_7		0x00000001
+#define  B43_PIO8_TXCTL_8_15		0x00000002
+#define  B43_PIO8_TXCTL_16_23		0x00000004
+#define  B43_PIO8_TXCTL_24_31		0x00000008
+#define  B43_PIO8_TXCTL_EOF		0x00000010
+#define  B43_PIO8_TXCTL_FREADY		0x00000080
+#define  B43_PIO8_TXCTL_SUSPREQ		0x00000100
+#define  B43_PIO8_TXCTL_QSUSP		0x00000200
+#define  B43_PIO8_TXCTL_FLUSHREQ	0x00000400
+#define  B43_PIO8_TXCTL_FLUSHPEND	0x00000800
+#define B43_PIO8_TXDATA			0x04
+/* RX queue */
+#define B43_PIO8_RXCTL			0x00
+#define  B43_PIO8_RXCTL_FRAMERDY	0x00000001
+#define  B43_PIO8_RXCTL_DATARDY		0x00000002
+#define B43_PIO8_RXDATA			0x04
+
+
+/* The maximum number of TX-packets the HW can handle. */
+#define B43_PIO_MAX_NR_TXPACKETS	32
+
+
+#ifdef CONFIG_B43_PIO
+
+struct b43_pio_txpacket {
+	/* Pointer to the TX queue we belong to. */
+	struct b43_pio_txqueue *queue;
+	/* The TX data packet. */
+	struct sk_buff *skb;
+	/* The status meta data. */
+	struct ieee80211_tx_status txstat;
+	/* Index in the (struct b43_pio_txqueue)->packets array. */
+	u8 index;
+
+	struct list_head list;
+};
+
+struct b43_pio_txqueue {
+	struct b43_wldev *dev;
+	spinlock_t lock;
+	u16 mmio_base;
+
+	/* The device queue buffer size in bytes. */
+	u16 buffer_size;
+	/* The number of used bytes in the device queue buffer. */
+	u16 buffer_used;
+	/* The number of packets that can still get queued.
+	 * This is decremented on queueing a packet and incremented
+	 * after receiving the transmit status. */
+	u16 free_packet_slots;
+
+	/* True, if the mac80211 queue was stopped due to overflow at TX. */
+	bool stopped;
+	/* Our b43 queue index number */
+	u8 index;
+	/* The mac80211 QoS queue priority. */
+	u8 queue_prio;
+
+	/* Buffer for TX packet meta data. */
+	struct b43_pio_txpacket packets[B43_PIO_MAX_NR_TXPACKETS];
+	struct list_head packets_list;
+
+	/* Total number of transmitted packets. */
+	unsigned int nr_tx_packets;
+
+	/* Shortcut to the 802.11 core revision. This is to
+	 * avoid horrible pointer dereferencing in the fastpaths. */
+	u8 rev;
+};
+
+struct b43_pio_rxqueue {
+	struct b43_wldev *dev;
+	spinlock_t lock;
+	u16 mmio_base;
+
+	/* Work to reduce latency issues on RX. */
+	struct work_struct rx_work;
+
+	/* Shortcut to the 802.11 core revision. This is to
+	 * avoid horrible pointer dereferencing in the fastpaths. */
+	u8 rev;
+};
+
+
+static inline u16 b43_piotx_read16(struct b43_pio_txqueue *q, u16 offset)
+{
+	return b43_read16(q->dev, q->mmio_base + offset);
+}
+
+static inline u32 b43_piotx_read32(struct b43_pio_txqueue *q, u16 offset)
+{
+	return b43_read32(q->dev, q->mmio_base + offset);
+}
+
+static inline void b43_piotx_write16(struct b43_pio_txqueue *q,
+				     u16 offset, u16 value)
+{
+	b43_write16(q->dev, q->mmio_base + offset, value);
+}
+
+static inline void b43_piotx_write32(struct b43_pio_txqueue *q,
+				     u16 offset, u32 value)
+{
+	b43_write32(q->dev, q->mmio_base + offset, value);
+}
+
+
+static inline u16 b43_piorx_read16(struct b43_pio_rxqueue *q, u16 offset)
+{
+	return b43_read16(q->dev, q->mmio_base + offset);
+}
+
+static inline u32 b43_piorx_read32(struct b43_pio_rxqueue *q, u16 offset)
+{
+	return b43_read32(q->dev, q->mmio_base + offset);
+}
+
+static inline void b43_piorx_write16(struct b43_pio_rxqueue *q,
+				     u16 offset, u16 value)
+{
+	b43_write16(q->dev, q->mmio_base + offset, value);
+}
+
+static inline void b43_piorx_write32(struct b43_pio_rxqueue *q,
+				     u16 offset, u32 value)
+{
+	b43_write32(q->dev, q->mmio_base + offset, value);
+}
+
+
+int b43_pio_init(struct b43_wldev *dev);
+void b43_pio_stop(struct b43_wldev *dev);
+void b43_pio_free(struct b43_wldev *dev);
+
+int b43_pio_tx(struct b43_wldev *dev,
+	       struct sk_buff *skb, struct ieee80211_tx_control *ctl);
+void b43_pio_handle_txstatus(struct b43_wldev *dev,
+			     const struct b43_txstatus *status);
+void b43_pio_get_tx_stats(struct b43_wldev *dev,
+			  struct ieee80211_tx_queue_stats *stats);
+void b43_pio_rx(struct b43_pio_rxqueue *q);
+
+void b43_pio_tx_suspend(struct b43_wldev *dev);
+void b43_pio_tx_resume(struct b43_wldev *dev);
+
+
+#else /* CONFIG_B43_PIO */
+
+
+static inline int b43_pio_init(struct b43_wldev *dev)
+{
+	return 0;
+}
+static inline void b43_pio_free(struct b43_wldev *dev)
+{
+}
+static inline void b43_pio_stop(struct b43_wldev *dev)
+{
+}
+static inline int b43_pio_tx(struct b43_wldev *dev,
+			     struct sk_buff *skb,
+			     struct ieee80211_tx_control *ctl)
+{
+	return 0;
+}
+static inline void b43_pio_handle_txstatus(struct b43_wldev *dev,
+					   const struct b43_txstatus *status)
+{
+}
+static inline void b43_pio_get_tx_stats(struct b43_wldev *dev,
+					struct ieee80211_tx_queue_stats *stats)
+{
+}
+static inline void b43_pio_rx(struct b43_pio_rxqueue *q)
+{
+}
+static inline void b43_pio_tx_suspend(struct b43_wldev *dev)
+{
+}
+static inline void b43_pio_tx_resume(struct b43_wldev *dev)
+{
+}
+
+#endif /* CONFIG_B43_PIO */
+#endif /* B43_PIO_H_ */
Index: wireless-testing/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Makefile	2008-03-29 19:52:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/Makefile	2008-03-29 19:52:35.000000000 +0100
@@ -5,12 +5,13 @@ b43-y				+= phy.o
 b43-$(CONFIG_B43_NPHY)		+= nphy.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
 b43-y				+= wa.o
 b43-y				+= dma.o
+b43-$(CONFIG_B43_PIO)		+= pio.o
 b43-$(CONFIG_B43_RFKILL)	+= rfkill.o
 b43-$(CONFIG_B43_LEDS)		+= leds.o
 b43-$(CONFIG_B43_PCMCIA)	+= pcmcia.o
 b43-$(CONFIG_B43_DEBUG)		+= debugfs.o
 
 obj-$(CONFIG_B43)		+= b43.o
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-03-29 19:52:14.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-03-29 19:52:35.000000000 +0100
@@ -72,12 +72,29 @@
 #define B43_MMIO_DMA64_BASE1		0x240
 #define B43_MMIO_DMA64_BASE2		0x280
 #define B43_MMIO_DMA64_BASE3		0x2C0
 #define B43_MMIO_DMA64_BASE4		0x300
 #define B43_MMIO_DMA64_BASE5		0x340
 
+/* PIO on core rev < 11 */
+#define B43_MMIO_PIO_BASE0		0x300
+#define B43_MMIO_PIO_BASE1		0x310
+#define B43_MMIO_PIO_BASE2		0x320
+#define B43_MMIO_PIO_BASE3		0x330
+#define B43_MMIO_PIO_BASE4		0x340
+#define B43_MMIO_PIO_BASE5		0x350
+#define B43_MMIO_PIO_BASE6		0x360
+#define B43_MMIO_PIO_BASE7		0x370
+/* PIO on core rev >= 11 */
+#define B43_MMIO_PIO11_BASE0		0x200
+#define B43_MMIO_PIO11_BASE1		0x240
+#define B43_MMIO_PIO11_BASE2		0x280
+#define B43_MMIO_PIO11_BASE3		0x2C0
+#define B43_MMIO_PIO11_BASE4		0x300
+#define B43_MMIO_PIO11_BASE5		0x340
+
 #define B43_MMIO_PHY_VER		0x3E0
 #define B43_MMIO_PHY_RADIO		0x3E2
 #define B43_MMIO_PHY0			0x3E6
 #define B43_MMIO_ANTENNA		0x3E8
 #define B43_MMIO_CHANNEL		0x3F0
 #define B43_MMIO_CHANNEL_EXT		0x3F4
@@ -439,13 +456,12 @@ enum {
 	B43_SEC_ALGO_AES,
 	B43_SEC_ALGO_WEP104,
 	B43_SEC_ALGO_AES_LEGACY,
 };
 
 struct b43_dmaring;
-struct b43_pioqueue;
 
 /* The firmware file header */
 #define B43_FW_TYPE_UCODE	'u'
 #define B43_FW_TYPE_PCM		'p'
 #define B43_FW_TYPE_IV		'i'
 struct b43_fw_header {
@@ -595,12 +611,26 @@ struct b43_dma {
 	struct b43_dmaring *tx_ring_AC_VO; /* Voice */
 	struct b43_dmaring *tx_ring_mcast; /* Multicast */
 
 	struct b43_dmaring *rx_ring;
 };
 
+struct b43_pio_txqueue;
+struct b43_pio_rxqueue;
+
+/* Data structures for PIO transmission, per 80211 core. */
+struct b43_pio {
+	struct b43_pio_txqueue *tx_queue_AC_BK; /* Background */
+	struct b43_pio_txqueue *tx_queue_AC_BE; /* Best Effort */
+	struct b43_pio_txqueue *tx_queue_AC_VI; /* Video */
+	struct b43_pio_txqueue *tx_queue_AC_VO; /* Voice */
+	struct b43_pio_txqueue *tx_queue_mcast; /* Multicast */
+
+	struct b43_pio_rxqueue *rx_queue;
+};
+
 /* Context information for a noise calculation (Link Quality). */
 struct b43_noise_calculation {
 	u8 channel_at_start;
 	bool calculation_running;
 	u8 nr_samples;
 	s8 samples[8][4];
@@ -770,14 +800,21 @@ struct b43_wldev {
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
 	bool suspend_in_progress;	/* TRUE, if we are in a suspend/resume cycle */
 
 	/* PHY/Radio device. */
 	struct b43_phy phy;
 
-	/* DMA engines. */
-	struct b43_dma dma;
+	union {
+		/* DMA engines. */
+		struct b43_dma dma;
+		/* PIO engines. */
+		struct b43_pio pio;
+	};
+	/* Use b43_using_pio_transfers() to check whether we are using
+	 * DMA or PIO data transfers. */
+	bool __using_pio_transfers;
 
 	/* Various statistics about the physical device. */
 	struct b43_stats stats;
 
 	/* The device LEDs. */
 	struct b43_led led_tx;
@@ -855,12 +892,28 @@ static inline u32 b43_read32(struct b43_
 
 static inline void b43_write32(struct b43_wldev *dev, u16 offset, u32 value)
 {
 	ssb_write32(dev->dev, offset, value);
 }
 
+static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
+{
+#ifdef CONFIG_B43_PIO
+	return dev->__using_pio_transfers;
+#else
+	return 0;
+#endif
+}
+
+#ifdef CONFIG_B43_FORCE_PIO
+# define B43_FORCE_PIO	1
+#else
+# define B43_FORCE_PIO	0
+#endif
+
+
 /* Message printing */
 void b43info(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 void b43err(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 void b43warn(struct b43_wl *wl, const char *fmt, ...)
Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-03-29 19:52:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-03-29 19:52:35.000000000 +0100
@@ -547,13 +547,12 @@ address_error:
 
 static int setup_rx_descbuffer(struct b43_dmaring *ring,
 			       struct b43_dmadesc_generic *desc,
 			       struct b43_dmadesc_meta *meta, gfp_t gfp_flags)
 {
 	struct b43_rxhdr_fw4 *rxhdr;
-	struct b43_hwtxstatus *txstat;
 	dma_addr_t dmaaddr;
 	struct sk_buff *skb;
 
 	B43_WARN_ON(ring->tx);
 
 	skb = __dev_alloc_skb(ring->rx_buffersize, gfp_flags);
@@ -583,14 +582,12 @@ static int setup_rx_descbuffer(struct b4
 	meta->dmaaddr = dmaaddr;
 	ring->ops->fill_descriptor(ring, desc, dmaaddr,
 				   ring->rx_buffersize, 0, 0, 0);
 
 	rxhdr = (struct b43_rxhdr_fw4 *)(skb->data);
 	rxhdr->frame_len = 0;
-	txstat = (struct b43_hwtxstatus *)(skb->data);
-	txstat->cookie = 0;
 
 	return 0;
 }
 
 /* Allocate the initial descbuffers.
  * This is used for an RX ring only.
@@ -773,12 +770,24 @@ static u64 supported_dma_mask(struct b43
 	if (tmp & B43_DMA32_TXADDREXT_MASK)
 		return DMA_32BIT_MASK;
 
 	return DMA_30BIT_MASK;
 }
 
+static enum b43_dmatype dma_mask_to_engine_type(u64 dmamask)
+{
+	if (dmamask == DMA_30BIT_MASK)
+		return B43_DMA_30BIT;
+	if (dmamask == DMA_32BIT_MASK)
+		return B43_DMA_32BIT;
+	if (dmamask == DMA_64BIT_MASK)
+		return B43_DMA_64BIT;
+	B43_WARN_ON(1);
+	return B43_DMA_30BIT;
+}
+
 /* Main initialization function. */
 static
 struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 				      int controller_index,
 				      int for_tx,
 				      enum b43_dmatype type)
@@ -953,13 +962,17 @@ static void b43_destroy_dmaring(struct b
 	b43_destroy_dmaring((dma)->ring, __stringify(ring));	\
 	(dma)->ring = NULL;					\
     } while (0)
 
 void b43_dma_free(struct b43_wldev *dev)
 {
-	struct b43_dma *dma = &dev->dma;
+	struct b43_dma *dma;
+
+	if (b43_using_pio_transfers(dev))
+		return;
+	dma = &dev->dma;
 
 	destroy_ring(dma, rx_ring);
 	destroy_ring(dma, tx_ring_AC_BK);
 	destroy_ring(dma, tx_ring_AC_BE);
 	destroy_ring(dma, tx_ring_AC_VI);
 	destroy_ring(dma, tx_ring_AC_VO);
@@ -971,25 +984,13 @@ int b43_dma_init(struct b43_wldev *dev)
 	struct b43_dma *dma = &dev->dma;
 	int err;
 	u64 dmamask;
 	enum b43_dmatype type;
 
 	dmamask = supported_dma_mask(dev);
-	switch (dmamask) {
-	default:
-		B43_WARN_ON(1);
-	case DMA_30BIT_MASK:
-		type = B43_DMA_30BIT;
-		break;
-	case DMA_32BIT_MASK:
-		type = B43_DMA_32BIT;
-		break;
-	case DMA_64BIT_MASK:
-		type = B43_DMA_64BIT;
-		break;
-	}
+	type = dma_mask_to_engine_type(dmamask);
 	err = ssb_dma_set_mask(dev->dev, dmamask);
 	if (err) {
 		b43err(dev->wl, "The machine/kernel does not support "
 		       "the required DMA mask (0x%08X%08X)\n",
 		       (unsigned int)((dmamask & 0xFFFFFFFF00000000ULL) >> 32),
 		       (unsigned int)(dmamask & 0x00000000FFFFFFFFULL));
@@ -1110,13 +1111,12 @@ static int dma_tx_fragment(struct b43_dm
 	struct b43_dmadesc_meta *meta_hdr;
 	struct sk_buff *bounce_skb;
 	u16 cookie;
 	size_t hdrsize = b43_txhdr_size(ring->dev);
 
 #define SLOTS_PER_PACKET  2
-	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 
 	old_top_slot = ring->current_slot;
 	old_used_slots = ring->used_slots;
 
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
@@ -1254,17 +1254,12 @@ int b43_dma_tx(struct b43_wldev *dev,
 {
 	struct b43_dmaring *ring;
 	struct ieee80211_hdr *hdr;
 	int err = 0;
 	unsigned long flags;
 
-	if (unlikely(skb->len < 2 + 2 + 6)) {
-		/* Too short, this can't be a valid frame. */
-		return -EINVAL;
-	}
-
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (ctl->flags & IEEE80211_TXCTL_SEND_AFTER_DTIM) {
 		/* The multicast ring will be sent after the DTIM */
 		ring = dev->dma.tx_ring_mcast;
 		/* Set the more-data bit. Ucode will clear it on
 		 * the last frame for us. */
@@ -1316,53 +1311,22 @@ int b43_dma_tx(struct b43_wldev *dev,
 out_unlock:
 	spin_unlock_irqrestore(&ring->lock, flags);
 
 	return err;
 }
 
-static void b43_fill_txstatus_report(struct b43_dmaring *ring,
-				    struct ieee80211_tx_status *report,
-				    const struct b43_txstatus *status)
-{
-	bool frame_failed = 0;
-
-	if (status->acked) {
-		/* The frame was ACKed. */
-		report->flags |= IEEE80211_TX_STATUS_ACK;
-	} else {
-		/* The frame was not ACKed... */
-		if (!(report->control.flags & IEEE80211_TXCTL_NO_ACK)) {
-			/* ...but we expected an ACK. */
-			frame_failed = 1;
-			report->excessive_retries = 1;
-		}
-	}
-	if (status->frame_count == 0) {
-		/* The frame was not transmitted at all. */
-		report->retry_count = 0;
-	} else {
-		report->retry_count = status->frame_count - 1;
-#ifdef CONFIG_B43_DEBUG
-		if (frame_failed)
-			ring->nr_failed_tx_packets++;
-		else
-			ring->nr_succeed_tx_packets++;
-		ring->nr_total_packet_tries += status->frame_count;
-#endif /* DEBUG */
-	}
-}
-
 /* Called with IRQs disabled. */
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status)
 {
 	const struct b43_dma_ops *ops;
 	struct b43_dmaring *ring;
 	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
 	int slot;
+	bool frame_succeed;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
 	if (unlikely(!ring))
 		return;
 
 	spin_lock(&ring->lock); /* IRQs are already disabled. */
@@ -1383,13 +1347,21 @@ void b43_dma_handle_txstatus(struct b43_
 		if (meta->is_last_fragment) {
 			B43_WARN_ON(!meta->skb);
 			/* Call back to inform the ieee80211 subsystem about the
 			 * status of the transmission.
 			 * Some fields of txstat are already filled in dma_tx().
 			 */
-			b43_fill_txstatus_report(ring, &(meta->txstat), status);
+			frame_succeed = b43_fill_txstatus_report(
+						&(meta->txstat), status);
+#ifdef CONFIG_B43_DEBUG
+			if (frame_succeed)
+				ring->nr_succeed_tx_packets++;
+			else
+				ring->nr_failed_tx_packets++;
+			ring->nr_total_packet_tries += status->frame_count;
+#endif /* DEBUG */
 			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb,
 						    &(meta->txstat));
 			/* skb is freed by ieee80211_tx_status_irqsafe() */
 			meta->skb = NULL;
 		} else {
 			/* No need to call free_descriptor_buffer here, as
@@ -1570,6 +1542,42 @@ void b43_dma_tx_resume(struct b43_wldev 
 	b43_dma_tx_resume_ring(dev->dma.tx_ring_AC_VO);
 	b43_dma_tx_resume_ring(dev->dma.tx_ring_AC_VI);
 	b43_dma_tx_resume_ring(dev->dma.tx_ring_AC_BE);
 	b43_dma_tx_resume_ring(dev->dma.tx_ring_AC_BK);
 	b43_power_saving_ctl_bits(dev, 0);
 }
+
+#ifdef CONFIG_B43_PIO
+static void direct_fifo_rx(struct b43_wldev *dev, enum b43_dmatype type,
+			   u16 mmio_base, bool enable)
+{
+	u32 ctl;
+
+	if (type == B43_DMA_64BIT) {
+		ctl = b43_read32(dev, mmio_base + B43_DMA64_RXCTL);
+		ctl &= ~B43_DMA64_RXDIRECTFIFO;
+		if (enable)
+			ctl |= B43_DMA64_RXDIRECTFIFO;
+		b43_write32(dev, mmio_base + B43_DMA64_RXCTL, ctl);
+	} else {
+		ctl = b43_read32(dev, mmio_base + B43_DMA32_RXCTL);
+		ctl &= ~B43_DMA32_RXDIRECTFIFO;
+		if (enable)
+			ctl |= B43_DMA32_RXDIRECTFIFO;
+		b43_write32(dev, mmio_base + B43_DMA32_RXCTL, ctl);
+	}
+}
+
+/* Enable/Disable Direct FIFO Receive Mode (PIO) on a RX engine.
+ * This is called from PIO code, so DMA structures are not available. */
+void b43_dma_direct_fifo_rx(struct b43_wldev *dev,
+			    unsigned int engine_index, bool enable)
+{
+	enum b43_dmatype type;
+	u16 mmio_base;
+
+	type = dma_mask_to_engine_type(supported_dma_mask(dev));
+
+	mmio_base = b43_dmacontroller_base(type, engine_index);
+	direct_fifo_rx(dev, type, mmio_base, enable);
+}
+#endif /* CONFIG_B43_PIO */
Index: wireless-testing/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2008-03-29 19:52:14.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2008-03-29 19:52:35.000000000 +0100
@@ -288,7 +288,10 @@ int b43_dma_tx(struct b43_wldev *dev,
 	       struct sk_buff *skb, struct ieee80211_tx_control *ctl);
 void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			     const struct b43_txstatus *status);
 
 void b43_dma_rx(struct b43_dmaring *ring);
 
+void b43_dma_direct_fifo_rx(struct b43_wldev *dev,
+			    unsigned int engine_index, bool enable);
+
 #endif /* B43_DMA_H_ */
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-03-29 19:52:35.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-03-29 19:52:35.000000000 +0100
@@ -44,12 +44,13 @@
 
 #include "b43.h"
 #include "main.h"
 #include "debugfs.h"
 #include "phy.h"
 #include "dma.h"
+#include "pio.h"
 #include "sysfs.h"
 #include "xmit.h"
 #include "lo.h"
 #include "pcmcia.h"
 
 MODULE_DESCRIPTION("Broadcom B43 wireless driver");
@@ -1590,14 +1591,18 @@ static void b43_interrupt_tasklet(struct
 	if (reason & B43_IRQ_TXFIFO_FLUSH_OK)
 		;/* TODO */
 	if (reason & B43_IRQ_NOISESAMPLE_OK)
 		handle_irq_noise(dev);
 
 	/* Check the DMA reason registers for received data. */
-	if (dma_reason[0] & B43_DMAIRQ_RX_DONE)
-		b43_dma_rx(dev->dma.rx_ring);
+	if (dma_reason[0] & B43_DMAIRQ_RX_DONE) {
+		if (b43_using_pio_transfers(dev))
+			b43_pio_rx(dev->pio.rx_queue);
+		else
+			b43_dma_rx(dev->dma.rx_ring);
+	}
 	B43_WARN_ON(dma_reason[1] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[2] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[3] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[4] & B43_DMAIRQ_RX_DONE);
 	B43_WARN_ON(dma_reason[5] & B43_DMAIRQ_RX_DONE);
 
@@ -2695,18 +2700,27 @@ static int b43_op_tx(struct ieee80211_hw
 		     struct ieee80211_tx_control *ctl)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	int err = -ENODEV;
 
+	if (unlikely(skb->len < 2 + 2 + 6)) {
+		/* Too short, this can't be a valid frame. */
+		return -EINVAL;
+	}
+	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
+
 	if (unlikely(!dev))
 		goto out;
 	if (unlikely(b43_status(dev) < B43_STAT_STARTED))
 		goto out;
-	/* DMA-TX is done without a global lock. */
-	err = b43_dma_tx(dev, skb, ctl);
+	/* TX is done without a global lock. */
+	if (b43_using_pio_transfers(dev))
+		err = b43_pio_tx(dev, skb, ctl);
+	else
+		err = b43_dma_tx(dev, skb, ctl);
 out:
 	if (unlikely(err))
 		return NETDEV_TX_BUSY;
 	return NETDEV_TX_OK;
 }
 
@@ -2894,13 +2908,16 @@ static int b43_op_get_tx_stats(struct ie
 	int err = -ENODEV;
 
 	if (!dev)
 		goto out;
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	if (likely(b43_status(dev) >= B43_STAT_STARTED)) {
-		b43_dma_get_tx_stats(dev, stats);
+		if (b43_using_pio_transfers(dev))
+			b43_pio_get_tx_stats(dev, stats);
+		else
+			b43_dma_get_tx_stats(dev, stats);
 		err = 0;
 	}
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 out:
 	return err;
 }
@@ -3363,12 +3380,13 @@ static void b43_wireless_core_stop(struc
 	b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* flush */
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	b43_synchronize_irq(dev);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
+	b43_pio_stop(dev);
 	mutex_unlock(&wl->mutex);
 	/* Must unlock as it would otherwise deadlock. No races here.
 	 * Cancel the possibly running self-rearming periodic work. */
 	cancel_delayed_work_sync(&dev->periodic_work);
 	mutex_lock(&wl->mutex);
 
@@ -3680,12 +3698,13 @@ static void b43_wireless_core_exit(struc
 
 	if (!dev->suspend_in_progress) {
 		b43_leds_exit(dev);
 		b43_rng_exit(dev->wl, false);
 	}
 	b43_dma_free(dev);
+	b43_pio_free(dev);
 	b43_chip_exit(dev);
 	b43_radio_turn_off(dev, 1);
 	b43_switch_analog(dev, 0);
 	if (phy->dyn_tssi_tbl)
 		kfree(phy->tssi2dbm);
 	kfree(phy->lo_control);
@@ -3777,13 +3796,19 @@ static int b43_wireless_core_init(struct
 	} else {
 		b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MINCONT, 0xF);
 	}
 	/* Maximum Contention Window */
 	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
 
-	err = b43_dma_init(dev);
+	if ((dev->dev->bus->bustype == SSB_BUSTYPE_PCMCIA) || B43_FORCE_PIO) {
+		dev->__using_pio_transfers = 1;
+		err = b43_pio_init(dev);
+	} else {
+		dev->__using_pio_transfers = 0;
+		err = b43_dma_init(dev);
+	}
 	if (err)
 		goto err_chip_exit;
 	b43_qos_init(dev);
 
 //FIXME
 #if 1
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2008-03-29 19:52:14.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2008-03-29 19:52:35.000000000 +0100
@@ -27,12 +27,13 @@
 
 */
 
 #include "xmit.h"
 #include "phy.h"
 #include "dma.h"
+#include "pio.h"
 
 
 /* Extract the bitrate index out of a CCK PLCP header. */
 static int b43_plcp_get_bitrate_idx_cck(struct b43_plcp_hdr6 *plcp)
 {
 	switch (plcp->raw[0]) {
@@ -665,43 +666,57 @@ void b43_handle_txstatus(struct b43_wlde
 		if (status->rts_count == 0xF)	//FIXME
 			dev->wl->ieee_stats.dot11RTSFailureCount++;
 		else
 			dev->wl->ieee_stats.dot11RTSSuccessCount++;
 	}
 
-	b43_dma_handle_txstatus(dev, status);
+	if (b43_using_pio_transfers(dev))
+		b43_pio_handle_txstatus(dev, status);
+	else
+		b43_dma_handle_txstatus(dev, status);
 }
 
-/* Handle TX status report as received through DMA/PIO queues */
-void b43_handle_hwtxstatus(struct b43_wldev *dev,
-			   const struct b43_hwtxstatus *hw)
-{
-	struct b43_txstatus status;
-	u8 tmp;
-
-	status.cookie = le16_to_cpu(hw->cookie);
-	status.seq = le16_to_cpu(hw->seq);
-	status.phy_stat = hw->phy_stat;
-	tmp = hw->count;
-	status.frame_count = (tmp >> 4);
-	status.rts_count = (tmp & 0x0F);
-	tmp = hw->flags;
-	status.supp_reason = ((tmp & 0x1C) >> 2);
-	status.pm_indicated = !!(tmp & 0x80);
-	status.intermediate = !!(tmp & 0x40);
-	status.for_ampdu = !!(tmp & 0x20);
-	status.acked = !!(tmp & 0x02);
+/* Fill out the mac80211 TXstatus report based on the b43-specific
+ * txstatus report data. This returns a boolean whether the frame was
+ * successfully transmitted. */
+bool b43_fill_txstatus_report(struct ieee80211_tx_status *report,
+			      const struct b43_txstatus *status)
+{
+	bool frame_success = 1;
 
-	b43_handle_txstatus(dev, &status);
+	if (status->acked) {
+		/* The frame was ACKed. */
+		report->flags |= IEEE80211_TX_STATUS_ACK;
+	} else {
+		/* The frame was not ACKed... */
+		if (!(report->control.flags & IEEE80211_TXCTL_NO_ACK)) {
+			/* ...but we expected an ACK. */
+			frame_success = 0;
+			report->excessive_retries = 1;
+		}
+	}
+	if (status->frame_count == 0) {
+		/* The frame was not transmitted at all. */
+		report->retry_count = 0;
+	} else
+		report->retry_count = status->frame_count - 1;
+
+	return frame_success;
 }
 
 /* Stop any TX operation on the device (suspend the hardware queues) */
 void b43_tx_suspend(struct b43_wldev *dev)
 {
-	b43_dma_tx_suspend(dev);
+	if (b43_using_pio_transfers(dev))
+		b43_pio_tx_suspend(dev);
+	else
+		b43_dma_tx_suspend(dev);
 }
 
 /* Resume any TX operation on the device (resume the hardware queues) */
 void b43_tx_resume(struct b43_wldev *dev)
 {
-	b43_dma_tx_resume(dev);
+	if (b43_using_pio_transfers(dev))
+		b43_pio_tx_resume(dev);
+	else
+		b43_dma_tx_resume(dev);
 }
Index: wireless-testing/drivers/net/wireless/b43/xmit.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.h	2008-03-29 19:52:14.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/xmit.h	2008-03-29 19:52:35.000000000 +0100
@@ -204,24 +204,12 @@ enum {
 	B43_TXST_SUPP_CHAN,	/* Channel mismatch */
 	B43_TXST_SUPP_LIFE,	/* Lifetime expired */
 	B43_TXST_SUPP_UNDER,	/* Buffer underflow */
 	B43_TXST_SUPP_ABNACK,	/* Afterburner NACK */
 };
 
-/* Transmit Status as received through DMA/PIO on old chips */
-struct b43_hwtxstatus {
-	PAD_BYTES(4);
-	__le16 cookie;
-	u8 flags;
-	u8 count;
-	 PAD_BYTES(2);
-	__le16 seq;
-	u8 phy_stat;
-	 PAD_BYTES(1);
-} __attribute__ ((__packed__));
-
 /* Receive header for v4 firmware. */
 struct b43_rxhdr_fw4 {
 	__le16 frame_len;	/* Frame length */
 	 PAD_BYTES(2);
 	__le16 phy_status0;	/* PHY RX Status 0 */
 	__u8 jssi;		/* PHY RX Status 1: JSSI */
@@ -292,15 +280,14 @@ void b43_generate_plcp_hdr(struct b43_pl
 			   const u16 octets, const u8 bitrate);
 
 void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr);
 
 void b43_handle_txstatus(struct b43_wldev *dev,
 			 const struct b43_txstatus *status);
-
-void b43_handle_hwtxstatus(struct b43_wldev *dev,
-			   const struct b43_hwtxstatus *hw);
+bool b43_fill_txstatus_report(struct ieee80211_tx_status *report,
+			      const struct b43_txstatus *status);
 
 void b43_tx_suspend(struct b43_wldev *dev);
 void b43_tx_resume(struct b43_wldev *dev);
 
 
 /* Helper functions for converting the key-table index from "firmware-format"
