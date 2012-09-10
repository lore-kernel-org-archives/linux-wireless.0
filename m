Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2021 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2IJNRT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:17:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/10] brcmfmac: Add tx flow control on net if queue for
 USB.
Date: Mon, 10 Sep 2012 15:16:52 +0200
Message-ID: <1347283018-24223-5-git-send-email-arend@broadcom.com> (sfid-20120910_151726_532778_AD074FBF)
In-Reply-To: <1347283018-24223-1-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Enable tx flow control for USB host interface.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   61 +++++++++++++++----------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 7fe68aa..8aab2a2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -119,9 +119,8 @@ struct brcmf_usbdev_info {
 	int rx_low_watermark;
 	int tx_low_watermark;
 	int tx_high_watermark;
-	bool txoff;
-	bool rxoff;
-	bool txoverride;
+	int tx_freecount;
+	bool tx_flowblock;
 
 	struct brcmf_usbreq *tx_reqs;
 	struct brcmf_usbreq *rx_reqs;
@@ -179,14 +178,6 @@ static struct brcmf_usbdev_info *brcmf_usb_get_businfo(struct device *dev)
 	return brcmf_usb_get_buspub(dev)->devinfo;
 }
 
-#if 0
-static void
-brcmf_usb_txflowcontrol(struct brcmf_usbdev_info *devinfo, bool onoff)
-{
-	dhd_txflowcontrol(devinfo->bus_pub.netdev, 0, onoff);
-}
-#endif
-
 static int brcmf_usb_ioctl_resp_wait(struct brcmf_usbdev_info *devinfo,
 	 uint *condition, bool *pending)
 {
@@ -420,7 +411,7 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 }
 
 static struct brcmf_usbreq *brcmf_usb_deq(struct brcmf_usbdev_info *devinfo,
-					  struct list_head *q)
+					  struct list_head *q, int *counter)
 {
 	unsigned long flags;
 	struct brcmf_usbreq  *req;
@@ -431,17 +422,22 @@ static struct brcmf_usbreq *brcmf_usb_deq(struct brcmf_usbdev_info *devinfo,
 	}
 	req = list_entry(q->next, struct brcmf_usbreq, list);
 	list_del_init(q->next);
+	if (counter)
+		(*counter)--;
 	spin_unlock_irqrestore(&devinfo->qlock, flags);
 	return req;
 
 }
 
 static void brcmf_usb_enq(struct brcmf_usbdev_info *devinfo,
-			  struct list_head *q, struct brcmf_usbreq *req)
+			  struct list_head *q, struct brcmf_usbreq *req,
+			  int *counter)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&devinfo->qlock, flags);
 	list_add_tail(&req->list, q);
+	if (counter)
+		(*counter)++;
 	spin_unlock_irqrestore(&devinfo->qlock, flags);
 }
 
@@ -523,8 +519,12 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 
 	brcmu_pkt_buf_free_skb(req->skb);
 	req->skb = NULL;
-	brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req);
-
+	brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req, &devinfo->tx_freecount);
+	if (devinfo->tx_freecount > devinfo->tx_high_watermark &&
+		devinfo->tx_flowblock) {
+		brcmf_txflowblock(devinfo->dev, false);
+		devinfo->tx_flowblock = false;
+	}
 }
 
 static void brcmf_usb_rx_complete(struct urb *urb)
@@ -543,7 +543,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	} else {
 		devinfo->bus_pub.bus->dstats.rx_errors++;
 		brcmu_pkt_buf_free_skb(skb);
-		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
+		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
 		return;
 	}
 
@@ -552,7 +552,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 		if (brcmf_proto_hdrpull(devinfo->dev, &ifidx, skb) != 0) {
 			brcmf_dbg(ERROR, "rx protocol error\n");
 			brcmu_pkt_buf_free_skb(skb);
-			brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
+			brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
 			devinfo->bus_pub.bus->dstats.rx_errors++;
 		} else {
 			brcmf_rx_packet(devinfo->dev, ifidx, skb);
@@ -560,7 +560,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 		}
 	} else {
 		brcmu_pkt_buf_free_skb(skb);
-		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
+		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
 	}
 	return;
 
