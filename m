Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2158 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab3IYLGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 07:06:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/7] brcmfmac: rework rx path bus interface
Date: Wed, 25 Sep 2013 13:05:46 +0200
Message-ID: <1380107146-24026-8-git-send-email-arend@broadcom.com> (sfid-20130925_130616_669574_98BE2A4F)
In-Reply-To: <1380107146-24026-1-git-send-email-arend@broadcom.com>
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmfmac has common and bus specific part. The rx function api
was using sk_buff_head. Changed to sk_buff instead.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   38 +++++++++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   12 +++----
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    5 +--
 4 files changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index f7c1985..200ee9b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -136,7 +136,7 @@ extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void brcmf_rx_frames(struct device *dev, struct sk_buff_head *rxlist);
+extern void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp);
 
 /* Indication from bus module regarding presence/insertion of dongle. */
 extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index e067aec..42bf19a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -509,9 +509,8 @@ netif_rx:
 	}
 }
 
-void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
+void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
 {
-	struct sk_buff *skb, *pnext;
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
@@ -519,29 +518,24 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 	u8 ifidx;
 	int ret;
 
-	brcmf_dbg(DATA, "Enter: %s: count=%u\n", dev_name(dev),
-		  skb_queue_len(skb_list));
+	brcmf_dbg(DATA, "Enter: %s: rxp=%p\n", dev_name(dev), skb);
 
-	skb_queue_walk_safe(skb_list, skb, pnext) {
-		skb_unlink(skb, skb_list);
-
-		/* process and remove protocol-specific header */
-		ret = brcmf_proto_hdrpull(drvr, true, &ifidx, skb);
-		ifp = drvr->iflist[ifidx];
-
-		if (ret || !ifp || !ifp->ndev) {
-			if ((ret != -ENODATA) && ifp)
-				ifp->stats.rx_errors++;
-			brcmu_pkt_buf_free_skb(skb);
-			continue;
-		}
+	/* process and remove protocol-specific header */
+	ret = brcmf_proto_hdrpull(drvr, true, &ifidx, skb);
+	ifp = drvr->iflist[ifidx];
 
-		rd = (struct brcmf_skb_reorder_data *)skb->cb;
-		if (rd->reorder)
-			brcmf_rxreorder_process_info(ifp, rd->reorder, skb);
-		else
-			brcmf_netif_rx(ifp, skb);
+	if (ret || !ifp || !ifp->ndev) {
+		if ((ret != -ENODATA) && ifp)
+			ifp->stats.rx_errors++;
+		brcmu_pkt_buf_free_skb(skb);
+		return;
 	}
+
+	rd = (struct brcmf_skb_reorder_data *)skb->cb;
+	if (rd->reorder)
+		brcmf_rxreorder_process_info(ifp, rd->reorder, skb);
+	else
+		brcmf_netif_rx(ifp, skb);
 }
 
 void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 6e72b73..67f05db 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1492,13 +1492,12 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 					   bus->glom.qlen, pfirst, pfirst->data,
 					   pfirst->len, pfirst->next,
 					   pfirst->prev);
+			skb_unlink(pfirst, &bus->glom);
+			brcmf_rx_frame(bus->sdiodev->dev, pfirst);
+			bus->sdcnt.rxglompkts++;
 		}
-		/* sent any remaining packets up */
-		if (bus->glom.qlen)
-			brcmf_rx_frames(bus->sdiodev->dev, &bus->glom);
 
 		bus->sdcnt.rxglomframes++;
-		bus->sdcnt.rxglompkts += bus->glom.qlen;
 	}
 	return num;
 }
@@ -1643,7 +1642,6 @@ static void brcmf_pad(struct brcmf_sdio *bus, u16 *pad, u16 *rdlen)
 static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 {
 	struct sk_buff *pkt;		/* Packet for event or data frames */
-	struct sk_buff_head pktlist;	/* needed for bus interface */
 	u16 pad;		/* Number of pad bytes to read */
 	uint rxleft = 0;	/* Remaining number of frames allowed */
 	int ret;		/* Return code from calls */
@@ -1845,9 +1843,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			continue;
 		}
 
-		skb_queue_head_init(&pktlist);
-		skb_queue_tail(&pktlist, pkt);
-		brcmf_rx_frames(bus->sdiodev->dev, &pktlist);
+		brcmf_rx_frame(bus->sdiodev->dev, pkt);
 	}
 
 	rxcount = maxframes - rxleft;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 39e01a7..bf6758d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -435,7 +435,6 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	struct brcmf_usbreq  *req = (struct brcmf_usbreq *)urb->context;
 	struct brcmf_usbdev_info *devinfo = req->devinfo;
 	struct sk_buff *skb;
-	struct sk_buff_head skbq;
 
 	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
 	brcmf_usb_del_fromq(devinfo, req);
@@ -450,10 +449,8 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	}
 
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
-		skb_queue_head_init(&skbq);
-		skb_queue_tail(&skbq, skb);
 		skb_put(skb, urb->actual_length);
-		brcmf_rx_frames(devinfo->dev, &skbq);
+		brcmf_rx_frame(devinfo->dev, skb);
 		brcmf_usb_rx_refill(devinfo, req);
 	} else {
 		brcmu_pkt_buf_free_skb(skb);
-- 
1.7.10.4


