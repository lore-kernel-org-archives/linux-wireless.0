Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:51706 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaELIrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:43 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 03/14] brcmfmac: Move out hdrpull from tx_finalize.
Date: Mon, 12 May 2014 10:47:28 +0200
Message-ID: <1399884459-5048-4-git-send-email-arend@broadcom.com> (sfid-20140512_105149_228577_5A364C24)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

In tx_finalize the hdrpull is performed. For the new protocol
msgbuf this is complex, because it does not use protocol headers
in front of payload anymore and therefor can not determine interface
index in the hdr pulll operation. Move out the hdrpull operation
from tx_finalize to make msgbuf implementation easier.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   27 +++++------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   50 +++++++++-----------
 3 files changed, 37 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 939d6b1..16f9ab2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -186,7 +186,7 @@ void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
 u32 brcmf_get_chip_info(struct brcmf_if *ifp);
-void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp,
+void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
 		      bool success);
 
 /* Sets dongle media info (drv_version, mac address). */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 7d28cd3..6056efd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -538,31 +538,26 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
 		brcmf_netif_rx(ifp, skb);
 }
 
-void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp,
+void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp, u8 ifidx,
 		      bool success)
 {
 	struct brcmf_if *ifp;
 	struct ethhdr *eh;
-	u8 ifidx;
 	u16 type;
-	int res;
-
-	res = brcmf_proto_hdrpull(drvr, false, &ifidx, txp);
 
 	ifp = drvr->iflist[ifidx];
 	if (!ifp)
 		goto done;
 
-	if (res == 0) {
-		eh = (struct ethhdr *)(txp->data);
-		type = ntohs(eh->h_proto);
+	eh = (struct ethhdr *)(txp->data);
+	type = ntohs(eh->h_proto);
 
-		if (type == ETH_P_PAE) {
-			atomic_dec(&ifp->pend_8021x_cnt);
-			if (waitqueue_active(&ifp->pend_8021x_wait))
-				wake_up(&ifp->pend_8021x_wait);
-		}
+	if (type == ETH_P_PAE) {
+		atomic_dec(&ifp->pend_8021x_cnt);
+		if (waitqueue_active(&ifp->pend_8021x_wait))
+			wake_up(&ifp->pend_8021x_wait);
 	}
+
 	if (!success)
 		ifp->stats.tx_errors++;
 done:
@@ -573,13 +568,17 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
+	u8 ifidx;
 
 	/* await txstatus signal for firmware if active */
 	if (brcmf_fws_fc_active(drvr->fws)) {
 		if (!success)
 			brcmf_fws_bustxfail(drvr->fws, txp);
 	} else {
-		brcmf_txfinalize(drvr, txp, success);
+		if (brcmf_proto_hdrpull(drvr, false, &ifidx, txp))
+			brcmu_pkt_buf_free_skb(txp);
+		else
+			brcmf_txfinalize(drvr, txp, ifidx, success);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index c3e7d76..bfe7c9a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1369,13 +1369,12 @@ done:
 }
 
 static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
-					 struct sk_buff *skb, u32 genbit,
-					 u16 seq)
+					 struct sk_buff *skb, u8 ifidx,
+					 u32 genbit, u16 seq)
 {
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
 	u32 hslot;
 	int ret;
-	u8 ifidx;
 
 	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 
@@ -1389,29 +1388,21 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 
 	entry->generation = genbit;
 
-	ret = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb);
-	if (ret == 0) {
-		brcmf_skb_htod_tag_set_field(skb, GENERATION, genbit);
-		brcmf_skbcb(skb)->htod_seq = seq;
-		if (brcmf_skb_htod_seq_get_field(skb, FROMFW)) {
-			brcmf_skb_htod_seq_set_field(skb, FROMDRV, 1);
-			brcmf_skb_htod_seq_set_field(skb, FROMFW, 0);
-		} else {
-			brcmf_skb_htod_seq_set_field(skb, FROMDRV, 0);
-		}
-		ret = brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_SUPPRESSED, fifo,
-				    skb);
+	brcmf_skb_htod_tag_set_field(skb, GENERATION, genbit);
+	brcmf_skbcb(skb)->htod_seq = seq;
+	if (brcmf_skb_htod_seq_get_field(skb, FROMFW)) {
+		brcmf_skb_htod_seq_set_field(skb, FROMDRV, 1);
+		brcmf_skb_htod_seq_set_field(skb, FROMFW, 0);
+	} else {
+		brcmf_skb_htod_seq_set_field(skb, FROMDRV, 0);
 	}
+	ret = brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_SUPPRESSED, fifo, skb);
 
 	if (ret != 0) {
-		/* suppress q is full or hdrpull failed, drop this packet */
-		brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
-					true);
+		/* suppress q is full drop this packet */
+		brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb, true);
 	} else {
-		/*
-		 * Mark suppressed to avoid a double free during
-		 * wlfc cleanup
-		 */
+		/* Mark suppressed to avoid a double free during wlfc cleanup */
 		brcmf_fws_hanger_mark_suppressed(&fws->hanger, hslot);
 	}
 
@@ -1428,6 +1419,7 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	struct sk_buff *skb;
 	struct brcmf_skbuff_cb *skcb;
 	struct brcmf_fws_mac_descriptor *entry = NULL;
+	u8 ifidx;
 
 	brcmf_dbg(DATA, "flags %d\n", flags);
 
@@ -1476,12 +1468,15 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	}
 	brcmf_fws_macdesc_return_req_credit(skb);
 
+	if (brcmf_proto_hdrpull(fws->drvr, false, &ifidx, skb)) {
+		brcmu_pkt_buf_free_skb(skb);
+		return -EINVAL;
+	}
 	if (!remove_from_hanger)
-		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, genbit,
-						    seq);
-
+		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, ifidx,
+						    genbit, seq);
 	if (remove_from_hanger || ret)
-		brcmf_txfinalize(fws->drvr, skb, true);
+		brcmf_txfinalize(fws->drvr, skb, ifidx, true);
 
 	return 0;
 }
@@ -1982,7 +1977,8 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 				ret = brcmf_proto_txdata(drvr, ifidx, 0, skb);
 				brcmf_fws_lock(fws);
 				if (ret < 0)
-					brcmf_txfinalize(drvr, skb, false);
+					brcmf_txfinalize(drvr, skb, ifidx,
+							 false);
 				if (fws->bus_flow_blocked)
 					break;
 			}
-- 
1.7.9.5

