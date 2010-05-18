Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24466 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0ERKGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 06:06:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 03:06:05 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19442.25652.916516.143181@gargle.gargle.HOWL>
Date: Tue, 18 May 2010 15:26:04 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: Use proper station add/remove callbacks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta_add/sta_remove are the callbacks that can sleep.
Use them instead of sta_notify.

Sigh. What a dumb fsckup.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   39 ++++++++++++++-----------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 6d46423..340d281 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1438,30 +1438,34 @@ static void ath9k_htc_configure_filter(struct ieee80211_hw *hw,
 	mutex_unlock(&priv->mutex);
 }
 
-static void ath9k_htc_sta_notify(struct ieee80211_hw *hw,
-				 struct ieee80211_vif *vif,
-				 enum sta_notify_cmd cmd,
-				 struct ieee80211_sta *sta)
+static int ath9k_htc_sta_add(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	int ret;
 
 	mutex_lock(&priv->mutex);
+	ret = ath9k_htc_add_station(priv, vif, sta);
+	if (!ret)
+		ath9k_htc_init_rate(priv, sta);
+	mutex_unlock(&priv->mutex);
 
-	switch (cmd) {
-	case STA_NOTIFY_ADD:
-		ret = ath9k_htc_add_station(priv, vif, sta);
-		if (!ret)
-			ath9k_htc_init_rate(priv, sta);
-		break;
-	case STA_NOTIFY_REMOVE:
-		ath9k_htc_remove_station(priv, vif, sta);
-		break;
-	default:
-		break;
-	}
+	return ret;
+}
 
+static int ath9k_htc_sta_remove(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	int ret;
+
+	mutex_lock(&priv->mutex);
+	ret = ath9k_htc_remove_station(priv, vif, sta);
 	mutex_unlock(&priv->mutex);
+
+	return ret;
 }
 
 static int ath9k_htc_conf_tx(struct ieee80211_hw *hw, u16 queue,
@@ -1756,7 +1760,8 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.remove_interface   = ath9k_htc_remove_interface,
 	.config             = ath9k_htc_config,
 	.configure_filter   = ath9k_htc_configure_filter,
-	.sta_notify         = ath9k_htc_sta_notify,
+	.sta_add            = ath9k_htc_sta_add,
+	.sta_remove         = ath9k_htc_sta_remove,
 	.conf_tx            = ath9k_htc_conf_tx,
 	.bss_info_changed   = ath9k_htc_bss_info_changed,
 	.set_key            = ath9k_htc_set_key,
-- 
1.7.1

