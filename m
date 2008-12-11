Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbYLKScp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:32:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwlwifi: remove 4965 from common uCode API structures
Date: Thu, 11 Dec 2008 10:33:40 -0800
Message-Id: <1229020421-4823-6-git-send-email-reinette.chatre@intel.com> (sfid-20081211_193252_845230_198F9026)
In-Reply-To: <1229020421-4823-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1229020421-4823-1-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-2-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-3-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-4-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes 4965 from common uCode API structures. Also updates
iwlagn commands with 3945 specific RX command in preparation for 3945 port.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |   67 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c |    2 +-
 5 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c6857dd..3680570 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -311,7 +311,7 @@ void iwl_update_chain_flags(struct iwl_priv *priv)
 
 static int iwl_send_bt_config(struct iwl_priv *priv)
 {
-	struct iwl4965_bt_cmd bt_cmd = {
+	struct iwl_bt_cmd bt_cmd = {
 		.flags = 3,
 		.lead_time = 0xAA,
 		.max_kill = 1,
@@ -320,7 +320,7 @@ static int iwl_send_bt_config(struct iwl_priv *priv)
 	};
 
 	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-				sizeof(struct iwl4965_bt_cmd), &bt_cmd);
+				sizeof(struct iwl_bt_cmd), &bt_cmd);
 }
 
 static void iwl_clear_free_frames(struct iwl_priv *priv)
@@ -858,7 +858,7 @@ static void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl_rxon_cmd *rxon = (void *)&priv->active_rxon;
-	struct iwl4965_csa_notification *csa = &(pkt->u.csa_notif);
+	struct iwl_csa_notification *csa = &(pkt->u.csa_notif);
 	IWL_DEBUG_11H("CSA notif: channel %d, status %d\n",
 		      le16_to_cpu(csa->channel), le32_to_cpu(csa->status));
 	rxon->channel = csa->channel;
@@ -870,7 +870,7 @@ static void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_sleep_notification *sleep = &(pkt->u.sleep_notif);
+	struct iwl_sleep_notification *sleep = &(pkt->u.sleep_notif);
 	IWL_DEBUG_RX("sleep mode: %d, src: %d\n",
 		     sleep->pm_sleep_mode, sleep->pm_wakeup_src);
 #endif
