Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11400 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab2CDUnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 058/101] iwlwifi: move all uCode load variables
Date: Sun,  4 Mar 2012 11:29:12 -0800
Message-Id: <1330889395-533-59-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214535_769811_181C9CEC)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All variables related to uCode loading (the
waitqueue and done indication) should be in
the PCI-E transport's private data as this
is transport specific. Move them there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    8 +++++---
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    3 ---
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index ca090d2..4fc8967 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -365,7 +365,7 @@ struct iwl_cfg {
  * @nic: pointer to the nic data
  * @hw_params: see struct iwl_hw_params
  * @lock: protect general shared data
- * @wait_command_queue: the wait_queue for SYNC host command nad uCode load
+ * @wait_command_queue: the wait_queue for SYNC host commands
  * @eeprom: pointer to the eeprom/OTP image
  * @ucode_type: indicator of loaded ucode image
  * @device_pointers: pointers to ucode event tables
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 44952c3..93f49ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -32,6 +32,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/skbuff.h>
+#include <linux/wait.h>
 #include <linux/pci.h>
 
 #include "iwl-fh.h"
@@ -243,6 +244,8 @@ struct iwl_tx_queue {
  * queue_stop_count: tracks what SW queue is stopped
  * @pci_dev: basic pci-network driver stuff
  * @hw_base: pci hardware address support
+ * @ucode_write_complete: indicates that the ucode has been copied.
+ * @ucode_write_waitq: wait queue for uCode load
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -279,6 +282,9 @@ struct iwl_trans_pcie {
 	/* PCI bus related data */
 	struct pci_dev *pci_dev;
 	void __iomem *hw_base;
+
+	bool ucode_write_complete;
+	wait_queue_head_t ucode_write_waitq;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 6214855..088354f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1114,8 +1114,8 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		isr_stats->tx++;
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
-		trans->ucode_write_complete = 1;
-		wake_up(&trans->shrd->wait_command_queue);
+		trans_pcie->ucode_write_complete = true;
+		wake_up(&trans_pcie->ucode_write_waitq);
 	}
 
 	if (inta & ~handled) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 7a2e65f..83143d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -954,11 +954,12 @@ static const u8 iwlagn_pan_ac_to_queue[] = {
 static int iwl_load_section(struct iwl_trans *trans, const char *name,
 			    const struct fw_desc *image, u32 dst_addr)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	dma_addr_t phy_addr = image->p_addr;
 	u32 byte_cnt = image->len;
 	int ret;
 
-	trans->ucode_write_complete = 0;
+	trans_pcie->ucode_write_complete = false;
 
 	iwl_write_direct32(trans,
 		FH_TCSR_CHNL_TX_CONFIG_REG(FH_SRVC_CHNL),
@@ -989,8 +990,8 @@ static int iwl_load_section(struct iwl_trans *trans, const char *name,
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
 	IWL_DEBUG_FW(trans, "%s uCode section being loaded...\n", name);
-	ret = wait_event_timeout(trans->shrd->wait_command_queue,
-				 trans->ucode_write_complete, 5 * HZ);
+	ret = wait_event_timeout(trans_pcie->ucode_write_waitq,
+				 trans_pcie->ucode_write_complete, 5 * HZ);
 	if (!ret) {
 		IWL_ERR(trans, "Could not load the %s uCode section\n",
 			name);
@@ -2266,6 +2267,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 	trans->shrd = shrd;
 	trans_pcie->trans = trans;
 	spin_lock_init(&trans_pcie->irq_lock);
+	init_waitqueue_head(&trans_pcie->ucode_write_waitq);
 
 	/* W/A - seems to solve weird behavior. We need to remove this if we
 	 * don't want to stay in L1 all the time. This wastes a lot of power */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index a8d476a..dcad694 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -338,7 +338,6 @@ enum iwl_trans_state {
  * @hw_id: a u32 with the ID of the device / subdevice.
  *	Set during transport allocation.
  * @hw_id_str: a string with info about HW ID. Set during transport allocation.
- * @ucode_write_complete: indicates that the ucode has been copied.
  * @nvm_device_type: indicates OTP or eeprom
  * @pm_support: set to true in start_hw if link pm is supported
  */
@@ -355,8 +354,6 @@ struct iwl_trans {
 	u32 hw_id;
 	char hw_id_str[52];
 
-	u8 ucode_write_complete;
-
 	int    nvm_device_type;
 	bool pm_support;
 
-- 
1.7.0.4

