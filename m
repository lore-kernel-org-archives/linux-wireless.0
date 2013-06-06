Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4842 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598Ab3FFLSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:18:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/22] brcmfmac: Simplify counting transit count.
Date: Thu, 6 Jun 2013 13:18:01 +0200
Message-ID: <1370517487-14395-17-git-send-email-arend@broadcom.com> (sfid-20130606_131901_706990_56DAD30E)
In-Reply-To: <1370517487-14395-1-git-send-email-arend@broadcom.com>
References: <1370517487-14395-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   31 ++++++++------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 159ed1d..ea37bd4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -361,7 +361,6 @@ struct brcmf_fws_mac_descriptor {
 	u8 seq[BRCMF_FWS_FIFO_COUNT];
 	struct pktq psq;
 	int transit_count;
-	int suppress_count;
 	int suppr_transit_count;
 	bool send_tim_signal;
 	u8 traffic_pending_bmp;
@@ -1176,8 +1175,6 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 
 	/* update the sk_buff state */
 	brcmf_skbcb(p)->state = state;
-	if (state == BRCMF_FWS_SKBSTATE_SUPPRESSED)
-		entry->suppress_count++;
 
 	/*
 	 * A packet has been pushed so update traffic
@@ -1217,9 +1214,8 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 		p = brcmu_pktq_mdeq(&entry->psq, pmsk << (fifo * 2), &prec_out);
 		if (p == NULL) {
 			if (entry->suppressed) {
-				if (entry->suppr_transit_count >
-				    entry->suppress_count)
-					return NULL;
+				if (entry->suppr_transit_count)
+					continue;
 				entry->suppressed = false;
 				p = brcmu_pktq_mdeq(&entry->psq,
 						    1 << (fifo * 2), &prec_out);
@@ -1270,12 +1266,9 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 	/* this packet was suppressed */
 	if (!entry->suppressed) {
 		entry->suppressed = true;
-		entry->suppress_count = brcmu_pktq_mlen(&entry->psq,
-							1 << (fifo * 2 + 1));
 		entry->suppr_transit_count = entry->transit_count;
-		brcmf_dbg(DATA, "suppress %s: supp_cnt %d transit %d\n",
-			  entry->name, entry->suppress_count,
-			  entry->transit_count);
+		brcmf_dbg(DATA, "suppress %s: transit %d\n",
+			  entry->name, entry->transit_count);
 	}
 
 	entry->generation = genbit;
@@ -1294,7 +1287,6 @@ static int brcmf_fws_txstatus_suppressed(struct brcmf_fws_info *fws, int fifo,
 		 * wlfc cleanup
 		 */
 		brcmf_fws_hanger_mark_suppressed(&fws->hanger, hslot);
-		entry->suppress_count++;
 	}
 
 	return ret;
@@ -1339,6 +1331,9 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 		brcmu_pkt_buf_free_skb(skb);
 		return -EINVAL;
 	}
+	entry->transit_count--;
+	if (entry->suppressed && entry->suppr_transit_count)
+		entry->suppr_transit_count--;
 
 	brcmf_dbg(DATA, "%s flags %X htod %X\n", entry->name, skcb->if_flags,
 		  skcb->htod);
@@ -1352,13 +1347,9 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	if (!remove_from_hanger)
 		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, genbit);
 
-	if (remove_from_hanger || ret) {
-		entry->transit_count--;
-		if (entry->suppressed)
-			entry->suppr_transit_count--;
-
+	if (remove_from_hanger || ret)
 		brcmf_txfinalize(fws->drvr, skb, true);
-	}
+
 	return 0;
 }
 
@@ -1614,7 +1605,6 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 		free_ctr = entry->seq[fifo];
 		brcmf_skb_htod_tag_set_field(p, HSLOT, hslot);
 		brcmf_skb_htod_tag_set_field(p, FREERUN, free_ctr);
-		entry->transit_count++;
 		rc = brcmf_fws_hanger_pushpkt(&fws->hanger, p, hslot);
 		if (rc)
 			brcmf_err("hanger push failed: rc=%d\n", rc);
@@ -1768,6 +1758,9 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		goto rollback;
 	}
 
+	entry->transit_count++;
+	if (entry->suppressed)
+		entry->suppr_transit_count++;
 	entry->seq[fifo]++;
 	fws->stats.pkt2bus++;
 	if (brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK) {
-- 
1.7.10.4


