Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33618 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753983AbcGFKqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:30 +0300
Message-Id: <1467801651-1816-35-git-send-email-luca@coelho.fi> (sfid-20160706_125026_180482_4A3A01E7)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 35/56] iwlwifi: mvm: write the correct internal TXF index
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

The TX fifos are arranged consecutively in the SMEM, beginning
with the regular fifos, and tailed by the internal fifos.
In the current code, while trying to read the internal fifos,
we read the fifos beginning with the index zero.
By doing this we actually re-read the regular fifos.

In order to read the internal fifos, start the reading index
from the number of regular fifos configured by the fw.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Fixes: 39654cb3a6a2 ("iwlwifi: don't access a nonexistent register upon assert")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 1ece19d..6e692a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -288,7 +288,8 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 			fifo_hdr->fifo_num = cpu_to_le32(i);
 
 			/* Mark the number of TXF we're pulling now */
-			iwl_trans_write_prph(mvm->trans, TXF_CPU2_NUM, i);
+			iwl_trans_write_prph(mvm->trans, TXF_CPU2_NUM, i +
+				ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size));
 
 			fifo_hdr->available_bytes =
 				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-- 
2.8.1

