Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25942C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00FA5218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfCVOAQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:00:16 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46252 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727994AbfCVOAQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:00:16 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khn-0000bK-IR; Fri, 22 Mar 2019 15:59:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:59:02 +0200
Message-Id: <20190322135903.10631-24-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 23/24] iwlwifi: mvm: support HE context cmd API change
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Support API change to pass all mbssid parameters to the firmware.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 77 ++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  3 +
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 12 ++-
 3 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
index 941c50477003..85c5e367cbf1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
@@ -541,6 +541,66 @@ enum iwl_he_htc_flags {
 #define IWL_HE_HTC_LINK_ADAP_UNSOLICITED	(2 << IWL_HE_HTC_LINK_ADAP_POS)
 #define IWL_HE_HTC_LINK_ADAP_BOTH		(3 << IWL_HE_HTC_LINK_ADAP_POS)
 
+/**
+ * struct iwl_he_sta_context_cmd_v1 - configure FW to work with HE AP
+ * @sta_id: STA id
+ * @tid_limit: max num of TIDs in TX HE-SU multi-TID agg
+ *	0 - bad value, 1 - multi-tid not supported, 2..8 - tid limit
+ * @reserved1: reserved byte for future use
+ * @reserved2: reserved byte for future use
+ * @flags: see %iwl_11ax_sta_ctxt_flags
+ * @ref_bssid_addr: reference BSSID used by the AP
+ * @reserved0: reserved 2 bytes for aligning the ref_bssid_addr field to 8 bytes
+ * @htc_flags: which features are supported in HTC
+ * @frag_flags: frag support in A-MSDU
+ * @frag_level: frag support level
+ * @frag_max_num: max num of "open" MSDUs in the receiver (in power of 2)
+ * @frag_min_size: min frag size (except last frag)
+ * @pkt_ext: optional, exists according to PPE-present bit in the HE-PHY capa
+ * @bss_color: 11ax AP ID that is used in the HE SIG-A to mark inter BSS frame
+ * @htc_trig_based_pkt_ext: default PE in 4us units
+ * @frame_time_rts_th: HE duration RTS threshold, in units of 32us
+ * @rand_alloc_ecwmin: random CWmin = 2**ECWmin-1
+ * @rand_alloc_ecwmax: random CWmax = 2**ECWmax-1
+ * @reserved3: reserved byte for future use
+ * @trig_based_txf: MU EDCA Parameter set for the trigger based traffic queues
+ */
+struct iwl_he_sta_context_cmd_v1 {
+	u8 sta_id;
+	u8 tid_limit;
+	u8 reserved1;
+	u8 reserved2;
+	__le32 flags;
+
+	/* The below fields are set via Multiple BSSID IE */
+	u8 ref_bssid_addr[6];
+	__le16 reserved0;
+
+	/* The below fields are set via HE-capabilities IE */
+	__le32 htc_flags;
+
+	u8 frag_flags;
+	u8 frag_level;
+	u8 frag_max_num;
+	u8 frag_min_size;
+
+	/* The below fields are set via PPE thresholds element */
+	struct iwl_he_pkt_ext pkt_ext;
+
+	/* The below fields are set via HE-Operation IE */
+	u8 bss_color;
+	u8 htc_trig_based_pkt_ext;
+	__le16 frame_time_rts_th;
+
+	/* Random access parameter set (i.e. RAPS) */
+	u8 rand_alloc_ecwmin;
+	u8 rand_alloc_ecwmax;
+	__le16 reserved3;
+
+	/* The below fields are set via MU EDCA parameter set element */
+	struct iwl_he_backoff_conf trig_based_txf[AC_NUM];
+} __packed; /* STA_CONTEXT_DOT11AX_API_S_VER_1 */
+
 /**
  * struct iwl_he_sta_context_cmd - configure FW to work with HE AP
  * @sta_id: STA id
@@ -564,6 +624,14 @@ enum iwl_he_htc_flags {
  * @rand_alloc_ecwmax: random CWmax = 2**ECWmax-1
  * @reserved3: reserved byte for future use
  * @trig_based_txf: MU EDCA Parameter set for the trigger based traffic queues
+ * @max_bssid_indicator: indicator of the max bssid supported on the associated
+ *	bss
+ * @bssid_index: index of the associated VAP
+ * @ema_ap: AP supports enhanced Multi BSSID advertisement
+ * @profile_periodicity: number of Beacon periods that are needed to receive the
+ *	complete VAPs info
+ * @bssid_count: actual number of VAPs in the MultiBSS Set
+ * @reserved4: alignment
  */
 struct iwl_he_sta_context_cmd {
 	u8 sta_id;
@@ -599,7 +667,14 @@ struct iwl_he_sta_context_cmd {
 
 	/* The below fields are set via MU EDCA parameter set element */
 	struct iwl_he_backoff_conf trig_based_txf[AC_NUM];
-} __packed; /* STA_CONTEXT_DOT11AX_API_S */
+
+	u8 max_bssid_indicator;
+	u8 bssid_index;
+	u8 ema_ap;
+	u8 profile_periodicity;
+	u8 bssid_count;
+	u8 reserved4[3];
+} __packed; /* STA_CONTEXT_DOT11AX_API_S_VER_2 */
 
 /**
  * struct iwl_he_monitor_cmd - configure air sniffer for HE
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index b7328861c725..abfdcabdcbf7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -279,6 +279,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS: This ucode supports v2 of
  *	SCAN_OFFLOAD_PROFILE_MATCH_RESULTS_S and v3 of
  *	SCAN_OFFLOAD_PROFILES_QUERY_RSP_S.
+ * @IWL_UCODE_TLV_API_MBSSID_HE: This ucode supports v2 of
+ *	STA_CONTEXT_DOT11AX_API_S
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -308,6 +310,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_REGULATORY_NVM_INFO   = (__force iwl_ucode_tlv_api_t)48,
 	IWL_UCODE_TLV_API_FTM_NEW_RANGE_REQ     = (__force iwl_ucode_tlv_api_t)49,
 	IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS    = (__force iwl_ucode_tlv_api_t)50,
+	IWL_UCODE_TLV_API_MBSSID_HE		= (__force iwl_ucode_tlv_api_t)52,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d55c7df813e3..bb2dc0be3621 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2212,6 +2212,10 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 		.frame_time_rts_th =
 			cpu_to_le16(vif->bss_conf.frame_time_rts_th),
 	};
+	int size = fw_has_api(&mvm->fw->ucode_capa,
+			      IWL_UCODE_TLV_API_MBSSID_HE) ?
+		   sizeof(sta_ctxt_cmd) :
+		   sizeof(struct iwl_he_sta_context_cmd_v1);
 	struct ieee80211_sta *sta;
 	u32 flags;
 	int i;
@@ -2399,13 +2403,19 @@ static void iwl_mvm_cfg_he_sta(struct iwl_mvm *mvm,
 		flags |= STA_CTXT_HE_REF_BSSID_VALID;
 		ether_addr_copy(sta_ctxt_cmd.ref_bssid_addr,
 				vif->bss_conf.transmitter_bssid);
+		sta_ctxt_cmd.max_bssid_indicator =
+			vif->bss_conf.bssid_indicator;
+		sta_ctxt_cmd.bssid_index = vif->bss_conf.bssid_index;
+		sta_ctxt_cmd.ema_ap = vif->bss_conf.ema_ap;
+		sta_ctxt_cmd.profile_periodicity =
+			vif->bss_conf.profile_periodicity;
 	}
 
 	sta_ctxt_cmd.flags = cpu_to_le32(flags);
 
 	if (iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(STA_HE_CTXT_CMD,
 						 DATA_PATH_GROUP, 0),
-				 0, sizeof(sta_ctxt_cmd), &sta_ctxt_cmd))
+				 0, size, &sta_ctxt_cmd))
 		IWL_ERR(mvm, "Failed to config FW to work HE!\n");
 }
 
-- 
2.20.1

