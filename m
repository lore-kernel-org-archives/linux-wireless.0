Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722Ab1D3Qks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/14] iwlagn: use proper good CRC threshold behaviour
Date: Sat, 30 Apr 2011 09:17:33 -0700
Message-Id: <1304180260-13875-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184113_696380_EE006444)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

New microcode versions use the good CRC threshold
field differently, as a flag, and in that case we
should set it to 1/0 instead of 1/65535 for an
active/passive scan.

The new behaviour is advertised by the uCode with
a feature flag.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   12 ++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    3 +++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    7 +++++--
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 75e1035..7fe9e0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1294,9 +1294,17 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	 * mean we never reach it, but at the same time work around
 	 * the aforementioned issue. Thus use IWL_GOOD_CRC_TH_NEVER
 	 * here instead of IWL_GOOD_CRC_TH_DISABLED.
+	 *
+	 * This was fixed in later versions along with some other
+	 * scan changes, and the threshold behaves as a flag in those
+	 * versions.
 	 */
-	scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
-					IWL_GOOD_CRC_TH_NEVER;
+	if (priv->new_scan_threshold_behaviour)
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
+						IWL_GOOD_CRC_TH_DISABLED;
+	else
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
+						IWL_GOOD_CRC_TH_NEVER;
 
 	band = priv->scan_band;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c27147c..395d1ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1716,6 +1716,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			priv->cfg->base_params->max_event_log_size;
 	priv->_agn.inst_errlog_ptr = pieces.inst_errlog_ptr;
 
+	priv->new_scan_threshold_behaviour =
+		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
+
 	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->valid_contexts |= BIT(IWL_RXON_CTX_PAN);
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 197fa74..f098eff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -547,12 +547,13 @@ enum iwl_ucode_tlv_type {
  * enum iwl_ucode_tlv_flag - ucode API flags
  * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
  *	was a separate TLV but moved here to save space.
- * @IWL_UCODE_TLV_FLAGS_RESERVED_1: reserved
+ * @IWL_UCODE_TLV_FLAGS_NEWSCAN: new uCode scan behaviour on hidden SSID,
+ *	treats good CRC threshold as a boolean
  * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN		= BIT(0),
-	IWL_UCODE_TLV_FLAGS_RESERVED_1	= BIT(1),
+	IWL_UCODE_TLV_FLAGS_NEWSCAN	= BIT(1),
 	IWL_UCODE_TLV_FLAGS_MFP		= BIT(2),
 };
 
@@ -1263,6 +1264,8 @@ struct iwl_priv {
 	/* max number of station keys */
 	u8 sta_key_max_num;
 
+	bool new_scan_threshold_behaviour;
+
 	/* EEPROM MAC addresses */
 	struct mac_address addresses[2];
 
-- 
1.7.0.4