@@ -940,7 +940,8 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
 {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_beacon_notif *beacon = &(pkt->u.beacon_status);
+	struct iwl4965_beacon_notif *beacon =
+		(struct iwl4965_beacon_notif *)pkt->u.raw;
 	u8 rate = iwl_hw_get_rate(beacon->beacon_notify_hdr.rate_n_flags);
 
 	IWL_DEBUG_RX("beacon status %x retries %d iss %d "
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 0ba325d..60e79d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -94,6 +94,7 @@ enum {
 	REPLY_WEPKEY = 0x20,
 
 	/* RX, TX, LEDs */
+	REPLY_3945_RX = 0x1b,           /* 3945 only */
 	REPLY_TX = 0x1c,
 	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
 	REPLY_LEDS_CMD = 0x48,
@@ -701,7 +702,7 @@ struct iwl_rxon_time_cmd {
 /*
  * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
  */
-struct iwl4965_channel_switch_cmd {
+struct iwl_channel_switch_cmd {
 	u8 band;
 	u8 expect_beacon;
 	__le16 channel;
@@ -714,7 +715,7 @@ struct iwl4965_channel_switch_cmd {
 /*
  * CHANNEL_SWITCH_NOTIFICATION = 0x73 (notification only, not a command)
  */
-struct iwl4965_csa_notification {
+struct iwl_csa_notification {
 	__le16 band;
 	__le16 channel;
 	__le32 status;		/* 0 - OK, 1 - fail */
@@ -1237,7 +1238,7 @@ struct iwl4965_rx_mpdu_res_start {
  * Used for managing Tx retries when expecting block-acks.
  * Driver should set these fields to 0.
  */
-struct iwl4965_dram_scratch {
+struct iwl_dram_scratch {
 	u8 try_cnt;		/* Tx attempts */
 	u8 bt_kill_cnt;		/* Tx attempts blocked by Bluetooth device */
 	__le16 reserved;
@@ -1268,9 +1269,9 @@ struct iwl_tx_cmd {
 
 	__le32 tx_flags;	/* TX_CMD_FLG_* */
 
-	/* 4965's uCode may modify this field of the Tx command (in host DRAM!).
+	/* uCode may modify this field of the Tx command (in host DRAM!).
 	 * Driver must also set dram_lsb_ptr and dram_msb_ptr in this cmd. */
-	struct iwl4965_dram_scratch scratch;
+	struct iwl_dram_scratch scratch;
 
 	/* Rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is cleared. */
 	__le32 rate_n_flags;	/* RATE_MCS_* */
@@ -1878,7 +1879,7 @@ struct iwl_link_quality_cmd {
  * same platform.  Bluetooth device alerts wireless device when it will Tx;
  * wireless device can delay or kill its own Tx to accommodate.
  */
-struct iwl4965_bt_cmd {
+struct iwl_bt_cmd {
 	u8 flags;
 	u8 lead_time;
 	u8 max_kill;
@@ -1904,18 +1905,18 @@ struct iwl4965_bt_cmd {
 				 RXON_FILTER_ASSOC_MSK           | \
 				 RXON_FILTER_BCON_AWARE_MSK)
 
-struct iwl4965_measure_channel {
+struct iwl_measure_channel {
 	__le32 duration;	/* measurement duration in extended beacon
 				 * format */
 	u8 channel;		/* channel to measure */
-	u8 type;		/* see enum iwl4965_measure_type */
+	u8 type;		/* see enum iwl_measure_type */
 	__le16 reserved;
 } __attribute__ ((packed));
 
 /*
  * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (command)
  */
-struct iwl4965_spectrum_cmd {
+struct iwl_spectrum_cmd {
 	__le16 len;		/* number of bytes starting from token */
 	u8 token;		/* token id */
 	u8 id;			/* measurement id -- 0 or 1 */
@@ -1928,13 +1929,13 @@ struct iwl4965_spectrum_cmd {
 	__le32 filter_flags;	/* rxon filter flags */
 	__le16 channel_count;	/* minimum 1, maximum 10 */
 	__le16 reserved3;
-	struct iwl4965_measure_channel channels[10];
+	struct iwl_measure_channel channels[10];
 } __attribute__ ((packed));
 
 /*
  * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (response)
  */
-struct iwl4965_spectrum_resp {
+struct iwl_spectrum_resp {
 	u8 token;
 	u8 id;			/* id of the prior command replaced, or 0xff */
 	__le16 status;		/* 0 - command will be handled
@@ -1942,12 +1943,12 @@ struct iwl4965_spectrum_resp {
 				 *     measurement) */
 } __attribute__ ((packed));
 
-enum iwl4965_measurement_state {
+enum iwl_measurement_state {
 	IWL_MEASUREMENT_START = 0,
 	IWL_MEASUREMENT_STOP = 1,
 };
 
-enum iwl4965_measurement_status {
+enum iwl_measurement_status {
 	IWL_MEASUREMENT_OK = 0,
 	IWL_MEASUREMENT_CONCURRENT = 1,
 	IWL_MEASUREMENT_CSA_CONFLICT = 2,
@@ -1960,18 +1961,18 @@ enum iwl4965_measurement_status {
 
 #define NUM_ELEMENTS_IN_HISTOGRAM 8
 
-struct iwl4965_measurement_histogram {
+struct iwl_measurement_histogram {
 	__le32 ofdm[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 0.8usec counts */
 	__le32 cck[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 1usec counts */
 } __attribute__ ((packed));
 
 /* clear channel availability counters */
-struct iwl4965_measurement_cca_counters {
+struct iwl_measurement_cca_counters {
 	__le32 ofdm;
 	__le32 cck;
 } __attribute__ ((packed));
 
-enum iwl4965_measure_type {
+enum iwl_measure_type {
 	IWL_MEASURE_BASIC = (1 << 0),
 	IWL_MEASURE_CHANNEL_LOAD = (1 << 1),
 	IWL_MEASURE_HISTOGRAM_RPI = (1 << 2),
@@ -1984,7 +1985,7 @@ enum iwl4965_measure_type {
 /*
  * SPECTRUM_MEASURE_NOTIFICATION = 0x75 (notification only, not a command)
  */
-struct iwl4965_spectrum_notification {
+struct iwl_spectrum_notification {
 	u8 id;			/* measurement id -- 0 or 1 */
 	u8 token;
 	u8 channel_index;	/* index in measurement channel list */
@@ -1992,7 +1993,7 @@ struct iwl4965_spectrum_notification {
 	__le32 start_time;	/* lower 32-bits of TSF */
 	u8 band;		/* 0 - 5.2GHz, 1 - 2.4GHz */
 	u8 channel;
-	u8 type;		/* see enum iwl4965_measurement_type */
+	u8 type;		/* see enum iwl_measurement_type */
 	u8 reserved1;
 	/* NOTE:  cca_ofdm, cca_cck, basic_type, and histogram are only only
 	 * valid if applicable for measurement type requested. */
@@ -2002,9 +2003,9 @@ struct iwl4965_spectrum_notification {
 	u8 basic_type;		/* 0 - bss, 1 - ofdm preamble, 2 -
 				 * unidentified */
 	u8 reserved2[3];
-	struct iwl4965_measurement_histogram histogram;
+	struct iwl_measurement_histogram histogram;
 	__le32 stop_time;	/* lower 32-bits of TSF */
-	__le32 status;		/* see iwl4965_measurement_status */
+	__le32 status;		/* see iwl_measurement_status */
 } __attribute__ ((packed));
 
 /******************************************************************************
@@ -2062,7 +2063,7 @@ struct iwl_powertable_cmd {
  * PM_SLEEP_NOTIFICATION = 0x7A (notification only, not a command)
  * 3945 and 4965 identical.
  */
-struct iwl4965_sleep_notification {
+struct iwl_sleep_notification {
 	u8 pm_sleep_mode;
 	u8 pm_wakeup_src;
 	__le16 reserved;
@@ -2092,14 +2093,14 @@ enum {
 #define CARD_STATE_CMD_DISABLE 0x00	/* Put card to sleep */
 #define CARD_STATE_CMD_ENABLE  0x01	/* Wake up card */
 #define CARD_STATE_CMD_HALT    0x02	/* Power down permanently */
-struct iwl4965_card_state_cmd {
+struct iwl_card_state_cmd {
 	__le32 status;		/* CARD_STATE_CMD_* request new power state */
 } __attribute__ ((packed));
 
 /*
  * CARD_STATE_NOTIFICATION = 0xa1 (notification only, not a command)
  */
-struct iwl4965_card_state_notif {
+struct iwl_card_state_notif {
 	__le32 flags;
 } __attribute__ ((packed));
 
@@ -2162,7 +2163,7 @@ struct iwl_scan_channel {
  * struct iwl_ssid_ie - directed scan network information element
  *
  * Up to 4 of these may appear in REPLY_SCAN_CMD, selected by "type" field
- * in struct iwl4965_scan_channel; each channel may select different ssids from
+ * in struct iwl_scan_channel; each channel may select different ssids from
  * among the 4 entries.  SSID IEs get transmitted in reverse order of entry.
  */
 struct iwl_ssid_ie {
@@ -2262,7 +2263,7 @@ struct iwl_scan_cmd {
 	 * Number of channels in list is specified by channel_count.
 	 * Each channel in list is of type:
 	 *
-	 * struct iwl4965_scan_channel channels[0];
+	 * struct iwl_scan_channel channels[0];
 	 *
 	 * NOTE:  Only one band of channels can be scanned per pass.  You
 	 * must not mix 2.4GHz channels and 5.2GHz channels, and you must wait
@@ -2573,7 +2574,7 @@ struct iwl_notif_statistics {
  * then this notification will be sent. */
 #define CONSECUTIVE_MISSED_BCONS_TH 20
 
-struct iwl4965_missed_beacon_notif {
+struct iwl_missed_beacon_notif {
 	__le32 consequtive_missed_beacons;
 	__le32 total_missed_becons;
 	__le32 num_expected_beacons;
@@ -3010,19 +3011,17 @@ struct iwl_rx_packet {
 	struct iwl_cmd_header hdr;
 	union {
 		struct iwl_alive_resp alive_frame;
-		struct iwl4965_tx_resp tx_resp;
-		struct iwl4965_spectrum_notification spectrum_notif;
-		struct iwl4965_csa_notification csa_notif;
+		struct iwl_spectrum_notification spectrum_notif;
+		struct iwl_csa_notification csa_notif;
 		struct iwl_error_resp err_resp;
-		struct iwl4965_card_state_notif card_state_notif;
-		struct iwl4965_beacon_notif beacon_status;
+		struct iwl_card_state_notif card_state_notif;
 		struct iwl_add_sta_resp add_sta;
 		struct iwl_rem_sta_resp rem_sta;
-		struct iwl4965_sleep_notification sleep_notif;
-		struct iwl4965_spectrum_resp spectrum;
+		struct iwl_sleep_notification sleep_notif;
+		struct iwl_spectrum_resp spectrum;
 		struct iwl_notif_statistics stats;
 		struct iwl_compressed_ba_resp compressed_ba;
-		struct iwl4965_missed_beacon_notif missed_beacon;
+		struct iwl_missed_beacon_notif missed_beacon;
 		__le32 status;
 		u8 raw[0];
 	} u;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 664a983..eaf0c9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -780,7 +780,7 @@ struct iwl_priv {
 
 #ifdef CONFIG_IWLAGN_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
-	struct iwl4965_spectrum_notification measure_report;
+	struct iwl_spectrum_notification measure_report;
 	u8 measurement_status;
 #endif
 	/* ucode beacon time */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 0965232..53d0557 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -482,7 +482,7 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_missed_beacon_notif *missed_beacon;
+	struct iwl_missed_beacon_notif *missed_beacon;
 
 	missed_beacon = &pkt->u.missed_beacon;
 	if (le32_to_cpu(missed_beacon->consequtive_missed_beacons) > 5) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
index a9a1897..836c3c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.c
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
@@ -178,7 +178,7 @@ static void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	struct iwl4965_spectrum_notification *report = &(pkt->u.spectrum_notif);
+	struct iwl_spectrum_notification *report = &(pkt->u.spectrum_notif);
 
 	if (!report->state) {
 		IWL_DEBUG(IWL_DL_11H,
-- 
1.5.4.3

