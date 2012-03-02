Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2170 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab2CBV4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:56:10 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/7] brcm80211: fmac: use counters in brcmf_bus
 structure
Date: Fri, 2 Mar 2012 22:55:47 +0100
Message-ID: <1330725351-3803-4-git-send-email-arend@broadcom.com> (sfid-20120302_225615_303488_A5724A32)
In-Reply-To: <1330725351-3803-1-git-send-email-arend@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The usb code defines a structure for counting statistics. However,
it should use the statistics entry provided in brcmf_bus as that is
exposed to the net_device. The usb private statistics counter only
remains with counters for control packets between driver and usb
device.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    8 ++++----
 drivers/net/wireless/brcm80211/brcmfmac/usb.h |   11 -----------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 0418a40..a2a0c45 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -514,9 +514,9 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 
 	brcmf_usb_del_fromq(devinfo, req);
 	if (urb->status == 0)
-		devinfo->bus_pub.stats.tx_packets++;
+		devinfo->bus_pub.bus->dstats.tx_packets++;
 	else
-		devinfo->bus_pub.stats.tx_errors++;
+		devinfo->bus_pub.bus->dstats.tx_errors++;
 
 	dev_kfree_skb(req->skb);
 	req->skb = NULL;
@@ -536,9 +536,9 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 	req->skb = NULL;
 
 	if (urb->status == 0) {
-		devinfo->bus_pub.stats.rx_packets++;
+		devinfo->bus_pub.bus->dstats.rx_packets++;
 	} else {
-		devinfo->bus_pub.stats.rx_errors++;
+		devinfo->bus_pub.bus->dstats.rx_errors++;
 		dev_kfree_skb(skb);
 		brcmf_usb_enq(devinfo, &devinfo->rx_freeq, req);
 		return;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.h b/drivers/net/wireless/brcm80211/brcmfmac/usb.h
index 3377d63..acfa5e8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.h
@@ -33,21 +33,10 @@ enum brcmf_usb_pnp_state {
 };
 
 struct brcmf_stats {
-	u32 tx_errors;
-	u32 tx_packets;
-	u32 tx_multicast;
 	u32 tx_ctlpkts;
 	u32 tx_ctlerrs;
-	u32 tx_dropped;
-	u32 tx_flushed;
-	u32 rx_errors;
-	u32 rx_packets;
-	u32 rx_multicast;
 	u32 rx_ctlpkts;
 	u32 rx_ctlerrs;
-	u32 rx_dropped;
-	u32 rx_flushed;
-
 };
 
 struct brcmf_usbdev {
-- 
1.7.5.4


