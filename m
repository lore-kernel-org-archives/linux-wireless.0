Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41896 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755812Ab0FAJnL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 05:43:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 02:43:11 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.54899.982149.372055@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:14:19 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/13] ath9k_htc: Fix fair beacon distribution
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes beacon distribution in IBSS mode
by configuring the hardware beacon queue properly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    8 +++++++-
 3 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index bf2bd42..f2cbc55 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -409,6 +409,7 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 	common->bus_ops->read_cachesize(common, csz);
 }
 
+void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
 void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index c10c7d0..12a3bb0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -222,6 +222,29 @@ void ath9k_htc_swba(struct ath9k_htc_priv *priv, u8 beacon_pending)
 	spin_unlock_bh(&priv->beacon_lock);
 }
 
+/* Currently, only for IBSS */
+void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
+{
+	struct ath_hw *ah = priv->ah;
+	struct ath9k_tx_queue_info qi, qi_be;
+	int qnum = priv->hwq_map[ATH9K_WME_AC_BE];
+
+	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
+	memset(&qi_be, 0, sizeof(struct ath9k_tx_queue_info));
+
+	ath9k_hw_get_txq_props(ah, qnum, &qi_be);
+
+	qi.tqi_aifs = qi_be.tqi_aifs;
+	qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
+	qi.tqi_cwmax = qi_be.tqi_cwmax;
+
+	if (!ath9k_hw_set_txq_props(ah, priv->beaconq, &qi)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Unable to update beacon queue %u!\n", qnum);
+	} else {
+		ath9k_hw_resettxqueue(ah, priv->beaconq);
+	}
+}
 
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 86145ef..569b9c0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1580,9 +1580,15 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		  params->cw_max, params->txop);
 
 	ret = ath_htc_txq_update(priv, qnum, &qi);
-	if (ret)
+	if (ret) {
 		ath_print(common, ATH_DBG_FATAL, "TXQ Update failed\n");
+		goto out;
+	}
 
+	if ((priv->ah->opmode == NL80211_IFTYPE_ADHOC) &&
+	    (qnum == priv->hwq_map[ATH9K_WME_AC_BE]))
+		    ath9k_htc_beaconq_config(priv);
+out:
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 
-- 
1.7.1

