Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1GUP0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.guy@intel.com>
Subject: [PATCH 03/25] iwlagn: kill iwlagn_setup_deferred_work
Date: Thu, 21 Jul 2011 07:50:06 -0700
Message-Id: <1311259828-8415-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172647_499836_76A24D5F)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since iwlagn_setup_deferred_work is always called, fold it into
iwl_setup_deferred_work. BT related works are setup by the new
bt_setup_deferred_work lib_ops.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    3 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    3 +--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   10 ----------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h    |    4 ++--
 8 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5fa1719..01b49eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -168,7 +168,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 static struct iwl_lib_ops iwl1000_lib = {
 	.set_hw_params = iwl1000_hw_set_hw_params,
-	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.nic_config = iwl1000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index c913410..aff555c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -167,7 +167,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 
 static struct iwl_lib_ops iwl2000_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
-	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.nic_config = iwl2000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
@@ -187,7 +186,7 @@ static struct iwl_lib_ops iwl2000_lib = {
 static struct iwl_lib_ops iwl2030_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
 	.bt_rx_handler_setup = iwlagn_bt_rx_handler_setup,
-	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
+	.bt_setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.nic_config = iwl2000_nic_config,
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 4e1204a..8c6fbd7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -320,7 +320,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
-	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.nic_config = iwl5000_nic_config,
 	.eeprom_ops = {
@@ -339,7 +338,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 
 static struct iwl_lib_ops iwl5150_lib = {
 	.set_hw_params = iwl5150_hw_set_hw_params,
-	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.nic_config = iwl5000_nic_config,
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f1fdcdc..ea48246 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -258,7 +258,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.nic_config = iwl6000_nic_config,
 	.eeprom_ops = {
@@ -279,7 +278,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 static struct iwl_lib_ops iwl6030_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
 	.bt_rx_handler_setup = iwlagn_bt_rx_handler_setup,
-	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
+	.bt_setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.nic_config = iwl6000_nic_config,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 5d6258d..339a89c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -478,14 +478,6 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-void iwlagn_setup_deferred_work(struct iwl_priv *priv)
-{
-	/*
-	 * nothing need to be done here anymore
-	 * still keep for future use if needed
-	 */
-}
-
 int iwlagn_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= IWLAGN_RTC_DATA_LOWER_BOUND) &&
@@ -1754,8 +1746,6 @@ void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv)
 
 void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv)
 {
-	iwlagn_setup_deferred_work(priv);
-
 	INIT_WORK(&priv->bt_traffic_change_work,
 		  iwlagn_bt_traffic_change_work);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d50c68a..503c786 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2845,8 +2845,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 	iwl_setup_scan_deferred_work(priv);
 
-	if (priv->cfg->lib->setup_deferred_work)
-		priv->cfg->lib->setup_deferred_work(priv);
+	if (priv->cfg->lib->bt_setup_deferred_work)
+		priv->cfg->lib->bt_setup_deferred_work(priv);
 
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d9fef63..57c70b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -162,7 +162,6 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 /* lib */
 void iwl_check_abort_status(struct iwl_priv *priv,
 			    u8 frame_count, u32 status);
-void iwlagn_setup_deferred_work(struct iwl_priv *priv);
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 int iwlagn_send_tx_power(struct iwl_priv *priv);
 void iwlagn_temperature(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6f825d3..a2cb1f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -85,8 +85,8 @@ struct iwl_lib_ops {
 	int (*set_hw_params)(struct iwl_priv *priv);
 	/* setup BT Rx handler */
 	void (*bt_rx_handler_setup)(struct iwl_priv *priv);
-	/* setup deferred work */
-	void (*setup_deferred_work)(struct iwl_priv *priv);
+	/* setup BT related deferred work */
+	void (*bt_setup_deferred_work)(struct iwl_priv *priv);
 	/* cancel deferred work */
 	void (*cancel_deferred_work)(struct iwl_priv *priv);
 	int (*set_channel_switch)(struct iwl_priv *priv,
-- 
1.7.0.4

