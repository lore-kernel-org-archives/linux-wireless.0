Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60845 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbZIKWtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 18:49:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: Add optional verbose runtime statistics
Date: Sat, 12 Sep 2009 00:48:03 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909120048.03982.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for verbose runtime statistics.
It defaults to off and must be enabled in debugfs, if desired.
The first measurement may be incorrect, because statistics are not cleared
after they got enabled through debugfs.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-09-12 00:31:32.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-09-12 00:31:44.000000000 +0200
@@ -817,6 +817,10 @@ struct b43_wldev {
 	/* Debugging stuff follows. */
 #ifdef CONFIG_B43_DEBUG
 	struct b43_dfsentry *dfsentry;
+	unsigned int irq_count;
+	unsigned int irq_bit_count[32];
+	unsigned int tx_count;
+	unsigned int rx_count;
 #endif
 };
 
Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2009-09-12 00:31:31.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2009-09-12 00:31:44.000000000 +0200
@@ -689,6 +689,7 @@ static void b43_add_dynamic_debug(struct
 	add_dyn_dbg("debug_lo", B43_DBG_LO, 0);
 	add_dyn_dbg("debug_firmware", B43_DBG_FIRMWARE, 0);
 	add_dyn_dbg("debug_keys", B43_DBG_KEYS, 0);
+	add_dyn_dbg("debug_verbose_stats", B43_DBG_VERBOSESTATS, 0);
 
 #undef add_dyn_dbg
 }
Index: wireless-testing/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2009-09-12 00:31:31.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2009-09-12 00:31:44.000000000 +0200
@@ -13,6 +13,7 @@ enum b43_dyndbg {		/* Dynamic debugging 
 	B43_DBG_LO,
 	B43_DBG_FIRMWARE,
 	B43_DBG_KEYS,
+	B43_DBG_VERBOSESTATS,
 	__B43_NR_DYNDBG,
 };
 
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-12 00:31:32.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-12 00:31:44.000000000 +0200
@@ -1830,6 +1830,16 @@ static void b43_do_interrupt_thread(stru
 
 	/* Re-enable interrupts on the device by restoring the current interrupt mask. */
 	b43_write32(dev, B43_MMIO_GEN_IRQ_MASK, dev->irq_mask);
+
+#if B43_DEBUG
+	if (b43_debug(dev, B43_DBG_VERBOSESTATS)) {
+		dev->irq_count++;
+		for (i = 0; i < ARRAY_SIZE(dev->irq_bit_count); i++) {
+			if (reason & (1 << i))
+				dev->irq_bit_count[i]++;
+		}
+	}
+#endif
 }
 
 /* Interrupt thread handler. Handles device interrupts in thread context. */
@@ -2893,6 +2903,27 @@ static void b43_periodic_every15sec(stru
 
 	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
 	wmb();
+
+#if B43_DEBUG
+	if (b43_debug(dev, B43_DBG_VERBOSESTATS)) {
+		unsigned int i;
+
+		b43dbg(dev->wl, "Stats: %7u IRQs/sec, %7u TX/sec, %7u RX/sec\n",
+		       dev->irq_count / 15,
+		       dev->tx_count / 15,
+		       dev->rx_count / 15);
+		dev->irq_count = 0;
+		dev->tx_count = 0;
+		dev->rx_count = 0;
+		for (i = 0; i < ARRAY_SIZE(dev->irq_bit_count); i++) {
+			if (dev->irq_bit_count[i]) {
+				b43dbg(dev->wl, "Stats: %7u IRQ-%02u/sec (0x%08X)\n",
+				       dev->irq_bit_count[i] / 15, i, (1 << i));
+				dev->irq_bit_count[i] = 0;
+			}
+		}
+	}
+#endif
 }
 
 static void do_periodic_work(struct b43_wldev *dev)
@@ -3092,6 +3123,9 @@ static void b43_tx_work(struct work_stru
 			dev_kfree_skb(skb); /* Drop it */
 	}
 
+#if B43_DEBUG
+	dev->tx_count++;
+#endif
 	mutex_unlock(&wl->mutex);
 }
 
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-09-12 00:31:31.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-09-12 00:31:44.000000000 +0200
@@ -692,6 +692,9 @@ void b43_rx(struct b43_wldev *dev, struc
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 	ieee80211_rx(dev->wl->hw, skb);
 
+#if B43_DEBUG
+	dev->rx_count++;
+#endif
 	return;
 drop:
 	b43dbg(dev->wl, "RX: Packet dropped\n");

-- 
Greetings, Michael.
