Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42540 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbaICT4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:40 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so9044875wgh.27
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:39 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/36] iwlwifi: mvm: Add marker command 0xcb
Date: Wed,  3 Sep 2014 22:55:56 +0300
Message-Id: <1409774184-24665-8-git-send-email-egrumbach@gmail.com> (sfid-20140903_215645_860413_9C33E103)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Add Marker command.
The marker command send the ucode the time of sending the command in
milliseconds since 1970-01-01 00:00:00 UTC, in addition to other metatdata.
The ucode inserts this information into the usniffer logs, and returns the GP2
time stamp inside the command response.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 95f5b32..ed7d3f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -184,6 +184,8 @@ enum {
 	REPLY_RX_MPDU_CMD = 0xc1,
 	BA_NOTIF = 0xc5,
 
+	MARKER_CMD = 0xcb,
+
 	/* BT Coex */
 	BT_COEX_PRIO_TABLE = 0xcc,
 	BT_COEX_PROT_ENV = 0xcd,
@@ -1307,6 +1309,38 @@ struct iwl_bcast_filter_cmd {
 	struct iwl_fw_bcast_mac macs[NUM_MAC_INDEX_DRIVER];
 } __packed; /* BCAST_FILTERING_HCMD_API_S_VER_1 */
 
+/*
+ * enum iwl_mvm_marker_id - maker ids
+ *
+ * The ids for different type of markers to insert into the usniffer logs
+ */
+enum iwl_mvm_marker_id {
+	MARKER_ID_TX_FRAME_LATENCY = 1,
+}; /* MARKER_ID_API_E_VER_1 */
+
+/**
+ * struct iwl_mvm_marker - mark info into the usniffer logs
+ *
+ * (MARKER_CMD = 0xcb)
+ *
+ * Mark the UTC time stamp into the usniffer logs together with additional
+ * metadata, so the usniffer output can be parsed.
+ * In the command response the ucode will return the GP2 time.
+ *
+ * @dw_len: The amount of dwords following this byte including this byte.
+ * @marker_id: A unique marker id (iwl_mvm_marker_id).
+ * @reserved: reserved.
+ * @timestamp: in milliseconds since 1970-01-01 00:00:00 UTC
+ * @metadata: additional meta data that will be written to the unsiffer log
+ */
+struct iwl_mvm_marker {
+	u8 dwLen;
+	u8 markerId;
+	__le16 reserved;
+	__le64 timestamp;
+	__le32 metadata[0];
+} __packed; /* MARKER_API_S_VER_1 */
+
 struct mvm_statistics_dbg {
 	__le32 burst_check;
 	__le32 burst_count;
-- 
1.9.1

