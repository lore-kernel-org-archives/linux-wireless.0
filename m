Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21564 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759854AbYEWCMF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:12:05 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH] iwlwifi-5000: implement initial calibration for 5000
Date: Fri, 23 May 2008 10:09:24 +0800
Message-Id: <1211508569-3163-47-git-send-email-yi.zhu@intel.com> (sfid-20080523_042835_310227_CE08CAC3)
In-Reply-To: <1211508569-3163-46-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-38-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-39-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-40-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-41-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-42-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-43-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-44-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-45-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-46-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds initial calibration framework for 5000 HW faimily.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |  127 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   50 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   16 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   12 +++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    4 +
 7 files changed, 211 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a94cd36..eb6141e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -395,6 +395,8 @@ static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 
 #endif /* CONFIG_IWL5000_RUN_TIME_CALIB */
 
+
+
 static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 					   size_t offset)
 {
@@ -404,6 +406,118 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 }
 
 /*
+ *  Calibration
+ */
+static int iwl5000_send_Xtal_calib(struct iwl_priv *priv)
+{
+	u16 *xtal_calib = (u16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
+
+	struct iwl5000_calibration cal_cmd = {
+		.op_code = IWL5000_PHY_CALIBRATE_CRYSTAL_FRQ_CMD,
+		.data = {
+			(u8)xtal_calib[0],
+			(u8)xtal_calib[1],
+		}
+	};
+
+	return iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+				sizeof(cal_cmd), &cal_cmd);
+}
+
+static int iwl5000_send_calib_results(struct iwl_priv *priv)
+{
+	int ret = 0;
+
+	if (priv->calib_results.lo_res)
+		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+					priv->calib_results.lo_res_len,
+					priv->calib_results.lo_res);
+	if (ret)
+		goto err;
+
+
+	if (priv->calib_results.tx_iq_res)
+		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+				priv->calib_results.tx_iq_res_len,
+				priv->calib_results.tx_iq_res);
+
+	if (ret)
+		goto err;
+
+	if (priv->calib_results.tx_iq_perd_res)
+		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+				      priv->calib_results.tx_iq_perd_res_len,
+				      priv->calib_results.tx_iq_perd_res);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	IWL_ERROR("Error %d\n", ret);
+	return ret;
+}
+
+static int iwl5000_send_calib_cfg(struct iwl_priv *priv)
+{
+	struct iwl5000_calib_cfg_cmd calib_cfg_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = CALIBRATION_CFG_CMD,
+		.len = sizeof(struct iwl5000_calib_cfg_cmd),
+		.data = &calib_cfg_cmd,
+	};
+
+	memset(&calib_cfg_cmd, 0, sizeof(calib_cfg_cmd));
+	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.once.start = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.once.send_res = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.flags = IWL_CALIB_INIT_CFG_ALL;
+
+	return iwl_send_cmd(priv, &cmd);
+}
+
+static void iwl5000_rx_calib_result(struct iwl_priv *priv,
+			     struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
+	struct iwl5000_calib_hdr *hdr = (struct iwl5000_calib_hdr *)pkt->u.raw;
+	int len = le32_to_cpu(pkt->len) & FH_RSCSR_FRAME_SIZE_MSK;
+
+	iwl_free_calib_results(priv);
+
+	/* reduce the size of the length field itself */
+	len -= 4;
+
+	switch (hdr->op_code) {
+	case IWL5000_PHY_CALIBRATE_LO_CMD:
+		priv->calib_results.lo_res = kzalloc(len, GFP_ATOMIC);
+		priv->calib_results.lo_res_len = len;
+		memcpy(priv->calib_results.lo_res, pkt->u.raw, len);
+		break;
+	case IWL5000_PHY_CALIBRATE_TX_IQ_CMD:
+		priv->calib_results.tx_iq_res = kzalloc(len, GFP_ATOMIC);
+		priv->calib_results.tx_iq_res_len = len;
+		memcpy(priv->calib_results.tx_iq_res, pkt->u.raw, len);
+		break;
+	case IWL5000_PHY_CALIBRATE_TX_IQ_PERD_CMD:
+		priv->calib_results.tx_iq_perd_res = kzalloc(len, GFP_ATOMIC);
+		priv->calib_results.tx_iq_perd_res_len = len;
+		memcpy(priv->calib_results.tx_iq_perd_res, pkt->u.raw, len);
+		break;
+	default:
+		IWL_ERROR("Unknown calibration notification %d\n",
+			  hdr->op_code);
+		return;
+	}
+}
+
+static void iwl5000_rx_calib_complete(struct iwl_priv *priv,
+			       struct iwl_rx_mem_buffer *rxb)
+{
+	IWL_DEBUG_INFO("Init. calibration is completed, restarting fw.\n");
+	queue_work(priv->workqueue, &priv->restart);
+}
+
+/*
  * ucode
  */
 static int iwl5000_load_section(struct iwl_priv *priv,
@@ -565,6 +679,7 @@ static void iwl5000_init_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
+	iwl5000_send_calib_cfg(priv);
 	return;
 
 restart:
@@ -684,8 +799,14 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+
 	iwl5000_send_wimax_coex(priv);
 
+	iwl5000_send_Xtal_calib(priv);
+
+	if (priv->ucode_type == UCODE_RT)
+		iwl5000_send_calib_results(priv);
+
 	return 0;
 }
 
