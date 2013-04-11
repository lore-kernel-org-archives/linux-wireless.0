Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4969 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab3DKL3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:29:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/15] brcmfmac: rename brcmf_fws_mac_desc_ready()
Date: Thu, 11 Apr 2013 13:28:59 +0200
Message-ID: <1365679740-25679-15-git-send-email-arend@broadcom.com> (sfid-20130411_133049_510786_17FB88B3)
In-Reply-To: <1365679740-25679-1-git-send-email-arend@broadcom.com>
References: <1365679740-25679-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the function by brcmf_fws_mac_desc_closed(). The new function
is used in the transmit path and in the dequeue worker.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   31 ++++++++------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index e26bbfd..9b1f4ef 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -714,26 +714,19 @@ done:
 	return entry;
 }
 
-static bool brcmf_fws_mac_desc_ready(struct brcmf_fws_mac_descriptor *entry,
-				     int fifo)
+static bool brcmf_fws_mac_desc_closed(struct brcmf_fws_mac_descriptor *entry,
+				      int fifo)
 {
-	bool ready;
+	bool closed;
 
-	/*
-	 * destination entry is ready when firmware says it is OPEN
-	 * and there are no packets enqueued for it.
+	/* an entry is closed when the state is closed and
+	 * the firmware did not request anything.
 	 */
-	ready = entry->state == BRCMF_FWS_STATE_OPEN &&
-		!entry->suppressed &&
-		brcmu_pktq_mlen(&entry->psq, 3 << (fifo * 2)) == 0;
+	closed = entry->state == BRCMF_FWS_STATE_CLOSE &&
+		 !entry->requested_credit && !entry->requested_packet;
 
-	/*
-	 * Or when the destination entry is CLOSED, but firmware has
-	 * specifically requested packets for this entry.
-	 */
-	ready = ready || (entry->state == BRCMF_FWS_STATE_CLOSE &&
-		(entry->requested_credit + entry->requested_packet));
-	return ready;
+	/* Or firmware does not allow traffic for given fifo */
+	return closed || !(entry->ac_bitmap & BIT(fifo));
 }
 
 static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_info *fws,
@@ -1086,7 +1079,7 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 
 	for (i = 0; i < num_nodes; i++) {
 		entry = &table[(node_pos + i) % num_nodes];
-		if (!entry->occupied)
+		if (!entry->occupied || brcmf_fws_mac_desc_closed(entry, fifo))
 			continue;
 
 		if (entry->suppressed)
@@ -1758,7 +1751,9 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		  multicast, fifo);
 
 	brcmf_fws_lock(drvr, flags);
-	if (!brcmf_fws_mac_desc_ready(skcb->mac, fifo) ||
+	if (skcb->mac->suppressed ||
+	    brcmf_fws_mac_desc_closed(skcb->mac, fifo) ||
+    	    brcmu_pktq_mlen(&skcb->mac->psq, 3 << (fifo *2)) ||
 	    (!multicast &&
 	     brcmf_fws_consume_credit(drvr->fws, fifo, skb) < 0)) {
 		/* enqueue the packet in delayQ */
-- 
1.7.10.4


