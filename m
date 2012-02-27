Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab2B0XTG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/24] iwlwifi: virtualize op_mode's rx
Date: Mon, 27 Feb 2012 14:07:34 -0800
Message-Id: <1330380468-17674-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_002005_092083_8F7D39DB)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is the op_mode's Rx handler.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c        |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h           |    3 +++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |   13 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    5 -----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    3 ++-
 6 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index aee7d06..30bb5bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1141,10 +1141,11 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 
 }
 
-int iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
+int iwl_rx_dispatch(struct iwl_op_mode *op_mode, struct iwl_rx_mem_buffer *rxb,
 		     struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
 	int err = 0;
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ac62010..bafa546 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1385,6 +1385,7 @@ static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 const struct iwl_op_mode_ops iwl_dvm_ops = {
 	.start = iwl_op_mode_dvm_start,
 	.stop = iwl_op_mode_dvm_stop,
+	.rx = iwl_rx_dispatch,
 	.free_skb = iwl_free_skb,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 00253f3..337e098 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -81,6 +81,9 @@ void iwl_down(struct iwl_priv *priv);
 void iwl_cancel_deferred_work(struct iwl_priv *priv);
 void iwlagn_prepare_restart(struct iwl_priv *priv);
 void iwl_free_skb(struct iwl_op_mode *op_mode, struct sk_buff *skb);
+int __must_check iwl_rx_dispatch(struct iwl_op_mode *op_mode,
+				 struct iwl_rx_mem_buffer *rxb,
+				 struct iwl_device_cmd *cmd);
 
 /* MAC80211 */
 struct ieee80211_hw *iwl_alloc_all(void);
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 59dd307..b0272fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -66,6 +66,8 @@
 struct iwl_op_mode;
 struct iwl_trans;
 struct sk_buff;
+struct iwl_device_cmd;
+struct iwl_rx_mem_buffer;
 
 /**
  * struct iwl_op_mode_ops - op_mode specific operations
@@ -76,6 +78,8 @@ struct sk_buff;
  *	May sleep
  * @stop: stop the op_mode
  *	May sleep
+ * @rx: Rx notification to the op_mode. rxb is the Rx buffer itself. Cmd is the
+ *	HCMD the this Rx responds to.
  * @free_skb: allows the transport layer to free skbs that haven't been
  *	reclaimed by the op_mode. This can happen when the driver is freed and
  *	there are Tx packets pending in the transport layer.
@@ -84,6 +88,8 @@ struct sk_buff;
 struct iwl_op_mode_ops {
 	struct iwl_op_mode *(*start)(struct iwl_trans *trans);
 	void (*stop)(struct iwl_op_mode *op_mode);
+	int (*rx)(struct iwl_op_mode *op_mode, struct iwl_rx_mem_buffer *rxb,
+		  struct iwl_device_cmd *cmd);
 	void (*free_skb)(struct iwl_op_mode *op_mode, struct sk_buff *skb);
 };
 
@@ -106,6 +112,13 @@ static inline void iwl_op_mode_stop(struct iwl_op_mode *op_mode)
 	op_mode->ops->stop(op_mode);
 }
 
+static inline int iwl_op_mode_rx(struct iwl_op_mode *op_mode,
+				  struct iwl_rx_mem_buffer *rxb,
+				  struct iwl_device_cmd *cmd)
+{
+	return op_mode->ops->rx(op_mode, rxb, cmd);
+}
+
 static inline void iwl_op_mode_free_skb(struct iwl_op_mode *op_mode,
 					struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index eff9360..b63423f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -532,11 +532,6 @@ enum iwl_rxon_context_id {
 	NUM_IWL_RXON_CTX
 };
 
-struct iwl_device_cmd;
-int __must_check iwl_rx_dispatch(struct iwl_priv *priv,
-				 struct iwl_rx_mem_buffer *rxb,
-				 struct iwl_device_cmd *cmd);
-
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
 void iwl_nic_config(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 6715d04..5791311 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -35,6 +35,7 @@
 #include "iwl-io.h"
 #include "iwl-trans-pcie-int.h"
 #include "iwl-wifi.h"
+#include "iwl-op-mode.h"
 
 #ifdef CONFIG_IWLWIFI_IDI
 #include "iwl-amfh.h"
@@ -460,7 +461,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
 		     get_cmd_string(pkt->hdr.cmd));
 
-		err = iwl_rx_dispatch(priv(trans), rxb, cmd);
+		err = iwl_op_mode_rx(trans->op_mode, rxb, cmd);
 
 		/*
 		 * XXX: After here, we should always check rxb->page
-- 
1.7.0.4

