Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbZA2TGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:06:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/7] iwlwifi: define structures and functions externally for customization
Date: Thu, 29 Jan 2009 11:09:15 -0800
Message-Id: <1233256157-21290-6-git-send-email-reinette.chatre@intel.com> (sfid-20090129_200630_366207_04E31837)
In-Reply-To: <1233256157-21290-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233256157-21290-1-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-2-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-3-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-4-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

defined the structures and functions as extern to alter behavior used by
5000 series for other products including 100 and 6000 series

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |   12 ++++++++++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5b59286..2b37aa7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -394,7 +394,7 @@ static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
 	}
 }
 
-static void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
+void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 			__le32 *tx_flags)
 {
 	if ((info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
@@ -1105,7 +1105,7 @@ static int iwl5000_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	return 0;
 }
 
-static u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
+u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 {
 	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
 	memcpy(data, cmd, size);
@@ -1334,7 +1334,7 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 }
 
 /* Currently 5000 is the superset of everything */
-static u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
+u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
 {
 	return len;
 }
@@ -1435,7 +1435,7 @@ static void iwl5000_temperature(struct iwl_priv *priv)
 }
 
 /* Calc max signal level (dBm) among 3 possible receivers */
-static int iwl5000_calc_rssi(struct iwl_priv *priv,
+int iwl5000_calc_rssi(struct iwl_priv *priv,
 			     struct iwl_rx_phy_res *rx_resp)
 {
 	/* data from PHY/DSP regarding signal strength, etc.,
@@ -1472,11 +1472,11 @@ static int iwl5000_calc_rssi(struct iwl_priv *priv,
 	return max_rssi - agc - IWL49_RSSI_OFFSET;
 }
 
-static struct iwl_hcmd_ops iwl5000_hcmd = {
+struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
 };
 
-static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
+struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 	.get_hcmd_size = iwl5000_get_hcmd_size,
 	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
 	.gain_computation = iwl5000_gain_computation,
@@ -1485,7 +1485,7 @@ static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 	.calc_rssi = iwl5000_calc_rssi,
 };
 
-static struct iwl_lib_ops iwl5000_lib = {
+struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b9954bc..afde713 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -67,6 +67,18 @@ extern struct iwl_cfg iwl100_bgn_cfg;
 /* shared structures from iwl-5000.c */
 extern struct iwl_mod_params iwl50_mod_params;
 extern struct iwl_ops iwl5000_ops;
+extern struct iwl_lib_ops iwl5000_lib;
+extern struct iwl_hcmd_ops iwl5000_hcmd;
+extern struct iwl_hcmd_utils_ops iwl5000_hcmd_utils;
+
+/* shared functions from iwl-5000.c */
+extern u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len);
+extern u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd,
+				     u8 *data);
+extern void iwl5000_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
+				    __le32 *tx_flags);
+extern int iwl5000_calc_rssi(struct iwl_priv *priv,
+			     struct iwl_rx_phy_res *rx_resp);
 
 /* CT-KILL constants */
 #define CT_KILL_THRESHOLD	110 /* in Celsius */
-- 
1.5.4.3

