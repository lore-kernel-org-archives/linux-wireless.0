Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030189Ab2CEUiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 23/33] iwlwifi: transport's tx_agg_alloc must not sleep
Date: Mon,  5 Mar 2012 11:24:41 -0800
Message-Id: <1330975491-19680-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213850_301993_AF9E78F1)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The annotation/documentation is wrong, we call
it in a context that can't sleep.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index e8ab8d8..0197f31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -229,7 +229,7 @@ static inline void iwl_free_resp(struct iwl_host_cmd *cmd)
  * @reclaim: free packet until ssn. Returns a list of freed packets.
  *	Must be atomic
  * @tx_agg_alloc: allocate resources for a TX BA session
- *	May sleep
+ *	Must be atomic
  * @tx_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
  *	ready and a successful ADDBA response has been received.
  *	May sleep
@@ -474,8 +474,6 @@ static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
 static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
 					 int sta_id, int tid)
 {
-	might_sleep();
-
 	if (trans->state != IWL_TRANS_FW_ALIVE)
 		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
-- 
1.7.0.4

