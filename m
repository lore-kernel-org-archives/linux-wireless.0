Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30636 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbcDKJfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 05:35:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <franky.lin@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/8] brcmfmac: screening firmware event packet
Date: Mon, 11 Apr 2016 11:35:25 +0200
Message-Id: <1460367328-12082-6-git-send-email-arend@broadcom.com> (sfid-20160411_113545_857267_76A16D9E)
In-Reply-To: <1460367328-12082-1-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Firmware uses asynchronized events as a communication method to the
host. The event packets are marked as ETH_P_LINK_CTL protocol type. For
SDIO and PCIe bus, this kind of packets are delivered through virtual
event channel not data channel. This patch adds a screening logic to
make sure the event handler only processes the events coming from the
correct channel.

Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 46 +++++++++++++++++-----
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 42 +++++++++++---------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 32 +++++++++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  2 +-
 6 files changed, 90 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 8e02a47..31856eb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -216,7 +216,9 @@ bool brcmf_c_prec_enq(struct device *dev, struct pktq *q, struct sk_buff *pkt,
 		      int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp);
+void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_evnt);
+/* Receive async event packet from firmware. Callee disposes of rxp. */
+void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
 
 /* Indication from bus module regarding presence/insertion of dongle. */
 int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ff825cd..8a91a517 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -311,16 +311,17 @@ void brcmf_txflowblock(struct device *dev, bool state)
 	brcmf_fws_bus_blocked(drvr, state);
 }
 
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
+		    bool handle_event)
 {
-	skb->dev = ifp->ndev;
-	skb->protocol = eth_type_trans(skb, skb->dev);
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
 
 	if (skb->pkt_type == PACKET_MULTICAST)
 		ifp->stats.multicast++;
 
 	/* Process special event packets */
-	brcmf_fweh_process_skb(ifp->drvr, skb);
+	if (handle_event)
+		brcmf_fweh_process_skb(ifp->drvr, skb);
 
 	if (!(ifp->ndev->flags & IFF_UP)) {
 		brcmu_pkt_buf_free_skb(skb);
@@ -381,7 +382,7 @@ static void brcmf_rxreorder_process_info(struct brcmf_if *ifp, u8 *reorder_data,
 	/* validate flags and flow id */
 	if (flags == 0xFF) {
 		brcmf_err("invalid flags...so ignore this packet\n");
-		brcmf_netif_rx(ifp, pkt);
+		brcmf_netif_rx(ifp, pkt, false);
 		return;
 	}
 
@@ -393,7 +394,7 @@ static void brcmf_rxreorder_process_info(struct brcmf_if *ifp, u8 *reorder_data,
 		if (rfi == NULL) {
 			brcmf_dbg(INFO, "received flags to cleanup, but no flow (%d) yet\n",
 				  flow_id);
-			brcmf_netif_rx(ifp, pkt);
+			brcmf_netif_rx(ifp, pkt, false);
 			return;
 		}
 
@@ -418,7 +419,7 @@ static void brcmf_rxreorder_process_info(struct brcmf_if *ifp, u8 *reorder_data,
 		rfi = kzalloc(buf_size, GFP_ATOMIC);
 		if (rfi == NULL) {
 			brcmf_err("failed to alloc buffer\n");
-			brcmf_netif_rx(ifp, pkt);
+			brcmf_netif_rx(ifp, pkt, false);
 			return;
 		}
 
@@ -532,11 +533,11 @@ static void brcmf_rxreorder_process_info(struct brcmf_if *ifp, u8 *reorder_data,
 netif_rx:
 	skb_queue_walk_safe(&reorder_list, pkt, pnext) {
 		__skb_unlink(pkt, &reorder_list);
-		brcmf_netif_rx(ifp, pkt);
+		brcmf_netif_rx(ifp, pkt, false);
 	}
 }
 
-void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
+void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_evnt)
 {
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -560,7 +561,32 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
 	if (rd->reorder)
 		brcmf_rxreorder_process_info(ifp, rd->reorder, skb);
 	else
-		brcmf_netif_rx(ifp, skb);
+		brcmf_netif_rx(ifp, skb, handle_evnt);
+}
+
+void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
+{
+	struct brcmf_if *ifp;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+	int ret;
+
+	brcmf_dbg(EVENT, "Enter: %s: rxp=%p\n", dev_name(dev), skb);
+
+	/* process and remove protocol-specific header */
+	ret = brcmf_proto_hdrpull(drvr, true, skb, &ifp);
+
+	if (ret || !ifp || !ifp->ndev) {
+		if (ret != -ENODATA && ifp)
+			ifp->stats.rx_errors++;
+		brcmu_pkt_buf_free_skb(skb);
+		return;
+	}
+
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
+
+	brcmf_fweh_process_skb(ifp->drvr, skb);
+	brcmu_pkt_buf_free_skb(skb);
 }
 
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 7bdb6fef..d3497e8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -225,7 +225,8 @@ int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
+		    bool handle_event);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 int __init brcmf_core_init(void);
 void __exit brcmf_core_exit(void);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 9229667..3795354 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -20,6 +20,7 @@
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
@@ -1075,28 +1076,13 @@ static void brcmf_msgbuf_rxbuf_event_post(struct brcmf_msgbuf *msgbuf)
 }
 
 
-static void
-brcmf_msgbuf_rx_skb(struct brcmf_msgbuf *msgbuf, struct sk_buff *skb,
-		    u8 ifidx)
-{
-	struct brcmf_if *ifp;
-
-	ifp = brcmf_get_ifp(msgbuf->drvr, ifidx);
-	if (!ifp || !ifp->ndev) {
-		brcmf_err("Received pkt for invalid ifidx %d\n", ifidx);
-		brcmu_pkt_buf_free_skb(skb);
-		return;
-	}
-	brcmf_netif_rx(ifp, skb);
-}
-
-
 static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 {
 	struct msgbuf_rx_event *event;
 	u32 idx;
 	u16 buflen;
 	struct sk_buff *skb;
+	struct brcmf_if *ifp;
 
 	event = (struct msgbuf_rx_event *)buf;
 	idx = le32_to_cpu(event->msg.request_id);
@@ -1116,7 +1102,19 @@ static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	skb_trim(skb, buflen);
 
-	brcmf_msgbuf_rx_skb(msgbuf, skb, event->msg.ifidx);
+	ifp = brcmf_get_ifp(msgbuf->drvr, event->msg.ifidx);
+	if (!ifp || !ifp->ndev) {
+		brcmf_err("Received pkt for invalid ifidx %d\n",
+			  event->msg.ifidx);
+		goto exit;
+	}
+
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
+
+	brcmf_fweh_process_skb(ifp->drvr, skb);
+
+exit:
+	brcmu_pkt_buf_free_skb(skb);
 }
 
 
@@ -1128,6 +1126,7 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 	u16 data_offset;
 	u16 buflen;
 	u32 idx;
+	struct brcmf_if *ifp;
 
 	brcmf_msgbuf_update_rxbufpost_count(msgbuf, 1);
 
@@ -1148,7 +1147,14 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	skb_trim(skb, buflen);
 
-	brcmf_msgbuf_rx_skb(msgbuf, skb, rx_complete->msg.ifidx);
+	ifp = brcmf_get_ifp(msgbuf->drvr, rx_complete->msg.ifidx);
+	if (!ifp || !ifp->ndev) {
+		brcmf_err("Received pkt for invalid ifidx %d\n",
+			  rx_complete->msg.ifidx);
+		brcmu_pkt_buf_free_skb(skb);
+		return;
+	}
+	brcmf_netif_rx(ifp, skb, false);
 }
 
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 48d7467..4252fa8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1294,6 +1294,17 @@ static inline u8 brcmf_sdio_getdatoffset(u8 *swheader)
 	return (u8)((hdrvalue & SDPCM_DOFFSET_MASK) >> SDPCM_DOFFSET_SHIFT);
 }
 
