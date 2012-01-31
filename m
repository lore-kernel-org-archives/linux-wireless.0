Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49614 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2AaJyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:54:08 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so4215776wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:54:07 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 04/10] wl12xx: fw api change - update cmd/acx/event enums
Date: Tue, 31 Jan 2012 11:57:19 +0200
Message-Id: <1328003845-3926-5-git-send-email-eliad@wizery.com> (sfid-20120131_105414_703626_431482DA)
In-Reply-To: <1328003845-3926-1-git-send-email-eliad@wizery.com>
References: <1328003845-3926-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update enums/structs to the new fw api.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: squash

 drivers/net/wireless/wl12xx/acx.h   |  137 ++++++++++++++++++-----------------
 drivers/net/wireless/wl12xx/boot.c  |    2 +-
 drivers/net/wireless/wl12xx/cmd.c   |   12 +++-
 drivers/net/wireless/wl12xx/cmd.h   |  122 +++++++++++++++++--------------
 drivers/net/wireless/wl12xx/event.h |   15 +++--
 drivers/net/wireless/wl12xx/main.c  |    2 +-
 6 files changed, 156 insertions(+), 134 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index a5bf761..0749df5 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1153,74 +1153,75 @@ struct wl12xx_acx_config_hangover {
 } __packed;
 
 enum {
-	ACX_WAKE_UP_CONDITIONS      = 0x0002,
-	ACX_MEM_CFG                 = 0x0003,
-	ACX_SLOT                    = 0x0004,
-	ACX_AC_CFG                  = 0x0007,
-	ACX_MEM_MAP                 = 0x0008,
-	ACX_AID                     = 0x000A,
-	ACX_MEDIUM_USAGE            = 0x000F,
-	ACX_TX_QUEUE_CFG            = 0x0011, /* FIXME: only used by wl1251 */
-	ACX_STATISTICS              = 0x0013, /* Debug API */
-	ACX_PWR_CONSUMPTION_STATISTICS = 0x0014,
-	ACX_FEATURE_CFG             = 0x0015,
-	ACX_TID_CFG                 = 0x001A,
-	ACX_PS_RX_STREAMING         = 0x001B,
-	ACX_BEACON_FILTER_OPT       = 0x001F,
-	ACX_NOISE_HIST              = 0x0021,
-	ACX_HDK_VERSION             = 0x0022, /* ??? */
-	ACX_PD_THRESHOLD            = 0x0023,
-	ACX_TX_CONFIG_OPT           = 0x0024,
-	ACX_CCA_THRESHOLD           = 0x0025,
-	ACX_EVENT_MBOX_MASK         = 0x0026,
-	ACX_CONN_MONIT_PARAMS       = 0x002D,
-	ACX_BCN_DTIM_OPTIONS        = 0x0031,
-	ACX_SG_ENABLE               = 0x0032,
-	ACX_SG_CFG                  = 0x0033,
-	ACX_FM_COEX_CFG             = 0x0034,
-	ACX_BEACON_FILTER_TABLE     = 0x0038,
-	ACX_ARP_IP_FILTER           = 0x0039,
-	ACX_ROAMING_STATISTICS_TBL  = 0x003B,
-	ACX_RATE_POLICY             = 0x003D,
-	ACX_CTS_PROTECTION          = 0x003E,
-	ACX_SLEEP_AUTH              = 0x003F,
-	ACX_PREAMBLE_TYPE	    = 0x0040,
-	ACX_ERROR_CNT               = 0x0041,
-	ACX_IBSS_FILTER		    = 0x0044,
-	ACX_SERVICE_PERIOD_TIMEOUT  = 0x0045,
-	ACX_TSF_INFO                = 0x0046,
-	ACX_CONFIG_PS_WMM           = 0x0049,
-	ACX_ENABLE_RX_DATA_FILTER   = 0x004A,
-	ACX_SET_RX_DATA_FILTER      = 0x004B,
-	ACX_GET_DATA_FILTER_STATISTICS = 0x004C,
-	ACX_RX_CONFIG_OPT           = 0x004E,
-	ACX_FRAG_CFG                = 0x004F,
-	ACX_BET_ENABLE              = 0x0050,
-	ACX_RSSI_SNR_TRIGGER        = 0x0051,
-	ACX_RSSI_SNR_WEIGHTS        = 0x0052,
-	ACX_KEEP_ALIVE_MODE         = 0x0053,
-	ACX_SET_KEEP_ALIVE_CONFIG   = 0x0054,
-	ACX_BA_SESSION_INIT_POLICY  = 0x0055,
-	ACX_BA_SESSION_RX_SETUP     = 0x0056,
-	ACX_PEER_HT_CAP             = 0x0057,
-	ACX_HT_BSS_OPERATION        = 0x0058,
-	ACX_COEX_ACTIVITY           = 0x0059,
-	ACX_BURST_MODE              = 0x005C,
-	ACX_SET_RATE_MGMT_PARAMS    = 0x005D,
-	ACX_SET_RATE_ADAPT_PARAMS   = 0x0060,
-	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
-	ACX_GEN_FW_CMD              = 0x0070,
-	ACX_HOST_IF_CFG_BITMAP      = 0x0071,
-	ACX_MAX_TX_FAILURE          = 0x0072,
-	ACX_UPDATE_INCONNECTION_STA_LIST = 0x0073,
-	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
-	DOT11_CUR_TX_PWR            = 0x100D,
-	DOT11_RX_DOT11_MODE         = 0x1012,
-	DOT11_RTS_THRESHOLD         = 0x1013,
-	DOT11_GROUP_ADDRESS_TBL     = 0x1014,
-	ACX_PM_CONFIG               = 0x1016,
-	ACX_CONFIG_PS               = 0x1017,
-	ACX_CONFIG_HANGOVER         = 0x1018,
+	ACX_WAKE_UP_CONDITIONS           = 0x0000,
+	ACX_MEM_CFG                      = 0x0001,
+	ACX_SLOT                         = 0x0002,
+	ACX_AC_CFG                       = 0x0003,
+	ACX_MEM_MAP                      = 0x0004,
+	ACX_AID                          = 0x0005,
+	ACX_MEDIUM_USAGE                 = 0x0006,
+	ACX_STATISTICS                   = 0x0007,
+	ACX_PWR_CONSUMPTION_STATISTICS   = 0x0008,
+	ACX_TID_CFG                      = 0x0009,
+	ACX_PS_RX_STREAMING              = 0x000A,
+	ACX_BEACON_FILTER_OPT            = 0x000B,
+	ACX_NOISE_HIST                   = 0x000C,
+	ACX_HDK_VERSION                  = 0x000D,
+	ACX_PD_THRESHOLD                 = 0x000E,
+	ACX_TX_CONFIG_OPT                = 0x000F,
+	ACX_CCA_THRESHOLD                = 0x0010,
+	ACX_EVENT_MBOX_MASK              = 0x0011,
+	ACX_CONN_MONIT_PARAMS            = 0x0012,
+	ACX_DISABLE_BROADCASTS           = 0x0013,
+	ACX_BCN_DTIM_OPTIONS             = 0x0014,
+	ACX_SG_ENABLE                    = 0x0015,
+	ACX_SG_CFG                       = 0x0016,
+	ACX_FM_COEX_CFG                  = 0x0017,
+	ACX_BEACON_FILTER_TABLE          = 0x0018,
+	ACX_ARP_IP_FILTER                = 0x0019,
+	ACX_ROAMING_STATISTICS_TBL       = 0x001A,
+	ACX_RATE_POLICY                  = 0x001B,
+	ACX_CTS_PROTECTION               = 0x001C,
+	ACX_SLEEP_AUTH                   = 0x001D,
+	ACX_PREAMBLE_TYPE                = 0x001E,
+	ACX_ERROR_CNT                    = 0x001F,
+	ACX_IBSS_FILTER                  = 0x0020,
+	ACX_SERVICE_PERIOD_TIMEOUT       = 0x0021,
+	ACX_TSF_INFO                     = 0x0022,
+	ACX_CONFIG_PS_WMM                = 0x0023,
+	ACX_ENABLE_RX_DATA_FILTER        = 0x0024,
+	ACX_SET_RX_DATA_FILTER           = 0x0025,
+	ACX_GET_DATA_FILTER_STATISTICS   = 0x0026,
+	ACX_RX_CONFIG_OPT                = 0x0027,
+	ACX_FRAG_CFG                     = 0x0028,
+	ACX_BET_ENABLE                   = 0x0029,
+	ACX_RSSI_SNR_TRIGGER             = 0x002A,
+	ACX_RSSI_SNR_WEIGHTS             = 0x002B,
+	ACX_KEEP_ALIVE_MODE              = 0x002C,
+	ACX_SET_KEEP_ALIVE_CONFIG        = 0x002D,
+	ACX_BA_SESSION_INIT_POLICY       = 0x002E,
+	ACX_BA_SESSION_RX_SETUP          = 0x002F,
+	ACX_PEER_HT_CAP                  = 0x0030,
+	ACX_HT_BSS_OPERATION             = 0x0031,
+	ACX_COEX_ACTIVITY                = 0x0032,
+	ACX_BURST_MODE                   = 0x0033,
+	ACX_SET_RATE_MGMT_PARAMS         = 0x0034,
+	ACX_GET_RATE_MGMT_PARAMS         = 0x0035,
+	ACX_SET_RATE_ADAPT_PARAMS        = 0x0036,
+	ACX_SET_DCO_ITRIM_PARAMS         = 0x0037,
+	ACX_GEN_FW_CMD                   = 0x0038,
+	ACX_HOST_IF_CFG_BITMAP           = 0x0039,
+	ACX_MAX_TX_FAILURE               = 0x003A,
+	ACX_UPDATE_INCONNECTION_STA_LIST = 0x003B,
+	DOT11_RX_MSDU_LIFE_TIME          = 0x003C,
+	DOT11_CUR_TX_PWR                 = 0x003D,
+	DOT11_RTS_THRESHOLD              = 0x003E,
+	DOT11_GROUP_ADDRESS_TBL          = 0x003F,
+	ACX_PM_CONFIG                    = 0x0040,
+	ACX_CONFIG_PS                    = 0x0041,
+	ACX_CONFIG_HANGOVER              = 0x0042,
+	ACX_FEATURE_CFG                  = 0x0043,
+	ACX_PROTECTION_CFG               = 0x0044,
 };
 
 
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 8f9cf5a..7843028 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -508,7 +508,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	wl->event_mask = BSS_LOSE_EVENT_ID |
 		SCAN_COMPLETE_EVENT_ID |
 		PS_REPORT_EVENT_ID |
