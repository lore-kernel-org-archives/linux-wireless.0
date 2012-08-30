Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4997 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab2H3IF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 04:05:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/4] brcmfmac: fix race condition for rx and tx data.
Date: Thu, 30 Aug 2012 10:05:36 +0200
Message-ID: <1346313937-3605-4-git-send-email-arend@broadcom.com> (sfid-20120830_100605_036286_C2BE7CA5)
In-Reply-To: <1346313937-3605-1-git-send-email-arend@broadcom.com>
References: <1346313937-3605-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

On both rx and tx there is was a race condition on the queueing
of usb requests. When for example frame gets submitted it is
possible that complete function gets called even before
usb_submit_urb() returns. As a result it is possible that usb
requests get losts, which was noticed on OMAP4 pandaboard
platform. This patch fixes the race condition.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 8ea2db7..58f89fa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -550,6 +550,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 		if (brcmf_proto_hdrpull(devinfo->dev, &ifidx, skb) != 0) {
 			brcmf_dbg(ERROR, "rx protocol error\n");
 			brcmu_pkt_buf_free_skb(skb);
+			brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
 			devinfo->bus_pub.bus->dstats.rx_errors++;
 		} else {
 			brcmf_rx_packet(devinfo->dev, ifidx, skb);
@@ -557,6 +558,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 		}
 	} else {
 		brcmu_pkt_buf_free_skb(skb);
+		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
 	}
 	return;
 
@@ -582,11 +584,11 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 			  skb->data, skb_tailroom(skb), brcmf_usb_rx_complete,
 			  req);
 	req->devinfo = devinfo;
+	brcmf_usb_enq(devinfo, &devinfo->rx_postq, req);
 
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
-	if (ret == 0) {
-		brcmf_usb_enq(devinfo, &devinfo->rx_postq, req);
-	} else {
+	if (ret) {
+		brcmf_usb_del_fromq(devinfo, req);
 		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
 		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
@@ -682,23 +684,22 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 
 	req = brcmf_usb_deq(devinfo, &devinfo->tx_freeq);
 	if (!req) {
+		brcmu_pkt_buf_free_skb(skb);
 		brcmf_dbg(ERROR, "no req to send\n");
 		return -ENOMEM;
 	}
-	if (!req->urb) {
-		brcmf_dbg(ERROR, "no urb for req %p\n", req);
-		return -ENOBUFS;
-	}
 
 	req->skb = skb;
 	req->devinfo = devinfo;
 	usb_fill_bulk_urb(req->urb, devinfo->usbdev, devinfo->tx_pipe,
 			  skb->data, skb->len, brcmf_usb_tx_complete, req);
 	req->urb->transfer_flags |= URB_ZERO_PACKET;
+	brcmf_usb_enq(devinfo, &devinfo->tx_postq, req);
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
-	if (!ret) {
-		brcmf_usb_enq(devinfo, &devinfo->tx_postq, req);
-	} else {
+	if (ret) {
+		brcmf_dbg(ERROR, "brcmf_usb_tx usb_submit_urb FAILED\n");
+		brcmf_usb_del_fromq(devinfo, req);
+		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
 		brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req);
 	}
-- 
1.7.9.5


