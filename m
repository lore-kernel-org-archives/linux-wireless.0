Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38072 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYCEUU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 15:20:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add QOS support
Date: Wed, 5 Mar 2008 21:18:49 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200803052118.50458.mb@bu3sch.de> (sfid-20080305_202035_120625_DDC485DD)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds QOS support to the b43 driver.
QOS can be disabled on driver level with a module parameter for debugging purposes.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.26


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-03-05 20:53:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-03-05 20:53:21.000000000 +0100
@@ -96,12 +96,14 @@
 #define B43_MMIO_TSF_CFP_START_HIGH	0x606
 #define B43_MMIO_TSF_0			0x632	/* core rev < 3 only */
 #define B43_MMIO_TSF_1			0x634	/* core rev < 3 only */
 #define B43_MMIO_TSF_2			0x636	/* core rev < 3 only */
 #define B43_MMIO_TSF_3			0x638	/* core rev < 3 only */
 #define B43_MMIO_RNG			0x65A
+#define B43_MMIO_IFSCTL			0x688 /* Interframe space control */
+#define  B43_MMIO_IFSCTL_USE_EDCF	0x0004
 #define B43_MMIO_POWERUP_DELAY		0x6A8
 
 /* SPROM boardflags_lo values */
 #define B43_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistance */
 #define B43_BFL_PACTRL			0x0002	/* GPIO 9 controlling the PA */
 #define B43_BFL_AIRLINEMODE		0x0004	/* implements GPIO 13 radio disable indication */
@@ -618,12 +620,41 @@ struct b43_key {
 	 * keyconf is a cookie. Don't derefenrence it outside of the set_key
 	 * path, because b43 doesn't own it. */
 	struct ieee80211_key_conf *keyconf;
 	u8 algorithm;
 };
 
