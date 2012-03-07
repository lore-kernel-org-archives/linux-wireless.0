Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338Ab2CGTGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:39 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 26/35] iwlwifi: configure transport layer from dvm op mode
Date: Wed,  7 Mar 2012 09:52:35 -0800
Message-Id: <1331142764-5750-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200715_844372_C052E402)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Introduce the iwl_trans_config struct which contains
state variables that only the op mode can determine,
but which the transport layer needs to know.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   10 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h |   14 ++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6ed2f78..83018ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1185,6 +1185,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	struct iwl_op_mode *op_mode;
 	u16 num_mac;
 	u32 ucode_flags;
+	struct iwl_trans_config trans_cfg;
 
 	/************************
 	 * 1. Allocating HW data
@@ -1205,7 +1206,14 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/* TODO: remove fw from shared data later */
 	priv->shrd->fw = fw;
 
-	iwl_trans_configure(trans(priv), op_mode);
+	/*
+	 * Populate the state variables that the transport layer needs
+	 * to know about.
+	 */
+	trans_cfg.op_mode = op_mode;
+
+	/* Configure transport layer */
+	iwl_trans_configure(trans(priv), &trans_cfg);
 
 	/* At this point both hw and priv are allocated. */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index ed6ab44..b6fd427 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -275,6 +275,16 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
 }
 
 /**
+ * struct iwl_trans_config - transport configuration
+ *
+ * @op_mode: pointer to the upper layer.
+ *	Must be set before any other call.
+ */
+struct iwl_trans_config {
+	struct iwl_op_mode *op_mode;
+};
+
+/**
  * struct iwl_trans_ops - transport specific operations
  *
  * All the handlers MUST be implemented
@@ -408,13 +418,13 @@ struct iwl_trans {
 };
 
 static inline void iwl_trans_configure(struct iwl_trans *trans,
-				       struct iwl_op_mode *op_mode)
+				       const struct iwl_trans_config *trans_cfg)
 {
 	/*
 	 * only set the op_mode for the moment. Later on, this function will do
 	 * more
 	 */
-	trans->op_mode = op_mode;
+	trans->op_mode = trans_cfg->op_mode;
 }
 
 static inline int iwl_trans_start_hw(struct iwl_trans *trans)
-- 
1.7.0.4

