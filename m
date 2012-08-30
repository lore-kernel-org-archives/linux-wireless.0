Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4989 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab2H3IF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 04:05:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/4] brcmfmac: fix use of dev_kfree_skb() in irq context
Date: Thu, 30 Aug 2012 10:05:34 +0200
Message-ID: <1346313937-3605-2-git-send-email-arend@broadcom.com> (sfid-20120830_100609_177825_A90FB47A)
In-Reply-To: <1346313937-3605-1-git-send-email-arend@broadcom.com>
References: <1346313937-3605-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The USB part of the brcmfmac did a dev_kfree_skb() that resulted
in a warning in net/core/skbuff.c:

Jul 11 04:53:33 lb-bun-10 kernel: [53282.667745] WARNING: at
net/core/skbuff.c:490 skb_release_head_state+0xcc/0xe0()

The brcmutil modules provides brcmu_pkt_buf_free_skb() which takes
the context into account. This patch makes use of this function
instead of dev_kfree_skb().

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index a299d42..f72dfb7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -519,7 +519,7 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 	else
 		devinfo->bus_pub.bus->dstats.tx_errors++;
 
-	dev_kfree_skb(req->skb);
+	brcmu_pkt_buf_free_skb(req->skb);
 	req->skb = NULL;
 	brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req);
 
@@ -540,7 +540,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 		devinfo->bus_pub.bus->dstats.rx_packets++;
 	} else {
 		devinfo->bus_pub.bus->dstats.rx_errors++;
-		dev_kfree_skb(skb);
+		brcmu_pkt_buf_free_skb(skb);
 		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
 		return;
 	}
@@ -556,7 +556,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 			brcmf_usb_rx_refill(devinfo, req);
 		}
 	} else {
-		dev_kfree_skb(skb);
+		brcmu_pkt_buf_free_skb(skb);
 	}
 	return;
 
@@ -588,7 +588,7 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 	if (ret == 0) {
 		brcmf_usb_enq(devinfo, &devinfo->rx_postq, req);
 	} else {
-		dev_kfree_skb(req->skb);
+		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
 		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
 	}
-- 
1.7.9.5


