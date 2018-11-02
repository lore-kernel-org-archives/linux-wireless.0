Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC93C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B8B320657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B8B320657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbeKBUO6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:14:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:33996 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726104AbeKBUO5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:14:57 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJB-0007MW-N0; Fri, 02 Nov 2018 13:08:10 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Tova Mussai <tova.mussai@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:49 +0200
Message-Id: <20181102110800.29817-5-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/15] iwlwifi: mvm: enable low latency for soft ap
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tova Mussai <tova.mussai@intel.com>

Enable low latency for softAP in all modes (standalone, SCM
and DCM).
This is in order to minimize the time the softAP leaves the channel for
other operations

Signed-off-by: Tova Mussai <tova.mussai@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/mvm/debugfs-vif.c  |  5 ++-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 12 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  4 ++
 .../net/wireless/intel/iwlwifi/mvm/utils.c    | 42 +++++++++++--------
 4 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 1aa6c7e93088..e9767bbdea1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -1299,10 +1299,11 @@ static ssize_t iwl_dbgfs_low_latency_read(struct file *file,
 	int len;
 
 	len = scnprintf(buf, sizeof(buf) - 1,
-			"traffic=%d\ndbgfs=%d\nvcmd=%d\n",
+			"traffic=%d\ndbgfs=%d\nvcmd=%d\nvif_type=%d\n",
 			!!(mvmvif->low_latency & LOW_LATENCY_TRAFFIC),
 			!!(mvmvif->low_latency & LOW_LATENCY_DEBUGFS),
-			!!(mvmvif->low_latency & LOW_LATENCY_VCMD));
+			!!(mvmvif->low_latency & LOW_LATENCY_VCMD),
+			!!(mvmvif->low_latency & LOW_LATENCY_VIF_TYPE));
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 505b0385d800..5bdc638fc999 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2379,6 +2379,12 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	/* must be set before quota calculations */
 	mvmvif->ap_ibss_active = true;
 
+	if (vif->type == NL80211_IFTYPE_AP && !vif->p2p) {
+		iwl_mvm_vif_set_low_latency(mvmvif, true,
+					    LOW_LATENCY_VIF_TYPE);
+		iwl_mvm_send_low_latency_cmd(mvm, true, mvmvif->id);
+	}
+
 	/* power updated needs to be done before quotas */
 	iwl_mvm_power_update_mac(mvm);
 
@@ -2441,6 +2447,12 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	mvmvif->ap_ibss_active = false;
 	mvm->ap_last_beacon_gp2 = 0;
 
+	if (vif->type == NL80211_IFTYPE_AP && !vif->p2p) {
+		iwl_mvm_vif_set_low_latency(mvmvif, false,
+					    LOW_LATENCY_VIF_TYPE);
+		iwl_mvm_send_low_latency_cmd(mvm, false,  mvmvif->id);
+	}
+
 	iwl_mvm_bt_coex_vif_change(mvm);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_AP_IBSS);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 8a933774a934..03fdc8b1892d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -303,11 +303,13 @@ enum iwl_bt_force_ant_mode {
 * @LOW_LATENCY_TRAFFIC: indicates low latency traffic was detected
 * @LOW_LATENCY_DEBUGFS: low latency mode set from debugfs
 * @LOW_LATENCY_VCMD: low latency mode set from vendor command
+* @LOW_LATENCY_VIF_TYPE: low latency mode set because of vif type (ap)
 */
 enum iwl_mvm_low_latency_cause {
 	LOW_LATENCY_TRAFFIC = BIT(0),
 	LOW_LATENCY_DEBUGFS = BIT(1),
 	LOW_LATENCY_VCMD = BIT(2),
+	LOW_LATENCY_VIF_TYPE = BIT(3),
 };
 
 /**
@@ -1845,6 +1847,8 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 /* get SystemLowLatencyMode - only needed for beacon threshold? */
 bool iwl_mvm_low_latency(struct iwl_mvm *mvm);
 bool iwl_mvm_low_latency_band(struct iwl_mvm *mvm, enum nl80211_band band);
+void iwl_mvm_send_low_latency_cmd(struct iwl_mvm *mvm, bool low_latency,
+				  u16 mac_id);
 
 /* get VMACLowLatencyMode */
 static inline bool iwl_mvm_vif_low_latency(struct iwl_mvm_vif *mvmvif)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 11730d018e20..3fd673128d51 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -764,6 +764,29 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 	return result;
 }
 
+void iwl_mvm_send_low_latency_cmd(struct iwl_mvm *mvm,
+				  bool low_latency, u16 mac_id)
+{
+	struct iwl_mac_low_latency_cmd cmd = {
+		.mac_id = cpu_to_le32(mac_id)
+	};
+
+	if (!fw_has_capa(&mvm->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA))
+		return;
+
+	if (low_latency) {
+		/* currently we don't care about the direction */
+		cmd.low_latency_rx = 1;
+		cmd.low_latency_tx = 1;
+	}
+
+	if (iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(LOW_LATENCY_CMD,
+						 MAC_CONF_GROUP, 0),
+				 0, sizeof(cmd), &cmd))
+		IWL_ERR(mvm, "Failed to send low latency command\n");
+}
+
 int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			       bool low_latency,
 			       enum iwl_mvm_low_latency_cause cause)
@@ -782,24 +805,7 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (low_latency == prev)
 		return 0;
 
-	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_DYNAMIC_QUOTA)) {
-		struct iwl_mac_low_latency_cmd cmd = {
-			.mac_id = cpu_to_le32(mvmvif->id)
-		};
-
-		if (low_latency) {
-			/* currently we don't care about the direction */
-			cmd.low_latency_rx = 1;
-			cmd.low_latency_tx = 1;
-		}
-		res = iwl_mvm_send_cmd_pdu(mvm,
-					   iwl_cmd_id(LOW_LATENCY_CMD,
-						      MAC_CONF_GROUP, 0),
-					   0, sizeof(cmd), &cmd);
-		if (res)
-			IWL_ERR(mvm, "Failed to send low latency command\n");
-	}
+	iwl_mvm_send_low_latency_cmd(mvm, low_latency, mvmvif->id);
 
 	res = iwl_mvm_update_quotas(mvm, false, NULL);
 	if (res)
-- 
2.19.1

