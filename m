Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:46770 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754854AbdDFMPA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 08:15:00 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/6] brcmfmac: remove reference to fwsignal data from struct brcmf_pub
Date: Thu,  6 Apr 2017 13:14:39 +0100
Message-Id: <1491480882-13877-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170406_141516_125340_2ADE6036)
In-Reply-To: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1491480882-13877-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fwsignal module is part of the bcdc protocol and as such does
its instance data is not needed in core structure. Moving it into
struct brcmf_bcdc instead.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    | 35 +++++++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.h    |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 -
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 51 ++++++++++------------
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |  4 +-
 5 files changed, 54 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 9628084..9f2d0b0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -103,9 +103,17 @@ struct brcmf_bcdc {
 	u8 bus_header[BUS_HEADER_LEN];
 	struct brcmf_proto_bcdc_dcmd msg;
 	unsigned char buf[BRCMF_DCMD_MAXLEN];
+	struct brcmf_fws_info *fws;
 };
 
 
+struct brcmf_fws_info *drvr_to_fws(struct brcmf_pub *drvr)
+{
+	struct brcmf_bcdc *bcdc = drvr->proto->pd;
+
+	return bcdc->fws;
+}
+
 static int
 brcmf_proto_bcdc_msg(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
 		     uint len, bool set)
@@ -330,8 +338,9 @@ static int brcmf_proto_bcdc_tx_queue_data(struct brcmf_pub *drvr, int ifidx,
 					  struct sk_buff *skb)
 {
 	struct brcmf_if *ifp = brcmf_get_ifp(drvr, ifidx);
+	struct brcmf_bcdc *bcdc = drvr->proto->pd;
 
-	if (!brcmf_fws_queue_skbs(drvr->fws))
+	if (!brcmf_fws_queue_skbs(bcdc->fws))
 		return brcmf_proto_txdata(drvr, ifidx, 0, skb);
 
 	return brcmf_fws_process_skb(ifp, skb);
@@ -360,15 +369,15 @@ void brcmf_proto_bcdc_txflowblock(struct device *dev, bool state)
 			    bool success)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_bcdc *bcdc = bus_if->drvr->proto->pd;
 	struct brcmf_if *ifp;
 
 	/* await txstatus signal for firmware if active */
