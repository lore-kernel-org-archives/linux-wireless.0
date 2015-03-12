Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbbCLNFD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:03 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/49] iwlwifi: mvm: LAR: Add chub mcc change notify command
Date: Thu, 12 Mar 2015 15:03:54 +0200
Message-Id: <1426165474-25586-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140513_307548_74C2EE94)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Chub (Communication Hub, CommsHUB) is a HW component that connects to the cellular
and connectivity cores that gets updates of mcc changes, and then notifies the FW
directly of any mcc change.

The ucode notifies the driver (via this command) that it should ask for an mcc update,
and the driver sends the ucode the update mcc command to set the updated regulatory info.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   | 20 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 56 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  7 ++++
 drivers/net/wireless/iwlwifi/mvm/nvm.c      | 26 +++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  1 +
 5 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 85afede..c4b59ec 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -214,6 +214,7 @@ enum {
 
 	/* Location Aware Regulatory */
 	MCC_UPDATE_CMD = 0xc8,
+	MCC_CHUB_UPDATE_CMD = 0xc9,
 
 	MARKER_CMD = 0xcb,
 
@@ -1715,6 +1716,25 @@ struct iwl_mcc_update_resp {
 	__le32 channels[0];
 } __packed; /* LAR_UPDATE_MCC_CMD_RESP_S */
 
+/**
+ * struct iwl_mcc_chub_notif - chub notifies of mcc change
+ * (MCC_CHUB_UPDATE_CMD = 0xc9)
+ * The Chub (Communication Hub, CommsHUB) is a HW component that connects to
+ * the cellular and connectivity cores that gets updates of the mcc, and
+ * notifies the ucode directly of any mcc change.
+ * The ucode requests the driver to request the device to update geographic
+ * regulatory  profile according to the given MCC (Mobile Country Code).
+ * The MCC is two letter-code, ascii upper case[A-Z] or '00' for world domain.
+ * 'ZZ' MCC will be used to switch to NVM default profile; in this case, the
+ * MCC in the cmd response will be the relevant MCC in the NVM.
+ * @mcc: given mobile country code
+ * @reserved: reserved for alignment
+ */
+struct iwl_mcc_chub_notif {
+	u16 mcc;
+	u16 reserved1;
+} __packed; /* LAR_MCC_NOTIFY_S */
+
 enum iwl_mcc_update_status {
 	MCC_RESP_NEW_CHAN_PROFILE,
 	MCC_RESP_SAME_CHAN_PROFILE,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2042554..0da8787 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -86,6 +86,7 @@
 #include "iwl-fw-error-dump.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
+#include "iwl-nvm-parse.h"
 
 static const struct ieee80211_iface_limit iwl_mvm_limits[] = {
 	{
@@ -301,6 +302,49 @@ static void iwl_mvm_reset_phy_ctxts(struct iwl_mvm *mvm)
 	}
 }
 
+struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
+						  const char *alpha2)
+{
+	struct ieee80211_regdomain *regd = NULL;
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mcc_update_resp *resp;
+
+	IWL_DEBUG_LAR(mvm, "Getting regdomain data for %s from FW\n", alpha2);
+
+	mutex_lock(&mvm->mutex);
+
+	/* change "99" to "ZZ" for the FW */
+	if (alpha2[0] == '9' && alpha2[1] == '9')
+		alpha2 = "ZZ";
+
+	resp = iwl_mvm_update_mcc(mvm, alpha2);
+	if (IS_ERR_OR_NULL(resp)) {
+		IWL_DEBUG_LAR(mvm, "Could not get update from FW %d\n",
+			      PTR_RET(resp));
+		goto out_unlock;
+	}
+
+	regd = iwl_parse_nvm_mcc_info(mvm->trans->dev,
+				      __le32_to_cpu(resp->n_channels),
+				      resp->channels,
+				      __le16_to_cpu(resp->mcc));
+	kfree(resp);
+	if (IS_ERR_OR_NULL(regd)) {
+		IWL_DEBUG_LAR(mvm, "Could not get parse update from FW %d\n",
+			      PTR_RET(resp));
+		goto out_unlock;
+	}
+
+	IWL_DEBUG_LAR(mvm, "setting alpha2 from FW to %s (0x%x, 0x%x)\n",
+		      regd->alpha2, regd->alpha2[0], regd->alpha2[1]);
+	mvm->lar_regdom_set = true;
+
+out_unlock:
+	mutex_unlock(&mvm->mutex);
+	return regd;
+}
+
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 {
 	struct ieee80211_hw *hw = mvm->hw;
@@ -2245,6 +2289,12 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
+		IWL_ERR(mvm, "scan while LAR regdomain is not set\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
 	if (mvm->scan_status != IWL_MVM_SCAN_NONE) {
 		ret = -EBUSY;
 		goto out;
@@ -2583,6 +2633,12 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	if (iwl_mvm_is_lar_supported(mvm) && !mvm->lar_regdom_set) {
+		IWL_ERR(mvm, "sched-scan while LAR regdomain is not set\n");
+		ret = -EBUSY;
+		goto out;
+	}
+
 	if (!vif->bss_conf.idle) {
 		ret = -EBUSY;
 		goto out;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b31f43c..df5a228 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -810,6 +810,8 @@ struct iwl_mvm {
 	/* system time of last beacon (for AP/GO interface) */
 	u32 ap_last_beacon_gp2;
 
+	bool lar_regdom_set;
+
 	u8 low_latency_agg_frame_limit;
 
 	/* TDLS channel switch data */
@@ -1398,6 +1400,11 @@ int iwl_mvm_get_temp(struct iwl_mvm *mvm);
 struct iwl_mcc_update_resp *
 iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2);
 int iwl_mvm_init_mcc(struct iwl_mvm *mvm);
+int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
+			       struct iwl_rx_cmd_buffer *rxb,
+			       struct iwl_device_cmd *cmd);
+struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
+						  const char *alpha2);
 
 /* smart fifo */
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 907e231..b88b4cd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -689,6 +689,30 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 	 * unknown-country "99" code. This will also clear the "custom reg"
 	 * flag and allow regdomain changes. It will happen after init since
 	 * RTNL is required.
+	 * Disallow scans that might crash the FW while the LAR regdomain
+	 * is not set.
 	 */
-	return regulatory_hint(mvm->hw->wiphy, "99");
+	mvm->lar_regdom_set = false;
+	return 0;
+}
+
+int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
+			       struct iwl_rx_cmd_buffer *rxb,
+			       struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_mcc_chub_notif *notif = (void *)pkt->data;
+	char mcc[3];
+
+	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
+		return -EOPNOTSUPP;
+
+	mcc[0] = notif->mcc >> 8;
+	mcc[1] = notif->mcc & 0xff;
+	mcc[2] = '\0';
+
+	IWL_DEBUG_LAR(mvm,
+		      "RX: received chub update mcc command (mcc 0x%x '%s')\n",
+		      notif->mcc, mcc);
+	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 72b8e19..1072f45 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -234,6 +234,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   iwl_mvm_rx_ant_coupling_notif, true),
 
 	RX_HANDLER(TIME_EVENT_NOTIFICATION, iwl_mvm_rx_time_event_notif, false),
+	RX_HANDLER(MCC_CHUB_UPDATE_CMD, iwl_mvm_rx_chub_update_mcc, false),
 
 	RX_HANDLER(EOSP_NOTIFICATION, iwl_mvm_rx_eosp_notif, false),
 
-- 
1.9.1

