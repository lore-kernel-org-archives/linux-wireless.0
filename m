Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52445 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbXKGGGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 01:06:31 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/5] iwl4965: fix cannot find a suitable rate issue
Date: Tue,  6 Nov 2007 22:06:25 -0800
Message-Id: <11944155913421-git-send-email-reinette.chatre@intel.com> (sfid-20071107_060637_662745_F7D91B75)
In-Reply-To: <1194415589137-git-send-email-reinette.chatre@intel.com>
References: <11944155883607-git-send-email-reinette.chatre@intel.com>
 <1194415589137-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

This patch fixes the iwl4965 problem for "Can not find a suitable rate
issues." by making rs_switch_to_mimo and rs_switch_to_siso functions
return -1 when CONFIG_IWL4965_HT is not selected. They used to return 0,
which means we can switch to HT rate causing the rate scale problem and
the error message.

The patch also fix another bug reported by Ben Cahill that it uses wrong
value for max_success_limit.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 5189788..19d1b05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -782,7 +782,7 @@ static void rs_set_stay_in_table(u8 is_legacy,
 	if (is_legacy) {
 		lq_data->table_count_limit = IWL_LEGACY_TABLE_COUNT;
 		lq_data->max_failure_limit = IWL_LEGACY_FAILURE_LIMIT;
-		lq_data->max_success_limit = IWL_LEGACY_TABLE_COUNT;
+		lq_data->max_success_limit = IWL_LEGACY_SUCCESS_LIMIT;
 	} else {
 		lq_data->table_count_limit = IWL_NONE_LEGACY_TABLE_COUNT;
 		lq_data->max_failure_limit = IWL_NONE_LEGACY_FAILURE_LIMIT;
@@ -937,9 +937,10 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate.rate_n_flags, is_green);
-
-#endif				/*CONFIG_IWL4965_HT */
 	return 0;
+#else
+	return -1;
+#endif				/*CONFIG_IWL4965_HT */
 }
 
 static int rs_switch_to_siso(struct iwl_priv *priv,
@@ -991,9 +992,11 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	rs_mcs_from_tbl(&tbl->current_rate, tbl, rate, is_green);
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate.rate_n_flags, is_green);
+	return 0;
+#else
+	return -1;
 
 #endif				/*CONFIG_IWL4965_HT */
-	return 0;
 }
 
 static int rs_move_legacy_other(struct iwl_priv *priv,
@@ -1282,7 +1285,7 @@ static void rs_stay_in_table(struct iwl_rate_scale_priv *lq_data)
 			lq_data->total_failed = 0;
 			lq_data->total_success = 0;
 			lq_data->flush_timer = 0;
-		} else if (lq_data->table_count > 0) {
+		} else {
 			lq_data->table_count++;
 			if (lq_data->table_count >=
 			    lq_data->table_count_limit) {
-- 
1.5.2.5
