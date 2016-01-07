Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbcAGMsG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:06 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/21] iwlwifi: mvm: check PN for CCMP/GCMP in the driver
Date: Thu,  7 Jan 2016 14:47:36 +0200
Message-Id: <1452170861-10060-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134829_616626_48FD39A4)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As we're working on multi-queue RX, we want to parallelise checking
the PN in order to avoid having to serialise the RX processing.

It may seem that doing parallel PN checking is insecure, but it turns
out to be OK because queue assignment is done based on the data in the
frame (IP/TCP) and thus cannot be manipulated by an attacker, since
the data is encrypted and must first have been decrypted successfully.

There are some corner cases, in particular when the peer starts using
fragmentation which redirects the packet to the default queue. However
this redirection is remembered (for the STA, per TID) and thus cannot
be exploited by an attacker either.

Leave checking on the default queue (queue 0) to mac80211, since we
get fragmented packets there and those are subject to stricter checks
during reassembly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       | 114 ++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  46 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 106 +++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      |  12 +++
 4 files changed, 245 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 6ac4072..2cd9052 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -137,6 +137,28 @@ static void iwl_mvm_convert_p1k(u16 *p1k, __le16 *out)
 		out[i] = cpu_to_le16(p1k[i]);
 }
 
+static const u8 *iwl_mvm_find_max_pn(struct ieee80211_key_conf *key,
+				     struct iwl_mvm_key_pn *ptk_pn,
+				     struct ieee80211_key_seq *seq,
+				     int tid, int queues)
+{
+	const u8 *ret = seq->ccmp.pn;
+	int i;
+
+	/* get the PN from mac80211, used on the default queue */
+	ieee80211_get_key_rx_seq(key, tid, seq);
+
+	/* and use the internal data for the other queues */
+	for (i = 1; i < queues; i++) {
+		const u8 *tmp = ptk_pn->q[i].pn[tid];
+
+		if (memcmp(ret, tmp, IEEE80211_CCMP_PN_LEN) <= 0)
+			ret = tmp;
+	}
+
+	return ret;
+}
+
 struct wowlan_key_data {
 	struct iwl_wowlan_rsc_tsc_params_cmd *rsc_tsc;
 	struct iwl_wowlan_tkip_params_cmd *tkip;
@@ -294,18 +316,42 @@ static void iwl_mvm_wowlan_program_keys(struct ieee80211_hw *hw,
 
 		/*
 		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 for checking the IV in the frames.
+		 * mac80211/our RX code use TID 0 for checking the PN.
 		 */
-		for (i = 0; i < IWL_NUM_RSC; i++) {
-			u8 *pn = seq.ccmp.pn;
+		if (sta && iwl_mvm_has_new_rx_api(mvm)) {
+			struct iwl_mvm_sta *mvmsta;
+			struct iwl_mvm_key_pn *ptk_pn;
+			const u8 *pn;
+
+			mvmsta = iwl_mvm_sta_from_mac80211(sta);
+			ptk_pn = rcu_dereference_protected(
+						mvmsta->ptk_pn[key->keyidx],
+						lockdep_is_held(&mvm->mutex));
+			if (WARN_ON(!ptk_pn))
+				break;
 
-			ieee80211_get_key_rx_seq(key, i, &seq);
-			aes_sc[i].pn = cpu_to_le64((u64)pn[5] |
-						   ((u64)pn[4] << 8) |
-						   ((u64)pn[3] << 16) |
-						   ((u64)pn[2] << 24) |
-						   ((u64)pn[1] << 32) |
-						   ((u64)pn[0] << 40));
+			for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
+				pn = iwl_mvm_find_max_pn(key, ptk_pn, &seq, i,
+						mvm->trans->num_rx_queues);
+				aes_sc[i].pn = cpu_to_le64((u64)pn[5] |
+							   ((u64)pn[4] << 8) |
+							   ((u64)pn[3] << 16) |
+							   ((u64)pn[2] << 24) |
+							   ((u64)pn[1] << 32) |
+							   ((u64)pn[0] << 40));
+			}
+		} else {
+			for (i = 0; i < IWL_NUM_RSC; i++) {
+				u8 *pn = seq.ccmp.pn;
+
+				ieee80211_get_key_rx_seq(key, i, &seq);
+				aes_sc[i].pn = cpu_to_le64((u64)pn[5] |
+							   ((u64)pn[4] << 8) |
+							   ((u64)pn[3] << 16) |
+							   ((u64)pn[2] << 24) |
+							   ((u64)pn[1] << 32) |
+							   ((u64)pn[0] << 40));
+			}
 		}
 		data->use_rsc_tsc = true;
 		break;
@@ -1426,18 +1472,42 @@ static void iwl_mvm_tkip_sc_to_seq(struct tkip_sc *sc,
 	seq->tkip.iv16 = le16_to_cpu(sc->iv16);
 }
 
-static void iwl_mvm_set_aes_rx_seq(struct aes_sc *scs,
+static void iwl_mvm_set_aes_rx_seq(struct iwl_mvm *mvm, struct aes_sc *scs,
+				   struct ieee80211_sta *sta,
 				   struct ieee80211_key_conf *key)
 {
 	int tid;
 
 	BUILD_BUG_ON(IWL_NUM_RSC != IEEE80211_NUM_TIDS);
 
-	for (tid = 0; tid < IWL_NUM_RSC; tid++) {
-		struct ieee80211_key_seq seq = {};
+	if (sta && iwl_mvm_has_new_rx_api(mvm)) {
+		struct iwl_mvm_sta *mvmsta;
+		struct iwl_mvm_key_pn *ptk_pn;
 
-		iwl_mvm_aes_sc_to_seq(&scs[tid], &seq);
-		ieee80211_set_key_rx_seq(key, tid, &seq);
+		mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+		ptk_pn = rcu_dereference_protected(mvmsta->ptk_pn[key->keyidx],
+						   lockdep_is_held(&mvm->mutex));
+		if (WARN_ON(!ptk_pn))
+			return;
+
+		for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
+			struct ieee80211_key_seq seq = {};
+			int i;
+
+			iwl_mvm_aes_sc_to_seq(&scs[tid], &seq);
+			ieee80211_set_key_rx_seq(key, tid, &seq);
+			for (i = 1; i < mvm->trans->num_rx_queues; i++)
+				memcpy(ptk_pn->q[i].pn[tid],
+				       seq.ccmp.pn, IEEE80211_CCMP_PN_LEN);
+		}
+	} else {
+		for (tid = 0; tid < IWL_NUM_RSC; tid++) {
+			struct ieee80211_key_seq seq = {};
+
+			iwl_mvm_aes_sc_to_seq(&scs[tid], &seq);
+			ieee80211_set_key_rx_seq(key, tid, &seq);
+		}
 	}
 }
 
@@ -1456,14 +1526,15 @@ static void iwl_mvm_set_tkip_rx_seq(struct tkip_sc *scs,
 	}
 }
 
-static void iwl_mvm_set_key_rx_seq(struct ieee80211_key_conf *key,
+static void iwl_mvm_set_key_rx_seq(struct iwl_mvm *mvm,
+				   struct ieee80211_key_conf *key,
 				   struct iwl_wowlan_status *status)
 {
 	union iwl_all_tsc_rsc *rsc = &status->gtk.rsc.all_tsc_rsc;
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
-		iwl_mvm_set_aes_rx_seq(rsc->aes.multicast_rsc, key);
+		iwl_mvm_set_aes_rx_seq(mvm, rsc->aes.multicast_rsc, NULL, key);
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		iwl_mvm_set_tkip_rx_seq(rsc->tkip.multicast_rsc, key);
@@ -1474,6 +1545,7 @@ static void iwl_mvm_set_key_rx_seq(struct ieee80211_key_conf *key,
 }
 
 struct iwl_mvm_d3_gtk_iter_data {
+	struct iwl_mvm *mvm;
 	struct iwl_wowlan_status *status;
 	void *last_gtk;
 	u32 cipher;
@@ -1522,7 +1594,8 @@ static void iwl_mvm_d3_update_keys(struct ieee80211_hw *hw,
 
 		switch (key->cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
-			iwl_mvm_set_aes_rx_seq(sc->aes.unicast_rsc, key);
+			iwl_mvm_set_aes_rx_seq(data->mvm, sc->aes.unicast_rsc,
+					       sta, key);
 			atomic64_set(&key->tx_pn, le64_to_cpu(sc->aes.tsc.pn));
 			break;
 		case WLAN_CIPHER_SUITE_TKIP:
@@ -1545,7 +1618,7 @@ static void iwl_mvm_d3_update_keys(struct ieee80211_hw *hw,
 	if (data->status->num_of_gtk_rekeys)
 		ieee80211_remove_key(key);
 	else if (data->last_gtk == key)
-		iwl_mvm_set_key_rx_seq(key, data->status);
+		iwl_mvm_set_key_rx_seq(data->mvm, key, data->status);
 }
 
 static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
@@ -1554,6 +1627,7 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_d3_gtk_iter_data gtkdata = {
+		.mvm = mvm,
 		.status = status,
 	};
 	u32 disconnection_reasons =
@@ -1615,7 +1689,7 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 		key = ieee80211_gtk_rekey_add(vif, &conf.conf);
 		if (IS_ERR(key))
 			return false;
-		iwl_mvm_set_key_rx_seq(key, status);
+		iwl_mvm_set_key_rx_seq(mvm, key, status);
 	}
 
 	if (status->num_of_gtk_rekeys) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 40b5c53..d70a171 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2568,6 +2568,9 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			       struct ieee80211_key_conf *key)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_sta *mvmsta;
+	struct iwl_mvm_key_pn *ptk_pn;
+	int keyidx = key->keyidx;
 	int ret;
 	u8 key_offset;
 
@@ -2635,6 +2638,36 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			break;
 		}
 
+		if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) &&
+		    sta && iwl_mvm_has_new_rx_api(mvm) &&
+		    key->flags & IEEE80211_KEY_FLAG_PAIRWISE &&
+		    (key->cipher == WLAN_CIPHER_SUITE_CCMP ||
+		     key->cipher == WLAN_CIPHER_SUITE_GCMP)) {
+			struct ieee80211_key_seq seq;
+			int tid, q;
+
+			mvmsta = iwl_mvm_sta_from_mac80211(sta);
+			WARN_ON(rcu_access_pointer(mvmsta->ptk_pn[keyidx]));
+			ptk_pn = kzalloc(sizeof(*ptk_pn) +
+					 mvm->trans->num_rx_queues *
+						sizeof(ptk_pn->q[0]),
+					 GFP_KERNEL);
+			if (!ptk_pn) {
+				ret = -ENOMEM;
+				break;
+			}
+
+			for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
+				ieee80211_get_key_rx_seq(key, tid, &seq);
+				for (q = 0; q < mvm->trans->num_rx_queues; q++)
+					memcpy(ptk_pn->q[q].pn[tid],
+					       seq.ccmp.pn,
+					       IEEE80211_CCMP_PN_LEN);
+			}
+
+			rcu_assign_pointer(mvmsta->ptk_pn[keyidx], ptk_pn);
+		}
+
 		/* in HW restart reuse the index, otherwise request a new one */
 		if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
 			key_offset = key->hw_key_idx;
@@ -2660,6 +2693,19 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			break;
 		}
 
