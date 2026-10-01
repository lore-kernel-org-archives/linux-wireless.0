Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D434AA00F
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860720; cv=none; b=hdvGGcjC/eyrwsfzuxHpdyHDeq5XxjgoelfE+09VNNqrvDKhSSgdUMMEHWM8MOmAKXeQDClcG4knRghxf69FNb1ZNMU/FYnPhn3X8MloHdU0wJOTiT5JubhdJSJ0qT9JCBJI0SmGy5tGKhzXbQSt8E2ygbm69DG6mwdu4MFCGUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860720; c=relaxed/simple;
	bh=uXBYeDfgXpkO8pgP/2iLi2pRJPtEqji0uLt36kD2gFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FbZL8DOlxk0mSbHRCCMRsGWlzygumGEkzuCgJDdzZ01XatDxfqBdBWU3j/GgLW3lJTw3iVNmm3rVMj+ScgX9rEtLFmUeWiNhDuh4ryWNXDuUyCL/Ky7ZOlywQZFzOWcUumNH8rKQlbqVr3GWKWlP/bWgUMYy+cSeVKgXOdpib2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=niKD5GqH; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="niKD5GqH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860715; x=1822396715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uXBYeDfgXpkO8pgP/2iLi2pRJPtEqji0uLt36kD2gFA=;
  b=niKD5GqH+UImfGvzOFVc7usykL8V9R/2cBR116vgTi2dVmA34QRRurIr
   kpTcizxYOrYzIDX5qUJPh1PLne+WoO6rsXwIH2mNMhmkR16iIkFYMKc0g
   gSL35dLLbvkFcKiqL0WJbD0EmJLKW6mLud/ytw2dfAyky9JBYfMQjlO7t
   04qmVRlp5hBwqrQjXxId/SAV4KeGyYcYleM/gx2awL3hUg/q7e/SBYvCH
   CjU+Bzo0BOikIWKam7hB+Bg9ewGraVJI1LAUJVO+T540bgwQmyKeUxLmQ
   hGoE4IxD0VsLVef8LNpzLRsakHmvw+34XtdnwVUSuHBzLQEdjGsJl0FJd
   Q==;
X-CSE-ConnectionGUID: jnIFF15dQcyNELBluh65aA==
X-CSE-MsgGUID: /gbuZz3nRyWJYwErbJf+pA==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423618"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423618"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:34 -0700
X-CSE-ConnectionGUID: NqHYIEMUQD+5PD9atr2DWg==
X-CSE-MsgGUID: aVWjzCbcTZqpmGJFqvvbLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485513"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:33 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 02/15] wifi: iwlwifi: mld: add UHR sniffer support
Date: Thu,  1 Oct 2026 16:20:15 +0300
Message-Id: <20261001161715.a1e1090ec775.I47fb568ddcd9d6aca634400b2d4850c1fef035ca@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Add UHR sniffer support as supported by the hardware.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 593 +++++++++++++++++++-
 1 file changed, 573 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 8fa438fd7815..1362e3ad97b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -944,8 +944,8 @@ static void iwl_mld_decode_eht_usig(struct iwl_mld_rx_phy_data *phy_data,
 }
 
 static void
