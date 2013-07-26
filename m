Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZI3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>
Subject: [PATCH 16/30] iwlwifi: mvm: Enable user set TX power
Date: Fri, 26 Jul 2013 10:28:33 +0200
Message-Id: <1374827327-3464-17-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103019_962469_4501F80B)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Support Tx power limitations. These limitations can come from
mac80211 for various reasons.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |  8 ++++++--
 drivers/net/wireless/iwlwifi/mvm/fw-api.h    | 14 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 20 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c       |  1 +
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index acd2665..b76a9a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -118,6 +118,7 @@ static const u8 iwl_nvm_channels[] = {
 #define LAST_2GHZ_HT_PLUS	9
 #define LAST_5GHZ_HT		161
 
+#define DEFAULT_MAX_TX_POWER 16
 
 /* rate data (static) */
 static struct ieee80211_rate iwl_cfg80211_rates[] = {
@@ -232,8 +233,11 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 		/* Initialize regulatory-based run-time data */
 
-		/* TODO: read the real value from the NVM */
-		channel->max_power = 0;
+		/*
+		 * Default value - highest tx power value.  max_power
+		 * is not used in mvm, and is used for backwards compatibility
+		 */
+		channel->max_power = DEFAULT_MAX_TX_POWER;
 		is_5ghz = channel->band == IEEE80211_BAND_5GHZ;
 		IWL_DEBUG_EEPROM(dev,
 				 "Ch. %d [%sGHz] %s%s%s%s%s%s(0x%02x %ddBm): Ad-Hoc %ssupported\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 28cab82..5003500 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -159,6 +159,7 @@ enum {
 	TX_ANT_CONFIGURATION_CMD = 0x98,
 	BT_CONFIG = 0x9b,
 	STATISTICS_NOTIFICATION = 0x9d,
+	REDUCE_TX_POWER_CMD = 0x9f,
 
 	/* RF-KILL commands and notifications */
 	CARD_STATE_CMD = 0xa0,
@@ -226,6 +227,19 @@ struct iwl_tx_ant_cfg_cmd {
 	__le32 valid;
 } __packed;
 
+/**
+ * struct iwl_reduce_tx_power_cmd - TX power reduction command
+ * REDUCE_TX_POWER_CMD = 0x9f
+ * @flags: (reserved for future implementation)
+ * @mac_context_id: id of the mac ctx for which we are reducing TX power.
+ * @pwr_restriction: TX power restriction in half dBms.
+ */
+struct iwl_reduce_tx_power_cmd {
+	u8 flags;
+	u8 mac_context_id;
+	__le16 pwr_restriction;
+} __packed; /* TX_REDUCED_POWER_API_S_VER_1 */
+
 /*
  * Calibration control struct.
  * Sent as part of the phy configuration command.
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 30319e0..f8b6300 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -714,6 +714,21 @@ out_release:
 	mutex_unlock(&mvm->mutex);
 }
 
+static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+				s8 tx_power)
+{
+	/* FW is in charge of regulatory enforcement */
+	struct iwl_reduce_tx_power_cmd reduce_txpwr_cmd = {
+		.mac_context_id = iwl_mvm_vif_from_mac80211(vif)->id,
+		/* half dBm need to multiply */
+		.pwr_restriction = cpu_to_le16(2 * tx_power),
+	};
+
+	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, CMD_SYNC,
+				    sizeof(reduce_txpwr_cmd),
+				    &reduce_txpwr_cmd);
+}
+
 static int iwl_mvm_mac_config(struct ieee80211_hw *hw, u32 changed)
 {
 	return 0;
@@ -794,6 +809,11 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
 	}
+	if (changes & BSS_CHANGED_TXPOWER) {
+		IWL_DEBUG_CALIB(mvm, "Changing TX Power to %d\n",
+				bss_conf->txpower);
+		iwl_mvm_set_tx_power(mvm, vif, bss_conf->txpower);
+	}
 }
 
 static int iwl_mvm_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 2ffa593..ef1ad5b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -275,6 +275,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BEACON_NOTIFICATION),
 	CMD(BEACON_TEMPLATE_CMD),
 	CMD(STATISTICS_NOTIFICATION),
+	CMD(REDUCE_TX_POWER_CMD),
 	CMD(TX_ANT_CONFIGURATION_CMD),
 	CMD(D3_CONFIG_CMD),
 	CMD(PROT_OFFLOAD_CONFIG_CMD),
-- 
1.8.0

