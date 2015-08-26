Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:7051 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbHZUPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/12] brcmfmac: pass struct brcmf_if instance in brcmf_txfinalize()
Date: Wed, 26 Aug 2015 22:14:59 +0200
Message-ID: <1440620104-2715-8-git-send-email-arend@broadcom.com> (sfid-20150826_221535_574018_2C636B9F)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most call sites of brcmf_txfinalize already have struct brcmf_if
instance so pass that to brcmf_txfinalize() as the function
needs it anyway.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 12 +++---------
 drivers/net/wireless/brcm80211/brcmfmac/core.h     |  3 +--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 11 ++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  6 +++++-
 4 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index b9ed0ed..cd0bffe 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -560,17 +560,11 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
 		brcmf_netif_rx(ifp, skb);
 }
 
-void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
-		      bool success)
+void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 {
-	struct brcmf_if *ifp;
 	struct ethhdr *eh;
 	u16 type;
 
-	ifp = drvr->iflist[ifidx];
-	if (!ifp)
-		goto done;
-
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 
@@ -582,7 +576,7 @@ void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
 
 	if (!success)
 		ifp->stats.tx_errors++;
-done:
+
 	brcmu_pkt_buf_free_skb(txp);
 }
 
@@ -600,7 +594,7 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 		if (brcmf_proto_hdrpull(drvr, false, txp, &ifp))
 			brcmu_pkt_buf_free_skb(txp);
 		else
-			brcmf_txfinalize(drvr, txp, ifp->ifidx, success);
+			brcmf_txfinalize(ifp, txp, success);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.h b/drivers/net/wireless/brcm80211/brcmfmac/core.h
index 5fb9f4be..576e7ac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.h
@@ -210,8 +210,7 @@ void brcmf_remove_interface(struct brcmf_if *ifp);
 int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
-void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
-		      bool success);
+void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 
 /* Sets dongle media info (drv_version, mac address). */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 0c80c85..dc4844c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1506,7 +1506,7 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, ifp->ifidx,
 						    genbit, seq);
 	if (remove_from_hanger || ret)
-		brcmf_txfinalize(fws->drvr, skb, ifp->ifidx, true);
+		brcmf_txfinalize(ifp, skb, true);
 
 	return 0;
 }
@@ -1905,7 +1905,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	if (fws->avoid_queueing) {
 		rc = brcmf_proto_txdata(drvr, ifp->ifidx, 0, skb);
 		if (rc < 0)
-			brcmf_txfinalize(drvr, skb, ifp->ifidx, false);
+			brcmf_txfinalize(ifp, skb, false);
 		return rc;
 	}
 
@@ -1929,7 +1929,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		brcmf_fws_schedule_deq(fws);
 	} else {
 		brcmf_err("drop skb: no hanger slot\n");
-		brcmf_txfinalize(drvr, skb, ifp->ifidx, false);
+		brcmf_txfinalize(ifp, skb, false);
 		rc = -ENOMEM;
 	}
 	brcmf_fws_unlock(fws);
@@ -2009,8 +2009,9 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 				ret = brcmf_proto_txdata(drvr, ifidx, 0, skb);
 				brcmf_fws_lock(fws);
 				if (ret < 0)
-					brcmf_txfinalize(drvr, skb, ifidx,
-							 false);
+					brcmf_txfinalize(brcmf_get_ifp(drvr,
+								       ifidx),
+							 skb, false);
 				if (fws->bus_flow_blocked)
 					break;
 			}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index d582f69..7eff9de 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -873,7 +873,11 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 	commonring = msgbuf->flowrings[flowid];
 	atomic_dec(&commonring->outstanding_tx);
 
-	brcmf_txfinalize(msgbuf->drvr, skb, tx_status->msg.ifidx, true);
+	/* Hante: i believe this was a bug as tx_status->msg.ifidx was used
+	 * in brcmf_txfinalize as index in drvr->iflist. Can you confirm/deny?
+	 */
+	brcmf_txfinalize(brcmf_get_ifp(msgbuf->drvr, tx_status->msg.ifidx),
+			 skb, true);
 }
 
 
-- 
1.9.1

