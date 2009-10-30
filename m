Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbZJ3VgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/15] iwlwifi: coex API data structure
Date: Fri, 30 Oct 2009 14:36:16 -0700
Message-Id: <1256938578-9638-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add data structure define for COEX_MEDIUM_NOTIFICATION and
COEX_EVENT_CMD host commands.

COEX_MEDIUM_NOTIFICATION is notification from uCode to host to indicate
medium changes. COEX_EVENT_CMD is from host to uCode for coex event
request.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   69 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 954bad6..43dd6af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3503,30 +3503,42 @@ struct iwl_led_cmd {
 } __attribute__ ((packed));
 
 /*
- * Coexistence WIFI/WIMAX  Command
- * COEX_PRIORITY_TABLE_CMD = 0x5a
- *
+ * station priority table entries
+ * also used as potential "events" value for both
+ * COEX_MEDIUM_NOTIFICATION and COEX_EVENT_CMD
  */
 enum {
+	/* un-association part */
 	COEX_UNASSOC_IDLE		= 0,
 	COEX_UNASSOC_MANUAL_SCAN	= 1,
 	COEX_UNASSOC_AUTO_SCAN		= 2,
+	/* calibration */
 	COEX_CALIBRATION		= 3,
 	COEX_PERIODIC_CALIBRATION	= 4,
+	/* connection */
 	COEX_CONNECTION_ESTAB		= 5,
+	/* association part */
 	COEX_ASSOCIATED_IDLE		= 6,
 	COEX_ASSOC_MANUAL_SCAN		= 7,
 	COEX_ASSOC_AUTO_SCAN		= 8,
 	COEX_ASSOC_ACTIVE_LEVEL		= 9,
+	/* RF ON/OFF */
 	COEX_RF_ON			= 10,
 	COEX_RF_OFF			= 11,
 	COEX_STAND_ALONE_DEBUG		= 12,
+	/* IPAN */
 	COEX_IPAN_ASSOC_LEVEL		= 13,
+	/* reserved */
 	COEX_RSRVD1			= 14,
 	COEX_RSRVD2			= 15,
 	COEX_NUM_OF_EVENTS		= 16
 };
 
+/*
+ * Coexistence WIFI/WIMAX  Command
+ * COEX_PRIORITY_TABLE_CMD = 0x5a
+ *
+ */
 struct iwl_wimax_coex_event_entry {
 	u8 request_prio;
 	u8 win_medium_prio;
@@ -3551,6 +3563,55 @@ struct iwl_wimax_coex_cmd {
 	struct iwl_wimax_coex_event_entry sta_prio[COEX_NUM_OF_EVENTS];
 } __attribute__ ((packed));
 
+/*
+ * Coexistence MEDIUM NOTIFICATION
+ * COEX_MEDIUM_NOTIFICATION = 0x5b
+ *
+ * notification from uCode to host to indicate medium changes
+ *
+ */
+/*
+ * status field
+ * bit 0 - 2: medium status
+ * bit 3: medium change indication
+ * bit 4 - 31: reserved
+ */
+/* status option values, (0 - 2 bits) */
+#define COEX_MEDIUM_BUSY	(0x0) /* radio belongs to WiMAX */
+#define COEX_MEDIUM_ACTIVE	(0x1) /* radio belongs to WiFi */
+#define COEX_MEDIUM_PRE_RELEASE	(0x2) /* received radio release */
+#define COEX_MEDIUM_MSK		(0x7)
+
+/* send notification status (1 bit) */
+#define COEX_MEDIUM_CHANGED	(0x8)
+#define COEX_MEDIUM_CHANGED_MSK	(0x8)
+#define COEX_MEDIUM_SHIFT	(3)
+
+struct iwl_coex_medium_notification {
+	__le32 status;
+	__le32 events;
+} __attribute__ ((packed));
+
+/*
+ * Coexistence EVENT  Command
+ * COEX_EVENT_CMD = 0x5c
+ *
+ * send from host to uCode for coex event request.
+ */
+/* flags options */
+#define COEX_EVENT_REQUEST_MSK	(0x1)
+
+struct iwl_coex_event_cmd {
+	u8 flags;
+	u8 event;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct iwl_coex_event_resp {
+	__le32 status;
+} __attribute__ ((packed));
+
+
 /******************************************************************************
  * (13)
  * Union of all expected notifications/responses:
@@ -3587,6 +3648,8 @@ struct iwl_rx_packet {
 		struct iwl_notif_statistics stats;
 		struct iwl_compressed_ba_resp compressed_ba;
 		struct iwl_missed_beacon_notif missed_beacon;
+		struct iwl_coex_medium_notification coex_medium_notif;
+		struct iwl_coex_event_resp coex_event;
 		__le32 status;
 		u8 raw[0];
 	} u;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index d7ebc5f..ccf50a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -56,6 +56,8 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_LEDS_CMD);
 		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
 		IWL_CMD(COEX_PRIORITY_TABLE_CMD);
+		IWL_CMD(COEX_MEDIUM_NOTIFICATION);
+		IWL_CMD(COEX_EVENT_CMD);
 		IWL_CMD(RADAR_NOTIFICATION);
 		IWL_CMD(REPLY_QUIET_CMD);
 		IWL_CMD(REPLY_CHANNEL_SWITCH);
-- 
1.5.6.3

