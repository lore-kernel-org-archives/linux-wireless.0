Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37624 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaKXOgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:10 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so12474803wgh.31
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:09 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 44/75] iwlwifi: mvm: allow private per-STA TFD queues
Date: Mon, 24 Nov 2014 16:34:20 +0200
Message-Id: <1416839691-28533-44-git-send-email-egrumbach@gmail.com> (sfid-20141124_153858_366204_672DB74D)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

TDLS stations will have private queues, so consider them as well when
allocating a new one. Consolidate the HW-queue iterating code into
a single exported function, to be used by the TDLS code in the future.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 65 ++++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 +
 2 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index b8ab4a1..a1dc9b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -83,11 +83,15 @@ struct iwl_mvm_mac_iface_iterator_data {
 	struct ieee80211_vif *vif;
 	unsigned long available_mac_ids[BITS_TO_LONGS(NUM_MAC_INDEX_DRIVER)];
 	unsigned long available_tsf_ids[BITS_TO_LONGS(NUM_TSF_IDS)];
-	u32 used_hw_queues;
 	enum iwl_tsf_id preferred_tsf;
 	bool found_vif;
 };
 
+struct iwl_mvm_hw_queues_iface_iterator_data {
+	struct ieee80211_vif *exclude_vif;
+	unsigned long used_hw_queues;
+};
+
 static void iwl_mvm_mac_tsf_id_iter(void *_data, u8 *mac,
 				    struct ieee80211_vif *vif)
 {
@@ -213,6 +217,54 @@ u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif)
 	return qmask;
 }
 
+static void iwl_mvm_iface_hw_queues_iter(void *_data, u8 *mac,
+					 struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_hw_queues_iface_iterator_data *data = _data;
+
+	/* exclude the given vif */
+	if (vif == data->exclude_vif)
+		return;
+
+	data->used_hw_queues |= iwl_mvm_mac_get_queues_mask(vif);
+}
+
+static void iwl_mvm_mac_sta_hw_queues_iter(void *_data,
+					   struct ieee80211_sta *sta)
+{
+	struct iwl_mvm_hw_queues_iface_iterator_data *data = _data;
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	/* Mark the queues used by the sta */
+	data->used_hw_queues |= mvmsta->tfd_queue_msk;
+}
+
+unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *exclude_vif)
+{
+	struct iwl_mvm_hw_queues_iface_iterator_data data = {
+		.exclude_vif = exclude_vif,
+		.used_hw_queues =
+			BIT(IWL_MVM_OFFCHANNEL_QUEUE) |
+			BIT(mvm->aux_queue) |
+			BIT(IWL_MVM_CMD_QUEUE),
+	};
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* mark all VIF used hw queues */
+	ieee80211_iterate_active_interfaces_atomic(
+		mvm->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+		iwl_mvm_iface_hw_queues_iter, &data);
+
+	/* don't assign the same hw queues as TDLS stations */
+	ieee80211_iterate_stations_atomic(mvm->hw,
+					  iwl_mvm_mac_sta_hw_queues_iter,
+					  &data);
+
+	return data.used_hw_queues;
+}
+
 static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 				       struct ieee80211_vif *vif)
 {
@@ -225,9 +277,6 @@ static void iwl_mvm_mac_iface_iterator(void *_data, u8 *mac,
 		return;
 	}
 
-	/* Mark the queues used by the vif */
-	data->used_hw_queues |= iwl_mvm_mac_get_queues_mask(vif);
-
 	/* Mark MAC IDs as used by clearing the available bit, and
 	 * (below) mark TSFs as used if their existing use is not
 	 * compatible with the new interface type.
@@ -274,10 +323,6 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 		.available_tsf_ids = { (1 << NUM_TSF_IDS) - 1 },
 		/* no preference yet */
 		.preferred_tsf = NUM_TSF_IDS,
-		.used_hw_queues =
-			BIT(IWL_MVM_OFFCHANNEL_QUEUE) |
-			BIT(mvm->aux_queue) |
-			BIT(IWL_MVM_CMD_QUEUE),
 		.found_vif = false,
 	};
 	u32 ac;
@@ -316,6 +361,8 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 		mvm->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
 		iwl_mvm_mac_iface_iterator, &data);
 
+	used_hw_queues = iwl_mvm_get_used_hw_queues(mvm, vif);
+
 	/*
 	 * In the case we're getting here during resume, it's similar to
 	 * firmware restart, and with RESUME_ALL the iterator will find
@@ -365,8 +412,6 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 		return 0;
 	}
 
-	used_hw_queues = data.used_hw_queues;
-
 	/* Find available queues, and allocate them to the ACs */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		u8 queue = find_first_zero_bit(&used_hw_queues,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index be0285d..363be83 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -937,6 +937,8 @@ int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 				    struct iwl_device_cmd *cmd);
 void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
+unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *exclude_vif);
 
 /* Bindings */
 int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-- 
1.9.1

