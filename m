Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbHRH6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/26] iwlwifi: make sure d3_suspend/resume ops exist
Date: Tue, 18 Aug 2015 10:57:23 +0300
Message-Id: <1439884656-18146-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095818_905799_90CF06FD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliadx.peller@intel.com>

We added calls to d3_suspend/resume trans ops during the
suspend/resume flow.

However, the wrapper code didn't verify the trans ops were
actually defined, resulting in panic when they were not
(such as in the case of sdio trans)

Fixes: 6dfb36c89dc2 ("iwlwifi: call d3_suspend/resume in d0i3 case as well")

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 9d8b5cb..c829c50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -810,7 +810,8 @@ static inline void iwl_trans_stop_device(struct iwl_trans *trans)
 static inline void iwl_trans_d3_suspend(struct iwl_trans *trans, bool test)
 {
 	might_sleep();
-	trans->ops->d3_suspend(trans, test);
+	if (trans->ops->d3_suspend)
+		trans->ops->d3_suspend(trans, test);
 }
 
 static inline int iwl_trans_d3_resume(struct iwl_trans *trans,
@@ -818,6 +819,9 @@ static inline int iwl_trans_d3_resume(struct iwl_trans *trans,
 				      bool test)
 {
 	might_sleep();
+	if (!trans->ops->d3_resume)
+		return 0;
+
 	return trans->ops->d3_resume(trans, status, test);
 }
 
-- 
2.1.4

