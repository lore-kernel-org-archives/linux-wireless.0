Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab1DERB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/25] iwlagn: clean up ucode loading
Date: Tue,  5 Apr 2011 09:41:51 -0700
Message-Id: <1302021732-21250-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All agn devices behave the same, so there's no
need to go through function pointers for any
of the ucode loading functionality.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    3 ---
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    6 ------
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    6 ------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-core.h      |    7 +------
 7 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 2601b55..ad50063 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -185,13 +185,10 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.init_alive_start = iwlagn_init_alive_start,
-	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 55274a1..5e375d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -266,13 +266,10 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.init_alive_start = iwlagn_init_alive_start,
-	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl2030_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8cab357..0e1f0b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -358,9 +358,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.load_ucode = iwlagn_load_ucode,
-	.init_alive_start = iwlagn_init_alive_start,
-	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
@@ -423,9 +420,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
-	.load_ucode = iwlagn_load_ucode,
-	.init_alive_start = iwlagn_init_alive_start,
-	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7ecfbbc..4d545e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -294,13 +294,10 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.init_alive_start = iwlagn_init_alive_start,
-	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
@@ -362,13 +359,10 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
 	.dump_csr = iwl_dump_csr,
 	.dump_fh = iwl_dump_fh,
-	.init_alive_start = iwlagn_init_alive_start,
-	.alive_notify = iwlagn_alive_notify,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index d807e5e..5d35e35 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -318,7 +318,7 @@ void iwlagn_init_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	ret = priv->cfg->ops->lib->alive_notify(priv);
+	ret = iwlagn_alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
 			"Could not complete ALIVE transition: %d\n", ret);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a437d91..18d6d66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2246,7 +2246,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
-	ret = priv->cfg->ops->lib->alive_notify(priv);
+	ret = iwlagn_alive_notify(priv);
 	if (ret) {
 		IWL_WARN(priv,
 			"Could not complete ALIVE transition [ntf]: %d\n", ret);
@@ -2582,7 +2582,7 @@ static int __iwl_up(struct iwl_priv *priv)
 		/* load bootstrap state machine,
 		 * load bootstrap program into processor's memory,
 		 * prepare to load the "initialize" uCode */
-		ret = priv->cfg->ops->lib->load_ucode(priv);
+		ret = iwlagn_load_ucode(priv);
 
 		if (ret) {
 			IWL_ERR(priv, "Unable to set up bootstrap uCode: %d\n",
@@ -2624,7 +2624,7 @@ static void iwl_bg_init_alive_start(struct work_struct *data)
 		return;
 
 	mutex_lock(&priv->mutex);
-	priv->cfg->ops->lib->init_alive_start(priv);
+	iwlagn_init_alive_start(priv);
 	mutex_unlock(&priv->mutex);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 967b4c0..46c90b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -177,14 +177,9 @@ struct iwl_lib_ops {
 	void (*setup_deferred_work)(struct iwl_priv *priv);
 	/* cancel deferred work */
 	void (*cancel_deferred_work)(struct iwl_priv *priv);
-	/* alive notification after init uCode load */
-	void (*init_alive_start)(struct iwl_priv *priv);
-	/* alive notification */
-	int (*alive_notify)(struct iwl_priv *priv);
 	/* check validity of rtc data address */
 	int (*is_valid_rtc_data_addr)(u32 addr);
-	/* 1st ucode load */
-	int (*load_ucode)(struct iwl_priv *priv);
+
 	int (*dump_nic_event_log)(struct iwl_priv *priv,
 				  bool full_log, char **buf, bool display);
 	void (*dump_nic_error_log)(struct iwl_priv *priv);
-- 
1.7.0.4

