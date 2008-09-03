Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbYICDW6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:22:58 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ian Schram <ischram@telenet.be>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 7/9] iwlwifi: fix Tx cmd memory allocation failure handling
Date: Wed,  3 Sep 2008 11:18:48 +0800
Message-Id: <1220411930-15216-8-git-send-email-yi.zhu@intel.com> (sfid-20080903_052308_744240_8B3ACC02)
In-Reply-To: <1220411930-15216-7-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-2-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-4-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-6-git-send-email-yi.zhu@intel.com>
 <1220411930-15216-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch "iwlwifi: do not use GFP_DMA in iwl_tx_queue_init" removes
GFP_DMA from allocation tx command buffers. GFP_DMA allows allocation
only for memory under 16M which causes allocation problems
suspend/resume flows.

Using kmalloc is temporal solution and some consistent/coherent
allocation schema will be more correct. Since iwlwifi hardware
supports 64bit address this solution should work on x86 (32 and
64bit) for now.

This patch fixes memory freeing problem in the previous patch.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index ff879d4..78b1a7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -402,12 +402,11 @@ static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 /**
  * iwl_tx_queue_init - Allocate and initialize one tx/cmd queue
  */
-static int iwl_tx_queue_init(struct iwl_priv *priv,
-			     struct iwl_tx_queue *txq,
+static int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 			     int slots_num, u32 txq_id)
 {
 	int i, len;
-	int rc = 0;
+	int ret;
 
 	/*
 	 * Alloc buffer array for commands (Tx or other types of commands).
@@ -428,17 +427,14 @@ static int iwl_tx_queue_init(struct iwl_priv *priv,
 
 		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
 		if (!txq->cmd[i])
-			return -ENOMEM;
+			goto err;
 	}
 
 	/* Alloc driver data array and TFD circular buffer */
-	rc = iwl_tx_queue_alloc(priv, txq, txq_id);
-	if (rc) {
-		for (i = 0; i < slots_num; i++)
-			kfree(txq->cmd[i]);
+	ret = iwl_tx_queue_alloc(priv, txq, txq_id);
+	if (ret)
+		goto err;
 
-		return -ENOMEM;
-	}
 	txq->need_update = 0;
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
@@ -452,6 +448,17 @@ static int iwl_tx_queue_init(struct iwl_priv *priv,
 	iwl_hw_tx_queue_init(priv, txq);
 
 	return 0;
+err:
+	for (i = 0; i < slots_num; i++) {
+		kfree(txq->cmd[i]);
+		txq->cmd[i] = NULL;
+	}
+
+	if (txq_id == IWL_CMD_QUEUE_NUM) {
+		kfree(txq->cmd[slots_num]);
+		txq->cmd[slots_num] = NULL;
+	}
+	return -ENOMEM;
 }
 /**
  * iwl_hw_txq_ctx_free - Free TXQ Context
-- 
1.5.3.6

