Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2158 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959Ab3E2QjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:39:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 04/16] brcmfmac: rework credit pickup to assure
 consistent handling
Date: Wed, 29 May 2013 18:38:54 +0200
Message-ID: <1369845546-31950-5-git-send-email-arend@broadcom.com> (sfid-20130529_183924_008320_7F2D365A)
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reworked brcmf_skb_pick_up_credit() so it can be used for both
fcmode flavours in the same way.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   30 +++++++++-----------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 7b37aac..ff8c2f0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1040,24 +1040,21 @@ static void brcmf_fws_schedule_deq(struct brcmf_fws_info *fws)
 		queue_work(fws->fws_wq, &fws->fws_dequeue_work);
 }
 
-static void brcmf_skb_pick_up_credit(struct brcmf_fws_info *fws, int fifo,
+static void brcmf_fws_skb_pickup_credit(struct brcmf_fws_info *fws, int fifo,
 				     struct sk_buff *p)
 {
 	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(p)->mac;
 
-	if (brcmf_skbcb(p)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK) {
-		if (fws->fcmode != BRCMF_FWS_FCMODE_IMPLIED_CREDIT)
-			return;
+	if (brcmf_skbcb(p)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
 		brcmf_fws_return_credits(fws, fifo, 1);
-	} else {
+	else if (!brcmf_skb_if_flags_get_field(p, REQUESTED))
 		/*
 		 * if this packet did not count against FIFO credit, it
 		 * must have taken a requested_credit from the destination
 		 * entry (for pspoll etc.)
 		 */
-		if (!brcmf_skb_if_flags_get_field(p, REQUESTED))
-			entry->requested_credit++;
-	}
+		entry->requested_credit++;
+
 	brcmf_fws_schedule_deq(fws);
 }
 
@@ -1272,7 +1269,9 @@ brcmf_fws_txstatus_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 
 	/* pick up the implicit credit from this packet */
 	fifo = brcmf_skb_htod_tag_get_field(skb, FIFO);
-	brcmf_skb_pick_up_credit(fws, fifo, skb);
+	if (fws->fcmode == BRCMF_FWS_FCMODE_IMPLIED_CREDIT ||
+	    !(brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK))
+		brcmf_fws_skb_pickup_credit(fws, fifo, skb);
 
 	if (!remove_from_hanger)
 		ret = brcmf_fws_txstatus_suppressed(fws, fifo, skb, genbit);
@@ -1845,7 +1844,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	} else {
 		if (brcmf_fws_commit_skb(fws, fifo, skb))
 			if (!multicast)
-				brcmf_skb_pick_up_credit(fws, fifo, skb);
+				brcmf_fws_skb_pickup_credit(fws, fifo, skb);
 	}
 	brcmf_fws_unlock(drvr, flags);
 	return 0;
@@ -2053,18 +2052,15 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
 	ulong flags;
+	int fifo;
 
 	brcmf_fws_lock(fws->drvr, flags);
 	brcmf_fws_txstatus_process(fws, BRCMF_FWS_TXSTATUS_FW_TOSSED,
 				   brcmf_skb_htod_tag_get_field(skb, HSLOT), 0);
 	/* the packet never reached firmware so reclaim credit */
-	if (fws->fcmode == BRCMF_FWS_FCMODE_EXPLICIT_CREDIT &&
-	    brcmf_skbcb(skb)->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK) {
-		brcmf_fws_return_credits(fws,
-					 brcmf_skb_htod_tag_get_field(skb,
-								      FIFO),
-					 1);
-		brcmf_fws_schedule_deq(fws);
+	if (fws->fcmode == BRCMF_FWS_FCMODE_EXPLICIT_CREDIT) {
+		fifo = brcmf_skb_htod_tag_get_field(skb, FIFO);
+		brcmf_fws_skb_pickup_credit(fws, fifo, skb);
 	}
 	brcmf_fws_unlock(fws->drvr, flags);
 }
-- 
1.7.10.4


