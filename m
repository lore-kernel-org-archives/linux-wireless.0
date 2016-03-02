Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbcCBH5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:41 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/43] iwlwifi: pcie: detect and workaround invalid write ptr behavior
Date: Wed,  2 Mar 2016 09:56:39 +0200
Message-Id: <1456905404-14435-38-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085952_392870_D74273B1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In 9000 series A0 step the closed_rb_num is not wrapping around
properly. The queue is wrapping around as it should, so we can
W/A it by wrapping the closed_rb_num in the driver.
While at it, extend RX logging and add error handling of other
cases HW values may cause us to access invalid memory locations.
Add also a proper masking of vid value read from HW - this should
not have actual affect, but better to be on the safe side.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 398dd93..489b07a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1159,9 +1159,12 @@ restart:
 	r = le16_to_cpu(ACCESS_ONCE(rxq->rb_stts->closed_rb_num)) & 0x0FFF;
 	i = rxq->read;
 
+	/* W/A 9000 device step A0 wrap-around bug */
+	r &= (rxq->queue_size - 1);
+
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IWL_DEBUG_RX(trans, "HW = SW = %d\n", r);
+		IWL_DEBUG_RX(trans, "Q %d: HW = SW = %d\n", rxq->id, r);
 
 	while (i != r) {
 		struct iwl_rx_mem_buffer *rxb;
@@ -1174,15 +1177,18 @@ restart:
 			 * used_bd is a 32 bit but only 12 are used to retrieve
 			 * the vid
 			 */
-			u16 vid = (u16)le32_to_cpu(rxq->used_bd[i]);
+			u16 vid = le32_to_cpu(rxq->used_bd[i]) & 0x0FFF;
 
+			if (WARN(vid >= ARRAY_SIZE(trans_pcie->global_table),
+				 "Invalid rxb index from HW %u\n", (u32)vid))
+				goto out;
 			rxb = trans_pcie->global_table[vid];
 		} else {
 			rxb = rxq->queue[i];
 			rxq->queue[i] = NULL;
 		}
 
-		IWL_DEBUG_RX(trans, "rxbuf: HW = %d, SW = %d\n", r, i);
+		IWL_DEBUG_RX(trans, "Q %d: HW = %d, SW = %d\n", rxq->id, r, i);
 		iwl_pcie_rx_handle_rb(trans, rxq, rxb, emergency);
 
 		i = (i + 1) & (rxq->queue_size - 1);
@@ -1245,7 +1251,7 @@ restart:
 			goto restart;
 		}
 	}
-
+out:
 	/* Backtrack one entry */
 	rxq->read = i;
 	spin_unlock(&rxq->lock);
@@ -1301,6 +1307,9 @@ irqreturn_t iwl_pcie_irq_rx_msix_handler(int irq, void *dev_id)
 	struct iwl_trans_pcie *trans_pcie = iwl_pcie_get_trans_pcie(entry);
 	struct iwl_trans *trans = trans_pcie->trans;
 
+	if (WARN_ON(entry->entry >= trans->num_rx_queues))
+		return IRQ_NONE;
+
 	lock_map_acquire(&trans->sync_cmd_lockdep_map);
 
 	local_bh_disable();
-- 
2.5.0

