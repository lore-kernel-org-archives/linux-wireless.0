Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843Ab3BLQCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:15 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 04/15] iwlwifi: mvm: Change the Time Event type used for ROC
Date: Tue, 12 Feb 2013 17:01:56 +0100
Message-Id: <1360684927-1367-4-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170221_161907_9F0C57D7)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The TE_P2P_DEVICE_DISCOVERABLE time event type used for ROC is
assigned low priority in the FW, and thus has low chance of
being scheduled when there are active BSS or GO VMACs (even if
fragmentation is allowed). This is mainly problematic in for
cases where ROC is requested for sending action frames.

To overcome this, use a time event type that has priority equal
to that ot the time event type used by the FW to action scan.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index b9f076f..4d62a5d4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -76,6 +76,15 @@
 #define TU_TO_JIFFIES(_tu)	(usecs_to_jiffies((_tu) * 1024))
 #define MSEC_TO_TU(_msec)	(_msec*1000/1024)
 
+/* For ROC use a TE type which has priority high enough to be scheduled when
+ * there is a concurrent BSS or GO/AP. Currently, use a TE type that has
+ * priority similar to the TE priority used for action scans by the FW.
+ * TODO: This needs to be changed, based on the reason for the ROC, i.e., use
+ * TE_P2P_DEVICE_DISCOVERABLE for remain on channel without mgmt skb, and use
+ * TE_P2P_DEVICE_ACTION_SCAN
+ */
+#define IWL_MVM_ROC_TE_TYPE TE_P2P_DEVICE_ACTION_SCAN
+
 void iwl_mvm_te_clear_data(struct iwl_mvm *mvm,
 			   struct iwl_mvm_time_event_data *te_data)
 {
@@ -436,7 +445,7 @@ static bool iwl_mvm_roc_te_notif(struct iwl_notif_wait_data *notif_wait,
 	u32 mac_id_n_color = FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color);
 
 	/* until we do something else */
-	WARN_ON(te_data->id != TE_P2P_DEVICE_DISCOVERABLE);
+	WARN_ON(te_data->id != IWL_MVM_ROC_TE_TYPE);
 
 	switch (pkt->hdr.cmd) {
 	case TIME_EVENT_CMD:
@@ -483,7 +492,7 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	time_cmd.action = cpu_to_le32(FW_CTXT_ACTION_ADD);
 	time_cmd.id_and_color =
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
-	time_cmd.id = cpu_to_le32(TE_P2P_DEVICE_DISCOVERABLE);
+	time_cmd.id = cpu_to_le32(IWL_MVM_ROC_TE_TYPE);
 
 	time_cmd.apply_time = cpu_to_le32(0);
 	time_cmd.dep_policy = cpu_to_le32(TE_INDEPENDENT);
@@ -492,7 +501,7 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	time_cmd.interval = cpu_to_le32(1);
 
 	/*
-	 * TE_P2P_DEVICE_DISCOVERABLE can have lower priority than other events
+	 * IWL_MVM_ROC_TE_TYPE can have lower priority than other events
 	 * that are being scheduled by the driver/fw, and thus it might not be
 	 * scheduled. To improve the chances of it being scheduled, allow it to
 	 * be fragmented.
-- 
1.8.0

