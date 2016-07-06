Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33572 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753933AbcGFKqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:29 +0300
Message-Id: <1467801651-1816-34-git-send-email-luca@coelho.fi> (sfid-20160706_125027_070391_4688647F)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 34/56] iwlwifi: pcie: fix access to scratch buffer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

This fixes a pretty ancient bug that hasn't manifested itself
until now.
The scratchbuf for command queue is allocated only for 32 slots
but is accessed with the queue write pointer - which can be
up to 256.
Since the scratch buf size was 16 and there are up to 256 TFDs
we never passed a page boundary when accessing the scratch buffer,
but when attempting to increase the size of the scratch buffer a
panic was quick to follow when trying to access the address resulted
in a page boundary.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 38c0f334b359 ("iwlwifi: use coherent DMA memory for command header")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 8901d49..9b5858b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1604,9 +1604,9 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 
 	/* start the TFD with the scratchbuf */
 	scratch_size = min_t(int, copy_size, IWL_HCMD_SCRATCHBUF_SIZE);
-	memcpy(&txq->scratchbufs[q->write_ptr], &out_cmd->hdr, scratch_size);
+	memcpy(&txq->scratchbufs[idx], &out_cmd->hdr, scratch_size);
 	iwl_pcie_txq_build_tfd(trans, txq,
-			       iwl_pcie_get_scratchbuf_dma(txq, q->write_ptr),
+			       iwl_pcie_get_scratchbuf_dma(txq, idx),
 			       scratch_size, true);
 
 	/* map first command fragment, if any remains */
-- 
2.8.1

