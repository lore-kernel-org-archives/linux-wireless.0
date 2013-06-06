Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4840 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab3FFLTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:19:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/22] brcmfmac: Take bus flowcontrol at credit mgmt
 into account.
Date: Thu, 6 Jun 2013 13:17:48 +0200
Message-ID: <1370517487-14395-4-git-send-email-arend@broadcom.com> (sfid-20130606_131925_685006_2F80638D)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On bus flow control (no more host bus resources to send packets
to device) the netif flow control was toggled, however credit
management should also take this status into account. Since there
are multiple sources handling this flow control necessary spinlocks
were added to protect flow control related data/states.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 ++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    8 ++++++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   21 ++++++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    8 ++++++++
 6 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 28db9cf..86cbfe2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -583,6 +583,7 @@ enum brcmf_netif_stop_reason {
  * @bssidx: index of bss associated with this interface.
  * @mac_addr: assigned mac address.
  * @netif_stop: bitmap indicates reason why netif queues are stopped.
+ * @netif_stop_lock: spinlock for update netif_stop from multiple sources.
  * @pend_8021x_cnt: tracks outstanding number of 802.1x frames.
  * @pend_8021x_wait: used for signalling change in count.
  */
@@ -598,6 +599,7 @@ struct brcmf_if {
 	s32 bssidx;
 	u8 mac_addr[ETH_ALEN];
 	u8 netif_stop;
+	spinlock_t netif_stop_lock;
 	atomic_t pend_8021x_cnt;
 	wait_queue_head_t pend_8021x_wait;
 };
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 59c2546..5a774493 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -240,11 +240,15 @@ done:
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state)
 {
+	unsigned long flags;
+
 	if (!ifp)
 		return;
 
 	brcmf_dbg(TRACE, "enter: idx=%d stop=0x%X reason=%d state=%d\n",
 		  ifp->bssidx, ifp->netif_stop, reason, state);
+
+	spin_lock_irqsave(&ifp->netif_stop_lock, flags);
 	if (state) {
 		if (!ifp->netif_stop)
 			netif_stop_queue(ifp->ndev);
@@ -254,6 +258,7 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 		if (!ifp->netif_stop)
 			netif_wake_queue(ifp->ndev);
 	}
+	spin_unlock_irqrestore(&ifp->netif_stop_lock, flags);
 }
 
 void brcmf_txflowblock(struct device *dev, bool state)
@@ -264,6 +269,8 @@ void brcmf_txflowblock(struct device *dev, bool state)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
+	brcmf_fws_bus_blocked(drvr, state);
+
 	for (i = 0; i < BRCMF_MAX_IFS; i++)
 		brcmf_txflowblock_if(drvr->iflist[i],
 				     BRCMF_NETIF_STOP_REASON_BLOCK_BUS, state);
@@ -773,6 +780,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 	ifp->bssidx = bssidx;
 
 	init_waitqueue_head(&ifp->pend_8021x_wait);
+	spin_lock_init(&ifp->netif_stop_lock);
 
 	if (mac_addr != NULL)
 		memcpy(ifp->mac_addr, mac_addr, ETH_ALEN);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index d248751..6f3d181 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2369,12 +2369,12 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	} else {
 		ret = 0;
 	}
-	spin_unlock_bh(&bus->txqlock);
 
 	if (pktq_len(&bus->txq) >= TXHI) {
 		bus->txoff = true;
 		brcmf_txflowblock(bus->sdiodev->dev, true);
 	}
