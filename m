Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE7C400990
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141870; cv=none; b=KiJLPX9vt9fV2hdjJboSwNvREgjnp3GUEw7I7wAey6etTxiNtQ2jHaFAp2o4gbDFFp6mXua8uNmFuJTOFLe/RGKhbjc78Bi2KschnPxTpwEchCpJ28aW0xQ2GJfXpYJ5f3yJbl638LF1KU2ScYp0s+ZLhfjLl7DEwDDKxFn2SNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141870; c=relaxed/simple;
	bh=mVYT+Ua8y31q8K0YXVDSamAL5PpTBt9kJHbnEnFbcmo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EGxwBmkhiyVE8Vm4be6pMmrZQbhQvbrFgfUMHYcwvOQKPSQMn2iMJ+oKaNj0sETjh/6AkMq5TRPz+sOYPo5wY+SzIE5i0ayMqpFbJt/koKH27tsswnfSeyJdDxvg54K+pUU58jrjPSafnjZXYpfDF4NBAtXK5PcwIFaMQV0UWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f14nVSVP; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f14nVSVP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141866; x=1815677866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mVYT+Ua8y31q8K0YXVDSamAL5PpTBt9kJHbnEnFbcmo=;
  b=f14nVSVPjNNaR7aNBcXnWjMl1e7Z4XEtQsaXRw3kHpvzjICePZtDTk+/
   yNqHja9MM6M/YNwrV6I3k6fmzZKztUUUT04CwsX5jdvGXUmoomVDGaWgv
   WrZDYtqqSivVgiPVckEdh/Y3ulv4T1eizkXKhvhB89JkC7pVew8YGN8YN
   yhH7D9ckIv/rqwo7o9E02WDy/Q9Hu0rdgViDy8+Ya+o/uP+lWDiVhNC31
   1tNtK0lQZWPXpoD7rUQW0i/mi8IrU2LHPt8S3DGY3czk4skg/RpkrKwB0
   9a6kW5V7pr83fM5lAYdpbvV0RZqAP8tXAXaTvJeL40g2beBWDuHrhUESU
   A==;
X-CSE-ConnectionGUID: vNa+p/HgTNSjFSykFDqWRw==
X-CSE-MsgGUID: PlwCxJ/zR+6QoD6tQh3QXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160887"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160887"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:40 -0700
X-CSE-ConnectionGUID: VDSozV4oQtSJqv1LjxCg/A==
X-CSE-MsgGUID: yxZRMtNUSGuMT2/UcM7IwQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:39 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-fixes 02/15] wifi: iwlwifi: add support for additional channels in NVM_GET_INFO
Date: Wed, 15 Jul 2026 21:57:02 +0300
Message-Id: <20260715215523.473f48e6135d.I0e93cda753558aa4d9e3efcdd52cbc2eb9302c4a@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We need to expect more channels on devices that support UNII-9.
Since iwl_ext_nvm_channels and iwl_uhb_nvm_channels are just a prefix
of iwl_unii9_nvm_channels just use iwl_unii9_nvm_channels and modify the
number of channels if the device does not support UNII-9 channels.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/rf-pe.c    |  1 +
 .../wireless/intel/iwlwifi/fw/api/nvm-reg.h   | 33 +++++++++-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  2 +
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 64 ++++++++++++-------
 4 files changed, 74 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/rf-pe.c b/drivers/net/wireless/intel/iwlwifi/cfg/rf-pe.c
index 7a04cb120b1b..6080f5f23e69 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/rf-pe.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/rf-pe.c
@@ -15,6 +15,7 @@
 	.non_shared_ant = ANT_B,					\
 	.vht_mu_mimo_supported = true,					\
 	.uhb_supported = true,						\
