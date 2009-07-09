Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24416 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbZGIRdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:33:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwl3945: cleanup number of queues settings
Date: Thu,  9 Jul 2009 10:33:40 -0700
Message-Id: <1247160821-14989-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247160821-14989-5-git-send-email-reinette.chatre@intel.com>
References: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-2-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-3-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-4-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

* Rename maximum number of queue (TFD_QUEUE_MAX) to IWL39_NUM_QUEUES to
  be consistent with rest of iwlwifi.
* Remove unused defines.
* Fix loops that iterate over number of TX queues to stop when maximum is reached
  (currently it is maximum + 1).
* Remove queues_num module parameter as it is not used.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    7 ++-----
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 ---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +--------------
 4 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 73f93a0..b569c6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -232,9 +232,8 @@ struct iwl3945_eeprom {
 #define PCI_CFG_REV_ID_BIT_BASIC_SKU                (0x40)	/* bit 6    */
 #define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
 
-#define TFD_QUEUE_MIN           0
-#define TFD_QUEUE_MAX           5	/* 4 DATA + 1 CMD */
-
+/* 4 DATA + 1 CMD. There are 2 HCCA queues that are not used. */
+#define IWL39_NUM_QUEUES        5
 #define IWL_NUM_SCAN_RATES         (2)
 
 #define IWL_DEFAULT_TX_RETRY  15
@@ -280,8 +279,6 @@ struct iwl3945_eeprom {
 /* Size of uCode instruction memory in bootstrap state machine */
 #define IWL39_MAX_BSM_SIZE IWL39_RTC_INST_SIZE
 
-#define IWL39_MAX_NUM_QUEUES	8
-
 static inline int iwl3945_hw_valid_rtc_data_addr(u32 addr)
 {
 	return (addr >= IWL39_RTC_DATA_LOWER_BOUND) &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b0246db..1227ed2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -963,7 +963,7 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 		goto error;
 
 	/* Tx queue(s) */
-	for (txq_id = 0; txq_id <= priv->hw_params.max_txq_num; txq_id++) {
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 				TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		rc = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
@@ -1140,7 +1140,7 @@ void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 	int txq_id;
 
 	/* Tx queues */
-	for (txq_id = 0; txq_id <= priv->hw_params.max_txq_num; txq_id++)
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
 		if (txq_id == IWL_CMD_QUEUE_NUM)
 			iwl_cmd_queue_free(priv);
 		else
@@ -1156,7 +1156,7 @@ void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl_write_prph(priv, ALM_SCD_MODE_REG, 0);
 
 	/* reset TFD queues */
-	for (txq_id = 0; txq_id <= priv->hw_params.max_txq_num; txq_id++) {
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
 		iwl_write_direct32(priv, FH39_TCSR_CONFIG(txq_id), 0x0);
 		iwl_poll_direct_bit(priv, FH39_TSSR_TX_STATUS,
 				FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(txq_id),
@@ -2552,7 +2552,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	}
 
 	/* Assign number of Usable TX queues */
-	priv->hw_params.max_txq_num = TFD_QUEUE_MAX;
+	priv->hw_params.max_txq_num = IWL39_NUM_QUEUES;
 
 	priv->hw_params.tfd_size = sizeof(struct iwl3945_tfd);
 	priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_3K;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index fbb3a57..f2ffc48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -111,9 +111,6 @@ enum iwl3945_antenna {
 #define IWL_TX_FIFO_HCCA_2	6
 #define IWL_TX_FIFO_NONE	7
 
-/* Minimum number of queues. MAX_NUM is defined in hw specific files */
-#define IWL_MIN_NUM_QUEUES	4
-
 #define IEEE80211_DATA_LEN              2304
 #define IEEE80211_4ADDR_LEN             30
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7ff95f8..c9b3ea9 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -89,7 +89,7 @@ MODULE_LICENSE("GPL");
 
  /* module parameters */
 struct iwl_mod_params iwl3945_mod_params = {
-	.num_of_queues = IWL39_MAX_NUM_QUEUES,
+	.num_of_queues = IWL39_NUM_QUEUES, /* Not used */
 	.sw_crypto = 1,
 	.restart_fw = 1,
 	/* the rest are 0 by default */
@@ -3947,15 +3947,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv = hw->priv;
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-	if ((iwl3945_mod_params.num_of_queues > IWL39_MAX_NUM_QUEUES) ||
-	     (iwl3945_mod_params.num_of_queues < IWL_MIN_NUM_QUEUES)) {
-		IWL_ERR(priv,
-			"invalid queues_num, should be between %d and %d\n",
-			IWL_MIN_NUM_QUEUES, IWL39_MAX_NUM_QUEUES);
-		err = -EINVAL;
-		goto out_ieee80211_free_hw;
-	}
-
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
 	 * "the hard way", rather than using device's scan.
@@ -4272,10 +4263,6 @@ module_param_named(debug, iwl3945_mod_params.debug, uint, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan, int, 0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
-
-module_param_named(queues_num, iwl3945_mod_params.num_of_queues, int, 0444);
-MODULE_PARM_DESC(queues_num, "number of hw queues.");
-
 module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, 0444);
 MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
 
-- 
1.5.6.3

