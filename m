Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab0EJW2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 47/47] iwlwifi: clear driver stations when going down
Date: Mon, 10 May 2010 15:28:18 -0700
Message-Id: <1273530498-11876-48-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During a hw restart, mac80211 will attempt to
reconfigure all stations. Currently, that fails
and leads to warnings because we still have the
stations marked active. Therefore, clear all
stations when doing down.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   19 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dd26965..47563cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2405,6 +2405,7 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	iwl_clear_ucode_stations(priv);
 	iwl_dealloc_bcast_station(priv);
+	iwl_clear_driver_stations(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 6427148..c2a453a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -81,6 +81,25 @@ int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 void iwl_sta_modify_ps_wake(struct iwl_priv *priv, int sta_id);
 void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
 
+/**
+ * iwl_clear_driver_stations - clear knowledge of all stations from driver
+ * @priv: iwl priv struct
+ *
+ * This is called during iwl_down() to make sure that in the case
+ * we're coming there from a hardware restart mac80211 will be
+ * able to reconfigure stations -- if we're getting there in the
+ * normal down flow then the stations will already be cleared.
+ */
+static inline void iwl_clear_driver_stations(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	memset(priv->stations, 0, sizeof(priv->stations));
+	priv->num_stations = 0;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+}
+
 static inline int iwl_sta_id(struct ieee80211_sta *sta)
 {
 	if (WARN_ON(!sta))
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4916f23..4c78783 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2585,6 +2585,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	/* Station information will now be cleared in device */
 	iwl_clear_ucode_stations(priv);
 	iwl_dealloc_bcast_station(priv);
+	iwl_clear_driver_stations(priv);
 
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
-- 
1.6.3.3

