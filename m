Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30636 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbcDKJfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 05:35:41 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/8] brcmfmac: revise handling events in receive path
Date: Mon, 11 Apr 2016 11:35:27 +0200
Message-Id: <1460367328-12082-8-git-send-email-arend@broadcom.com> (sfid-20160411_113544_214766_BFE9DB7D)
In-Reply-To: <1460367328-12082-1-git-send-email-arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move event handling out of brcmf_netif_rx() avoiding the need
to pass a flag. This flag is only ever true for USB hosts as
other interface use separate brcmf_rx_event() function.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 24 +++++++++++-----------
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  3 +--
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  8 ++++----
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  2 +-
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 31856eb..2b24654 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -216,7 +216,7 @@ bool brcmf_c_prec_enq(struct device *dev, struct pktq *q, struct sk_buff *pkt,
 		      int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_evnt);
+void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp, bool handle_event);
 /* Receive async event packet from firmware. Callee disposes of rxp. */
 void brcmf_rx_event(struct device *dev, struct sk_buff *rxp);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index a30841b..9b53555 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -298,18 +298,11 @@ void brcmf_txflowblock(struct device *dev, bool state)
 	brcmf_fws_bus_blocked(drvr, state);
 }
 
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
-		    bool handle_event)
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
 {
-	skb->protocol = eth_type_trans(skb, ifp->ndev);
-
 	if (skb->pkt_type == PACKET_MULTICAST)
 		ifp->stats.multicast++;
 
-	/* Process special event packets */
-	if (handle_event)
-		brcmf_fweh_process_skb(ifp->drvr, skb);
-
 	if (!(ifp->ndev->flags & IFF_UP)) {
 		brcmu_pkt_buf_free_skb(skb);
 		return;
@@ -329,7 +322,7 @@ void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
 		netif_rx_ni(skb);
 }
 
-void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_evnt)
+void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_event)
 {
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -348,10 +341,17 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb, bool handle_evnt)
 		return;
 	}
 
-	if (brcmf_proto_is_reorder_skb(skb))
+	skb->protocol = eth_type_trans(skb, ifp->ndev);
+
+	if (brcmf_proto_is_reorder_skb(skb)) {
 		brcmf_proto_rxreorder(ifp, skb);
-	else
-		brcmf_netif_rx(ifp, skb, handle_evnt);
+	} else {
+		/* Process special event packets */
+		if (handle_event)
+			brcmf_fweh_process_skb(ifp->drvr, skb);
+
+		brcmf_netif_rx(ifp, skb);
+	}
 }
 
 void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 394ae05..241ee8d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -221,8 +221,7 @@ int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
-void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb,
-		    bool handle_event);
+void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 int __init brcmf_core_init(void);
 void __exit brcmf_core_exit(void);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 8a07687..5b30922 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1668,7 +1668,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 	/* validate flags and flow id */
 	if (flags == 0xFF) {
 		brcmf_err("invalid flags...so ignore this packet\n");
-		brcmf_netif_rx(ifp, pkt, false);
+		brcmf_netif_rx(ifp, pkt);
 		return;
 	}
 
@@ -1680,7 +1680,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 		if (rfi == NULL) {
 			brcmf_dbg(INFO, "received flags to cleanup, but no flow (%d) yet\n",
 				  flow_id);
-			brcmf_netif_rx(ifp, pkt, false);
+			brcmf_netif_rx(ifp, pkt);
 			return;
 		}
 
@@ -1705,7 +1705,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 		rfi = kzalloc(buf_size, GFP_ATOMIC);
 		if (rfi == NULL) {
 			brcmf_err("failed to alloc buffer\n");
-			brcmf_netif_rx(ifp, pkt, false);
+			brcmf_netif_rx(ifp, pkt);
 			return;
 		}
 
@@ -1819,7 +1819,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 netif_rx:
 	skb_queue_walk_safe(&reorder_list, pkt, pnext) {
 		__skb_unlink(pkt, &reorder_list);
-		brcmf_netif_rx(ifp, pkt, false);
+		brcmf_netif_rx(ifp, pkt);
 	}
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 8c064ab..68f1ce0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1157,7 +1157,7 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
-	brcmf_netif_rx(ifp, skb, false);
+	brcmf_netif_rx(ifp, skb);
 }
 
 
-- 
1.9.1

