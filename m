Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33414 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbcGFKoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:42 +0300
Message-Id: <1467801651-1816-47-git-send-email-luca@coelho.fi> (sfid-20160706_124435_110425_275F843A)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 47/56] iwlwifi: decouple PCIe transport from mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The PCIe transport needs to store two pointers in each TX SKB, and
currently assumes mac80211's ieee80211_tx_info is present in the CB
to do that.

In order to remove that assumption, have the opmodes pass in the
offset to where the pointers can be stored in the CB and use the
offset in the PCIe code.

To make the disentanglement complete, remove mac80211.h includes
from everywhere in the generic iwlwifi code. This required adding
an include of cfg80211.h in one place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  2 ++
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  9 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  3 ++
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  3 ++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 41 ++++++++++++----------
 8 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 5915914..b498486 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1337,6 +1337,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.command_groups_size = ARRAY_SIZE(iwl_dvm_groups);
 
 	trans_cfg.cmd_fifo = IWLAGN_CMD_FIFO_NUM;
+	trans_cfg.cb_data_offs = offsetof(struct ieee80211_tx_info,
+					  driver_data[2]);
 
 	WARN_ON(sizeof(priv->transport_queue_stop) * BITS_PER_BYTE <
 		priv->cfg->base_params->num_of_queues);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
index 1f4e502..e04a91d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h
@@ -66,6 +66,7 @@
 
 #include <linux/types.h>
 #include <linux/if_ether.h>