+static inline bool brcmf_sdio_fromevntchan(u8 *swheader)
+{
+	u32 hdrvalue;
+	u8 ret;
+
+	hdrvalue = *(u32 *)swheader;
+	ret = (u8)((hdrvalue & SDPCM_CHANNEL_MASK) >> SDPCM_CHANNEL_SHIFT);
+
+	return (ret == SDPCM_EVENT_CHANNEL);
+}
+
 static int brcmf_sdio_hdparse(struct brcmf_sdio *bus, u8 *header,
 			      struct brcmf_sdio_hdrinfo *rd,
 			      enum brcmf_sdio_frmtype type)
@@ -1641,7 +1652,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 					   pfirst->len, pfirst->next,
 					   pfirst->prev);
 			skb_unlink(pfirst, &bus->glom);
-			brcmf_rx_frame(bus->sdiodev->dev, pfirst);
+			if (brcmf_sdio_fromevntchan(pfirst->data))
+				brcmf_rx_event(bus->sdiodev->dev, pfirst);
+			else
+				brcmf_rx_frame(bus->sdiodev->dev, pfirst,
+					       false);
 			bus->sdcnt.rxglompkts++;
 		}
 
@@ -1967,18 +1982,19 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		__skb_trim(pkt, rd->len);
 		skb_pull(pkt, rd->dat_offset);
 
+		if (pkt->len == 0)
+			brcmu_pkt_buf_free_skb(pkt);
+		else if (rd->channel == SDPCM_EVENT_CHANNEL)
+			brcmf_rx_event(bus->sdiodev->dev, pkt);
+		else
+			brcmf_rx_frame(bus->sdiodev->dev, pkt,
+				       false);
+
 		/* prepare the descriptor for the next read */
 		rd->len = rd->len_nxtfrm << 4;
 		rd->len_nxtfrm = 0;
 		/* treat all packet as event if we don't know */
 		rd->channel = SDPCM_EVENT_CHANNEL;
-
-		if (pkt->len == 0) {
-			brcmu_pkt_buf_free_skb(pkt);
-			continue;
-		}
-
-		brcmf_rx_frame(bus->sdiodev->dev, pkt);
 	}
 
 	rxcount = maxframes - rxleft;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 869eb82..aa0b2a1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -514,7 +514,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
 		skb_put(skb, urb->actual_length);
-		brcmf_rx_frame(devinfo->dev, skb);
+		brcmf_rx_frame(devinfo->dev, skb, true);
 		brcmf_usb_rx_refill(devinfo, req);
 	} else {
 		brcmu_pkt_buf_free_skb(skb);
-- 
1.9.1

