Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbYDXSzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 11/21] iwlwifi-5000: adding iwl5000 HW parameters
Date: Thu, 24 Apr 2008 11:55:28 -0700
Message-Id: <1209063338-6572-12-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205623_753706_883F0506)
In-Reply-To: <1209063338-6572-11-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds iwl 5000 HW parameters

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h       |   47 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-5000.c          |   51 +++++++++++++++++++++-
 3 files changed, 99 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 6b2d6bf..d0e3f35 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -712,6 +712,8 @@ struct iwl4965_qosparam_cmd {
 #define	IWL_STA_ID		2
 #define IWL4965_BROADCAST_ID	31
 #define	IWL4965_STATION_COUNT	32
+#define IWL5000_BROADCAST_ID	15
+#define	IWL5000_STATION_COUNT	16
 
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 5cf8a68..31592fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -68,6 +68,11 @@
 #ifndef __iwl_5000_hw_h__
 #define __iwl_5000_hw_h__
 
+#define IWL50_RTC_INST_UPPER_BOUND		(0x020000)
+#define IWL50_RTC_DATA_UPPER_BOUND		(0x80C000)
+#define IWL50_RTC_INST_SIZE (IWL50_RTC_INST_UPPER_BOUND - RTC_INST_LOWER_BOUND)
+#define IWL50_RTC_DATA_SIZE (IWL50_RTC_DATA_UPPER_BOUND - RTC_DATA_LOWER_BOUND)
+
 /* EERPROM */
 #define IWL_5000_EEPROM_IMG_SIZE			2048
 
@@ -78,5 +83,47 @@
 #define IWL50_NUM_QUEUES                  20
 #define IWL50_BACK_QUEUE_FIRST_ID         10
 
+/* Fixed (non-configurable) rx data from phy */
+
+/* Base physical address of iwl5000_shared is provided to SCD_DRAM_BASE_ADDR
+ * and &iwl5000_shared.val0 is provided to FH_RSCSR_CHNL0_STTS_WPTR_REG */
+struct iwl5000_sched_queue_byte_cnt_tbl {
+	struct iwl4965_queue_byte_cnt_entry tfd_offset[IWL50_QUEUE_SIZE +
+						       IWL50_MAX_WIN_SIZE];
+} __attribute__ ((packed));
+
+struct iwl5000_shared {
+	struct iwl5000_sched_queue_byte_cnt_tbl
+	 queues_byte_cnt_tbls[IWL50_NUM_QUEUES];
+	__le32 rb_closed;
+
+	/* __le32 rb_closed_stts_rb_num:12; */
+#define IWL_rb_closed_stts_rb_num_POS 0
+#define IWL_rb_closed_stts_rb_num_LEN 12
+#define IWL_rb_closed_stts_rb_num_SYM rb_closed
+	/* __le32 rsrv1:4; */
+	/* __le32 rb_closed_stts_rx_frame_num:12; */
+#define IWL_rb_closed_stts_rx_frame_num_POS 16
+#define IWL_rb_closed_stts_rx_frame_num_LEN 12
+#define IWL_rb_closed_stts_rx_frame_num_SYM rb_closed
+	/* __le32 rsrv2:4; */
+
+	__le32 frm_finished;
+	/* __le32 frame_finished_stts_rb_num:12; */
+#define IWL_frame_finished_stts_rb_num_POS 0
+#define IWL_frame_finished_stts_rb_num_LEN 12
+#define IWL_frame_finished_stts_rb_num_SYM frm_finished
+	/* __le32 rsrv3:4; */
+	/* __le32 frame_finished_stts_rx_frame_num:12; */
+#define IWL_frame_finished_stts_rx_frame_num_POS 16
+#define IWL_frame_finished_stts_rx_frame_num_LEN 12
+#define IWL_frame_finished_stts_rx_frame_num_SYM frm_finished
+	/* __le32 rsrv4:4; */
+
+	__le32 padding1;  /* so that allocation will be aligned to 16B */
+	__le32 padding2;
+} __attribute__ ((packed));
+
+
 #endif /* __iwl_5000_hw_h__ */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 91b3e56..545970b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -133,8 +133,56 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 	return &priv->eeprom[address];
 }
 
+static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
+{
+	if ((priv->cfg->mod_params->num_of_queues > IWL50_NUM_QUEUES) ||
+	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
+		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
+			  IWL_MIN_NUM_QUEUES, IWL50_NUM_QUEUES);
+		return -EINVAL;
+	}
 
-
+	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.sw_crypto = priv->cfg->mod_params->sw_crypto;
+	priv->hw_params.tx_cmd_len = sizeof(struct iwl4965_tx_cmd);
+	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
+	priv->hw_params.max_rxq_log = RX_QUEUE_SIZE_LOG;
+	if (priv->cfg->mod_params->amsdu_size_8K)
+		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_8K;
+	else
+		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_4K;
+	priv->hw_params.max_pkt_size = priv->hw_params.rx_buf_size - 256;
+	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
+	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
+	priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
+	priv->hw_params.max_bsm_size = BSM_SRAM_SIZE;
+	priv->hw_params.fat_channel =  BIT(IEEE80211_BAND_2GHZ) |
+					BIT(IEEE80211_BAND_5GHZ);
+
+	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_5100:
+	case CSR_HW_REV_TYPE_5150:
+		priv->hw_params.tx_chains_num = 1;
+		priv->hw_params.rx_chains_num = 2;
+		/* FIXME: move to ANT_A, ANT_B, ANT_C enum */
+		priv->hw_params.valid_tx_ant = IWL_ANTENNA_MAIN;
+		priv->hw_params.valid_rx_ant = (IWL_ANTENNA_MAIN |
+						IWL_ANTENNA_AUX);
+		break;
+	case CSR_HW_REV_TYPE_5300:
+	case CSR_HW_REV_TYPE_5350:
+		priv->hw_params.tx_chains_num = 3;
+		priv->hw_params.rx_chains_num = 3;
+		/* FIXME: move to ANT_A, ANT_B, ANT_C enum */
+		priv->hw_params.valid_tx_ant = (IWL_ANTENNA_MAIN |
+						IWL_ANTENNA_AUX | 0x04);
+		priv->hw_params.valid_rx_ant = (IWL_ANTENNA_MAIN |
+						IWL_ANTENNA_AUX | 0x04);
+		break;
+	}
+	return 0;
+}
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
@@ -142,6 +190,7 @@ static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 };
 
 static struct iwl_lib_ops iwl5000_lib = {
+	.set_hw_params = iwl5000_hw_set_hw_params,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.set_pwr_src = iwl4965_set_pwr_src,
-- 
1.5.3.4

