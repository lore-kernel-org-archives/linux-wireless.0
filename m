Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E8AC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F4252084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F4252084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbeJASr5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:47:57 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54352 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729270AbeJASr5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:47:57 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g6x1s-0006wq-DO; Mon, 01 Oct 2018 15:10:25 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon,  1 Oct 2018 15:10:01 +0300
Message-Id: <20181001121010.29684-8-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181001121010.29684-1-luca@coelho.fi>
References: <20181001121010.29684-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/16] iwlwifi: mvm Support new MCC update response
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Change MCC update response API to be compatible with new FW API.
While at it change v2 which is not in use anymore to v3 and cleanup
mcc_update v1 command and response which is obsolete.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   | 67 ++++++++-----------
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |  7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c  | 25 ++++---
 3 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index d22c1eefba6a..93b392f0c6a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -269,22 +269,6 @@ struct iwl_nvm_access_complete_cmd {
 	__le32 reserved;
 } __packed; /* NVM_ACCESS_COMPLETE_CMD_API_S_VER_1 */
 
-/**
- * struct iwl_mcc_update_cmd_v1 - Request the device to update geographic
- * regulatory profile according to the given MCC (Mobile Country Code).
- * The MCC is two letter-code, ascii upper case[A-Z] or '00' for world domain.
- * 'ZZ' MCC will be used to switch to NVM default profile; in this case, the
- * MCC in the cmd response will be the relevant MCC in the NVM.
- * @mcc: given mobile country code
- * @source_id: the source from where we got the MCC, see iwl_mcc_source
- * @reserved: reserved for alignment
- */
-struct iwl_mcc_update_cmd_v1 {
-	__le16 mcc;
-	u8 source_id;
-	u8 reserved;
-} __packed; /* LAR_UPDATE_MCC_CMD_API_S_VER_1 */
-
 /**
  * struct iwl_mcc_update_cmd - Request the device to update geographic
  * regulatory profile according to the given MCC (Mobile Country Code).
@@ -306,7 +290,18 @@ struct iwl_mcc_update_cmd {
 } __packed; /* LAR_UPDATE_MCC_CMD_API_S_VER_2 */
 
 /**
- * struct iwl_mcc_update_resp_v1  - response to MCC_UPDATE_CMD.
+ * enum iwl_geo_information - geographic information.
+ * @GEO_NO_INFO: no special info for this geo profile.
+ * @GEO_WMM_ETSI_5GHZ_INFO: this geo profile limits the WMM params
+ *	for the 5 GHz band.
+ */
+enum iwl_geo_information {
+	GEO_NO_INFO =			0,
+	GEO_WMM_ETSI_5GHZ_INFO =	BIT(0),
+};
+
+/**
+ * struct iwl_mcc_update_resp_v3 - response to MCC_UPDATE_CMD.
  * Contains the new channel control profile map, if changed, and the new MCC
  * (mobile country code).
  * The new MCC may be different than what was requested in MCC_UPDATE_CMD.
@@ -314,30 +309,23 @@ struct iwl_mcc_update_cmd {
  * @mcc: the new applied MCC
  * @cap: capabilities for all channels which matches the MCC
  * @source_id: the MCC source, see iwl_mcc_source
- * @n_channels: number of channels in @channels_data (may be 14, 39, 50 or 51
- *		channels, depending on platform)
+ * @time: time elapsed from the MCC test start (in units of 30 seconds)
+ * @geo_info: geographic specific profile information
+ *	see &enum iwl_geo_information.
+ * @n_channels: number of channels in @channels_data.
  * @channels: channel control data map, DWORD for each channel. Only the first
  *	16bits are used.
  */