-	if (brcmf_fws_fc_active(drvr->fws)) {
+	if (brcmf_fws_fc_active(bcdc->fws)) {
 		if (!success)
-			brcmf_fws_bustxfail(drvr->fws, txp);
+			brcmf_fws_bustxfail(bcdc->fws, txp);
 	} else {
-		if (brcmf_proto_bcdc_hdrpull(drvr, false, txp, &ifp))
+		if (brcmf_proto_bcdc_hdrpull(bus_if->drvr, false, txp, &ifp))
 			brcmu_pkt_buf_free_skb(txp);
 		else
 			brcmf_txfinalize(ifp, txp, success);
@@ -420,7 +429,15 @@ static void brcmf_proto_bcdc_rxreorder(struct brcmf_if *ifp,
 static int
 brcmf_proto_bcdc_init_done(struct brcmf_pub *drvr)
 {
-	return brcmf_fws_attach(drvr);
+	struct brcmf_bcdc *bcdc = drvr->proto->pd;
+	struct brcmf_fws_info *fws;
+
+	fws = brcmf_fws_attach(drvr);
+	if (IS_ERR(fws))
+		return PTR_ERR(fws);
+
+	bcdc->fws = fws;
+	return 0;
 }
 
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
@@ -464,7 +481,9 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 
 void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr)
 {
-	brcmf_fws_detach(drvr);
-	kfree(drvr->proto->pd);
+	struct brcmf_bcdc *bcdc = drvr->proto->pd;
+
 	drvr->proto->pd = NULL;
+	brcmf_fws_detach(bcdc->fws);
+	kfree(bcdc);
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
index b6fa7a8..3b0e9ef 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.h
@@ -22,6 +22,7 @@
 void brcmf_proto_bcdc_txflowblock(struct device *dev, bool state);
 void brcmf_proto_bcdc_txcomplete(struct device *dev, struct sk_buff *txp,
 				 bool success);
+struct brcmf_fws_info *drvr_to_fws(struct brcmf_pub *drvr);
 #else
 static inline int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr) { return 0; }
 static inline void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr) {}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 6aecd8d..a4dd313 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -127,8 +127,6 @@ struct brcmf_pub {
 
 	struct brcmf_fweh_info fweh;
 
-	struct brcmf_fws_info *fws;
-
 	struct brcmf_ampdu_rx_reorder
 		*reorder_flows[BRCMF_AMPDU_RX_REORDER_MAXFLOWS];
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 23b2b3f..72373e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -36,6 +36,7 @@
 #include "p2p.h"
 #include "cfg80211.h"
 #include "proto.h"
+#include "bcdc.h"
 #include "common.h"
 
 /**
@@ -1586,7 +1587,7 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 				       const struct brcmf_event_msg *e,
 				       void *data)
 {
-	struct brcmf_fws_info *fws = ifp->drvr->fws;
+	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
 	int i;
 	u8 *credits = data;
 
@@ -1617,7 +1618,7 @@ static int brcmf_fws_notify_bcmc_credit_support(struct brcmf_if *ifp,
 						const struct brcmf_event_msg *e,
 						void *data)
 {
-	struct brcmf_fws_info *fws = ifp->drvr->fws;
+	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
 
 	if (fws) {
 		brcmf_fws_lock(fws);
@@ -1826,7 +1827,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 siglen, struct sk_buff *skb)
 {
 	struct brcmf_skb_reorder_data *rd;
-	struct brcmf_fws_info *fws = ifp->drvr->fws;
+	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
 	u8 *signal_data;
 	s16 data_len;
 	u8 type;
@@ -2091,8 +2092,7 @@ static int brcmf_fws_assign_htod(struct brcmf_fws_info *fws, struct sk_buff *p,
 
 int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 {
-	struct brcmf_pub *drvr = ifp->drvr;
-	struct brcmf_fws_info *fws = drvr->fws;
+	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(skb);
 	struct ethhdr *eh = (struct ethhdr *)(skb->data);
 	int fifo = BRCMF_FWS_FIFO_BCMC;
@@ -2142,7 +2142,7 @@ void brcmf_fws_reset_interface(struct brcmf_if *ifp)
 
 void brcmf_fws_add_interface(struct brcmf_if *ifp)
 {
-	struct brcmf_fws_info *fws = ifp->drvr->fws;
+	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
 	struct brcmf_fws_mac_descriptor *entry;
 
 	if (!ifp->ndev || fws->fcmode == BRCMF_FWS_FCMODE_NONE)
@@ -2160,16 +2160,17 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 void brcmf_fws_del_interface(struct brcmf_if *ifp)
 {
 	struct brcmf_fws_mac_descriptor *entry = ifp->fws_desc;
+	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
 
 	if (!entry)
 		return;
 
-	brcmf_fws_lock(ifp->drvr->fws);
+	brcmf_fws_lock(fws);
 	ifp->fws_desc = NULL;
 	brcmf_dbg(TRACE, "deleting %s\n", entry->name);
 	brcmf_fws_macdesc_deinit(entry);
-	brcmf_fws_cleanup(ifp->drvr->fws, ifp->ifidx);
-	brcmf_fws_unlock(ifp->drvr->fws);
+	brcmf_fws_cleanup(fws, ifp->ifidx);
+	brcmf_fws_unlock(fws);
 }
 
 static void brcmf_fws_dequeue_worker(struct work_struct *worker)
@@ -2243,7 +2244,7 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 static int brcmf_debugfs_fws_stats_read(struct seq_file *seq, void *data)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
-	struct brcmf_fws_stats *fwstats = &bus_if->drvr->fws->stats;
+	struct brcmf_fws_stats *fwstats = &(drvr_to_fws(bus_if->drvr)->stats);
 
 	seq_printf(seq,
 		   "header_pulls:      %u\n"
@@ -2308,7 +2309,7 @@ static int brcmf_debugfs_fws_stats_read(struct seq_file *seq, void *data)
 }
 #endif
 
-int brcmf_fws_attach(struct brcmf_pub *drvr)
+struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr)
 {
 	struct brcmf_fws_info *fws;
 	struct brcmf_if *ifp;
@@ -2316,17 +2317,15 @@ int brcmf_fws_attach(struct brcmf_pub *drvr)
 	int rc;
 	u32 mode;
 
-	drvr->fws = kzalloc(sizeof(*(drvr->fws)), GFP_KERNEL);
-	if (!drvr->fws) {
+	fws = kzalloc(sizeof(*fws), GFP_KERNEL);
+	if (!fws) {
 		rc = -ENOMEM;
 		goto fail;
 	}
 
-	fws = drvr->fws;
-
 	spin_lock_init(&fws->spinlock);
 
-	/* set linkage back */
+	/* store drvr reference */
 	fws->drvr = drvr;
 	fws->fcmode = drvr->settings->fcmode;
 
@@ -2334,7 +2333,7 @@ int brcmf_fws_attach(struct brcmf_pub *drvr)
 	    (fws->fcmode == BRCMF_FWS_FCMODE_NONE)) {
 		fws->avoid_queueing = true;
 		brcmf_dbg(INFO, "FWS queueing will be avoided\n");
-		return 0;
+		return fws;
 	}
 
 	fws->fws_wq = create_singlethread_workqueue("brcmf_fws_wq");
@@ -2396,6 +2395,7 @@ int brcmf_fws_attach(struct brcmf_pub *drvr)
 	brcmf_fws_hanger_init(&fws->hanger);
 	brcmf_fws_macdesc_init(&fws->desc.other, NULL, 0);
 	brcmf_fws_macdesc_set_name(fws, &fws->desc.other);
+	brcmf_dbg(INFO, "added %s\n", fws->desc.other.name);
 	brcmu_pktq_init(&fws->desc.other.psq, BRCMF_FWS_PSQ_PREC_COUNT,
 			BRCMF_FWS_PSQ_LEN);
 
@@ -2405,27 +2405,24 @@ int brcmf_fws_attach(struct brcmf_pub *drvr)
 
 	brcmf_dbg(INFO, "%s bdcv2 tlv signaling [%x]\n",
 		  fws->fw_signals ? "enabled" : "disabled", tlv);
-	return 0;
+	return fws;
 
 fail:
-	brcmf_fws_detach(drvr);
-	return rc;
+	brcmf_fws_detach(fws);
+	return ERR_PTR(rc);
 }
 
