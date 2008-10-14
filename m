Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbYJNTfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:35:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 9/9] iwlwifi: tx command must run on same tfd as packet
Date: Tue, 14 Oct 2008 12:32:49 -0700
Message-Id: <1224012769-8920-10-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213531_636907_5E73DED1)
In-Reply-To: <1224012769-8920-9-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-5-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-6-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-7-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-8-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch makes clear that tx command is attached to the same tfd as
the tx packet

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 2fadb8f..f7dc509 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -817,7 +817,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	dma_addr_t scratch_phys;
-	u16 len, idx, len_org;
+	u16 len, len_org;
 	u16 seq_number = 0;
 	__le16 fc;
 	u8 hdr_len, unicast;
@@ -906,14 +906,13 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Set up first empty TFD within this queue's circular TFD buffer */
 	tfd = &txq->tfds[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
-	idx = get_cmd_index(q, q->write_ptr, 0);
 
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
 	txq->txb[q->write_ptr].skb[0] = skb;
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_cmd = txq->cmd[idx];
+	out_cmd = txq->cmd[q->write_ptr];
 	tx_cmd = &out_cmd->cmd.tx;
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(tx_cmd, 0, sizeof(struct iwl_tx_cmd));
-- 
1.5.4.3

