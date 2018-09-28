Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BA2C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F84B2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F84B2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbeI1OpA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:45:00 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53422 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728275AbeI1Oo7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:44:59 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2Y-0004tY-0U; Fri, 28 Sep 2018 11:22:22 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:21:59 +0300
Message-Id: <20180928082210.20762-8-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/18] iwlwifi: dbg: group trigger condition to helper function
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

The triplet of get trigger, is trigger enabled and is trigger stopped
repeats itself.  Group them in a function to avoid code duplication.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   | 24 ++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 12 ++-----
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 33 +++++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  8 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   | 29 +++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 22 +++++--------
 .../wireless/intel/iwlwifi/mvm/time-event.c   | 11 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   | 15 +++------
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 16 ++++-----
 9 files changed, 77 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index e1e8a1a03c68..5b087fc4f380 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -188,6 +188,30 @@ iwl_fw_dbg_trigger_check_stop(struct iwl_fw_runtime *fwrt,
 	return iwl_fw_dbg_trigger_stop_conf_match(fwrt, trig);
 }
 
+static inline struct iwl_fw_dbg_trigger_tlv*
+_iwl_fw_dbg_trigger_on(struct iwl_fw_runtime *fwrt,
+		       struct wireless_dev *wdev,
+		       const enum iwl_fw_dbg_trigger id)
+{
+	struct iwl_fw_dbg_trigger_tlv *trig;
+
+	if (!iwl_fw_dbg_trigger_enabled(fwrt->fw, id))
+		return NULL;
+
+	trig = _iwl_fw_dbg_get_trigger(fwrt->fw, id);
+
+	if (!iwl_fw_dbg_trigger_check_stop(fwrt, wdev, trig))
+		return NULL;
+
+	return trig;
+}
+
+#define iwl_fw_dbg_trigger_on(fwrt, wdev, id) ({		\
+	BUILD_BUG_ON(!__builtin_constant_p(id));		\
+	BUILD_BUG_ON((id) >= FW_DBG_TRIGGER_MAX);		\
+	_iwl_fw_dbg_trigger_on((fwrt), (wdev), (id));		\
+})
+
 static inline void
 _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 				struct wireless_dev *wdev,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 781f30356720..6486cfb33f40 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1487,12 +1487,11 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 	     IWL_MVM_MISSED_BEACONS_THRESHOLD)
 		ieee80211_beacon_loss(vif);
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw,
-					FW_DBG_TRIGGER_MISSED_BEACONS))
+	trigger = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
+					FW_DBG_TRIGGER_MISSED_BEACONS);
+	if (!trigger)
 		return;
 
-	trigger = iwl_fw_dbg_get_trigger(mvm->fw,
-					 FW_DBG_TRIGGER_MISSED_BEACONS);
 	bcon_trig = (void *)trigger->data;
 	stop_trig_missed_bcon = le32_to_cpu(bcon_trig->stop_consec_missed_bcon);
 	stop_trig_missed_bcon_since_rx =
@@ -1500,11 +1499,6 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 
 	/* TODO: implement start trigger */
 
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-					   ieee80211_vif_to_wdev(vif),
-					   trigger))
-		return;
-
 	if (rx_missed_bcon_since_rx >= stop_trig_missed_bcon_since_rx ||
 	    rx_missed_bcon >= stop_trig_missed_bcon)
 		iwl_fw_dbg_collect_trig(&mvm->fwrt, trigger, NULL);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 4a54756bd1d8..356d3ea57d92 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -857,16 +857,13 @@ iwl_mvm_ampdu_check_trigger(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_ba *ba_trig;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_BA))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
+				     FW_DBG_TRIGGER_BA);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
 	ba_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-					   ieee80211_vif_to_wdev(vif), trig))
-		return;
-
 	switch (action) {
 	case IEEE80211_AMPDU_TX_OPERATIONAL: {
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
@@ -2806,14 +2803,12 @@ iwl_mvm_tdls_check_trigger(struct iwl_mvm *mvm,
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_tdls *tdls_trig;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TDLS))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
+				     FW_DBG_TRIGGER_TDLS);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TDLS);
 	tdls_trig = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-					   ieee80211_vif_to_wdev(vif), trig))
-		return;
 
 	if (!(tdls_trig->action_bitmap & BIT(action)))
 		return;
@@ -4495,14 +4490,12 @@ static void iwl_mvm_event_mlme_callback(struct iwl_mvm *mvm,
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_mlme *trig_mlme;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_MLME))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
+				     FW_DBG_TRIGGER_MLME);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_MLME);
 	trig_mlme = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-					   ieee80211_vif_to_wdev(vif), trig))
