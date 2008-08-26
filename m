Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39762 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbYHZCme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 22:42:34 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18611.27953.781576.654067@localhost.localdomain> (sfid-20080826_044237_199319_9F9B7DC2)
Date: Tue, 26 Aug 2008 08:10:49 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/4] ath9k: Do not update frame's duration field
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When AR_DurUpdateEna is set, the frame's duration field
is updated by the MAC based on the current rate.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    1 -
 drivers/net/wireless/ath9k/xmit.c |   56 +++++++-----------------------------
 2 files changed, 11 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 0692fc3..b6b6868 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -516,7 +516,6 @@ struct ath_tx_control {
 	u32 keyix;
 	int min_rate;
 	int mcast_rate;
-	u16 nextfraglen;
 	struct ath_softc *dev;
 	dma_addr_t dmacontext;
 };
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index a18cea6..87aebf1 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -227,7 +227,6 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	}
 
 	txctl->if_id = 0;
-	txctl->nextfraglen = 0;
 	txctl->frmlen = skb->len + FCS_LEN - (hdrlen & 3);
 	txctl->txpower = MAX_RATE_POWER; /* FIXME */
 
@@ -344,51 +343,18 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	}
 	rix = rcs[0].rix;
 
-	/*
-	 * Calculate duration.  This logically belongs in the 802.11
-	 * layer but it lacks sufficient information to calculate it.
-	 */
-	if ((txctl->flags & ATH9K_TXDESC_NOACK) == 0 && !ieee80211_is_ctl(fc)) {
-		u16 dur;
+	if (ieee80211_has_morefrags(fc) ||
+	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
 		/*
-		 * XXX not right with fragmentation.
-		 */
-		if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
-			dur = rt->info[rix].spAckDuration;
-		else
-			dur = rt->info[rix].lpAckDuration;
-
-		if (le16_to_cpu(hdr->frame_control) &
-				IEEE80211_FCTL_MOREFRAGS) {
-			dur += dur;  /* Add additional 'SIFS + ACK' */
-
-			/*
-			** Compute size of next fragment in order to compute
-			** durations needed to update NAV.
-			** The last fragment uses the ACK duration only.
-			** Add time for next fragment.
-			*/
-			dur += ath9k_hw_computetxtime(sc->sc_ah, rt,
-				      txctl->nextfraglen,
-				      rix,
-				      (sc->sc_flags & SC_OP_PREAMBLE_SHORT));
-		}
-
-		if (ieee80211_has_morefrags(fc) ||
-		     (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
-			/*
-			**  Force hardware to use computed duration for next
-			**  fragment by disabling multi-rate retry, which
-			**  updates duration based on the multi-rate
-			**  duration table.
-			*/
-			rcs[1].tries = rcs[2].tries = rcs[3].tries = 0;
-			rcs[1].rix = rcs[2].rix = rcs[3].rix = 0;
-			/* reset tries but keep rate index */
-			rcs[0].tries = ATH_TXMAXTRY;
-		}
-
-		hdr->duration_id = cpu_to_le16(dur);
+		**  Force hardware to use computed duration for next
+		**  fragment by disabling multi-rate retry, which
+		**  updates duration based on the multi-rate
+		**  duration table.
+		*/
+		rcs[1].tries = rcs[2].tries = rcs[3].tries = 0;
+		rcs[1].rix = rcs[2].rix = rcs[3].rix = 0;
+		/* reset tries but keep rate index */
+		rcs[0].tries = ATH_TXMAXTRY;
 	}
 
 	/*
-- 
1.6.0

