Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab0G3Ol0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 10:41:26 -0400
Date: Fri, 30 Jul 2010 16:41:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH -next] iwlwifi: make scan workqueue functions static
Message-ID: <20100730164108.6270e76f@dhcp-lab-109.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not need export iwl_bg.*scan.*() functions just for initialize
workqueue in other module. Making that functions static helps with
iwl-scan.c code review a bit.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ----
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   12 ++++--------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ++----
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e9d23f2..fe8f704 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -528,7 +528,6 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    struct cfg80211_scan_request *req);
-void iwl_bg_start_internal_scan(struct work_struct *work);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
 int iwl_force_reset(struct iwl_priv *priv, int mode, bool external);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
@@ -540,9 +539,6 @@ u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 			       enum ieee80211_band band,
 			       struct ieee80211_vif *vif);
-void iwl_bg_scan_check(struct work_struct *data);
-void iwl_bg_abort_scan(struct work_struct *work);
-void iwl_bg_scan_completed(struct work_struct *work);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 
 /* For faster active scanning, scan will move to the next channel if fewer than
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index b0c6b04..247e4c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -378,7 +378,7 @@ void iwl_internal_short_hw_scan(struct iwl_priv *priv)
 	queue_work(priv->workqueue, &priv->start_internal_scan);
 }
 
-void iwl_bg_start_internal_scan(struct work_struct *work)
+static void iwl_bg_start_internal_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, start_internal_scan);
@@ -418,9 +418,8 @@ void iwl_bg_start_internal_scan(struct work_struct *work)
  unlock:
 	mutex_unlock(&priv->mutex);
 }
-EXPORT_SYMBOL(iwl_bg_start_internal_scan);
 
-void iwl_bg_scan_check(struct work_struct *data)
+static void iwl_bg_scan_check(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, scan_check.work);
@@ -439,7 +438,6 @@ void iwl_bg_scan_check(struct work_struct *data)
 	}
 	mutex_unlock(&priv->mutex);
 }
-EXPORT_SYMBOL(iwl_bg_scan_check);
 
 /**
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
@@ -489,7 +487,7 @@ u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 }
 EXPORT_SYMBOL(iwl_fill_probe_req);
 
-void iwl_bg_abort_scan(struct work_struct *work)
+static void iwl_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
@@ -504,9 +502,8 @@ void iwl_bg_abort_scan(struct work_struct *work)
 		iwl_send_scan_abort(priv);
 	mutex_unlock(&priv->mutex);
 }
-EXPORT_SYMBOL(iwl_bg_abort_scan);
 
-void iwl_bg_scan_completed(struct work_struct *work)
+static void iwl_bg_scan_completed(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
@@ -555,7 +552,6 @@ void iwl_bg_scan_completed(struct work_struct *work)
 	if (!internal)
 		ieee80211_scan_completed(priv->hw, false);
 }
-EXPORT_SYMBOL(iwl_bg_scan_completed);
 
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d24eb47..f590753 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3739,10 +3739,8 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->_3945.rfkill_poll, iwl3945_rfkill_poll);
-	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
-	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
-	INIT_WORK(&priv->start_internal_scan, iwl_bg_start_internal_scan);
-	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
+
+	iwl_setup_scan_deferred_work(priv);
 
 	iwl3945_hw_setup_deferred_work(priv);
 
-- 
1.5.5.6