+#include <net/cfg80211.h>
 #include "iwl-trans.h"
 
 struct iwl_nvm_data {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index 0379899..4d32b10 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -66,7 +66,6 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/gfp.h>
-#include <net/mac80211.h>
 
 extern struct iwl_mod_params iwlwifi_mod_params;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 57cc67f..9ac47e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -392,11 +392,6 @@ static inline void iwl_free_rxb(struct iwl_rx_cmd_buffer *r)
 
 #define MAX_NO_RECLAIM_CMDS	6
 
-/*
- * The first entry in driver_data array in ieee80211_tx_info
- * that can be used by the transport.
- */
-#define IWL_TRANS_FIRST_DRIVER_DATA 2
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
 /*
@@ -500,6 +495,8 @@ struct iwl_hcmd_arr {
  * @command_groups_size: number of command groups, to avoid illegal access
  * @sdio_adma_addr: the default address to set for the ADMA in SDIO mode until
  *	we get the ALIVE from the uCode
+ * @cb_data_offs: offset inside skb->cb to store transport data at, must have
+ *	space for at least two pointers
  */
 struct iwl_trans_config {
 	struct iwl_op_mode *op_mode;
@@ -519,6 +516,8 @@ struct iwl_trans_config {
 	int command_groups_size;
 
 	u32 sdio_adma_addr;
+
+	u8 cb_data_offs;
 };
 
 struct iwl_trans_dump_data {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index a08db00..55d9096 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -668,6 +668,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.cmd_fifo = IWL_MVM_TX_FIFO_CMD;
 	trans_cfg.scd_set_active = true;
 
+	trans_cfg.cb_data_offs = offsetof(struct ieee80211_tx_info,
+					  driver_data[2]);
+
 	trans_cfg.sdio_adma_addr = fw->sdio_adma_addr;
 	trans_cfg.sw_csum_tx = IWL_MVM_SW_TX_CSUM_OFFLOAD;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 8bfa915..f684b9d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -385,6 +385,8 @@ struct iwl_trans_pcie {
 	wait_queue_head_t wait_command_queue;
 	wait_queue_head_t d0i3_waitq;
 
+	u8 page_offs, dev_cmd_offs;
+
 	u8 cmd_queue;
 	u8 cmd_fifo;
 	unsigned int cmd_q_wdg_timeout;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f5ace92..3b7a414 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1650,6 +1650,9 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	trans_pcie->scd_set_active = trans_cfg->scd_set_active;
 	trans_pcie->sw_csum_tx = trans_cfg->sw_csum_tx;
 
+	trans_pcie->page_offs = trans_cfg->cb_data_offs;
+	trans_pcie->dev_cmd_offs = trans_cfg->cb_data_offs + sizeof(void *);
+
 	trans->command_groups = trans_cfg->command_groups;
 	trans->command_groups_size = trans_cfg->command_groups_size;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9b5858b..2b68826 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -584,16 +584,16 @@ static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 	return 0;
 }
 
-static void iwl_pcie_free_tso_page(struct sk_buff *skb)
+static void iwl_pcie_free_tso_page(struct iwl_trans_pcie *trans_pcie,
+				   struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct page **page_ptr;
 
-	if (info->driver_data[IWL_TRANS_FIRST_DRIVER_DATA]) {
-		struct page *page =
-			info->driver_data[IWL_TRANS_FIRST_DRIVER_DATA];
+	page_ptr = (void *)((u8 *)skb->cb + trans_pcie->page_offs);
 
-		__free_page(page);
-		info->driver_data[IWL_TRANS_FIRST_DRIVER_DATA] = NULL;
+	if (*page_ptr) {
+		__free_page(*page_ptr);
+		*page_ptr = NULL;
 	}
 }
 
@@ -639,7 +639,7 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 			if (WARN_ON_ONCE(!skb))
 				continue;
 
-			iwl_pcie_free_tso_page(skb);
+			iwl_pcie_free_tso_page(trans_pcie, skb);
 		}
 		iwl_pcie_txq_free_tfd(trans, txq);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr);
@@ -1084,7 +1084,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		if (WARN_ON_ONCE(!skb))
 			continue;
 
-		iwl_pcie_free_tso_page(skb);
+		iwl_pcie_free_tso_page(trans_pcie, skb);
 
 		__skb_queue_tail(skbs, skb);
 
@@ -1115,17 +1115,17 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 		while (!skb_queue_empty(&overflow_skbs)) {
 			struct sk_buff *skb = __skb_dequeue(&overflow_skbs);
-			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-			u8 dev_cmd_idx = IWL_TRANS_FIRST_DRIVER_DATA + 1;
-			struct iwl_device_cmd *dev_cmd =
-				info->driver_data[dev_cmd_idx];
+			struct iwl_device_cmd *dev_cmd_ptr;
+
+			dev_cmd_ptr = *(void **)((u8 *)skb->cb +
+						 trans_pcie->dev_cmd_offs);
 
 			/*
 			 * Note that we can very well be overflowing again.
 			 * In that case, iwl_queue_space will be small again
 			 * and we won't wake mac80211's queue.
 			 */
-			iwl_trans_pcie_tx(trans, skb, dev_cmd, txq_id);
+			iwl_trans_pcie_tx(trans, skb, dev_cmd_ptr, txq_id);
 		}
 		spin_lock_bh(&txq->lock);
 
@@ -2024,7 +2024,6 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 				   struct iwl_cmd_meta *out_meta,
 				   struct iwl_device_cmd *dev_cmd, u16 tb1_len)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int snap_ip_tcp_hdrlen, ip_hdrlen, total_len, hdr_room;
@@ -2033,6 +2032,7 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 	u16 length, iv_len, amsdu_pad;
 	u8 *start_hdr;
 	struct iwl_tso_hdr_page *hdr_page;
+	struct page **page_ptr;
 	int ret;
 	struct tso_t tso;
 
@@ -2063,7 +2063,8 @@ static int iwl_fill_data_tbs_amsdu(struct iwl_trans *trans, struct sk_buff *skb,
 
 	get_page(hdr_page->page);
 	start_hdr = hdr_page->pos;
-	info->driver_data[IWL_TRANS_FIRST_DRIVER_DATA] = hdr_page->page;
+	page_ptr = (void *)((u8 *)skb->cb + trans_pcie->page_offs);
+	*page_ptr = hdr_page->page;
 	memcpy(hdr_page->pos, skb->data + hdr_len, iv_len);
 	hdr_page->pos += iv_len;
 
@@ -2273,10 +2274,12 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 		/* don't put the packet on the ring, if there is no room */
 		if (unlikely(iwl_queue_space(q) < 3)) {
-			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+			struct iwl_device_cmd **dev_cmd_ptr;
+
+			dev_cmd_ptr = (void *)((u8 *)skb->cb +
+					       trans_pcie->dev_cmd_offs);
 
-			info->driver_data[IWL_TRANS_FIRST_DRIVER_DATA + 1] =
-				dev_cmd;
+			*dev_cmd_ptr = dev_cmd;
 			__skb_queue_tail(&txq->overflow_q, skb);
 
 			spin_unlock(&txq->lock);
-- 
2.8.1

