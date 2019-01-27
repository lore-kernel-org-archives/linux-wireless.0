Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC6CC282C9
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC232146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfA0KTc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:32 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51338 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726798AbfA0KTa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:30 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXE-0001vC-3K; Sun, 27 Jan 2019 12:19:28 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:55 +0200
Message-Id: <20190127101908.6428-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/21] iwlwifi: mvm: implement CSI reporting
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Implement CSI (channel estimation matrix) reporting in the mvm
driver, if the firmware has the capability.

Currently only a debugfs API is provided as the API is still
under discussion.

For now, RX aggregation must be disabled to use this feature
on data frames as we haven't found a good way to attach the
data to A-MPDUs, given complexities with multi-queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/datapath.h  | 55 +++++++++++++++++++
 .../wireless/intel/iwlwifi/fw/api/location.h  | 20 +++++++
 .../net/wireless/intel/iwlwifi/fw/api/rx.h    |  2 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  7 ++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 20 +++----
 7 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
index fdc54a5dc9de..93c06e6c1ced 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
@@ -104,6 +104,12 @@ enum iwl_data_path_subcmd_ids {
 	 */
 	HE_AIR_SNIFFER_CONFIG_CMD = 0x13,
 
+	/**
+	 * @CHEST_COLLECTOR_FILTER_CONFIG_CMD: Configure the CSI
+	 *	matrix collection, uses &struct iwl_channel_estimation_cfg
+	 */
+	CHEST_COLLECTOR_FILTER_CONFIG_CMD = 0x14,
+
 	/**
 	 * @RX_NO_DATA_NOTIF: &struct iwl_rx_no_data
 	 */
@@ -156,4 +162,53 @@ struct iwl_mu_group_mgmt_notif {
 	__le32 user_position[4];
 } __packed; /* MU_GROUP_MNG_NTFY_API_S_VER_1 */
 
+enum iwl_channel_estimation_flags {
+	IWL_CHANNEL_ESTIMATION_ENABLE	= BIT(0),
+	IWL_CHANNEL_ESTIMATION_TIMER	= BIT(1),
+	IWL_CHANNEL_ESTIMATION_COUNTER	= BIT(2),
+};
+
+/**
+ * struct iwl_channel_estimation_cfg - channel estimation reporting config
+ */
+struct iwl_channel_estimation_cfg {
+	/**
+	 * @flags: flags, see &enum iwl_channel_estimation_flags
+	 */
+	__le32 flags;
+	/**
+	 * @timer: if enabled via flags, automatically disable after this many
+	 *	microseconds
+	 */
+	__le32 timer;
+	/**
+	 * @count: if enabled via flags, automatically disable after this many
+	 *	frames with channel estimation matrix were captured
+	 */
+	__le32 count;
+	/**
+	 * @rate_n_flags_mask: only try to record the channel estimation matrix
+	 *	if the rate_n_flags value for the received frame (let's call
+	 *	that rx_rnf) matches the mask/value given here like this:
+	 *	(rx_rnf & rate_n_flags_mask) == rate_n_flags_val.
+	 */
+	__le32 rate_n_flags_mask;
+	/**
+	 * @rate_n_flags_val: see @rate_n_flags_mask
+	 */
+	__le32 rate_n_flags_val;
+	/**
+	 * @reserved: reserved (for alignment)
+	 */
+	__le32 reserved;
+	/**
+	 * @frame_types: bitmap of frame types to capture, the received frame's
+	 *	subtype|type takes 6 bits in the frame and the corresponding bit
+	 *	in this field must be set to 1 to capture channel estimation for
+	 *	that frame type. Set to all-ones to enable capturing for all
+	 *	frame types.
+	 */
+	__le64 frame_types;
+} __packed; /* CHEST_COLLECTOR_FILTER_CMD_API_S_VER_1 */
+
 #endif /* __iwl_fw_api_datapath_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
index 0df0851b9513..6da91ec0df55 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
@@ -93,6 +93,15 @@ enum iwl_location_subcmd_ids {
 	 *	uses &struct iwl_tof_responder_dyn_config_cmd
 	 */
 	TOF_RESPONDER_DYN_CONFIG_CMD = 0x5,
+	/**
+	 * @CSI_HEADER_NOTIFICATION: CSI header
+	 */
+	CSI_HEADER_NOTIFICATION = 0xFA,
+	/**
+	 * @CSI_CHUNKS_NOTIFICATION: CSI chunk,
+	 *	uses &struct iwl_csi_chunk_notification
+	 */
+	CSI_CHUNKS_NOTIFICATION = 0xFB,
 	/**
 	 * @TOF_LC_NOTIF: used for LCI/civic location, contains just
 	 *	the action frame
@@ -688,4 +697,15 @@ struct iwl_ftm_responder_stats {
 	__le16 reserved;
 } __packed; /* TOF_RESPONDER_STATISTICS_NTFY_S_VER_2 */
 
+#define IWL_CSI_CHUNK_CTL_NUM_MASK	0x3
+#define IWL_CSI_CHUNK_CTL_IDX_MASK	0xc
+
+struct iwl_csi_chunk_notification {
+	__le32 token;
+	__le16 seq;
+	__le16 ctl;
+	__le32 size;
+	u8 data[];
+} __packed; /* CSI_CHUNKS_HDR_NTFY_API_S_VER_1 */
+
 #endif /* __iwl_fw_api_location_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
index 11c25f32a286..6e8224ce8906 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rx.h
@@ -333,6 +333,8 @@ enum iwl_rx_mpdu_phy_info {
 	IWL_RX_MPDU_PHY_AMPDU		= BIT(5),
 	IWL_RX_MPDU_PHY_AMPDU_TOGGLE	= BIT(6),
 	IWL_RX_MPDU_PHY_SHORT_PREAMBLE	= BIT(7),
+	/* short preamble is only for CCK, for non-CCK overridden by this */
+	IWL_RX_MPDU_PHY_NCCK_ADDTL_NTFY	= BIT(7),
 	IWL_RX_MPDU_PHY_TSF_OVERLOAD	= BIT(8),
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index dfe02bdb7481..f73c5c697690 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -356,10 +356,13 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_TX_POWER_ACK: reduced TX power API has larger
  *	command size (command version 4) that supports toggling ACK TX
  *	power reduction.
- * @IWL_UCODE_TLV_CAPA_MLME_OFFLOAD: supports MLME offload
  * @IWL_UCODE_TLV_CAPA_D3_DEBUG: supports debug recording during D3
  * @IWL_UCODE_TLV_CAPA_MCC_UPDATE_11AX_SUPPORT: MCC response support 11ax
  *	capability.
+ * @IWL_UCODE_TLV_CAPA_CSI_REPORTING: firmware is capable of being configured
+ *	to report the CSI information with (certain) RX frames
+ *
+ * @IWL_UCODE_TLV_CAPA_MLME_OFFLOAD: supports MLME offload
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -410,6 +413,8 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_D3_DEBUG			= (__force iwl_ucode_tlv_capa_t)87,
 	IWL_UCODE_TLV_CAPA_LED_CMD_SUPPORT		= (__force iwl_ucode_tlv_capa_t)88,
 	IWL_UCODE_TLV_CAPA_MCC_UPDATE_11AX_SUPPORT	= (__force iwl_ucode_tlv_capa_t)89,
+	IWL_UCODE_TLV_CAPA_CSI_REPORTING		= (__force iwl_ucode_tlv_capa_t)90,
+
 	IWL_UCODE_TLV_CAPA_MLME_OFFLOAD			= (__force iwl_ucode_tlv_capa_t)96,
 
 	NUM_IWL_UCODE_TLV_CAPA
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index cbbd4b076e17..91b46361ac9f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -69,6 +69,7 @@
 #include "sta.h"
 #include "iwl-io.h"
 #include "debugfs.h"
+#include "iwl-modparams.h"
 #include "fw/error-dump.h"
 
 static ssize_t iwl_dbgfs_ctdp_budget_read(struct file *file,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index c7ec36ceb661..5e4f8b767d10 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -445,6 +445,7 @@ static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
 	HCMD_NAME(TRIGGER_RX_QUEUES_NOTIF_CMD),
 	HCMD_NAME(STA_HE_CTXT_CMD),
 	HCMD_NAME(RFH_QUEUE_CONFIG_CMD),
+	HCMD_NAME(CHEST_COLLECTOR_FILTER_CONFIG_CMD),
 	HCMD_NAME(STA_PM_NOTIF),
 	HCMD_NAME(MU_GROUP_MGMT_NOTIF),
 	HCMD_NAME(RX_QUEUES_NOTIFICATION),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 120e3f2d21aa..7b6f4585fec9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -201,18 +201,10 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 
 	if (!(rx_status->flag & RX_FLAG_NO_PSDU) &&
-	    iwl_mvm_check_pn(mvm, skb, queue, sta)) {
+	    iwl_mvm_check_pn(mvm, skb, queue, sta))
 		kfree_skb(skb);
-	} else {
-		unsigned int radiotap_len = 0;
-
-		if (rx_status->flag & RX_FLAG_RADIOTAP_HE)
-			radiotap_len += sizeof(struct ieee80211_radiotap_he);
-		if (rx_status->flag & RX_FLAG_RADIOTAP_HE_MU)
-			radiotap_len += sizeof(struct ieee80211_radiotap_he_mu);
-		__skb_push(skb, radiotap_len);
+	else
 		ieee80211_rx_napi(mvm->hw, sta, skb, napi);
-	}
 }
 
 static void iwl_mvm_get_signal_strength(struct iwl_mvm *mvm,
@@ -1438,9 +1430,15 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
 
 		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
-		/* toggle is switched whenever new aggregation starts */
+		/*
+		 * Toggle is switched whenever new aggregation starts. Make
+		 * sure ampdu_reference is never 0 so we can later use it to
+		 * see if the frame was really part of an A-MPDU or not.
+		 */
 		if (toggle_bit != mvm->ampdu_toggle) {
 			mvm->ampdu_ref++;
+			if (mvm->ampdu_ref == 0)
+				mvm->ampdu_ref++;
 			mvm->ampdu_toggle = toggle_bit;
 		}
 		rx_status->ampdu_reference = mvm->ampdu_ref;
-- 
2.20.1

