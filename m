Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab1LIBZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:00 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/15] iwlwifi: minor cleanup
Date: Thu,  8 Dec 2011 16:26:11 -0800
Message-Id: <1323390382-1678-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022532_957027_DE54B462)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the defines only used by legacy devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   58 ++++++---------------------
 2 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 626ed70..63d948d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -135,8 +135,8 @@ static u16 iwlagn_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
 	struct iwl_addsta_cmd *addsta = (struct iwl_addsta_cmd *)data;
 	memcpy(addsta, cmd, size);
-	/* resrved in 5000 */
-	addsta->rate_n_flags = cpu_to_le16(0);
+	/* resrved in agn */
+	addsta->legacy_reserved = cpu_to_le16(0);
 	return size;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index d98d09c..87bfdf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -109,10 +109,10 @@ enum {
 	/* RX, TX, LEDs */
 	REPLY_TX = 0x1c,
 	REPLY_LEDS_CMD = 0x48,
-	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* for 4965 and up */
+	REPLY_TX_LINK_QUALITY_CMD = 0x4e,
 
 	/* WiMAX coexistence */
-	COEX_PRIORITY_TABLE_CMD = 0x5a,	/* for 5000 series and up */
+	COEX_PRIORITY_TABLE_CMD = 0x5a,
 	COEX_MEDIUM_NOTIFICATION = 0x5b,
 	COEX_EVENT_CMD = 0x5c,
 
@@ -935,8 +935,7 @@ struct iwl_addsta_cmd {
 	 * corresponding to bit (e.g. bit 5 controls TID 5).
 	 * Set modify_mask bit STA_MODIFY_TID_DISABLE_TX to use this field. */
 	__le16 tid_disable_tx;
-
-	__le16	rate_n_flags;		/* 3945 only */
+	__le16 legacy_reserved;
 
 	/* TID for which to add block-ack support.
 	 * Set modify_mask bit STA_MODIFY_ADDBA_TID_MSK to use this field. */
@@ -1166,8 +1165,7 @@ struct iwl_rx_mpdu_res_start {
  *
  * uCode handles retrying Tx when an ACK is expected but not received.
  * This includes trying lower data rates than the one requested in the Tx
- * command, as set up by the REPLY_RATE_SCALE (for 3945) or
- * REPLY_TX_LINK_QUALITY_CMD (agn).
+ * command, as set up by the REPLY_TX_LINK_QUALITY_CMD (agn).
  *
  * Driver sets up transmit power for various rates via REPLY_TX_PWR_TABLE_CMD.
  * This command must be executed after every RXON command, before Tx can occur.
@@ -1179,25 +1177,9 @@ struct iwl_rx_mpdu_res_start {
  * 1: Use RTS/CTS protocol or CTS-to-self if spec allows it
  * before this frame. if CTS-to-self required check
  * RXON_FLG_SELF_CTS_EN status.
- * unused in 3945/4965, used in 5000 series and after
  */
 #define TX_CMD_FLG_PROT_REQUIRE_MSK cpu_to_le32(1 << 0)
 
-/*
- * 1: Use Request-To-Send protocol before this frame.
- * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK.
- * used in 3945/4965, unused in 5000 series and after
- */
-#define TX_CMD_FLG_RTS_MSK cpu_to_le32(1 << 1)
-
-/*
- * 1: Transmit Clear-To-Send to self before this frame.
- * Driver should set this for AUTH/DEAUTH/ASSOC-REQ/REASSOC mgmnt frames.
- * Mutually exclusive vs. TX_CMD_FLG_RTS_MSK.
- * used in 3945/4965, unused in 5000 series and after
- */
-#define TX_CMD_FLG_CTS_MSK cpu_to_le32(1 << 2)
-
 /* 1: Expect ACK from receiving station
  * 0: Don't expect ACK (MAC header's duration field s/b 0)
  * Set this for unicast frames, but not broadcast/multicast. */
@@ -1215,18 +1197,8 @@ struct iwl_rx_mpdu_res_start {
  * Set when Txing a block-ack request frame.  Also set TX_CMD_FLG_ACK_MSK. */
 #define TX_CMD_FLG_IMM_BA_RSP_MASK  cpu_to_le32(1 << 6)
 
-/*
- * 1: Frame requires full Tx-Op protection.
- * Set this if either RTS or CTS Tx Flag gets set.
- * used in 3945/4965, unused in 5000 series and after
- */
-#define TX_CMD_FLG_FULL_TXOP_PROT_MSK cpu_to_le32(1 << 7)
-
-/* Tx antenna selection field; used only for 3945, reserved (0) for agn devices.
- * Set field to "0" to allow 3945 uCode to select antenna (normal usage). */
+/* Tx antenna selection field; reserved (0) for agn devices. */
 #define TX_CMD_FLG_ANT_SEL_MSK cpu_to_le32(0xf00)
-#define TX_CMD_FLG_ANT_A_MSK cpu_to_le32(1 << 8)
-#define TX_CMD_FLG_ANT_B_MSK cpu_to_le32(1 << 9)
 
 /* 1: Ignore Bluetooth priority for this frame.
  * 0: Delay Tx until Bluetooth device is done (normal usage). */
@@ -1572,7 +1544,6 @@ struct iwl_compressed_ba_resp {
 	__le64 bitmap;
 	__le16 scd_flow;
 	__le16 scd_ssn;
-	/* following only for 5000 series and up */
 	u8 txed;	/* number of frames sent */
 	u8 txed_2_done; /* number of frames acked */
 } __packed;
@@ -1674,7 +1645,7 @@ struct iwl_link_qual_agg_params {
 /*
  * REPLY_TX_LINK_QUALITY_CMD = 0x4e (command, has simple generic response)
  *
- * For agn devices only; 3945 uses REPLY_RATE_SCALE.
+ * For agn devices
  *
  * Each station in the agn device's internal station table has its own table
  * of 16
@@ -1923,7 +1894,7 @@ struct iwl_link_quality_cmd {
 /*
  * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
  *
- * 3945 and agn devices support hardware handshake with Bluetooth device on
+ * agn devices support hardware handshake with Bluetooth device on
  * same platform.  Bluetooth device alerts wireless device when it will Tx;
  * wireless device can delay or kill its own Tx to accommodate.
  */
@@ -2207,8 +2178,8 @@ struct iwl_spectrum_notification {
 
 struct iwl_powertable_cmd {
 	__le16 flags;
-	u8 keep_alive_seconds;		/* 3945 reserved */
-	u8 debug_flags;			/* 3945 reserved */
+	u8 keep_alive_seconds;
+	u8 debug_flags;
 	__le32 rx_data_timeout;
 	__le32 tx_data_timeout;
 	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
@@ -2329,9 +2300,9 @@ struct iwl_scan_channel {
 /**
  * struct iwl_ssid_ie - directed scan network information element
  *
- * Up to 20 of these may appear in REPLY_SCAN_CMD (Note: Only 4 are in
- * 3945 SCAN api), selected by "type" bit field in struct iwl_scan_channel;
- * each channel may select different ssids from among the 20 (4) entries.
+ * Up to 20 of these may appear in REPLY_SCAN_CMD,
+ * selected by "type" bit field in struct iwl_scan_channel;
+ * each channel may select different ssids from among the 20 entries.
  * SSID IEs get transmitted in reverse order of entry.
  */
 struct iwl_ssid_ie {
@@ -2340,7 +2311,6 @@ struct iwl_ssid_ie {
 	u8 ssid[32];
 } __packed;
 
-#define PROBE_OPTION_MAX_3945		4
 #define PROBE_OPTION_MAX		20
 #define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
 #define IWL_GOOD_CRC_TH_DISABLED	0
@@ -2421,8 +2391,6 @@ struct iwl_scan_cmd {
 				 * channel */
 	__le32 suspend_time;	/* pause scan this long (in "extended beacon
 				 * format") when returning to service chnl:
-				 * 3945; 31:24 # beacons, 19:0 additional usec,
-				 * 4965; 31:22 # beacons, 21:0 additional usec.
 				 */
 	__le32 flags;		/* RXON_FLG_* */
 	__le32 filter_flags;	/* RXON_FILTER_* */
@@ -2738,7 +2706,7 @@ struct statistics_div {
 
 struct statistics_general_common {
 	__le32 temperature;   /* radio temperature */
-	__le32 temperature_m; /* for 5000 and up, this is radio voltage */
+	__le32 temperature_m; /* radio voltage */
 	struct statistics_dbg dbg;
 	__le32 sleep_time;
 	__le32 slots_out;
-- 
1.7.0.4

