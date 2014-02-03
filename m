Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaBCKnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:43:45 -0500
Date: Mon, 3 Feb 2014 11:45:51 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@venema.h4ckr.net
Subject: [PATCH] ath9k_htc: avoid scheduling while atomic on sta_rc_update
Message-ID: <20140203104550.GC1725@redhat.com> (sfid-20140203_114353_968396_37B8D45D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 ->sta_rc_update() callback must be atomic. Since we have to
take mutex and do other operations that can sleep when sending fimrware
commands to device, the only option to satisfy atomicity requirement of
->sta_rc_update(), that I can see, is introduce work_struct and defer
uploading new rates to that work.

Tested-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
This is on top of my previous patch:
"ath9k_htc: make ->sta_rc_update atomic for most calls"

 drivers/net/wireless/ath/ath9k/htc.h          |  2 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 60 +++++++++++++++++----------
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 58da346..99a2031 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -262,6 +262,8 @@ enum tid_aggr_state {
 struct ath9k_htc_sta {
 	u8 index;
 	enum tid_aggr_state tid_state[ATH9K_HTC_MAX_TID];
+	struct work_struct rc_update_work;
+	struct ath9k_htc_priv *htc_priv;
 };
 
 #define ATH9K_HTC_RXBUF 256
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a57af9b..c9254a6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1270,18 +1270,50 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	mutex_unlock(&priv->mutex);
 }
 
+static void ath9k_htc_sta_rc_update_work(struct work_struct *work)
+{
+	struct ath9k_htc_sta *ista =
+	    container_of(work, struct ath9k_htc_sta, rc_update_work);
+	struct ieee80211_sta *sta =
+	    container_of((void *)ista, struct ieee80211_sta, drv_priv);
+	struct ath9k_htc_priv *priv = ista->htc_priv;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_target_rate trate;
+
+	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
+
+	memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
+	ath9k_htc_setup_rate(priv, sta, &trate);
+	if (!ath9k_htc_send_rate_cmd(priv, &trate))
+		ath_dbg(common, CONFIG,
+			"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
+			sta->addr, be32_to_cpu(trate.capflags));
+	else
+		ath_dbg(common, CONFIG,
+			"Unable to update supported rates for sta: %pM\n",
+			sta->addr);
+
+	ath9k_htc_ps_restore(priv);
+	mutex_unlock(&priv->mutex);
+}
+
 static int ath9k_htc_sta_add(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
+	struct ath9k_htc_sta *ista = (struct ath9k_htc_sta *) sta->drv_priv;
 	int ret;
 
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 	ret = ath9k_htc_add_station(priv, vif, sta);
-	if (!ret)
+	if (!ret) {
+		INIT_WORK(&ista->rc_update_work, ath9k_htc_sta_rc_update_work);
+		ista->htc_priv = priv;
 		ath9k_htc_init_rate(priv, sta);
+	}
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 
@@ -1293,12 +1325,13 @@ static int ath9k_htc_sta_remove(struct ieee80211_hw *hw,
 				struct ieee80211_sta *sta)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
-	struct ath9k_htc_sta *ista;
+	struct ath9k_htc_sta *ista = (struct ath9k_htc_sta *) sta->drv_priv;
 	int ret;
 
+	cancel_work_sync(&ista->rc_update_work);
+
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
-	ista = (struct ath9k_htc_sta *) sta->drv_priv;
 	htc_sta_drain(priv->htc, ista->index);
 	ret = ath9k_htc_remove_station(priv, vif, sta);
 	ath9k_htc_ps_restore(priv);
@@ -1311,29 +1344,12 @@ static void ath9k_htc_sta_rc_update(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_sta *sta, u32 changed)
 {
-	struct ath9k_htc_priv *priv = hw->priv;
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct ath9k_htc_target_rate trate;
+	struct ath9k_htc_sta *ista = (struct ath9k_htc_sta *) sta->drv_priv;
 
 	if (!(changed & IEEE80211_RC_SUPP_RATES_CHANGED))
 		return;
 
-	mutex_lock(&priv->mutex);
-	ath9k_htc_ps_wakeup(priv);
-
-	memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
-	ath9k_htc_setup_rate(priv, sta, &trate);
-	if (!ath9k_htc_send_rate_cmd(priv, &trate))
-		ath_dbg(common, CONFIG,
-			"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
-			sta->addr, be32_to_cpu(trate.capflags));
-	else
-		ath_dbg(common, CONFIG,
-			"Unable to update supported rates for sta: %pM\n",
-			sta->addr);
-
-	ath9k_htc_ps_restore(priv);
-	mutex_unlock(&priv->mutex);
+	schedule_work(&ista->rc_update_work);
 }
 
 static int ath9k_htc_conf_tx(struct ieee80211_hw *hw,
-- 
1.7.11.7

