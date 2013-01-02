Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3960 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3ABOXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:08 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/18] brcmfmac: remove rx helper function from bus
 interface
Date: Wed, 2 Jan 2013 15:22:42 +0100
Message-ID: <1357136572-18273-10-git-send-email-arend@broadcom.com> (sfid-20130102_152319_738190_F1F863C6)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bus interface provided a wrapper function to pass a single
packet to the common driver part filling a skb queue with one
packet. For clarity the caller now sets up the skb queue and
call the rx bus interface function.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h   |   13 ++-----------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    4 ++--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c  |    7 +++++--
 drivers/net/wireless/brcm80211/brcmfmac/usb.c       |    5 ++++-
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 358b54f..639bc2a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -138,17 +138,8 @@ extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void brcmf_rx_frame(struct device *dev, u8 ifidx,
-			   struct sk_buff_head *rxlist);
-static inline void brcmf_rx_packet(struct device *dev, int ifidx,
-				   struct sk_buff *pkt)
-{
-	struct sk_buff_head q;
-
-	skb_queue_head_init(&q);
-	skb_queue_tail(&q, pkt);
-	brcmf_rx_frame(dev, ifidx, &q);
-}
+extern void brcmf_rx_frames(struct device *dev, u8 ifidx,
+			    struct sk_buff_head *rxlist);
 
 /* Indication from bus module regarding presence/insertion of dongle. */
 extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 6520b58..a820f58 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -248,8 +248,8 @@ void brcmf_txflowblock(struct device *dev, bool state)
 		}
 }
 
-void brcmf_rx_frame(struct device *dev, u8 ifidx,
-		    struct sk_buff_head *skb_list)
+void brcmf_rx_frames(struct device *dev, u8 ifidx,
+		     struct sk_buff_head *skb_list)
 {
 	unsigned char *eth;
 	uint len;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 651474b..13ea9b4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1405,7 +1405,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		}
 		/* sent any remaining packets up */
 		if (bus->glom.qlen)
-			brcmf_rx_frame(bus->sdiodev->dev, ifidx, &bus->glom);
+			brcmf_rx_frames(bus->sdiodev->dev, ifidx, &bus->glom);
 
 		bus->sdcnt.rxglomframes++;
 		bus->sdcnt.rxglompkts += bus->glom.qlen;
@@ -1556,6 +1556,7 @@ static void brcmf_pad(struct brcmf_sdio *bus, u16 *pad, u16 *rdlen)
 static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 {
 	struct sk_buff *pkt;		/* Packet for event or data frames */
+	struct sk_buff_head pktlist;	/* needed for bus interface */
 	u16 pad;		/* Number of pad bytes to read */
 	uint rxleft = 0;	/* Remaining number of frames allowed */
 	int sdret;		/* Return code from calls */
@@ -1766,7 +1767,9 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 			continue;
 		}
 
-		brcmf_rx_packet(bus->sdiodev->dev, ifidx, pkt);
+		skb_queue_head_init(&pktlist);
+		skb_queue_tail(&pktlist, pkt);
+		brcmf_rx_frames(bus->sdiodev->dev, ifidx, &pktlist);
 	}
 
 	rxcount = maxframes - rxleft;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 1df8595..34342ff 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -443,6 +443,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	struct brcmf_usbreq  *req = (struct brcmf_usbreq *)urb->context;
 	struct brcmf_usbdev_info *devinfo = req->devinfo;
 	struct sk_buff *skb;
+	struct sk_buff_head skbq;
 	int ifidx = 0;
 
 	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
@@ -460,13 +461,15 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	}
 
 	if (devinfo->bus_pub.state == BRCMFMAC_USB_STATE_UP) {
+		skb_queue_head_init(&skbq);
+		skb_queue_tail(&skbq, skb);
 		skb_put(skb, urb->actual_length);
 		if (brcmf_proto_hdrpull(devinfo->dev, &ifidx, skb) != 0) {
 			brcmf_err("rx protocol error\n");
 			brcmu_pkt_buf_free_skb(skb);
 			devinfo->bus_pub.bus->dstats.rx_errors++;
 		} else
-			brcmf_rx_packet(devinfo->dev, ifidx, skb);
+			brcmf_rx_frames(devinfo->dev, ifidx, &skbq);
 		/* zero lenght packets indicate usb "failure". Do not refill */
 		if (urb->actual_length)
 			brcmf_usb_rx_refill(devinfo, req);
-- 
1.7.10.4


