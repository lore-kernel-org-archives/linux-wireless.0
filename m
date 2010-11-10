Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab0KJSBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/16] iwlwifi: legacy tx_cmd_protection function
Date: Wed, 10 Nov 2010 09:56:41 -0800
Message-Id: <1289411810-23093-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Legacy (4965 and 3945) devices has different tx_cmd_protection routine.
Move to iwl-legacy.c

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |   34 -----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    4 +--
 drivers/net/wireless/iwlwifi/iwl-legacy.c |   34 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-legacy.h |    3 ++
 6 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7d3e414..a19b811 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2745,7 +2745,7 @@ static const struct iwl_legacy_ops iwl3945_legacy_ops = {
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.get_hcmd_size = iwl3945_get_hcmd_size,
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
-	.tx_cmd_protection = iwlcore_tx_cmd_protection,
+	.tx_cmd_protection = iwl_legacy_tx_cmd_protection,
 	.request_scan = iwl3945_request_scan,
 	.post_scan = iwl3945_post_scan,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c515671..8cb88d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2518,7 +2518,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.build_addsta_hcmd = iwl4965_build_addsta_hcmd,
 	.chain_noise_reset = iwl4965_chain_noise_reset,
 	.gain_computation = iwl4965_gain_computation,
-	.tx_cmd_protection = iwlcore_tx_cmd_protection,
+	.tx_cmd_protection = iwl_legacy_tx_cmd_protection,
 	.calc_rssi = iwl4965_calc_rssi,
 	.request_scan = iwlagn_request_scan,
 	.post_scan = iwl4965_post_scan,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 88c6de7..5460560 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -288,40 +288,6 @@ void iwlcore_free_geos(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwlcore_free_geos);
 
-/*
- *  iwlcore_tx_cmd_protection: Set rts/cts. 3945 and 4965 only share this
- *  function.
- */
-void iwlcore_tx_cmd_protection(struct iwl_priv *priv,
-			       struct ieee80211_tx_info *info,
-			       __le16 fc, __le32 *tx_flags)
-{
-	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
-		*tx_flags |= TX_CMD_FLG_RTS_MSK;
-		*tx_flags &= ~TX_CMD_FLG_CTS_MSK;
-		*tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
-
-		if (!ieee80211_is_mgmt(fc))
-			return;
-
-		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-		case cpu_to_le16(IEEE80211_STYPE_AUTH):
-		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
-		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
-		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
-			*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-			*tx_flags |= TX_CMD_FLG_CTS_MSK;
-			break;
-		}
-	} else if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-		*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-		*tx_flags |= TX_CMD_FLG_CTS_MSK;
-		*tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
-	}
-}
-EXPORT_SYMBOL(iwlcore_tx_cmd_protection);
-
-
 static bool iwl_is_channel_extension(struct iwl_priv *priv,
 				     enum ieee80211_band band,
 				     u16 channel, u8 extension_chan_offset)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6275c05..8f3cc23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -447,9 +447,7 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw,
 			     enum nl80211_iftype newtype, bool newp2p);
 int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
-void iwlcore_tx_cmd_protection(struct iwl_priv *priv,
-			       struct ieee80211_tx_info *info,
-			       __le16 fc, __le32 *tx_flags);
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.c b/drivers/net/wireless/iwlwifi/iwl-legacy.c
index f49e500..10d9c42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-legacy.c
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.c
@@ -620,3 +620,37 @@ none:
 	return IRQ_NONE;
 }
 EXPORT_SYMBOL(iwl_isr_legacy);
+
+/*
+ *  iwl_legacy_tx_cmd_protection: Set rts/cts. 3945 and 4965 only share this
+ *  function.
+ */
+void iwl_legacy_tx_cmd_protection(struct iwl_priv *priv,
+			       struct ieee80211_tx_info *info,
+			       __le16 fc, __le32 *tx_flags)
+{
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
+		*tx_flags |= TX_CMD_FLG_RTS_MSK;
+		*tx_flags &= ~TX_CMD_FLG_CTS_MSK;
+		*tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
+
+		if (!ieee80211_is_mgmt(fc))
+			return;
+
+		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_AUTH):
+		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
+		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
+			*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+			*tx_flags |= TX_CMD_FLG_CTS_MSK;
+			break;
+		}
+	} else if (info->control.rates[0].flags &
+		   IEEE80211_TX_RC_USE_CTS_PROTECT) {
+		*tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+		*tx_flags |= TX_CMD_FLG_CTS_MSK;
+		*tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
+	}
+}
+EXPORT_SYMBOL(iwl_legacy_tx_cmd_protection);
diff --git a/drivers/net/wireless/iwlwifi/iwl-legacy.h b/drivers/net/wireless/iwlwifi/iwl-legacy.h
index 81d1ccd..9f7b2f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-legacy.h
+++ b/drivers/net/wireless/iwlwifi/iwl-legacy.h
@@ -70,6 +70,9 @@ void iwl_legacy_mac_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
 				     u32 changes);
+void iwl_legacy_tx_cmd_protection(struct iwl_priv *priv,
+				struct ieee80211_tx_info *info,
+				__le16 fc, __le32 *tx_flags);
 
 irqreturn_t iwl_isr_legacy(int irq, void *data);
 
-- 
1.7.0.4

