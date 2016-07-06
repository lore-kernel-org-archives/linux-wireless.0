Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33606 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753917AbcGFKqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:35 +0300
Message-Id: <1467801651-1816-40-git-send-email-luca@coelho.fi> (sfid-20160706_125022_110408_D2C32D1D)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 40/56] iwlwifi: pcie: don't use vid 0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In cases of hardware or DMA error, the vid read from
a zeroed location will be 0, and we will access the rxb
at index 0 in the global table, while it may be NULL or
owned by hardware.
Invalidate vid 0 in order to detect the situation and
bail out.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index c1c3c6a..0296c29 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -960,7 +960,7 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 		else
 			list_add(&rxb->list, &def_rxq->rx_used);
 		trans_pcie->global_table[i] = rxb;
-		rxb->vid = (u16)i;
+		rxb->vid = (u16)(i + 1);
 	}
 
 	iwl_pcie_rxq_alloc_rbs(trans, GFP_KERNEL, def_rxq);
@@ -1249,10 +1249,13 @@ restart:
 			 */
 			u16 vid = le32_to_cpu(rxq->used_bd[i]) & 0x0FFF;
 
-			if (WARN(vid >= ARRAY_SIZE(trans_pcie->global_table),
-				 "Invalid rxb index from HW %u\n", (u32)vid))
+			if (WARN(!vid ||
+				 vid > ARRAY_SIZE(trans_pcie->global_table),
+				 "Invalid rxb index from HW %u\n", (u32)vid)) {
+				iwl_force_nmi(trans);
 				goto out;
-			rxb = trans_pcie->global_table[vid];
+			}
+			rxb = trans_pcie->global_table[vid - 1];
 		} else {
 			rxb = rxq->queue[i];
 			rxq->queue[i] = NULL;
-- 
2.8.1

