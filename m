Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36778 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdCCHJa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 02:09:30 -0500
Received: by mail-lf0-f66.google.com with SMTP id g70so6339714lfh.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Mar 2017 23:09:01 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4.12 V2] brcmfmac: move brcmf_txcomplete function to fwsignal.c
Date: Fri,  3 Mar 2017 07:38:33 +0100
Message-Id: <20170303063833.20466-1-zajec5@gmail.com> (sfid-20170303_081059_711071_A2B5C5FE)
In-Reply-To: <20170227124251.30338-1-zajec5@gmail.com>
References: <20170227124251.30338-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This function is called by USB and SDIO only, both using BCDC & FW
Signalling. Move it out of core.c to make this file more generic and
allow making fwsignal optional in the future.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Make code with this patch compile when not based on top of (to be dropped)
[PATCH 4.12] brcmfmac: get rid of brcmf_txflowblock helper function
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  3 ---
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c    | 18 ------------------
 .../wireless/broadcom/brcm80211/brcmfmac/fwsignal.c    | 18 ++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/fwsignal.h    |  9 +++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  3 ++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  3 ++-
 6 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 76693df34742..059e40fdc3d5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -232,9 +232,6 @@ void brcmf_dev_reset(struct device *dev);
 /* Indication from bus module to change flow-control state */
 void brcmf_txflowblock(struct device *dev, bool state);
 
-/* Notify the bus has transferred the tx packet to firmware */
-void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
-
 /* Configure the "global" bus state used by upper layers */
 void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 2f2f3a5ad86a..45ed24049b37 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -393,24 +393,6 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
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
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 5f1a5929cb30..07f0b3cfd59c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2445,6 +2445,24 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 	return fws->fcmode != BRCMF_FWS_FCMODE_NONE;
 }
 
+void brcmf_fws_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
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
+		if (brcmf_proto_hdrpull(drvr, false, txp, &ifp))
+			brcmu_pkt_buf_free_skb(txp);
+		else
+			brcmf_txfinalize(ifp, txp, success);
+	}
+}
+
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
 	u32 hslot;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
index 96df66073b2a..d534164785de 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -18,6 +18,10 @@
 #ifndef FWSIGNAL_H_
 #define FWSIGNAL_H_
 
+struct brcmf_fws_info;
+struct brcmf_if;
+struct brcmf_pub;
+
 int brcmf_fws_init(struct brcmf_pub *drvr);
 void brcmf_fws_deinit(struct brcmf_pub *drvr);
 bool brcmf_fws_queue_skbs(struct brcmf_fws_info *fws);
@@ -28,6 +32,11 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_fws_reset_interface(struct brcmf_if *ifp);
 void brcmf_fws_add_interface(struct brcmf_if *ifp);
 void brcmf_fws_del_interface(struct brcmf_if *ifp);
+
+/* Notify the bus has transferred the tx packet to firmware */
+void brcmf_fws_txcomplete(struct device *dev, struct sk_buff *txp,
+			  bool success);
+
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb);
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked);
 void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index c5744b45ec8f..22d21643ed8c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -42,6 +42,7 @@
 #include "sdio.h"
 #include "chip.h"
 #include "firmware.h"
+#include "fwsignal.h"
 #include "core.h"
 #include "common.h"
 
@@ -2265,7 +2266,7 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		bus->tx_seq = (bus->tx_seq + pktq->qlen) % SDPCM_SEQ_WRAP;
 	skb_queue_walk_safe(pktq, pkt_next, tmp) {
 		__skb_unlink(pkt_next, pktq);
-		brcmf_txcomplete(bus->sdiodev->dev, pkt_next, ret == 0);
+		brcmf_fws_txcomplete(bus->sdiodev->dev, pkt_next, ret == 0);
 	}
 	return ret;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index d93ebbdc7737..676c28081dc5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -26,6 +26,7 @@
 #include "bus.h"
 #include "debug.h"
 #include "firmware.h"
+#include "fwsignal.h"
 #include "usb.h"
 #include "core.h"
 #include "common.h"
@@ -482,7 +483,7 @@ static void brcmf_usb_tx_complete(struct urb *urb)
 		  req->skb);
 	brcmf_usb_del_fromq(devinfo, req);
 
-	brcmf_txcomplete(devinfo->dev, req->skb, urb->status == 0);
+	brcmf_fws_txcomplete(devinfo->dev, req->skb, urb->status == 0);
 	req->skb = NULL;
 	brcmf_usb_enq(devinfo, &devinfo->tx_freeq, req, &devinfo->tx_freecount);
 	spin_lock_irqsave(&devinfo->tx_flowblock_lock, flags);
-- 
2.11.0
