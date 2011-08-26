Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44772 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1HZGxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 31/60] iwlagn: fix the check of IWLAGN_FIRST_AMPDU_QUEUE
Date: Thu, 25 Aug 2011 23:11:03 -0700
Message-Id: <1314339092-20797-32-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085418_044102_870B3C6E)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) !=
						IWLAGN_FIRST_AMPDU_QUEUE);

This check can be buggy. IWLAGN_FIRST_AMPDU_QUEUE has to be greater than the
ARRAY_SIZE of iwlagn_ipan_queue_to_tx_fifo.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 0e04b51..a2950a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -875,9 +875,9 @@ static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
 
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) !=
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) <
 						IWLAGN_FIRST_AMPDU_QUEUE);
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) !=
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) <
 						IWLAGN_FIRST_AMPDU_QUEUE);
 
 	for (i = 0; i < IWLAGN_FIRST_AMPDU_QUEUE; i++) {
-- 
1.7.0.4

