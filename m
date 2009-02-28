Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13154 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZB1AQt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 19:16:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwl3945 : use iwl_activate_qos
Date: Fri, 27 Feb 2009 16:21:24 -0800
Message-Id: <1235780484-27979-7-git-send-email-reinette.chatre@intel.com> (sfid-20090228_011656_092880_F775E45C)
In-Reply-To: <1235780484-27979-6-git-send-email-reinette.chatre@intel.com>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-4-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-5-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

3945 can use iwl_activate_qos instead of iwl3945_activate_qos.
Patch does two things
1) Patch adds iwl_activate_qos in core library.
2) 3945 makes use of iwl_activate_qos.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 ------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   33 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   48 ++-------------------------
 4 files changed, 37 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 18f6f68..31e64bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -601,38 +601,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
-/*
- * QoS  support
-*/
-static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	priv->qos_data.def_qos_parm.qos_flags = 0;
-
-	if (priv->qos_data.qos_cap.q_AP.queue_request &&
-	    !priv->qos_data.qos_cap.q_AP.txop_request)
-		priv->qos_data.def_qos_parm.qos_flags |=
-			QOS_PARAM_FLG_TXOP_TYPE_MSK;
-	if (priv->qos_data.qos_active)
-		priv->qos_data.def_qos_parm.qos_flags |=
-			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
-
-	if (priv->current_ht_config.is_ht)
-		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
-
-	if (force || iwl_is_associated(priv)) {
-		IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
-				priv->qos_data.qos_active,
-				priv->qos_data.def_qos_parm.qos_flags);
-
-		iwl_send_cmd_pdu_async(priv, REPLY_QOS_PARAM,
-				       sizeof(struct iwl_qosparam_cmd),
-				       &priv->qos_data.def_qos_parm, NULL);
-	}
-}
-
 #define MAX_UCODE_BEACON_INTERVAL	4096
 
 static u16 iwl_adjust_beacon_interval(u16 beacon_val)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 37069d4..085e9cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -240,6 +240,39 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_hw_nic_init);
 
+/*
+ * QoS  support
+*/
+void iwl_activate_qos(struct iwl_priv *priv, u8 force)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	priv->qos_data.def_qos_parm.qos_flags = 0;
+
+	if (priv->qos_data.qos_cap.q_AP.queue_request &&
+	    !priv->qos_data.qos_cap.q_AP.txop_request)
+		priv->qos_data.def_qos_parm.qos_flags |=
+			QOS_PARAM_FLG_TXOP_TYPE_MSK;
+	if (priv->qos_data.qos_active)
+		priv->qos_data.def_qos_parm.qos_flags |=
+			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
+
+	if (priv->current_ht_config.is_ht)
+		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
+
+	if (force || iwl_is_associated(priv)) {
+		IWL_DEBUG_QOS(priv, "send QoS cmd with Qos active=%d FLAGS=0x%X\n",
+				priv->qos_data.qos_active,
+				priv->qos_data.def_qos_parm.qos_flags);
+
+		iwl_send_cmd_pdu_async(priv, REPLY_QOS_PARAM,
+				       sizeof(struct iwl_qosparam_cmd),
+				       &priv->qos_data.def_qos_parm, NULL);
+	}
+}
+EXPORT_SYMBOL(iwl_activate_qos);
+
 void iwl_reset_qos(struct iwl_priv *priv)
 {
 	u16 cw_min = 15;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7427d75..27310fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -224,6 +224,7 @@ struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
 		struct ieee80211_ops *hw_ops);
 void iwl_hw_detect(struct iwl_priv *priv);
 void iwl_reset_qos(struct iwl_priv *priv);
+void iwl_activate_qos(struct iwl_priv *priv, u8 force);
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt);
 int iwl_check_rxon_cmd(struct iwl_priv *priv);
 int iwl_full_rxon_required(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index b667f27..883d0c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -689,48 +689,6 @@ static void iwl3945_unset_hw_params(struct iwl_priv *priv)
 				    priv->shared_phys);
 }
 
-/*
- * QoS  support
-*/
-static int iwl3945_send_qos_params_command(struct iwl_priv *priv,
-				       struct iwl_qosparam_cmd *qos)
-{
-
-	return iwl_send_cmd_pdu(priv, REPLY_QOS_PARAM,
-				sizeof(struct iwl_qosparam_cmd), qos);
-}
-
-static void iwl3945_activate_qos(struct iwl_priv *priv, u8 force)
-{
-	unsigned long flags;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->qos_data.def_qos_parm.qos_flags = 0;
-
-	if (priv->qos_data.qos_cap.q_AP.queue_request &&
-	    !priv->qos_data.qos_cap.q_AP.txop_request)
-		priv->qos_data.def_qos_parm.qos_flags |=
-			QOS_PARAM_FLG_TXOP_TYPE_MSK;
-
-	if (priv->qos_data.qos_active)
-		priv->qos_data.def_qos_parm.qos_flags |=
-			QOS_PARAM_FLG_UPDATE_EDCA_MSK;
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (force || iwl_is_associated(priv)) {
-		IWL_DEBUG_QOS(priv, "send QoS cmd with QoS active %d \n",
-			      priv->qos_data.qos_active);
-
-		iwl3945_send_qos_params_command(priv,
-				&(priv->qos_data.def_qos_parm));
-	}
-}
-
-
 #define MAX_UCODE_BEACON_INTERVAL	1024
 #define INTEL_CONN_LISTEN_INTERVAL	cpu_to_le16(0xA)
 
@@ -3663,7 +3621,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 		break;
 	}
 
-	iwl3945_activate_qos(priv, 0);
+	iwl_activate_qos(priv, 0);
 
 	/* we have just associated, don't start scan too early */
 	priv->next_scan_jiffies = jiffies + IWL_DELAY_NEXT_SCAN;
@@ -4262,9 +4220,9 @@ static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	mutex_lock(&priv->mutex);
 	if (priv->iw_mode == NL80211_IFTYPE_AP)
-		iwl3945_activate_qos(priv, 1);
+		iwl_activate_qos(priv, 1);
 	else if (priv->assoc_id && iwl_is_associated(priv))
-		iwl3945_activate_qos(priv, 0);
+		iwl_activate_qos(priv, 0);
 
 	mutex_unlock(&priv->mutex);
 
-- 
1.5.6.3

