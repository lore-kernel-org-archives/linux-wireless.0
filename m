Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab1GPPcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/18] iwlagn: remove indirection for iwlagn_hw_valid_rtc_data_addr
Date: Sat, 16 Jul 2011 07:56:34 -0700
Message-Id: <1310828199-18000-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173220_654857_4F09384D)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fry, Donald H <donald.h.fry@intel.com>

Not needed since the driver split.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 --
 6 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index e21f718..fe15a46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -170,7 +170,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.set_hw_params = iwl1000_hw_set_hw_params,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.nic_config = iwl1000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 68ee25b..7e0f766 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -169,7 +169,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.nic_config = iwl2000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
@@ -191,7 +190,6 @@ static struct iwl_lib_ops iwl2030_lib = {
 	.rx_handler_setup = iwlagn_bt_rx_handler_setup,
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
-	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.nic_config = iwl2000_nic_config,
 	.eeprom_ops = {
 		.regulatory_bands = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 33b383c..e090878 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -322,7 +322,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.nic_config = iwl5000_nic_config,
 	.eeprom_ops = {
@@ -343,7 +342,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.set_hw_params = iwl5150_hw_set_hw_params,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.nic_config = iwl5000_nic_config,
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index cffff09..3b2d753 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -260,7 +260,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.nic_config = iwl6000_nic_config,
 	.eeprom_ops = {
@@ -283,7 +282,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.rx_handler_setup = iwlagn_bt_rx_handler_setup,
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
-	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.nic_config = iwl6000_nic_config,
 	.eeprom_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 41c3e15..c2a1241 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -375,7 +375,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 	u32 next_entry; /* index of next entry to be written by uCode */
 
 	base = priv->device_pointers.error_event_table;
-	if (priv->cfg->lib->is_valid_rtc_data_addr(base)) {
+	if (iwlagn_hw_valid_rtc_data_addr(base)) {
 		capacity = iwl_read_targ_mem(priv, base);
 		num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
 		mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
@@ -1614,7 +1614,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 			base = priv->_agn.inst_errlog_ptr;
 	}
 
-	if (!priv->cfg->lib->is_valid_rtc_data_addr(base)) {
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
@@ -1805,7 +1805,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 			base = priv->_agn.inst_evtlog_ptr;
 	}
 
-	if (!priv->cfg->lib->is_valid_rtc_data_addr(base)) {
+	if (!iwlagn_hw_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
 			base,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5187318..2318052 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -89,8 +89,6 @@ struct iwl_lib_ops {
 	void (*setup_deferred_work)(struct iwl_priv *priv);
 	/* cancel deferred work */
 	void (*cancel_deferred_work)(struct iwl_priv *priv);
-	/* check validity of rtc data address */
-	int (*is_valid_rtc_data_addr)(u32 addr);
 	int (*set_channel_switch)(struct iwl_priv *priv,
 				  struct ieee80211_channel_switch *ch_switch);
 	/* device specific configuration */
-- 
1.7.0.4

