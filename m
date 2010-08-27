Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab0H0Q4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/27] iwlwifi: add PAN API
Date: Fri, 27 Aug 2010 09:59:45 -0700
Message-Id: <1282928395-32762-18-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Define the new host commands and notifications
	REPLY_WIPAN_PARAMS
	REPLY_WIPAN_RXON
	REPLY_WIPAN_RXON_TIMING
	REPLY_WIPAN_RXON_ASSOC
	REPLY_WIPAN_QOS_PARAM
	REPLY_WIPAN_WEPKEY
	REPLY_WIPAN_P2P_CHANNEL_SWITCH
	REPLY_WIPAN_NOA_NOTIFICATION

and their corresponding structures along with the PAN
station flag, the PAN AP sta ID and new dev types for
the second context.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |  109 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    8 ++
 2 files changed, 116 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 55779bf..3e4ba31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -180,6 +180,16 @@ enum {
 	REPLY_BT_COEX_PROFILE_NOTIF = 0xce,
 	REPLY_BT_COEX_SCO = 0xcf,
 
+	/* PAN commands */
+	REPLY_WIPAN_PARAMS = 0xb2,
+	REPLY_WIPAN_RXON = 0xb3,	/* use REPLY_RXON structure */
+	REPLY_WIPAN_RXON_TIMING = 0xb4,	/* use REPLY_RXON_TIMING structure */
+	REPLY_WIPAN_RXON_ASSOC = 0xb6,	/* use REPLY_RXON_ASSOC structure */
+	REPLY_WIPAN_QOS_PARAM = 0xb7,	/* use REPLY_QOS_PARAM structure */
+	REPLY_WIPAN_WEPKEY = 0xb8,	/* use REPLY_WEPKEY structure */
+	REPLY_WIPAN_P2P_CHANNEL_SWITCH = 0xb9,
+	REPLY_WIPAN_NOA_NOTIFICATION = 0xbc,
+
 	REPLY_MAX = 0xff
 };
 
@@ -607,6 +617,9 @@ enum {
 	RXON_DEV_TYPE_ESS = 3,
 	RXON_DEV_TYPE_IBSS = 4,
 	RXON_DEV_TYPE_SNIFFER = 6,
+	RXON_DEV_TYPE_CP = 7,
+	RXON_DEV_TYPE_2STA = 8,
+	RXON_DEV_TYPE_P2P = 9,
 };
 
 
@@ -823,7 +836,8 @@ struct iwl_rxon_time_cmd {
 	__le16 atim_window;
 	__le32 beacon_init_val;
 	__le16 listen_interval;
-	__le16 reserved;
+	u8 dtim_period;
+	u8 delta_cp_bss_tbtts;
 } __packed;
 
 /*
@@ -960,11 +974,13 @@ struct iwl_qosparam_cmd {
 
 /* Special, dedicated locations within device's station table */
 #define	IWL_AP_ID		0
+#define	IWL_AP_ID_PAN		1
 #define	IWL_STA_ID		2
 #define	IWL3945_BROADCAST_ID	24
 #define IWL3945_STATION_COUNT	25
 #define IWL4965_BROADCAST_ID	31
 #define	IWL4965_STATION_COUNT	32
+#define IWLAGN_PAN_BCAST_ID	14
 #define IWLAGN_BROADCAST_ID	15
 #define	IWLAGN_STATION_COUNT	16
 
