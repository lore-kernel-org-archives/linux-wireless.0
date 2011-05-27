Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1E0QH7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:07:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/10] iwlagn: remove un-necessary tx power ops
Date: Fri, 27 May 2011 08:40:25 -0700
Message-Id: <1306510833-32049-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180804_228029_2D88B849)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All agn devices use the same tx power function, remove the ops

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-2000.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 +----
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 6 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 61d4a11..9940950 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -174,7 +174,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init = iwl_apm_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 86feec8..a37c41b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -256,7 +256,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl2030_hw_channel_switch,
 	.apm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a70b8cf..a8dbbd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -342,7 +342,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
@@ -373,7 +372,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
 	.apm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f8c710d..eabf3b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -281,7 +281,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
@@ -314,7 +313,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
 	.apm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4653dea..52e9413 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1131,9 +1131,6 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	if (priv->tx_power_user_lmt == tx_power && !force)
 		return 0;
 
-	if (!priv->cfg->ops->lib->send_tx_power)
-		return -EOPNOTSUPP;
-
 	if (tx_power < IWLAGN_TX_POWER_TARGET_POWER_MIN) {
 		IWL_WARN(priv,
 			 "Requested user TXPOWER %d below lower limit %d.\n",
@@ -1167,7 +1164,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	prev_tx_power = priv->tx_power_user_lmt;
 	priv->tx_power_user_lmt = tx_power;
 
-	ret = priv->cfg->ops->lib->send_tx_power(priv);
+	ret = iwlagn_send_tx_power(priv);
 
 	/* if fail to set tx_power, restore the orig. tx power */
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3bb76f6..a87b54f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -141,7 +141,6 @@ struct iwl_lib_ops {
 	struct iwl_apm_ops apm_ops;
 
 	/* power */
-	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
 
 	/* eeprom operations (as defined in iwl-eeprom.h) */
-- 
1.7.0.4