+	spin_unlock_bh(&bus->txqlock);
 
 #ifdef DEBUG
 	if (pktq_plen(&bus->txq, prec) > qcount[prec])
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index bc2edc0..c1930ef5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -431,6 +431,7 @@ struct brcmf_fws_info {
 	u32 fifo_credit_map;
 	u32 fifo_delay_map;
 	unsigned long borrow_defer_timestamp;
+	bool bus_flow_blocked;
 };
 
 /*
@@ -1833,6 +1834,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	brcmf_fws_lock(drvr, flags);
 	if (skcb->mac->suppressed ||
+	    fws->bus_flow_blocked ||
 	    brcmf_fws_mac_desc_closed(fws, skcb->mac, fifo) ||
 	    brcmu_pktq_mlen(&skcb->mac->psq, 3 << (fifo * 2)) ||
 	    (!multicast &&
@@ -1905,7 +1907,8 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 
 	brcmf_dbg(TRACE, "enter: fws=%p\n", fws);
 	brcmf_fws_lock(fws->drvr, flags);
-	for (fifo = NL80211_NUM_ACS; fifo >= 0; fifo--) {
+	for (fifo = NL80211_NUM_ACS; fifo >= 0 && !fws->bus_flow_blocked;
+	     fifo--) {
 		brcmf_dbg(TRACE, "fifo %d credit %d\n", fifo,
 			  fws->fifo_credit[fifo]);
 		for (credit = 0; credit < fws->fifo_credit[fifo]; /* nop */) {
@@ -1915,9 +1918,12 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 			if (brcmf_skbcb(skb)->if_flags &
 			    BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
 				credit++;
+			if (fws->bus_flow_blocked)
+				break;
 		}
 		if ((fifo == BRCMF_FWS_FIFO_AC_BE) &&
-		    (credit == fws->fifo_credit[fifo])) {
+		    (credit == fws->fifo_credit[fifo]) &&
+		    (!fws->bus_flow_blocked)) {
 			fws->fifo_credit[fifo] -= credit;
 			while (brcmf_fws_borrow_credit(fws) == 0) {
 				skb = brcmf_fws_deq(fws, fifo);
@@ -1929,6 +1935,8 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 					brcmf_fws_return_credits(fws, fifo, 1);
 					break;
 				}
+				if (fws->bus_flow_blocked)
+					break;
 			}
 		} else {
 			fws->fifo_credit[fifo] -= credit;
@@ -2060,3 +2068,12 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 	}
 	brcmf_fws_unlock(fws->drvr, flags);
 }
+
+void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked)
+{
+	struct brcmf_fws_info *fws = drvr->fws;
+
+	fws->bus_flow_blocked = flow_blocked;
+	if (!flow_blocked)
+		brcmf_fws_schedule_deq(fws);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
index fbe483d..9fc8609 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
@@ -29,5 +29,6 @@ void brcmf_fws_reset_interface(struct brcmf_if *ifp);
 void brcmf_fws_add_interface(struct brcmf_if *ifp);
 void brcmf_fws_del_interface(struct brcmf_if *ifp);
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb);
+void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked);
 
 #endif /* FWSIGNAL_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 01aed7a..322cadc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -82,6 +82,7 @@ struct brcmf_usbdev_info {
 	int tx_high_watermark;
 	int tx_freecount;
 	bool tx_flowblock;
+	spinlock_t tx_flowblock_lock;
 
 	struct brcmf_usbreq *tx_reqs;
 	struct brcmf_usbreq *rx_reqs;
@@ -411,6 +412,7 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 {
 	struct brcmf_usbreq *req = (struct brcmf_usbreq *)urb->context;
 	struct brcmf_usbdev_info *devinfo = req->devinfo;
+	unsigned long flags;
 
 	brcmf_dbg(USB, "Enter, urb->status=%d, skb=%p\n", urb->status,
 		  req->skb);
@@ -419,11 +421,13 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 	brcmf_txcomplete(devinfo->dev, req->skb, urb->status == 0);
 	req->skb = NULL;
 	brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req, &devinfo->tx_freecount);
+	spin_lock_irqsave(&devinfo->tx_flowblock_lock, flags);
 	if (devinfo->tx_freecount > devinfo->tx_high_watermark &&
 		devinfo->tx_flowblock) {
 		brcmf_txflowblock(devinfo->dev, false);
 		devinfo->tx_flowblock = false;
 	}
+	spin_unlock_irqrestore(&devinfo->tx_flowblock_lock, flags);
 }
 
 static void brcmf_usb_rx_complete(struct urb *urb)
@@ -568,6 +572,7 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 	struct brcmf_usbreq  *req;
 	int ret;
+	unsigned long flags;
 
 	brcmf_dbg(USB, "Enter, skb=%p\n", skb);
 	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP) {
@@ -599,11 +604,13 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 		goto fail;
 	}
 
+	spin_lock_irqsave(&devinfo->tx_flowblock_lock, flags);
 	if (devinfo->tx_freecount < devinfo->tx_low_watermark &&
 	    !devinfo->tx_flowblock) {
 		brcmf_txflowblock(dev, true);
 		devinfo->tx_flowblock = true;
 	}
+	spin_unlock_irqrestore(&devinfo->tx_flowblock_lock, flags);
 	return 0;
 
 fail:
@@ -1164,6 +1171,7 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 
 	/* Initialize the spinlocks */
 	spin_lock_init(&devinfo->qlock);
+	spin_lock_init(&devinfo->tx_flowblock_lock);
 
 	INIT_LIST_HEAD(&devinfo->rx_freeq);
 	INIT_LIST_HEAD(&devinfo->rx_postq);
-- 
1.7.10.4