-void brcmf_fws_detach(struct brcmf_pub *drvr)
+void brcmf_fws_detach(struct brcmf_fws_info *fws)
 {
-	struct brcmf_fws_info *fws = drvr->fws;
-
 	if (!fws)
 		return;
 
-	if (drvr->fws->fws_wq)
-		destroy_workqueue(drvr->fws->fws_wq);
+	if (fws->fws_wq)
+		destroy_workqueue(fws->fws_wq);
 
 	/* cleanup */
 	brcmf_fws_lock(fws);
 	brcmf_fws_cleanup(fws, -1);
-	drvr->fws = NULL;
 	brcmf_fws_unlock(fws);
 
 	/* free top structure */
@@ -2461,7 +2458,7 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked)
 {
-	struct brcmf_fws_info *fws = drvr->fws;
+	struct brcmf_fws_info *fws = drvr_to_fws(drvr);
 	struct brcmf_if *ifp;
 	int i;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
index d725158..ba07bd9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -18,8 +18,8 @@
 #ifndef FWSIGNAL_H_
 #define FWSIGNAL_H_
 
-int brcmf_fws_attach(struct brcmf_pub *drvr);
-void brcmf_fws_detach(struct brcmf_pub *drvr);
+struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr);
+void brcmf_fws_detach(struct brcmf_fws_info *fws);
 bool brcmf_fws_queue_skbs(struct brcmf_fws_info *fws);
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws);
 void brcmf_fws_hdrpull(struct brcmf_if *ifp, s16 siglen, struct sk_buff *skb);
-- 
1.9.1
