Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56715 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3LaRQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:39 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so5667786eei.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:38 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/28] iwlwifi: mvm: dynamically update tsf_id
Date: Tue, 31 Dec 2013 19:15:54 +0200
Message-Id: <1388510157-23345-25-git-send-email-egrumbach@gmail.com> (sfid-20131231_183436_216851_FBC9E2C9)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Currently, the MAC context tsf_id assignment and the master/slave
relations are determined only when a new vif is added, as part
of the MAC context resource allocation. However, at this stage, the
beacon interval is not known, and thus could not be taken into account
in the master-slave algorithm.

To fix this, recalculate the MAC context tsf_id assignment,
just before the MAC context is activated, i.e., just before
a station VMAC is configured to associated and before an AP
VMAC is started.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |  104 +++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   15 ++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    2 +
 3 files changed, 91 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 510cf9f..3d41829 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -85,35 +85,15 @@ struct iwl_mvm_mac_iface_iterator_data {
 	bool found_vif;
 };
 
-static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
-				       struct ieee80211_vif *vif)
+static void iwl_mvm_mac_tsf_id_iter(void *_data, u8 *mac,
+				    struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_mac_iface_iterator_data *data = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	u32 ac;
 
-	/* Iterator may already find the interface being added -- skip it */
-	if (vif == data->vif) {
-		data->found_vif = true;
+	/* Skip the interface for which we are trying to assign a tsf_id  */
+	if (vif == data->vif)
 		return;
-	}
-
-	/* Mark the queues used by the vif */
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
-			__set_bit(vif->hw_queue[ac], data->used_hw_queues);
-
-	if (vif->cab_queue != IEEE80211_INVAL_HW_QUEUE)
-		__set_bit(vif->cab_queue, data->used_hw_queues);
-
-	/*
-	 * Mark MAC IDs as used by clearing the available bit, and
-	 * (below) mark TSFs as used if their existing use is not
-	 * compatible with the new interface type.
-	 * No locking or atomic bit operations are needed since the
-	 * data is on the stack of the caller function.
-	 */
-	__clear_bit(mvmvif->id, data->available_mac_ids);
 
 	/*
 	 * The TSF is a hardware/firmware resource, there are 4 and
@@ -135,21 +115,26 @@ static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 	case NL80211_IFTYPE_STATION:
 		/*
 		 * The new interface is client, so if the existing one
-		 * we're iterating is an AP, the TSF should be used to
+		 * we're iterating is an AP, and both interfaces have the
+		 * same beacon interval, the same TSF should be used to
 		 * avoid drift between the new client and existing AP,
 		 * the existing AP will get drift updates from the new
 		 * client context in this case
 		 */
 		if (vif->type == NL80211_IFTYPE_AP) {
 			if (data->preferred_tsf == NUM_TSF_IDS &&
-			    test_bit(mvmvif->tsf_id, data->available_tsf_ids))
+			    test_bit(mvmvif->tsf_id, data->available_tsf_ids) &&
+			    (vif->bss_conf.beacon_int ==
+			     data->vif->bss_conf.beacon_int)) {
 				data->preferred_tsf = mvmvif->tsf_id;
-			return;
+				return;
+			}
 		}
 		break;
 	case NL80211_IFTYPE_AP:
 		/*
-		 * The new interface is AP/GO, so should get drift
+		 * The new interface is AP/GO, so in case both interfaces
+		 * have the same beacon interval, it should get drift
 		 * updates from an existing client or use the same
 		 * TSF as an existing GO. There's no drift between
 		 * TSFs internally but if they used different TSFs
@@ -159,9 +144,12 @@ static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 		if (vif->type == NL80211_IFTYPE_STATION ||
 		    vif->type == NL80211_IFTYPE_AP) {
 			if (data->preferred_tsf == NUM_TSF_IDS &&
-			    test_bit(mvmvif->tsf_id, data->available_tsf_ids))
+			    test_bit(mvmvif->tsf_id, data->available_tsf_ids) &&
+			    (vif->bss_conf.beacon_int ==
+			     data->vif->bss_conf.beacon_int)) {
 				data->preferred_tsf = mvmvif->tsf_id;
-			return;
+				return;
+			}
 		}
 		break;
 	default:
@@ -187,6 +175,39 @@ static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 		data->preferred_tsf = NUM_TSF_IDS;
 }
 
+static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
+				       struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_mac_iface_iterator_data *data = _data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	u32 ac;
+
+	/* Iterator may already find the interface being added -- skip it */
+	if (vif == data->vif) {
+		data->found_vif = true;
+		return;
+	}
+
+	/* Mark the queues used by the vif */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
+			__set_bit(vif->hw_queue[ac], data->used_hw_queues);
+
+	if (vif->cab_queue != IEEE80211_INVAL_HW_QUEUE)
+		__set_bit(vif->cab_queue, data->used_hw_queues);
+
+	/* Mark MAC IDs as used by clearing the available bit, and
+	 * (below) mark TSFs as used if their existing use is not
+	 * compatible with the new interface type.
+	 * No locking or atomic bit operations are needed since the
+	 * data is on the stack of the caller function.
+	 */
+	__clear_bit(mvmvif->id, data->available_mac_ids);
+
+	/* find a suitable tsf_id */
+	iwl_mvm_mac_tsf_id_iter(_data, mac, vif);
+}
+
 /*
  * Get the mask of the queus used by the vif
  */
@@ -205,6 +226,29 @@ u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
 	return qmask;
 }
 
+void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_mac_iface_iterator_data data = {
+		.mvm = mvm,
+		.vif = vif,
+		.available_tsf_ids = { (1 << NUM_TSF_IDS) - 1 },
+		/* no preference yet */
+		.preferred_tsf = NUM_TSF_IDS,
+	};
+
+	ieee80211_iterate_active_interfaces_atomic(
+		mvm->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		iwl_mvm_mac_tsf_id_iter, &data);
+
+	if (data.preferred_tsf != NUM_TSF_IDS)
+		mvmvif->tsf_id = data.preferred_tsf;
+	else if (!test_bit(mvmvif->tsf_id, data.available_tsf_ids))
+		mvmvif->tsf_id = find_first_bit(data.available_tsf_ids,
+						NUM_TSF_IDS);
+}
+
 static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 					       struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index abe7514..4c94482 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -866,6 +866,14 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
+	/*
+	 * Re-calculate the tsf id, as the master-slave relations depend on the
+	 * beacon interval, which was not known when the station interface was
+	 * added.
+	 */
+	if (changes & BSS_CHANGED_ASSOC && bss_conf->assoc)
+		iwl_mvm_mac_ctxt_recalc_tsf_id(mvm, vif);
+
 	ret = iwl_mvm_mac_ctxt_changed(mvm, vif);
 	if (ret)
 		IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
@@ -979,6 +987,13 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * Re-calculate the tsf id, as the master-slave relations depend on the
+	 * beacon interval, which was not known when the AP interface was added.
+	 */
+	if (vif->type == NL80211_IFTYPE_AP)
+		iwl_mvm_mac_ctxt_recalc_tsf_id(mvm, vif);
+
 	/* Add the mac context */
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index ca8a904..f6b096b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -712,6 +712,8 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb,
 				    struct iwl_device_cmd *cmd);
+void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
+				    struct ieee80211_vif *vif);
 
 /* Bindings */
 int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-- 
1.7.9.5

