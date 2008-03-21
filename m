Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22575 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761431AbYCUU6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 16:58:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 5/5] iwlwifi: move host command sending functions to core module
Date: Fri, 21 Mar 2008 13:53:44 -0700
Message-Id: <1206132824-20558-6-git-send-email-reinette.chatre@intel.com> (sfid-20080321_210004_115464_D6D0CDBE)
In-Reply-To: <1206132824-20558-5-git-send-email-reinette.chatre@intel.com>
References: <1206132824-20558-1-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-2-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-3-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-4-git-send-email-reinette.chatre@intel.com>
 <1206132824-20558-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

1. Host command sending functions moved from iwl4965-base.c to iwl-hcmd.c
in iwlcore module
2. enqueue_hcmd function currently stays in iwl4965-base.c. It is invoked
   through the new 'utils' field in priv's ops.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |   14 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h       |    3 -
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c       |    7 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c          |   86 ++++---
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   33 +--
 drivers/net/wireless/iwlwifi/iwl-core.h          |   26 ++
 drivers/net/wireless/iwlwifi/iwl-hcmd.c          |  251 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |  299 ++++------------------
 9 files changed, 399 insertions(+), 322 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-hcmd.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 86ac1fc..6be8012 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_IWLCORE)	+= iwlcore.o
-iwlcore-objs 		= iwl-core.o iwl-eeprom.o
+iwlcore-objs 		= iwl-core.o iwl-eeprom.o iwl-hcmd.o
 
 ifeq ($(CONFIG_IWLWIFI_DEBUGFS),y)
 	iwlcore-objs += iwl-debugfs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 1d82f10..7e36ecb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -139,7 +139,7 @@ enum {
 	REPLY_PHY_CALIBRATION_CMD = 0xb0,
 	REPLY_RX_PHY_CMD = 0xc0,
 	REPLY_RX_MPDU_CMD = 0xc1,
-	REPLY_4965_RX = 0xc3,
+	REPLY_RX = 0xc3,
 	REPLY_COMPRESSED_BA = 0xc5,
 	REPLY_MAX = 0xff
 };
