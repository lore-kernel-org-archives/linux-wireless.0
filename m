Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50740 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751797AbdDKMkY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:40:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:29 +0300
Message-Id: <20170411123742.12214-13-luca@coelho.fi> (sfid-20170411_145544_547426_C5E7F38B)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 12/25] iwlwifi: mvm: add multicast station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently multicast queue is associated with the broadcast
station.

This raises quite a few issues:

The multicast queue has a special treatment:
- It is sent in the MAC context command
- It is excluded from tfd_queue_mask

In DQA mode we end up enabling two queues - the probe response
queue and the multicast queue - with the same station (broadcast)
and TID while in DQA mode it should be unique RA-TID.
Firmware will enforce it for a000 devices, so this allocation
will fail.

In addition, in a000 devices the FW will set the FIFO and not
the driver. So there is a need for FW to know when we enable
the queue that it is multicast queue so it will be bound to
the multicast FIFO. There is no such way in current design.

In order to simplify driver and firmware handling of this queue
create a multicast station.
This solves the unique RA-TID issue in the short term and serves
as preparation for the long term.

In the long term we will also add a flag marking this station for
the FW as the multicast station.
Once we will do that the FW will know this is the multicast queue
immediately when it is added and bind it to the correct FIFO.
It will also enable removing the special treatment of the
queue in the MAC context command.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  26 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 112 +++++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |   3 +
 5 files changed, 106 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 99132ea16ede..e7c8567cafff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -472,6 +472,7 @@ static int iwl_mvm_mac_ctxt_allocate_resources(struct iwl_mvm *mvm,
 	}
 
 	mvmvif->bcast_sta.sta_id = IWL_MVM_STATION_COUNT;
+	mvmvif->mcast_sta.sta_id = IWL_MVM_STATION_COUNT;
 	mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
 
 	for (i = 0; i < NUM_IWL_MVM_SMPS_REQ; i++)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 265d9eb8f0b0..72a056a80516 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -6,8 +6,8 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,7 +33,8 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1351,6 +1352,17 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 			goto out_release;
 		}
 
+		if (iwl_mvm_is_dqa_supported(mvm)) {
+			/*
+			 * Only queue for this station is the mcast queue,
+			 * which shouldn't be in TFD mask anyway
+			 */
+			ret = iwl_mvm_allocate_int_sta(mvm, &mvmvif->mcast_sta,
+						       0, vif->type);
+			if (ret)
+				goto out_release;
+		}
+
 		iwl_mvm_vif_dbgfs_register(mvm, vif);
 		goto out_unlock;
 	}
@@ -1516,6 +1528,7 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 			mvm->noa_duration = 0;
 		}
 #endif
+		iwl_mvm_dealloc_int_sta(mvm, &mvmvif->mcast_sta);
 		iwl_mvm_dealloc_bcast_sta(mvm, vif);
 		goto out_release;
 	}
@@ -2104,6 +2117,10 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unbind;
 
+	ret = iwl_mvm_add_mcast_sta(mvm, vif);
+	if (ret)
+		goto out_rm_bcast;
+
 	/* must be set before quota calculations */
 	mvmvif->ap_ibss_active = true;
 
@@ -2131,6 +2148,8 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 out_quota_failed:
 	iwl_mvm_power_update_mac(mvm);
 	mvmvif->ap_ibss_active = false;
+	iwl_mvm_rm_mcast_sta(mvm, vif);
+out_rm_bcast:
 	iwl_mvm_send_rm_bcast_sta(mvm, vif);
 out_unbind:
 	iwl_mvm_binding_remove_vif(mvm, vif);
@@ -2177,6 +2196,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false, NULL);
 
 	iwl_mvm_update_quotas(mvm, false, NULL);
