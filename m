Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 12/24] ath9k_htc: use common WMM AC definitions instead of ath9k ones
Date: Sat, 12 Jun 2010 00:33:50 -0400
Message-Id: <1276317242-15540-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    5 ++---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    8 ++++----
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   13 ++++++-------
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 051b8d8..c584fbd 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -398,7 +398,7 @@ struct ath9k_htc_priv {
 
 	int beaconq;
 	int cabq;
-	int hwq_map[ATH9K_WME_AC_VO+1];
+	int hwq_map[WME_NUM_AC];
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 	struct ath9k_debug debug;
@@ -431,8 +431,7 @@ int ath9k_tx_init(struct ath9k_htc_priv *priv);
 void ath9k_tx_tasklet(unsigned long data);
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb);
 void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
-bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv,
-			 enum ath9k_tx_queue_subtype qtype);
+bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv, int subtype);
 int ath9k_htc_cabq_setup(struct ath9k_htc_priv *priv);
 int get_hw_qnum(u16 queue, int *hwq_map);
 int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 12a3bb0..bd1506e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -227,7 +227,7 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
 	struct ath9k_tx_queue_info qi, qi_be;
-	int qnum = priv->hwq_map[ATH9K_WME_AC_BE];
+	int qnum = priv->hwq_map[WME_AC_BE];
 
 	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
 	memset(&qi_be, 0, sizeof(struct ath9k_tx_queue_info));
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 7339439..947de70 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -521,23 +521,23 @@ static int ath9k_init_queues(struct ath9k_htc_priv *priv)
 		goto err;
 	}
 
-	if (!ath9k_htc_txq_setup(priv, ATH9K_WME_AC_BE)) {
+	if (!ath9k_htc_txq_setup(priv, WME_AC_BE)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for BE traffic\n");
 		goto err;
 	}
 
-	if (!ath9k_htc_txq_setup(priv, ATH9K_WME_AC_BK)) {
+	if (!ath9k_htc_txq_setup(priv, WME_AC_BK)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for BK traffic\n");
 		goto err;
 	}
-	if (!ath9k_htc_txq_setup(priv, ATH9K_WME_AC_VI)) {
+	if (!ath9k_htc_txq_setup(priv, WME_AC_VI)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for VI traffic\n");
 		goto err;
 	}
-	if (!ath9k_htc_txq_setup(priv, ATH9K_WME_AC_VO)) {
+	if (!ath9k_htc_txq_setup(priv, WME_AC_VO)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup xmit queue for VO traffic\n");
 		goto err;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 7aefbc6..c4d022a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1590,7 +1590,7 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	}
 
 	if ((priv->ah->opmode == NL80211_IFTYPE_ADHOC) &&
-	    (qnum == priv->hwq_map[ATH9K_WME_AC_BE]))
+	    (qnum == priv->hwq_map[WME_AC_BE]))
 		    ath9k_htc_beaconq_config(priv);
 out:
 	ath9k_htc_ps_restore(priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index ffebd5a..89d81ab 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -34,15 +34,15 @@ int get_hw_qnum(u16 queue, int *hwq_map)
 {
 	switch (queue) {
 	case 0:
-		return hwq_map[ATH9K_WME_AC_VO];
+		return hwq_map[WME_AC_VO];
 	case 1:
-		return hwq_map[ATH9K_WME_AC_VI];
+		return hwq_map[WME_AC_VI];
 	case 2:
-		return hwq_map[ATH9K_WME_AC_BE];
+		return hwq_map[WME_AC_BE];
 	case 3:
-		return hwq_map[ATH9K_WME_AC_BK];
+		return hwq_map[WME_AC_BK];
 	default:
-		return hwq_map[ATH9K_WME_AC_BE];
+		return hwq_map[WME_AC_BE];
 	}
 }
 
@@ -297,8 +297,7 @@ void ath9k_tx_cleanup(struct ath9k_htc_priv *priv)
 
 }
 
-bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv,
-			 enum ath9k_tx_queue_subtype subtype)
+bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv, int subtype)
 {
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-- 
1.6.3.3