@@ -151,16 +151,16 @@ enum {
  *
  *****************************************************************************/
 
-/* iwl4965_cmd_header flags value */
+/* iwl_cmd_header flags value */
 #define IWL_CMD_FAILED_MSK 0x40
 
 /**
- * struct iwl4965_cmd_header
+ * struct iwl_cmd_header
  *
  * This header format appears in the beginning of each command sent from the
  * driver, and each response/notification received from uCode.
  */
-struct iwl4965_cmd_header {
+struct iwl_cmd_header {
 	u8 cmd;		/* Command ID:  REPLY_RXON, etc. */
 	u8 flags;	/* IWL_CMD_* */
 	/*
@@ -194,7 +194,7 @@ struct iwl4965_cmd_header {
  * 4965 rate_n_flags bit fields
  *
  * rate_n_flags format is used in following 4965 commands:
- *  REPLY_4965_RX (response only)
+ *  REPLY_RX (response only)
  *  REPLY_TX (both command and response)
  *  REPLY_TX_LINK_QUALITY_CMD
  *
@@ -939,7 +939,7 @@ struct iwl4965_rx_non_cfg_phy {
 } __attribute__ ((packed));
 
 /*
- * REPLY_4965_RX = 0xc3 (response only, not a command)
+ * REPLY_RX = 0xc3 (response only, not a command)
  * Used only for legacy (non 11n) frames.
  */
 #define RX_RES_PHY_CNT 14
@@ -2664,7 +2664,7 @@ struct iwl4965_led_cmd {
 
 struct iwl4965_rx_packet {
 	__le32 len;
-	struct iwl4965_cmd_header hdr;
+	struct iwl_cmd_header hdr;
 	union {
 		struct iwl4965_alive_resp alive_frame;
 		struct iwl4965_rx_frame rx_frame;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index c66993e..1898888 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -113,9 +113,6 @@
 #define TFD_TX_CMD_SLOTS 256
 #define TFD_CMD_SLOTS 32
 
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl4965_cmd) - \
-			      sizeof(struct iwl4965_cmd_meta))
-
 /*
  * RX related structures and functions
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 02990ae..7d7ce74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -39,6 +39,7 @@
 #include "../net/mac80211/ieee80211_rate.h"
 
 #include "iwl-4965.h"
+#include "iwl-core.h"
 #include "iwl-helpers.h"
 
 #define RS_NAME "iwl-4965-rs"
@@ -230,7 +231,7 @@ static s32 expected_tpt_mimo40MHzSGI[IWL_RATE_COUNT] = {
 };
 
 static int iwl4965_lq_sync_callback(struct iwl_priv *priv,
-				struct iwl4965_cmd *cmd, struct sk_buff *skb)
+				struct iwl_cmd *cmd, struct sk_buff *skb)
 {
 	/*We didn't cache the SKB; let the caller free it */
 	return 1;
@@ -247,7 +248,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	int i;
 #endif
-	struct iwl4965_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_LINK_QUALITY_CMD,
 		.len = sizeof(struct iwl4965_link_quality_cmd),
 		.meta.flags = flags,
@@ -276,7 +277,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 
 	if (iwl4965_is_associated(priv) && priv->assoc_station_added &&
 	    priv->lq_mngr.lq_ready)
-		return  iwl4965_send_cmd(priv, &cmd);
+		return  iwl_send_cmd(priv, &cmd);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 772318c..1db873b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -869,7 +869,7 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 	u32 temp_th;
 	u32 crit_temperature;
 	unsigned long flags;
-	int rc = 0;
+	int ret = 0;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl4965_write32(priv, CSR_UCODE_DRV_GP1_CLR,
@@ -890,9 +890,9 @@ void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 
 	crit_temperature = ((temp_th * (R3-R1))/CT_LIMIT_CONST) + R2;
 	cmd.critical_temperature_R =  cpu_to_le32(crit_temperature);
-	rc = iwl4965_send_cmd_pdu(priv,
-			      REPLY_CT_KILL_CONFIG_CMD, sizeof(cmd), &cmd);
-	if (rc)
+	ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
+			       sizeof(cmd), &cmd);
+	if (ret)
 		IWL_ERROR("REPLY_CT_KILL_CONFIG_CMD failed\n");
 	else
 		IWL_DEBUG_INFO("REPLY_CT_KILL_CONFIG_CMD succeeded\n");
@@ -1165,7 +1165,7 @@ static int iwl4965_sens_auto_corr_ofdm(struct iwl_priv *priv,
 }
 
 static int iwl4965_sensitivity_callback(struct iwl_priv *priv,
-				    struct iwl4965_cmd *cmd, struct sk_buff *skb)
+				    struct iwl_cmd *cmd, struct sk_buff *skb)
 {
 	/* We didn't cache the SKB; let the caller free it */
 	return 1;
@@ -1174,15 +1174,15 @@ static int iwl4965_sensitivity_callback(struct iwl_priv *priv,
 /* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
 static int iwl4965_sensitivity_write(struct iwl_priv *priv, u8 flags)
 {
-	int rc = 0;
 	struct iwl4965_sensitivity_cmd cmd ;
 	struct iwl4965_sensitivity_data *data = NULL;
-	struct iwl4965_host_cmd cmd_out = {
+	struct iwl_host_cmd cmd_out = {
 		.id = SENSITIVITY_CMD,
 		.len = sizeof(struct iwl4965_sensitivity_cmd),
 		.meta.flags = flags,
 		.data = &cmd,
 	};
+	int ret;
 
 	data = &(priv->sensitivity_data);
 
@@ -1240,20 +1240,18 @@ static int iwl4965_sensitivity_write(struct iwl_priv *priv, u8 flags)
 	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.table[0]),
 	       sizeof(u16)*HD_TABLE_SIZE);
 
-	rc = iwl4965_send_cmd(priv, &cmd_out);
-	if (!rc) {
-		IWL_DEBUG_CALIB("SENSITIVITY_CMD succeeded\n");
-		return rc;
-	}
+	ret = iwl_send_cmd(priv, &cmd_out);
+	if (ret)
+		IWL_ERROR("SENSITIVITY_CMD failed\n");
 
-	return 0;
+	return ret;
 }
 
 void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags, u8 force)
 {
-	int rc = 0;
-	int i;
 	struct iwl4965_sensitivity_data *data = NULL;
+	int i;
+	int ret  = 0;
 
 	IWL_DEBUG_CALIB("Start iwl4965_init_sensitivity\n");
 
@@ -1297,8 +1295,8 @@ void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags, u8 force)
 		memset(&(priv->sensitivity_tbl[0]), 0,
 		    sizeof(u16)*HD_TABLE_SIZE);
 
-	rc |= iwl4965_sensitivity_write(priv, flags);
-	IWL_DEBUG_CALIB("<<return 0x%X\n", rc);
+	ret |= iwl4965_sensitivity_write(priv, flags);
+	IWL_DEBUG_CALIB("<<return 0x%X\n", ret);
 
 	return;
 }
@@ -1310,7 +1308,6 @@ void iwl4965_init_sensitivity(struct iwl_priv *priv, u8 flags, u8 force)
 void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 {
 	struct iwl4965_chain_noise_data *data = NULL;
-	int rc = 0;
 
 	data = &(priv->chain_noise_data);
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl4965_is_associated(priv)) {
@@ -1321,7 +1318,7 @@ void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 		cmd.diff_gain_a = 0;
 		cmd.diff_gain_b = 0;
 		cmd.diff_gain_c = 0;
-		rc = iwl4965_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+		iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 				 sizeof(cmd), &cmd);
 		msleep(4);
 		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
@@ -1340,7 +1337,7 @@ static void iwl4965_noise_calibration(struct iwl_priv *priv,
 				      struct iwl4965_notif_statistics *stat_resp)
 {
 	struct iwl4965_chain_noise_data *data = NULL;
-	int rc = 0;
+	int ret = 0;
 
 	u32 chain_noise_a;
 	u32 chain_noise_b;
@@ -1546,9 +1543,9 @@ static void iwl4965_noise_calibration(struct iwl_priv *priv,
 			cmd.diff_gain_a = data->delta_gain_code[0];
 			cmd.diff_gain_b = data->delta_gain_code[1];
 			cmd.diff_gain_c = data->delta_gain_code[2];
-			rc = iwl4965_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+			ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 					      sizeof(cmd), &cmd);
-			if (rc)
+			if (ret)
 				IWL_DEBUG_CALIB("fail sending cmd "
 					     "REPLY_PHY_CALIBRATION_CMD \n");
 
@@ -1572,7 +1569,6 @@ static void iwl4965_noise_calibration(struct iwl_priv *priv,
 static void iwl4965_sensitivity_calibration(struct iwl_priv *priv,
 					    struct iwl4965_notif_statistics *resp)
 {
-	int rc = 0;
 	u32 rx_enable_time;
 	u32 fa_cck;
 	u32 fa_ofdm;
@@ -1585,6 +1581,7 @@ static void iwl4965_sensitivity_calibration(struct iwl_priv *priv,
 	struct statistics_rx *statistics = &(resp->rx);
 	unsigned long flags;
 	struct statistics_general_data statis;
+	int ret;
 
 	data = &(priv->sensitivity_data);
 
@@ -1669,7 +1666,7 @@ static void iwl4965_sensitivity_calibration(struct iwl_priv *priv,
 
 	iwl4965_sens_auto_corr_ofdm(priv, norm_fa_ofdm, rx_enable_time);
 	iwl4965_sens_energy_cck(priv, norm_fa_cck, rx_enable_time, &statis);
-	rc |= iwl4965_sensitivity_write(priv, CMD_ASYNC);
+	ret = iwl4965_sensitivity_write(priv, CMD_ASYNC);
 
 	return;
 }
@@ -1797,7 +1794,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	u32 a;
 	int i = 0;
 	unsigned long flags;
-	int rc;
+	int ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -1810,10 +1807,10 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 		priv->chain_noise_data.delta_gain_code[i] =
 				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
 #endif /* CONFIG_IWL4965_SENSITIVITY*/
-	rc = iwl4965_grab_nic_access(priv);
-	if (rc) {
+	ret = iwl4965_grab_nic_access(priv);
+	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
+		return ret;
 	}
 
 	/* Clear 4965's internal Tx Scheduler data base */
@@ -1876,7 +1873,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 	iwl4965_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -2727,7 +2724,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 int iwl4965_hw_reg_send_txpower(struct iwl_priv *priv)
 {
 	struct iwl4965_txpowertable_cmd cmd = { 0 };
-	int rc = 0;
+	int ret;
 	u8 band = 0;
 	u8 is_fat = 0;
 	u8 ctrl_chan_high = 0;
@@ -2751,14 +2748,16 @@ int iwl4965_hw_reg_send_txpower(struct iwl_priv *priv)
 	cmd.band = band;
 	cmd.channel = priv->active_rxon.channel;
 
-	rc = iwl4965_fill_txpower_tbl(priv, band,
+	ret = iwl4965_fill_txpower_tbl(priv, band,
 				le16_to_cpu(priv->active_rxon.channel),
 				is_fat, ctrl_chan_high, &cmd.tx_power);
-	if (rc)
-		return rc;
+	if (ret)
+		goto out;
 
-	rc = iwl4965_send_cmd_pdu(priv, REPLY_TX_PWR_TABLE_CMD, sizeof(cmd), &cmd);
-	return rc;
+	ret = iwl_send_cmd_pdu(priv, REPLY_TX_PWR_TABLE_CMD, sizeof(cmd), &cmd);
+
+out:
+	return ret;
 }
 
 int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
@@ -2798,7 +2797,7 @@ int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 		return rc;
 	}
 
-	rc = iwl4965_send_cmd_pdu(priv, REPLY_CHANNEL_SWITCH, sizeof(cmd), &cmd);
+	rc = iwl_send_cmd_pdu(priv, REPLY_CHANNEL_SWITCH, sizeof(cmd), &cmd);
 	return rc;
 }
 
@@ -2806,7 +2805,7 @@ int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 #define RTS_DFAULT_RETRY_LIMIT		60
 
 void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-			      struct iwl4965_cmd *cmd,
+			      struct iwl_cmd *cmd,
 			      struct ieee80211_tx_control *ctrl,
 			      struct ieee80211_hdr *hdr, int sta_id,
 			      int is_hcca)
@@ -3871,7 +3870,7 @@ static inline void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 
 #define IWL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)
 
-/* Called for REPLY_4965_RX (legacy ABG frames), or
+/* Called for REPLY_RX (legacy ABG frames), or
  * REPLY_RX_MPDU_CMD (HT high-throughput N frames). */
 static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 				struct iwl4965_rx_mem_buffer *rxb)
@@ -3882,7 +3881,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	/* Use phy data (Rx signal strength, etc.) contained within
 	 *   this rx packet for legacy frames,
 	 *   or phy data cached from REPLY_RX_PHY_CMD for HT frames. */
-	int include_phy = (pkt->hdr.cmd == REPLY_4965_RX);
+	int include_phy = (pkt->hdr.cmd == REPLY_RX);
 	struct iwl4965_rx_phy_res *rx_start = (include_phy) ?
 		(struct iwl4965_rx_phy_res *)&(pkt->u.raw[0]) :
 		(struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
@@ -4570,7 +4569,7 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 	/* Update the rate scaling for control frame Tx to AP */
 	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_setting.bcast_sta_id;
 
-	iwl4965_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD, sizeof(link_cmd),
+	iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD, sizeof(link_cmd),
 			 &link_cmd);
 }
 
@@ -4923,7 +4922,7 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 void iwl4965_hw_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* Legacy Rx frames */
-	priv->rx_handlers[REPLY_4965_RX] = iwl4965_rx_reply_rx;
+	priv->rx_handlers[REPLY_RX] = iwl4965_rx_reply_rx;
 
 	/* High-throughput (HT) Rx frames */
 	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl4965_rx_reply_rx_phy;
@@ -4956,6 +4955,10 @@ void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work(&priv->init_alive_start);
 }
 
