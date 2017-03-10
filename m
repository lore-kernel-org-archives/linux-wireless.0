Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46003 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933565AbdCJVR0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 16:17:26 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/5] brcmfmac: move brcmf_txcomplete to bcdc layer
Date: Fri, 10 Mar 2017 21:17:03 +0000
Message-Id: <1489180626-6722-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170310_221741_063644_37DF6E7D)
In-Reply-To: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1489180626-6722-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

brcmf_txcomplete is invoked by sdio and usb bus module which are using
bcdc protocol. So move it from core module into bcdc layer.

Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 20 ++++++++++++++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h  |  2 ++
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h   |  3 ---
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c  | 18 ------------------
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  |  3 ++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c   |  2 +-
 6 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 4c7dafa..bee70f3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -355,6 +355,26 @@ void brcmf_proto_bcdc_txflowblock(struct device *dev, bool state)
 	brcmf_fws_bus_blocked(drvr, state);
 }
 
+void
+brcmf_proto_bcdc_txcomplete(struct device *dev, struct sk_buff *txp,
+			    bool success)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_if *ifp;
+
+	/* await txstatus signal for firmware if active */
+	if (brcmf_fws_fc_active(drvr->fws)) {
+		if (!success)
+			brcmf_fws_bustxfail(drvr->fws, txp);
+	} else {
+		if (brcmf_proto_bcdc_hdrpull(drvr, false, txp, &ifp))
+			brcmu_pkt_buf_free_skb(txp);
+		else
+			brcmf_txfinalize(ifp, txp, success);
+	}
+}
+
 static void
 brcmf_proto_bcdc_configure_addr_mode(struct brcmf_pub *drvr, int ifidx,
 				     enum proto_addr_mode addr_mode)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
index b5282cb..b6fa7a8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
@@ -20,6 +20,8 @@
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr);
 void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr);
 void brcmf_proto_bcdc_txflowblock(struct device *dev, bool state);
+void brcmf_proto_bcdc_txcomplete(struct device *dev, struct sk_buff *txp,
+				 bool success);
 #else
 static inline int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr) { return 0; }
 static inline void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr) {}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index eeb6643..b55c329 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -230,9 +230,6 @@ int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
 /* Indication from bus module that dongle should be reset */
 void brcmf_dev_reset(struct device *dev);
 
-/* Notify the bus has transferred the tx packet to firmware */
-void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
-
 /* Configure the "global" bus state used by upper layers */
 void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index b4ed60d..a68e1af 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -383,24 +383,6 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 	brcmu_pkt_buf_free_skb(txp);
 }
 
-void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
-{
-	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
-	struct brcmf_if *ifp;
-
-	/* await txstatus signal for firmware if active */
-	if (brcmf_fws_fc_active(drvr->fws)) {
-		if (!success)
-			brcmf_fws_bustxfail(drvr->fws, txp);
-	} else {
-		if (brcmf_proto_hdrpull(drvr, false, txp, &ifp))
-			brcmu_pkt_buf_free_skb(txp);
-		else
-			brcmf_txfinalize(ifp, txp, success);
-	}
-}
-
 static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 				    struct ethtool_drvinfo *info)
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 2a38dd3..a999f95 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2266,7 +2266,8 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		bus->tx_seq = (bus->tx_seq + pktq->qlen) % SDPCM_SEQ_WRAP;
 	skb_queue_walk_safe(pktq, pkt_next, tmp) {
 		__skb_unlink(pkt_next, pktq);
-		brcmf_txcomplete(bus->sdiodev->dev, pkt_next, ret == 0);
+		brcmf_proto_bcdc_txcomplete(bus->sdiodev->dev, pkt_next,
+					    ret == 0);
 	}
 	return ret;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index c45c7c1..e4d545f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -483,7 +483,7 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 		  req->skb);
 	brcmf_usb_del_fromq(devinfo, req);
 
-	brcmf_txcomplete(devinfo->dev, req->skb, urb->status == 0);
+	brcmf_proto_bcdc_txcomplete(devinfo->dev, req->skb, urb->status == 0);
 	req->skb = NULL;
 	brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req, &devinfo->tx_freecount);
 	spin_lock_irqsave(&devinfo->tx_flowblock_lock, flags);
-- 
1.9.1
