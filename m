Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2020 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/13] brcmfmac: release transmit packet in
 brcmf_txcomplete()
Date: Sun, 3 Mar 2013 12:45:29 +0100
Message-ID: <1362311132-29561-11-git-send-email-arend@broadcom.com> (sfid-20130303_131303_198532_F5C7889C)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the bus-specific driver code each call to brcmf_txcomplete() is
following by a free of that packet. This patch moves that free to
the brcmf_txcomplete() function.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    5 ++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   14 +++-----------
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    2 --
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index ad25c34..883ef90 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -134,7 +134,7 @@ extern void brcmf_dev_reset(struct device *dev);
 /* Indication from bus module to change flow-control state */
 extern void brcmf_txflowblock(struct device *dev, bool state);
 
-/* Notify tx completion */
+/* Notify the bus has transferred the tx packet to firmware */
 extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
 			     bool success);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 8e84f90..2110eed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -364,7 +364,7 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 
 	ifp = drvr->iflist[ifidx];
 	if (!ifp)
-		return;
+		goto done;
 
 	if (res == 0) {
 		eh = (struct ethhdr *)(txp->data);
@@ -378,6 +378,9 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 	}
 	if (!success)
 		ifp->stats.tx_errors++;
+
+done:
+	brcmu_pkt_buf_free_skb(txp);
 }
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 84a4eb3..e4d68cb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1776,7 +1776,7 @@ brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
 static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
-			      uint chan, bool free_pkt)
+			      uint chan)
 {
 	int ret;
 	u8 *frame;
@@ -1806,10 +1806,7 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 
 			pkt_align(new, pkt->len, BRCMF_SDALIGN);
 			memcpy(new->data, pkt->data, pkt->len);
-			if (free_pkt)
-				brcmu_pkt_buf_free_skb(pkt);
-			/* free the pkt if canned one is not used */
-			free_pkt = true;
+			brcmu_pkt_buf_free_skb(pkt);
 			pkt = new;
 			frame = (u8 *) (pkt->data);
 			/* precondition: (frame % BRCMF_SDALIGN) == 0) */
@@ -1902,10 +1899,6 @@ done:
 	/* restore pkt buffer pointer before calling tx complete routine */
 	skb_pull(pkt, SDPCM_HDRLEN + pad);
 	brcmf_txcomplete(bus->sdiodev->dev, pkt, ret != 0);
-
-	if (free_pkt)
-		brcmu_pkt_buf_free_skb(pkt);
-
 	return ret;
 }
 
@@ -1933,7 +1926,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 		spin_unlock_bh(&bus->txqlock);
 		datalen = pkt->len - SDPCM_HDRLEN;
 
-		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL, true);
+		ret = brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_DATA_CHANNEL);
 
 		/* In poll mode, need to check for other events */
 		if (!bus->intr && cnt) {
@@ -2344,7 +2337,6 @@ static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	if (!brcmf_c_prec_enq(bus->sdiodev->dev, &bus->txq, pkt, prec)) {
 		skb_pull(pkt, SDPCM_HDRLEN);
 		brcmf_txcomplete(bus->sdiodev->dev, pkt, false);
-		brcmu_pkt_buf_free_skb(pkt);
 		brcmf_err("out of bus->txq !!!\n");
 		ret = -ENOSR;
 	} else {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 2e8f938..28f7764 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -418,8 +418,6 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 	brcmf_usb_del_fromq(devinfo, req);
 
 	brcmf_txcomplete(devinfo->dev, req->skb, urb->status == 0);
-
-	brcmu_pkt_buf_free_skb(req->skb);
 	req->skb = NULL;
 	brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req, &devinfo->tx_freecount);
 	if (devinfo->tx_freecount > devinfo->tx_high_watermark &&
-- 
1.7.6


