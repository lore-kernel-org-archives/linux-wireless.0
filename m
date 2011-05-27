Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298Ab1E0QIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:08:01 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/10] iwlwifi: disambiguate invalid DMA index warnings
Date: Fri, 27 May 2011 08:40:28 -0700
Message-Id: <1306510833-32049-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180809_447195_555BFD72)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

The exact same error message is used in three different functions in
iwlagn. Add the function name to the error string to disambiguate where
the error is coming from.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-tx.c      |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f803fb6..4ab77c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -408,9 +408,9 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 	unsigned long flags;
 
 	if ((index >= txq->q.n_bd) || (iwl_queue_used(&txq->q, index) == 0)) {
-		IWL_ERR(priv, "Read index for DMA queue txq_id (%d) index %d "
-			  "is out of range [0-%d] %d %d\n", txq_id,
-			  index, txq->q.n_bd, txq->q.write_ptr,
+		IWL_ERR(priv, "%s: Read index for DMA queue txq_id (%d) "
+			  "index %d is out of range [0-%d] %d %d\n", __func__,
+			  txq_id, index, txq->q.n_bd, txq->q.write_ptr,
 			  txq->q.read_ptr);
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 9acf0e9..631d0a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1231,9 +1231,9 @@ int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	struct ieee80211_hdr *hdr;
 
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
-		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
-			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->write_ptr, q->read_ptr);
+		IWL_ERR(priv, "%s: Read index for DMA queue txq id (%d), "
+			  "index %d is out of range [0-%d] %d %d.\n", __func__,
+			  txq_id, index, q->n_bd, q->write_ptr, q->read_ptr);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 686e176..1084fe0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -753,9 +753,9 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int idx)
 	int nfreed = 0;
 
 	if ((idx >= q->n_bd) || (iwl_queue_used(q, idx) == 0)) {
-		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
-			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  idx, q->n_bd, q->write_ptr, q->read_ptr);
+		IWL_ERR(priv, "%s: Read index for DMA queue txq id (%d), "
+			  "index %d is out of range [0-%d] %d %d.\n", __func__,
+			  txq_id, idx, q->n_bd, q->write_ptr, q->read_ptr);
 		return;
 	}
 
-- 
1.7.0.4

