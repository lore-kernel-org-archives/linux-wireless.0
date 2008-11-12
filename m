Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16352 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYKLVNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:50 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwlwifi: some fh document fix and cleanup
Date: Wed, 12 Nov 2008 13:14:10 -0800
Message-Id: <1226524451-3417-8-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221401_195051_C114A228)
In-Reply-To: <1226524451-3417-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226524451-3417-1-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-2-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-3-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-4-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-5-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-6-git-send-email-reinette.chatre@intel.com>
 <1226524451-3417-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

This patch cleans up some flow handler related document. It also
removes some blank lines.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fh.h |    9 ++++-----
 drivers/net/wireless/iwlwifi/iwl-tx.c |    4 ----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index e46300c..694ebb0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -440,7 +440,7 @@ static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
  * @lo: low [31:0] portion of the dma address of TX buffer
  * 	every even is unaligned on 16 bit boundary
  * @hi_n_len 0-3 [35:32] portion of dma
- *	     4-16 length of the tx buffer
+ *	     4-15 length of the tx buffer
  */
 struct iwl_tfd_tb {
 	__le32 lo;
@@ -453,7 +453,8 @@ struct iwl_tfd_tb {
  * Transmit Frame Descriptor (TFD)
  *
  * @ __reserved1[3] reserved
- * @ num_tbs 0-5 number of active tbs
+ * @ num_tbs 0-4 number of active tbs
+ *	     5   reserved
  * 	     6-7 padding (not used)
  * @ tbs[20]	transmit frame buffer descriptors
  * @ __pad 	padding
@@ -473,8 +474,6 @@ struct iwl_tfd_tb {
  * Tx frame, up to 8 KBytes in size.
  *
  * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
- *
- * Bit fields in the control dword (val0):
  */
 struct iwl_tfd {
 	u8 __reserved1[3];
@@ -485,6 +484,6 @@ struct iwl_tfd {
 
 
 /* Keep Warm Size */
-#define IWL_KW_SIZE 0x1000	/*4k */
+#define IWL_KW_SIZE 0x1000	/* 4k */
 
 #endif /* !__iwl_fh_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index d347505..6db11af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -587,8 +587,6 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-
-
 	/* Alloc and init all Tx queues, including the command queue (#4) */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
@@ -618,11 +616,9 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
  */
 void iwl_txq_ctx_stop(struct iwl_priv *priv)
 {
-
 	int txq_id;
 	unsigned long flags;
 
-
 	/* Turn off all Tx DMA fifos */
 	spin_lock_irqsave(&priv->lock, flags);
 	if (iwl_grab_nic_access(priv)) {
-- 
1.5.4.3