-iwl_mld_eht_set_ru_alloc(struct ieee80211_rx_status *rx_status,
-			 u32 ru_with_p80)
+iwl_mld_eht_uhr_set_ru_alloc(struct ieee80211_rx_status *rx_status,
+			     u32 ru_with_p80, bool uhr)
 {
 	enum nl80211_eht_ru_alloc nl_ru;
 	u32 ru = ru_with_p80 >> 1;
@@ -1011,7 +1011,15 @@ iwl_mld_eht_set_ru_alloc(struct ieee80211_rx_status *rx_status,
 	}
 
 	rx_status->bw = RATE_INFO_BW_EHT_RU;
-	rx_status->eht.ru = nl_ru;
+
+	/*
+	 * This should get optimised away, but since it's bitfields,
+	 * we can't ensure uhr.ru and eht.ru overlap in the union.
+	 */
+	if (uhr)
+		rx_status->uhr.ru = nl_ru;
+	else
+		rx_status->eht.ru = nl_ru;
 }
 
 static void iwl_mld_decode_eht_tb(struct iwl_mld_rx_phy_data *phy_data,
@@ -1051,9 +1059,10 @@ static void iwl_mld_decode_eht_tb(struct iwl_mld_rx_phy_data *phy_data,
 				     OFDM_UCODE_TRIG_BASE_RX_RU_P80,
 				     IEEE80211_RADIOTAP_EHT_DATA1_PRIMARY_80);
 
-	iwl_mld_eht_set_ru_alloc(rx_status,
-				 le32_get_bits(phy_data->ntfy->sigs.eht_tb.tb_rx1,
-					       OFDM_UCODE_TRIG_BASE_RX_RU));
+	iwl_mld_eht_uhr_set_ru_alloc(rx_status,
+				     le32_get_bits(phy_data->ntfy->sigs.eht_tb.tb_rx1,
+						   OFDM_UCODE_TRIG_BASE_RX_RU),
+				     false);
 }
 
 static void iwl_mld_eht_decode_user_ru(struct iwl_mld_rx_phy_data *phy_data,
@@ -1209,9 +1218,10 @@ static void iwl_mld_decode_eht_non_tb(struct iwl_mld_rx_phy_data *phy_data,
 
 	iwl_mld_eht_decode_user_ru(phy_data, eht);
 
-	iwl_mld_eht_set_ru_alloc(rx_status,
-				 le32_get_bits(phy_data->ntfy->sigs.eht.b2,
-					       OFDM_RX_FRAME_EHT_STA_RU));
+	iwl_mld_eht_uhr_set_ru_alloc(rx_status,
+				     le32_get_bits(phy_data->ntfy->sigs.eht.b2,
+						   OFDM_RX_FRAME_EHT_STA_RU),
+				     false);
 
 	if (phy_data->with_data)
 		eht->user_info[0] |=
@@ -1317,7 +1327,7 @@ static void iwl_mld_rx_eht(struct iwl_mld *mld, struct sk_buff *skb,
 
 		eht->user_info[0] |=
 			le32_encode_bits(u32_get_bits(rate_n_flags,
-						      RATE_VHT_MCS_RATE_CODE_MSK),
+						      RATE_MCS_CODE_MSK),
 					 IEEE80211_RADIOTAP_EHT_USER_INFO_MCS) |
 			le32_encode_bits(u32_get_bits(rate_n_flags,
 						      RATE_MCS_NSS_MSK),
@@ -1331,6 +1341,526 @@ static void iwl_mld_rx_eht(struct iwl_mld *mld, struct sk_buff *skb,
 	iwl_mld_decode_eht_phy_data(phy_data, rx_status, eht);
 }
 
+static void iwl_mld_decode_uhr_usig_tb(struct iwl_mld_rx_phy_data *phy_data,
+				       struct ieee80211_radiotap_eht_usig *usig)
+{
+	__le32 usig_a1 = phy_data->ntfy->sigs.uhr_tb.usig_a1;
+	__le32 usig_a2 = phy_data->ntfy->sigs.uhr_tb.usig_a2_uhr;
+
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a1,
+				    OFDM_RX_FRAME_EHT_USIG1_DISREGARD |
+				    OFDM_RX_FRAME_EHT_USIG1_VALIDATE,
+				    IEEE80211_RADIOTAP_UHR_USIG1_TB_B20_B25_DISREGARD);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_PPDU_TYPE,
+				    IEEE80211_RADIOTAP_UHR_USIG2_TB_B0_B1_PPDU_TYPE);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    IEEE80211_RADIOTAP_UHR_USIG2_MU_B2_COBF_COSR,
+				    IEEE80211_RADIOTAP_UHR_USIG2_TB_B2_VALIDATE);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_TRIG_SPATIAL_REUSE_1,
+				    IEEE80211_RADIOTAP_UHR_USIG2_TB_B3_B6_SPATIAL_REUSE_1);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_TRIG_SPATIAL_REUSE_2,
+				    IEEE80211_RADIOTAP_UHR_USIG2_TB_B7_B10_SPATIAL_REUSE_2);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_TRIG_USIG2_DISREGARD,
+				    IEEE80211_RADIOTAP_UHR_USIG2_TB_B11_B15_DISREGARD);
+
+	if (le32_get_bits(usig_a1, OFDM_RX_FRAME_EHT_USIG1_VALIDATE) &&
+	    le32_get_bits(usig_a2, OFDM_RX_FRAME_UHR_USIG2_VALIDATE_B8))
+		usig->common |= cpu_to_le32(IEEE80211_RADIOTAP_EHT_USIG_COMMON_VALIDATE_BITS_OK);
+
+	if (!le32_get_bits(usig_a2, OFDM_RX_FRAME_UHR_USIG_CRC_OK))
+		usig->common |= cpu_to_le32(IEEE80211_RADIOTAP_EHT_USIG_COMMON_BAD_USIG_CRC);
+}
+
+static void iwl_mld_decode_uhr_usig_elr(struct iwl_mld_rx_phy_data *phy_data,
+					struct ieee80211_radiotap_eht_usig *usig)
+{
+	__le32 usig_a1 = phy_data->ntfy->sigs.uhr_elr.usig_a1;
+	__le32 usig_a2 = phy_data->ntfy->sigs.uhr_elr.usig_a2_uhr_elr;
+
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a1,
+				    OFDM_RX_FRAME_EHT_USIG1_DISREGARD,
+				    IEEE80211_RADIOTAP_UHR_USIG1_ELR_B20_B24_DISREGARD);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a1,
+				    OFDM_RX_FRAME_EHT_USIG1_VALIDATE,
+				    IEEE80211_RADIOTAP_UHR_USIG1_ELR_B25_VALIDATE);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_VECTOR_UHR_ELR_PPDU_TYPE,
+				    IEEE80211_RADIOTAP_UHR_USIG2_ELR_B0_B1_PPDU_TYPE);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_VECTOR_UHR_ELR_USIG_STA_ID,
+				    IEEE80211_RADIOTAP_UHR_USIG2_ELR_B2_B12_STA_ID);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_VECTOR_UHR_ELR_VALIDATE,
+				    IEEE80211_RADIOTAP_UHR_USIG2_ELR_B13_B15_VALIDATE);
+
+	if (le32_get_bits(usig_a1, OFDM_RX_FRAME_EHT_USIG1_VALIDATE) &&
+	    le32_get_bits(usig_a2, OFDM_RX_VECTOR_UHR_ELR_VALIDATE) == 0xe)
+		usig->common |= cpu_to_le32(IEEE80211_RADIOTAP_EHT_USIG_COMMON_VALIDATE_BITS_OK);
+
+	if (!le32_get_bits(usig_a2, OFDM_RX_VECTOR_UHR_ELR_CRC_OK))
+		usig->common |= cpu_to_le32(IEEE80211_RADIOTAP_EHT_USIG_COMMON_BAD_USIG_CRC);
+}
+
+static void iwl_mld_decode_uhr_usig_non_tb(struct iwl_mld_rx_phy_data *phy_data,
+					   struct ieee80211_radiotap_eht_usig *usig)
+{
+	__le32 usig_a1 = phy_data->ntfy->sigs.uhr.usig_a1;
+	__le32 usig_a2 = phy_data->ntfy->sigs.uhr.usig_a2_uhr;
+
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a1,
+				    OFDM_RX_FRAME_EHT_USIG1_DISREGARD,
+				    IEEE80211_RADIOTAP_UHR_USIG1_MU_B20_B24_DISREGARD);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a1,
+				    OFDM_RX_FRAME_EHT_USIG1_VALIDATE,
+				    IEEE80211_RADIOTAP_UHR_USIG1_MU_B25_VALIDATE);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_PPDU_TYPE,
+				    IEEE80211_RADIOTAP_UHR_USIG2_MU_B0_B1_PPDU_TYPE);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_COBF_CSR_DISABLE,
+				    IEEE80211_RADIOTAP_UHR_USIG2_MU_B2_COBF_COSR);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_PUNC_CHANNEL,
+				    IEEE80211_RADIOTAP_UHR_USIG2_MU_B3_B7_PUNCTURED_INFO);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_USIG2_VALIDATE_B8,
+				    IEEE80211_RADIOTAP_UHR_USIG2_MU_B8_VALIDATE);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_SIG_MCS,
+				    IEEE80211_RADIOTAP_UHR_USIG2_MU_B9_B10_SIG_MCS);
+	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
+				    OFDM_RX_FRAME_UHR_SIG_SYM_NUM,
+				    IEEE80211_RADIOTAP_UHR_USIG2_MU_B11_B15_UHR_SIG_SYMBOLS);
+
+	if (le32_get_bits(usig_a1, OFDM_RX_FRAME_EHT_USIG1_VALIDATE) &&
+	    le32_get_bits(usig_a2, OFDM_RX_FRAME_UHR_USIG2_VALIDATE_B8))
+		usig->common |= cpu_to_le32(IEEE80211_RADIOTAP_EHT_USIG_COMMON_VALIDATE_BITS_OK);
+
+	if (!le32_get_bits(usig_a2, OFDM_RX_FRAME_UHR_USIG_CRC_OK))
+		usig->common |= cpu_to_le32(IEEE80211_RADIOTAP_EHT_USIG_COMMON_BAD_USIG_CRC);
+}
+
+static void iwl_mld_decode_uhr_usig(struct iwl_mld_rx_phy_data *phy_data,
+				    struct sk_buff *skb)
+{
+	u32 he_type = phy_data->rate_n_flags & RATE_MCS_HE_TYPE_MSK;
+	struct ieee80211_radiotap_eht_usig *usig;
+	__le32 usig_a1 = phy_data->ntfy->sigs.uhr.usig_a1;
+	u32 bw;
+
+	usig = iwl_mld_radiotap_put_tlv(skb, IEEE80211_RADIOTAP_EHT_USIG,
+					sizeof(*usig));
+
+	BUILD_BUG_ON(offsetof(typeof(phy_data->ntfy->sigs.uhr), usig_a1) !=
+		     offsetof(typeof(phy_data->ntfy->sigs.uhr_elr), usig_a1));
+	BUILD_BUG_ON(offsetof(typeof(phy_data->ntfy->sigs.uhr), usig_a1) !=
+		     offsetof(typeof(phy_data->ntfy->sigs.uhr_tb), usig_a1));
+
+	usig->common |= cpu_to_le32(IEEE80211_RADIOTAP_EHT_USIG_COMMON_UL_DL_KNOWN |
+				    IEEE80211_RADIOTAP_EHT_USIG_COMMON_BSS_COLOR_KNOWN |
+				    IEEE80211_RADIOTAP_EHT_USIG_COMMON_VALIDATE_BITS_CHECKED |
+				    IEEE80211_RADIOTAP_EHT_USIG_COMMON_BW_KNOWN |
+				    IEEE80211_RADIOTAP_EHT_USIG_COMMON_TXOP_KNOWN |
+				    IEEE80211_RADIOTAP_EHT_USIG_COMMON_PHY_VER_KNOWN);
+
+#define CHECK_BW(bw) \
+	BUILD_BUG_ON(IEEE80211_RADIOTAP_EHT_USIG_COMMON_BW_ ## bw ## MHZ != \
+		     RATE_MCS_CHAN_WIDTH_ ## bw ## _VAL)
+	CHECK_BW(20);
+	CHECK_BW(40);
+	CHECK_BW(80);
+	CHECK_BW(160);
+#undef CHECK_BW
+	BUILD_BUG_ON(IEEE80211_RADIOTAP_EHT_USIG_COMMON_BW_320MHZ_1 !=
+		     RATE_MCS_CHAN_WIDTH_320_VAL);
+	bw = u32_get_bits(phy_data->rate_n_flags, RATE_MCS_CHAN_WIDTH_MSK);
+	/* specific handling for 320MHz-1/320MHz-2 */
+	if (bw == RATE_MCS_CHAN_WIDTH_320_VAL)
+		bw += le32_get_bits(usig_a1, OFDM_RX_FRAME_EHT_BW320_SLOT);
+	usig->common |= le32_encode_bits(bw,
+					 IEEE80211_RADIOTAP_EHT_USIG_COMMON_BW);
+
+	usig->common |= LE32_DEC_ENC(usig_a1, OFDM_RX_FRAME_ENHANCED_WIFI_UL_FLAG,
+				     IEEE80211_RADIOTAP_EHT_USIG_COMMON_UL_DL);
+	usig->common |= LE32_DEC_ENC(usig_a1, OFDM_RX_FRAME_ENHANCED_WIFI_BSS_COLOR,
+				     IEEE80211_RADIOTAP_EHT_USIG_COMMON_BSS_COLOR);
+	usig->common |= LE32_DEC_ENC(usig_a1,
+				     OFDM_RX_FRAME_ENHANCED_WIFI_TXOP_DURATION,
+				     IEEE80211_RADIOTAP_EHT_USIG_COMMON_TXOP);
+	usig->common |= LE32_DEC_ENC(usig_a1,
+				     OFDM_RX_FRAME_ENHANCED_WIFI_VER_ID,
+				     IEEE80211_RADIOTAP_EHT_USIG_COMMON_PHY_VER);
+
+	switch (he_type) {
+	case RATE_MCS_HE_TYPE_TRIG:
+		iwl_mld_decode_uhr_usig_tb(phy_data, usig);
+		break;
+	case RATE_MCS_HE_TYPE_UHR_ELR:
+		iwl_mld_decode_uhr_usig_elr(phy_data, usig);
+		break;
+	default:
+		iwl_mld_decode_uhr_usig_non_tb(phy_data, usig);
+		break;
+	}
+}
+
+static void iwl_mld_decode_uhr_tb(struct iwl_mld_rx_phy_data *phy_data,
+				  struct ieee80211_rx_status *rx_status,
+				  struct ieee80211_radiotap_uhr *uhr)
+{
+	if (!(phy_data->ntfy->flags & IWL_SNIF_FLAG_VALID_TB_RX))
+		return;
+
+	uhr->known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_KNOWN_DRU_RRU_ALLOC_TB_FMT |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_LDPC_EXTRA_SYMBOL_SEGMENT |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_PRE_FEC_PADDING_FACTOR |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_PE_DISAMBIGUITY |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_NUMBER_OF_UHR_LTF_SYMBOLS |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_PRI80_CHAN_POS);
+
+	uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr_tb.tb_rx0,
+				     OFDM_UCODE_TRIG_BASE_PS160,
+				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_PS_160);
+	uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr_tb.tb_rx1,
+				     OFDM_UCODE_TRIG_BASE_RX_RU,
+				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_B0 |
+				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_B7_B1);
+	uhr->data[8] |= le32_encode_bits(!le32_get_bits(phy_data->ntfy->sigs.uhr_tb.tb_rx0,
+							OFDM_UCODE_RX_IS_DRU),
+					 IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_INDICATION);
+
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr_tb.tb_rx1,
+				     OFDM_UCODE_TRIG_BASE_RX_CODING_EXTRA_SYM,
+				     IEEE80211_RADIOTAP_UHR_DATA0_LDPC_EXTRA_SYMBOL_SEGMENT);
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr_tb.tb_rx1,
+				     OFDM_UCODE_TRIG_BASE_RX_PRE_FEC_PAD_FACTOR,
+				     IEEE80211_RADIOTAP_UHR_DATA0_PRE_FEC_PADDING_FACTOR);
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr_tb.tb_rx1,
+				     OFDM_UCODE_TRIG_BASE_RX_PE_DISAMBIG,
+				     IEEE80211_RADIOTAP_UHR_DATA0_PE_DISAMBIGUITY);
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr_tb.tb_rx1,
+				     OFDM_UCODE_TRIG_BASE_RX_NUM_OF_LTF_SYM,
+				     IEEE80211_RADIOTAP_UHR_DATA0_NUMBER_OF_LTF_SYMBOLS);
+	uhr->data[1] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr_tb.tb_rx0,
+				     OFDM_UCODE_TRIG_BASE_RX_RU_P80,
+				     IEEE80211_RADIOTAP_UHR_DATA1_PRI80_CHAN_POS);
+
+	iwl_mld_eht_uhr_set_ru_alloc(rx_status,
+				     le32_get_bits(phy_data->ntfy->sigs.uhr_tb.tb_rx1,
+						   OFDM_UCODE_TRIG_BASE_RX_RU),
+				     true);
+}
+
+static void iwl_mld_uhr_decode_user_ru(struct iwl_mld_rx_phy_data *phy_data,
+				       struct ieee80211_radiotap_uhr *uhr)
+{
+	u32 phy_bw = phy_data->rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK;
+
+	if (!(phy_data->ntfy->flags & IWL_SNIF_FLAG_VALID_RU))
+		return;
+
+#define __IWL_MLD_ENC_UHR_RU(rt_data, rt_ru, fw_data, fw_ru) \
+	uhr->data[(rt_data)] |= \
+		(cpu_to_le32(IEEE80211_RADIOTAP_UHR_DATA ## rt_data ## _RU_ALLOC_CC_ ## rt_ru ## _KNOWN) | \
+		 LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.cmn[fw_data], \
+			      OFDM_RX_FRAME_EHT_RU_ALLOC_ ## fw_data ## _ ## fw_ru, \
+			      IEEE80211_RADIOTAP_UHR_DATA ## rt_data ## _RU_ALLOC_CC_ ## rt_ru))
+
+#define _IWL_MLD_ENC_UHR_RU(rt_data, rt_ru, fw_data, fw_ru)	\
+	__IWL_MLD_ENC_UHR_RU(rt_data, rt_ru, fw_data, fw_ru)
+
+#define IEEE80211_RADIOTAP_RU_DATA_1_1_1	1
+#define IEEE80211_RADIOTAP_RU_DATA_2_1_1	2
+#define IEEE80211_RADIOTAP_RU_DATA_1_1_2	2
+#define IEEE80211_RADIOTAP_RU_DATA_2_1_2	2
+#define IEEE80211_RADIOTAP_RU_DATA_1_2_1	3
+#define IEEE80211_RADIOTAP_RU_DATA_2_2_1	3
+#define IEEE80211_RADIOTAP_RU_DATA_1_2_2	3
+#define IEEE80211_RADIOTAP_RU_DATA_2_2_2	4
+#define IEEE80211_RADIOTAP_RU_DATA_1_2_3	4
+#define IEEE80211_RADIOTAP_RU_DATA_2_2_3	4
+#define IEEE80211_RADIOTAP_RU_DATA_1_2_4	5
+#define IEEE80211_RADIOTAP_RU_DATA_2_2_4	5
+#define IEEE80211_RADIOTAP_RU_DATA_1_2_5	5
+#define IEEE80211_RADIOTAP_RU_DATA_2_2_5	6
+#define IEEE80211_RADIOTAP_RU_DATA_1_2_6	6
+#define IEEE80211_RADIOTAP_RU_DATA_2_2_6	6
+
+#define IWL_RX_RU_DATA_A1			0
+#define IWL_RX_RU_DATA_A2			0
+#define IWL_RX_RU_DATA_A3			0
+#define IWL_RX_RU_DATA_A4			4
+#define IWL_RX_RU_DATA_B1			1
+#define IWL_RX_RU_DATA_B2			1
+#define IWL_RX_RU_DATA_B3			1
+#define IWL_RX_RU_DATA_B4			4
+#define IWL_RX_RU_DATA_C1			2
+#define IWL_RX_RU_DATA_C2			2
+#define IWL_RX_RU_DATA_C3			2
+#define IWL_RX_RU_DATA_C4			5
+#define IWL_RX_RU_DATA_D1			3
+#define IWL_RX_RU_DATA_D2			3
+#define IWL_RX_RU_DATA_D3			3
+#define IWL_RX_RU_DATA_D4			5
+
+#define IWL_MLD_ENC_UHR_RU(rt_ru, fw_ru)				\
+	_IWL_MLD_ENC_UHR_RU(IEEE80211_RADIOTAP_RU_DATA_ ## rt_ru,	\
+			    rt_ru,					\
+			    IWL_RX_RU_DATA_ ## fw_ru,			\
+			    fw_ru)
+
+	/*
+	 * Hardware labels the content channels/RU allocation values
+	 * as follows:
+	 *
+	 *           Content Channel 1		Content Channel 2
+	 *   20 MHz: A1
+	 *   40 MHz: A1				B1
+	 *   80 MHz: A1 C1			B1 D1
+	 *  160 MHz: A1 C1 A2 C2		B1 D1 B2 D2
+	 *  320 MHz: A1 C1 A2 C2 A3 C3 A4 C4	B1 D1 B2 D2 B3 D3 B4 D4
+	 */
+
+	switch (phy_bw) {
+	case RATE_MCS_CHAN_WIDTH_320:
+		/* content channel 1 */
+		IWL_MLD_ENC_UHR_RU(1_2_3, A3);
+		IWL_MLD_ENC_UHR_RU(1_2_4, C3);
+		IWL_MLD_ENC_UHR_RU(1_2_5, A4);
+		IWL_MLD_ENC_UHR_RU(1_2_6, C4);
+		/* content channel 2 */
+		IWL_MLD_ENC_UHR_RU(2_2_3, B3);
+		IWL_MLD_ENC_UHR_RU(2_2_4, D3);
+		IWL_MLD_ENC_UHR_RU(2_2_5, B4);
+		IWL_MLD_ENC_UHR_RU(2_2_6, D4);
+		fallthrough;
+	case RATE_MCS_CHAN_WIDTH_160:
+		/* content channel 1 */
+		IWL_MLD_ENC_UHR_RU(1_2_1, A2);
+		IWL_MLD_ENC_UHR_RU(1_2_2, C2);
+		/* content channel 2 */
+		IWL_MLD_ENC_UHR_RU(2_2_1, B2);
+		IWL_MLD_ENC_UHR_RU(2_2_2, D2);
+		fallthrough;
+	case RATE_MCS_CHAN_WIDTH_80:
+		/* content channel 1 */
+		IWL_MLD_ENC_UHR_RU(1_1_2, C1);
+		/* content channel 2 */
+		IWL_MLD_ENC_UHR_RU(2_1_2, D1);
+		fallthrough;
+	case RATE_MCS_CHAN_WIDTH_40:
+		/* content channel 2 */
+		IWL_MLD_ENC_UHR_RU(2_1_1, B1);
+		fallthrough;
+	case RATE_MCS_CHAN_WIDTH_20:
+		/* content channel 1 */
+		IWL_MLD_ENC_UHR_RU(1_1_1, A1);
+		break;
+	}
+}
+
+static void iwl_mld_decode_uhr_non_tb(struct iwl_mld_rx_phy_data *phy_data,
+				      struct ieee80211_rx_status *rx_status,
+				      struct ieee80211_radiotap_uhr *uhr)
+{
+	__le32 usig_a1 = phy_data->ntfy->sigs.uhr.usig_a1;
+	__le32 usig_a2 = phy_data->ntfy->sigs.uhr.usig_a2_uhr;
+
+	uhr->known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_KNOWN_SPATIAL_REUSE |
+				  /* All RU allocating size/index is in TB format */
+				  IEEE80211_RADIOTAP_UHR_KNOWN_DRU_RRU_ALLOC_TB_FMT |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_LDPC_EXTRA_SYMBOL_SEGMENT |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_PRE_FEC_PADDING_FACTOR |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_PE_DISAMBIGUITY |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_PRI80_CHAN_POS |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_NUMBER_OF_NON_OFDMA_USERS |
+				  IEEE80211_RADIOTAP_UHR_KNOWN_INTERFERENCE_MITIGATION);
+
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
+				     OFDM_RX_FRAME_UHR_SPATIAL_REUSE,
+				     IEEE80211_RADIOTAP_UHR_DATA0_SPATIAL_REUSE);
+	uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
+				     OFDM_RX_FRAME_UHR_STA_RU_PS160,
+				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_PS_160);
+	uhr->data[8] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
+				     OFDM_RX_FRAME_UHR_STA_RU,
+				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_B0 |
+				     IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_ALLOC_TB_FMT_B7_B1);
+	/* downlink is never DRU */
+	uhr->data[8] |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_DATA8_DRU_RRU_INDICATION);
+
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
+				     OFDM_RX_FRAME_UHR_CODING_EXTRA_SYM,
+				     IEEE80211_RADIOTAP_UHR_DATA0_LDPC_EXTRA_SYMBOL_SEGMENT);
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
+				     OFDM_RX_FRAME_UHR_PE_A_FACTOR,
+				     IEEE80211_RADIOTAP_UHR_DATA0_PRE_FEC_PADDING_FACTOR);
+	uhr->data[0] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
+				     OFDM_RX_FRAME_UHR_PE_DISAMBIGUITY,
+				     IEEE80211_RADIOTAP_UHR_DATA0_PE_DISAMBIGUITY);
+	uhr->data[1] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
+				     OFDM_RX_FRAME_UHR_STA_RU_P80,
+				     IEEE80211_RADIOTAP_UHR_DATA1_PRI80_CHAN_POS);
+	uhr->data[7] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
+				     OFDM_RX_FRAME_UHR_NUM_OF_USERS,
+				     IEEE80211_RADIOTAP_UHR_DATA7_NUMBER_OF_NON_OFDMA_USERS);
+
+	uhr->data[7] |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b1,
+				     OFDM_RX_FRAME_UHR_IM_DISABLE,
+				     IEEE80211_RADIOTAP_UHR_DATA7_INTERFERENCE_MITIGATION);
+
+	iwl_mld_uhr_decode_user_ru(phy_data, uhr);
+
+	iwl_mld_eht_uhr_set_ru_alloc(rx_status,
+				     le32_get_bits(phy_data->ntfy->sigs.uhr.b2,
+						   OFDM_RX_FRAME_UHR_STA_RU),
+				     true);
+
+	if (!phy_data->with_data)
+		return;
+
+	uhr->user[0].known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_KNOWN_STA_ID);
+	uhr->user[0].info |= LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.user_id,
+					  OFDM_RX_FRAME_UHR_USER_FIELD_ID,
+					  IEEE80211_RADIOTAP_UHR_USER_INFO_STA_ID);
+
+	/* don't report UEQM for downlink non-OFDMA MU-MIMO allocations */
+	if (!(usig_a1 & cpu_to_le32(OFDM_RX_FRAME_ENHANCED_WIFI_UL_FLAG)) &&
+	    le32_get_bits(usig_a2, OFDM_RX_FRAME_UHR_PPDU_TYPE) == 2)
+		return;
+
+	uhr->user[0].known |=
+		cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_KNOWN_UEQM);
+	uhr->user[0].info |=
+		LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
+			     OFDM_RX_FRAME_UHR_UEQM,
+			     IEEE80211_RADIOTAP_UHR_USER_INFO_UEQM);
+
+	if (uhr->user[0].info & cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_INFO_UEQM)) {
+		uhr->user[0].known |=
+			cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_KNOWN_UEQM_PATTERN);
+		uhr->user[0].info |=
+			LE32_DEC_ENC(phy_data->ntfy->sigs.uhr.b2,
+				     OFDM_RX_FRAME_UHR_UEQM_PATTERN,
+				     IEEE80211_RADIOTAP_UHR_USER_INFO_UEQM_PATTERN);
+	}
+}
+
+static void
+iwl_mld_decode_uhr_elr_phy_data(struct iwl_mld_rx_phy_data *phy_data,
+				struct sk_buff *skb,
+				struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_radiotap_uhr_elr *elr;
+	__le32 elr1 = phy_data->ntfy->sigs.uhr_elr.uhr_sig_elr1;
+	__le32 elr2 = phy_data->ntfy->sigs.uhr_elr.uhr_sig_elr2;
+
+	elr = iwl_mld_radiotap_put_tlv(skb, IEEE80211_RADIOTAP_UHR_ELR,
+				       sizeof(*elr));
+
+	elr->known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_ELR_KNOWN_VERSION_ID |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_UL_DL |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_MCS |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_CODING |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_LENGTH |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_LDPC_EXTRA_OFDM_SYM |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_STA_ID |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_DISREGARD |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_SIG_1_CRC_CHECKED |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_SIG_2_CRC_CHECKED |
+				  IEEE80211_RADIOTAP_UHR_ELR_KNOWN_MARK_BSS_COLOR);
+	elr->sig1 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_VER_ID,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG1_VERSION_ID);
+	elr->sig1 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_UPLINK_FLAG,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG1_UL_DL);
+	elr->sig1 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_MCS,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG1_MCS);
+	elr->sig1 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_CODING,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG1_CODING);
+	elr->sig1 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_LENGTH_IN_SYM,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG1_LENGTH);
+	elr->sig1 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_CODING_EXTRA_SYM,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG1_LDPC_EXTRA_OFDM_SYM);
+	elr->sig1 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_SIG1_CRC_OK,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG1_CRC_VALID);
+
+	elr->sig2 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_STA_ID,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG2_STA_ID);
+	elr->sig2 |= LE32_DEC_ENC(elr1, OFDM_RX_VECTOR_UHR_ELR_DISREGARD,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG2_DISREGARD);
+
+	elr->sig2 |= LE32_DEC_ENC(elr2, OFDM_RX_VECTOR_UHR_ELR_SIG2_CRC_OK,
+				  IEEE80211_RADIOTAP_UHR_ELR_SIG2_CRC_VALID);
+
+	elr->mark |= LE32_DEC_ENC(elr2, OFDM_RX_VECTOR_UHR_ELR_MARK_BSS_COLOR,
+				  IEEE80211_RADIOTAP_UHR_ELR_MARK_BSS_COLOR);
+}
+
+static void iwl_mld_decode_uhr_phy_data(struct iwl_mld_rx_phy_data *phy_data,
+					struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	u32 rate_n_flags = phy_data->rate_n_flags;
+	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
+	struct ieee80211_radiotap_uhr *uhr;
+	size_t uhr_len;
+
+	if (he_type == RATE_MCS_HE_TYPE_UHR_ELR) {
+		iwl_mld_decode_uhr_elr_phy_data(phy_data, skb, rx_status);
+		return;
+	}
+
+	/* space for one user_info if we captured data */
+	uhr_len = struct_size(uhr, user, (phy_data->with_data ? 1 : 0));
+
+	uhr = iwl_mld_radiotap_put_tlv(skb, IEEE80211_RADIOTAP_UHR, uhr_len);
+
+	uhr->known |= cpu_to_le32(IEEE80211_RADIOTAP_UHR_KNOWN_GI_LTF_SIZE);
+	uhr->data[0] |= le32_encode_bits(u32_get_bits(rate_n_flags,
+						      RATE_MCS_HE_GI_LTF_MSK),
+					 IEEE80211_RADIOTAP_UHR_DATA0_GI_LTF_SIZE);
+
+	if (phy_data->with_data) {
+		uhr->user[0].known |=
+			cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_KNOWN_MCS |
+				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_2X_LDPC |
+				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_CODING |
+				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_USER_CAPTURED);
+
+		uhr->user[0].info |=
+			le32_encode_bits(u32_get_bits(rate_n_flags,
+						      RATE_MCS_CODE_MSK),
+					 IEEE80211_RADIOTAP_UHR_USER_INFO_MCS);
+
+		if (phy_data->phy_info & IWL_RX_MPDU_PHY_2X_LDPC)
+			uhr->user[0].info |=
+				cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_INFO_2X_LDPC);
+
+		if (rate_n_flags & RATE_MCS_LDPC_MSK)
+			uhr->user[0].info |=
+				cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_INFO_CODING);
+	}
+
+	if (he_type == RATE_MCS_HE_TYPE_TRIG)
+		iwl_mld_decode_uhr_tb(phy_data, rx_status, uhr);
+	else
+		iwl_mld_decode_uhr_non_tb(phy_data, rx_status, uhr);
+}
+
+static void iwl_mld_rx_uhr(struct iwl_mld *mld, struct sk_buff *skb,
+			   struct iwl_mld_rx_phy_data *phy_data)
+{
+	if (likely(!phy_data->ntfy))
+		return;
+
+	iwl_mld_decode_uhr_usig(phy_data, skb);
+	iwl_mld_decode_uhr_phy_data(phy_data, skb);
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 static void iwl_mld_add_rtap_sniffer_config(struct iwl_mld *mld,
 					    struct sk_buff *skb)
@@ -1512,19 +2042,42 @@ static void iwl_mld_rx_fill_status(struct iwl_mld *mld, int link_id,
 
 	iwl_mld_set_rx_rate(mld, phy_data, rx_status);
 
-	/* must be before HE data (radiotap field order) */
-	if (format == RATE_MCS_MOD_TYPE_VHT)
+	switch (format) {
+	case RATE_MCS_MOD_TYPE_CCK:
+		/* nothing to see here, see note below */
+		break;
+	case RATE_MCS_MOD_TYPE_LEGACY_OFDM:
+		/*
+		 * Technically legacy CCK/OFDM frames don't have an L-SIG
+		 * since that's the compat format for HT (non-greenfield)
+		 * and up. However, it's meant to be compatible with the
+		 * LENGTH and RATE fields in Clause 17 and 18 OFDM frames
+		 * so include the field for any non-CCK frame. For CCK it
+		 * cannot work, since the LENGTH field for them is 16-bit
+		 * and the radiotap field only has 12 bits.
+		 */
+		iwl_mld_decode_lsig(skb, phy_data);
+		break;
+	case RATE_MCS_MOD_TYPE_HT:
+		iwl_mld_decode_lsig(skb, phy_data);
+		break;
+	case RATE_MCS_MOD_TYPE_VHT:
 		iwl_mld_rx_vht(skb, phy_data);
-
-	/* must be before L-SIG data (radiotap field order) */
-	if (format == RATE_MCS_MOD_TYPE_HE)
+		iwl_mld_decode_lsig(skb, phy_data);
+		break;
+	case RATE_MCS_MOD_TYPE_HE:
 		iwl_mld_rx_he(skb, phy_data);
-
-	iwl_mld_decode_lsig(skb, phy_data);
-
-	/* TLVs - must be after radiotap fixed fields */
-	if (format == RATE_MCS_MOD_TYPE_EHT)
+		iwl_mld_decode_lsig(skb, phy_data);
+		break;
+	case RATE_MCS_MOD_TYPE_EHT:
+		iwl_mld_decode_lsig(skb, phy_data);
 		iwl_mld_rx_eht(mld, skb, phy_data);
+		break;
+	case RATE_MCS_MOD_TYPE_UHR:
+		iwl_mld_decode_lsig(skb, phy_data);
+		iwl_mld_rx_uhr(mld, skb, phy_data);
+		break;
+	}
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (unlikely(mld->monitor.on)) {
-- 
2.34.1

