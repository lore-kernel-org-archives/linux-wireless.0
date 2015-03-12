Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbbCLNGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:07 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/49] iwlwifi: mvm: rs: improve ss_params debug print
Date: Thu, 12 Mar 2015 15:04:19 +0200
Message-Id: <1426165474-25586-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143419_130768_AD6D0707)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Make the print a bit more readable.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index d8dacb3..98edb18 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3373,13 +3373,13 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	ss_params = le32_to_cpu(lq_sta->lq.ss_params);
 	desc += sprintf(buff+desc, "single stream params: %s%s%s%s\n",
 			(ss_params & LQ_SS_PARAMS_VALID) ?
-			"VALID," : "INVALID",
+			"VALID" : "INVALID",
 			(ss_params & LQ_SS_BFER_ALLOWED) ?
-			"BFER," : "",
+			", BFER" : "",
 			(ss_params & LQ_SS_STBC_1SS_ALLOWED) ?
-			"STBC," : "",
+			", STBC" : "",
 			(ss_params & LQ_SS_FORCE) ?
-			"FORCE" : "");
+			", FORCE" : "");
 	desc += sprintf(buff+desc,
 			"Start idx [0]=0x%x [1]=0x%x [2]=0x%x [3]=0x%x\n",
 			lq_sta->lq.initial_rate_index[0],
-- 
1.9.1