+/* SHM offsets to the QOS data structures for the 4 different queues. */
+#define B43_QOS_PARAMS(queue)	(B43_SHM_SH_EDCFQ + \
+				 (B43_NR_QOSPARAMS * sizeof(u16) * (queue)))
+#define B43_QOS_BACKGROUND	B43_QOS_PARAMS(0)
+#define B43_QOS_BESTEFFORT	B43_QOS_PARAMS(1)
+#define B43_QOS_VIDEO		B43_QOS_PARAMS(2)
+#define B43_QOS_VOICE		B43_QOS_PARAMS(3)
+
+/* QOS parameter hardware data structure offsets. */
+#define B43_NR_QOSPARAMS	22
+enum {
+	B43_QOSPARAM_TXOP = 0,
+	B43_QOSPARAM_CWMIN,
+	B43_QOSPARAM_CWMAX,
+	B43_QOSPARAM_CWCUR,
+	B43_QOSPARAM_AIFS,
+	B43_QOSPARAM_BSLOTS,
+	B43_QOSPARAM_REGGAP,
+	B43_QOSPARAM_STATUS,
+};
+
+/* QOS parameters for a queue. */
+struct b43_qos_params {
+	/* The QOS parameters */
+	struct ieee80211_tx_queue_params p;
+	/* Does this need to get uploaded to hardware? */
+	bool need_hw_update;
+};
+
 struct b43_wldev;
 
 /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 struct b43_wl {
 	/* Pointer to the active wireless device on this chip */
 	struct b43_wldev *current_dev;
@@ -670,12 +701,18 @@ struct b43_wl {
 
 	/* The beacon we are currently using (AP or IBSS mode).
 	 * This beacon stuff is protected by the irq_lock. */
 	struct sk_buff *current_beacon;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
+
+	/* The current QOS parameters for the 4 queues.
+	 * This is protected by the irq_lock. */
+	struct b43_qos_params qos_params[4];
+	/* Workqueue for updating QOS parameters in hardware. */
+	struct work_struct qos_update_work;
 };
 
 /* In-memory representation of a cached microcode file. */
 struct b43_firmware_file {
 	const char *filename;
 	const struct firmware *data;
Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c	2008-03-05 20:53:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.c	2008-03-05 21:16:28.000000000 +0100
@@ -288,58 +288,12 @@ static inline int request_slot(struct b4
 
 	update_max_used_slots(ring, ring->used_slots);
 
 	return slot;
 }
 
-/* Mac80211-queue to b43-ring mapping */
-static struct b43_dmaring *priority_to_txring(struct b43_wldev *dev,
-					      int queue_priority)
-{
-	struct b43_dmaring *ring;
-
-/*FIXME: For now we always run on TX-ring-1 */
-	return dev->dma.tx_ring1;
-
-	/* 0 = highest priority */
-	switch (queue_priority) {
-	default:
-		B43_WARN_ON(1);
-		/* fallthrough */
-	case 0:
-		ring = dev->dma.tx_ring3;
-		break;
-	case 1:
-		ring = dev->dma.tx_ring2;
-		break;
-	case 2:
-		ring = dev->dma.tx_ring1;
-		break;
-	case 3:
-		ring = dev->dma.tx_ring0;
-		break;
-	}
-
-	return ring;
-}
-
-/* b43-ring to mac80211-queue mapping */
-static inline int txring_to_priority(struct b43_dmaring *ring)
-{
-	static const u8 idx_to_prio[] = { 3, 2, 1, 0, };
-	unsigned int index;
-
-/*FIXME: have only one queue, for now */
-	return 0;
-
-	index = ring->index;
-	if (B43_WARN_ON(index >= ARRAY_SIZE(idx_to_prio)))
-		index = 0;
-	return idx_to_prio[index];
-}
-
 static u16 b43_dmacontroller_base(enum b43_dmatype type, int controller_idx)
 {
 	static const u16 map64[] = {
 		B43_MMIO_DMA64_BASE0,
 		B43_MMIO_DMA64_BASE1,
 		B43_MMIO_DMA64_BASE2,
@@ -1269,12 +1223,43 @@ static inline int should_inject_overflow
 		}
 	}
 #endif /* CONFIG_B43_DEBUG */
 	return 0;
 }
 
+/* Static mapping of mac80211's queues (priorities) to b43 DMA rings. */
+static struct b43_dmaring * select_ring_by_priority(struct b43_wldev *dev,
+						    u8 queue_prio)
+{
+	struct b43_dmaring *ring;
+
+	if (b43_modparam_qos) {
+		/* 0 = highest priority */
+		switch (queue_prio) {
+		default:
+			B43_WARN_ON(1);
+			/* fallthrough */
+		case 0:
+			ring = dev->dma.tx_ring3; /* AC_VO */
+			break;
+		case 1:
+			ring = dev->dma.tx_ring2; /* AC_VI */
+			break;
+		case 2:
+			ring = dev->dma.tx_ring1; /* AC_BE */
+			break;
+		case 3:
+			ring = dev->dma.tx_ring0; /* AC_BK */
+			break;
+		}
+	} else
+		ring = dev->dma.tx_ring1;
+
+	return ring;
+}
+
 int b43_dma_tx(struct b43_wldev *dev,
 	       struct sk_buff *skb, struct ieee80211_tx_control *ctl)
 {
 	struct b43_dmaring *ring;
 	struct ieee80211_hdr *hdr;
 	int err = 0;
@@ -1291,13 +1276,13 @@ int b43_dma_tx(struct b43_wldev *dev,
 		ring = dev->dma.tx_ring4;
 		/* Set the more-data bit. Ucode will clear it on
 		 * the last frame for us. */
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	} else {
 		/* Decide by priority where to put this frame. */
-		ring = priority_to_txring(dev, ctl->queue);
+		ring = select_ring_by_priority(dev, ctl->queue);
 	}
 
 	spin_lock_irqsave(&ring->lock, flags);
 	B43_WARN_ON(!ring->tx);
 	if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
 		b43warn(dev->wl, "DMA queue overflow\n");
@@ -1306,12 +1291,17 @@ int b43_dma_tx(struct b43_wldev *dev,
 	}
 	/* Check if the queue was stopped in mac80211,
 	 * but we got called nevertheless.
 	 * That would be a mac80211 bug. */
 	B43_WARN_ON(ring->stopped);
 
+	/* Assign the queue number to the ring (if not already done before)
+	 * so TX status handling can use it. The queue to ring mapping is
+	 * static, so we don't need to store it per frame. */
+	ring->queue_prio = ctl->queue;
+
 	err = dma_tx_fragment(ring, skb, ctl);
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
 		dev_kfree_skb_any(skb);
 		err = 0;
@@ -1322,13 +1312,13 @@ int b43_dma_tx(struct b43_wldev *dev,
 		goto out_unlock;
 	}
 	ring->nr_tx_packets++;
 	if ((free_slots(ring) < SLOTS_PER_PACKET) ||
 	    should_inject_overflow(ring)) {
 		/* This TX ring is full. */
-		ieee80211_stop_queue(dev->wl->hw, txring_to_priority(ring));
+		ieee80211_stop_queue(dev->wl->hw, ctl->queue);
 		ring->stopped = 1;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
 		}
 	}
 out_unlock:
@@ -1401,13 +1391,13 @@ void b43_dma_handle_txstatus(struct b43_
 			break;
 		slot = next_slot(ring, slot);
 	}
 	dev->stats.last_tx = jiffies;
 	if (ring->stopped) {
 		B43_WARN_ON(free_slots(ring) < SLOTS_PER_PACKET);
-		ieee80211_wake_queue(dev->wl->hw, txring_to_priority(ring));
+		ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);
 		ring->stopped = 0;
 		if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
 			b43dbg(dev->wl, "Woke up TX ring %d\n", ring->index);
 		}
 	}
 
