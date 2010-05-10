Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab0EJW2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/47] iwl3945: fix scan races
Date: Mon, 10 May 2010 15:27:33 -0700
Message-Id: <1273530498-11876-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Port following patch to 3945.

"commit 90c4162ff59a3281b6d2f7206740be6217bd6758
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Apr 7 00:21:36 2010 -0700
    iwlwifi: fix scan races"

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    3 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 ++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7273609..7deed86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -515,6 +515,7 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    struct cfg80211_scan_request *req);
+void iwl_bg_start_internal_scan(struct work_struct *work);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
 int iwl_force_reset(struct iwl_priv *priv, int mode);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 447c301..28e2d86 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -367,7 +367,7 @@ void iwl_internal_short_hw_scan(struct iwl_priv *priv)
 	queue_work(priv->workqueue, &priv->start_internal_scan);
 }
 
-static void iwl_bg_start_internal_scan(struct work_struct *work)
+void iwl_bg_start_internal_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, start_internal_scan);
@@ -402,6 +402,7 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
  unlock:
 	mutex_unlock(&priv->mutex);
 }
+EXPORT_SYMBOL(iwl_bg_start_internal_scan);
 
 void iwl_bg_scan_check(struct work_struct *data)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 867d105..04cedef 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3739,6 +3739,7 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->_3945.rfkill_poll, iwl3945_rfkill_poll);
 	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
 	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
+	INIT_WORK(&priv->start_internal_scan, iwl_bg_start_internal_scan);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
 
 	iwl3945_hw_setup_deferred_work(priv);
@@ -3761,6 +3762,7 @@ static void iwl3945_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
+	cancel_work_sync(&priv->start_internal_scan);
 	cancel_work_sync(&priv->beacon_update);
 	if (priv->cfg->ops->lib->recover_from_tx_stall)
 		del_timer_sync(&priv->monitor_recover);
-- 
1.6.3.3

