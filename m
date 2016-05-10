Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40780 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752268AbcEJUaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:06 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:28 +0300
Message-Id: <1462910797-20303-32-git-send-email-luca@coelho.fi> (sfid-20160510_223110_037421_E8FA2088)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 32/41] iwlwifi: don't access a nonexistent register upon assert
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The commit below added code to dump the content of FIFOs
that are present only on dual CPU products (8000 and up).
This broke 7265D whose firmware does advertise
IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG but doesn't have 2
CPUs. The current code does check the length of the FIFO
before dumping them (and the nonexistent FIFO has a 0
length), but we still accessed a register to set the FIFO
number and that made the DMA unhappy.

The impact was a much longer recovery upon firmware assert.

Fixes: 5b086414293f ("iwlwifi: mvm: support dumping UMAC internal txfifos")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 442e13e..1ece19d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -271,9 +271,6 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 		for (i = 0;
 		     i < ARRAY_SIZE(mvm->shared_mem_cfg.internal_txfifo_size);
 		     i++) {
-			/* Mark the number of TXF we're pulling now */
-			iwl_trans_write_prph(mvm->trans, TXF_CPU2_NUM, i);
-
 			fifo_hdr = (void *)(*dump_data)->data;
 			fifo_data = (void *)fifo_hdr->data;
 			fifo_len = mvm->shared_mem_cfg.internal_txfifo_size[i];
@@ -289,6 +286,10 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 				cpu_to_le32(fifo_len + sizeof(*fifo_hdr));
 
 			fifo_hdr->fifo_num = cpu_to_le32(i);
+
+			/* Mark the number of TXF we're pulling now */
+			iwl_trans_write_prph(mvm->trans, TXF_CPU2_NUM, i);
+
 			fifo_hdr->available_bytes =
 				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
 								TXF_CPU2_FIFO_ITEM_CNT));
-- 
2.8.1

