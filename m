Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588Ab1D1Jw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:59 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 09/10] iwlegacy: more priv->mutex serialization
Date: Thu, 28 Apr 2011 11:51:32 +0200
Message-Id: <1303984293-6601-9-git-send-email-sgruszka@redhat.com> (sfid-20110428_115309_228541_596DDB1B)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check status bits with mutex taken, because when we wait for mutex
unlock, status can change. Patch should also make remaining sync
commands be send with priv->mutex taken. That will prevent execute
these commands when we are currently reset firmware, what could
possibly cause troubles.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-core.c     |    8 ++++--
 drivers/net/wireless/iwlegacy/iwl3945-base.c |   21 ++++++++++++-------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |   28 ++++++++++++++-----------
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 4b244fe..d743373 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -2429,11 +2429,13 @@ void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "changes = 0x%X\n", changes);
 
-	if (!iwl_legacy_is_alive(priv))
-		return;
-
 	mutex_lock(&priv->mutex);
 
+	if (!iwl_legacy_is_alive(priv)) {
+		mutex_unlock(&priv->mutex);
+		return;
+	}
+
 	if (changes & BSS_CHANGED_QOS) {
 		unsigned long flags;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 64714f7..0460d3b 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -2748,11 +2748,12 @@ static void iwl3945_bg_init_alive_start(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, init_alive_start.work);
 
+	mutex_lock(&priv->mutex);
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+		goto out;
 
-	mutex_lock(&priv->mutex);
 	iwl3945_init_alive_start(priv);
+out:
 	mutex_unlock(&priv->mutex);
 }
 
@@ -2761,11 +2762,12 @@ static void iwl3945_bg_alive_start(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, alive_start.work);
 
+	mutex_lock(&priv->mutex);
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+		goto out;
 
-	mutex_lock(&priv->mutex);
 	iwl3945_alive_start(priv);
+out:
 	mutex_unlock(&priv->mutex);
 }
 
@@ -2995,10 +2997,12 @@ static void iwl3945_bg_restart(struct work_struct *data)
 	} else {
 		iwl3945_down(priv);
 
-		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		mutex_lock(&priv->mutex);
+		if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+			mutex_unlock(&priv->mutex);
 			return;
+		}
 
-		mutex_lock(&priv->mutex);
 		__iwl3945_up(priv);
 		mutex_unlock(&priv->mutex);
 	}
@@ -3009,11 +3013,12 @@ static void iwl3945_bg_rx_replenish(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, rx_replenish);
 
+	mutex_lock(&priv->mutex);
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+		goto out;
 
-	mutex_lock(&priv->mutex);
 	iwl3945_rx_replenish(priv);
+out:
 	mutex_unlock(&priv->mutex);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 871e13b..8650970 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2404,11 +2404,12 @@ static void iwl4965_bg_init_alive_start(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, init_alive_start.work);
 
+	mutex_lock(&priv->mutex);
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+		goto out;
 
-	mutex_lock(&priv->mutex);
 	priv->cfg->ops->lib->init_alive_start(priv);
+out:
 	mutex_unlock(&priv->mutex);
 }
 
@@ -2417,11 +2418,12 @@ static void iwl4965_bg_alive_start(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, alive_start.work);
 
+	mutex_lock(&priv->mutex);
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+		goto out;
 
-	mutex_lock(&priv->mutex);
 	iwl4965_alive_start(priv);
+out:
 	mutex_unlock(&priv->mutex);
 }
 
@@ -2471,10 +2473,12 @@ static void iwl4965_bg_restart(struct work_struct *data)
 	} else {
 		iwl4965_down(priv);
 
-		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		mutex_lock(&priv->mutex);
+		if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+			mutex_unlock(&priv->mutex);
 			return;
+		}
 
-		mutex_lock(&priv->mutex);
 		__iwl4965_up(priv);
 		mutex_unlock(&priv->mutex);
 	}
@@ -2851,21 +2855,22 @@ void iwl4965_mac_channel_switch(struct ieee80211_hw *hw,
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
+	mutex_lock(&priv->mutex);
+
 	if (iwl_legacy_is_rfkill(priv))
-		goto out_exit;
+		goto out;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
 	    test_bit(STATUS_SCANNING, &priv->status))
-		goto out_exit;
+		goto out;
 
 	if (!iwl_legacy_is_associated_ctx(ctx))
-		goto out_exit;
+		goto out;
 
 	/* channel switch in progress */
 	if (priv->switch_rxon.switch_in_progress == true)
-		goto out_exit;
+		goto out;
 
-	mutex_lock(&priv->mutex);
 	if (priv->cfg->ops->lib->set_channel_switch) {
 
 		ch = channel->hw_value;
@@ -2921,7 +2926,6 @@ void iwl4965_mac_channel_switch(struct ieee80211_hw *hw,
 	}
 out:
 	mutex_unlock(&priv->mutex);
-out_exit:
 	if (!priv->switch_rxon.switch_in_progress)
 		ieee80211_chswitch_done(ctx->vif, false);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-- 
1.7.1

