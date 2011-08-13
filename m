Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34427 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1HME55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:57:57 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 01/11] ath9k_hw: Fix exceed transmission burst-time of 5GHz
Date: Sat, 13 Aug 2011 10:28:08 +0530
Message-ID: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065809_518554_2664FD40)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The WAR which adds extra delimiters when using RTS/CTS
with aggregation and non-enterprise AR9003 chips.
This extra padding is done after doing all the 4ms limit
checks and hence the total aggregate sizes are exceeding
the allowed duration. This patch limits the aggregate
sizes appropriately after including these extra delimiters.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   28 +-------------------------
 drivers/net/wireless/ath/ath9k/xmit.c       |   16 ++++++++++++--
 2 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 1aadc47..81ccce1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -415,36 +415,12 @@ static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
 static void ar9003_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
 					u32 aggrLen)
 {
-#define FIRST_DESC_NDELIMS 60
 	struct ar9003_txc *ads = (struct ar9003_txc *) ds;
 
 	ads->ctl12 |= (AR_IsAggr | AR_MoreAggr);
 
-	if (ah->ent_mode & AR_ENT_OTP_MPSD) {
-		u32 ctl17, ndelim;
-		/*
-		 * Add delimiter when using RTS/CTS with aggregation
-		 * and non enterprise AR9003 card
-		 */
-		ctl17 = ads->ctl17;
-		ndelim = MS(ctl17, AR_PadDelim);
-
-		if (ndelim < FIRST_DESC_NDELIMS) {
-			aggrLen += (FIRST_DESC_NDELIMS - ndelim) * 4;
-			ndelim = FIRST_DESC_NDELIMS;
-		}
-
-		ctl17 &= ~AR_AggrLen;
-		ctl17 |= SM(aggrLen, AR_AggrLen);
-
-		ctl17 &= ~AR_PadDelim;
-		ctl17 |= SM(ndelim, AR_PadDelim);
-
-		ads->ctl17 = ctl17;
-	} else {
-		ads->ctl17 &= ~AR_AggrLen;
-		ads->ctl17 |= SM(aggrLen, AR_AggrLen);
-	}
+	ads->ctl17 &= ~AR_AggrLen;
+	ads->ctl17 |= SM(aggrLen, AR_AggrLen);
 }
 
 static void ar9003_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e1d1e90..feef013 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -644,8 +644,10 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
  * meet the minimum required mpdudensity.
  */
 static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
-				  struct ath_buf *bf, u16 frmlen)
+				  struct ath_buf *bf, u16 frmlen,
+				  bool first_subfrm)
 {
+#define FIRST_DESC_NDELIMS 60
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	u32 nsymbits, nsymbols;
@@ -668,6 +670,13 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 		ndelim += ATH_AGGR_ENCRYPTDELIM;
 
 	/*
+	 * Add delimiter when using RTS/CTS with aggregation
+	 * and non enterprise AR9003 card
+	 */
+	if (first_subfrm)
+		ndelim = max(ndelim, FIRST_DESC_NDELIMS);
+
+	/*
 	 * Convert desired mpdu density from microeconds to bytes based
 	 * on highest rate in rate series (i.e. first rate) to determine
 	 * required minimum length for subframe. Take into account
@@ -756,7 +765,6 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			status = ATH_AGGR_LIMITED;
 			break;
 		}
-		nframes++;
 
 		/* add padding for previous frame to aggregation length */
 		al += bpad + al_delta;
@@ -765,9 +773,11 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		 * Get the delimiters needed to meet the MPDU
 		 * density for this node.
 		 */
-		ndelim = ath_compute_num_delims(sc, tid, bf_first, fi->framelen);
+		ndelim = ath_compute_num_delims(sc, tid, bf_first, fi->framelen,
+						!nframes);
 		bpad = PADBYTES(al_delta) + (ndelim << 2);
 
+		nframes++;
 		bf->bf_next = NULL;
 		ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, 0);
 
-- 
1.7.6

