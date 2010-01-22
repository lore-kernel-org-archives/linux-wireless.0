Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab0AVWXK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 17:23:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/17] iwlwifi: make broadcast station addition generic
Date: Fri, 22 Jan 2010 14:22:49 -0800
Message-Id: <1264198978-5915-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
References: <1264198978-5915-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Add function pointer for broadcast station addition so that we can call it
in from iwlcore at a later time. We only distinguish between iwlagn and
iwl3945 broadcast station addition. For the iwl3945 station addition we add
that function to iwlcore since that is where most station functionality
resides, making it part of iwl3945 will require significant code
reorganization that will dilute station management functionality. This
seems to be an efficient solution.

It may seem as though we are removing error checking when adding the 3945
broadcast station but this error checking was never really necessary since
the function returns the station id and the broadcast station id is always
set.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c |    7 ++-----
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-6000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.h  |    1 +
 9 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 85162e2..4281999 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -140,6 +140,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.temperature = iwl5000_temperature,
 		.set_ct_kill = iwl1000_set_ct_threshold,
 	 },
+	.add_bcast_station = iwl_add_bcast_station,
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 764479f..57194bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1951,11 +1951,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	}
 
 	/* Add the broadcast address so we can send broadcast frames */
-	if (iwl_add_station(priv, iwl_bcast_addr, false, CMD_SYNC, NULL) ==
-	    IWL_INVALID_STATION) {
-		IWL_ERR(priv, "Error adding BROADCAST address for transmit.\n");
-		return -EIO;
-	}
+	priv->cfg->ops->lib->add_bcast_station(priv);
 
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
@@ -2796,6 +2792,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.post_associate = iwl3945_post_associate,
 	.isr = iwl_isr_legacy,
 	.config_ap = iwl3945_config_ap,
+	.add_bcast_station = iwl3945_add_bcast_station,
 };
 
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c36fef9..aebe8c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2206,6 +2206,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.temperature = iwl4965_temperature_calib,
 		.set_ct_kill = iwl4965_set_ct_threshold,
 	},
+	.add_bcast_station = iwl_add_bcast_station,
 };
 
 static const struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cbbc0e4..6027e2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1503,6 +1503,7 @@ struct iwl_lib_ops iwl5000_lib = {
 		.temperature = iwl5000_temperature,
 		.set_ct_kill = iwl5000_set_ct_threshold,
 	 },
+	.add_bcast_station = iwl_add_bcast_station,
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -1556,6 +1557,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.temperature = iwl5150_temperature,
 		.set_ct_kill = iwl5150_set_ct_threshold,
 	 },
+	.add_bcast_station = iwl_add_bcast_station,
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f89ef4a..81e03e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -266,6 +266,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.temperature = iwl5000_temperature,
 		.set_ct_kill = iwl6000_set_ct_threshold,
 	 },
+	.add_bcast_station = iwl_add_bcast_station,
 };
 
 static const struct iwl_ops iwl6000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a1c560f..537837b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -203,7 +203,8 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 	priv->start_calib = 0;
 
 	/* Add the broadcast address so we can send broadcast frames */
-	iwl_add_bcast_station(priv);
+	priv->cfg->ops->lib->add_bcast_station(priv);
+
 
 	/* If we have set the ASSOC_MSK and we are in BSS mode then
 	 * add the IWL_AP_ID to the station rate table */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6619183..e14e329 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -188,6 +188,8 @@ struct iwl_lib_ops {
 
 	/* temperature */
 	struct iwl_temp_ops temp_ops;
+	/* station management */
+	void (*add_bcast_station)(struct iwl_priv *priv);
 };
 
 struct iwl_led_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 842f156..fcac73c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1127,6 +1127,7 @@ static void iwl_sta_init_bcast_lq(struct iwl_priv *priv)
  */
 void iwl_add_bcast_station(struct iwl_priv *priv)
 {
+	IWL_DEBUG_INFO(priv, "Adding broadcast station to station table\n");
 	iwl_add_station(priv, iwl_bcast_addr, false, CMD_SYNC, NULL);
 
 	/* Set up default rate scaling table in device's station table */
@@ -1135,6 +1136,16 @@ void iwl_add_bcast_station(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_add_bcast_station);
 
 /**
+ * iwl3945_add_bcast_station - add broadcast station into station table.
+ */
+void iwl3945_add_bcast_station(struct iwl_priv *priv)
+{
+	IWL_DEBUG_INFO(priv, "Adding broadcast station to station table\n");
+	iwl_add_station(priv, iwl_bcast_addr, false, CMD_SYNC, NULL);
+}
+EXPORT_SYMBOL(iwl3945_add_bcast_station);
+
+/**
  * iwl_get_sta_id - Find station's index within station table
  *
  * If new IBSS station, create new entry in station table
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 8c6850d..2dc35fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -53,6 +53,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
 void iwl_add_bcast_station(struct iwl_priv *priv);
+void iwl3945_add_bcast_station(struct iwl_priv *priv);
 int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, bool is_ap);
 void iwl_clear_stations_table(struct iwl_priv *priv);
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
-- 
1.6.3.3