+	iwl_mvm_rm_mcast_sta(mvm, vif);
 	iwl_mvm_send_rm_bcast_sta(mvm, vif);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 88bc459b1f9a..70b994638273 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -407,6 +407,7 @@ struct iwl_mvm_vif {
 	struct iwl_mvm_time_event_data hs_time_event_data;
 
 	struct iwl_mvm_int_sta bcast_sta;
+	struct iwl_mvm_int_sta mcast_sta;
 
 	/*
 	 * Assigned while mac80211 has the interface in a channel context,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index b51a2853cc80..41fd3ba574c0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2012 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1652,8 +1652,7 @@ int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
 	return 0;
 }
 
-static void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm,
-				    struct iwl_mvm_int_sta *sta)
+void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta)
 {
 	RCU_INIT_POINTER(mvm->fw_id_to_mac_id[sta->sta_id], NULL);
 	memset(sta, 0, sizeof(struct iwl_mvm_int_sta));
@@ -1826,33 +1825,8 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	ret = iwl_mvm_add_int_sta_common(mvm, bsta, baddr,
 					 mvmvif->id, mvmvif->color);
-	if (ret)
-		return ret;
-
-	/*
-	 * In AP vif type, we also need to enable the cab_queue. However, we
-	 * have to enable it after the ADD_STA command is sent, otherwise the
-	 * FW will throw an assert once we send the ADD_STA command (it'll
-	 * detect a mismatch in the tfd_queue_msk, as we can't add the
-	 * enabled-cab_queue to the mask)
-	 */
-	if (iwl_mvm_is_dqa_supported(mvm) &&
-	    vif->type == NL80211_IFTYPE_AP) {
-		struct iwl_trans_txq_scd_cfg cfg = {
-			.fifo = IWL_MVM_TX_FIFO_MCAST,
-			.sta_id = mvmvif->bcast_sta.sta_id,
-			.tid = IWL_MAX_TID_COUNT,
-			.aggregate = false,
-			.frame_limit = IWL_FRAME_LIMIT,
-		};
-		unsigned int wdg_timeout =
-			iwl_mvm_get_wd_timeout(mvm, vif, false, false);
-
-		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue,
-				   0, &cfg, wdg_timeout);
-	}
 
-	return 0;
+	return ret;
 }
 
 static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
@@ -1862,10 +1836,6 @@ static void iwl_mvm_free_bcast_sta_queues(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (vif->type == NL80211_IFTYPE_AP)
-		iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
-				    IWL_MAX_TID_COUNT, 0);
-
 	if (mvmvif->bcast_sta.tfd_queue_msk &
 	    BIT(IWL_MVM_DQA_AP_PROBE_RESP_QUEUE)) {
 		iwl_mvm_disable_txq(mvm,
@@ -1979,6 +1949,80 @@ int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	return ret;
 }
 
+/*
+ * Allocate a new station entry for the multicast station to the given vif,
+ * and send it to the FW.
+ * Note that each AP/GO mac should have its own multicast station.
+ *
+ * @mvm: the mvm component
+ * @vif: the interface to which the multicast station is added
+ */
+int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_int_sta *msta = &mvmvif->mcast_sta;
+	static const u8 _maddr[] = {0x03, 0x00, 0x00, 0x00, 0x00, 0x00};
+	const u8 *maddr = _maddr;
+	struct iwl_trans_txq_scd_cfg cfg = {
+		.fifo = IWL_MVM_TX_FIFO_MCAST,
+		.sta_id = msta->sta_id,
+		.tid = IWL_MAX_TID_COUNT,
+		.aggregate = false,
+		.frame_limit = IWL_FRAME_LIMIT,
+	};
+	unsigned int timeout = iwl_mvm_get_wd_timeout(mvm, vif, false, false);
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (!iwl_mvm_is_dqa_supported(mvm))
+		return 0;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_AP))
+		return -ENOTSUPP;
+
+	ret = iwl_mvm_add_int_sta_common(mvm, msta, maddr,
+					 mvmvif->id, mvmvif->color);
+	if (ret) {
+		iwl_mvm_dealloc_int_sta(mvm, msta);
+		return ret;
+	}
+
+	/*
+	 * Enable cab queue after the ADD_STA command is sent.
+	 * This is needed for a000 firmware which won't accept SCD_QUEUE_CFG
+	 * command with unknown station id.
+	 */
+	iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0, &cfg,
+			   timeout);
+
+	return 0;
+}
+
+/*
+ * Send the FW a request to remove the station from it's internal data
+ * structures, and in addition remove it from the local data structure.
+ */
+int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (!iwl_mvm_is_dqa_supported(mvm))
+		return 0;
+
+	iwl_mvm_disable_txq(mvm, vif->cab_queue, vif->cab_queue,
+			    IWL_MAX_TID_COUNT, 0);
+
+	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->mcast_sta.sta_id);
+	if (ret)
+		IWL_WARN(mvm, "Failed sending remove station\n");
+
+	return ret;
+}
+
 #define IWL_MAX_RX_BA_SESSIONS 16
 
 static void iwl_mvm_sync_rxq_del_ba(struct iwl_mvm *mvm, u8 baid)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 1927ce607798..a143a8757e27 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -532,10 +532,13 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
 			     struct iwl_mvm_int_sta *sta,
 				    u32 qmask, enum nl80211_iftype iftype);
 void iwl_mvm_dealloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta);
 int iwl_mvm_add_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 void iwl_mvm_dealloc_snif_sta(struct iwl_mvm *mvm);
-- 
2.11.0
