Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D89CC282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F9DF218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbfAYUWN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:22:13 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50944 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbfAYUWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:22:13 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qu-00010a-7y; Fri, 25 Jan 2019 22:13:24 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:13:05 +0200
Message-Id: <20190125201305.5616-18-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/17] iwlwifi: mvm: add an option to dereference vif by id
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Currently whenever we get firmware notification with mac id,
we iterate over all the interfaces to find the ID. This is a
bit cumbersome. Instead, adding an array of RCU pointers, like
we have for station IDs. This is not expensive space wise
since we have only up to 4 active MACs, and not complicated
code wise, since we have a clear point to init and de-init it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 99 +++++++++----------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 14 +++
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 22 ++---
 4 files changed, 72 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index b1d6dea7672e..c868ebfa10ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1382,35 +1382,47 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	}
 }
 
-static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
-					 struct ieee80211_vif *vif)
+void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
+				     struct iwl_rx_cmd_buffer *rxb)
 {
-	struct iwl_missed_beacons_notif *missed_beacons = _data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_missed_beacons_notif *mb = (void *)pkt->data;
 	struct iwl_fw_dbg_trigger_missed_bcon *bcon_trig;
 	struct iwl_fw_dbg_trigger_tlv *trigger;
 	u32 stop_trig_missed_bcon, stop_trig_missed_bcon_since_rx;
 	u32 rx_missed_bcon, rx_missed_bcon_since_rx;
+	struct ieee80211_vif *vif;
+	u32 id = le32_to_cpu(mb->mac_id);
 
-	if (mvmvif->id != (u16)le32_to_cpu(missed_beacons->mac_id))
-		return;
+	IWL_DEBUG_INFO(mvm,
+		       "missed bcn mac_id=%u, consecutive=%u (%u, %u, %u)\n",
+		       le32_to_cpu(mb->mac_id),
+		       le32_to_cpu(mb->consec_missed_beacons),
+		       le32_to_cpu(mb->consec_missed_beacons_since_last_rx),
+		       le32_to_cpu(mb->num_recvd_beacons),
+		       le32_to_cpu(mb->num_expected_beacons));
+
+	rcu_read_lock();
+
+	vif = iwl_mvm_rcu_dereference_vif_id(mvm, id, true);
+	if (!vif)
+		goto out;
 
-	rx_missed_bcon = le32_to_cpu(missed_beacons->consec_missed_beacons);
+	rx_missed_bcon = le32_to_cpu(mb->consec_missed_beacons);
 	rx_missed_bcon_since_rx =
-		le32_to_cpu(missed_beacons->consec_missed_beacons_since_last_rx);
+		le32_to_cpu(mb->consec_missed_beacons_since_last_rx);
 	/*
 	 * TODO: the threshold should be adjusted based on latency conditions,
 	 * and/or in case of a CS flow on one of the other AP vifs.
 	 */
-	if (le32_to_cpu(missed_beacons->consec_missed_beacons_since_last_rx) >
+	if (le32_to_cpu(mb->consec_missed_beacons_since_last_rx) >
 	     IWL_MVM_MISSED_BEACONS_THRESHOLD)
 		ieee80211_beacon_loss(vif);
 
 	trigger = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
 					FW_DBG_TRIGGER_MISSED_BEACONS);
 	if (!trigger)
-		return;
+		goto out;
 
 	bcon_trig = (void *)trigger->data;
 	stop_trig_missed_bcon = le32_to_cpu(bcon_trig->stop_consec_missed_bcon);
@@ -1422,28 +1434,11 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 	if (rx_missed_bcon_since_rx >= stop_trig_missed_bcon_since_rx ||
 	    rx_missed_bcon >= stop_trig_missed_bcon)
 		iwl_fw_dbg_collect_trig(&mvm->fwrt, trigger, NULL);
-}
-
-void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
-				     struct iwl_rx_cmd_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_missed_beacons_notif *mb = (void *)pkt->data;
-
-	IWL_DEBUG_INFO(mvm,
-		       "missed bcn mac_id=%u, consecutive=%u (%u, %u, %u)\n",
-		       le32_to_cpu(mb->mac_id),
-		       le32_to_cpu(mb->consec_missed_beacons),
-		       le32_to_cpu(mb->consec_missed_beacons_since_last_rx),
-		       le32_to_cpu(mb->num_recvd_beacons),
-		       le32_to_cpu(mb->num_expected_beacons));
-
-	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
-						   IEEE80211_IFACE_ITER_NORMAL,
-						   iwl_mvm_beacon_loss_iterator,
-						   mb);
 
 	iwl_fw_dbg_apply_point(&mvm->fwrt, IWL_FW_INI_APPLY_MISSED_BEACONS);
