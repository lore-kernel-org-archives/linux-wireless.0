Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60714 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751149AbdFBL0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:32 +0300
Message-Id: <20170602112553.2466-5-luca@coelho.fi> (sfid-20170602_132638_159300_A34C6879)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: mvm: fix endianness in lq_cmd declaration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This member doesn't seem to be used, so this doesn't really
fix anything, but it's better to have the right type there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
index 1b7d265ffb0a..019a9a92a1ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h
@@ -387,7 +387,7 @@ enum {
 struct iwl_lq_cmd {
 	u8 sta_id;
 	u8 reduced_tpc;
-	u16 control;
+	__le16 control;
 	/* LINK_QUAL_GENERAL_PARAMS_API_S_VER_1 */
 	u8 flags;
 	u8 mimo_delim;
-- 
2.11.0
