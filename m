Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26288 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1HVMgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 08:36:47 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Send legacy rated frames as unaggregated
Date: Mon, 22 Aug 2011 18:07:12 +0530
Message-ID: <1314016632-1742-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110822_143651_101159_C0E307D6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the aggregation is formed till the aggregation limit
is reached and the rate lookup is done for the first frame alone.
But there can be a legacy rated frames in tid queue. This patch
limits the subframe addition based on last MRR's rate and sends
the legacy rated frames as unaggregated one.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2062672..41d9184 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -571,6 +571,26 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		ath_reset(sc, false);
 }
 
+static bool ath_lookup_lecacy(struct ath_buf *bf)
+{
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *rates;
+
+	skb = bf->bf_mpdu;
+	tx_info = IEEE80211_SKB_CB(skb);
+	rates = tx_info->control.rates;
+
+	/*
+	 * Checking the last MRR's flag is sufficient to
+	 * determine legacy or not
+	 */
+	if (!(rates[3].flags & IEEE80211_TX_RC_MCS))
+		return true;
+
+	return false;
+}
+
 static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 			   struct ath_atx_tid *tid)
 {
@@ -750,7 +770,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		al_delta = ATH_AGGR_DELIM_SZ + fi->framelen;
 
 		if (nframes &&
-		    (aggr_limit < (al + bpad + al_delta + prev_al))) {
+		    ((aggr_limit < (al + bpad + al_delta + prev_al)) ||
+		     ath_lookup_lecacy(bf))) {
 			status = ATH_AGGR_LIMITED;
 			break;
 		}
-- 
1.7.6

