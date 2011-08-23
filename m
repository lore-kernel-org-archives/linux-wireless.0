Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9055 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1HWHCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 03:02:31 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v3] ath9k: Send legacy rated frames as unaggregated
Date: Tue, 23 Aug 2011 12:32:57 +0530
Message-ID: <1314082977-1692-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110823_090235_372657_620CF745)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the aggregation is formed till the aggregation limit
is reached and the rate lookup is done for the first frame alone.
But there can be a legacy rated frames in tid queue. This patch
limits the subframe addition based on presence of legacy rate and
sends the legacy rated frames as unaggregated one.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
v2: check against all rates
v3: updated commit log
 drivers/net/wireless/ath/ath9k/xmit.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2062672..5e29829 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -571,6 +571,25 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		ath_reset(sc, false);
 }
 
+static bool ath_lookup_legacy(struct ath_buf *bf)
+{
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *rates;
+	int i;
+
+	skb = bf->bf_mpdu;
+	tx_info = IEEE80211_SKB_CB(skb);
+	rates = tx_info->control.rates;
+
+	for (i = 3; i >= 0; i--) {
+		if (!(rates[i].flags & IEEE80211_TX_RC_MCS))
+			return true;
+	}
+
+	return false;
+}
+
 static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 			   struct ath_atx_tid *tid)
 {
@@ -750,7 +769,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		al_delta = ATH_AGGR_DELIM_SZ + fi->framelen;
 
 		if (nframes &&
-		    (aggr_limit < (al + bpad + al_delta + prev_al))) {
+		    ((aggr_limit < (al + bpad + al_delta + prev_al)) ||
+		     ath_lookup_legacy(bf))) {
 			status = ATH_AGGR_LIMITED;
 			break;
 		}
-- 
1.7.6

