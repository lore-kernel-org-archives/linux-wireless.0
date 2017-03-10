Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46006 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933631AbdCJVR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 16:17:26 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/5] brcmfmac: move brcmf_txflowblock to bcdc layer
Date: Fri, 10 Mar 2017 21:17:02 +0000
Message-Id: <1489180626-6722-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170310_221744_094231_AB51E9EA)
In-Reply-To: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

brcmf_txflowblock is invoked by sdio and usb bus module which are using
bcdc protocol. This patch makes it a bcdc API instead of a core module
function.

Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 10 ++++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h |  1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h  |  2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 10 ----------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |  5 +++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c  |  5 +++--
 6 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 384b187..4c7dafa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -345,6 +345,16 @@ static int brcmf_proto_bcdc_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
 	return brcmf_bus_txdata(drvr->bus_if, pktbuf);
 }
 
+void brcmf_proto_bcdc_txflowblock(struct device *dev, bool state)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	brcmf_fws_bus_blocked(drvr, state);
+}
+
 static void
 brcmf_proto_bcdc_configure_addr_mode(struct brcmf_pub *drvr, int ifidx,
 				     enum proto_addr_mode addr_mode)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
index 6003179..b5282cb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
@@ -19,6 +19,7 @@
 #ifdef CONFIG_BRCMFMAC_PROTO_BCDC
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr);
 void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr);
+void brcmf_proto_bcdc_txflowblock(struct device *dev, bool state);
 #else
 static inline int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr) { return 0; }
 static inline void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr) {}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 76693df..eeb6643 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -229,8 +229,6 @@ int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
 void brcmf_detach(struct device *dev);
 /* Indication from bus module that dongle should be reset */
 void brcmf_dev_reset(struct device *dev);
-/* Indication from bus module to change flow-control state */
-void brcmf_txflowblock(struct device *dev, bool state);
 
 /* Notify the bus has transferred the tx packet to firmware */
 void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 60da86a..b4ed60d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -283,16 +283,6 @@ void brcmf_txflowblock_if(struct brcmf_if *ifp,
 	spin_unlock_irqrestore(&ifp->netif_stop_lock, flags);
 }
 
-void brcmf_txflowblock(struct device *dev, bool state)
-{
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	brcmf_fws_bus_blocked(drvr, state);
-}
-
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
 	if (skb->pkt_type == PACKET_MULTICAST)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 6568946..2a38dd3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -44,6 +44,7 @@
 #include "firmware.h"
 #include "core.h"
 #include "common.h"
+#include "bcdc.h"
 
 #define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2500)
 #define CTL_DONE_TIMEOUT	msecs_to_jiffies(2500)
@@ -2328,7 +2329,7 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 	if ((bus->sdiodev->state == BRCMF_SDIOD_DATA) &&
 	    bus->txoff && (pktq_len(&bus->txq) < TXLOW)) {
 		bus->txoff = false;
-		brcmf_txflowblock(bus->sdiodev->dev, false);
+		brcmf_proto_bcdc_txflowblock(bus->sdiodev->dev, false);
 	}
 
 	return cnt;
@@ -2753,7 +2754,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 
 	if (pktq_len(&bus->txq) >= TXHI) {
 		bus->txoff = true;
-		brcmf_txflowblock(dev, true);
+		brcmf_proto_bcdc_txflowblock(dev, true);
 	}
 	spin_unlock_bh(&bus->txq_lock);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index d93ebbd..c45c7c1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -29,6 +29,7 @@
 #include "usb.h"
 #include "core.h"
 #include "common.h"
+#include "bcdc.h"
 
 
 #define IOCTL_RESP_TIMEOUT		msecs_to_jiffies(2000)
@@ -488,7 +489,7 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 	spin_lock_irqsave(&devinfo->tx_flowblock_lock, flags);
 	if (devinfo->tx_freecount > devinfo->tx_high_watermark &&
 		devinfo->tx_flowblock) {
-		brcmf_txflowblock(devinfo->dev, false);
+		brcmf_proto_bcdc_txflowblock(devinfo->dev, false);
 		devinfo->tx_flowblock = false;
 	}
 	spin_unlock_irqrestore(&devinfo->tx_flowblock_lock, flags);
@@ -635,7 +636,7 @@ static int brcmf_usb_tx(struct device *dev, struct sk_buff *skb)
 	spin_lock_irqsave(&devinfo->tx_flowblock_lock, flags);
 	if (devinfo->tx_freecount < devinfo->tx_low_watermark &&
 	    !devinfo->tx_flowblock) {
-		brcmf_txflowblock(dev, true);
+		brcmf_proto_bcdc_txflowblock(dev, true);
 		devinfo->tx_flowblock = true;
 	}
 	spin_unlock_irqrestore(&devinfo->tx_flowblock_lock, flags);
-- 
1.9.1
