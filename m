Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57618 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbYICDbg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ian Schram <ischram@telenet.be>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 31/39] iwlwifi: fix memory allocation of TX command
Date: Wed,  3 Sep 2008 11:26:51 +0800
Message-Id: <1220412419-15404-32-git-send-email-yi.zhu@intel.com> (sfid-20080903_055044_311892_58260CBA)
In-Reply-To: <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes GFP_DMA from allocation tx command buffers
GFP_DMA allows allocation only for memory under 16M which causes
allocation problems suspend/resume flows.

Using kmalloc is temporal solution and some consistent/coherent
allocation schema will be more correct. Since iwlwifi hardware
supports 64bit address this solution should work on x86 (32 and
64bit) for now. This patch also fixes memory freeing in error path.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ian Schram <ischram@telenet.be>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 6cba5e9..68567fa 100644
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
@@ -426,19 +425,16 @@ static int iwl_tx_queue_init(struct iwl_priv *priv,
 				continue;
 		}
 
-		txq->cmd[i] = kmalloc(len, GFP_KERNEL | GFP_DMA);
+		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
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

