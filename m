Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZCKSNB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:01 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/8] iwl3945: unmap previously mapped memory
Date: Wed, 11 Mar 2009 11:17:58 -0700
Message-Id: <1236795481-12757-6-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191314_835703_B990B59A)
In-Reply-To: <1236795481-12757-5-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

During preparation of TX we create DMA mapping to TX command as part of
preparing the TFD. This mapping needs to be cleared at the time TFD is
freed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 9e6f9ec..ba7e720 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -741,7 +741,8 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)txq->tfds;
-	struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
+	int index = txq->q.read_ptr;
+	struct iwl3945_tfd *tfd = &tfd_tmp[index];
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
 	int counter;
@@ -759,6 +760,13 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		return;
 	}
 
+	/* Unmap tx_cmd */
+	if (counter)
+		pci_unmap_single(dev,
+				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
+				pci_unmap_len(&txq->cmd[index]->meta, len),
+				PCI_DMA_TODEVICE);
+
 	/* unmap chunks if any */
 
 	for (i = 1; i < counter; i++) {
-- 
1.5.6.3

