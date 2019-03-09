Return-Path: <SRS0=krUy=RM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF60FC4360F
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 813122086A
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Mar 2019 09:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfCIJWv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:22:51 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41816 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726296AbfCIJWu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Mar 2019 04:22:50 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2YBr-0000qV-CX; Sat, 09 Mar 2019 11:22:48 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat,  9 Mar 2019 11:22:35 +0200
Message-Id: <20190309092237.10294-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190309092237.10294-1-luca@coelho.fi>
References: <20190309092237.10294-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 6/8] iwlwifi: mvm: disconnect in case of bad channel switch parameters
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

In case we receive channel switch announcement with immediate
quiet and unknown switching time, we will switch when FW identifies
AP left channel. However, if AP remains on channel, we will
eventually get TX queue hang. Init a work to disconnect if
switch doesn't occur within 1500 milliseconds. Do it also
for a too long channel switch.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 171 ++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   1 +
 .../wireless/intel/iwlwifi/mvm/time-event.c   |   5 +-
 4 files changed, 107 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 6a70dece447d..f24d73700ad6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1573,6 +1573,7 @@ void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 
 	rcu_read_lock();
 	vif = rcu_dereference(mvm->vif_id_to_mac[mac_id]);
+	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
@@ -1581,7 +1582,6 @@ void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 			    csa_vif != vif))
 			goto out_unlock;
 
-		mvmvif = iwl_mvm_vif_from_mac80211(csa_vif);
 		csa_id = FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color);
 		if (WARN(csa_id != id_n_color,
 			 "channel switch noa notification on unexpected vif (csa_vif=%d, notif=%d)",
@@ -1602,6 +1602,7 @@ void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 		return;
 	case NL80211_IFTYPE_STATION:
 		iwl_mvm_csa_client_absent(mvm, vif);
+		cancel_delayed_work_sync(&mvmvif->csa_work);
 		ieee80211_chswitch_done(vif, true);
 		break;
 	default:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5d56c6008787..af71e58bdd24 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1500,6 +1500,91 @@ static int iwl_mvm_set_tx_power(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return iwl_mvm_send_cmd_pdu(mvm, REDUCE_TX_POWER_CMD, 0, len, &cmd);
 }
 
+static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+
+	if (mvmvif->csa_failed) {
+		mvmvif->csa_failed = false;
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		struct iwl_mvm_sta *mvmsta;
+
+		mvmvif->csa_bcn_pending = false;
+		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
+							  mvmvif->ap_sta_id);
+
+		if (WARN_ON(!mvmsta)) {
+			ret = -EIO;
+			goto out_unlock;
+		}
+
+		iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, false);
+
+		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+
+		ret = iwl_mvm_enable_beacon_filter(mvm, vif, 0);
+		if (ret)
+			goto out_unlock;
+
+		iwl_mvm_stop_session_protection(mvm, vif);
+	}
+
+	mvmvif->ps_disabled = false;
+
+	ret = iwl_mvm_power_update_ps(mvm);
+
+out_unlock:
+	mutex_unlock(&mvm->mutex);
+
+	return ret;
+}
+
+static void iwl_mvm_abort_channel_switch(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_chan_switch_te_cmd cmd = {
+		.mac_id = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
+							  mvmvif->color)),
+		.action = cpu_to_le32(FW_CTXT_ACTION_REMOVE),
+	};
+
+	IWL_DEBUG_MAC80211(mvm, "Abort CSA on mac %d\n", mvmvif->id);
+
+	mutex_lock(&mvm->mutex);
+	WARN_ON(iwl_mvm_send_cmd_pdu(mvm,
+				     WIDE_ID(MAC_CONF_GROUP,
+					     CHANNEL_SWITCH_TIME_EVENT_CMD),
+				     0, sizeof(cmd), &cmd));
+	mutex_unlock(&mvm->mutex);
+
+	WARN_ON(iwl_mvm_post_channel_switch(hw, vif));
+}
+
+static void iwl_mvm_channel_switch_disconnect_wk(struct work_struct *wk)
+{
+	struct iwl_mvm *mvm;
+	struct iwl_mvm_vif *mvmvif;
+	struct ieee80211_vif *vif;
+
+	mvmvif = container_of(wk, struct iwl_mvm_vif, csa_work.work);
+	vif = container_of((void *)mvmvif, struct ieee80211_vif, drv_priv);
+	mvm = mvmvif->mvm;
+
+	iwl_mvm_abort_channel_switch(mvm->hw, vif);
+	ieee80211_chswitch_done(vif, false);
+}
+
 static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
@@ -1626,6 +1711,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	}
 
 	iwl_mvm_tcm_add_vif(mvm, vif);
