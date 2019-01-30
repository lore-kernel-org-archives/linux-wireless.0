Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3523FC282D9
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1699920882
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730829AbfA3L4Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:56:24 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52854 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730308AbfA3L4X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:56:23 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooTB-0003x8-HJ; Wed, 30 Jan 2019 13:55:54 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:22 +0200
Message-Id: <20190130115528.19922-12-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/17] iwlwifi: mvm: support new format for the beacon notification
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware is changing the format of the beacon
notification to remove the dependency on the Tx response
format.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/tx.h    | 18 ++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  3 ++
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 35 ++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  6 ++++
 4 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 358bdf051e83..8511e735c374 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -847,19 +847,33 @@ struct iwl_beacon_notif {
 } __packed;
 
 /**
- * struct iwl_extended_beacon_notif - notifies about beacon transmission
+ * struct iwl_extended_beacon_notif_v5 - notifies about beacon transmission
  * @beacon_notify_hdr: tx response command associated with the beacon
  * @tsf: last beacon tsf
  * @ibss_mgr_status: whether IBSS is manager
  * @gp2: last beacon time in gp2
  */
-struct iwl_extended_beacon_notif {
+struct iwl_extended_beacon_notif_v5 {
 	struct iwl_mvm_tx_resp beacon_notify_hdr;
 	__le64 tsf;
 	__le32 ibss_mgr_status;
 	__le32 gp2;
 } __packed; /* BEACON_NTFY_API_S_VER_5 */
 
+/**
+ * struct iwl_extended_beacon_notif - notifies about beacon transmission
+ * @status: the status of the Tx response of the beacon
+ * @tsf: last beacon tsf
+ * @ibss_mgr_status: whether IBSS is manager
+ * @gp2: last beacon time in gp2
+ */
+struct iwl_extended_beacon_notif {
+	__le32 status;
+	__le64 tsf;
+	__le32 ibss_mgr_status;
+	__le32 gp2;
+} __packed; /* BEACON_NTFY_API_S_VER_6_ */
+
 /**
  * enum iwl_dump_control - dump (flush) control flags
  * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the the FIFO is empty
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index db392cfc2bd4..a6dd27fbe4aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -263,6 +263,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_FRAG_EBS: This ucode supports fragmented EBS
  * @IWL_UCODE_TLV_API_REDUCE_TX_POWER: This ucode supports v5 of
  *	the REDUCE_TX_POWER_CMD.
+ * @IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF: This ucode supports the short
+ *	version of the beacon notification.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -287,6 +289,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_ADAPTIVE_DWELL_V2	= (__force iwl_ucode_tlv_api_t)42,
 	IWL_UCODE_TLV_API_FRAG_EBS		= (__force iwl_ucode_tlv_api_t)44,
 	IWL_UCODE_TLV_API_REDUCE_TX_POWER	= (__force iwl_ucode_tlv_api_t)45,
+	IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF	= (__force iwl_ucode_tlv_api_t)46,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 768a87e0a1c3..c1eb07c08827 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1330,7 +1330,7 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_extended_beacon_notif *beacon = (void *)pkt->data;
-	struct iwl_mvm_tx_resp *beacon_notify_hdr;
+	struct iwl_extended_beacon_notif_v5 *beacon_v5 = (void *)pkt->data;
 	struct ieee80211_vif *csa_vif;
 	struct ieee80211_vif *tx_blocked_vif;
 	struct agg_tx_status *agg_status;
@@ -1338,18 +1338,29 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	beacon_notify_hdr = &beacon->beacon_notify_hdr;
 	mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
-	mvm->ibss_manager = beacon->ibss_mgr_status != 0;
-
-	agg_status = iwl_mvm_get_agg_status(mvm, beacon_notify_hdr);
-	status = le16_to_cpu(agg_status->status) & TX_STATUS_MSK;
-	IWL_DEBUG_RX(mvm,
-		     "beacon status %#x retries:%d tsf:0x%016llX gp2:0x%X rate:%d\n",
-		     status, beacon_notify_hdr->failure_frame,
-		     le64_to_cpu(beacon->tsf),
-		     mvm->ap_last_beacon_gp2,
-		     le32_to_cpu(beacon_notify_hdr->initial_rate));
+
+	if (!iwl_mvm_is_short_beacon_notif_supported(mvm)) {
+		struct iwl_mvm_tx_resp *beacon_notify_hdr =
+			&beacon_v5->beacon_notify_hdr;
+
+		mvm->ibss_manager = beacon_v5->ibss_mgr_status != 0;
+		agg_status = iwl_mvm_get_agg_status(mvm, beacon_notify_hdr);
+		status = le16_to_cpu(agg_status->status) & TX_STATUS_MSK;
+		IWL_DEBUG_RX(mvm,
+			     "beacon status %#x retries:%d tsf:0x%016llX gp2:0x%X rate:%d\n",
+			     status, beacon_notify_hdr->failure_frame,
+			     le64_to_cpu(beacon->tsf),
+			     mvm->ap_last_beacon_gp2,
+			     le32_to_cpu(beacon_notify_hdr->initial_rate));
+	} else {
+		mvm->ibss_manager = beacon->ibss_mgr_status != 0;
+		status = le32_to_cpu(beacon->status) & TX_STATUS_MSK;
+		IWL_DEBUG_RX(mvm,
+			     "beacon status %#x tsf:0x%016llX gp2:0x%X\n",
+			     status, le64_to_cpu(beacon->tsf),
+			     mvm->ap_last_beacon_gp2);
+	}
 
 	csa_vif = rcu_dereference_protected(mvm->csa_vif,
 					    lockdep_is_held(&mvm->mutex));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 12e9ecc3ee27..f7176020139d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1311,6 +1311,12 @@ static inline bool iwl_mvm_is_frag_ebs_supported(struct iwl_mvm *mvm)
 	return fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_FRAG_EBS);
 }
 
+static inline bool iwl_mvm_is_short_beacon_notif_supported(struct iwl_mvm *mvm)
+{
+	return fw_has_api(&mvm->fw->ucode_capa,
+			  IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF);
+}
+
 static inline bool iwl_mvm_enter_d0i3_on_suspend(struct iwl_mvm *mvm)
 {
 	/* For now we only use this mode to differentiate between
-- 
2.20.1

