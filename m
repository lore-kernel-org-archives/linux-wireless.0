Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40742 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069AbcEJU3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:29:34 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:18 +0300
Message-Id: <1462910797-20303-22-git-send-email-luca@coelho.fi> (sfid-20160510_222937_581161_B8EA3356)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 22/41] iwlwifi: mvm: add more registers to dump upon error
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Add UREG, RXFC, RFH, WMAL and RL2P registers to the prph dump
upon error. These regesiters could help to debug MSI-X and other
issues.

These register should be dumped only when multi-queue rx is supported
so separate the prph ranges static array to two different arrays,
and enable dumping different prph ranges according to run-time
decision.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 53 ++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index e25171f..442e13e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -339,9 +339,11 @@ void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm)
 #define IWL8260_ICCM_OFFSET		0x44000 /* Only for B-step */
 #define IWL8260_ICCM_LEN		0xC000 /* Only for B-step */
 
-static const struct {
+struct iwl_prph_range {
 	u32 start, end;
-} iwl_prph_dump_addr[] = {
+};
+
+static const struct iwl_prph_range iwl_prph_dump_addr_comm[] = {
 	{ .start = 0x00a00000, .end = 0x00a00000 },
 	{ .start = 0x00a0000c, .end = 0x00a00024 },
 	{ .start = 0x00a0002c, .end = 0x00a0003c },
@@ -439,8 +441,18 @@ static const struct {
 	{ .start = 0x00a44000, .end = 0x00a7bf80 },
 };
 
+static const struct iwl_prph_range iwl_prph_dump_addr_9000[] = {
+	{ .start = 0x00a05c00, .end = 0x00a05c18 },
+	{ .start = 0x00a05400, .end = 0x00a056e8 },
+	{ .start = 0x00a08000, .end = 0x00a098bc },
+	{ .start = 0x00adfc00, .end = 0x00adfd1c },
+	{ .start = 0x00a02400, .end = 0x00a02758 },
+};
+
 static u32 iwl_dump_prph(struct iwl_trans *trans,
-			 struct iwl_fw_error_dump_data **data)
+			 struct iwl_fw_error_dump_data **data,
+			 const struct iwl_prph_range *iwl_prph_dump_addr,
+			 u32 range_len)
 {
 	struct iwl_fw_error_dump_prph *prph;
 	unsigned long flags;
@@ -449,7 +461,7 @@ static u32 iwl_dump_prph(struct iwl_trans *trans,
 	if (!iwl_trans_grab_nic_access(trans, &flags))
 		return 0;
 
-	for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
+	for (i = 0; i < range_len; i++) {
 		/* The range includes both boundaries */
 		int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
 			 iwl_prph_dump_addr[i].start + 4;
@@ -572,16 +584,31 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		}
 
 		/* Make room for PRPH registers */
-		for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
+		for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr_comm); i++) {
 			/* The range includes both boundaries */
-			int num_bytes_in_chunk = iwl_prph_dump_addr[i].end -
-				iwl_prph_dump_addr[i].start + 4;
+			int num_bytes_in_chunk =
+				iwl_prph_dump_addr_comm[i].end -
+				iwl_prph_dump_addr_comm[i].start + 4;
 
 			prph_len += sizeof(*dump_data) +
 				sizeof(struct iwl_fw_error_dump_prph) +
 				num_bytes_in_chunk;
 		}
 
+		if (mvm->cfg->mq_rx_supported) {
+			for (i = 0; i <
+				ARRAY_SIZE(iwl_prph_dump_addr_9000); i++) {
+				/* The range includes both boundaries */
+				int num_bytes_in_chunk =
+					iwl_prph_dump_addr_9000[i].end -
+					iwl_prph_dump_addr_9000[i].start + 4;
+
+				prph_len += sizeof(*dump_data) +
+					sizeof(struct iwl_fw_error_dump_prph) +
+					num_bytes_in_chunk;
+			}
+		}
+
 		if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000)
 			radio_len = sizeof(*dump_data) + RADIO_REG_MAX_READ;
 	}
@@ -769,8 +796,16 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		}
 	}
 
-	if (prph_len)
-		iwl_dump_prph(mvm->trans, &dump_data);
+	if (prph_len) {
+		iwl_dump_prph(mvm->trans, &dump_data,
+			      iwl_prph_dump_addr_comm,
+			      ARRAY_SIZE(iwl_prph_dump_addr_comm));
+
+		if (mvm->cfg->mq_rx_supported)
+			iwl_dump_prph(mvm->trans, &dump_data,
+				      iwl_prph_dump_addr_9000,
+				      ARRAY_SIZE(iwl_prph_dump_addr_9000));
+	}
 
 dump_trans_data:
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(mvm->trans,
-- 
2.8.1

