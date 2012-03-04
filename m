Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab2CDUnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 075/101] iwlwifi: remove BT handlers from lib_ops
Date: Sun,  4 Mar 2012 11:29:29 -0800
Message-Id: <1330889395-533-76-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214503_341932_C976937C)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have operations for
these as they simply depend on whether
the device has built-in bluetooth, so
just duplicate the information already
there (whether bt_params is present or
not).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    3 ---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |    5 ++---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-core.h   |    6 ------
 5 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index db6df69..2c03858 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -154,9 +154,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 
 static struct iwl_lib_ops iwl2030_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
-	.bt_rx_handler_setup = iwlagn_bt_rx_handler_setup,
-	.bt_setup_deferred_work = iwlagn_bt_setup_deferred_work,
-	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.nic_config = iwl2000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 6f7d5f0..510a5c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -250,9 +250,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 
 static struct iwl_lib_ops iwl6030_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.bt_rx_handler_setup = iwlagn_bt_rx_handler_setup,
-	.bt_setup_deferred_work = iwlagn_bt_setup_deferred_work,
-	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.nic_config = iwl6000_nic_config,
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index a9bdbad..e504675 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1143,9 +1143,8 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	iwl_notification_wait_init(&priv->notif_wait);
 
 	/* Set up BT Rx handlers */
-	if (cfg(priv)->lib->bt_rx_handler_setup)
-		cfg(priv)->lib->bt_rx_handler_setup(priv);
-
+	if (cfg(priv)->bt_params)
+		iwlagn_bt_rx_handler_setup(priv);
 }
 
 int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_cmd_buffer *rxb,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 29f40ea..5f390f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -976,8 +976,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 	iwl_setup_scan_deferred_work(priv);
 
-	if (cfg(priv)->lib->bt_setup_deferred_work)
-		cfg(priv)->lib->bt_setup_deferred_work(priv);
+	if (cfg(priv)->bt_params)
+		iwlagn_bt_setup_deferred_work(priv);
 
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
@@ -994,8 +994,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
-	if (cfg(priv)->lib->cancel_deferred_work)
-		cfg(priv)->lib->cancel_deferred_work(priv);
+	if (cfg(priv)->bt_params)
+		iwlagn_bt_cancel_deferred_work(priv);
 
 	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e0423c4..95f6b7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -77,12 +77,6 @@ struct iwl_cmd;
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	void (*set_hw_params)(struct iwl_priv *priv);
-	/* setup BT Rx handler */
-	void (*bt_rx_handler_setup)(struct iwl_priv *priv);
-	/* setup BT related deferred work */
-	void (*bt_setup_deferred_work)(struct iwl_priv *priv);
-	/* cancel deferred work */
-	void (*cancel_deferred_work)(struct iwl_priv *priv);
 	int (*set_channel_switch)(struct iwl_priv *priv,
 				  struct ieee80211_channel_switch *ch_switch);
 	/* device specific configuration */
-- 
1.7.0.4

