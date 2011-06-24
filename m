Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab1FXTVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:21:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlagn: Fix a bug introduced by the HUGE command removal
Date: Fri, 24 Jun 2011 11:49:33 -0700
Message-Id: <1308941374-29323-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_212130_577821_E744D1F7)
In-Reply-To: <1308941374-29323-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308941374-29323-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since we don't have HUGE command any more, there is no point in adding 1
to the num of slots in the command queue. Doing so is buggy and might corrupt
memory.

Bug introduced by 4ce7cc2b09553a91d4aea014c39674685715173a
iwlagn: support multiple TBs per command

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 686e176..157a642 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -535,12 +535,7 @@ out_free_arrays:
 void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 			int slots_num, u32 txq_id)
 {
-	int actual_slots = slots_num;
-
-	if (txq_id == priv->cmd_queue)
-		actual_slots++;
-
-	memset(txq->meta, 0, sizeof(struct iwl_cmd_meta) * actual_slots);
+	memset(txq->meta, 0, sizeof(struct iwl_cmd_meta) * slots_num);
 
 	txq->need_update = 0;
 
-- 
1.7.0.4