+		if (sta && iwl_mvm_has_new_rx_api(mvm) &&
+		    key->flags & IEEE80211_KEY_FLAG_PAIRWISE &&
+		    (key->cipher == WLAN_CIPHER_SUITE_CCMP ||
+		     key->cipher == WLAN_CIPHER_SUITE_GCMP)) {
+			mvmsta = iwl_mvm_sta_from_mac80211(sta);
+			ptk_pn = rcu_dereference_protected(
+						mvmsta->ptk_pn[keyidx],
+						lockdep_is_held(&mvm->mutex));
+			RCU_INIT_POINTER(mvmsta->ptk_pn[keyidx], NULL);
+			if (ptk_pn)
+				kfree_rcu(ptk_pn, rcu_head);
+		}
+
 		IWL_DEBUG_MAC80211(mvm, "disable hwcrypto key\n");
 		ret = iwl_mvm_remove_sta_key(mvm, vif, sta, key);
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index e2a872d..0c073e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -78,12 +78,83 @@ void iwl_mvm_rx_phy_cmd_mq(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 #endif
 }
 
-static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
-					    struct napi_struct *napi,
-					    struct sk_buff *skb,
-					    struct ieee80211_hdr *hdr, u16 len,
-					    u32 ampdu_status, u8 crypt_len,
-					    struct iwl_rx_cmd_buffer *rxb)
+static inline int iwl_mvm_check_pn(struct iwl_mvm *mvm, struct sk_buff *skb,
+				   int queue, struct ieee80211_sta *sta)
+{
+	struct iwl_mvm_sta *mvmsta;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_rx_status *stats = IEEE80211_SKB_RXCB(skb);
+	struct iwl_mvm_key_pn *ptk_pn;
+	u8 tid, keyidx;
+	u8 pn[IEEE80211_CCMP_PN_LEN];
+	u8 *extiv;
+
+	/* do PN checking */
+
+	/* multicast and non-data only arrives on default queue */
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
+		return 0;
+
+	/* do not check PN for open AP */
+	if (!(stats->flag & RX_FLAG_DECRYPTED))
+		return 0;
+
+	/*
+	 * avoid checking for default queue - we don't want to replicate
+	 * all the logic that's necessary for checking the PN on fragmented
+	 * frames, leave that to mac80211
+	 */
+	if (queue == 0)
+		return 0;
+
+	/* if we are here - this for sure is either CCMP or GCMP */
+	if (IS_ERR_OR_NULL(sta)) {
+		IWL_ERR(mvm,
+			"expected hw-decrypted unicast frame for station\n");
+		return -1;
+	}
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	extiv = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
+	keyidx = extiv[3] >> 6;
+
+	ptk_pn = rcu_dereference(mvmsta->ptk_pn[keyidx]);
+	if (!ptk_pn)
+		return -1;
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	else
+		tid = 0;
+
+	/* we don't use HCCA/802.11 QoS TSPECs, so drop such frames */
+	if (tid >= IWL_MAX_TID_COUNT)
+		return -1;
+
+	/* load pn */
+	pn[0] = extiv[7];
+	pn[1] = extiv[6];
+	pn[2] = extiv[5];
+	pn[3] = extiv[4];
+	pn[4] = extiv[1];
+	pn[5] = extiv[0];
+
+	if (memcmp(pn, ptk_pn->q[queue].pn[tid],
+		   IEEE80211_CCMP_PN_LEN) <= 0)
+		return -1;
+
+	memcpy(ptk_pn->q[queue].pn[tid], pn, IEEE80211_CCMP_PN_LEN);
+	stats->flag |= RX_FLAG_PN_VALIDATED;
+
+	return 0;
+}
+
+/* iwl_mvm_create_skb Adds the rxb to a new skb */
+static void iwl_mvm_create_skb(struct sk_buff *skb, struct ieee80211_hdr *hdr,
+			       u16 len, u8 crypt_len,
+			       struct iwl_rx_cmd_buffer *rxb)
 {
 	unsigned int hdrlen, fraglen;
 
@@ -112,8 +183,18 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 		skb_add_rx_frag(skb, 0, rxb_steal_page(rxb), offset,
 				fraglen, rxb->truesize);
 	}
