Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758891AbYDXSzu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 17/21] iwlwifi-5000: update the byte count in SCD
Date: Thu, 24 Apr 2008 11:55:34 -0700
Message-Id: <1209063338-6572-18-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205636_904679_77167FD6)
In-Reply-To: <1209063338-6572-17-git-send-email-reinette.chatre@intel.com>
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
 <1209063338-6572-12-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-13-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-14-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-15-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-16-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-17-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch udpates the byte count of the frame in the registers of the
scheduler.
This patch also moves two defines in iwl-4965.h to a more appropriate
area in the file.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |    4 ++
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   49 ++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 31592fb..9e557ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -83,6 +83,10 @@
 #define IWL50_NUM_QUEUES                  20
 #define IWL50_BACK_QUEUE_FIRST_ID         10
 
+#define IWL_sta_id_POS 12
+#define IWL_sta_id_LEN 4
+#define IWL_sta_id_SYM val
+
 /* Fixed (non-configurable) rx data from phy */
 
 /* Base physical address of iwl5000_shared is provided to SCD_DRAM_BASE_ADDR
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8e2a6a5..1e63b49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -314,6 +314,54 @@ static void iwl5000_free_shared_mem(struct iwl_priv *priv)
 				    priv->shared_phys);
 }
 
+/**
+ * iwl5000_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
+ */
+static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+					    struct iwl4965_tx_queue *txq,
+					    u16 byte_cnt)
+{
+	struct iwl5000_shared *shared_data = priv->shared_virt;
+	int txq_id = txq->q.id;
+	u8 sec_ctl = 0;
+	u8 sta = 0;
+	int len;
+
+	len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
+
+	if (txq_id != IWL_CMD_QUEUE_NUM) {
+		sta = txq->cmd[txq->q.write_ptr].cmd.tx.sta_id;
+		sec_ctl = txq->cmd[txq->q.write_ptr].cmd.tx.sec_ctl;
+
+		switch (sec_ctl & TX_CMD_SEC_MSK) {
+		case TX_CMD_SEC_CCM:
+			len += CCMP_MIC_LEN;
+			break;
+		case TX_CMD_SEC_TKIP:
+			len += TKIP_ICV_LEN;
+			break;
+		case TX_CMD_SEC_WEP:
+			len += WEP_IV_LEN + WEP_ICV_LEN;
+			break;
+		}
+	}
+
+	IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
+		       tfd_offset[txq->q.write_ptr], byte_cnt, len);
+
+	IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
+		       tfd_offset[txq->q.write_ptr], sta_id, sta);
+
+	if (txq->q.write_ptr < IWL50_MAX_WIN_SIZE) {
+		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
+			tfd_offset[IWL50_QUEUE_SIZE + txq->q.write_ptr],
+			byte_cnt, len);
+		IWL_SET_BITS16(shared_data->queues_byte_cnt_tbls[txq_id].
+			tfd_offset[IWL50_QUEUE_SIZE + txq->q.write_ptr],
+			sta_id, sta);
+	}
+}
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
@@ -328,6 +376,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.alloc_shared_mem = iwl5000_alloc_shared_mem,
 	.free_shared_mem = iwl5000_free_shared_mem,
+	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.set_pwr_src = iwl4965_set_pwr_src,
-- 
1.5.3.4

