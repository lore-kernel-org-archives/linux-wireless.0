Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53534 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1GUP0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.guy@intel.com>
Subject: [PATCH 01/25] iwlagn: add kick_nic API to transport layer
Date: Thu, 21 Jul 2011 07:50:04 -0700
Message-Id: <1311259828-8415-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172655_982595_D0D0E32D)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

kick_nic means to remove the RESET bit from the embedded CPU

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    3 +++
 drivers/net/wireless/iwlwifi/iwl-trans.c     |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h     |    5 +++++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index aebd5c7..8936300 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -494,8 +494,7 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		return ret;
 	}
 
-	/* Remove all resets to allow NIC to operate */
-	iwl_write32(priv, CSR_RESET, 0);
+	trans_kick_nic(priv);
 
 	/*
 	 * Some things may run in the background now, but we
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fddc236..d6d6fe9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1245,6 +1245,7 @@ struct iwl_trans;
  * @send_cmd_pdu:send a host command: flags can be CMD_*
  * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
  * @tx: send an skb
+ * @kick_nic: remove the RESET from the embedded CPU and let it run
  * @sync_irq: the upper layer will typically disable interrupt and call this
  *            handler. After this handler returns, it is guaranteed that all
  *            the ISR / tasklet etc... have finished running and the transport
@@ -1271,6 +1272,8 @@ struct iwl_trans_ops {
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx);
 
+	void (*kick_nic)(struct iwl_priv *priv);
+
 	void (*sync_irq)(struct iwl_priv *priv);
 	void (*free)(struct iwl_priv *priv);
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 7c748f6..639b469 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -952,6 +952,12 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return 0;
 }
 
+static void iwl_trans_kick_nic(struct iwl_priv *priv)
+{
+	/* Remove all resets to allow NIC to operate */
+	iwl_write32(priv, CSR_RESET, 0);
+}
+
 static void iwl_trans_sync_irq(struct iwl_priv *priv)
 {
 	/* wait to make sure we flush pending tasklet*/
@@ -980,6 +986,7 @@ static const struct iwl_trans_ops trans_ops = {
 
 	.get_tx_cmd = iwl_trans_get_tx_cmd,
 	.tx = iwl_trans_tx,
+	.kick_nic = iwl_trans_kick_nic,
 
 	.sync_irq = iwl_trans_sync_irq,
 	.free = iwl_trans_free,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 16cdb89..9a95049 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -119,6 +119,11 @@ static inline int trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return priv->trans.ops->tx(priv, skb, tx_cmd, txq_id, fc, ampdu, ctx);
 }
 
+static inline void trans_kick_nic(struct iwl_priv *priv)
+{
+	priv->trans.ops->kick_nic(priv);
+}
+
 static inline void trans_sync_irq(struct iwl_priv *priv)
 {
 	priv->trans.ops->sync_irq(priv);
-- 
1.7.0.4