+
+out:
+	rcu_read_unlock();
 }
 
 void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
@@ -1485,16 +1480,29 @@ void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 	ieee80211_rx_napi(mvm->hw, NULL, skb, NULL);
 }
 
-static void iwl_mvm_probe_resp_data_iter(void *_data, u8 *mac,
-					 struct ieee80211_vif *vif)
+void iwl_mvm_probe_resp_data_notif(struct iwl_mvm *mvm,
+				   struct iwl_rx_cmd_buffer *rxb)
 {
-	struct iwl_probe_resp_data_notif *notif = _data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_probe_resp_data_notif *notif = (void *)pkt->data;
 	struct iwl_probe_resp_data *old_data, *new_data;
+	int len = iwl_rx_packet_payload_len(pkt);
+	u32 id = le32_to_cpu(notif->mac_id);
+	struct ieee80211_vif *vif;
+	struct iwl_mvm_vif *mvmvif;
+
+	if (WARN_ON_ONCE(len < sizeof(*notif)))
+		return;
+
+	IWL_DEBUG_INFO(mvm, "Probe response data notif: noa %d, csa %d\n",
+		       notif->noa_active, notif->csa_counter);
 
-	if (mvmvif->id != (u16)le32_to_cpu(notif->mac_id))
+	vif = iwl_mvm_rcu_dereference_vif_id(mvm, id, false);
+	if (!vif)
 		return;
 
+	mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
 	new_data = kzalloc(sizeof(*new_data), GFP_KERNEL);
 	if (!new_data)
 		return;
@@ -1525,25 +1533,6 @@ static void iwl_mvm_probe_resp_data_iter(void *_data, u8 *mac,
 		ieee80211_csa_set_counter(vif, notif->csa_counter);
 }
 
-void iwl_mvm_probe_resp_data_notif(struct iwl_mvm *mvm,
-				   struct iwl_rx_cmd_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_probe_resp_data_notif *notif = (void *)pkt->data;
-	int len = iwl_rx_packet_payload_len(pkt);
-
-	if (WARN_ON_ONCE(len < sizeof(*notif)))
-		return;
-
-	IWL_DEBUG_INFO(mvm, "Probe response data notif: noa %d, csa %d\n",
-		       notif->noa_active, notif->csa_counter);
-
-	ieee80211_iterate_active_interfaces(mvm->hw,
-					    IEEE80211_IFACE_ITER_ACTIVE,
-					    iwl_mvm_probe_resp_data_iter,
-					    notif);
-}
-
 void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 				      struct iwl_rx_cmd_buffer *rxb)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b4a55349336f..e3da6992f244 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1471,6 +1471,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unlock;
 