@@ -973,6 +989,7 @@ struct iwl_qosparam_cmd {
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
 #define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8)
+#define STA_FLG_PAN_STATION		cpu_to_le32(1 << 13)
 #define STA_FLG_RTS_MIMO_PROT_MSK	cpu_to_le32(1 << 17)
 #define STA_FLG_AGG_MPDU_8US_MSK	cpu_to_le32(1 << 18)
 #define STA_FLG_MAX_AGG_SIZE_POS	(19)
@@ -4309,4 +4326,94 @@ struct iwl_rx_packet {
 
 int iwl_agn_check_rxon_cmd(struct iwl_priv *priv);
 
+/*
+ * REPLY_WIPAN_PARAMS = 0xb2 (Commands and Notification)
+ */
+
+/**
+ * struct iwl_wipan_slot
+ * @width: Time in TU
+ * @type:
+ *   0 - BSS
+ *   1 - PAN
+ */
+struct iwl_wipan_slot {
+	__le16 width;
+	u8 type;
+	u8 reserved;
+} __packed;
+
+#define IWL_WIPAN_PARAMS_FLG_LEAVE_CHANNEL_CTS		BIT(1)	/* reserved */
+#define IWL_WIPAN_PARAMS_FLG_LEAVE_CHANNEL_QUIET	BIT(2)	/* reserved */
+#define IWL_WIPAN_PARAMS_FLG_SLOTTED_MODE		BIT(3)	/* reserved */
+#define IWL_WIPAN_PARAMS_FLG_FILTER_BEACON_NOTIF	BIT(4)
+#define IWL_WIPAN_PARAMS_FLG_FULL_SLOTTED_MODE		BIT(5)
+
+/**
+ * struct iwl_wipan_params_cmd
+ * @flags:
+ *   bit0: reserved
+ *   bit1: CP leave channel with CTS
+ *   bit2: CP leave channel qith Quiet
+ *   bit3: slotted mode
+ *     1 - work in slotted mode
+ *     0 - work in non slotted mode
+ *   bit4: filter beacon notification
+ *   bit5: full tx slotted mode. if this flag is set,
+ *         uCode will perform leaving channel methods in context switch
+ *         also when working in same channel mode
+ * @num_slots: 1 - 10
+ */
+struct iwl_wipan_params_cmd {
+	__le16 flags;
+	u8 reserved;
+	u8 num_slots;
+	struct iwl_wipan_slot slots[10];
+} __packed;
+
+/*
+ * REPLY_WIPAN_P2P_CHANNEL_SWITCH = 0xb9
+ *
+ * TODO: Figure out what this is used for,
+ *	 it can only switch between 2.4 GHz
+ *	 channels!!
+ */
+
+struct iwl_wipan_p2p_channel_switch_cmd {
+	__le16 channel;
+	__le16 reserved;
+};
+
+/*
+ * REPLY_WIPAN_NOA_NOTIFICATION = 0xbc
+ *
+ * This is used by the device to notify us of the
+ * NoA schedule it determined so we can forward it
+ * to userspace for inclusion in probe responses.
+ *
+ * In beacons, the NoA schedule is simply appended
+ * to the frame we give the device.
+ */
+
+struct iwl_wipan_noa_descriptor {
+	u8 count;
+	__le32 duration;
+	__le32 interval;
+	__le32 starttime;
+} __packed;
+
+struct iwl_wipan_noa_attribute {
+	u8 id;
+	__le16 length;
+	u8 index;
+	u8 ct_window;
+	struct iwl_wipan_noa_descriptor descr0, descr1;
+	u8 reserved;
+} __packed;
+
+struct iwl_wipan_noa_notification {
+	u32 noa_active;
+	struct iwl_wipan_noa_attribute noa_attribute;
+} __packed;
+
 #endif				/* __iwl_commands_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 9fb2035..c373b53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -100,6 +100,14 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_BT_COEX_PROFILE_NOTIF);
 		IWL_CMD(REPLY_BT_COEX_PRIO_TABLE);
 		IWL_CMD(REPLY_BT_COEX_PROT_ENV);
+		IWL_CMD(REPLY_WIPAN_PARAMS);
+		IWL_CMD(REPLY_WIPAN_RXON);
+		IWL_CMD(REPLY_WIPAN_RXON_TIMING);
+		IWL_CMD(REPLY_WIPAN_RXON_ASSOC);
+		IWL_CMD(REPLY_WIPAN_QOS_PARAM);
+		IWL_CMD(REPLY_WIPAN_WEPKEY);
+		IWL_CMD(REPLY_WIPAN_P2P_CHANNEL_SWITCH);
+		IWL_CMD(REPLY_WIPAN_NOA_NOTIFICATION);
 	default:
 		return "UNKNOWN";
 
-- 
1.7.0.4

