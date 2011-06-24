Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1FXTjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:39:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/5] iwlagn: fix cmd queue unmap
Date: Fri, 24 Jun 2011 12:07:14 -0700
Message-Id: <1308942437-6039-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_213924_147751_56B487BA)
In-Reply-To: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
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
index fd8aee9..cf8fc9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -309,10 +309,7 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 		i = get_cmd_index(q, q->read_ptr);
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
-			dma_unmap_single(priv->bus.dev,
-					 dma_unmap_addr(&txq->meta[i], mapping),
-					 dma_unmap_len(&txq->meta[i], len),
-					 DMA_BIDIRECTIONAL);
+			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i]);
 			txq->meta[i].flags = 0;
 		}
 
-- 
1.7.0.4

