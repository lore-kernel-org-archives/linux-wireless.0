Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49775 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbZGIRdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:33:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6 2.6.31 and w-t] iwlwifi: only update byte count table during aggregation
Date: Thu,  9 Jul 2009 10:33:39 -0700
Message-Id: <1247160821-14989-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247160821-14989-4-git-send-email-reinette.chatre@intel.com>
References: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-2-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-3-git-send-email-reinette.chatre@intel.com>
 <1247160821-14989-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The byte count table is only used for aggregation. Updating it
in other cases caused fragmented frames to be dropped.

This fixes http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2004

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 753fca3..7073069 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -873,7 +873,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
+	if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
 						     le16_to_cpu(tx_cmd->len));
 
 	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
-- 
1.5.6.3

