Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1761 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 1/9] brcmfmac: simplify transmit path
Date: Wed, 26 Jun 2013 14:20:14 +0200
Message-ID: <1372249222-4858-2-git-send-email-arend@broadcom.com> (sfid-20130626_142042_487601_E8C807F1)
In-Reply-To: <1372249222-4858-1-git-send-email-arend@broadcom.com>
References: <1372249222-4858-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When getting a transmit packet from the networking layer simply
enqueue the packet unconditional and have it handled by the dequeue
worker. The transfer of the packet to the bus-specific driver part
is now done from one context.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   54 ++------------------
 1 file changed, 5 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 13e75c4..41f902d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1707,37 +1707,6 @@ static int brcmf_fws_borrow_credit(struct brcmf_fws_info *fws)
 	return -ENAVAIL;
 }
 
-static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
-				    struct sk_buff *skb)
-{
-	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
-	int *credit = &fws->fifo_credit[fifo];
-
-	if (fifo != BRCMF_FWS_FIFO_AC_BE)
-		fws->borrow_defer_timestamp = jiffies +
-					      BRCMF_FWS_BORROW_DEFER_PERIOD;
-
-	if (!(*credit)) {
-		/* Try to borrow a credit from other queue */
-		if (fifo != BRCMF_FWS_FIFO_AC_BE ||
-		    (brcmf_fws_borrow_credit(fws) != 0)) {
-			brcmf_dbg(DATA, "ac=%d, credits depleted\n", fifo);
-			return -ENAVAIL;
-		}
-	} else {
-		(*credit)--;
-		if (!(*credit))
-			fws->fifo_credit_map &= ~(1 << fifo);
-	}
-
-	brcmf_fws_macdesc_use_req_credit(entry, skb);
-
-	brcmf_dbg(DATA, "ac=%d, credits=%02d:%02d:%02d:%02d\n", fifo,
-		  fws->fifo_credit[0], fws->fifo_credit[1],
-		  fws->fifo_credit[2], fws->fifo_credit[3]);
-	return 0;
-}
-
 static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 				struct sk_buff *skb)
 {
@@ -1819,25 +1788,12 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		  eh->h_dest, multicast, fifo);
 
 	brcmf_fws_lock(drvr, flags);
-	/* multicast credit support is conditional, setting
-	 * flag to false to assure credit is consumed below.
-	 */
-	if (fws->bcmc_credit_check)
-		multicast = false;
-
-	if (skcb->mac->suppressed ||
-	    fws->bus_flow_blocked ||
-	    brcmf_fws_macdesc_closed(fws, skcb->mac, fifo) ||
-	    brcmu_pktq_mlen(&skcb->mac->psq, 3 << (fifo * 2)) ||
-	    (!multicast &&
-	     brcmf_fws_consume_credit(fws, fifo, skb) < 0)) {
-		/* enqueue the packet in delayQ */
-		drvr->fws->fifo_delay_map |= 1 << fifo;
-		brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
-	} else {
-		brcmf_fws_commit_skb(fws, fifo, skb);
-	}
+	brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
+	if (fifo != BRCMF_FWS_FIFO_AC_BE && fifo < BRCMF_FWS_FIFO_BCMC)
+		fws->borrow_defer_timestamp = jiffies +
+					      BRCMF_FWS_BORROW_DEFER_PERIOD;
 	brcmf_fws_unlock(drvr, flags);
+	brcmf_fws_schedule_deq(fws);
 	return 0;
 }
 
-- 
1.7.10.4


