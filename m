Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:43498 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753225Ab0IPJvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 05:51:43 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-033193701
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 18:51:41 +0900 (JST)
Subject: [PATCH 9/9] ath5k: Add tx queue configuration function
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Thu, 16 Sep 2010 18:52:00 +0900
Message-ID: <20100916095200.17637.61587.stgit@tt-desk>
In-Reply-To: <20100916095112.17637.17207.stgit@tt-desk>
References: <20100916095112.17637.17207.stgit@tt-desk>
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

