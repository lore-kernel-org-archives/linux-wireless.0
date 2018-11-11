Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458EDC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13D4A2148E
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13D4A2148E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbeKLF5N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:13 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35946 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731152AbeKLF5L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:11 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1G-0000JG-5t; Sun, 11 Nov 2018 22:07:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:22 +0200
Message-Id: <20181111200732.8159-7-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/16] iwlwifi: mvm: add support for TWT capabilities
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We need to check the TWT support of the peer and to
propagte the capability to the firmware.
The current implementation will enable TWT only if the TWT
support is advertised in the HE CAP IE and in the Extended
Capability IE.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 16 +++++++++----
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 24 ++++++++++++++++++-
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
index d0b79fb461bf..2c9e40eedef5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
@@ -185,6 +185,14 @@ struct iwl_mac_data_ibss {
 	__le32 beacon_template;
 } __packed; /* IBSS_MAC_DATA_API_S_VER_1 */
 
+/**
+ * enum iwl_mac_data_policy - policy of the data path for this MAC
+ * @TWT_SUPPORTED: twt is supported
+ */
+enum iwl_mac_data_policy {
+	TWT_SUPPORTED	= BIT(0),
+};
+
 /**
  * struct iwl_mac_data_sta - configuration data for station MAC context
  * @is_assoc: 1 for associated state, 0 otherwise
@@ -193,7 +201,7 @@ struct iwl_mac_data_ibss {
  * @bi: beacon interval in TU, applicable only when associated
  * @reserved1: reserved
  * @dtim_interval: DTIM interval in TU, applicable only when associated
- * @reserved2: reserved
+ * @data_policy: see &enum iwl_mac_data_policy
  * @listen_interval: in beacon intervals, applicable only when associated
  * @assoc_id: unique ID assigned by the AP during association
  * @assoc_beacon_arrive_time: TSF of first beacon after association
@@ -205,11 +213,11 @@ struct iwl_mac_data_sta {
 	__le32 bi;
 	__le32 reserved1;
 	__le32 dtim_interval;
-	__le32 reserved2;
+	__le32 data_policy;
 	__le32 listen_interval;
 	__le32 assoc_id;
 	__le32 assoc_beacon_arrive_time;
-} __packed; /* STA_MAC_DATA_API_S_VER_1 */
+} __packed; /* STA_MAC_DATA_API_S_VER_2 */
 
 /**
  * struct iwl_mac_data_go - configuration data for P2P GO MAC context
@@ -233,7 +241,7 @@ struct iwl_mac_data_go {
 struct iwl_mac_data_p2p_sta {
 	struct iwl_mac_data_sta sta;
 	__le32 ctwin;
-} __packed; /* P2P_STA_MAC_DATA_API_S_VER_1 */
+} __packed; /* P2P_STA_MAC_DATA_API_S_VER_2 */
 
 /**
  * struct iwl_mac_data_pibss - Pseudo IBSS config data
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 3b93293d4559..990ebf89f342 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -777,8 +777,30 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
 
 	if (vif->bss_conf.assoc && vif->bss_conf.he_support &&
-	    !iwlwifi_mod_params.disable_11ax)
+	    !iwlwifi_mod_params.disable_11ax) {
+		struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+		u8 sta_id = mvmvif->ap_sta_id;
+
 		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_11AX);
+		if (sta_id != IWL_MVM_INVALID_STA) {
+			struct ieee80211_sta *sta;
+
+			sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
+				lockdep_is_held(&mvm->mutex));
+
+			/*
+			 * TODO: we should check the ext cap IE but it is
+			 * unclear why the spec requires two bits (one in HE
+			 * cap IE, and one in the ext cap IE). In the meantime
+			 * rely on the HE cap IE only.
+			 */
+			if (sta && (sta->he_cap.he_cap_elem.mac_cap_info[0] &
+				    IEEE80211_HE_MAC_CAP0_TWT_RES))
+				ctxt_sta->data_policy |=
+					cpu_to_le32(TWT_SUPPORTED);
+		}
+	}
+
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
 }
-- 
2.19.1

