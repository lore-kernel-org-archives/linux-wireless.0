Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0KLHnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 02:43:35 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/3] iwl3945: remove unused len_org variable
Date: Fri, 12 Nov 2010 08:47:05 +0100
Message-Id: <1289548027-3383-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 931c546..f2ce7dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -475,7 +475,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	int txq_id = skb_get_queue_mapping(skb);
-	u16 len, idx, len_org, hdr_len; /* TODO: len_org is not used */
+	u16 len, idx, hdr_len;
 	u8 id;
 	u8 unicast;
 	u8 sta_id;
@@ -612,15 +612,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	 */
 	len = sizeof(struct iwl3945_tx_cmd) +
 			sizeof(struct iwl_cmd_header) + hdr_len;
-
-	len_org = len;
 	len = (len + 3) & ~3;
 
-	if (len_org != len)
-		len_org = 1;
-	else
-		len_org = 0;
-
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
 	txcmd_phys = pci_map_single(priv->pci_dev, &out_cmd->hdr,
-- 
1.7.1

