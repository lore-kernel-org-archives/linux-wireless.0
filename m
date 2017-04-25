Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54244 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1948970AbdDYUX4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:39 +0300
Message-Id: <20170425202243.7844-22-luca@coelho.fi> (sfid-20170425_222421_832165_34C308A7)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 21/25] iwlwifi: move to 512 queues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Avoid using the old define since it will enlarge necessary
structs for previous HW.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 6 +++---
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 097cb45c8ad9..c648cfb981a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -85,7 +85,7 @@
 
 static const struct iwl_base_params iwl_a000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_A000,
-	.num_of_queues = 31,
+	.num_of_queues = 512,
 	.shadow_ram_support = true,
 	.led_compensation = 57,
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 4af1267181a9..a12197e3ce78 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -170,7 +170,7 @@ struct iwl_base_params {
 	   apmg_wake_up_wa:1,
 	   scd_chain_ext_wa:1;
 
-	u8 num_of_queues;	/* def: HW dependent */
+	u16 num_of_queues;	/* def: HW dependent */
 
 	u8 max_ll_items;
 	u8 led_compensation;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 626e2703a57f..181636861cb6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -396,6 +396,8 @@ static inline void iwl_free_rxb(struct iwl_rx_cmd_buffer *r)
  * currently supports
  */
 #define IWL_MAX_HW_QUEUES		32
+#define IWL_MAX_TVQM_QUEUES		512
+
 #define IWL_MAX_TID_COUNT	8
 #define IWL_MGMT_TID		15
 #define IWL_FRAME_LIMIT	64
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 204664b578df..4e74a6b90e70 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -788,7 +788,7 @@ struct iwl_mvm {
 		u64 on_time_scan;
 	} radio_stats, accu_radio_stats;
 
-	u8 hw_queue_to_mac80211[IWL_MAX_HW_QUEUES];
+	u8 hw_queue_to_mac80211[IWL_MAX_TVQM_QUEUES];
 
 	struct {
 		u8 hw_queue_refcount;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 30835f06a6e2..fd4faaaa1484 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -414,9 +414,9 @@ struct iwl_trans_pcie {
 	struct iwl_dma_ptr kw;
 
 	struct iwl_txq *txq_memory;
-	struct iwl_txq *txq[IWL_MAX_HW_QUEUES];
-	unsigned long queue_used[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
-	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
+	struct iwl_txq *txq[IWL_MAX_TVQM_QUEUES];
+	unsigned long queue_used[BITS_TO_LONGS(IWL_MAX_TVQM_QUEUES)];
+	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_TVQM_QUEUES)];
 
 	/* PCI bus related data */
 	struct pci_dev *pci_dev;
-- 
2.11.0
