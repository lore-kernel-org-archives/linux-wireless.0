Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZHZUPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 16:15:50 -0400
Subject: [PATCH] iwlwifi: fix ICT irq table endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 22:15:13 +0200
Message-Id: <1251317713.14690.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ICT IRQ table is a set of __le32 values, not u32 values,
so when reading it we need to take into account that it has
to be converted to CPU endianness. This was causing a lot of
trouble on my powerpc box where various things would simply
not work for no apparent reason with 5xxx cards, but worked
with 4965 -- which doesn't use the ICT table.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Oddly, the __le32 pointer doesn't help one bit, sparse
doesn't warn. Oh well. This makes lots of things work
better for me :)

 drivers/net/wireless/iwlwifi/iwl-core.c |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2009-08-26 20:37:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-dev.h	2009-08-26 20:37:06.000000000 +0200
@@ -1170,7 +1170,7 @@ struct iwl_priv {
 	struct iwl_hw_params hw_params;
 
 	/* INT ICT Table */
-	u32 *ict_tbl;
+	__le32 *ict_tbl;
 	dma_addr_t ict_tbl_dma;
 	dma_addr_t aligned_ict_tbl_dma;
 	int ict_index;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-08-26 20:39:14.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-08-26 20:40:36.000000000 +0200
@@ -1823,7 +1823,7 @@ int iwl_reset_ict(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_disable_interrupts(priv);
 
-	memset(&priv->ict_tbl[0],0, sizeof(u32) * ICT_COUNT);
+	memset(&priv->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
 
 	val = priv->aligned_ict_tbl_dma >> PAGE_SHIFT;
 
@@ -1901,13 +1901,13 @@ irqreturn_t iwl_isr_ict(int irq, void *d
 	/* read all entries that not 0 start with ict_index */
 	while (priv->ict_tbl[priv->ict_index]) {
 
-		val |= priv->ict_tbl[priv->ict_index];
+		val |= le32_to_cpu(priv->ict_tbl[priv->ict_index]);
 		IWL_DEBUG_ISR(priv, "ICT index %d value 0x%08X\n",
-					priv->ict_index,
-					priv->ict_tbl[priv->ict_index]);
+				priv->ict_index,
+				le32_to_cpu(priv->ict_tbl[priv->ict_index]));
 		priv->ict_tbl[priv->ict_index] = 0;
 		priv->ict_index = iwl_queue_inc_wrap(priv->ict_index,
-								ICT_COUNT);
+						     ICT_COUNT);
 
 	}
 