@@ -577,7 +577,7 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 
 	skb = dev_alloc_skb(devinfo->bus_pub.bus_mtu);
 	if (!skb) {
-		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
+		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
 		return;
 	}
 	req->skb = skb;
@@ -586,14 +586,14 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 			  skb->data, skb_tailroom(skb), brcmf_usb_rx_complete,
 			  req);
 	req->devinfo = devinfo;
-	brcmf_usb_enq(devinfo, &devinfo->rx_postq, req);
+	brcmf_usb_enq(devinfo, &devinfo->rx_postq, req, NULL);
 
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
 	if (ret) {
 		brcmf_usb_del_fromq(devinfo, req);
 		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
-		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
+		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
 	}
 	return;
 }
@@ -606,7 +606,7 @@ static void brcmf_usb_rx_fill_all(struct brcmf_usbdev_info *devinfo)
 		brcmf_dbg(ERROR, "bus is not up\n");
 		return;
 	}
-	while ((req = brcmf_usb_deq(devinfo, &devinfo->rx_freeq)) != NULL)
+	while ((req = brcmf_usb_deq(devinfo, &devinfo->rx_freeq, NULL)) != NULL)
 		brcmf_usb_rx_refill(devinfo, req);
 }
 
@@ -684,7 +684,8 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 		return -EIO;
 	}
 
-	req = brcmf_usb_deq(devinfo, &devinfo->tx_freeq);
+	req = brcmf_usb_deq(devinfo, &devinfo->tx_freeq,
+					&devinfo->tx_freecount);
 	if (!req) {
 		brcmu_pkt_buf_free_skb(skb);
 		brcmf_dbg(ERROR, "no req to send\n");
@@ -696,14 +697,21 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	usb_fill_bulk_urb(req->urb, devinfo->usbdev, devinfo->tx_pipe,
 			  skb->data, skb->len, brcmf_usb_tx_complete, req);
 	req->urb->transfer_flags |= URB_ZERO_PACKET;
-	brcmf_usb_enq(devinfo, &devinfo->tx_postq, req);
+	brcmf_usb_enq(devinfo, &devinfo->tx_postq, req, NULL);
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
 	if (ret) {
 		brcmf_dbg(ERROR, "brcmf_usb_tx usb_submit_urb FAILED\n");
 		brcmf_usb_del_fromq(devinfo, req);
 		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
-		brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req);
+		brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req,
+						&devinfo->tx_freecount);
+	} else {
+		if (devinfo->tx_freecount < devinfo->tx_low_watermark &&
+			!devinfo->tx_flowblock) {
+			brcmf_txflowblock(dev, true);
+			devinfo->tx_flowblock = true;
+		}
 	}
 
 	return ret;
@@ -1316,6 +1324,8 @@ struct brcmf_usbdev *brcmf_usb_attach(int nrxq, int ntxq, struct device *dev)
 	INIT_LIST_HEAD(&devinfo->tx_freeq);
 	INIT_LIST_HEAD(&devinfo->tx_postq);
 
+	devinfo->tx_flowblock = false;
+
 	devinfo->rx_reqs = brcmf_usbdev_qinit(&devinfo->rx_freeq, nrxq);
 	if (!devinfo->rx_reqs)
 		goto error;
@@ -1323,6 +1333,7 @@ struct brcmf_usbdev *brcmf_usb_attach(int nrxq, int ntxq, struct device *dev)
 	devinfo->tx_reqs = brcmf_usbdev_qinit(&devinfo->tx_freeq, ntxq);
 	if (!devinfo->tx_reqs)
 		goto error;
+	devinfo->tx_freecount = ntxq;
 
 	devinfo->intr_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!devinfo->intr_urb) {
-- 
1.7.9.5


