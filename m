Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab2B0XTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/24] iwlwifi: virtualize op_mode's free skb
Date: Mon, 27 Feb 2012 14:07:33 -0800
Message-Id: <1330380468-17674-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_002021_426866_49287584)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This handler allows the transport layer to free an skb from the
op_mode. This can happen when the driver is stopped while Tx
packets are pending in the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    3 +++
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c          |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |   12 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    1 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   13 +++++++++++++
 7 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dbef0f4..ac62010 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1170,6 +1170,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans)
 	priv->shrd = trans->shrd;
 	priv->shrd->priv = priv;
 
+	iwl_trans_configure(trans(priv), op_mode);
+
 	/* At this point both hw and priv are allocated. */
 
 	SET_IEEE80211_DEV(priv->hw, trans(priv)->dev);
@@ -1383,6 +1385,7 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
+	.free_skb = iwl_free_skb,
 };
 
 /*****************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 79894ac..00253f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -80,6 +80,7 @@ static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
 void iwl_down(struct iwl_priv *priv);
 void iwl_cancel_deferred_work(struct iwl_priv *priv);
 void iwlagn_prepare_restart(struct iwl_priv *priv);
+void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f52d545..675464a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -41,6 +41,7 @@
 #include "iwl-shared.h"
 #include "iwl-agn.h"
 #include "iwl-trans.h"
+#include "iwl-wifi.h"
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
@@ -1464,8 +1465,9 @@ void iwl_nic_config(struct iwl_priv *priv)
 	cfg(priv)->lib->nic_config(priv);
 }
 
-void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb)
+void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb)
 {
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	struct ieee80211_tx_info *info;
 
 	info = IEEE80211_SKB_CB(skb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index c85c8dc..59dd307 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -65,6 +65,7 @@
 
 struct iwl_op_mode;
 struct iwl_trans;
+struct sk_buff;
 
 /**
  * struct iwl_op_mode_ops - op_mode specific operations
@@ -75,10 +76,15 @@ struct iwl_trans;
  *	May sleep
  * @stop: stop the op_mode
  *	May sleep
+ * @free_skb: allows the transport layer to free skbs that haven't been
+ *	reclaimed by the op_mode. This can happen when the driver is freed and
+ *	there are Tx packets pending in the transport layer.
+ *	Must be atomic
  */
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans);
 	void (*stop)(struct iwl_op_mode *op_mode);
+	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 };
 
 /**
@@ -100,6 +106,12 @@ static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
 	op_mode->ops->stop(op_mode);
 }
 
+static inline void iwl_op_mode_free_skb(struct iwl_op_mode *op_mode,
+					struct sk_buff *skb)
+{
+	op_mode->ops->free_skb(op_mode, skb);
+}
+
 /*****************************************************
 * Op mode layers implementations
 ******************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 635e3eb..eff9360 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -540,7 +540,6 @@ int __must_check iwl_rx_dispatch(struct iwl_priv *priv,
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
 void iwl_nic_config(struct iwl_priv *priv);
-void iwl_free_skb(struct iwl_priv *priv, struct sk_buff *skb);
 void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 const char *get_cmd_string(u8 cmd);
 bool iwl_check_for_ct_kill(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index a3cebd7..bca0f4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -35,6 +35,7 @@
 #include "iwl-prph.h"
 #include "iwl-io.h"
 #include "iwl-agn-hw.h"
+#include "iwl-op-mode.h"
 #include "iwl-trans-pcie-int.h"
 
 #define IWL_TX_CRC_SIZE 4
@@ -229,7 +230,7 @@ void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 		 * freed and that the queue is not empty - free the skb
 		 */
 		if (skb) {
-			iwl_free_skb(priv(trans), skb);
+			iwl_op_mode_free_skb(trans->op_mode, skb);
 			txq->skbs[index] = NULL;
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index f423286..fbb09f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -114,6 +114,7 @@
 
 struct iwl_priv;
 struct iwl_shared;
+struct iwl_op_mode;
 
 /**
  * DOC: Host command section
@@ -312,6 +313,7 @@ enum iwl_trans_state {
  * struct iwl_trans - transport common data
  *
  * @ops - pointer to iwl_trans_ops
+ * @op_mode - pointer to the op_mode
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
  * @hcmd_lock: protects HCMD
  * @reg_lock - protect hw register access
@@ -327,6 +329,7 @@ enum iwl_trans_state {
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
+	struct iwl_op_mode *op_mode;
 	struct iwl_shared *shrd;
 	enum iwl_trans_state state;
 	spinlock_t hcmd_lock;
@@ -350,6 +353,16 @@ struct iwl_trans {
 	char trans_specific[0] __aligned(sizeof(void *));
 };
 
+static inline void iwl_trans_configure(struct iwl_trans *trans,
+				       struct iwl_op_mode *op_mode)
+{
+	/*
+	 * only set the op_mode for the moment. Later on, this function will do
+	 * more
+	 */
+	trans->op_mode = op_mode;
+}
+
 static inline int iwl_trans_start_hw(struct iwl_trans *trans)
 {
 	might_sleep();
-- 
1.7.0.4

