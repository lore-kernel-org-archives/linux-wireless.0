Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41519 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430AbaGVT1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:24 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so6555819wiv.13
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:23 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ariej Marjieh <ariej.marjieh@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/20] iwlwifi: mvm: Define AUX ROC Command
Date: Tue, 22 Jul 2014 22:26:39 +0300
Message-Id: <1406057211-31752-8-git-send-email-egrumbach@gmail.com> (sfid-20140722_212733_032875_4EA57AEC)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ariej Marjieh <ariej.marjieh@intel.com>

Add new AUX ROC command that is intended for HS2.0 purposes.
It is used to send ANQP requests on a specific channel.

This command requests the firmware to trigger a time event
and remain on a certain channel for a given duration.
Triggering the time event is done by using the Aux
Framework in the firmware, and makes use of the Aux station
(similarly to scan).

Signed-off-by: Ariej Marjieh <ariej.marjieh@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 67 +++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index b8e4e78..95f5b32 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -133,6 +133,7 @@ enum {
 	/* Scan offload */
 	SCAN_OFFLOAD_REQUEST_CMD = 0x51,
 	SCAN_OFFLOAD_ABORT_CMD = 0x52,
+	HOT_SPOT_CMD = 0x53,
 	SCAN_OFFLOAD_COMPLETE = 0x6D,
 	SCAN_OFFLOAD_UPDATE_PROFILES_CMD = 0x6E,
 	SCAN_OFFLOAD_CONFIG_CMD = 0x6f,
@@ -910,6 +911,72 @@ struct iwl_phy_context_cmd {
 	__le32 dsp_cfg_flags;
 } __packed; /* PHY_CONTEXT_CMD_API_VER_1 */
 
+/*
+ * Aux ROC command
+ *
+ * Command requests the firmware to create a time event for a certain duration
+ * and remain on the given channel. This is done by using the Aux framework in
+ * the FW.
+ * The command was first used for Hot Spot issues - but can be used regardless
+ * to Hot Spot.
+ *
+ * ( HOT_SPOT_CMD 0x53 )
+ *
+ * @id_and_color: ID and color of the MAC
+ * @action: action to perform, one of FW_CTXT_ACTION_*
+ * @event_unique_id: If the action FW_CTXT_ACTION_REMOVE then the
+ *	event_unique_id should be the id of the time event assigned by ucode.
+ *	Otherwise ignore the event_unique_id.
+ * @sta_id_and_color: station id and color, resumed during "Remain On Channel"
+ *	activity.
+ * @channel_info: channel info
+ * @node_addr: Our MAC Address
+ * @reserved: reserved for alignment
+ * @apply_time: GP2 value to start (should always be the current GP2 value)
+ * @apply_time_max_delay: Maximum apply time delay value in TU. Defines max
+ *	time by which start of the event is allowed to be postponed.
+ * @duration: event duration in TU To calculate event duration:
+ *	timeEventDuration = min(duration, remainingQuota)
+ */
+struct iwl_hs20_roc_req {
+	/* COMMON_INDEX_HDR_API_S_VER_1 hdr */
+	__le32 id_and_color;
+	__le32 action;
+	__le32 event_unique_id;
+	__le32 sta_id_and_color;
+	struct iwl_fw_channel_info channel_info;
+	u8 node_addr[ETH_ALEN];
+	__le16 reserved;
+	__le32 apply_time;
+	__le32 apply_time_max_delay;
+	__le32 duration;
+} __packed; /* HOT_SPOT_CMD_API_S_VER_1 */
+
+/*
+ * values for AUX ROC result values
+ */
+enum iwl_mvm_hot_spot {
+	HOT_SPOT_RSP_STATUS_OK,
+	HOT_SPOT_RSP_STATUS_TOO_MANY_EVENTS,
+	HOT_SPOT_MAX_NUM_OF_SESSIONS,
+};
+
+/*
+ * Aux ROC command response
+ *
+ * In response to iwl_hs20_roc_req the FW sends this command to notify the
+ * driver the uid of the timevent.
+ *
+ * ( HOT_SPOT_CMD 0x53 )
+ *
+ * @event_unique_id: Unique ID of time event assigned by ucode
+ * @status: Return status 0 is success, all the rest used for specific errors
+ */
+struct iwl_hs20_roc_res {
+	__le32 event_unique_id;
+	__le32 status;
+} __packed; /* HOT_SPOT_RSP_API_S_VER_1 */
+
 #define IWL_RX_INFO_PHY_CNT 8
 #define IWL_RX_INFO_ENERGY_ANT_ABC_IDX 1
 #define IWL_RX_INFO_ENERGY_ANT_A_MSK 0x000000ff
-- 
1.8.3.2