-		DISCONNECT_EVENT_COMPLETE_ID |
+		ROLE_STOP_COMPLETE_EVENT_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
 		SOFT_GEMINI_SENSE_EVENT_ID |
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 10dba19..88e94c5 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -566,7 +566,7 @@ static int wl12xx_cmd_role_stop_dev(struct wl1271 *wl,
 		goto out_free;
 	}
 
-	ret = wl1271_cmd_wait_for_event(wl, DISCONNECT_EVENT_COMPLETE_ID);
+	ret = wl1271_cmd_wait_for_event(wl, ROLE_STOP_COMPLETE_EVENT_ID);
 	if (ret < 0) {
 		wl1271_error("cmd role stop dev event completion error");
 		goto out_free;
@@ -715,6 +715,8 @@ int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ap.beacon_interval = cpu_to_le16(wlvif->beacon_int);
 	cmd->ap.dtim_interval = bss_conf->dtim_period;
 	cmd->ap.beacon_expiry = WL1271_AP_DEF_BEACON_EXP;
+	/* FIXME: Change when adding DFS */
+	cmd->ap.reset_tsf = 1;  /* By default reset AP TSF */
 	cmd->channel = wlvif->channel;
 
 	if (!bss_conf->hidden_ssid) {
@@ -1756,6 +1758,7 @@ out:
 }
 
 int wl12xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch)
 {
 	struct wl12xx_cmd_channel_switch *cmd;
@@ -1769,10 +1772,13 @@ int wl12xx_cmd_channel_switch(struct wl1271 *wl,
 		goto out;
 	}
 
+	cmd->role_id = wlvif->role_id;
 	cmd->channel = ch_switch->channel->hw_value;
 	cmd->switch_time = ch_switch->count;
-	cmd->tx_suspend = ch_switch->block_tx;
-	cmd->flush = 0; /* this value is ignored by the FW */
+	cmd->stop_tx = ch_switch->block_tx;
+
+	/* FIXME: control from mac80211 in the future */
+	cmd->post_switch_tx_disable = 0;  /* Enable TX on the target channel */
 
 	ret = wl1271_cmd_send(wl, CMD_CHANNEL_SWITCH, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 8e8035d..edd240d 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -91,6 +91,7 @@ int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch);
 int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl);
 int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif,
