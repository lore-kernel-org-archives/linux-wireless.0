Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20654 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500Ab0A2TyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/12] iwlwifi: remove bg_up work
Date: Fri, 29 Jan 2010 11:53:59 -0800
Message-Id: <1264794842-8046-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to queue a work struct from
within a work struct, just move the code to
execute directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   21 +++++++--------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   21 +++++++--------------
 3 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1c54425..b528a20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2439,18 +2439,6 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	return;
 }
 
-static void iwl_bg_up(struct work_struct *data)
-{
-	struct iwl_priv *priv = container_of(data, struct iwl_priv, up);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
-	__iwl_up(priv);
-	mutex_unlock(&priv->mutex);
-}
-
 static void iwl_bg_restart(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
@@ -2467,7 +2455,13 @@ static void iwl_bg_restart(struct work_struct *data)
 		ieee80211_restart_hw(priv->hw);
 	} else {
 		iwl_down(priv);
-		queue_work(priv->workqueue, &priv->up);
+
+		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+			return;
+
+		mutex_lock(&priv->mutex);
+		__iwl_up(priv);
+		mutex_unlock(&priv->mutex);
 	}
 }
 
@@ -3285,7 +3279,6 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 	init_waitqueue_head(&priv->wait_command_queue);
 
-	INIT_WORK(&priv->up, iwl_bg_up);
 	INIT_WORK(&priv->restart, iwl_bg_restart);
 	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9b0a5cb..1cd565a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1264,7 +1264,6 @@ struct iwl_priv {
 
 	struct workqueue_struct *workqueue;
 
-	struct work_struct up;
 	struct work_struct restart;
 	struct work_struct calibrated_work;
 	struct work_struct scan_completed;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cd42b58..119da54 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3033,18 +3033,6 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl3945_bg_up(struct work_struct *data)
-{
-	struct iwl_priv *priv = container_of(data, struct iwl_priv, up);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
-	__iwl3945_up(priv);
-	mutex_unlock(&priv->mutex);
-}
-
 static void iwl3945_bg_restart(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
@@ -3061,7 +3049,13 @@ static void iwl3945_bg_restart(struct work_struct *data)
 		ieee80211_restart_hw(priv->hw);
 	} else {
 		iwl3945_down(priv);
-		queue_work(priv->workqueue, &priv->up);
+
+		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+			return;
+
+		mutex_lock(&priv->mutex);
+		__iwl3945_up(priv);
+		mutex_unlock(&priv->mutex);
 	}
 }
 
@@ -3782,7 +3776,6 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 
 	init_waitqueue_head(&priv->wait_command_queue);
 
-	INIT_WORK(&priv->up, iwl3945_bg_up);
 	INIT_WORK(&priv->restart, iwl3945_bg_restart);
 	INIT_WORK(&priv->rx_replenish, iwl3945_bg_rx_replenish);
 	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
-- 
1.6.3.3