-		return;
 
 	if (event->u.mlme.data == ASSOC_EVENT) {
 		if (event->u.mlme.status == MLME_DENIED)
@@ -4537,14 +4530,12 @@ static void iwl_mvm_event_bar_rx_callback(struct iwl_mvm *mvm,
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_ba *ba_trig;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_BA))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
+				     FW_DBG_TRIGGER_BA);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
 	ba_trig = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-					   ieee80211_vif_to_wdev(vif), trig))
-		return;
 
 	if (!(le16_to_cpu(ba_trig->rx_bar) & BIT(event->u.ba.tid)))
 		return;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5f2f599a7ccd..2f611bf83d56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -953,15 +953,13 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 	struct iwl_fw_dbg_trigger_cmd *cmds_trig;
 	int i;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_FW_NOTIF))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, NULL,
+				     FW_DBG_TRIGGER_FW_NOTIF);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_FW_NOTIF);
 	cmds_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt, NULL, trig))
-		return;
-
 	for (i = 0; i < ARRAY_SIZE(cmds_trig->cmds); i++) {
 		/* don't collect on CMD 0 */
 		if (!cmds_trig->cmds[i].cmd_id)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index a050220da678..ef624833cf1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -433,13 +433,14 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 		struct ieee80211_vif *tx_blocked_vif =
 			rcu_dereference(mvm->csa_tx_blocked_vif);
+		struct iwl_fw_dbg_trigger_tlv *trig;
+		struct ieee80211_vif *vif = mvmsta->vif;
 
 		/* We have tx blocked stations (with CS bit). If we heard
 		 * frames from a blocked station on a new channel we can
 		 * TX to it again.
 		 */
-		if (unlikely(tx_blocked_vif) &&
-		    mvmsta->vif == tx_blocked_vif) {
+		if (unlikely(tx_blocked_vif) && vif == tx_blocked_vif) {
 			struct iwl_mvm_vif *mvmvif =
 				iwl_mvm_vif_from_mac80211(tx_blocked_vif);
 
@@ -450,23 +451,18 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 		rs_update_last_rssi(mvm, mvmsta, rx_status);
 
-		if (iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_RSSI) &&
-		    ieee80211_is_beacon(hdr->frame_control)) {
-			struct iwl_fw_dbg_trigger_tlv *trig;
+		trig = iwl_fw_dbg_trigger_on(&mvm->fwrt,
+					     ieee80211_vif_to_wdev(vif),
+					     FW_DBG_TRIGGER_RSSI);
+
+		if (trig && ieee80211_is_beacon(hdr->frame_control)) {
 			struct iwl_fw_dbg_trigger_low_rssi *rssi_trig;
-			bool trig_check;
 			s32 rssi;
 
-			trig = iwl_fw_dbg_get_trigger(mvm->fw,
-						      FW_DBG_TRIGGER_RSSI);
 			rssi_trig = (void *)trig->data;
 			rssi = le32_to_cpu(rssi_trig->rssi);
 
-			trig_check =
-				iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-							      ieee80211_vif_to_wdev(mvmsta->vif),
-							      trig);
-			if (trig_check && rx_status->signal < rssi)
+			if (rx_status->signal < rssi)
 				iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
 							NULL);
 		}
@@ -693,15 +689,12 @@ iwl_mvm_rx_stats_check_trigger(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 	struct iwl_fw_dbg_trigger_stats *trig_stats;
 	u32 trig_offset, trig_thold;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_STATS))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, NULL, FW_DBG_TRIGGER_STATS);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_STATS);
 	trig_stats = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt, NULL, trig))
-		return;
-
 	trig_offset = le32_to_cpu(trig_stats->stop_offset);
 	trig_thold = le32_to_cpu(trig_stats->stop_threshold);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 894dd6379b9a..5f79133029da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -1424,6 +1424,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		u8 baid = (u8)((le32_to_cpu(desc->reorder_data) &
 			       IWL_RX_MPDU_REORDER_BAID_MASK) >>
 			       IWL_RX_MPDU_REORDER_BAID_SHIFT);