@@ -98,62 +99,65 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid);
 
 enum wl1271_commands {
-	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
-	CMD_CONFIGURE       = 2,    /*use this to write information elements*/
-	CMD_ENABLE_RX       = 3,
-	CMD_ENABLE_TX       = 4,
-	CMD_DISABLE_RX      = 5,
-	CMD_DISABLE_TX      = 6,
-	CMD_SCAN            = 8,
-	CMD_STOP_SCAN       = 9,
-	CMD_SET_KEYS        = 12,
-	CMD_READ_MEMORY     = 13,
-	CMD_WRITE_MEMORY    = 14,
-	CMD_SET_TEMPLATE    = 19,
-	CMD_TEST            = 23,
-	CMD_NOISE_HIST      = 28,
-	CMD_QUIET_ELEMENT_SET_STATE  = 29,
-	CMD_SET_BCN_MODE    = 33,
-	CMD_MEASUREMENT      = 34,
-	CMD_STOP_MEASUREMENT = 35,
-	CMD_SET_PS_MODE      = 37,
-	CMD_CHANNEL_SWITCH   = 38,
-	CMD_STOP_CHANNEL_SWICTH = 39,
-	CMD_AP_DISCOVERY     = 40,
-	CMD_STOP_AP_DISCOVERY = 41,
-	CMD_HEALTH_CHECK     = 45,
-	CMD_DEBUG            = 46,
-	CMD_TRIGGER_SCAN_TO  = 47,
-	CMD_CONNECTION_SCAN_CFG      = 48,
-	CMD_CONNECTION_SCAN_SSID_CFG = 49,
-	CMD_START_PERIODIC_SCAN      = 50,
-	CMD_STOP_PERIODIC_SCAN       = 51,
-	CMD_SET_PEER_STATE           = 52,
-	CMD_REMAIN_ON_CHANNEL        = 53,
-	CMD_CANCEL_REMAIN_ON_CHANNEL = 54,
-
-	CMD_CONFIG_FWLOGGER          = 55,
-	CMD_START_FWLOGGER           = 56,
-	CMD_STOP_FWLOGGER            = 57,
-
-	/* AP commands */
-	CMD_ADD_PEER                 = 62,
-	CMD_REMOVE_PEER              = 63,
+	CMD_INTERROGATE	= 1, /* use this to read information elements */
+	CMD_CONFIGURE	= 2, /* use this to write information elements */
+	CMD_ENABLE_RX	= 3,
+	CMD_ENABLE_TX	= 4,
+	CMD_DISABLE_RX	= 5,
+	CMD_DISABLE_TX	= 6,
+	CMD_SCAN	= 7,
+	CMD_STOP_SCAN	= 8,
+	CMD_SET_KEYS	= 9,
+	CMD_READ_MEMORY	= 10,
+	CMD_WRITE_MEMORY	= 11,
+	CMD_SET_TEMPLATE	= 12,
+	CMD_TEST		= 13,
+	CMD_NOISE_HIST		= 14,
+	CMD_QUIET_ELEMENT_SET_STATE = 15,
+	CMD_SET_BCN_MODE	= 16,
+
+	CMD_MEASUREMENT		= 17,
+	CMD_STOP_MEASUREMENT	= 18,
+	CMD_SET_PS_MODE		= 19,
+	CMD_CHANNEL_SWITCH	= 20,
+	CMD_STOP_CHANNEL_SWICTH = 21,
+	CMD_AP_DISCOVERY	= 22,
+	CMD_STOP_AP_DISCOVERY	= 23,
+	CMD_HEALTH_CHECK	= 24,
+	CMD_DEBUG		= 25,
+	CMD_TRIGGER_SCAN_TO	= 26,
+	CMD_CONNECTION_SCAN_CFG	= 27,
+	CMD_CONNECTION_SCAN_SSID_CFG	= 28,
+	CMD_START_PERIODIC_SCAN	= 29,
+	CMD_STOP_PERIODIC_SCAN	= 30,
+	CMD_SET_PEER_STATE	= 31,
+	CMD_REMAIN_ON_CHANNEL	= 32,
+	CMD_CANCEL_REMAIN_ON_CHANNEL	= 33,
+	CMD_CONFIG_FWLOGGER		= 34,
+	CMD_START_FWLOGGER			= 35,
+	CMD_STOP_FWLOGGER			= 36,
+
+	/* Access point commands */
+	CMD_ADD_PEER		= 37,
+	CMD_REMOVE_PEER		= 38,
 
 	/* Role API */
-	CMD_ROLE_ENABLE              = 70,
-	CMD_ROLE_DISABLE             = 71,
-	CMD_ROLE_START               = 72,
-	CMD_ROLE_STOP                = 73,
+	CMD_ROLE_ENABLE		= 39,
+	CMD_ROLE_DISABLE	= 40,
+	CMD_ROLE_START		= 41,
+	CMD_ROLE_STOP		= 42,
 
-	/* WIFI Direct */
-	CMD_WFD_START_DISCOVERY      = 80,
-	CMD_WFD_STOP_DISCOVERY	     = 81,
-	CMD_WFD_ATTRIBUTE_CONFIG     = 82,
+	/* DFS */
+	CMD_START_RADAR_DETECTION	= 43,
+	CMD_STOP_RADAR_DETECTION	= 44,
 
-	CMD_NOP                      = 100,
+	/* WIFI Direct */
+	CMD_WFD_START_DISCOVERY	= 45,
+	CMD_WFD_STOP_DISCOVERY	= 46,
+	CMD_WFD_ATTRIBUTE_CONFIG	= 47,
+	CMD_NOP			= 48,
+	CMD_LAST_COMMAND,
 
-	NUM_COMMANDS,
 	MAX_COMMAND_ID = 0xFFFF,
 };
 
