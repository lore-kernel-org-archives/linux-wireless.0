Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36118 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751136AbdAWWEE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:04 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Johannes Berg <johannes.berg@intel.com>
Date: Tue, 24 Jan 2017 00:03:29 +0200
Message-Id: <20170123220350.25305-5-luca@coelho.fi> (sfid-20170123_230408_467989_D830B24A)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: mvm: make iwl_dump_prph() void
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The return value is never used, so make the function void.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 46ab6b9f680b..7df3c3f4749e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -406,17 +406,17 @@ static const struct iwl_prph_range iwl_prph_dump_addr_9000[] = {
 	{ .start = 0x00a02400, .end = 0x00a02758 },
 };
 
-static u32 iwl_dump_prph(struct iwl_trans *trans,
-			 struct iwl_fw_error_dump_data **data,
-			 const struct iwl_prph_range *iwl_prph_dump_addr,
-			 u32 range_len)
+static void iwl_dump_prph(struct iwl_trans *trans,
+			  struct iwl_fw_error_dump_data **data,
+			  const struct iwl_prph_range *iwl_prph_dump_addr,
+			  u32 range_len)
 {
 	struct iwl_fw_error_dump_prph *prph;
 	unsigned long flags;
-	u32 prph_len = 0, i;
+	u32 i;
 
 	if (!iwl_trans_grab_nic_access(trans, &flags))
-		return 0;
+		return;
 
 	for (i = 0; i < range_len; i++) {
 		/* The range includes both boundaries */
@@ -425,8 +425,6 @@ static u32 iwl_dump_prph(struct iwl_trans *trans,
 		int reg;
 		__le32 *val;
 
-		prph_len += sizeof(**data) + sizeof(*prph) + num_bytes_in_chunk;
-
 		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
 		(*data)->len = cpu_to_le32(sizeof(*prph) +
 					num_bytes_in_chunk);
@@ -444,8 +442,6 @@ static u32 iwl_dump_prph(struct iwl_trans *trans,
 	}
 
 	iwl_trans_release_nic_access(trans, &flags);
-
-	return prph_len;
 }
 
 /*
-- 
2.11.0