+		struct iwl_fw_dbg_trigger_tlv *trig;
+		struct ieee80211_vif *vif = mvmsta->vif;
 
 		if (!mvm->tcm.paused && len >= sizeof(*hdr) &&
 		    !is_multicast_ether_addr(hdr->addr1) &&
@@ -1436,8 +1438,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		 * frames from a blocked station on a new channel we can
 		 * TX to it again.
 		 */
-		if (unlikely(tx_blocked_vif) &&
-		    tx_blocked_vif == mvmsta->vif) {
+		if (unlikely(tx_blocked_vif) && tx_blocked_vif == vif) {
 			struct iwl_mvm_vif *mvmvif =
 				iwl_mvm_vif_from_mac80211(tx_blocked_vif);
 
@@ -1448,23 +1449,18 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 		rs_update_last_rssi(mvm, mvmsta, rx_status);
 
-		if (iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_RSSI) &&
-		    ieee80211_is_beacon(hdr->frame_control)) {
-			struct iwl_fw_dbg_trigger_tlv *trig;
+		trig = iwl_fw_dbg_trigger_on(&mvm->fwrt,
+					     ieee80211_vif_to_wdev(vif),
+					     FW_DBG_TRIGGER_RSSI);
+
+		if (trig && ieee80211_is_beacon(hdr->frame_control)) {
 			struct iwl_fw_dbg_trigger_low_rssi *rssi_trig;
-			bool trig_check;
 			s32 rssi;
 
-			trig = iwl_fw_dbg_get_trigger(mvm->fw,
-						      FW_DBG_TRIGGER_RSSI);
 			rssi_trig = (void *)trig->data;
 			rssi = le32_to_cpu(rssi_trig->rssi);
 
-			trig_check =
-				iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-							      ieee80211_vif_to_wdev(mvmsta->vif),
-							      trig);
-			if (trig_check && rx_status->signal < rssi)
+			if (rx_status->signal < rssi)
 				iwl_fw_dbg_collect_trig(&mvm->fwrt, trig,
 							NULL);
 		}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index cd91bc44259c..e1a6f4e22253 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -254,17 +254,14 @@ static void iwl_mvm_te_check_trigger(struct iwl_mvm *mvm,
 	struct iwl_fw_dbg_trigger_time_event *te_trig;
 	int i;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TIME_EVENT))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt,
+				     ieee80211_vif_to_wdev(te_data->vif),
+				     FW_DBG_TRIGGER_TIME_EVENT);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TIME_EVENT);
 	te_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-					   ieee80211_vif_to_wdev(te_data->vif),
-					   trig))
-		return;
-
 	for (i = 0; i < ARRAY_SIZE(te_trig->time_events); i++) {
 		u32 trig_te_id = le32_to_cpu(te_trig->time_events[i].id);
 		u32 trig_action_bitmap =
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index a6877b3f8037..99c64ea2619b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -79,15 +79,12 @@ iwl_mvm_bar_check_trigger(struct iwl_mvm *mvm, const u8 *addr,
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_ba *ba_trig;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_BA))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, NULL, FW_DBG_TRIGGER_BA);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
 	ba_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt, NULL, trig))
-		return;
-
 	if (!(le16_to_cpu(ba_trig->tx_bar) & BIT(tid)))
 		return;
 
@@ -1414,15 +1411,13 @@ static void iwl_mvm_tx_status_check_trigger(struct iwl_mvm *mvm,
 	struct iwl_fw_dbg_trigger_tx_status *status_trig;
 	int i;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_TX_STATUS))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, NULL,
+				     FW_DBG_TRIGGER_TX_STATUS);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_TX_STATUS);
 	status_trig = (void *)trig->data;
 
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt, NULL, trig))
-		return;
-
 	for (i = 0; i < ARRAY_SIZE(status_trig->statuses); i++) {
 		/* don't collect on status 0 */
 		if (!status_trig->statuses[i].status)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index dcacc4d11abc..6c14d3413bdc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1238,14 +1238,12 @@ void iwl_mvm_connection_loss(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_mlme *trig_mlme;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_MLME))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
+				     FW_DBG_TRIGGER_MLME);
+	if (!trig)
 		goto out;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_MLME);
 	trig_mlme = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-					   ieee80211_vif_to_wdev(vif), trig))
-		goto out;
 
 	if (trig_mlme->stop_connection_loss &&
 	    --trig_mlme->stop_connection_loss)
@@ -1430,14 +1428,12 @@ void iwl_mvm_event_frame_timeout_callback(struct iwl_mvm *mvm,
 	struct iwl_fw_dbg_trigger_tlv *trig;
 	struct iwl_fw_dbg_trigger_ba *ba_trig;
 
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, FW_DBG_TRIGGER_BA))
+	trig = iwl_fw_dbg_trigger_on(&mvm->fwrt, ieee80211_vif_to_wdev(vif),
+				     FW_DBG_TRIGGER_BA);
+	if (!trig)
 		return;
 
-	trig = iwl_fw_dbg_get_trigger(mvm->fw, FW_DBG_TRIGGER_BA);
 	ba_trig = (void *)trig->data;
-	if (!iwl_fw_dbg_trigger_check_stop(&mvm->fwrt,
-					   ieee80211_vif_to_wdev(vif), trig))
-		return;
 
 	if (!(le16_to_cpu(ba_trig->frame_timeout) & BIT(tid)))
 		return;
-- 
2.19.0

