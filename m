Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab1FVUYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 16:24:46 -0400
Subject: Re: [3.0 regression] DMAR faults in iwlagn
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lutomirski <luto@mit.edu>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com> (sfid-20110620_204449_827132_DD43A304)
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
	 (sfid-20110620_204449_827132_DD43A304)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 22:24:42 +0200
Message-ID: <1308774283.29571.24.camel@jlt3.sipsolutions.net> (sfid-20110622_222449_263549_431D3C5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy, could you try this patch?

I haven't tested it at all yet, it's kinda late here.

johannes

iwlagn: map command buffers BIDI

From: Johannes Berg <johannes.berg@intel.com>

Evidently, the device sometimes wants to write back
to command buffers, even if I see no reason why it
should. Allow it to do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c	2011-06-22 22:19:35.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c	2011-06-22 22:21:48.000000000 +0200
@@ -126,7 +126,7 @@ static inline u8 iwl_tfd_get_num_tbs(str
 }
 
 static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
-			     struct iwl_tfd *tfd)
+			     struct iwl_tfd *tfd, enum dma_data_direction dma_dir)
 {
 	int i;
 	int num_tbs;
@@ -150,7 +150,7 @@ static void iwlagn_unmap_tfd(struct iwl_
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
 		dma_unmap_single(priv->bus.dev, iwl_tfd_tb_get_addr(tfd, i),
-				iwl_tfd_tb_get_len(tfd, i), DMA_TO_DEVICE);
+				iwl_tfd_tb_get_len(tfd, i), dma_dir);
 }
 
 /**
@@ -166,7 +166,8 @@ void iwlagn_txq_free_tfd(struct iwl_priv
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 	int index = txq->q.read_ptr;
 
-	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index]);
+	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index],
+			 DMA_TO_DEVICE);
 
 	/* free SKB */
 	if (txq->txb) {
@@ -309,7 +310,8 @@ void iwl_cmd_queue_unmap(struct iwl_priv
 		i = get_cmd_index(q, q->read_ptr);
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
-			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i]);
+			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i],
+					 DMA_BIDIRECTIONAL);
 			txq->meta[i].flags = 0;
 		}
 
@@ -691,10 +693,11 @@ int iwl_enqueue_hcmd(struct iwl_priv *pr
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
 		phys_addr = dma_map_single(priv->bus.dev, (void *)cmd->data[i],
-					   cmd->len[i], DMA_TO_DEVICE);
+					   cmd->len[i], DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(priv->bus.dev, phys_addr)) {
 			iwlagn_unmap_tfd(priv, out_meta,
-					 &txq->tfds[q->write_ptr]);
+					 &txq->tfds[q->write_ptr],
+					 DMA_BIDIRECTIONAL);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -798,7 +801,7 @@ void iwl_tx_cmd_complete(struct iwl_priv
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
-	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index]);
+	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], DMA_BIDIRECTIONAL);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {


