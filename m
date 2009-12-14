Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23157 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbZLNJYL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 04:24:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 01:24:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19238.1248.439940.601526@gargle.gargle.HOWL>
Date: Mon, 14 Dec 2009 14:56:56 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/6] ath9k: Fix bug in assigning sequence number
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The internal, driver-specific maintenance of sequence
numbers is applicable only for HT frames.

Also, remove comments that are not relevant anymore.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2a11cc5..c56f4ac 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1414,17 +1414,9 @@ static void assign_aggr_tid_seqno(struct sk_buff *skb,
 	 * For HT capable stations, we save tidno for later use.
 	 * We also override seqno set by upper layer with the one
 	 * in tx aggregation state.
-	 *
-	 * If fragmentation is on, the sequence number is
-	 * not overridden, since it has been
-	 * incremented by the fragmentation routine.
-	 *
-	 * FIXME: check if the fragmentation threshold exceeds
-	 * IEEE80211 max.
 	 */
 	tid = ATH_AN_2_TID(an, bf->bf_tidno);
-	hdr->seq_ctrl = cpu_to_le16(tid->seq_next <<
-			IEEE80211_SEQ_SEQ_SHIFT);
+	hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
 	bf->bf_seqno = tid->seq_next;
 	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
 }
@@ -1636,7 +1628,8 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
 	}
 
-	if (ieee80211_is_data_qos(fc) && (sc->sc_flags & SC_OP_TXAGGR))
+	if (ieee80211_is_data_qos(fc) && bf_isht(bf) &&
+	    (sc->sc_flags & SC_OP_TXAGGR))
 		assign_aggr_tid_seqno(skb, bf);
 
 	bf->bf_mpdu = skb;
-- 
1.6.5.6