@@ -856,8 +977,14 @@ static u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
 
 static void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 {
+	/* init calibration handlers */
+	priv->rx_handlers[CALIBRATION_RES_NOTIFICATION] =
+					iwl5000_rx_calib_result;
+	priv->rx_handlers[CALIBRATION_COMPLETE_NOTIFICATION] =
+					iwl5000_rx_calib_complete;
 }
 
+
 static int iwl5000_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= RTC_DATA_LOWER_BOUND) &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index a637abe..6f62beb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2778,10 +2778,59 @@ enum {
 	IWL5000_PHY_CALIBRATE_AGC_TABLE_CMD	= 14,
 	IWL5000_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
 	IWL5000_PHY_CALIBRATE_BASE_BAND_CMD	= 16,
+	IWL5000_PHY_CALIBRATE_TX_IQ_PERD_CMD	= 17,
 	IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD = 18,
 	IWL5000_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD = 19,
 };
 
+enum {
+	CALIBRATION_CFG_CMD = 0x65,
+	CALIBRATION_RES_NOTIFICATION = 0x66,
+	CALIBRATION_COMPLETE_NOTIFICATION = 0x67
+};
+
+struct iwl_cal_crystal_freq_cmd {
+	u8 cap_pin1;
+	u8 cap_pin2;
+} __attribute__ ((packed));
+
+struct iwl5000_calibration {
+	u8 op_code;
+	u8 first_group;
+	u8 num_groups;
+	u8 all_data_valid;
+	struct iwl_cal_crystal_freq_cmd data;
+} __attribute__ ((packed));
+
+#define IWL_CALIB_INIT_CFG_ALL	__constant_cpu_to_le32(0xffffffff)
+
+struct iwl_calib_cfg_elmnt_s {
+	__le32 is_enable;
+	__le32 start;
+	__le32 send_res;
+	__le32 apply_res;
+	__le32 reserved;
+} __attribute__ ((packed));
+
+struct iwl_calib_cfg_status_s {
+	struct iwl_calib_cfg_elmnt_s once;
+	struct iwl_calib_cfg_elmnt_s perd;
+	__le32 flags;
+} __attribute__ ((packed));
+
+struct iwl5000_calib_cfg_cmd {
+	struct iwl_calib_cfg_status_s ucd_calib_cfg;
+	struct iwl_calib_cfg_status_s drv_calib_cfg;
+	__le32 reserved1;
+} __attribute__ ((packed));
+
+struct iwl5000_calib_hdr {
+	u8 op_code;
+	u8 first_group;
+	u8 groups_num;
+	u8 data_valid;
+} __attribute__ ((packed));
+
 struct iwl5000_calibration_chain_noise_reset_cmd {
 	u8 op_code;	/* IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
 	u8 flags;	/* not used */
@@ -2894,6 +2943,7 @@ struct iwl_rx_packet {
 		struct iwl4965_notif_statistics stats;
 		struct iwl4965_compressed_ba_resp compressed_ba;
 		struct iwl4965_missed_beacon_notif missed_beacon;
+		struct iwl5000_calibration calib;
 		__le32 status;
 		u8 raw[0];
 	} u;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 373e984..010085a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -871,9 +871,25 @@ err:
 }
 EXPORT_SYMBOL(iwl_init_drv);
 
