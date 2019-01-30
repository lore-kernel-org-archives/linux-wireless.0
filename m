Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE4AC282D8
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A56120855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbfA3Lzy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:54 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52768 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730756AbfA3Lzx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:53 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooT8-0003x8-A8; Wed, 30 Jan 2019 13:55:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:18 +0200
Message-Id: <20190130115528.19922-8-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/17] iwlwifi: mvm: support CHANNEL_SWITCH_TIME_EVENT_CMD command
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When we do channel switch, we used to schedule time events
ourselves. This was offloaded to FW. Support the new command
and flow.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   | 27 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  2 +
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 58 +++++++++------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 71 ++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 +
 5 files changed, 119 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
index ca49db786ed6..6b4d59daacd6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
@@ -73,6 +73,10 @@ enum iwl_mac_conf_subcmd_ids {
 	 * @LOW_LATENCY_CMD: &struct iwl_mac_low_latency_cmd
 	 */
 	LOW_LATENCY_CMD = 0x3,
+	/**
+	 * @CHANNEL_SWITCH_TIME_EVENT_CMD: &struct iwl_chan_switch_te_cmd
+	 */
+	CHANNEL_SWITCH_TIME_EVENT_CMD = 0x4,
 	/**
 	 * @PROBE_RESPONSE_DATA_NOTIF: &struct iwl_probe_resp_data_notif
 	 */
@@ -135,6 +139,29 @@ struct iwl_channel_switch_noa_notif {
 	__le32 id_and_color;
 } __packed; /* CHANNEL_SWITCH_START_NTFY_API_S_VER_1 */
 
+/**
+ * struct iwl_chan_switch_te_cmd - Channel Switch Time Event command
+ *
+ * @mac_id: MAC ID for channel switch
+ * @action: action to perform, one of FW_CTXT_ACTION_*
+ * @tsf: beacon tsf
+ * @cs_count: channel switch count from CSA/eCSA IE
+ * @cs_delayed_bcn_count: if set to N (!= 0) GO/AP can delay N beacon intervals
+ *	at the new channel after the channel switch, otherwise (N == 0) expect
+ *	beacon right after the channel switch.
+ * @cs_mode: 1 - quiet, 0 - otherwise
+ * @reserved: reserved for alignment purposes
+ */
+struct iwl_chan_switch_te_cmd {
+	__le32 mac_id;
+	__le32 action;
+	__le32 tsf;
+	u8 cs_count;
+	u8 cs_delayed_bcn_count;
+	u8 cs_mode;
+	u8 reserved;
+} __packed; /* MAC_CHANNEL_SWITCH_TIME_EVENT_S_VER_2 */
+
 /**
  * struct iwl_mac_low_latency_cmd - set/clear mac to 'low-latency mode'
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index e8b00b795cbb..db392cfc2bd4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -333,6 +333,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_TLC_OFFLOAD: firmware implements rate scaling algorithm
  * @IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA: firmware implements quota related
  * @IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2: firmware implements Coex Schema 2
+ * IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD: firmware supports CSA command
  * @IWL_UCODE_TLV_CAPA_ULTRA_HB_CHANNELS: firmware supports ultra high band
  *	(6 GHz).
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
@@ -397,6 +398,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_TLC_OFFLOAD                  = (__force iwl_ucode_tlv_capa_t)43,
 	IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA                = (__force iwl_ucode_tlv_capa_t)44,
 	IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2		= (__force iwl_ucode_tlv_capa_t)45,
+	IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD		= (__force iwl_ucode_tlv_capa_t)46,
 	IWL_UCODE_TLV_CAPA_ULTRA_HB_CHANNELS		= (__force iwl_ucode_tlv_capa_t)48,
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 7cfdd07d8736..768a87e0a1c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1539,42 +1539,58 @@ void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_channel_switch_noa_notif *notif = (void *)pkt->data;
-	struct ieee80211_vif *csa_vif;
+	struct ieee80211_vif *csa_vif, *vif;
 	struct iwl_mvm_vif *mvmvif;
 	int len = iwl_rx_packet_payload_len(pkt);
-	u32 id_n_color;
+	u32 id_n_color, csa_id, mac_id;
 
 	if (WARN_ON_ONCE(len < sizeof(*notif)))
 		return;
 
-	rcu_read_lock();
-
-	csa_vif = rcu_dereference(mvm->csa_vif);
-	if (WARN_ON(!csa_vif || !csa_vif->csa_active))
-		goto out_unlock;
-
 	id_n_color = le32_to_cpu(notif->id_and_color);
+	mac_id = id_n_color & FW_CTXT_ID_MSK;
 
-	mvmvif = iwl_mvm_vif_from_mac80211(csa_vif);
-	if (WARN(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color) != id_n_color,
-		 "channel switch noa notification on unexpected vif (csa_vif=%d, notif=%d)",
-		 FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color), id_n_color))
-		goto out_unlock;
+	if (WARN_ON_ONCE(mac_id >= NUM_MAC_INDEX_DRIVER))
+		return;
 
-	IWL_DEBUG_INFO(mvm, "Channel Switch Started Notification\n");
+	rcu_read_lock();
+	vif = rcu_dereference(mvm->vif_id_to_mac[mac_id]);
 
-	schedule_delayed_work(&mvm->cs_tx_unblock_dwork,
-			      msecs_to_jiffies(IWL_MVM_CS_UNBLOCK_TX_TIMEOUT *
-					       csa_vif->bss_conf.beacon_int));
+	switch (vif->type) {
+	case NL80211_IFTYPE_AP:
+		csa_vif = rcu_dereference(mvm->csa_vif);
+		if (WARN_ON(!csa_vif || !csa_vif->csa_active ||
+			    csa_vif != vif))
+			goto out_unlock;
 
-	ieee80211_csa_finish(csa_vif);
+		mvmvif = iwl_mvm_vif_from_mac80211(csa_vif);
+		csa_id = FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color);
+		if (WARN(csa_id != id_n_color,
+			 "channel switch noa notification on unexpected vif (csa_vif=%d, notif=%d)",
+			 csa_id, id_n_color))
+			goto out_unlock;
 
-	rcu_read_unlock();
+		IWL_DEBUG_INFO(mvm, "Channel Switch Started Notification\n");
 
-	RCU_INIT_POINTER(mvm->csa_vif, NULL);
+		schedule_delayed_work(&mvm->cs_tx_unblock_dwork,
+				      msecs_to_jiffies(IWL_MVM_CS_UNBLOCK_TX_TIMEOUT *
+						       csa_vif->bss_conf.beacon_int));
 
-	return;
+		ieee80211_csa_finish(csa_vif);
 
+		rcu_read_unlock();
+
+		RCU_INIT_POINTER(mvm->csa_vif, NULL);
+		return;
+	case NL80211_IFTYPE_STATION:
+		iwl_mvm_csa_client_absent(mvm, vif);
+		ieee80211_chswitch_done(vif, true);
+		break;
+	default:
+		/* should never happen */
+		WARN_ON_ONCE(1);
+		break;
+	}
 out_unlock:
 	rcu_read_unlock();
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index c9effd7f0ef8..8837d7667f36 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3953,25 +3953,30 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 	}
 
 	if (switching_chanctx && vif->type == NL80211_IFTYPE_STATION) {
-		u32 duration = 3 * vif->bss_conf.beacon_int;
+		mvmvif->csa_bcn_pending = true;
 
-		/* iwl_mvm_protect_session() reads directly from the
-		 * device (the system time), so make sure it is
-		 * available.
-		 */
-		ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PROTECT_CSA);
-		if (ret)
-			goto out_remove_binding;
+		if (!fw_has_capa(&mvm->fw->ucode_capa,
+				 IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD)) {
+			u32 duration = 3 * vif->bss_conf.beacon_int;
 
-		/* Protect the session to make sure we hear the first
-		 * beacon on the new channel.
-		 */
-		mvmvif->csa_bcn_pending = true;
-		iwl_mvm_protect_session(mvm, vif, duration, duration,
-					vif->bss_conf.beacon_int / 2,
-					true);
 
-		iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_CSA);
+			/* iwl_mvm_protect_session() reads directly from the
+			 * device (the system time), so make sure it is
+			 * available.
+			 */
+			ret = iwl_mvm_ref_sync(mvm, IWL_MVM_REF_PROTECT_CSA);
+			if (ret)
+				goto out_remove_binding;
+
+			/* Protect the session to make sure we hear the first
+			 * beacon on the new channel.
+			 */
+			iwl_mvm_protect_session(mvm, vif, duration, duration,
+						vif->bss_conf.beacon_int / 2,
+						true);
+
+			iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_CSA);
+		}
 
 		iwl_mvm_update_quotas(mvm, false, NULL);
 	}
