Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab0HWOx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/26] iwlwifi: add 6000g2b BT coexist API
Date: Mon, 23 Aug 2010 07:56:54 -0700
Message-Id: <1282575437-23270-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new 6000g2b hardware requires a different
bluetooth coexist implementation on the host,
this adds the command/notification definitions
for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   76 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    3 +
 2 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e2f3616..78086ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -173,6 +173,12 @@ enum {
 	REPLY_RX_MPDU_CMD = 0xc1,
 	REPLY_RX = 0xc3,
 	REPLY_COMPRESSED_BA = 0xc5,
+
+	/* BT Coex */
+	REPLY_BT_COEX_PRIO_TABLE = 0xcc,
+	REPLY_BT_COEX_PROT_ENV = 0xcd,
+	REPLY_BT_COEX_PROFILE_NOTIF = 0xce,
+
 	REPLY_MAX = 0xff
 };
 
@@ -2896,6 +2902,12 @@ struct iwl_scanstart_notification {
 #define  SCAN_OWNER_STATUS 0x1;
 #define  MEASURE_OWNER_STATUS 0x2;
 
+#define IWL_PROBE_STATUS_OK		0
+#define IWL_PROBE_STATUS_TX_FAILED	BIT(0)
+/* error statuses combined with TX_FAILED */
+#define IWL_PROBE_STATUS_FAIL_TTL	BIT(1)
+#define IWL_PROBE_STATUS_FAIL_BT	BIT(2)
+
 #define NUMBER_OF_STATISTICS 1	/* first __le32 is good CRC */
 /*
  * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
@@ -2903,7 +2915,8 @@ struct iwl_scanstart_notification {
 struct iwl_scanresults_notification {
 	u8 channel;
 	u8 band;
-	u8 reserved[2];
+	u8 probe_status;
+	u8 num_probe_not_sent; /* not enough time to send */
 	__le32 tsf_low;
 	__le32 tsf_high;
 	__le32 statistics[NUMBER_OF_STATISTICS];
@@ -3969,6 +3982,66 @@ struct iwl_coex_event_resp {
 
 
 /******************************************************************************
+ * Bluetooth Coexistence commands
+ *
+ *****************************************************************************/
+
+/*
+ * BT Status notification
+ * REPLY_BT_COEX_PROFILE_NOTIF = 0xcb
+ */
+enum iwl_bt_coex_profile_traffic_load {
+	IWL_BT_COEX_TRAFFIC_LOAD_NONE = 	0,
+	IWL_BT_COEX_TRAFFIC_LOAD_LOW =		1,
+	IWL_BT_COEX_TRAFFIC_LOAD_HIGH = 	2,
+	IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS =	3,
+/*
+ * There are no more even though below is a u8, the
+ * indication from the BT device only has two bits.
+ */
+};
+
+struct iwl_bt_coex_profile_notif {
+	u8 uart_msg[8];
+	u8 bt_status; /* 0 - off, 1 - on */
+	u8 bt_traffic_load; /* 0 .. 3? */
+	u8 bt_ci_compliance; /* 0 - not complied, 1 - complied */
+	u8 reserved;
+} __attribute__((packed));
+
+#define IWL_BT_COEX_PRIO_SHARED_ANTENNA		0x1
+#define IWL_BT_COEX_PRIO_PRIO_MASK		0xe
+#define IWL_BT_COEX_PRIO_PRIO_SHIFT		1
+
+/*
+ * BT Coexistence Priority table
+ * REPLY_BT_COEX_PRIO_TABLE = 0xcc
+ */
+struct iwl_bt_coex_prio_table_cmd {
+	u8 init_calib_protection_cfg1,
+	   init_calib_protection_cfg2,
+	   init_calib_protection_lowprio_cfg1,
+	   init_calib_protection_lowprio_cfg2,
+	   init_calib_protection_highprio_cfg1,
+	   init_calib_protection_highprio_cfg2,
+	   dtim_protection_prio_cfg,
+	   scan_52_protection_cfg,
+	   scan_24_protection_cfg,
+	   bc_mc_protection_cfg;
+	u8 reserved[6];
+} __attribute__((packed));
+
+/*
+ * BT Protection Envelope
+ * REPLY_BT_COEX_PROT_ENV = 0xcd
+ */
+struct iwl_bt_coex_prot_env_cmd {
+	u8 open; /* 0 = closed, 1 = open */
+	u8 type; /* 0 .. 15 */
+	u8 reserved[2];
+} __attribute__((packed));
+
+/******************************************************************************
  * (13)
  * Union of all expected notifications/responses:
  *
@@ -4007,6 +4080,7 @@ struct iwl_rx_packet {
 		struct iwl_missed_beacon_notif missed_beacon;
 		struct iwl_coex_medium_notification coex_medium_notif;
 		struct iwl_coex_event_resp coex_event;
+		struct iwl_bt_coex_profile_notif bt_coex_profile_notif;
 		__le32 status;
 		u8 raw[0];
 	} u;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 258d059..1f15b3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -97,6 +97,9 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_TX_POWER_DBM_CMD);
 		IWL_CMD(TEMPERATURE_NOTIFICATION);
 		IWL_CMD(TX_ANT_CONFIGURATION_CMD);
+		IWL_CMD(REPLY_BT_COEX_PROFILE_NOTIF);
+		IWL_CMD(REPLY_BT_COEX_PRIO_TABLE);
+		IWL_CMD(REPLY_BT_COEX_PROT_ENV);
 	default:
 		return "UNKNOWN";
 
-- 
1.7.0.4