+void iwl_free_calib_results(struct iwl_priv *priv)
+{
+	kfree(priv->calib_results.lo_res);
+	priv->calib_results.lo_res = NULL;
+	priv->calib_results.lo_res_len = 0;
+
+	kfree(priv->calib_results.tx_iq_res);
+	priv->calib_results.tx_iq_res = NULL;
+	priv->calib_results.tx_iq_res_len = 0;
+
+	kfree(priv->calib_results.tx_iq_perd_res);
+	priv->calib_results.tx_iq_perd_res = NULL;
+	priv->calib_results.tx_iq_perd_res_len = 0;
+}
+EXPORT_SYMBOL(iwl_free_calib_results);
 
 void iwl_uninit_drv(struct iwl_priv *priv)
 {
+	iwl_free_calib_results(priv);
 	iwlcore_free_geos(priv);
 	iwl_free_channel_map(priv);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index eeea4e8..4fe7a9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -172,6 +172,7 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 void iwl_hw_detect(struct iwl_priv *priv);
 
 void iwlcore_clear_stations_table(struct iwl_priv *priv);
+void iwl_free_calib_results(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
 void iwl_set_rxon_chain(struct iwl_priv *priv);
 int iwl_set_rxon_channel(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d7bca7c..924a1f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -877,6 +877,15 @@ struct statistics_general_data {
 	u32 beacon_energy_c;
 };
 
+struct iwl_calib_results {
+	void *tx_iq_res;
+	void *tx_iq_perd_res;
+	void *lo_res;
+	u32 tx_iq_res_len;
+	u32 tx_iq_perd_res_len;
+	u32 lo_res_len;
+};
+
 enum ucode_type {
 	UCODE_NONE = 0,
 	UCODE_INIT,
@@ -984,6 +993,9 @@ struct iwl_priv {
 	s32 temperature;	/* degrees Kelvin */
 	s32 last_temperature;
 
+	/* init calibration results */
+	struct iwl_calib_results calib_results;
+
 	/* Scan related variables */
 	unsigned long last_scan_jiffies;
 	unsigned long next_scan_jiffies;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index dc1f027..d3a2a5b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -146,6 +146,7 @@ struct iwl_eeprom_channel {
 
 /*5000 calibrations */
 #define EEPROM_5000_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
+#define EEPROM_5000_XTAL	((2*0x128) | EEPROM_5000_CALIB_ALL)
 
 /* 5000 links */
 #define EEPROM_5000_LINK_HOST             (2*0x64)
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index dab4a0e..6c53736 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -56,6 +56,7 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_RATE_SCALE);
 		IWL_CMD(REPLY_LEDS_CMD);
 		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
+		IWL_CMD(COEX_PRIORITY_TABLE_CMD);
 		IWL_CMD(RADAR_NOTIFICATION);
 		IWL_CMD(REPLY_QUIET_CMD);
 		IWL_CMD(REPLY_CHANNEL_SWITCH);
@@ -89,6 +90,9 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_RX_MPDU_CMD);
 		IWL_CMD(REPLY_RX);
 		IWL_CMD(REPLY_COMPRESSED_BA);
+		IWL_CMD(CALIBRATION_CFG_CMD);
+		IWL_CMD(CALIBRATION_RES_NOTIFICATION);
+		IWL_CMD(CALIBRATION_COMPLETE_NOTIFICATION);
 	default:
 		return "UNKNOWN";
 
-- 
1.5.3.6

