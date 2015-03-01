Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbbCATcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:06 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/31] iwlwifi: mvm: rs: print single stream params via debugfs
Date: Sun,  1 Mar 2015 21:31:21 +0200
Message-Id: <1425238304-498-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203210_370473_ACF2C2B6)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Add this to the info printed when reading rate_scale_table.
Useful for debugging.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 43f807f..6578498 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3323,6 +3323,7 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	struct iwl_mvm *mvm;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct rs_rate *rate = &tbl->rate;
+	u32 ss_params;
 	mvm = lq_sta->pers.drv;
 	buff = kmalloc(2048, GFP_KERNEL);
 	if (!buff)
@@ -3369,6 +3370,16 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			lq_sta->lq.agg_frame_cnt_limit);
 
 	desc += sprintf(buff+desc, "reduced tpc=%d\n", lq_sta->lq.reduced_tpc);
+	ss_params = le32_to_cpu(lq_sta->lq.ss_params);
+	desc += sprintf(buff+desc, "single stream params: %s%s%s%s\n",
+			(ss_params & LQ_SS_PARAMS_VALID) ?
+			"VALID," : "INVALID",
+			(ss_params & LQ_SS_BFER_ALLOWED) ?
+			"BFER," : "",
+			(ss_params & LQ_SS_STBC_1SS_ALLOWED) ?
+			"STBC," : "",
+			(ss_params & LQ_SS_FORCE) ?
+			"FORCE" : "");
 	desc += sprintf(buff+desc,
 			"Start idx [0]=0x%x [1]=0x%x [2]=0x%x [3]=0x%x\n",
 			lq_sta->lq.initial_rate_index[0],
-- 
1.9.1

