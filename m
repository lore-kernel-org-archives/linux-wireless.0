Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:42865 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754700Ab0IQCg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:56 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0687531015
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:36:55 +0900 (JST)
Subject: [PATCH 11/11] ath5k: Add tx queue configuration function
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:37:18 +0900
Message-ID: <20100917023718.24997.40780.stgit@tt-desk>
In-Reply-To: <20100917023543.24997.48466.stgit@tt-desk>
References: <20100917023543.24997.48466.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the mac80211 callback function to configure the tx queue properties like
cw_min, cw_max and aifs.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   40 ++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index cfa9243..95072db 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3144,6 +3144,44 @@ static void ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_unlock(&sc->lock);
 }
 
+static int ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
+			 const struct ieee80211_tx_queue_params *params)
+{
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_txq_info qi;
+	int ret = 0;
+
+	if (queue >= ah->ah_capabilities.cap_queues.q_tx_num)
+		return 0;
+
+	mutex_lock(&sc->lock);
+
+	ath5k_hw_get_tx_queueprops(ah, queue, &qi);
+
+	qi.tqi_aifs = params->aifs;
+	qi.tqi_cw_min = params->cw_min;
+	qi.tqi_cw_max = params->cw_max;
+	qi.tqi_burst_time = params->txop;
+
+	ATH5K_DBG(sc, ATH5K_DEBUG_ANY,
+		  "Configure tx [queue %d],  "
+		  "aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
+		  queue, params->aifs, params->cw_min,
+		  params->cw_max, params->txop);
+
+	if (ath5k_hw_set_tx_queueprops(ah, queue, &qi)) {
+		ATH5K_ERR(sc,
+			  "Unable to update hardware queue %u!\n", queue);
+		ret = -EIO;
+	} else
+		ath5k_hw_reset_tx_queue(ah, queue);
+
+	mutex_unlock(&sc->lock);
+
+	return ret;
+}
+
 static const struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
 	.start 		= ath5k_start,
@@ -3156,7 +3194,7 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.set_key 	= ath5k_set_key,
 	.get_stats 	= ath5k_get_stats,
 	.get_survey	= ath5k_get_survey,
-	.conf_tx 	= NULL,
+	.conf_tx	= ath5k_conf_tx,
 	.get_tsf 	= ath5k_get_tsf,
 	.set_tsf 	= ath5k_set_tsf,
 	.reset_tsf 	= ath5k_reset_tsf,

