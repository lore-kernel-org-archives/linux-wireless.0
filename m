Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56235 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbYDOXCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 09/11] iwlwifi: arrange max number of Tx queues
Date: Tue, 15 Apr 2008 16:01:45 -0700
Message-Id: <1208300507-25628-10-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000233_350578_85376707)
In-Reply-To: <1208300507-25628-9-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-2-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-3-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-4-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-5-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-6-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-7-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-8-git-send-email-reinette.chatre@intel.com>
 <1208300507-25628-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch increases the max possible number of Tx queues, but leaves
current used number of queues as HW dependent

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 +++---
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 368da98..ad612a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -456,7 +456,7 @@ struct iwl3945_eeprom {
 /* Size of uCode instruction memory in bootstrap state machine */
 #define IWL_MAX_BSM_SIZE ALM_RTC_INST_SIZE
 
-#define IWL_MAX_NUM_QUEUES	8
+#define IWL39_MAX_NUM_QUEUES	8
 
 static inline int iwl3945_hw_valid_rtc_data_addr(u32 addr)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 3dc7f0f..45c1c55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -687,6 +687,8 @@ enum {
 
 #endif
 
+#define IWL_MAX_NUM_QUEUES IWL39_MAX_NUM_QUEUES
+
 struct iwl3945_priv {
 
 	/* ieee device used by generic ieee processing code */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 3d098da..1a66b50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -1385,10 +1385,10 @@ static inline __le32 iwl4965_hw_set_rate_n_flags(u8 rate, u16 flags)
  * up to 7 DMA channels (FIFOs).  Each Tx queue is supported by a circular array
  * in DRAM containing 256 Transmit Frame Descriptors (TFDs).
  */
-#define IWL4965_MAX_WIN_SIZE              64
-#define IWL4965_QUEUE_SIZE               256
-#define IWL4965_NUM_FIFOS                  7
-#define IWL_MAX_NUM_QUEUES                16
+#define IWL4965_MAX_WIN_SIZE	64
+#define IWL4965_QUEUE_SIZE	256
+#define IWL4965_NUM_FIFOS	7
+#define IWL4965_MAX_NUM_QUEUES	16
 
 
 /**
@@ -1553,7 +1553,7 @@ struct iwl4965_sched_queue_byte_cnt_tbl {
  */
 struct iwl4965_shared {
 	struct iwl4965_sched_queue_byte_cnt_tbl
-	 queues_byte_cnt_tbls[IWL_MAX_NUM_QUEUES];
+	 queues_byte_cnt_tbls[IWL4965_MAX_NUM_QUEUES];
 	__le32 rb_closed;
 
 	/* __le32 rb_closed_stts_rb_num:12; */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2e74712..b072523 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -46,7 +46,7 @@
 
 /* module parameters */
 static struct iwl_mod_params iwl4965_mod_params = {
-	.num_of_queues = IWL_MAX_NUM_QUEUES,
+	.num_of_queues = IWL4965_MAX_NUM_QUEUES,
 	.enable_qos = 1,
 	.amsdu_size_8K = 1,
 	/* the rest are 0 by default */
@@ -2021,10 +2021,10 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 {
 
-	if ((priv->cfg->mod_params->num_of_queues > IWL_MAX_NUM_QUEUES) ||
+	if ((priv->cfg->mod_params->num_of_queues > IWL4965_MAX_NUM_QUEUES) ||
 	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
-			  IWL_MIN_NUM_QUEUES, IWL_MAX_NUM_QUEUES);
+			  IWL_MIN_NUM_QUEUES, IWL4965_MAX_NUM_QUEUES);
 		return -EINVAL;
 	}
 
@@ -4362,7 +4362,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 	 * (in Tx queue's circular buffer) of first TFD/frame in window */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
-	if (scd_flow >= ARRAY_SIZE(priv->txq)) {
+	if (scd_flow >= priv->hw_params.max_txq_num) {
 		IWL_ERROR("BUG_ON scd_flow is bigger than number of queues");
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index ddcbad5..9ed13cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -941,6 +941,8 @@ enum {
 
 #endif
 
+#define IWL_MAX_NUM_QUEUES	20 /* FIXME: do dynamic allocation */
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 29a9ecd..1a5678f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -70,7 +70,7 @@ static int iwl3945_param_disable;  /* def: 0 = enable radio */
 static int iwl3945_param_antenna;  /* def: 0 = both antennas (use diversity) */
 int iwl3945_param_hwcrypto;        /* def: 0 = use software encryption */
 static int iwl3945_param_qos_enable = 1; /* def: 1 = use quality of service */
-int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 8 Tx queues */
+int iwl3945_param_queues_num = IWL39_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 
 /*
  * module name, copyright, version, etc.
@@ -7974,10 +7974,10 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		iwl3945_hw_ops.hw_scan = NULL;
 	}
 
-	if ((iwl3945_param_queues_num > IWL_MAX_NUM_QUEUES) ||
+	if ((iwl3945_param_queues_num > IWL39_MAX_NUM_QUEUES) ||
 	    (iwl3945_param_queues_num < IWL_MIN_NUM_QUEUES)) {
 		IWL_ERROR("invalid queues_num, should be between %d and %d\n",
-			  IWL_MIN_NUM_QUEUES, IWL_MAX_NUM_QUEUES);
+			  IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
 		err = -EINVAL;
 		goto out;
 	}
-- 
1.5.3.4

