Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61389 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbYGKD4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:56:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/14] iwlwifi: make iwl4965_mac_conf_tx in atomic context
Date: Fri, 11 Jul 2008 11:53:34 +0800
Message-Id: <1215748422-12672-7-git-send-email-yi.zhu@intel.com> (sfid-20080711_055657_201060_387BC0D3)
In-Reply-To: <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes iwl4965_mac_conf_tx. A mutex was taken in atomic context
leading to Oops. This patch removes the mutex and extends the hold
priv->lock. None of the field of QOS is accessed without priv->lock held.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   12 ++++----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   39 ++++++++++----------------
 3 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index d877039..92754ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -725,7 +725,7 @@ struct iwl4965_csa_notification {
  * transmission retry.  Device uses cw_max as a bit mask, ANDed with new CW
  * value, to cap the CW value.
  */
-struct iwl4965_ac_qos {
+struct iwl_ac_qos {
 	__le16 cw_min;
 	__le16 cw_max;
 	u8 aifsn;
@@ -747,9 +747,9 @@ struct iwl4965_ac_qos {
  * This command sets up timings for each of the 4 prioritized EDCA Tx FIFOs
  * 0: Background, 1: Best Effort, 2: Video, 3: Voice.
  */
-struct iwl4965_qosparam_cmd {
+struct iwl_qosparam_cmd {
 	__le32 qos_flags;
-	struct iwl4965_ac_qos ac[AC_NUM];
+	struct iwl_ac_qos ac[AC_NUM];
 } __attribute__ ((packed));
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 81a57cb..92a3766 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -290,7 +290,7 @@ struct iwl_cmd {
 		struct iwl4965_bt_cmd bt;
 		struct iwl4965_rxon_time_cmd rxon_time;
 		struct iwl4965_powertable_cmd powertable;
-		struct iwl4965_qosparam_cmd qosparam;
+		struct iwl_qosparam_cmd qosparam;
 		struct iwl_tx_cmd tx;
 		struct iwl4965_tx_beacon_cmd tx_beacon;
 		struct iwl4965_rxon_assoc_cmd rxon_assoc;
@@ -435,7 +435,7 @@ struct iwl_ht_info {
 	u8 non_GF_STA_present;
 };
 
-union iwl4965_qos_capabity {
+union iwl_qos_capabity {
 	struct {
 		u8 edca_count:4;	/* bit 0-3 */
 		u8 q_ack:1;		/* bit 4 */
@@ -456,11 +456,11 @@ union iwl4965_qos_capabity {
 };
 
 /* QoS structures */
-struct iwl4965_qos_info {
+struct iwl_qos_info {
 	int qos_enable;
 	int qos_active;
-	union iwl4965_qos_capabity qos_cap;
-	struct iwl4965_qosparam_cmd def_qos_parm;
+	union iwl_qos_capabity qos_cap;
+	struct iwl_qosparam_cmd def_qos_parm;
 };
 
 #define STA_PS_STATUS_WAKE             0
@@ -1042,7 +1042,7 @@ struct iwl_priv {
 	u16 assoc_capability;
 	u8 ps_mode;
 
-	struct iwl4965_qos_info qos_data;
+	struct iwl_qos_info qos_data;
 
 	struct workqueue_struct *workqueue;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 95ec61a..bc9aa8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -575,25 +575,14 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
 /*
  * QoS  support
 */
-static int iwl4965_send_qos_params_command(struct iwl_priv *priv,
-				       struct iwl4965_qosparam_cmd *qos)
+static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 {
-
-	return iwl_send_cmd_pdu(priv, REPLY_QOS_PARAM,
-				sizeof(struct iwl4965_qosparam_cmd), qos);
-}
-
-static void iwl4965_activate_qos(struct iwl_priv *priv, u8 force)
-{
-	unsigned long flags;
-
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	if (!priv->qos_data.qos_enable)
 		return;
 
-	spin_lock_irqsave(&priv->lock, flags);
 	priv->qos_data.def_qos_parm.qos_flags = 0;
 
 	if (priv->qos_data.qos_cap.q_AP.queue_request &&
@@ -607,15 +596,14 @@ static void iwl4965_activate_qos(struct iwl_priv *priv, u8 force)
 	if (priv->current_ht_config.is_ht)
 		priv->qos_data.def_qos_parm.qos_flags |= QOS_PARAM_FLG_TGN_MSK;
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	if (force || iwl_is_associated(priv)) {
 		IWL_DEBUG_QOS("send QoS cmd with Qos active=%d FLAGS=0x%X\n",
 				priv->qos_data.qos_active,
 				priv->qos_data.def_qos_parm.qos_flags);
 
-		iwl4965_send_qos_params_command(priv,
-				&(priv->qos_data.def_qos_parm));
+		iwl_send_cmd_pdu_async(priv, REPLY_QOS_PARAM,
+				       sizeof(struct iwl_qosparam_cmd),
+				       &priv->qos_data.def_qos_parm, NULL);
 	}
 }
 
@@ -2424,6 +2412,7 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	struct ieee80211_conf *conf = NULL;
 	int ret = 0;
 	DECLARE_MAC_BUF(mac);
+	unsigned long flags;
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
 		IWL_ERROR("%s Should not be called in AP mode\n", __FUNCTION__);
@@ -2513,7 +2502,9 @@ static void iwl4965_post_associate(struct iwl_priv *priv)
 	if (priv->iw_mode == IEEE80211_IF_TYPE_IBSS)
 		priv->assoc_station_added = 1;
 
-	iwl4965_activate_qos(priv, 0);
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_activate_qos(priv, 0);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	iwl_power_update_mode(priv, 0);
 	/* we have just associated, don't start scan too early */
@@ -2845,6 +2836,7 @@ out:
 static void iwl4965_config_ap(struct iwl_priv *priv)
 {
 	int ret = 0;
+	unsigned long flags;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -2892,7 +2884,9 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
-		iwl4965_activate_qos(priv, 1);
+		spin_lock_irqsave(&priv->lock, flags);
+		iwl_activate_qos(priv, 1);
+		spin_unlock_irqrestore(&priv->lock, flags);
 		iwl_rxon_add_station(priv, iwl_bcast_addr, 0);
 	}
 	iwl4965_send_beacon_cmd(priv);
@@ -3327,15 +3321,12 @@ static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	priv->qos_data.def_qos_parm.ac[q].reserved1 = 0;
 	priv->qos_data.qos_active = 1;
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	mutex_lock(&priv->mutex);
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP)
-		iwl4965_activate_qos(priv, 1);
+		iwl_activate_qos(priv, 1);
 	else if (priv->assoc_id && iwl_is_associated(priv))
-		iwl4965_activate_qos(priv, 0);
+		iwl_activate_qos(priv, 0);
 
-	mutex_unlock(&priv->mutex);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	IWL_DEBUG_MAC80211("leave\n");
 	return 0;
-- 
1.5.3.6