+	INIT_DELAYED_WORK(&mvmvif->csa_work,
+			  iwl_mvm_channel_switch_disconnect_wk);
 
 	if (vif->type == NL80211_IFTYPE_MONITOR)
 		mvm->monitor_on = true;
@@ -4484,6 +4571,7 @@ static int iwl_mvm_schedule_client_csa(struct iwl_mvm *mvm,
 				    0, sizeof(cmd), &cmd);
 }
 
+#define IWL_MAX_CSA_BLOCK_TX 1500
 static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct ieee80211_channel_switch *chsw)
@@ -4548,8 +4636,18 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 				((vif->bss_conf.beacon_int * (chsw->count - 1) -
 				  IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT) * 1024);
 
-		if (chsw->block_tx)
+		if (chsw->block_tx) {
 			iwl_mvm_csa_client_absent(mvm, vif);
+			/*
+			 * In case of undetermined / long time with immediate
+			 * quiet monitor status to gracefully disconnect
+			 */
+			if (!chsw->count ||
+			    chsw->count * vif->bss_conf.beacon_int >
+			    IWL_MAX_CSA_BLOCK_TX)
+				schedule_delayed_work(&mvmvif->csa_work,
+						      msecs_to_jiffies(IWL_MAX_CSA_BLOCK_TX));
+		}
 
 		if (mvmvif->bf_data.bf_enabled) {
 			ret = iwl_mvm_disable_beacon_filter(mvm, vif, 0);
@@ -4584,54 +4682,6 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	int ret;
-
-	mutex_lock(&mvm->mutex);
-
-	if (mvmvif->csa_failed) {
-		mvmvif->csa_failed = false;
-		ret = -EIO;
-		goto out_unlock;
-	}
-
-	if (vif->type == NL80211_IFTYPE_STATION) {
-		struct iwl_mvm_sta *mvmsta;
-
-		mvmvif->csa_bcn_pending = false;
-		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
-							  mvmvif->ap_sta_id);
-
-		if (WARN_ON(!mvmsta)) {
-			ret = -EIO;
-			goto out_unlock;
-		}
-
-		iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, false);
-
-		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
-
-		ret = iwl_mvm_enable_beacon_filter(mvm, vif, 0);
-		if (ret)
-			goto out_unlock;
-
-		iwl_mvm_stop_session_protection(mvm, vif);
-	}
-
-	mvmvif->ps_disabled = false;
-
-	ret = iwl_mvm_power_update_ps(mvm);
-
-out_unlock:
-	mutex_unlock(&mvm->mutex);
-
-	return ret;
-}
-
 static void iwl_mvm_channel_switch_rx_beacon(struct ieee80211_hw *hw,
 					     struct ieee80211_vif *vif,
 					     struct ieee80211_channel_switch *chsw)
@@ -4658,29 +4708,6 @@ static void iwl_mvm_channel_switch_rx_beacon(struct ieee80211_hw *hw,
 				     CMD_ASYNC, sizeof(cmd), &cmd));
 }
 
-static void iwl_mvm_abort_channel_switch(struct ieee80211_hw *hw,
-					 struct ieee80211_vif *vif)
-{
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_chan_switch_te_cmd cmd = {
-		.mac_id = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
-							  mvmvif->color)),
-		.action = cpu_to_le32(FW_CTXT_ACTION_REMOVE),
-	};
-
-	IWL_DEBUG_MAC80211(mvm, "Abort CSA on mac %d\n", mvmvif->id);
-
-	mutex_lock(&mvm->mutex);
-	WARN_ON(iwl_mvm_send_cmd_pdu(mvm,
-				     WIDE_ID(MAC_CONF_GROUP,
-					     CHANNEL_SWITCH_TIME_EVENT_CMD),
-				     0, sizeof(cmd), &cmd));
-	mutex_unlock(&mvm->mutex);
-
-	WARN_ON(iwl_mvm_post_channel_switch(hw, vif));
-}
-
 static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 {
 	int i;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index dd70bdc27d58..79d7fcb95b6f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -490,6 +490,7 @@ struct iwl_mvm_vif {
 	bool csa_countdown;
 	bool csa_failed;
 	u16 csa_target_freq;
+	struct delayed_work csa_work;
 
 	/* Indicates that we are waiting for a beacon on a new channel */
 	bool csa_bcn_pending;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 9693fa4cdc39..50314018d157 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -234,6 +234,7 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 			break;
 		}
 		iwl_mvm_csa_client_absent(mvm, te_data->vif);
+		cancel_delayed_work_sync(&mvmvif->csa_work);
 		ieee80211_chswitch_done(te_data->vif, true);
 		break;
 	default:
-- 
2.20.1

