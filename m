Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5161 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab1F0Pgx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 11:36:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/2] iwlagn: fix cmd queue unmap
Date: Mon, 27 Jun 2011 08:04:34 -0700
Message-Id: <1309187075-3879-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110627_173657_836432_79E90502)
In-Reply-To: <1309187075-3879-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309187075-3879-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we stop the device while a command is in
flight that uses multiple TBs, we can leak the
DMA buffers for the second and higher TBs. Fix
this by using iwlagn_unmap_tfd() as we do when
we normally recover the entry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 157a642..8f20065 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -310,10 +310,7 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 		i = get_cmd_index(q, q->read_ptr);
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
-			pci_unmap_single(priv->pci_dev,
-					 dma_unmap_addr(&txq->meta[i], mapping),
-					 dma_unmap_len(&txq->meta[i], len),
-					 PCI_DMA_BIDIRECTIONAL);
+			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i]);
 			txq->meta[i].flags = 0;
 		}
 
-- 
1.7.0.4