@@ -1422,13 +1412,13 @@ void b43_dma_get_tx_stats(struct b43_wld
 	struct ieee80211_tx_queue_stats_data *data;
 	unsigned long flags;
 	int i;
 
 	for (i = 0; i < nr_queues; i++) {
 		data = &(stats->data[i]);
-		ring = priority_to_txring(dev, i);
+		ring = select_ring_by_priority(dev, i);
 
 		spin_lock_irqsave(&ring->lock, flags);
 		data->len = ring->used_slots / SLOTS_PER_PACKET;
 		data->limit = ring->nr_slots / SLOTS_PER_PACKET;
 		data->count = ring->nr_tx_packets;
 		spin_unlock_irqrestore(&ring->lock, flags);
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-03-05 20:53:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-03-05 20:53:21.000000000 +0100
@@ -75,12 +75,17 @@ module_param_named(hwpctl, modparam_hwpc
 MODULE_PARM_DESC(hwpctl, "Enable hardware-side power control (default off)");
 
 static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
+int b43_modparam_qos = 1;
+module_param_named(qos, b43_modparam_qos, int, 0444);
+MODULE_PARM_DESC(qos, "Enable QOS support (default on)");
+
+
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
@@ -2705,16 +2710,184 @@ static int b43_op_tx(struct ieee80211_hw
 out:
 	if (unlikely(err))
 		return NETDEV_TX_BUSY;
 	return NETDEV_TX_OK;
 }
 
+/* Locking: wl->irq_lock */
+static void b43_qos_params_upload(struct b43_wldev *dev,
+				  const struct ieee80211_tx_queue_params *p,
+				  u16 shm_offset)
+{
+	u16 params[B43_NR_QOSPARAMS];
+	int cw_min, cw_max, aifs, bslots, tmp;
+	unsigned int i;
+
+	const u16 aCWmin = 0x0001;
+	const u16 aCWmax = 0x03FF;
+
+	/* Calculate the default values for the parameters, if needed. */
+	switch (shm_offset) {
+	case B43_QOS_VOICE:
+		aifs = (p->aifs == -1) ? 2 : p->aifs;
+		cw_min = (p->cw_min == 0) ? ((aCWmin + 1) / 4 - 1) : p->cw_min;
+		cw_max = (p->cw_max == 0) ? ((aCWmin + 1) / 2 - 1) : p->cw_max;
+		break;
+	case B43_QOS_VIDEO:
+		aifs = (p->aifs == -1) ? 2 : p->aifs;
+		cw_min = (p->cw_min == 0) ? ((aCWmin + 1) / 2 - 1) : p->cw_min;
+		cw_max = (p->cw_max == 0) ? aCWmin : p->cw_max;
+		break;
+	case B43_QOS_BESTEFFORT:
+		aifs = (p->aifs == -1) ? 3 : p->aifs;
+		cw_min = (p->cw_min == 0) ? aCWmin : p->cw_min;
+		cw_max = (p->cw_max == 0) ? aCWmax : p->cw_max;
+		break;
+	case B43_QOS_BACKGROUND:
+		aifs = (p->aifs == -1) ? 7 : p->aifs;
+		cw_min = (p->cw_min == 0) ? aCWmin : p->cw_min;
+		cw_max = (p->cw_max == 0) ? aCWmax : p->cw_max;
+		break;
+	default:
+		B43_WARN_ON(1);
+		return;
+	}
+	if (cw_min <= 0)
+		cw_min = aCWmin;
+	if (cw_max <= 0)
+		cw_max = aCWmin;
+	bslots = b43_read16(dev, B43_MMIO_RNG) % cw_min;
+
+	memset(&params, 0, sizeof(params));
+
+	params[B43_QOSPARAM_TXOP] = p->txop * 32;
+	params[B43_QOSPARAM_CWMIN] = cw_min;
+	params[B43_QOSPARAM_CWMAX] = cw_max;
+	params[B43_QOSPARAM_CWCUR] = cw_min;
+	params[B43_QOSPARAM_AIFS] = aifs;
+	params[B43_QOSPARAM_BSLOTS] = bslots;
+	params[B43_QOSPARAM_REGGAP] = bslots + aifs;
+
+	for (i = 0; i < ARRAY_SIZE(params); i++) {
+		if (i == B43_QOSPARAM_STATUS) {
+			tmp = b43_shm_read16(dev, B43_SHM_SHARED,
+					     shm_offset + (i * 2));
+			/* Mark the parameters as updated. */
+			tmp |= 0x100;
+			b43_shm_write16(dev, B43_SHM_SHARED,
+					shm_offset + (i * 2),
+					tmp);
+		} else {
+			b43_shm_write16(dev, B43_SHM_SHARED,
+					shm_offset + (i * 2),
+					params[i]);
+		}
+	}
+}
+
+/* Update the QOS parameters in hardware. */
+static void b43_qos_update(struct b43_wldev *dev)
+{
+	struct b43_wl *wl = dev->wl;
+	struct b43_qos_params *params;
+	unsigned long flags;
+	unsigned int i;
+
+	/* Mapping of mac80211 queues to b43 SHM offsets. */
+	static const u16 qos_shm_offsets[] = {
+		[0] = B43_QOS_VOICE,
+		[1] = B43_QOS_VIDEO,
+		[2] = B43_QOS_BESTEFFORT,
+		[3] = B43_QOS_BACKGROUND,
+	};
+	BUILD_BUG_ON(ARRAY_SIZE(qos_shm_offsets) != ARRAY_SIZE(wl->qos_params));
+
+	b43_mac_suspend(dev);
+	spin_lock_irqsave(&wl->irq_lock, flags);
+
+	for (i = 0; i < ARRAY_SIZE(wl->qos_params); i++) {
+		params = &(wl->qos_params[i]);
+		if (params->need_hw_update) {
+			b43_qos_params_upload(dev, &(params->p),
+					      qos_shm_offsets[i]);
+			params->need_hw_update = 0;
+		}
+	}
+
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	b43_mac_enable(dev);
+}
+
+static void b43_qos_clear(struct b43_wl *wl)
+{
+	struct b43_qos_params *params;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(wl->qos_params); i++) {
+		params = &(wl->qos_params[i]);
+
+		memset(&(params->p), 0, sizeof(params->p));
+		params->p.aifs = -1;
+		params->need_hw_update = 1;
+	}
+}
+
+/* Initialize the core's QOS capabilities */
+static void b43_qos_init(struct b43_wldev *dev)
+{
+	struct b43_wl *wl = dev->wl;
+	unsigned int i;
+
+	/* Upload the current QOS parameters. */
+	for (i = 0; i < ARRAY_SIZE(wl->qos_params); i++)
+		wl->qos_params[i].need_hw_update = 1;
+	b43_qos_update(dev);
+
+	/* Enable QOS support. */
+	b43_hf_write(dev, b43_hf_read(dev) | B43_HF_EDCF);
+	b43_write16(dev, B43_MMIO_IFSCTL,
+		    b43_read16(dev, B43_MMIO_IFSCTL)
+		    | B43_MMIO_IFSCTL_USE_EDCF);
+}
+
+static void b43_qos_update_work(struct work_struct *work)
+{
+	struct b43_wl *wl = container_of(work, struct b43_wl, qos_update_work);
+	struct b43_wldev *dev;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (likely(dev && (b43_status(dev) >= B43_STAT_INITIALIZED)))
+		b43_qos_update(dev);
+	mutex_unlock(&wl->mutex);
+}
+
 static int b43_op_conf_tx(struct ieee80211_hw *hw,
-			  int queue,
+			  int _queue,
 			  const struct ieee80211_tx_queue_params *params)
 {
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	unsigned long flags;
+	unsigned int queue = (unsigned int)_queue;
+	struct b43_qos_params *p;
+
+	if (queue >= ARRAY_SIZE(wl->qos_params)) {
+		/* Queue not available or don't support setting
+		 * params on this queue. Return success to not
+		 * confuse mac80211. */
+		return 0;
+	}
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	p = &(wl->qos_params[queue]);
+	memcpy(&(p->p), params, sizeof(p->p));
+	p->need_hw_update = 1;
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+	queue_work(hw->workqueue, &wl->qos_update_work);
+
 	return 0;
 }
 
 static int b43_op_get_tx_stats(struct ieee80211_hw *hw,
 			       struct ieee80211_tx_queue_stats *stats)
 {
@@ -3729,12 +3902,13 @@ static int b43_op_start(struct ieee80211
 	 * the card won't use it in the short timeframe between start
 	 * and mac80211 reconfiguring it. */
 	memset(wl->bssid, 0, ETH_ALEN);
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	wl->filter_flags = 0;
 	wl->radiotap_enabled = 0;
+	b43_qos_clear(wl);
 
 	/* First register RFkill.
 	 * LEDs that are registered later depend on it. */
 	b43_rfkill_init(dev);
 
 	mutex_lock(&wl->mutex);
@@ -3770,12 +3944,13 @@ static int b43_op_start(struct ieee80211
 static void b43_op_stop(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 
 	b43_rfkill_exit(dev);
+	cancel_work_sync(&(wl->qos_update_work));
 
 	mutex_lock(&wl->mutex);
 	if (b43_status(dev) >= B43_STAT_STARTED)
 		b43_wireless_core_stop(dev);
 	b43_wireless_core_exit(dev);
 	mutex_unlock(&wl->mutex);
@@ -4130,13 +4305,13 @@ static int b43_wireless_init(struct ssb_
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 		    IEEE80211_HW_RX_INCLUDES_FCS;
 	hw->max_signal = 100;
 	hw->max_rssi = -110;
 	hw->max_noise = -110;
-	hw->queues = 1;		/* FIXME: hardware has more queues */
+	hw->queues = b43_modparam_qos ? 4 : 1;
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
 		SET_IEEE80211_PERM_ADDR(hw, sprom->et1mac);
 	else
 		SET_IEEE80211_PERM_ADDR(hw, sprom->il0mac);
 
@@ -4146,12 +4321,13 @@ static int b43_wireless_init(struct ssb_
 	wl->hw = hw;
 	spin_lock_init(&wl->irq_lock);
 	spin_lock_init(&wl->leds_lock);
 	spin_lock_init(&wl->shm_lock);
 	mutex_init(&wl->mutex);
 	INIT_LIST_HEAD(&wl->devlist);
+	INIT_WORK(&wl->qos_update_work, b43_qos_update_work);
 
 	ssb_set_devtypedata(dev, wl);
 	b43info(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
 	err = 0;
       out:
 	return err;
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2008-03-05 20:53:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2008-03-05 20:53:21.000000000 +0100
@@ -702,33 +702,6 @@ void b43_tx_suspend(struct b43_wldev *de
 
 /* Resume any TX operation on the device (resume the hardware queues) */
 void b43_tx_resume(struct b43_wldev *dev)
 {
 	b43_dma_tx_resume(dev);
 }
-
-#if 0
-static void upload_qos_parms(struct b43_wldev *dev,
-			     const u16 * parms, u16 offset)
-{
-	int i;
-
-	for (i = 0; i < B43_NR_QOSPARMS; i++) {
-		b43_shm_write16(dev, B43_SHM_SHARED,
-				offset + (i * 2), parms[i]);
-	}
-}
-#endif
-
-/* Initialize the QoS parameters */
-void b43_qos_init(struct b43_wldev *dev)
-{
-	/* FIXME: This function must probably be called from the mac80211
-	 * config callback. */
-	return;
-
-	b43_hf_write(dev, b43_hf_read(dev) | B43_HF_EDCF);
-	//FIXME kill magic
-	b43_write16(dev, 0x688, b43_read16(dev, 0x688) | 0x4);
-
-	/*TODO: We might need some stack support here to get the values. */
-}
Index: wireless-testing/drivers/net/wireless/b43/xmit.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.h	2008-03-05 20:53:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/xmit.h	2008-03-05 20:53:21.000000000 +0100
@@ -299,24 +299,12 @@ void b43_handle_txstatus(struct b43_wlde
 void b43_handle_hwtxstatus(struct b43_wldev *dev,
 			   const struct b43_hwtxstatus *hw);
 
 void b43_tx_suspend(struct b43_wldev *dev);
 void b43_tx_resume(struct b43_wldev *dev);
 
-#define B43_NR_QOSPARMS		22
-enum {
-	B43_QOSPARM_TXOP = 0,
-	B43_QOSPARM_CWMIN,
-	B43_QOSPARM_CWMAX,
-	B43_QOSPARM_CWCUR,
-	B43_QOSPARM_AIFS,
-	B43_QOSPARM_BSLOTS,
-	B43_QOSPARM_REGGAP,
-	B43_QOSPARM_STATUS,
-};
-void b43_qos_init(struct b43_wldev *dev);
 
 /* Helper functions for converting the key-table index from "firmware-format"
  * to "raw-format" and back. The firmware API changed for this at some revision.
  * We need to account for that here. */
 static inline int b43_new_kidx_api(struct b43_wldev *dev)
 {
Index: wireless-testing/drivers/net/wireless/b43/dma.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.h	2008-03-05 20:53:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/dma.h	2008-03-05 20:53:21.000000000 +0100
@@ -242,12 +242,15 @@ struct b43_dmaring {
 	/* Boolean. Is this a TX ring? */
 	bool tx;
 	/* The type of DMA engine used. */
 	enum b43_dmatype type;
 	/* Boolean. Is this ring stopped at ieee80211 level? */
 	bool stopped;
+	/* The QOS priority assigned to this ring. Only used for TX rings.
+	 * This is the mac80211 "queue" value. */
+	u8 queue_prio;
 	/* Lock, only used for TX. */
 	spinlock_t lock;
 	struct b43_wldev *dev;
 #ifdef CONFIG_B43_DEBUG
 	/* Maximum number of used slots. */
 	int max_used_slots;
Index: wireless-testing/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.h	2008-03-05 20:53:06.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.h	2008-03-05 20:53:21.000000000 +0100
@@ -35,12 +35,16 @@
 
 #define P4D_BYT3S(magic, nr_bytes)	u8 __p4dding##magic[nr_bytes]
 #define P4D_BYTES(line, nr_bytes)	P4D_BYT3S(line, nr_bytes)
 /* Magic helper macro to pad structures. Ignore those above. It's magic. */
 #define PAD_BYTES(nr_bytes)		P4D_BYTES( __LINE__ , (nr_bytes))
 
+
+extern int b43_modparam_qos;
+
+
 /* Lightweight function to convert a frequency (in Mhz) to a channel number. */
 static inline u8 b43_freq_to_channel_5ghz(int freq)
 {
 	return ((freq - 5000) / 5);
 }
 static inline u8 b43_freq_to_channel_2ghz(int freq)