@@ -341,7 +345,9 @@ struct wl12xx_cmd_role_start {
 			u8 ssid_len;
 			u8 ssid[IEEE80211_MAX_SSID_LEN];
 
-			u8 padding_1[5];
+			u8 reset_tsf;
+
+			u8 padding_1[4];
 		} __packed ap;
 	};
 } __packed;
@@ -701,14 +707,18 @@ struct wl12xx_cmd_stop_fwlog {
 struct wl12xx_cmd_channel_switch {
 	struct wl1271_cmd_header header;
 
+	u8 role_id;
+
 	/* The new serving channel */
 	u8 channel;
 	/* Relative time of the serving channel switch in TBTT units */
 	u8 switch_time;
-	/* 1: Suspend TX till switch time; 0: Do not suspend TX */
-	u8 tx_suspend;
-	/* 1: Flush TX at switch time; 0: Do not flush */
-	u8 flush;
+	/* Stop the role TX, should expect it after radar detection */
+	u8 stop_tx;
+	/* The target channel tx status 1-stopped 0-open*/
+	u8 post_switch_tx_disable;
+
+	u8 padding[3];
 } __packed;
 
 struct wl12xx_cmd_stop_channel_switch {
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index 1d878ba..b41f730 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -53,8 +53,8 @@ enum {
 	AP_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(12),
 	PS_REPORT_EVENT_ID			 = BIT(13),
 	PSPOLL_DELIVERY_FAILURE_EVENT_ID	 = BIT(14),
-	DISCONNECT_EVENT_COMPLETE_ID		 = BIT(15),
-	/* BIT(16) is reserved */
+	ROLE_STOP_COMPLETE_EVENT_ID		 = BIT(15),
+	RADAR_DETECTED_EVENT_ID                  = BIT(16),
 	CHANNEL_SWITCH_COMPLETE_EVENT_ID	 = BIT(17),
 	BSS_LOSE_EVENT_ID			 = BIT(18),
 	REGAINED_BSS_EVENT_ID			 = BIT(19),
@@ -94,7 +94,7 @@ struct event_mailbox {
 	u8 soft_gemini_sense_info;
 	u8 soft_gemini_protective_info;
 	s8 rssi_snr_trigger_metric[NUM_OF_RSSI_SNR_TRIGGERS];
-	u8 channel_switch_status;
+	u8 change_auto_mode_timeout;
 	u8 scheduled_scan_status;
 	u8 ps_status;
 	/* tuned channel (roc) */
@@ -119,12 +119,17 @@ struct event_mailbox {
 	u8 rx_ba_allowed;
 	u8 reserved_6[2];
 
+	/* Channel switch results */
+
+	u8 channel_switch_role_id;
+	u8 channel_switch_status;
+	u8 reserved_7[2];
+
 	u8 ps_poll_delivery_failure_role_ids;
 	u8 stopped_role_ids;
 	u8 started_role_ids;
-	u8 change_auto_mode_timeout;
 
-	u8 reserved_7[12];
+	u8 reserved_8[9];
 } __packed;
 
 int wl1271_event_unmask(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7bbc970..85604b4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4383,7 +4383,7 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 
 	/* TODO: change mac80211 to pass vif as param */
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
-		ret = wl12xx_cmd_channel_switch(wl, ch_switch);
+		ret = wl12xx_cmd_channel_switch(wl, wlvif, ch_switch);
 
 		if (!ret)
 			set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
-- 
1.7.6.401.g6a319

