Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0H0Q4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/27] iwlwifi: move QoS into context
Date: Fri, 27 Aug 2010 09:59:35 -0700
Message-Id: <1282928395-32762-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since mac80211 doesn't currently enable/disable
QoS per interface, we can't yet do it properly,
but we can already prepare for it and move the
QoS data and command ID into the context struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   45 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   24 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 5 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d3714f0..007dede 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4203,6 +4203,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
+	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 1);
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a145d17..d5499db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -191,27 +191,27 @@ EXPORT_SYMBOL(iwl_alloc_all);
 /*
  * QoS  support
 */
-static void iwl_update_qos(struct iwl_priv *priv)
+static void iwl_update_qos(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	priv->qos_data.def_qos_parm.qos_flags = 0;
+	ctx->qos_data.def_qos_parm.qos_flags = 0;
 
-	if (priv->qos_data.qos_active)
-		priv->qos_data.def_qos_parm.qos_flags |=
+	if (ctx->qos_data.qos_active)
+		ctx->qos_data.def_qos_parm.qos_flags |=
 			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
 
 	if (priv->current_ht_config.is_ht)
-		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
+		ctx->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 
 	IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
-		      priv->qos_data.qos_active,
-		      priv->qos_data.def_qos_parm.qos_flags);
+		      ctx->qos_data.qos_active,
+		      ctx->qos_data.def_qos_parm.qos_flags);
 
-	iwl_send_cmd_pdu_async(priv, REPLY_QOS_PARAM,
+	iwl_send_cmd_pdu_async(priv, ctx->qos_cmd,
 			       sizeof(struct iwl_qosparam_cmd),
-			       &priv->qos_data.def_qos_parm, NULL);
+			       &ctx->qos_data.def_qos_parm, NULL);
 }
 
 #define MAX_BIT_RATE_40_MHZ 150 /* Mbps */
@@ -1584,6 +1584,7 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx;
 	unsigned long flags;
 	int q;
 
@@ -1603,13 +1604,21 @@ int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	priv->qos_data.def_qos_parm.ac[q].cw_min = cpu_to_le16(params->cw_min);
-	priv->qos_data.def_qos_parm.ac[q].cw_max = cpu_to_le16(params->cw_max);
-	priv->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
-	priv->qos_data.def_qos_parm.ac[q].edca_txop =
-			cpu_to_le16((params->txop * 32));
+	/*
+	 * MULTI-FIXME
+	 * This may need to be done per interface in nl80211/cfg80211/mac80211.
+	 */
+	for_each_context(priv, ctx) {
+		ctx->qos_data.def_qos_parm.ac[q].cw_min =
+			cpu_to_le16(params->cw_min);
+		ctx->qos_data.def_qos_parm.ac[q].cw_max =
+			cpu_to_le16(params->cw_max);
+		ctx->qos_data.def_qos_parm.ac[q].aifsn = params->aifs;
+		ctx->qos_data.def_qos_parm.ac[q].edca_txop =
+				cpu_to_le16((params->txop * 32));
 
-	priv->qos_data.def_qos_parm.ac[q].reserved1 = 0;
+		ctx->qos_data.def_qos_parm.ac[q].reserved1 = 0;
+	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -1751,8 +1760,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		unsigned long flags;
 
 		spin_lock_irqsave(&priv->lock, flags);
-		priv->qos_data.qos_active = bss_conf->qos;
-		iwl_update_qos(priv);
+		ctx->qos_data.qos_active = bss_conf->qos;
+		iwl_update_qos(priv, ctx);
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d36418c..0ee8f51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -643,19 +643,25 @@ static ssize_t iwl_dbgfs_qos_read(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
+	struct iwl_rxon_context *ctx;
 	int pos = 0, i;
-	char buf[256];
+	char buf[256 * NUM_IWL_RXON_CTX];
 	const size_t bufsz = sizeof(buf);
 
-	for (i = 0; i < AC_NUM; i++) {
-		pos += scnprintf(buf + pos, bufsz - pos,
-			"\tcw_min\tcw_max\taifsn\ttxop\n");
-		pos += scnprintf(buf + pos, bufsz - pos,
+	for_each_context(priv, ctx) {
+		pos += scnprintf(buf + pos, bufsz - pos, "context %d:\n",
+				 ctx->ctxid);
+		for (i = 0; i < AC_NUM; i++) {
+			pos += scnprintf(buf + pos, bufsz - pos,
+				"\tcw_min\tcw_max\taifsn\ttxop\n");
+			pos += scnprintf(buf + pos, bufsz - pos,
 				"AC[%d]\t%u\t%u\t%u\t%u\n", i,
-				priv->qos_data.def_qos_parm.ac[i].cw_min,
-				priv->qos_data.def_qos_parm.ac[i].cw_max,
-				priv->qos_data.def_qos_parm.ac[i].aifsn,
-				priv->qos_data.def_qos_parm.ac[i].edca_txop);
+				ctx->qos_data.def_qos_parm.ac[i].cw_min,
+				ctx->qos_data.def_qos_parm.ac[i].cw_max,
+				ctx->qos_data.def_qos_parm.ac[i].aifsn,
+				ctx->qos_data.def_qos_parm.ac[i].edca_txop);
+		}
+		pos += scnprintf(buf + pos, bufsz - pos, "\n");
 	}
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6a7e9ff..01a654e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1125,9 +1125,12 @@ struct iwl_rxon_context {
 
 	struct iwl_rxon_time_cmd timing;
 
+	struct iwl_qos_info qos_data;
+
 	u8 bcast_sta_id;
 
 	u8 rxon_cmd, rxon_assoc_cmd, rxon_timing_cmd;
+	u8 qos_cmd;
 };
 
 struct iwl_priv {
@@ -1418,8 +1421,6 @@ struct iwl_priv {
 
 	u32 inta_mask;
 
-	struct iwl_qos_info qos_data;
-
 	struct workqueue_struct *workqueue;
 
 	struct work_struct restart;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4321d97..09bca17 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4016,6 +4016,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_cmd = REPLY_RXON;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_timing_cmd = REPLY_RXON_TIMING;
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
+	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
-- 
1.7.0.4

