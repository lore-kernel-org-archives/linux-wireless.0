Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbZAWVm5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:57 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/15] iwlwifi: iwl_tx_queue_alloc : fix warning in printk formatting
Date: Fri, 23 Jan 2009 13:45:23 -0800
Message-Id: <1232747123-7261-16-git-send-email-reinette.chatre@intel.com> (sfid-20090123_230906_396754_CCAF9780)
In-Reply-To: <1232747123-7261-15-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-9-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-10-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-11-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-12-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-13-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-14-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-15-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch fix compilation warning in printk formatting
iwl_tx_queue_alloc function.
Cleanup the code a bit on the way.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 58118c8..7d2b6e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -278,6 +278,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 			      struct iwl_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
+	size_t tfd_sz = priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX;
 
 	/* Driver private data, only for Tx (not command) queues,
 	 * not shared with device. */
@@ -289,18 +290,16 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 				  "structures failed\n");
 			goto error;
 		}
-	} else
+	} else {
 		txq->txb = NULL;
+	}
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->tfds = pci_alloc_consistent(dev,
-			priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX,
-			&txq->q.dma_addr);
+	txq->tfds = pci_alloc_consistent(dev, tfd_sz, &txq->q.dma_addr);
 
 	if (!txq->tfds) {
-		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
-			  priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX);
+		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n", tfd_sz);
 		goto error;
 	}
 	txq->q.id = id;
-- 
1.5.4.3