+}
 
-	ieee80211_rx_napi(mvm->hw, skb, napi);
+/* iwl_mvm_pass_packet_to_mac80211 - passes the packet for mac80211 */
+static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
+					    struct napi_struct *napi,
+					    struct sk_buff *skb, int queue,
+					    struct ieee80211_sta *sta)
+{
+	if (iwl_mvm_check_pn(mvm, skb, queue, sta))
+		kfree_skb(skb);
+	else
+		ieee80211_rx_napi(mvm->hw, skb, napi);
 }
 
 static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
@@ -141,7 +222,7 @@ static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
 	rx_status->chain_signal[2] = energy_c;
 }
 
-static u32 iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
+static int iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 			     struct ieee80211_rx_status *stats,
 			     struct iwl_rx_mpdu_desc *desc, int queue,
 			     u8 *crypt_len)
@@ -158,6 +239,7 @@ static u32 iwl_mvm_rx_crypto(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 	switch (status & IWL_RX_MPDU_STATUS_SEC_MASK) {
 	case IWL_RX_MPDU_STATUS_SEC_CCM:
 	case IWL_RX_MPDU_STATUS_SEC_GCM:
+		BUILD_BUG_ON(IEEE80211_CCMP_PN_LEN != IEEE80211_GCMP_PN_LEN);
 		/* alg is CCM: check MIC only */
 		if (!(status & IWL_RX_MPDU_STATUS_MIC_OK))
 			return -1;
@@ -217,7 +299,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	u32 rate_n_flags = le32_to_cpu(desc->rate_n_flags);
 	struct ieee80211_sta *sta = NULL;
 	struct sk_buff *skb;
-	u32 ampdu_status;
 	u8 crypt_len = 0;
 
 	/* Dont use dev_alloc_skb(), we'll have enough headroom once
@@ -311,8 +392,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			iwl_mvm_rx_csum(sta, skb, desc);
 	}
 
-	rcu_read_unlock();
-
 	/*
 	 * TODO: PHY info.
 	 * Verify we don't have the information in the MPDU descriptor and
@@ -367,8 +446,9 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	/* TODO: PHY info - update ampdu queue statistics (for debugfs) */
 	/* TODO: PHY info - gscan */
 
-	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, hdr, len, ampdu_status,
-					crypt_len, rxb);
+	iwl_mvm_create_skb(skb, hdr, len, crypt_len, rxb);
+	iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta);
+	rcu_read_unlock();
 }
 
 void iwl_mvm_rx_frame_release(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index badf17c..39fdf52 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015        Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -284,6 +286,13 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
 				tid_data->next_reclaimed);
 }
 
+struct iwl_mvm_key_pn {
+	struct rcu_head rcu_head;
+	struct {
+		u8 pn[IWL_MAX_TID_COUNT][IEEE80211_CCMP_PN_LEN];
+	} ____cacheline_aligned_in_smp q[];
+};
+
 /**
  * struct iwl_mvm_sta - representation of a station in the driver
  * @sta_id: the index of the station in the fw (will be replaced by id_n_color)
@@ -308,6 +317,7 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
  *	gets empty before all the frames were sent, which can happen when
  *	we are sending frames from an AMPDU queue and there was a hole in
  *	the BA window. To be used for UAPSD only.
+ * @ptk_pn: per-queue PTK PN data structures
  *
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is placed in that
@@ -328,6 +338,8 @@ struct iwl_mvm_sta {
 	struct iwl_lq_sta lq_sta;
 	struct ieee80211_vif *vif;
 
+	struct iwl_mvm_key_pn __rcu *ptk_pn[4];
+
 	/* Temporary, until the new TLC will control the Tx protection */
 	s8 tx_protection;
 	bool tt_tx_protection;
-- 
2.5.0

