Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1EMTin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/13] iwlagn: remove unused pad argument
Date: Fri, 13 May 2011 12:13:20 -0700
Message-Id: <1305314010-18073-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213849_287780_FDB57A34)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The pad argument to iwlagn_txq_free_tfd
isn't used, remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 --
 drivers/net/wireless/iwlwifi/iwl-tx.c     |    5 ++---
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index d34e103..9acf0e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -750,10 +750,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	spin_unlock(&priv->sta_lock);
 
 	/* Attach buffers to TFD */
-	iwlagn_txq_attach_buf_to_tfd(priv, txq, txcmd_phys, firstlen, 1, 0);
+	iwlagn_txq_attach_buf_to_tfd(priv, txq, txcmd_phys, firstlen, 1);
 	if (secondlen > 0)
 		iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr,
-					     secondlen, 0, 0);
+					     secondlen, 0);
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 				offsetof(struct iwl_tx_cmd, scratch);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 269e0c4..fc7dc06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -194,7 +194,7 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv);
 void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 struct iwl_tx_queue *txq,
-				 dma_addr_t addr, u16 len, u8 reset, u8 pad);
+				 dma_addr_t addr, u16 len, u8 reset);
 void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			      struct ieee80211_tx_info *info);
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9daf964..38254bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -48,8 +48,6 @@
 #include "iwl-agn-rs.h"
 #include "iwl-agn-tt.h"
 
-#define U32_PAD(n)		((4-(n))&0x3)
-
 struct iwl_tx_queue;
 
 /* CT-KILL constants */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 302284b..a47558f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -182,7 +182,7 @@ void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len,
-				 u8 reset, u8 pad)
+				 u8 reset)
 {
 	struct iwl_queue *q;
 	struct iwl_tfd *tfd, *tfd_tmp;
@@ -702,8 +702,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	trace_iwlwifi_dev_hcmd(priv, &out_cmd->hdr, fix_size, cmd->flags);
 
-	iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr, fix_size, 1,
-				     U32_PAD(cmd->len[0]));
+	iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr, fix_size, 1);
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-- 
1.7.0.4

