Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbYEECY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH 21/25] iwlwifi : Set monitor mode for 3945
Date: Mon,  5 May 2008 10:22:48 +0800
Message-Id: <1209954172-3092-22-git-send-email-yi.zhu@intel.com> (sfid-20080505_044416_877343_C6CB42FA)
In-Reply-To: <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch leverages mac80211 configure_filter to enable iwl3945
monitor mode.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   36 ++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index fb96c62..9fdc140 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -886,6 +886,7 @@ struct iwl3945_priv {
 	struct work_struct report_work;
 	struct work_struct request_scan;
 	struct work_struct beacon_update;
+	struct work_struct set_monitor;
 
 	struct tasklet_struct irq_tasklet;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7040cde..f021eba 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6144,6 +6144,24 @@ static void iwl3945_bg_rf_kill(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
+static void iwl3945_bg_set_monitor(struct work_struct *work)
+{
+	struct iwl3945_priv *priv = container_of(work,
+				struct iwl3945_priv, set_monitor);
+
+	IWL_DEBUG(IWL_DL_STATE, "setting monitor mode\n");
+
+	mutex_lock(&priv->mutex);
+
+	if (!iwl3945_is_ready(priv))
+		IWL_DEBUG(IWL_DL_STATE, "leave - not ready\n");
+	else
+		if (iwl3945_set_mode(priv, IEEE80211_IF_TYPE_MNTR) != 0)
+			IWL_ERROR("iwl3945_set_mode() failed\n");
+
+	mutex_unlock(&priv->mutex);
+}
+
 #define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
 
 static void iwl3945_bg_scan_check(struct work_struct *data)
@@ -6996,7 +7014,22 @@ static void iwl3945_configure_filter(struct ieee80211_hw *hw,
 	 * XXX: dummy
 	 * see also iwl3945_connection_init_rx_config
 	 */
-	*total_flags = 0;
+	struct iwl3945_priv *priv = hw->priv;
+	int new_flags = 0;
+	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
+		if (*total_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
+			IWL_DEBUG_MAC80211("Enter: type %d (0x%x, 0x%x)\n",
+					   IEEE80211_IF_TYPE_MNTR,
+					   changed_flags, *total_flags);
+			/* queue work 'cuz mac80211 is holding a lock which
+			 * prevents us from issuing (synchronous) f/w cmds */
+			queue_work(priv->workqueue, &priv->set_monitor);
+			new_flags &= FIF_PROMISC_IN_BSS |
+				     FIF_OTHER_BSS |
+				     FIF_ALLMULTI;
+		}
+	}
+	*total_flags = new_flags;
 }
 
 static void iwl3945_mac_remove_interface(struct ieee80211_hw *hw,
@@ -7872,6 +7905,7 @@ static void iwl3945_setup_deferred_work(struct iwl3945_priv *priv)
 	INIT_WORK(&priv->abort_scan, iwl3945_bg_abort_scan);
 	INIT_WORK(&priv->rf_kill, iwl3945_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
+	INIT_WORK(&priv->set_monitor, iwl3945_bg_set_monitor);
 	INIT_DELAYED_WORK(&priv->post_associate, iwl3945_bg_post_associate);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
-- 
1.5.3.6