+static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
+	.enqueue_hcmd = iwl4965_enqueue_hcmd,
+};
+
 static struct iwl_lib_ops iwl4965_lib = {
 	.init_drv = iwl4965_init_drv,
 	.eeprom_ops = {
@@ -4967,6 +4970,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 
 static struct iwl_ops iwl4965_ops = {
 	.lib = &iwl4965_lib,
+	.utils = &iwl4965_hcmd_utils,
 };
 
 static struct iwl_cfg iwl4965_agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 26bd9c6..960b53b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -137,7 +137,7 @@ struct iwl4965_tx_info {
 struct iwl4965_tx_queue {
 	struct iwl4965_queue q;
 	struct iwl4965_tfd_frame *bd;
-	struct iwl4965_cmd *cmd;
+	struct iwl_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
 	struct iwl4965_tx_info *txb;
 	int need_update;
@@ -309,15 +309,15 @@ enum {
 	CMD_WANT_SKB = (1 << 2),
 };
 
-struct iwl4965_cmd;
+struct iwl_cmd;
 struct iwl_priv;
 
-struct iwl4965_cmd_meta {
-	struct iwl4965_cmd_meta *source;
+struct iwl_cmd_meta {
+	struct iwl_cmd_meta *source;
 	union {
 		struct sk_buff *skb;
 		int (*callback)(struct iwl_priv *priv,
-				struct iwl4965_cmd *cmd, struct sk_buff *skb);
+				struct iwl_cmd *cmd, struct sk_buff *skb);
 	} __attribute__ ((packed)) u;
 
 	/* The CMD_SIZE_HUGE flag bit indicates that the command
@@ -327,15 +327,15 @@ struct iwl4965_cmd_meta {
 } __attribute__ ((packed));
 
 /**
- * struct iwl4965_cmd
+ * struct iwl_cmd
  *
  * For allocation of the command and tx queues, this establishes the overall
  * size of the largest command we send to uCode, except for a scan command
  * (which is relatively huge; space is allocated separately).
  */
-struct iwl4965_cmd {
-	struct iwl4965_cmd_meta meta;	/* driver data */
-	struct iwl4965_cmd_header hdr;	/* uCode API */
+struct iwl_cmd {
+	struct iwl_cmd_meta meta;	/* driver data */
+	struct iwl_cmd_header hdr;	/* uCode API */
 	union {
 		struct iwl4965_addsta_cmd addsta;
 		struct iwl4965_led_cmd led;
@@ -355,15 +355,15 @@ struct iwl4965_cmd {
 	} __attribute__ ((packed)) cmd;
 } __attribute__ ((packed));
 
-struct iwl4965_host_cmd {
+struct iwl_host_cmd {
 	u8 id;
 	u16 len;
-	struct iwl4965_cmd_meta meta;
+	struct iwl_cmd_meta meta;
 	const void *data;
 };
 
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl4965_cmd) - \
-			      sizeof(struct iwl4965_cmd_meta))
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
+			      sizeof(struct iwl_cmd_meta))
 
 /*
  * RX related structures and functions
@@ -653,10 +653,6 @@ extern int iwl4965_tx_queue_init(struct iwl_priv *priv,
 			     struct iwl4965_tx_queue *txq, int count, u32 id);
 extern void iwl4965_rx_replenish(void *data);
 extern void iwl4965_tx_queue_free(struct iwl_priv *priv, struct iwl4965_tx_queue *txq);
-extern int iwl4965_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
-			    const void *data);
-extern int __must_check iwl4965_send_cmd(struct iwl_priv *priv,
-		struct iwl4965_host_cmd *cmd);
 extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,
 					const u8 *dest, int left);
@@ -671,6 +667,7 @@ int iwl4965_init_geos(struct iwl_priv *priv);
 void iwl4965_free_geos(struct iwl_priv *priv);
 
 extern const u8 iwl4965_broadcast_addr[ETH_ALEN];
+int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
 /*
  * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
@@ -715,7 +712,7 @@ extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl4965_frame *frame, u8 rate);
 extern int iwl4965_hw_get_rx_read(struct iwl_priv *priv);
 extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-				     struct iwl4965_cmd *cmd,
+				     struct iwl_cmd *cmd,
 				     struct ieee80211_tx_control *ctrl,
 				     struct ieee80211_hdr *hdr,
 				     int sta_id, int tx_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4dde4d6..ce7f90e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -63,6 +63,13 @@
 #ifndef __iwl_core_h__
 #define __iwl_core_h__
 
+/************************
+ * forward declarations *
+ ************************/
+struct iwl_host_cmd;
+struct iwl_cmd;
+
+
 #define IWLWIFI_VERSION "1.2.26k"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2008 Intel Corporation"
 
@@ -75,6 +82,10 @@
 #define IWL_SKU_A       0x2
 #define IWL_SKU_N       0x8
 
+struct iwl_hcmd_utils_ops {
+	int (*enqueue_hcmd)(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+};
+
 struct iwl_lib_ops {
 	/* iwlwifi driver (priv) init */
 	int (*init_drv)(struct iwl_priv *priv);
@@ -84,6 +95,7 @@ struct iwl_lib_ops {
 
 struct iwl_ops {
 	const struct iwl_lib_ops *lib;
+	const struct iwl_hcmd_utils_ops *utils;
 };
 
 struct iwl_mod_params {
@@ -120,4 +132,18 @@ int iwlcore_set_rxon_channel(struct iwl_priv *priv,
 
 int iwl_setup(struct iwl_priv *priv);
 
+/*****************************************************
+ *   S e n d i n g     H o s t     C o m m a n d s   *
+ *****************************************************/
+
+const char *get_cmd_string(u8 cmd);
+int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data);
+int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
+			   const void *data,
+			   int (*callback)(struct iwl_priv *priv,
+					   struct iwl_cmd *cmd,
+					   struct sk_buff *skb));
+
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
new file mode 100644
index 0000000..559ff73
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -0,0 +1,251 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <net/mac80211.h>
+
+#include "iwl-4965.h" /* FIXME: remove */
+#include "iwl-debug.h"
+#include "iwl-eeprom.h"
+#include "iwl-core.h"
+
+
+#define IWL_CMD(x) case x : return #x
+
+const char *get_cmd_string(u8 cmd)
+{
+	switch (cmd) {
+		IWL_CMD(REPLY_ALIVE);
+		IWL_CMD(REPLY_ERROR);
+		IWL_CMD(REPLY_RXON);
+		IWL_CMD(REPLY_RXON_ASSOC);
+		IWL_CMD(REPLY_QOS_PARAM);
+		IWL_CMD(REPLY_RXON_TIMING);
+		IWL_CMD(REPLY_ADD_STA);
+		IWL_CMD(REPLY_REMOVE_STA);
+		IWL_CMD(REPLY_REMOVE_ALL_STA);
+		IWL_CMD(REPLY_TX);
+		IWL_CMD(REPLY_RATE_SCALE);
+		IWL_CMD(REPLY_LEDS_CMD);
+		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
+		IWL_CMD(RADAR_NOTIFICATION);
+		IWL_CMD(REPLY_QUIET_CMD);
+		IWL_CMD(REPLY_CHANNEL_SWITCH);
+		IWL_CMD(CHANNEL_SWITCH_NOTIFICATION);
+		IWL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
+		IWL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
+		IWL_CMD(POWER_TABLE_CMD);
+		IWL_CMD(PM_SLEEP_NOTIFICATION);
+		IWL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
+		IWL_CMD(REPLY_SCAN_CMD);
+		IWL_CMD(REPLY_SCAN_ABORT_CMD);
+		IWL_CMD(SCAN_START_NOTIFICATION);
+		IWL_CMD(SCAN_RESULTS_NOTIFICATION);
+		IWL_CMD(SCAN_COMPLETE_NOTIFICATION);
+		IWL_CMD(BEACON_NOTIFICATION);
+		IWL_CMD(REPLY_TX_BEACON);
+		IWL_CMD(WHO_IS_AWAKE_NOTIFICATION);
+		IWL_CMD(QUIET_NOTIFICATION);
+		IWL_CMD(REPLY_TX_PWR_TABLE_CMD);
+		IWL_CMD(MEASURE_ABORT_NOTIFICATION);
+		IWL_CMD(REPLY_BT_CONFIG);
+		IWL_CMD(REPLY_STATISTICS_CMD);
+		IWL_CMD(STATISTICS_NOTIFICATION);
+		IWL_CMD(REPLY_CARD_STATE_CMD);
+		IWL_CMD(CARD_STATE_NOTIFICATION);
+		IWL_CMD(MISSED_BEACONS_NOTIFICATION);
+		IWL_CMD(REPLY_CT_KILL_CONFIG_CMD);
+		IWL_CMD(SENSITIVITY_CMD);
+		IWL_CMD(REPLY_PHY_CALIBRATION_CMD);
+		IWL_CMD(REPLY_RX_PHY_CMD);
+		IWL_CMD(REPLY_RX_MPDU_CMD);
+		IWL_CMD(REPLY_RX);
+		IWL_CMD(REPLY_COMPRESSED_BA);
+	default:
+		return "UNKNOWN";
+
+	}
+}
+EXPORT_SYMBOL(get_cmd_string);
+
+#define HOST_COMPLETE_TIMEOUT (HZ / 2)
+
+static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+{
+	int ret;
+
+	BUG_ON(!(cmd->meta.flags & CMD_ASYNC));
+
+	/* An asynchronous command can not expect an SKB to be set. */
+	BUG_ON(cmd->meta.flags & CMD_WANT_SKB);
+
+	/* An asynchronous command MUST have a callback. */
+	BUG_ON(!cmd->meta.u.callback);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return -EBUSY;
+
+	ret = priv->cfg->ops->utils->enqueue_hcmd(priv, cmd);
+	if (ret < 0) {
+		IWL_ERROR("Error sending %s: enqueue_hcmd failed: %d\n",
+			  get_cmd_string(cmd->id), ret);
+		return ret;
+	}
+	return 0;
+}
+
+int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+{
+	int cmd_idx;
+	int ret;
+	static atomic_t entry = ATOMIC_INIT(0); /* reentrance protection */
+
+	BUG_ON(cmd->meta.flags & CMD_ASYNC);
+
+	 /* A synchronous command can not have a callback set. */
+	BUG_ON(cmd->meta.u.callback != NULL);
+
+	if (atomic_xchg(&entry, 1)) {
+		IWL_ERROR("Error sending %s: Already sending a host command\n",
+			  get_cmd_string(cmd->id));
+		return -EBUSY;
+	}
+
+	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
+
+	if (cmd->meta.flags & CMD_WANT_SKB)
+		cmd->meta.source = &cmd->meta;
+
+	cmd_idx = priv->cfg->ops->utils->enqueue_hcmd(priv, cmd);
+	if (cmd_idx < 0) {
+		ret = cmd_idx;
+		IWL_ERROR("Error sending %s: enqueue_hcmd failed: %d\n",
+			  get_cmd_string(cmd->id), ret);
+		goto out;
+	}
+
+	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+			!test_bit(STATUS_HCMD_ACTIVE, &priv->status),
+			HOST_COMPLETE_TIMEOUT);
+	if (!ret) {
+		if (test_bit(STATUS_HCMD_ACTIVE, &priv->status)) {
+			IWL_ERROR("Error sending %s: time out after %dms.\n",
+				  get_cmd_string(cmd->id),
+				  jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
+
+			clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+			ret = -ETIMEDOUT;
+			goto cancel;
+		}
+	}
+
+	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
+		IWL_DEBUG_INFO("Command %s aborted: RF KILL Switch\n",
+			       get_cmd_string(cmd->id));
+		ret = -ECANCELED;
+		goto fail;
+	}
+	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
+		IWL_DEBUG_INFO("Command %s failed: FW Error\n",
+			       get_cmd_string(cmd->id));
+		ret = -EIO;
+		goto fail;
+	}
+	if ((cmd->meta.flags & CMD_WANT_SKB) && !cmd->meta.u.skb) {
+		IWL_ERROR("Error: Response NULL in '%s'\n",
+			  get_cmd_string(cmd->id));
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = 0;
+	goto out;
+
+cancel:
+	if (cmd->meta.flags & CMD_WANT_SKB) {
+		struct iwl_cmd *qcmd;
+
+		/* Cancel the CMD_WANT_SKB flag for the cmd in the
+		 * TX cmd queue. Otherwise in case the cmd comes
+		 * in later, it will possibly set an invalid
+		 * address (cmd->meta.source). */
+		qcmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
+		qcmd->meta.flags &= ~CMD_WANT_SKB;
+	}
+fail:
+	if (cmd->meta.u.skb) {
+		dev_kfree_skb_any(cmd->meta.u.skb);
+		cmd->meta.u.skb = NULL;
+	}
+out:
+	atomic_set(&entry, 0);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_send_cmd_sync);
+
+int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
+{
+	if (cmd->meta.flags & CMD_ASYNC)
+		return iwl_send_cmd_async(priv, cmd);
+
+	return iwl_send_cmd_sync(priv, cmd);
+}
+EXPORT_SYMBOL(iwl_send_cmd);
+
+int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
+{
+	struct iwl_host_cmd cmd = {
+		.id = id,
+		.len = len,
+		.data = data,
+	};
+
+	return iwl_send_cmd_sync(priv, &cmd);
+}
+EXPORT_SYMBOL(iwl_send_cmd_pdu);
+
+int iwl_send_cmd_pdu_async(struct iwl_priv *priv,
+			   u8 id, u16 len, const void *data,
+			   int (*callback)(struct iwl_priv *priv,
+					   struct iwl_cmd *cmd,
+					   struct sk_buff *skb))
+{
+	struct iwl_host_cmd cmd = {
+		.id = id,
+		.len = len,
+		.data = data,
+	};
+
+	cmd.meta.flags |= CMD_ASYNC;
+	cmd.meta.u.callback = callback;
+
+	return iwl_send_cmd_async(priv, &cmd);
+}
+EXPORT_SYMBOL(iwl_send_cmd_pdu_async);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 93ed61d..5383a89 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -297,7 +297,7 @@ int iwl4965_tx_queue_init(struct iwl_priv *priv,
 	 * For normal Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
-	len = sizeof(struct iwl4965_cmd) * slots_num;
+	len = sizeof(struct iwl_cmd) * slots_num;
 	if (txq_id == IWL_CMD_QUEUE_NUM)
 		len +=  IWL_MAX_SCAN_SIZE;
 	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
@@ -348,7 +348,7 @@ void iwl4965_tx_queue_free(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
 		iwl4965_hw_txq_free_tfd(priv, txq);
 
-	len = sizeof(struct iwl4965_cmd) * q->n_window;
+	len = sizeof(struct iwl_cmd) * q->n_window;
 	if (q->id == IWL_CMD_QUEUE_NUM)
 		len += IWL_MAX_SCAN_SIZE;
 
@@ -533,65 +533,6 @@ static inline int iwl4965_is_ready_rf(struct iwl_priv *priv)
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
-#define IWL_CMD(x) case x : return #x
-
-static const char *get_cmd_string(u8 cmd)
-{
-	switch (cmd) {
-		IWL_CMD(REPLY_ALIVE);
-		IWL_CMD(REPLY_ERROR);
-		IWL_CMD(REPLY_RXON);
-		IWL_CMD(REPLY_RXON_ASSOC);
-		IWL_CMD(REPLY_QOS_PARAM);
-		IWL_CMD(REPLY_RXON_TIMING);
-		IWL_CMD(REPLY_ADD_STA);
-		IWL_CMD(REPLY_REMOVE_STA);
-		IWL_CMD(REPLY_REMOVE_ALL_STA);
-		IWL_CMD(REPLY_TX);
-		IWL_CMD(REPLY_RATE_SCALE);
-		IWL_CMD(REPLY_LEDS_CMD);
-		IWL_CMD(REPLY_TX_LINK_QUALITY_CMD);
-		IWL_CMD(RADAR_NOTIFICATION);
-		IWL_CMD(REPLY_QUIET_CMD);
-		IWL_CMD(REPLY_CHANNEL_SWITCH);
-		IWL_CMD(CHANNEL_SWITCH_NOTIFICATION);
-		IWL_CMD(REPLY_SPECTRUM_MEASUREMENT_CMD);
-		IWL_CMD(SPECTRUM_MEASURE_NOTIFICATION);
-		IWL_CMD(POWER_TABLE_CMD);
-		IWL_CMD(PM_SLEEP_NOTIFICATION);
-		IWL_CMD(PM_DEBUG_STATISTIC_NOTIFIC);
-		IWL_CMD(REPLY_SCAN_CMD);
-		IWL_CMD(REPLY_SCAN_ABORT_CMD);
-		IWL_CMD(SCAN_START_NOTIFICATION);
-		IWL_CMD(SCAN_RESULTS_NOTIFICATION);
-		IWL_CMD(SCAN_COMPLETE_NOTIFICATION);
-		IWL_CMD(BEACON_NOTIFICATION);
-		IWL_CMD(REPLY_TX_BEACON);
-		IWL_CMD(WHO_IS_AWAKE_NOTIFICATION);
-		IWL_CMD(QUIET_NOTIFICATION);
-		IWL_CMD(REPLY_TX_PWR_TABLE_CMD);
-		IWL_CMD(MEASURE_ABORT_NOTIFICATION);
-		IWL_CMD(REPLY_BT_CONFIG);
-		IWL_CMD(REPLY_STATISTICS_CMD);
-		IWL_CMD(STATISTICS_NOTIFICATION);
-		IWL_CMD(REPLY_CARD_STATE_CMD);
-		IWL_CMD(CARD_STATE_NOTIFICATION);
-		IWL_CMD(MISSED_BEACONS_NOTIFICATION);
-		IWL_CMD(REPLY_CT_KILL_CONFIG_CMD);
-		IWL_CMD(SENSITIVITY_CMD);
-		IWL_CMD(REPLY_PHY_CALIBRATION_CMD);
-		IWL_CMD(REPLY_RX_PHY_CMD);
-		IWL_CMD(REPLY_RX_MPDU_CMD);
-		IWL_CMD(REPLY_4965_RX);
-		IWL_CMD(REPLY_COMPRESSED_BA);
-	default:
-		return "UNKNOWN";
-
-	}
-}
-
-#define HOST_COMPLETE_TIMEOUT (HZ / 2)
-
 /**
  * iwl4965_enqueue_hcmd - enqueue a uCode command
  * @priv: device private data point
@@ -601,13 +542,13 @@ static const char *get_cmd_string(u8 cmd)
  * failed. On success, it turns the index (> 0) of command in the
  * command queue.
  */
-static int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
+int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl4965_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl4965_queue *q = &txq->q;
 	struct iwl4965_tfd_frame *tfd;
 	u32 *control_flags;
-	struct iwl4965_cmd *out_cmd;
+	struct iwl_cmd *out_cmd;
 	u32 idx;
 	u16 fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
 	dma_addr_t phys_addr;
@@ -654,7 +595,7 @@ static int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl4965_host_cmd *
 		out_cmd->hdr.sequence |= cpu_to_le16(SEQ_HUGE_FRAME);
 
 	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
-			offsetof(struct iwl4965_cmd, hdr);
+			offsetof(struct iwl_cmd, hdr);
 	iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
@@ -676,118 +617,6 @@ static int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl4965_host_cmd *
 	return ret ? ret : idx;
 }
 
-static int iwl4965_send_cmd_async(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
-{
-	int ret;
-
-	BUG_ON(!(cmd->meta.flags & CMD_ASYNC));
-
-	/* An asynchronous command can not expect an SKB to be set. */
-	BUG_ON(cmd->meta.flags & CMD_WANT_SKB);
-
-	/* An asynchronous command MUST have a callback. */
-	BUG_ON(!cmd->meta.u.callback);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return -EBUSY;
-
-	ret = iwl4965_enqueue_hcmd(priv, cmd);
-	if (ret < 0) {
-		IWL_ERROR("Error sending %s: iwl4965_enqueue_hcmd failed: %d\n",
-			  get_cmd_string(cmd->id), ret);
-		return ret;
-	}
-	return 0;
-}
-
-static int iwl4965_send_cmd_sync(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
-{
-	int cmd_idx;
-	int ret;
-	static atomic_t entry = ATOMIC_INIT(0); /* reentrance protection */
-
-	BUG_ON(cmd->meta.flags & CMD_ASYNC);
-
-	 /* A synchronous command can not have a callback set. */
-	BUG_ON(cmd->meta.u.callback != NULL);
-
-	if (atomic_xchg(&entry, 1)) {
-		IWL_ERROR("Error sending %s: Already sending a host command\n",
-			  get_cmd_string(cmd->id));
-		return -EBUSY;
-	}
-
-	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
-
-	if (cmd->meta.flags & CMD_WANT_SKB)
-		cmd->meta.source = &cmd->meta;
-
-	cmd_idx = iwl4965_enqueue_hcmd(priv, cmd);
-	if (cmd_idx < 0) {
-		ret = cmd_idx;
-		IWL_ERROR("Error sending %s: iwl4965_enqueue_hcmd failed: %d\n",
-			  get_cmd_string(cmd->id), ret);
-		goto out;
-	}
-
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-			!test_bit(STATUS_HCMD_ACTIVE, &priv->status),
-			HOST_COMPLETE_TIMEOUT);
-	if (!ret) {
-		if (test_bit(STATUS_HCMD_ACTIVE, &priv->status)) {
-			IWL_ERROR("Error sending %s: time out after %dms.\n",
-				  get_cmd_string(cmd->id),
-				  jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
-
-			clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-			ret = -ETIMEDOUT;
-			goto cancel;
-		}
-	}
-
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_INFO("Command %s aborted: RF KILL Switch\n",
-			       get_cmd_string(cmd->id));
-		ret = -ECANCELED;
-		goto fail;
-	}
-	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
-		IWL_DEBUG_INFO("Command %s failed: FW Error\n",
-			       get_cmd_string(cmd->id));
-		ret = -EIO;
-		goto fail;
-	}
-	if ((cmd->meta.flags & CMD_WANT_SKB) && !cmd->meta.u.skb) {
-		IWL_ERROR("Error: Response NULL in '%s'\n",
-			  get_cmd_string(cmd->id));
-		ret = -EIO;
-		goto out;
-	}
-
-	ret = 0;
-	goto out;
-
-cancel:
-	if (cmd->meta.flags & CMD_WANT_SKB) {
-		struct iwl4965_cmd *qcmd;
-
-		/* Cancel the CMD_WANT_SKB flag for the cmd in the
-		 * TX cmd queue. Otherwise in case the cmd comes
-		 * in later, it will possibly set an invalid
-		 * address (cmd->meta.source). */
-		qcmd = &priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
-		qcmd->meta.flags &= ~CMD_WANT_SKB;
-	}
-fail:
-	if (cmd->meta.u.skb) {
-		dev_kfree_skb_any(cmd->meta.u.skb);
-		cmd->meta.u.skb = NULL;
-	}
-out:
-	atomic_set(&entry, 0);
-	return ret;
-}
-
 static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 {
 	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
@@ -799,39 +628,11 @@ static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 
 }
 
-int iwl4965_send_cmd(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
-{
-	if (cmd->meta.flags & CMD_ASYNC)
-		return iwl4965_send_cmd_async(priv, cmd);
-
-	return iwl4965_send_cmd_sync(priv, cmd);
-}
-
-int iwl4965_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
-{
-	struct iwl4965_host_cmd cmd = {
-		.id = id,
-		.len = len,
-		.data = data,
-	};
-
-	return iwl4965_send_cmd_sync(priv, &cmd);
-}
-
-static int __must_check iwl4965_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
-{
-	struct iwl4965_host_cmd cmd = {
-		.id = id,
-		.len = sizeof(val),
-		.data = &val,
-	};
-
-	return iwl4965_send_cmd_sync(priv, &cmd);
-}
-
 int iwl4965_send_statistics_request(struct iwl_priv *priv)
 {
-	return iwl4965_send_cmd_u32(priv, REPLY_STATISTICS_CMD, 0);
+	u32 flags = 0;
+	return iwl_send_cmd_pdu(priv, REPLY_STATISTICS_CMD,
+				      sizeof(flags), &flags);
 }
 
 /**
@@ -992,7 +793,7 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 	int rc = 0;
 	struct iwl4965_rx_packet *res = NULL;
 	struct iwl4965_rxon_assoc_cmd rxon_assoc;
-	struct iwl4965_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_RXON_ASSOC,
 		.len = sizeof(rxon_assoc),
 		.meta.flags = CMD_WANT_SKB,
@@ -1025,7 +826,7 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
 	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
 
-	rc = iwl4965_send_cmd_sync(priv, &cmd);
+	rc = iwl_send_cmd_sync(priv, &cmd);
 	if (rc)
 		return rc;
 
@@ -1104,7 +905,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
-		rc = iwl4965_send_cmd_pdu(priv, REPLY_RXON,
+		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 				      sizeof(struct iwl4965_rxon_cmd),
 				      &priv->active_rxon);
 
@@ -1129,7 +930,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 
 	iwl4965_set_rxon_hwcrypto(priv, priv->cfg->mod_params->hw_crypto);
 	/* Apply the new configuration */
-	rc = iwl4965_send_cmd_pdu(priv, REPLY_RXON,
+	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl4965_rxon_cmd), &priv->staging_rxon);
 	if (rc) {
 		IWL_ERROR("Error setting new configuration (%d).\n", rc);
@@ -1188,7 +989,7 @@ static int iwl4965_send_bt_config(struct iwl_priv *priv)
 		.kill_cts_mask = 0,
 	};
 
-	return iwl4965_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 				sizeof(struct iwl4965_bt_cmd), &bt_cmd);
 }
 
@@ -1196,7 +997,7 @@ static int iwl4965_send_scan_abort(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct iwl4965_rx_packet *res;
-	struct iwl4965_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.meta.flags = CMD_WANT_SKB,
 	};
@@ -1209,7 +1010,7 @@ static int iwl4965_send_scan_abort(struct iwl_priv *priv)
 		return 0;
 	}
 
-	rc = iwl4965_send_cmd_sync(priv, &cmd);
+	rc = iwl_send_cmd_sync(priv, &cmd);
 	if (rc) {
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 		return rc;
@@ -1234,7 +1035,7 @@ static int iwl4965_send_scan_abort(struct iwl_priv *priv)
 }
 
 static int iwl4965_card_state_sync_callback(struct iwl_priv *priv,
-					struct iwl4965_cmd *cmd,
+					struct iwl_cmd *cmd,
 					struct sk_buff *skb)
 {
 	return 1;
@@ -1252,7 +1053,7 @@ static int iwl4965_card_state_sync_callback(struct iwl_priv *priv,
  */
 static int iwl4965_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
 {
-	struct iwl4965_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_CARD_STATE_CMD,
 		.len = sizeof(u32),
 		.data = &flags,
@@ -1262,11 +1063,11 @@ static int iwl4965_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_fla
 	if (meta_flag & CMD_ASYNC)
 		cmd.meta.u.callback = iwl4965_card_state_sync_callback;
 
-	return iwl4965_send_cmd(priv, &cmd);
+	return iwl_send_cmd(priv, &cmd);
 }
 
 static int iwl4965_add_sta_sync_callback(struct iwl_priv *priv,
-				     struct iwl4965_cmd *cmd, struct sk_buff *skb)
+				     struct iwl_cmd *cmd, struct sk_buff *skb)
 {
 	struct iwl4965_rx_packet *res = NULL;
 
@@ -1298,7 +1099,7 @@ int iwl4965_send_add_station(struct iwl_priv *priv,
 {
 	struct iwl4965_rx_packet *res = NULL;
 	int rc = 0;
-	struct iwl4965_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
 		.len = sizeof(struct iwl4965_addsta_cmd),
 		.meta.flags = flags,
@@ -1310,7 +1111,7 @@ int iwl4965_send_add_station(struct iwl_priv *priv,
 	else
 		cmd.meta.flags |= CMD_WANT_SKB;
 
-	rc = iwl4965_send_cmd(priv, &cmd);
+	rc = iwl_send_cmd(priv, &cmd);
 
 	if (rc || (flags & CMD_ASYNC))
 		return rc;
@@ -1571,7 +1372,7 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
 
 	frame_size = iwl4965_hw_get_beacon_cmd(priv, frame, rate);
 
-	rc = iwl4965_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
+	rc = iwl_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
 			      &frame->u.cmd[0]);
 
 	iwl4965_free_frame(priv, frame);
@@ -1748,7 +1549,7 @@ static int iwl4965_send_qos_params_command(struct iwl_priv *priv,
 				       struct iwl4965_qosparam_cmd *qos)
 {
 
-	return iwl4965_send_cmd_pdu(priv, REPLY_QOS_PARAM,
+	return iwl_send_cmd_pdu(priv, REPLY_QOS_PARAM,
 				sizeof(struct iwl4965_qosparam_cmd), qos);
 }
 
@@ -1958,7 +1759,7 @@ static int iwl4965_send_power_mode(struct iwl_priv *priv, u32 mode)
 
 	iwl4965_update_power_cmd(priv, &cmd, final_mode);
 
-	rc = iwl4965_send_cmd_pdu(priv, POWER_TABLE_CMD, sizeof(cmd), &cmd);
+	rc = iwl_send_cmd_pdu(priv, POWER_TABLE_CMD, sizeof(cmd), &cmd);
 
 	if (final_mode == IWL_POWER_MODE_CAM)
 		clear_bit(STATUS_POWER_PMI, &priv->status);
@@ -2337,7 +2138,7 @@ static int iwl4965_set_mode(struct iwl_priv *priv, int mode)
 
 static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_control *ctl,
-				      struct iwl4965_cmd *cmd,
+				      struct iwl_cmd *cmd,
 				      struct sk_buff *skb_frag,
 				      int sta_id)
 {
@@ -2382,7 +2183,7 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
  * handle build REPLY_TX command notification.
  */
 static void iwl4965_build_tx_cmd_basic(struct iwl_priv *priv,
-				  struct iwl4965_cmd *cmd,
+				  struct iwl_cmd *cmd,
 				  struct ieee80211_tx_control *ctrl,
 				  struct ieee80211_hdr *hdr,
 				  int is_unicast, u8 std_id)
@@ -2523,7 +2324,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
-	struct iwl4965_cmd *out_cmd = NULL;
+	struct iwl_cmd *out_cmd = NULL;
 	u16 len, idx, len_org;
 	u8 id, hdr_len, unicast;
 	u8 sta_id;
@@ -2652,7 +2453,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	 * We'll tell device about this padding later.
 	 */
 	len = priv->hw_setting.tx_cmd_len +
-		sizeof(struct iwl4965_cmd_header) + hdr_len;
+		sizeof(struct iwl_cmd_header) + hdr_len;
 
 	len_org = len;
 	len = (len + 3) & ~3;
@@ -2664,8 +2465,8 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl4965_cmd) * idx +
-		     offsetof(struct iwl4965_cmd, hdr);
+	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
+		     offsetof(struct iwl_cmd, hdr);
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
@@ -2699,7 +2500,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 
 	iwl_update_tx_stats(priv, fc, len);
 
-	scratch_phys = txcmd_phys + sizeof(struct iwl4965_cmd_header) +
+	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 		offsetof(struct iwl4965_tx_cmd, scratch);
 	out_cmd->cmd.tx.dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	out_cmd->cmd.tx.dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
@@ -3012,7 +2813,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 {
 	struct iwl4965_spectrum_cmd spectrum;
 	struct iwl4965_rx_packet *res;
-	struct iwl4965_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
 		.meta.flags = CMD_WANT_SKB,
@@ -3052,7 +2853,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 		spectrum.flags |= RXON_FLG_BAND_24G_MSK |
 		    RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK;
 
-	rc = iwl4965_send_cmd_sync(priv, &cmd);
+	rc = iwl_send_cmd_sync(priv, &cmd);
 	if (rc)
 		return rc;
 
@@ -3827,7 +3628,7 @@ static void iwl4965_tx_cmd_complete(struct iwl_priv *priv,
 	int index = SEQ_TO_INDEX(sequence);
 	int huge = sequence & SEQ_HUGE_FRAME;
 	int cmd_index;
-	struct iwl4965_cmd *cmd;
+	struct iwl_cmd *cmd;
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
@@ -4329,7 +4130,7 @@ static void iwl4965_rx_handle(struct iwl_priv *priv)
 		 *   but apparently a few don't get set; catch them here. */
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
 			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
-			(pkt->hdr.cmd != REPLY_4965_RX) &&
+			(pkt->hdr.cmd != REPLY_RX) &&
 			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
 			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
@@ -4352,7 +4153,7 @@ static void iwl4965_rx_handle(struct iwl_priv *priv)
 
 		if (reclaim) {
 			/* Invoke any callbacks, transfer the skb to caller, and
-			 * fire off the (possibly) blocking iwl4965_send_cmd()
+			 * fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
 				iwl4965_tx_cmd_complete(priv, rxb);
@@ -6205,17 +6006,17 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, request_scan);
-	struct iwl4965_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = sizeof(struct iwl4965_scan_cmd),
 		.meta.flags = CMD_SIZE_HUGE,
 	};
-	int rc = 0;
 	struct iwl4965_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
 	u16 cmd_len;
 	enum ieee80211_band band;
 	u8 direct_mask;
+	int ret = 0;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -6236,7 +6037,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
 		IWL_DEBUG_INFO("Multiple concurrent scan requests in parallel. "
 			       "Ignoring second request.\n");
-		rc = -EIO;
+		ret = -EIO;
 		goto done;
 	}
 
@@ -6269,7 +6070,7 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 		priv->scan = kmalloc(sizeof(struct iwl4965_scan_cmd) +
 				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!priv->scan) {
-			rc = -ENOMEM;
+			ret = -ENOMEM;
 			goto done;
 		}
 	}
@@ -6321,8 +6122,9 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
 		direct_mask = 1;
-	} else
+	} else {
 		direct_mask = 0;
+	}
 
 	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
 	scan->tx_cmd.sta_id = priv->hw_setting.bcast_sta_id;
@@ -6397,8 +6199,8 @@ static void iwl4965_bg_request_scan(struct work_struct *data)
 	scan->len = cpu_to_le16(cmd.len);
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
-	rc = iwl4965_send_cmd_sync(priv, &cmd);
-	if (rc)
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret)
 		goto done;
 
 	queue_delayed_work(priv->workqueue, &priv->scan_check,
@@ -6455,9 +6257,8 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv,
 					     post_associate.work);
-
-	int rc = 0;
 	struct ieee80211_conf *conf = NULL;
+	int ret = 0;
 	DECLARE_MAC_BUF(mac);
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
@@ -6488,9 +6289,9 @@ static void iwl4965_bg_post_associate(struct work_struct *data)
 
 	memset(&priv->rxon_timing, 0, sizeof(struct iwl4965_rxon_time_cmd));
 	iwl4965_setup_rxon_timing(priv);
-	rc = iwl4965_send_cmd_pdu(priv, REPLY_RXON_TIMING,
+	ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
-	if (rc)
+	if (ret)
 		IWL_WARNING("REPLY_RXON_TIMING failed - "
 			    "Attempting to continue.\n");
 
@@ -6886,7 +6687,7 @@ out:
 
 static void iwl4965_config_ap(struct iwl_priv *priv)
 {
-	int rc = 0;
+	int ret = 0;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -6901,9 +6702,9 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 		/* RXON Timing */
 		memset(&priv->rxon_timing, 0, sizeof(struct iwl4965_rxon_time_cmd));
 		iwl4965_setup_rxon_timing(priv);
-		rc = iwl4965_send_cmd_pdu(priv, REPLY_RXON_TIMING,
+		ret = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				sizeof(priv->rxon_timing), &priv->rxon_timing);
-		if (rc)
+		if (ret)
 			IWL_WARNING("REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
 
-- 
1.5.3.4