@@ -4041,7 +4046,9 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 
 		disabled_vif = vif;
 
-		iwl_mvm_mac_ctxt_changed(mvm, vif, true, NULL);
+		if (!fw_has_capa(&mvm->fw->ucode_capa,
+				 IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD))
+			iwl_mvm_mac_ctxt_changed(mvm, vif, true, NULL);
 		break;
 	default:
 		break;
@@ -4292,6 +4299,27 @@ static void iwl_mvm_channel_switch(struct ieee80211_hw *hw,
 			   "dummy channel switch op\n");
 }
 
+static int iwl_mvm_schedule_client_csa(struct iwl_mvm *mvm,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_channel_switch *chsw)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_chan_switch_te_cmd cmd = {
+		.mac_id = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
+							  mvmvif->color)),
+		.action = cpu_to_le32(FW_CTXT_ACTION_ADD),
+		.tsf = cpu_to_le32(chsw->timestamp),
+		.cs_count = chsw->count,
+	};
+
+	lockdep_assert_held(&mvm->mutex);
+
+	return iwl_mvm_send_cmd_pdu(mvm,
+				    WIDE_ID(MAC_CONF_GROUP,
+					    CHANNEL_SWITCH_TIME_EVENT_CMD),
+				    0, sizeof(cmd), &cmd);
+}
+
 static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct ieee80211_channel_switch *chsw)
@@ -4359,14 +4387,19 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 		if (chsw->block_tx)
 			iwl_mvm_csa_client_absent(mvm, vif);
 
-		iwl_mvm_schedule_csa_period(mvm, vif, vif->bss_conf.beacon_int,
-					    apply_time);
 		if (mvmvif->bf_data.bf_enabled) {
 			ret = iwl_mvm_disable_beacon_filter(mvm, vif, 0);
 			if (ret)
 				goto out_unlock;
 		}
 
+		if (fw_has_capa(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD))
+			iwl_mvm_schedule_client_csa(mvm, vif, chsw);
+		else
+			iwl_mvm_schedule_csa_period(mvm, vif,
+						    vif->bss_conf.beacon_int,
+						    apply_time);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5e4f8b767d10..e56b31692a20 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -421,6 +421,7 @@ static const struct iwl_hcmd_names iwl_mvm_system_names[] = {
  * Access is done through binary search
  */
 static const struct iwl_hcmd_names iwl_mvm_mac_conf_names[] = {
+	HCMD_NAME(CHANNEL_SWITCH_TIME_EVENT_CMD),
 	HCMD_NAME(CHANNEL_SWITCH_NOA_NOTIF),
 };
 
-- 
2.20.1

