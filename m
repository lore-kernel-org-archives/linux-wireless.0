Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1546 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/13] brcmfmac: assure brcmf_txcomplete() is called in
 failure paths
Date: Sun, 3 Mar 2013 12:45:30 +0100
Message-ID: <1362311132-29561-12-git-send-email-arend@broadcom.com> (sfid-20130303_124556_390738_4E37F15B)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For transmit packets the function brcmf_txcomplete() must be
called. This should be done as well when for some reason the
transmit fails to assure proper tx post processing. This patch
fixes the code paths in brcmf_usb_tx() that forgot to do so.

Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   29 ++++++++++++++----------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 28f7764..a14e12f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -571,15 +571,17 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	int ret;
 
 	brcmf_dbg(USB, "Enter, skb=%p\n", skb);
-	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP)
-		return -EIO;
+	if (devinfo->bus_pub.state != BRCMFMAC_USB_STATE_UP) {
+		ret = -EIO;
+		goto fail;
+	}
 
 	req = brcmf_usb_deq(devinfo, &devinfo->tx_freeq,
 					&devinfo->tx_freecount);
 	if (!req) {
-		brcmu_pkt_buf_free_skb(skb);
 		brcmf_err("no req to send\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto fail;
 	}
 
 	req->skb = skb;
@@ -592,18 +594,21 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	if (ret) {
 		brcmf_err("brcmf_usb_tx usb_submit_urb FAILED\n");
 		brcmf_usb_del_fromq(devinfo, req);
-		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
 		brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req,
-						&devinfo->tx_freecount);
-	} else {
-		if (devinfo->tx_freecount < devinfo->tx_low_watermark &&
-			!devinfo->tx_flowblock) {
-			brcmf_txflowblock(dev, true);
-			devinfo->tx_flowblock = true;
-		}
+			      &devinfo->tx_freecount);
+		goto fail;
 	}
 
+	if (devinfo->tx_freecount < devinfo->tx_low_watermark &&
+	    !devinfo->tx_flowblock) {
+		brcmf_txflowblock(dev, true);
+		devinfo->tx_flowblock = true;
+	}
+	return 0;
+
+fail:
+	brcmf_txcomplete(dev, skb, false);
 	return ret;
 }
 
-- 
1.7.6


