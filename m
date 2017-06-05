Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59450 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751186AbdFEUn7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:04 +0300
Message-Id: <20170605204218.30151-12-luca@coelho.fi> (sfid-20170605_224403_060391_7A559A91)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 11/25] iwlwifi: mvm: disable prph collection in a000 hw
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Apart from the current list of PRPH that can't be
collected in A000 HW, the rest of the debug dump
data the driver collects is valid, so there is no
need to disable collection only because of this.

Disable PRPH collecting in A000 HW, and allow
collecting the rest of the debug data.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 8aa2992e1427..aac0426112c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -640,18 +640,21 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		}
 
 		/* Make room for PRPH registers */
-		for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr_comm); i++) {
-			/* The range includes both boundaries */
-			int num_bytes_in_chunk =
-				iwl_prph_dump_addr_comm[i].end -
-				iwl_prph_dump_addr_comm[i].start + 4;
-
-			prph_len += sizeof(*dump_data) +
-				sizeof(struct iwl_fw_error_dump_prph) +
-				num_bytes_in_chunk;
+		if (!mvm->trans->cfg->gen2) {
+			for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr_comm);
+			     i++) {
+				/* The range includes both boundaries */
+				int num_bytes_in_chunk =
+					iwl_prph_dump_addr_comm[i].end -
+					iwl_prph_dump_addr_comm[i].start + 4;
+
+				prph_len += sizeof(*dump_data) +
+					sizeof(struct iwl_fw_error_dump_prph) +
+					num_bytes_in_chunk;
+			}
 		}
 
-		if (mvm->cfg->mq_rx_supported) {
+		if (!mvm->trans->cfg->gen2 && mvm->cfg->mq_rx_supported) {
 			for (i = 0; i <
 				ARRAY_SIZE(iwl_prph_dump_addr_9000); i++) {
 				/* The range includes both boundaries */
-- 
2.11.0