+	.unii9_supported = true,					\
 	.eht_supported = true,						\
 	.uhr_supported = true,						\
 	.num_rbds = IWL_NUM_RBDS_EHT,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 443a9a416325..0172c0747a47 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -205,6 +205,7 @@ struct iwl_nvm_get_info_phy {
 
 #define IWL_NUM_CHANNELS_V1	51
 #define IWL_NUM_CHANNELS_V2	110
+#define IWL_NUM_CHANNELS_V3	115
 
 /**
  * struct iwl_nvm_get_info_regulatory_v1 - regulatory information
@@ -219,12 +220,12 @@ struct iwl_nvm_get_info_regulatory_v1 {
 } __packed; /* REGULATORY_NVM_GET_INFO_REGULATORY_S_VER_1 */
 
 /**
- * struct iwl_nvm_get_info_regulatory - regulatory information
+ * struct iwl_nvm_get_info_regulatory_v2 - regulatory information
  * @lar_enabled: is LAR enabled
  * @n_channels: number of valid channels in the array
  * @channel_profile: regulatory data of this channel
  */
-struct iwl_nvm_get_info_regulatory {
+struct iwl_nvm_get_info_regulatory_v2 {
 	__le32 lar_enabled;
 	__le32 n_channels;
 	__le32 channel_profile[IWL_NUM_CHANNELS_V2];
@@ -244,6 +245,32 @@ struct iwl_nvm_get_info_rsp_v3 {
 	struct iwl_nvm_get_info_regulatory_v1 regulatory;
 } __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_3 */
 
+/**
+ * struct iwl_nvm_get_info_rsp_v4 - response to get NVM data
+ * @general: general NVM data
+ * @mac_sku: data relating to MAC sku
+ * @phy_sku: data relating to PHY sku
+ * @regulatory: regulatory data
+ */
+struct iwl_nvm_get_info_rsp_v4 {
+	struct iwl_nvm_get_info_general general;
+	struct iwl_nvm_get_info_sku mac_sku;
+	struct iwl_nvm_get_info_phy phy_sku;
+	struct iwl_nvm_get_info_regulatory_v2 regulatory;
+} __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_4 */
+
+/**
+ * struct iwl_nvm_get_info_regulatory - regulatory information
+ * @lar_enabled: is LAR enabled
+ * @n_channels: number of valid channels in the array
+ * @channel_profile: regulatory data of this channel
+ */
+struct iwl_nvm_get_info_regulatory {
+	__le32 lar_enabled;
+	__le32 n_channels;
+	__le32 channel_profile[IWL_NUM_CHANNELS_V3];
+} __packed; /* REGULATORY_NVM_GET_INFO_REGULATORY_S_VER_3 */
+
 /**
  * struct iwl_nvm_get_info_rsp - response to get NVM data
  * @general: general NVM data
@@ -256,7 +283,7 @@ struct iwl_nvm_get_info_rsp {
 	struct iwl_nvm_get_info_sku mac_sku;
 	struct iwl_nvm_get_info_phy phy_sku;
 	struct iwl_nvm_get_info_regulatory regulatory;
-} __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_4 */
+} __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_5 */
 
 /**
  * struct iwl_nvm_access_complete_cmd - NVM_ACCESS commands are completed
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 6a3539ad7331..3ac7f000ede4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -415,6 +415,7 @@ struct iwl_mac_cfg {
  * @vht_mu_mimo_supported: VHT MU-MIMO support
  * @nvm_type: see &enum iwl_nvm_type
  * @uhb_supported: ultra high band channels supported
+ * @unii9_supported: UNII-9 channels supported
  * @eht_supported: EHT supported
  * @uhr_supported: UHR supported
  * @num_rbds: number of receive buffer descriptors to use
@@ -450,6 +451,7 @@ struct iwl_rf_cfg {
 	    lp_xtal_workaround:1,
 	    vht_mu_mimo_supported:1,
 	    uhb_supported:1,
+	    unii9_supported:1,
 	    eht_supported:1,
 	    uhr_supported:1;
 	u8 valid_tx_ant;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index d47b4ae2f486..bd5353fdde81 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -85,16 +85,7 @@ static const u16 iwl_nvm_channels[] = {
 	149, 153, 157, 161, 165
 };
 
-static const u16 iwl_ext_nvm_channels[] = {
-	/* 2.4 GHz */
-	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
-	/* 5 GHz */
-	36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92,
-	96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144,
-	149, 153, 157, 161, 165, 169, 173, 177, 181
-};
-
-static const u16 iwl_uhb_nvm_channels[] = {
+static const u16 iwl_unii9_nvm_channels[] = {
 	/* 2.4 GHz */
 	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
 	/* 5 GHz */
@@ -105,12 +96,16 @@ static const u16 iwl_uhb_nvm_channels[] = {
 	1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69,
 	73, 77, 81, 85, 89, 93, 97, 101, 105, 109, 113, 117, 121, 125, 129,
 	133, 137, 141, 145, 149, 153, 157, 161, 165, 169, 173, 177, 181, 185,
-	189, 193, 197, 201, 205, 209, 213, 217, 221, 225, 229, 233
+	189, 193, 197, 201, 205, 209, 213, 217, 221, 225, 229, 233,
+
+	/* UNII-9 */
+	237, 241, 245, 249, 253
 };
 
 #define IWL_NVM_NUM_CHANNELS		ARRAY_SIZE(iwl_nvm_channels)
-#define IWL_NVM_NUM_CHANNELS_EXT	ARRAY_SIZE(iwl_ext_nvm_channels)
-#define IWL_NVM_NUM_CHANNELS_UHB	ARRAY_SIZE(iwl_uhb_nvm_channels)
+#define IWL_NVM_NUM_CHANNELS_EXT	51
+#define IWL_NVM_NUM_CHANNELS_UHB	110
+#define IWL_NVM_NUM_CHANNELS_UNII9	ARRAY_SIZE(iwl_unii9_nvm_channels)
 #define NUM_2GHZ_CHANNELS		14
 #define NUM_5GHZ_CHANNELS		37
 #define FIRST_2GHZ_HT_MINUS		5
@@ -351,12 +346,15 @@ static int iwl_init_channel_map(struct iwl_trans *trans,
 	int num_of_ch;
 	const u16 *nvm_chan;
 
-	if (cfg->uhb_supported) {
+	if (cfg->unii9_supported) {
+		num_of_ch = IWL_NVM_NUM_CHANNELS_UNII9;
+		nvm_chan = iwl_unii9_nvm_channels;
+	} else if (cfg->uhb_supported) {
 		num_of_ch = IWL_NVM_NUM_CHANNELS_UHB;
-		nvm_chan = iwl_uhb_nvm_channels;
+		nvm_chan = iwl_unii9_nvm_channels;
 	} else if (cfg->nvm_type == IWL_NVM_EXT) {
 		num_of_ch = IWL_NVM_NUM_CHANNELS_EXT;
-		nvm_chan = iwl_ext_nvm_channels;
+		nvm_chan = iwl_unii9_nvm_channels;
 	} else {
 		num_of_ch = IWL_NVM_NUM_CHANNELS;
 		nvm_chan = iwl_nvm_channels;
@@ -1441,7 +1439,9 @@ iwl_parse_mei_nvm_data(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	u8 rx_chains = fw->valid_rx_ant;
 	u8 tx_chains = fw->valid_rx_ant;
 
-	if (cfg->uhb_supported)
+	if (cfg->unii9_supported)
+		data = kzalloc_flex(*data, channels, IWL_NVM_NUM_CHANNELS_UNII9);
+	else if (cfg->uhb_supported)
 		data = kzalloc_flex(*data, channels, IWL_NVM_NUM_CHANNELS_UHB);
 	else
 		data = kzalloc_flex(*data, channels, IWL_NVM_NUM_CHANNELS_EXT);
@@ -1506,7 +1506,9 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	u16 lar_config;
 	const __le16 *ch_section;
 
-	if (cfg->uhb_supported)
+	if (cfg->unii9_supported)
+		data = kzalloc_flex(*data, channels, IWL_NVM_NUM_CHANNELS_UNII9);
+	else if (cfg->uhb_supported)
 		data = kzalloc_flex(*data, channels, IWL_NVM_NUM_CHANNELS_UHB);
 	else if (cfg->nvm_type != IWL_NVM_EXT)
 		data = kzalloc_flex(*data, channels, IWL_NVM_NUM_CHANNELS);
@@ -1727,12 +1729,15 @@ iwl_parse_nvm_mcc_info(struct iwl_trans *trans,
 	int max_num_ch;
 	struct iwl_reg_capa reg_capa;
 
-	if (cfg->uhb_supported) {
+	if (cfg->unii9_supported) {
+		max_num_ch = IWL_NVM_NUM_CHANNELS_UNII9;
+		nvm_chan = iwl_unii9_nvm_channels;
+	} else if (cfg->uhb_supported) {
 		max_num_ch = IWL_NVM_NUM_CHANNELS_UHB;
-		nvm_chan = iwl_uhb_nvm_channels;
+		nvm_chan = iwl_unii9_nvm_channels;
 	} else if (cfg->nvm_type == IWL_NVM_EXT) {
 		max_num_ch = IWL_NVM_NUM_CHANNELS_EXT;
-		nvm_chan = iwl_ext_nvm_channels;
+		nvm_chan = iwl_unii9_nvm_channels;
 	} else {
 		max_num_ch = IWL_NVM_NUM_CHANNELS;
 		nvm_chan = iwl_nvm_channels;
@@ -2087,13 +2092,26 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	struct iwl_nvm_get_info_rsp_v3 *rsp_v3;
 	bool v4 = fw_has_api(&fw->ucode_capa,
 			     IWL_UCODE_TLV_API_REGULATORY_NVM_INFO);
-	size_t rsp_size = v4 ? sizeof(*rsp) : sizeof(*rsp_v3);
+	size_t rsp_size;
 	void *channel_profile;
 
 	ret = iwl_trans_send_cmd(trans, &hcmd);
 	if (ret)
 		return ERR_PTR(ret);
 
+	switch (iwl_fw_lookup_notif_ver(fw, REGULATORY_AND_NVM_GROUP,
+					NVM_GET_INFO, 0)) {
+	case 5:
+		rsp_size = sizeof(struct iwl_nvm_get_info_rsp);
+		break;
+	case 4:
+		rsp_size = sizeof(struct iwl_nvm_get_info_rsp_v4);
+		break;
+	default:
+		rsp_size = sizeof(struct iwl_nvm_get_info_rsp_v3);
+		break;
+	}
+
 	if (WARN(iwl_rx_packet_payload_len(hcmd.resp_pkt) != rsp_size,
 		 "Invalid payload len in NVM response from FW %d",
 		 iwl_rx_packet_payload_len(hcmd.resp_pkt))) {
@@ -2107,7 +2125,7 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	if (empty_otp)
 		IWL_INFO(trans, "OTP is empty\n");
 
-	nvm = kzalloc_flex(*nvm, channels, IWL_NUM_CHANNELS_V2);
+	nvm = kzalloc_flex(*nvm, channels, IWL_NUM_CHANNELS_V3);
 	if (!nvm) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.34.1

