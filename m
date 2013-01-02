Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3961 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3ABOXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:08 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/18] brcmfmac: remove brcmf_proto_hdrpull() from bus
 interface
Date: Wed, 2 Jan 2013 15:22:43 +0100
Message-ID: <1357136572-18273-11-git-send-email-arend@broadcom.com> (sfid-20130102_152315_616381_20802E9E)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The use of the function brcmf_proto_hdrpull() is moved to the
common part of the driver and consequently it can be removed
from the bus interface.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h       |    4 ++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h   |    7 +------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c   |    6 +++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |   19 +++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c  |   19 ++-----------------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c       |   17 ++++-------------
 6 files changed, 29 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 7245b17..4937bf4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -577,6 +577,10 @@ extern int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 				    void *buf, uint len);
 
+/* Remove any protocol-specific data header. */
+extern int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
+			       struct sk_buff *rxp);
+
 extern int brcmf_net_attach(struct brcmf_if *ifp);
 extern struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx,
 				     s32 bssidx, char *name, u8 *mac_addr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 639bc2a..64c38f4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -130,16 +130,11 @@ int brcmf_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint len)
  * interface functions from common layer
  */
 
-/* Remove any protocol-specific data header. */
-extern int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
-			       struct sk_buff *rxp);
-
 extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void brcmf_rx_frames(struct device *dev, u8 ifidx,
-			    struct sk_buff_head *rxlist);
+extern void brcmf_rx_frames(struct device *dev, struct sk_buff_head *rxlist);
 
 /* Indication from bus module regarding presence/insertion of dongle. */
 extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 0c83998..aa37f3e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -303,12 +303,10 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
-int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
+int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
 			struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -346,6 +344,8 @@ int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
 	skb_pull(pktbuf, BDC_HEADER_LEN);
 	skb_pull(pktbuf, h->data_offset << 2);
 
+	if (pktbuf->len == 0)
+		return -ENODATA;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index a820f58..682cb02 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -248,8 +248,7 @@ void brcmf_txflowblock(struct device *dev, bool state)
 		}
 }
 
-void brcmf_rx_frames(struct device *dev, u8 ifidx,
-		     struct sk_buff_head *skb_list)
+void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 {
 	unsigned char *eth;
 	uint len;
@@ -257,12 +256,24 @@ void brcmf_rx_frames(struct device *dev, u8 ifidx,
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
+	u8 ifidx;
+	int ret;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	skb_queue_walk_safe(skb_list, skb, pnext) {
 		skb_unlink(skb, skb_list);
 
+		/* process and remove protocol-specific header
+		 */
+		ret = brcmf_proto_hdrpull(drvr, &ifidx, skb);
+		if (ret < 0) {
+			if (ret != -ENODATA)
+				bus_if->dstats.rx_errors++;
+			brcmu_pkt_buf_free_skb(skb);
+			continue;
+		}
+
 		/* Get the protocol, maintain skb around eth_type_trans()
 		 * The main reason for this hack is for the limitation of
 		 * Linux 2.4 where 'eth_type_trans' uses the
@@ -326,13 +337,13 @@ void brcmf_rx_frames(struct device *dev, u8 ifidx,
 
 void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 {
-	uint ifidx;
+	u8 ifidx;
 	struct ethhdr *eh;
 	u16 type;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 
-	brcmf_proto_hdrpull(dev, &ifidx, txp);
+	brcmf_proto_hdrpull(drvr, &ifidx, txp);
 
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 13ea9b4..7fef9b5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1167,7 +1167,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 	int errcode;
 	u8 doff, sfdoff;
 
-	int ifidx = 0;
 	bool usechain = bus->use_rxchain;
 
 	struct brcmf_sdio_read rd_new;
@@ -1386,13 +1385,6 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				skb_unlink(pfirst, &bus->glom);
 				brcmu_pkt_buf_free_skb(pfirst);
 				continue;
-			} else if (brcmf_proto_hdrpull(bus->sdiodev->dev,
-						       &ifidx, pfirst) != 0) {
-				brcmf_err("rx protocol error\n");
-				bus->sdiodev->bus_if->dstats.rx_errors++;
-				skb_unlink(pfirst, &bus->glom);
-				brcmu_pkt_buf_free_skb(pfirst);
-				continue;
 			}
 
 			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
@@ -1405,7 +1397,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		}
 		/* sent any remaining packets up */
 		if (bus->glom.qlen)
-			brcmf_rx_frames(bus->sdiodev->dev, ifidx, &bus->glom);
+			brcmf_rx_frames(bus->sdiodev->dev, &bus->glom);
 
 		bus->sdcnt.rxglomframes++;
 		bus->sdcnt.rxglompkts += bus->glom.qlen;
@@ -1560,7 +1552,6 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 	u16 pad;		/* Number of pad bytes to read */
 	uint rxleft = 0;	/* Remaining number of frames allowed */
 	int sdret;		/* Return code from calls */
-	int ifidx = 0;
 	uint rxcount = 0;	/* Total frames read */
 	struct brcmf_sdio_read *rd = &bus->cur_read, rd_new;
 	u8 head_read = 0;
@@ -1759,17 +1750,11 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		if (pkt->len == 0) {
 			brcmu_pkt_buf_free_skb(pkt);
 			continue;
-		} else if (brcmf_proto_hdrpull(bus->sdiodev->dev, &ifidx,
-			   pkt) != 0) {
-			brcmf_err("rx protocol error\n");
-			brcmu_pkt_buf_free_skb(pkt);
-			bus->sdiodev->bus_if->dstats.rx_errors++;
-			continue;
 		}
 
 		skb_queue_head_init(&pktlist);
 		skb_queue_tail(&pktlist, pkt);
-		brcmf_rx_frames(bus->sdiodev->dev, ifidx, &pktlist);
+		brcmf_rx_frames(bus->sdiodev->dev, &pktlist);
 	}
 
 	rxcount = maxframes - rxleft;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 34342ff..e15630c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -444,14 +444,14 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	struct brcmf_usbdev_info *devinfo = req->devinfo;
 	struct sk_buff *skb;
 	struct sk_buff_head skbq;
-	int ifidx = 0;
 
 	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
 	brcmf_usb_del_fromq(devinfo, req);
 	skb = req->skb;
 	req->skb = NULL;
 
-	if (urb->status == 0) {
+	/* zero lenght packets indicate usb "failure". Do not refill */
+	if (urb->status == 0 && urb->actual_length) {
 		devinfo->bus_pub.bus->dstats.rx_packets++;
 	} else {
 		devinfo->bus_pub.bus->dstats.rx_errors++;
@@ -464,17 +464,8 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 		skb_queue_head_init(&skbq);
 		skb_queue_tail(&skbq, skb);
 		skb_put(skb, urb->actual_length);
-		if (brcmf_proto_hdrpull(devinfo->dev, &ifidx, skb) != 0) {
-			brcmf_err("rx protocol error\n");
-			brcmu_pkt_buf_free_skb(skb);
-			devinfo->bus_pub.bus->dstats.rx_errors++;
-		} else
-			brcmf_rx_frames(devinfo->dev, ifidx, &skbq);
-		/* zero lenght packets indicate usb "failure". Do not refill */
-		if (urb->actual_length)
-			brcmf_usb_rx_refill(devinfo, req);
-		else
-			brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
+		brcmf_rx_frames(devinfo->dev, &skbq);
+		brcmf_usb_rx_refill(devinfo, req);
 	} else {
 		brcmu_pkt_buf_free_skb(skb);
 		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req, NULL);
-- 
1.7.10.4


