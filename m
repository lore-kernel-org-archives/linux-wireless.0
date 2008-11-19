Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10060 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbYKSXb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:57 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/7] iwlwifi: move iwl_clear_stations_table to iwl-sta.c
Date: Wed, 19 Nov 2008 15:32:23 -0800
Message-Id: <1227137548-28718-3-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003215_795299_EA586317)
In-Reply-To: <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch moves iwl_clear_stations_table into iwl-sta.c

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   23 +----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h  |    1 +
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8bd4d08..9a2e964 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -37,6 +37,7 @@
 #include "iwl-io.h"
 #include "iwl-rfkill.h"
 #include "iwl-power.h"
+#include "iwl-sta.h"
 
 
 MODULE_DESCRIPTION("iwl core");
@@ -237,28 +238,6 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_hw_nic_init);
 
-/**
- * iwl_clear_stations_table - Clear the driver's station table
- *
- * NOTE:  This does not clear or otherwise alter the device's station table.
- */
-void iwl_clear_stations_table(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	if (iwl_is_alive(priv) &&
-	   !test_bit(STATUS_EXIT_PENDING, &priv->status) &&
-	   iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL))
-		IWL_ERROR("Couldn't clear the station table\n");
-
-	priv->num_stations = 0;
-	memset(priv->stations, 0, sizeof(priv->stations));
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-}
-EXPORT_SYMBOL(iwl_clear_stations_table);
 
 void iwl_reset_qos(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5d4e2e2..82bf263 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -182,7 +182,6 @@ struct iwl_cfg {
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
 void iwl_hw_detect(struct iwl_priv *priv);
-void iwl_clear_stations_table(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
 int iwl_set_rxon_channel(struct iwl_priv *priv, struct ieee80211_channel *ch);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 2529c23..0222ef8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -470,6 +470,29 @@ out:
 }
 EXPORT_SYMBOL(iwl_remove_station);
 
+/**
+ * iwl_clear_stations_table - Clear the driver's station table
+ *
+ * NOTE:  This does not clear or otherwise alter the device's station table.
+ */
+void iwl_clear_stations_table(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	if (iwl_is_alive(priv) &&
+	   !test_bit(STATUS_EXIT_PENDING, &priv->status) &&
+	   iwl_send_cmd_pdu_async(priv, REPLY_REMOVE_ALL_STA, 0, NULL, NULL))
+		IWL_ERROR("Couldn't clear the station table\n");
+
+	priv->num_stations = 0;
+	memset(priv->stations, 0, sizeof(priv->stations));
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+}
+EXPORT_SYMBOL(iwl_clear_stations_table);
+
 static int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 61eede5..7b98ea4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -53,6 +53,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
+void iwl_clear_stations_table(struct iwl_priv *priv);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 u8 iwl_add_station_flags(struct iwl_priv *priv, const u8 *addr,
-- 
1.5.4.3

