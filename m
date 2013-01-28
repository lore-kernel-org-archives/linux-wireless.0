Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55390 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab3A1Qik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:40 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/14] wil6210: fix checkpatch CamelCase warnings
Date: Mon, 28 Jan 2013 18:31:06 +0200
Message-ID: <1359390669-9310-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173848_271973_7795B9D5)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c  |    4 +-
 drivers/net/wireless/ath/wil6210/interrupt.c |   32 +++++++--------
 drivers/net/wireless/ath/wil6210/main.c      |   26 ++++++------
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |    4 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |   30 +++++++-------
 drivers/net/wireless/ath/wil6210/wil6210.h   |   12 +++---
 drivers/net/wireless/ath/wil6210/wmi.c       |   56 +++++++++++++-------------
 7 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 56f39b6..4b48f2e 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -228,7 +228,7 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 		}
 		/* 0-based channel indexes */
 		cmd.cmd.channel_list[cmd.cmd.num_channels++].channel = ch - 1;
-		wil_dbg_MISC(wil, "Scan for ch %d  : %d MHz\n", ch,
+		wil_dbg_misc(wil, "Scan for ch %d  : %d MHz\n", ch,
 			     request->channels[i]->center_freq);
 	}
 
@@ -425,7 +425,7 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	wil_dbg_MISC(wil, "AP on Channel %d %d MHz, %s\n", channel->hw_value,
+	wil_dbg_misc(wil, "AP on Channel %d %d MHz, %s\n", channel->hw_value,
 		     channel->center_freq, info->privacy ? "secure" : "open");
 	print_hex_dump_bytes("SSID ", DUMP_PREFIX_OFFSET,
 			     info->ssid, info->ssid_len);
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 660bacf..865c33f 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -96,7 +96,7 @@ static void wil6210_mask_irq_misc(struct wil6210_priv *wil)
 
 static void wil6210_mask_irq_pseudo(struct wil6210_priv *wil)
 {
-	wil_dbg_IRQ(wil, "%s()\n", __func__);
+	wil_dbg_irq(wil, "%s()\n", __func__);
 
 	iowrite32(WIL6210_IRQ_DISABLE, wil->csr +
 		  HOSTADDR(RGF_DMA_PSEUDO_CAUSE_MASK_SW));
@@ -127,7 +127,7 @@ static void wil6210_unmask_irq_misc(struct wil6210_priv *wil)
 
 static void wil6210_unmask_irq_pseudo(struct wil6210_priv *wil)
 {
-	wil_dbg_IRQ(wil, "%s()\n", __func__);
+	wil_dbg_irq(wil, "%s()\n", __func__);
 
 	set_bit(wil_status_irqen, &wil->status);
 
@@ -137,7 +137,7 @@ static void wil6210_unmask_irq_pseudo(struct wil6210_priv *wil)
 
 void wil6210_disable_irq(struct wil6210_priv *wil)
 {
-	wil_dbg_IRQ(wil, "%s()\n", __func__);
+	wil_dbg_irq(wil, "%s()\n", __func__);
 
 	wil6210_mask_irq_tx(wil);
 	wil6210_mask_irq_rx(wil);
@@ -147,7 +147,7 @@ void wil6210_disable_irq(struct wil6210_priv *wil)
 
 void wil6210_enable_irq(struct wil6210_priv *wil)
 {
-	wil_dbg_IRQ(wil, "%s()\n", __func__);
+	wil_dbg_irq(wil, "%s()\n", __func__);
 
 	iowrite32(WIL_ICR_ICC_VALUE, wil->csr + HOSTADDR(RGF_DMA_EP_RX_ICR) +
 		  offsetof(struct RGF_ICR, ICC));
@@ -169,7 +169,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 					 HOSTADDR(RGF_DMA_EP_RX_ICR) +
 					 offsetof(struct RGF_ICR, ICR));
 
-	wil_dbg_IRQ(wil, "ISR RX 0x%08x\n", isr);
+	wil_dbg_irq(wil, "ISR RX 0x%08x\n", isr);
 
 	if (!isr) {
 		wil_err(wil, "spurious IRQ: RX\n");
@@ -179,7 +179,7 @@ static irqreturn_t wil6210_irq_rx(int irq, void *cookie)
 	wil6210_mask_irq_rx(wil);
 
 	if (isr & BIT_DMA_EP_RX_ICR_RX_DONE) {
-		wil_dbg_IRQ(wil, "RX done\n");
+		wil_dbg_irq(wil, "RX done\n");
 		isr &= ~BIT_DMA_EP_RX_ICR_RX_DONE;
 		wil_rx_handle(wil);
 	}
@@ -199,7 +199,7 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 					 HOSTADDR(RGF_DMA_EP_TX_ICR) +
 					 offsetof(struct RGF_ICR, ICR));
 
-	wil_dbg_IRQ(wil, "ISR TX 0x%08x\n", isr);
+	wil_dbg_irq(wil, "ISR TX 0x%08x\n", isr);
 
 	if (!isr) {
 		wil_err(wil, "spurious IRQ: TX\n");
@@ -210,13 +210,13 @@ static irqreturn_t wil6210_irq_tx(int irq, void *cookie)
 
 	if (isr & BIT_DMA_EP_TX_ICR_TX_DONE) {
 		uint i;
-		wil_dbg_IRQ(wil, "TX done\n");
+		wil_dbg_irq(wil, "TX done\n");
 		isr &= ~BIT_DMA_EP_TX_ICR_TX_DONE;
 		for (i = 0; i < 24; i++) {
 			u32 mask = BIT_DMA_EP_TX_ICR_TX_DONE_N(i);
 			if (isr & mask) {
 				isr &= ~mask;
-				wil_dbg_IRQ(wil, "TX done(%i)\n", i);
+				wil_dbg_irq(wil, "TX done(%i)\n", i);
 				wil_tx_complete(wil, i);
 			}
 		}
@@ -248,7 +248,7 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 					 HOSTADDR(RGF_DMA_EP_MISC_ICR) +
 					 offsetof(struct RGF_ICR, ICR));
 
-	wil_dbg_IRQ(wil, "ISR MISC 0x%08x\n", isr);
+	wil_dbg_irq(wil, "ISR MISC 0x%08x\n", isr);
 
 	if (!isr) {
 		wil_err(wil, "spurious IRQ: MISC\n");
@@ -258,14 +258,14 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	wil6210_mask_irq_misc(wil);
 
 	if (isr & ISR_MISC_FW_ERROR) {
-		wil_dbg_IRQ(wil, "IRQ: Firmware error\n");
+		wil_dbg_irq(wil, "IRQ: Firmware error\n");
 		clear_bit(wil_status_fwready, &wil->status);
 		wil_notify_fw_error(wil);
 		isr &= ~ISR_MISC_FW_ERROR;
 	}
 
 	if (isr & ISR_MISC_FW_READY) {
-		wil_dbg_IRQ(wil, "IRQ: FW ready\n");
+		wil_dbg_irq(wil, "IRQ: FW ready\n");
 		/**
 		 * Actual FW ready indicated by the
 		 * WMI_FW_READY_EVENTID
@@ -288,10 +288,10 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 	struct wil6210_priv *wil = cookie;
 	u32 isr = wil->isr_misc;
 
-	wil_dbg_IRQ(wil, "Thread ISR MISC 0x%08x\n", isr);
+	wil_dbg_irq(wil, "Thread ISR MISC 0x%08x\n", isr);
 
 	if (isr & ISR_MISC_MBOX_EVT) {
-		wil_dbg_IRQ(wil, "MBOX event\n");
+		wil_dbg_irq(wil, "MBOX event\n");
 		wmi_recv_cmd(wil);
 		isr &= ~ISR_MISC_MBOX_EVT;
 	}
@@ -313,7 +313,7 @@ static irqreturn_t wil6210_thread_irq(int irq, void *cookie)
 {
 	struct wil6210_priv *wil = cookie;
 
-	wil_dbg_IRQ(wil, "Thread IRQ\n");
+	wil_dbg_irq(wil, "Thread IRQ\n");
 	/* Discover real IRQ cause */
 	if (wil->isr_misc)
 		wil6210_irq_misc_thread(irq, cookie);
@@ -390,7 +390,7 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 	if (wil6210_debug_irq_mask(wil, pseudo_cause))
 		return IRQ_NONE;
 
-	wil_dbg_IRQ(wil, "Pseudo IRQ 0x%08x\n", pseudo_cause);
+	wil_dbg_irq(wil, "Pseudo IRQ 0x%08x\n", pseudo_cause);
 
 	wil6210_mask_irq_pseudo(wil);
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index aa598f3..d160ea8 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -64,7 +64,7 @@ static void _wil6210_disconnect(struct wil6210_priv *wil, void *bssid)
 	struct net_device *ndev = wil_to_ndev(wil);
 	struct wireless_dev *wdev = wil->wdev;
 
-	wil_dbg_MISC(wil, "%s()\n", __func__);
+	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	wil_link_off(wil);
 	clear_bit(wil_status_fwconnected, &wil->status);
@@ -101,7 +101,7 @@ static void wil_connect_timer_fn(ulong x)
 {
 	struct wil6210_priv *wil = (void *)x;
 
-	wil_dbg_MISC(wil, "Connect timeout\n");
+	wil_dbg_misc(wil, "Connect timeout\n");
 
 	/* reschedule to thread context - disconnect won't
 	 * run from atomic context
@@ -120,7 +120,7 @@ static void wil_cache_mbox_regs(struct wil6210_priv *wil)
 
 int wil_priv_init(struct wil6210_priv *wil)
 {
-	wil_dbg_MISC(wil, "%s()\n", __func__);
+	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	mutex_init(&wil->mutex);
 	mutex_init(&wil->wmi_mutex);
@@ -169,7 +169,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 
 static void wil_target_reset(struct wil6210_priv *wil)
 {
-	wil_dbg_MISC(wil, "Resetting...\n");
+	wil_dbg_misc(wil, "Resetting...\n");
 
 	/* register write */
 #define W(a, v) iowrite32(v, wil->csr + HOSTADDR(a))
@@ -209,7 +209,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 
 	msleep(2000);
 
-	wil_dbg_MISC(wil, "Reset completed\n");
+	wil_dbg_misc(wil, "Reset completed\n");
 
 #undef W
 #undef S
@@ -232,7 +232,7 @@ static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 		wil_err(wil, "Firmware not ready\n");
 		return -ETIME;
 	} else {
-		wil_dbg_MISC(wil, "FW ready after %d ms\n",
+		wil_dbg_misc(wil, "FW ready after %d ms\n",
 			     jiffies_to_msecs(to-left));
 	}
 	return 0;
@@ -281,7 +281,7 @@ void wil_link_on(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 
-	wil_dbg_MISC(wil, "%s()\n", __func__);
+	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	netif_carrier_on(ndev);
 	netif_tx_wake_all_queues(ndev);
@@ -291,7 +291,7 @@ void wil_link_off(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
 
-	wil_dbg_MISC(wil, "%s()\n", __func__);
+	wil_dbg_misc(wil, "%s()\n", __func__);
 
 	netif_tx_stop_all_queues(ndev);
 	netif_carrier_off(ndev);
@@ -314,27 +314,27 @@ static int __wil_up(struct wil6210_priv *wil)
 	wmi_nettype = wil_iftype_nl2wmi(NL80211_IFTYPE_ADHOC);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
-		wil_dbg_MISC(wil, "type: STATION\n");
+		wil_dbg_misc(wil, "type: STATION\n");
 		bi = 0;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_AP:
-		wil_dbg_MISC(wil, "type: AP\n");
+		wil_dbg_misc(wil, "type: AP\n");
 		bi = 100;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
-		wil_dbg_MISC(wil, "type: P2P_CLIENT\n");
+		wil_dbg_misc(wil, "type: P2P_CLIENT\n");
 		bi = 0;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_P2P_GO:
-		wil_dbg_MISC(wil, "type: P2P_GO\n");
+		wil_dbg_misc(wil, "type: P2P_GO\n");
 		bi = 100;
 		ndev->type = ARPHRD_ETHER;
 		break;
 	case NL80211_IFTYPE_MONITOR:
-		wil_dbg_MISC(wil, "type: Monitor\n");
+		wil_dbg_misc(wil, "type: Monitor\n");
 		bi = 0;
 		ndev->type = ARPHRD_IEEE80211_RADIOTAP;
 		/* ARPHRD_IEEE80211 or ARPHRD_IEEE80211_RADIOTAP ? */
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index ab1cade..81c35c6 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -53,7 +53,7 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	}
 	wil->n_msi = use_msi;
 	if (wil->n_msi) {
-		wil_dbg_MISC(wil, "Setup %d MSI interrupts\n", use_msi);
+		wil_dbg_misc(wil, "Setup %d MSI interrupts\n", use_msi);
 		rc = pci_enable_msi_block(pdev, wil->n_msi);
 		if (rc && (wil->n_msi == 3)) {
 			wil_err(wil, "3 MSI mode failed, try 1 MSI\n");
@@ -65,7 +65,7 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 			wil->n_msi = 0;
 		}
 	} else {
-		wil_dbg_MISC(wil, "MSI interrupts disabled, use INTx\n");
+		wil_dbg_misc(wil, "MSI interrupts disabled, use INTx\n");
 	}
 
 	rc = wil6210_init_irq(wil, pdev->irq);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 649f504..f0d0913 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -100,7 +100,7 @@ static int wil_vring_alloc(struct wil6210_priv *wil, struct vring *vring)
 		d->dma.status = TX_DMA_STATUS_DU;
 	}
 
-	wil_dbg_MISC(wil, "vring[%d] 0x%p:0x%016llx 0x%p\n", vring->size,
+	wil_dbg_misc(wil, "vring[%d] 0x%p:0x%016llx 0x%p\n", vring->size,
 		     vring->va, (unsigned long long)vring->pa, vring->ctx);
 
 	return 0;
@@ -353,8 +353,8 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
 		wil_rx_add_radiotap_header(wil, skb, d);
 
-	wil_dbg_TXRX(wil, "Rx[%3d] : %d bytes\n", vring->swhead, d->dma.length);
-	wil_hex_dump_TXRX("Rx ", DUMP_PREFIX_NONE, 32, 4,
+	wil_dbg_txrx(wil, "Rx[%3d] : %d bytes\n", vring->swhead, d->dma.length);
+	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
 	wil_vring_advance_head(vring, 1);
@@ -369,7 +369,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	 */
 	ftype = wil_rxdesc_ftype(d) << 2;
 	if (ftype != IEEE80211_FTYPE_DATA) {
-		wil_dbg_TXRX(wil, "Non-data frame ftype 0x%08x\n", ftype);
+		wil_dbg_txrx(wil, "Non-data frame ftype 0x%08x\n", ftype);
 		/* TODO: process it */
 		kfree_skb(skb);
 		return NULL;
@@ -461,9 +461,9 @@ void wil_rx_handle(struct wil6210_priv *wil)
 		wil_err(wil, "Rx IRQ while Rx not yet initialized\n");
 		return;
 	}
-	wil_dbg_TXRX(wil, "%s()\n", __func__);
+	wil_dbg_txrx(wil, "%s()\n", __func__);
 	while (NULL != (skb = wil_vring_reap_rx(wil, v))) {
-		wil_hex_dump_TXRX("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
+		wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
 				  skb->data, skb_headlen(skb), false);
 
 		if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
@@ -639,7 +639,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	uint i = swhead;
 	dma_addr_t pa;
 
-	wil_dbg_TXRX(wil, "%s()\n", __func__);
+	wil_dbg_txrx(wil, "%s()\n", __func__);
 
 	if (avail < vring->size/8)
 		netif_tx_stop_all_queues(wil_to_ndev(wil));
@@ -656,9 +656,9 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	pa = dma_map_single(dev, skb->data,
 			skb_headlen(skb), DMA_TO_DEVICE);
 
-	wil_dbg_TXRX(wil, "Tx skb %d bytes %p -> %#08llx\n", skb_headlen(skb),
+	wil_dbg_txrx(wil, "Tx skb %d bytes %p -> %#08llx\n", skb_headlen(skb),
 		     skb->data, (unsigned long long)pa);
-	wil_hex_dump_TXRX("Tx ", DUMP_PREFIX_OFFSET, 16, 1,
+	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_OFFSET, 16, 1,
 			  skb->data, skb_headlen(skb), false);
 
 	if (unlikely(dma_mapping_error(dev, pa)))
@@ -687,12 +687,12 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
 	d->dma.d0 |= (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
 
-	wil_hex_dump_TXRX("Tx ", DUMP_PREFIX_NONE, 32, 4,
+	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
 	/* advance swhead */
 	wil_vring_advance_head(vring, nr_frags + 1);
-	wil_dbg_TXRX(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
+	wil_dbg_txrx(wil, "Tx swhead %d -> %d\n", swhead, vring->swhead);
 	iowrite32(vring->swhead, wil->csr + HOSTADDR(vring->hwtail));
 	/* hold reference to skb
 	 * to prevent skb release before accounting
@@ -725,7 +725,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct vring *vring;
 	int rc;
 
-	wil_dbg_TXRX(wil, "%s()\n", __func__);
+	wil_dbg_txrx(wil, "%s()\n", __func__);
 	if (!test_bit(wil_status_fwready, &wil->status)) {
 		wil_err(wil, "FW not ready\n");
 		goto drop;
@@ -785,7 +785,7 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		return;
 	}
 
-	wil_dbg_TXRX(wil, "%s(%d)\n", __func__, ringid);
+	wil_dbg_txrx(wil, "%s(%d)\n", __func__, ringid);
 
 	while (!wil_vring_is_empty(vring)) {
 		volatile struct vring_tx_desc *d = &vring->va[vring->swtail].tx;
@@ -794,11 +794,11 @@ void wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		if (!(d->dma.status & TX_DMA_STATUS_DU))
 			break;
 
-		wil_dbg_TXRX(wil,
+		wil_dbg_txrx(wil,
 			     "Tx[%3d] : %d bytes, status 0x%02x err 0x%02x\n",
 			     vring->swtail, d->dma.length, d->dma.status,
 			     d->dma.error);
-		wil_hex_dump_TXRX("TxC ", DUMP_PREFIX_NONE, 32, 4,
+		wil_hex_dump_txrx("TxC ", DUMP_PREFIX_NONE, 32, 4,
 				  (const void *)d, sizeof(*d), false);
 
 		pa = d->dma.addr_low | ((u64)d->dma.addr_high << 32);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index d957286..69e5162 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -270,18 +270,18 @@ struct wil6210_priv {
 #define wil_info(wil, fmt, arg...) netdev_info(wil_to_ndev(wil), fmt, ##arg)
 #define wil_err(wil, fmt, arg...) netdev_err(wil_to_ndev(wil), fmt, ##arg)
 
-#define wil_dbg_IRQ(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
-#define wil_dbg_TXRX(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
-#define wil_dbg_WMI(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
-#define wil_dbg_MISC(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
+#define wil_dbg_irq(wil, fmt, arg...) wil_dbg(wil, "DBG[ IRQ]" fmt, ##arg)
+#define wil_dbg_txrx(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
+#define wil_dbg_wmi(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
+#define wil_dbg_misc(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
 
-#define wil_hex_dump_TXRX(prefix_str, prefix_type, rowsize,	\
+#define wil_hex_dump_txrx(prefix_str, prefix_type, rowsize,	\
 			  groupsize, buf, len, ascii)		\
 			  wil_print_hex_dump_debug("DBG[TXRX]" prefix_str,\
 					 prefix_type, rowsize,	\
 					 groupsize, buf, len, ascii)
 
-#define wil_hex_dump_WMI(prefix_str, prefix_type, rowsize,	\
+#define wil_hex_dump_wmi(prefix_str, prefix_type, rowsize,	\
 			 groupsize, buf, len, ascii)		\
 			 wil_print_hex_dump_debug("DBG[ WMI]" prefix_str,\
 					prefix_type, rowsize,	\
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index dffb002..91f41a7 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -215,7 +215,7 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	}
 	/* next head */
 	next_head = r->base + ((r->head - r->base + sizeof(d_head)) % r->size);
-	wil_dbg_WMI(wil, "Head 0x%08x -> 0x%08x\n", r->head, next_head);
+	wil_dbg_wmi(wil, "Head 0x%08x -> 0x%08x\n", r->head, next_head);
 	/* wait till FW finish with previous command */
 	for (retry = 5; retry > 0; retry--) {
 		r->tail = ioread32(wil->csr + HOST_MBOX +
@@ -236,10 +236,10 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	}
 	cmd.hdr.seq = cpu_to_le16(++wil->wmi_seq);
 	/* set command */
-	wil_dbg_WMI(wil, "WMI command 0x%04x [%d]\n", cmdid, len);
-	wil_hex_dump_WMI("Cmd ", DUMP_PREFIX_OFFSET, 16, 1, &cmd,
+	wil_dbg_wmi(wil, "WMI command 0x%04x [%d]\n", cmdid, len);
+	wil_hex_dump_wmi("Cmd ", DUMP_PREFIX_OFFSET, 16, 1, &cmd,
 			 sizeof(cmd), true);
-	wil_hex_dump_WMI("cmd ", DUMP_PREFIX_OFFSET, 16, 1, buf,
+	wil_hex_dump_wmi("cmd ", DUMP_PREFIX_OFFSET, 16, 1, buf,
 			 len, true);
 	wil_memcpy_toio_32(dst, &cmd, sizeof(cmd));
 	wil_memcpy_toio_32(dst + sizeof(cmd), buf, len);
@@ -275,7 +275,7 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 	struct wmi_ready_event *evt = d;
 	u32 ver = le32_to_cpu(evt->sw_version);
 
-	wil_dbg_WMI(wil, "FW ver. %d; MAC %pM\n", ver, evt->mac);
+	wil_dbg_wmi(wil, "FW ver. %d; MAC %pM\n", ver, evt->mac);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		memcpy(ndev->dev_addr, evt->mac, ETH_ALEN);
@@ -288,7 +288,7 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
 			     int len)
 {
-	wil_dbg_WMI(wil, "WMI: FW ready\n");
+	wil_dbg_wmi(wil, "WMI: FW ready\n");
 
 	set_bit(wil_status_fwready, &wil->status);
 	/* reuse wmi_ready for the firmware ready indication */
@@ -311,11 +311,11 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 	u32 d_len = le32_to_cpu(data->info.len);
 	u16 d_status = le16_to_cpu(data->info.status);
 
-	wil_dbg_WMI(wil, "MGMT: channel %d MCS %d SNR %d\n",
+	wil_dbg_wmi(wil, "MGMT: channel %d MCS %d SNR %d\n",
 		    data->info.channel, data->info.mcs, data->info.snr);
-	wil_dbg_WMI(wil, "status 0x%04x len %d stype %04x\n", d_status, d_len,
+	wil_dbg_wmi(wil, "status 0x%04x len %d stype %04x\n", d_status, d_len,
 		    le16_to_cpu(data->info.stype));
-	wil_dbg_WMI(wil, "qid %d mid %d cid %d\n",
+	wil_dbg_wmi(wil, "qid %d mid %d cid %d\n",
 		    data->info.qid, data->info.mid, data->info.cid);
 
 	if (!channel) {
@@ -331,13 +331,13 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 		const u8 *ie_buf = rx_mgmt_frame->u.beacon.variable;
 		size_t ie_len = d_len - offsetof(struct ieee80211_mgmt,
 						 u.beacon.variable);
-		wil_dbg_WMI(wil, "Capability info : 0x%04x\n", cap);
+		wil_dbg_wmi(wil, "Capability info : 0x%04x\n", cap);
 
 		bss = cfg80211_inform_bss(wiphy, channel, rx_mgmt_frame->bssid,
 					  tsf, cap, bi, ie_buf, ie_len,
 					  signal, GFP_KERNEL);
 		if (bss) {
-			wil_dbg_WMI(wil, "Added BSS %pM\n",
+			wil_dbg_wmi(wil, "Added BSS %pM\n",
 				    rx_mgmt_frame->bssid);
 			cfg80211_put_bss(bss);
 		} else {
@@ -353,7 +353,7 @@ static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 		struct wmi_scan_complete_event *data = d;
 		bool aborted = (data->status != 0);
 
-		wil_dbg_WMI(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
+		wil_dbg_wmi(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
 		cfg80211_scan_done(wil->scan_request, aborted);
 		wil->scan_request = NULL;
 	} else {
@@ -388,9 +388,9 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 		return;
 	}
 	ch = evt->channel + 1;
-	wil_dbg_WMI(wil, "Connect %pM channel [%d] cid %d\n",
+	wil_dbg_wmi(wil, "Connect %pM channel [%d] cid %d\n",
 		    evt->bssid, ch, evt->cid);
-	wil_hex_dump_WMI("connect AI : ", DUMP_PREFIX_OFFSET, 16, 1,
+	wil_hex_dump_wmi("connect AI : ", DUMP_PREFIX_OFFSET, 16, 1,
 			 evt->assoc_info, len - sizeof(*evt), true);
 
 	/* figure out IE's */
@@ -452,7 +452,7 @@ static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
 {
 	struct wmi_disconnect_event *evt = d;
 
-	wil_dbg_WMI(wil, "Disconnect %pM reason %d proto %d wmi\n",
+	wil_dbg_wmi(wil, "Disconnect %pM reason %d proto %d wmi\n",
 		    evt->bssid,
 		    evt->protocol_reason_status, evt->disconnect_reason);
 
@@ -477,7 +477,7 @@ static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
 	wil->stats.my_tx_sector = le16_to_cpu(evt->my_tx_sector);
 	wil->stats.peer_rx_sector = le16_to_cpu(evt->other_rx_sector);
 	wil->stats.peer_tx_sector = le16_to_cpu(evt->other_tx_sector);
-	wil_dbg_WMI(wil, "Link status, MCS %d TSF 0x%016llx\n"
+	wil_dbg_wmi(wil, "Link status, MCS %d TSF 0x%016llx\n"
 		    "BF status 0x%08x SNR 0x%08x\n"
 		    "Tx Tpt %d goodput %d Rx goodput %d\n"
 		    "Sectors(rx:tx) my %d:%d peer %d:%d\n",
@@ -502,7 +502,7 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 	struct sk_buff *skb;
 	struct ethhdr *eth;
 
-	wil_dbg_WMI(wil, "EAPOL len %d from %pM\n", eapol_len,
+	wil_dbg_wmi(wil, "EAPOL len %d from %pM\n", eapol_len,
 		    evt->src_mac);
 
 	if (eapol_len > 196) { /* TODO: revisit size limit */
@@ -600,15 +600,15 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 		iowrite32(0, wil->csr + HOSTADDR(r->tail) +
 			  offsetof(struct wil6210_mbox_ring_desc, sync));
 		/* indicate */
-		wil_dbg_WMI(wil, "Mbox evt %04x %04x %04x %02x\n",
+		wil_dbg_wmi(wil, "Mbox evt %04x %04x %04x %02x\n",
 			    le16_to_cpu(hdr.seq), len, le16_to_cpu(hdr.type),
 			    hdr.flags);
 		if ((hdr.type == WIL_MBOX_HDR_TYPE_WMI) &&
 		    (len >= sizeof(struct wil6210_mbox_hdr_wmi))) {
-			wil_dbg_WMI(wil, "WMI event 0x%04x\n",
+			wil_dbg_wmi(wil, "WMI event 0x%04x\n",
 				    evt->event.wmi.id);
 		}
-		wil_hex_dump_WMI("evt ", DUMP_PREFIX_OFFSET, 16, 1,
+		wil_hex_dump_wmi("evt ", DUMP_PREFIX_OFFSET, 16, 1,
 				 &evt->event.hdr, sizeof(hdr) + len, true);
 
 		/* advance tail */
@@ -624,7 +624,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 		{
 			int q =	queue_work(wil->wmi_wq,
 					   &wil->wmi_event_worker);
-			wil_dbg_WMI(wil, "queue_work -> %d\n", q);
+			wil_dbg_wmi(wil, "queue_work -> %d\n", q);
 		}
 	}
 }
@@ -651,7 +651,7 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 			cmdid, reply_id, to_msec);
 		rc = -ETIME;
 	} else {
-		wil_dbg_WMI(wil,
+		wil_dbg_wmi(wil,
 			    "wmi_call(0x%04x->0x%04x) completed in %d msec\n",
 			    cmdid, reply_id,
 			    to_msec - jiffies_to_msecs(remain));
@@ -681,7 +681,7 @@ int wmi_set_mac_address(struct wil6210_priv *wil, void *addr)
 
 	memcpy(cmd.mac, addr, ETH_ALEN);
 
-	wil_dbg_WMI(wil, "Set MAC %pM\n", addr);
+	wil_dbg_wmi(wil, "Set MAC %pM\n", addr);
 
 	return wmi_send(wil, WMI_SET_MAC_ADDRESS_CMDID, &cmd, sizeof(cmd));
 }
@@ -779,7 +779,7 @@ int wmi_tx_eapol(struct wil6210_priv *wil, struct sk_buff *skb)
 
 	skb_set_mac_header(skb, 0);
 	eth = eth_hdr(skb);
-	wil_dbg_WMI(wil, "EAPOL %d bytes to %pM\n", eapol_len, eth->h_dest);
+	wil_dbg_wmi(wil, "EAPOL %d bytes to %pM\n", eapol_len, eth->h_dest);
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
 		if (memcmp(wil->dst_addr[i], eth->h_dest, ETH_ALEN) == 0)
 			goto found_dest;
@@ -894,7 +894,7 @@ int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
 
 	vring->hwtail = le32_to_cpu(evt.evt.rx_ring_tail_ptr);
 
-	wil_dbg_MISC(wil, "Rx init: status %d tail 0x%08x\n",
+	wil_dbg_misc(wil, "Rx init: status %d tail 0x%08x\n",
 		     le32_to_cpu(evt.evt.status), vring->hwtail);
 
 	if (le32_to_cpu(evt.evt.status) != WMI_CFG_RX_CHAIN_SUCCESS)
@@ -929,7 +929,7 @@ void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
 
-	wil_dbg_WMI(wil, "%s()\n", __func__);
+	wil_dbg_wmi(wil, "%s()\n", __func__);
 
 	list_for_each_entry_safe(evt, t, &wil->pending_wmi_ev, list) {
 		list_del(&evt->list);
@@ -971,7 +971,7 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 				wmi_evt_call_handler(wil, id, evt_data,
 						     len - sizeof(*wmi));
 			}
-			wil_dbg_WMI(wil, "Complete WMI 0x%04x\n", id);
+			wil_dbg_wmi(wil, "Complete WMI 0x%04x\n", id);
 			complete(&wil->wmi_ready);
 			return;
 		}
@@ -1036,7 +1036,7 @@ void wmi_connect_worker(struct work_struct *work)
 		return;
 	}
 
-	wil_dbg_WMI(wil, "Configure for connection CID %d\n",
+	wil_dbg_wmi(wil, "Configure for connection CID %d\n",
 		    wil->pending_connect_cid);
 
 	rc = wil_vring_init_tx(wil, 0, WIL6210_TX_RING_SIZE,
-- 
1.7.10.4

