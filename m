Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:40963 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaICT5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:21 -0400
Received: by mail-we0-f172.google.com with SMTP id q59so9213047wes.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:19 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/36] iwlwifi: mvm: use iwl_mvm_mac_get_queues_mask() more
Date: Wed,  3 Sep 2014 22:56:22 +0300
Message-Id: <1409774184-24665-34-git-send-email-egrumbach@gmail.com> (sfid-20140903_220114_370258_3CF5BEC0)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few places that can call the function
iwl_mvm_mac_get_queues_mask() instead of open-coding the
equivalent, so do that. This requires changing it to return
the multicast queue as part of the bitmap, which broke GO
mode because including it in the broadcast station queues
seems to confuse the firmware, so work around that.

Also, the API defines that the CAB queue shouldn't be
included in the TFD queue mask, adjust the comment
accordingly (not a bug).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |  3 --
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 62 ++++++++++++++---------------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 18 +++++----
 3 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 94342db..9c975f9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -75,9 +75,6 @@
 #include "fw-api-coex.h"
 #include "fw-api-scan.h"
 
-/* maximal number of Tx queues in any platform */
-#define IWL_MVM_MAX_QUEUES	20
-
 /* Tx queue numbers */
 enum {
 	IWL_MVM_OFFCHANNEL_QUEUE = 8,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 115bb36..9cbb192 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -83,7 +83,7 @@ struct iwl_mvm_mac_iface_iterator_data {
 	struct ieee80211_vif *vif;
 	unsigned long available_mac_ids[BITS_TO_LONGS(NUM_MAC_INDEX_DRIVER)];
 	unsigned long available_tsf_ids[BITS_TO_LONGS(NUM_TSF_IDS)];
-	unsigned long used_hw_queues[BITS_TO_LONGS(IWL_MVM_MAX_QUEUES)];
+	u32 used_hw_queues;
 	enum iwl_tsf_id preferred_tsf;
 	bool found_vif;
 };
@@ -194,12 +194,31 @@ static void iwl_mvm_mac_tsf_id_iter(void *_data, u8 *mac,
 		data->preferred_tsf = NUM_TSF_IDS;
 }
 
+/*
+ * Get the mask of the queues used by the vif
+ */
+u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
+				struct ieee80211_vif *vif)
+{
+	u32 qmask = 0, ac;
+
+	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
+		return BIT(IWL_MVM_OFFCHANNEL_QUEUE);
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		qmask |= BIT(vif->hw_queue[ac]);
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		qmask |= BIT(vif->cab_queue);
+
+	return qmask;
+}
+
 static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 				       struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_mac_iface_iterator_data *data = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	u32 ac;
 
 	/* Iterator may already find the interface being added -- skip it */
 	if (vif == data->vif) {
@@ -208,12 +227,7 @@ static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 	}
 
 	/* Mark the queues used by the vif */
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
-			__set_bit(vif->hw_queue[ac], data->used_hw_queues);
-
-	if (vif->cab_queue != IEEE80211_INVAL_HW_QUEUE)
-		__set_bit(vif->cab_queue, data->used_hw_queues);
+	data->used_hw_queues |= iwl_mvm_mac_get_queues_mask(data->mvm, vif);
 
 	/* Mark MAC IDs as used by clearing the available bit, and
 	 * (below) mark TSFs as used if their existing use is not
@@ -227,24 +241,6 @@ static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 	iwl_mvm_mac_tsf_id_iter(_data, mac, vif);
 }
 
-/*
- * Get the mask of the queus used by the vif
- */
-u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
-				struct ieee80211_vif *vif)
-{
-	u32 qmask = 0, ac;
-
-	if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
-		return BIT(IWL_MVM_OFFCHANNEL_QUEUE);
-
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
-			qmask |= BIT(vif->hw_queue[ac]);
-
-	return qmask;
-}
-
 void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif)
 {
@@ -279,15 +275,15 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 		.available_tsf_ids = { (1 << NUM_TSF_IDS) - 1 },
 		/* no preference yet */
 		.preferred_tsf = NUM_TSF_IDS,
-		.used_hw_queues = {
+		.used_hw_queues =
 			BIT(IWL_MVM_OFFCHANNEL_QUEUE) |
 			BIT(mvm->aux_queue) |
-			BIT(IWL_MVM_CMD_QUEUE)
-		},
+			BIT(IWL_MVM_CMD_QUEUE),
 		.found_vif = false,
 	};
 	u32 ac;
 	int ret, i;
+	unsigned long used_hw_queues;
 
 	/*
 	 * Allocate a MAC ID and a TSF for this MAC, along with the queues
@@ -370,9 +366,11 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 		return 0;
 	}
 
+	used_hw_queues = data.used_hw_queues;
+
 	/* Find available queues, and allocate them to the ACs */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		u8 queue = find_first_zero_bit(data.used_hw_queues,
+		u8 queue = find_first_zero_bit(&used_hw_queues,
 					       mvm->first_agg_queue);
 
 		if (queue >= mvm->first_agg_queue) {
@@ -381,13 +379,13 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 			goto exit_fail;
 		}
 
-		__set_bit(queue, data.used_hw_queues);
+		__set_bit(queue, &used_hw_queues);
 		vif->hw_queue[ac] = queue;
 	}
 
 	/* Allocate the CAB queue for softAP and GO interfaces */
 	if (vif->type == NL80211_IFTYPE_AP) {
-		u8 queue = find_first_zero_bit(data.used_hw_queues,
+		u8 queue = find_first_zero_bit(&used_hw_queues,
 					       mvm->first_agg_queue);
 
 		if (queue >= mvm->first_agg_queue) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ea79f1a..ac2b11a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -972,6 +972,15 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_ADHOC) {
 		u32 qmask = iwl_mvm_mac_get_queues_mask(mvm, vif);
+
+		/*
+		 * The firmware defines the TFD queue mask to only be relevant
+		 * for *unicast* queues, so the multicast (CAB) queue should
+		 * be excluded.
+		 */
+		if (vif->type == NL80211_IFTYPE_AP)
+			qmask &= ~BIT(vif->cab_queue);
+
 		ret = iwl_mvm_allocate_int_sta(mvm, &mvmvif->bcast_sta,
 					       qmask,
 					       ieee80211_vif_type_p2p(vif));
@@ -1063,14 +1072,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif)
 {
-	u32 tfd_msk = 0, ac;
-
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
-		if (vif->hw_queue[ac] != IEEE80211_INVAL_HW_QUEUE)
-			tfd_msk |= BIT(vif->hw_queue[ac]);
-
-	if (vif->cab_queue != IEEE80211_INVAL_HW_QUEUE)
-		tfd_msk |= BIT(vif->cab_queue);
+	u32 tfd_msk = iwl_mvm_mac_get_queues_mask(mvm, vif);
 
 	if (tfd_msk) {
 		mutex_lock(&mvm->mutex);
-- 
1.9.1

