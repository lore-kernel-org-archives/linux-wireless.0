Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbZCREq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/13] iwl3945: set TFD_QUEUE_MAX to correct value
Date: Tue, 17 Mar 2009 21:51:48 -0700
Message-Id: <1237351913-19202-9-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054710_299058_FF9EE3F1)
In-Reply-To: <1237351913-19202-8-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Total number of queues is 8 but only 7 of them are TX queues.
4 AC(Data) queue ,1 CMD and 2 HCCA. The HCCA queues are not used.
max_txq_num is set to maximum usable TX queues.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 205603d..73f93a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -233,7 +233,7 @@ struct iwl3945_eeprom {
 #define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
 
 #define TFD_QUEUE_MIN           0
-#define TFD_QUEUE_MAX           6
+#define TFD_QUEUE_MAX           5	/* 4 DATA + 1 CMD */
 
 #define IWL_NUM_SCAN_RATES         (2)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ba7e720..99bb48e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1046,7 +1046,7 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 		goto error;
 
 	/* Tx queue(s) */
-	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
+	for (txq_id = 0; txq_id <= priv->hw_params.max_txq_num; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 				TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		rc = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
@@ -1239,7 +1239,7 @@ void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 	int txq_id;
 
 	/* Tx queues */
-	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++)
+	for (txq_id = 0; txq_id <= priv->hw_params.max_txq_num; txq_id++)
 		iwl_tx_queue_free(priv, txq_id);
 }
 
@@ -1259,7 +1259,7 @@ void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
 	iwl_write_prph(priv, ALM_SCD_MODE_REG, 0);
 
 	/* reset TFD queues */
-	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
+	for (txq_id = 0; txq_id <= priv->hw_params.max_txq_num; txq_id++) {
 		iwl_write_direct32(priv, FH39_TCSR_CONFIG(txq_id), 0x0);
 		iwl_poll_direct_bit(priv, FH39_TSSR_TX_STATUS,
 				FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(txq_id),
@@ -2488,6 +2488,9 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 		return -ENOMEM;
 	}
 
+	/* Assign number of Usable TX queues */
+	priv->hw_params.max_txq_num = TFD_QUEUE_MAX;
+
 	priv->hw_params.tfd_size = sizeof(struct iwl3945_tfd);
 	priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_3K;
 	priv->hw_params.max_pkt_size = 2342;
-- 
1.5.6.3

