Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1GHQUg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/21] iwlagn: remove code duplication
Date: Fri,  8 Jul 2011 08:46:13 -0700
Message-Id: <1310139989-27661-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182041_552405_69D6793E)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Code duplication was needed during the move, not needed any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   21 ---------------------
 drivers/net/wireless/iwlwifi/iwl-trans.c  |    1 -
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index c420750..f77f7e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -831,27 +831,6 @@ drop_unlock_priv:
 	return -1;
 }
 
-static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
-				    struct iwl_dma_ptr *ptr, size_t size)
-{
-	ptr->addr = dma_alloc_coherent(priv->bus.dev, size,
-				       &ptr->dma, GFP_KERNEL);
-	if (!ptr->addr)
-		return -ENOMEM;
-	ptr->size = size;
-	return 0;
-}
-
-static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
-				    struct iwl_dma_ptr *ptr)
-{
-	if (unlikely(!ptr->addr))
-		return;
-
-	dma_free_coherent(priv->bus.dev, ptr->size, ptr->addr, ptr->dma);
-	memset(ptr, 0, sizeof(*ptr));
-}
-
 /*
  * Find first available (lowest unused) Tx Queue, mark it "active".
  * Called only when finding queue for aggregation.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 81716fd..de627f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -197,7 +197,6 @@ static int iwl_trans_rx_stop(struct iwl_priv *priv)
 			    FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 }
 
-/* TODO:remove this code duplication */
 static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
 				    struct iwl_dma_ptr *ptr, size_t size)
 {
-- 
1.7.0.4