-struct iwl_mcc_update_resp_v1  {
+struct iwl_mcc_update_resp_v3 {
 	__le32 status;
 	__le16 mcc;
 	u8 cap;
 	u8 source_id;
+	__le16 time;
+	__le16 geo_info;
 	__le32 n_channels;
 	__le32 channels[0];
-} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_1 */
-
-/**
- * enum iwl_geo_information - geographic information.
- * @GEO_NO_INFO: no special info for this geo profile.
- * @GEO_WMM_ETSI_5GHZ_INFO: this geo profile limits the WMM params
- *	for the 5 GHz band.
- */
-enum iwl_geo_information {
-	GEO_NO_INFO =			0,
-	GEO_WMM_ETSI_5GHZ_INFO =	BIT(0),
-};
+} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_3 */
 
 /**
  * struct iwl_mcc_update_resp - response to MCC_UPDATE_CMD.
@@ -347,25 +335,26 @@ enum iwl_geo_information {
  * @status: see &enum iwl_mcc_update_status
  * @mcc: the new applied MCC
  * @cap: capabilities for all channels which matches the MCC
- * @source_id: the MCC source, see iwl_mcc_source
- * @time: time elapsed from the MCC test start (in 30 seconds TU)
+ * @time: time elapsed from the MCC test start (in units of 30 seconds)
  * @geo_info: geographic specific profile information
  *	see &enum iwl_geo_information.
- * @n_channels: number of channels in @channels_data (may be 14, 39, 50 or 51
- *		channels, depending on platform)
+ * @source_id: the MCC source, see iwl_mcc_source
+ * @reserved: for four bytes alignment.
+ * @n_channels: number of channels in @channels_data.
  * @channels: channel control data map, DWORD for each channel. Only the first
  *	16bits are used.
  */
 struct iwl_mcc_update_resp {
 	__le32 status;
 	__le16 mcc;
-	u8 cap;
-	u8 source_id;
+	__le16 cap;
 	__le16 time;
 	__le16 geo_info;
+	u8 source_id;
+	u8 reserved[3];
 	__le32 n_channels;
 	__le32 channels[0];
-} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_3 */
+} __packed; /* LAR_UPDATE_MCC_CMD_RESP_S_VER_4 */
 
 /**
  * struct iwl_mcc_chub_notif - chub notifies of mcc change
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 63e277b07b8a..6005a41c53d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -337,7 +337,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  *	antenna the beacon should be transmitted
  * @IWL_UCODE_TLV_CAPA_BEACON_STORING: firmware will store the latest beacon
  *	from AP and will send it upon d0i3 exit.
- * @IWL_UCODE_TLV_CAPA_LAR_SUPPORT_V2: support LAR API V2
+ * @IWL_UCODE_TLV_CAPA_LAR_SUPPORT_V3: support LAR API V3
  * @IWL_UCODE_TLV_CAPA_CT_KILL_BY_FW: firmware responsible for CT-kill
  * @IWL_UCODE_TLV_CAPA_TEMP_THS_REPORT_SUPPORT: supports temperature
  *	thresholds reporting
@@ -352,6 +352,8 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  *	power reduction.
  * @IWL_UCODE_TLV_CAPA_MLME_OFFLOAD: supports MLME offload
  * @IWL_UCODE_TLV_CAPA_D3_DEBUG: supports debug recording during D3
+ * @IWL_UCODE_TLV_CAPA_MCC_UPDATE_11AX_SUPPORT: MCC response support 11ax
+ *	capability.
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -392,7 +394,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_CSA_AND_TBTT_OFFLOAD		= (__force iwl_ucode_tlv_capa_t)70,
 	IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION		= (__force iwl_ucode_tlv_capa_t)71,
 	IWL_UCODE_TLV_CAPA_BEACON_STORING		= (__force iwl_ucode_tlv_capa_t)72,
-	IWL_UCODE_TLV_CAPA_LAR_SUPPORT_V2		= (__force iwl_ucode_tlv_capa_t)73,
+	IWL_UCODE_TLV_CAPA_LAR_SUPPORT_V3		= (__force iwl_ucode_tlv_capa_t)73,
 	IWL_UCODE_TLV_CAPA_CT_KILL_BY_FW		= (__force iwl_ucode_tlv_capa_t)74,
 	IWL_UCODE_TLV_CAPA_TEMP_THS_REPORT_SUPPORT	= (__force iwl_ucode_tlv_capa_t)75,
 	IWL_UCODE_TLV_CAPA_CTDP_SUPPORT			= (__force iwl_ucode_tlv_capa_t)76,
@@ -402,6 +404,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_TX_POWER_ACK			= (__force iwl_ucode_tlv_capa_t)84,
 	IWL_UCODE_TLV_CAPA_D3_DEBUG			= (__force iwl_ucode_tlv_capa_t)87,
 	IWL_UCODE_TLV_CAPA_LED_CMD_SUPPORT		= (__force iwl_ucode_tlv_capa_t)88,
+	IWL_UCODE_TLV_CAPA_MCC_UPDATE_11AX_SUPPORT	= (__force iwl_ucode_tlv_capa_t)89,
 	IWL_UCODE_TLV_CAPA_MLME_OFFLOAD			= (__force iwl_ucode_tlv_capa_t)96,
 
 	NUM_IWL_UCODE_TLV_CAPA
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index fff98fed35ed..3633f27d048a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -477,15 +477,11 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	u32 status;
 	int resp_len, n_channels;
 	u16 mcc;
-	bool resp_v2 = fw_has_capa(&mvm->fw->ucode_capa,
-				   IWL_UCODE_TLV_CAPA_LAR_SUPPORT_V2);
 
 	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	cmd.len[0] = sizeof(struct iwl_mcc_update_cmd);
-	if (!resp_v2)
-		cmd.len[0] = sizeof(struct iwl_mcc_update_cmd_v1);
 
 	IWL_DEBUG_LAR(mvm, "send MCC update to FW with '%c%c' src = %d\n",
 		      alpha2[0], alpha2[1], src_id);
@@ -497,7 +493,8 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	pkt = cmd.resp_pkt;
 
 	/* Extract MCC response */