+	rcu_assign_pointer(mvm->vif_id_to_mac[mvmvif->id], vif);
+
 	/* Counting number of interfaces is needed for legacy PM */
 	if (vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count++;
@@ -1662,6 +1664,8 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 	iwl_mvm_power_update_mac(mvm);
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
+	RCU_INIT_POINTER(mvm->vif_id_to_mac[mvmvif->id], NULL);
+
 	if (vif->type == NL80211_IFTYPE_MONITOR)
 		mvm->monitor_on = false;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index c314f77f657f..d326843636cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -989,6 +989,7 @@ struct iwl_mvm {
 	u8 refs[IWL_MVM_REF_COUNT];
 
 	u8 vif_count;
+	struct ieee80211_vif __rcu *vif_id_to_mac[NUM_MAC_INDEX_DRIVER];
 
 	/* -1 for always, 0 for never, >0 for that many times */
 	s8 fw_restart;
@@ -1241,6 +1242,19 @@ iwl_mvm_sta_from_staid_protected(struct iwl_mvm *mvm, u8 sta_id)
 	return iwl_mvm_sta_from_mac80211(sta);
 }
 
+static inline struct ieee80211_vif *
+iwl_mvm_rcu_dereference_vif_id(struct iwl_mvm *mvm, u8 vif_id, bool rcu)
+{
+	if (WARN_ON(vif_id >= ARRAY_SIZE(mvm->vif_id_to_mac)))
+		return NULL;
+
+	if (rcu)
+		return rcu_dereference(mvm->vif_id_to_mac[vif_id]);
+
+	return rcu_dereference_protected(mvm->vif_id_to_mac[vif_id],
+					 lockdep_is_held(&mvm->mutex));
+}
+
 static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
 {
 	return !iwlwifi_mod_params.d0i3_disable &&
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 5dbbd35ee630..211c4638d690 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1136,19 +1136,14 @@ static void iwl_mvm_tcm_uapsd_nonagg_detected_wk(struct work_struct *wk)
 				"AP isn't using AMPDU with uAPSD enabled");
 }
 
-static void iwl_mvm_uapsd_agg_disconnect_iter(void *data, u8 *mac,
-					      struct ieee80211_vif *vif)
+static void iwl_mvm_uapsd_agg_disconnect(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = mvmvif->mvm;
-	int *mac_id = data;
 
 	if (vif->type != NL80211_IFTYPE_STATION)
 		return;
 
-	if (mvmvif->id != *mac_id)
-		return;
-
 	if (!vif->bss_conf.assoc)
 		return;
 
@@ -1158,10 +1153,10 @@ static void iwl_mvm_uapsd_agg_disconnect_iter(void *data, u8 *mac,
 	    !mvmvif->queue_params[IEEE80211_AC_BK].uapsd)
 		return;
 
-	if (mvm->tcm.data[*mac_id].uapsd_nonagg_detect.detected)
+	if (mvm->tcm.data[mvmvif->id].uapsd_nonagg_detect.detected)
 		return;
 
-	mvm->tcm.data[*mac_id].uapsd_nonagg_detect.detected = true;
+	mvm->tcm.data[mvmvif->id].uapsd_nonagg_detect.detected = true;
 	IWL_INFO(mvm,
 		 "detected AP should do aggregation but isn't, likely due to U-APSD\n");
 	schedule_delayed_work(&mvmvif->uapsd_nonagg_detected_wk, 15 * HZ);
@@ -1174,6 +1169,7 @@ static void iwl_mvm_check_uapsd_agg_expected_tpt(struct iwl_mvm *mvm,
 	u64 bytes = mvm->tcm.data[mac].uapsd_nonagg_detect.rx_bytes;
 	u64 tpt;
 	unsigned long rate;
+	struct ieee80211_vif *vif;
 
 	rate = ewma_rate_read(&mvm->tcm.data[mac].uapsd_nonagg_detect.rate);
 
@@ -1202,9 +1198,11 @@ static void iwl_mvm_check_uapsd_agg_expected_tpt(struct iwl_mvm *mvm,
 			return;
 	}
 
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_uapsd_agg_disconnect_iter, &mac);
+	rcu_read_lock();
+	vif = rcu_dereference(mvm->vif_id_to_mac[mac]);
+	if (vif)
+		iwl_mvm_uapsd_agg_disconnect(mvm, vif);
+	rcu_read_unlock();
 }
 
 static void iwl_mvm_tcm_iterator(void *_data, u8 *mac,
-- 
2.20.1

