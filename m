Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:34175 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab3LaRQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:34 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so5638974eek.38
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:33 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/28] iwlwifi: mvm: Add a missed beacons threshold
Date: Tue, 31 Dec 2013 19:15:51 +0200
Message-Id: <1388510157-23345-22-git-send-email-egrumbach@gmail.com> (sfid-20131231_183436_460569_DFB5C8F1)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Instead of always calling ieee80211_beacon_loss() on every missed
beacons notification, call this function only if the number of
consecutive missed beacons from last rx is higher than a predefined
threshold.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c |   25 ++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index eaaf2db..761cca3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1191,10 +1191,18 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 					 struct ieee80211_vif *vif)
 {
-	u16 *id = _data;
+	struct iwl_missed_beacons_notif *missed_beacons = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	if (mvmvif->id == *id)
+	if (mvmvif->id != (u16)le32_to_cpu(missed_beacons->mac_id))
+		return;
+
+	/*
+	 * TODO: the threshold should be adjusted based on latency conditions,
+	 * and/or in case of a CS flow on one of the other AP vifs.
+	 */
+	if (le32_to_cpu(missed_beacons->consec_missed_beacons_since_last_rx) >
+	     IWL_MVM_MISSED_BEACONS_THRESHOLD)
 		ieee80211_beacon_loss(vif);
 }
 
@@ -1203,12 +1211,19 @@ int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_missed_beacons_notif *missed_beacons = (void *)pkt->data;
-	u16 id = (u16)le32_to_cpu(missed_beacons->mac_id);
+	struct iwl_missed_beacons_notif *mb = (void *)pkt->data;
+
+	IWL_DEBUG_INFO(mvm,
+		       "missed bcn mac_id=%u, consecutive=%u (%u, %u, %u)\n",
+		       le32_to_cpu(mb->mac_id),
+		       le32_to_cpu(mb->consec_missed_beacons),
+		       le32_to_cpu(mb->consec_missed_beacons_since_last_rx),
+		       le32_to_cpu(mb->num_recvd_beacons),
+		       le32_to_cpu(mb->num_expected_beacons));
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 						   IEEE80211_IFACE_ITER_NORMAL,
 						   iwl_mvm_beacon_loss_iterator,
-						   &id);
+						   mb);
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 84edf36..ca8a904 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -81,6 +81,7 @@
 #define IWL_MVM_MAX_ADDRESSES		5
 /* RSSI offset for WkP */
 #define IWL_RSSI_OFFSET 50
+#define IWL_MVM_MISSED_BEACONS_THRESHOLD 8
 
 enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BK = 0,
-- 
1.7.9.5