-	if (resp_v2) {
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_MCC_UPDATE_11AX_SUPPORT)) {
 		struct iwl_mcc_update_resp *mcc_resp = (void *)pkt->data;
 
 		n_channels =  __le32_to_cpu(mcc_resp->n_channels);
@@ -509,9 +506,9 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 			goto exit;
 		}
 	} else {
-		struct iwl_mcc_update_resp_v1 *mcc_resp_v1 = (void *)pkt->data;
+		struct iwl_mcc_update_resp_v3 *mcc_resp_v3 = (void *)pkt->data;
 
-		n_channels =  __le32_to_cpu(mcc_resp_v1->n_channels);
+		n_channels =  __le32_to_cpu(mcc_resp_v3->n_channels);
 		resp_len = sizeof(struct iwl_mcc_update_resp) +
 			   n_channels * sizeof(__le32);
 		resp_cp = kzalloc(resp_len, GFP_KERNEL);
@@ -520,12 +517,14 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 			goto exit;
 		}
 
-		resp_cp->status = mcc_resp_v1->status;
-		resp_cp->mcc = mcc_resp_v1->mcc;
-		resp_cp->cap = mcc_resp_v1->cap;
-		resp_cp->source_id = mcc_resp_v1->source_id;
-		resp_cp->n_channels = mcc_resp_v1->n_channels;
-		memcpy(resp_cp->channels, mcc_resp_v1->channels,
+		resp_cp->status = mcc_resp_v3->status;
+		resp_cp->mcc = mcc_resp_v3->mcc;
+		resp_cp->cap = cpu_to_le16(mcc_resp_v3->cap);
+		resp_cp->source_id = mcc_resp_v3->source_id;
+		resp_cp->time = mcc_resp_v3->time;
+		resp_cp->geo_info = mcc_resp_v3->geo_info;
+		resp_cp->n_channels = mcc_resp_v3->n_channels;
+		memcpy(resp_cp->channels, mcc_resp_v3->channels,
 		       n_channels * sizeof(__le32));
 	}
 
-- 
2.19.0

