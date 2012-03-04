Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab2CDUnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 074/101] iwlwifi: transport's tx_agg_disable must be atomic
Date: Sun,  4 Mar 2012 11:29:28 -0800
Message-Id: <1330889395-533-75-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214501_694414_27C3E7A6)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

At least as long as it is called from the reclaim
flow (iwlagn_check_ratid_empty) it must be atomic.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 609949f..ed6ab44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -306,7 +306,7 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  *	ready and a successful ADDBA response has been received.
  *	May sleep
  * @tx_agg_disable: de-configure a Tx queue to send AMPDUs
- *	May sleep
+ *	Must be atomic
  * @free: release all the ressource for the transport layer itself such as
  *	irq, tasklet etc... From this point on, the device may not issue
  *	any interrupt (incl. RFKILL).
@@ -497,8 +497,6 @@ static inline int iwl_trans_reclaim(struct iwl_trans *trans, int sta_id,
 static inline int iwl_trans_tx_agg_disable(struct iwl_trans *trans,
 					    int sta_id, int tid)
 {
-	might_sleep();
-
 	if (trans->state != IWL_TRANS_FW_ALIVE)
 		IWL_ERR(trans, "%s bad state = %d", __func__, trans->state);
 
-- 
1.7.0.4

