Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90A853D0B2
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077711; cv=none; b=ABa12NQ6UCe3E00HL9BJYkwdWGXUdDHTQwaUL4vqt9Uh9oMr1wtqc+85xo5p525oHdUnWeLbTC8Aa0YQDXoGKNi5itwMcZO/wNTdJ7jPNX2I/RdGBfMOgpOAKUh1K5A7hQBVfr/xMR46kK7n+OdUOmmsc/msGkRhMTtICzyhgBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077711; c=relaxed/simple;
	bh=eqSVrQaddfWegBbCQ1gcluUX16Qj35K/txSlJXsoXe4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sOcM9/rDS+FDQUqmys19IoDrFc87+QWq58t+4UWfG6wtXseJ6InuTdHWxpqtF0TqXPnbTHK+ob53J4z8ZlIXdmA1l+/nVjNb5cOu7b5XC8OgT0EEOf1aCOyGVlpsFCE8yybzaSgghfNxe/jO3pP5Esp7ixwFZivgo6dkbFjppIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PE3vvrG/; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PE3vvrG/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077709; x=1821613709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eqSVrQaddfWegBbCQ1gcluUX16Qj35K/txSlJXsoXe4=;
  b=PE3vvrG/l/qNBeMGTwqTr2oSFvj4Lk/cdFrXugV1sEG4EmDnS2XkUhLv
   KeKbXGYy69g51XoRwEELAzWleW6X4t1vpGzXtZF+eZwAagno4+A0eoz4b
   WAuSz237cx582kJTvHTAwUE+ms6dOZWHzBQzXhGwQ72MpedIIlF5Kixam
   o8Q3CnjK2+531zLSua1JYBwXi1IApPl2CMOMfajrL/jCYjd0oZW0oCke1
   WwfLIhg8E3oynTBCB10nLY2mNyM54gd1TFSOi0kZrr2kPK/yWzVTY/abN
   YFgHE9g7odIIxRSAwBhDPo7Bv8X1/HeWTCjAGz/ZlFigTjNmkNOZVqagv
   A==;
X-CSE-ConnectionGUID: B4MpqOYuT5S17DIABj1YRg==
X-CSE-MsgGUID: u/26h4r5Tkifc5Jd9VtZ5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170572"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170572"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:25 -0700
X-CSE-ConnectionGUID: DAd3mcPaRlucj20NY50lHQ==
X-CSE-MsgGUID: lrMOyBCATGqLcIQrA0+Ftw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275437"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:24 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: mld: separate HT/VHT/HE/EHT LDPC/STBC capabilities
Date: Tue, 22 Sep 2026 14:50:02 +0300
Message-Id: <20260922144819.cf235dddcbb3.I315c8089e341c6f7b2108276a32560595a8571fd@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

It appears that there are some APs that advertise STBC
for HT and VHT, but don't actually support it for HE.

Since the FW TLC will only use the mode we set (or fall
back to legacy rates), we can set the bits according to
the mode for STBC and LDPC. For EHT, there's no STBC at
all, but LDPC support is more complex to determine.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/tlc.c | 173 +++++++++++++------
 1 file changed, 120 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tlc.c b/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
index 1f5994f8be26..0e448b24a6a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tlc.c
@@ -49,9 +49,60 @@ struct iwl_mld_tlc_sta_capa {
 	const struct ieee80211_sta_uhr_cap *own_uhr_cap;
 };
 
+static bool iwl_mld_eht_ldpc_support(const struct ieee80211_sta_he_cap *he_cap,
+				     const struct ieee80211_sta_eht_cap *eht_cap,
+				     bool from_ap)
+{
+	u8 nss;
+
+	/* higher bandwidth implies LDPC */
+	if (he_cap->he_cap_elem.phy_cap_info[0] &
+	    IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_IN_2G)
+		return true;
+	if (he_cap->he_cap_elem.phy_cap_info[0] &
+	    IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_40MHZ_80MHZ_IN_5G)
+		return true;
+	if (he_cap->he_cap_elem.phy_cap_info[0] &
+	    IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G)
+		return true;
+	if (eht_cap->eht_cap_elem.phy_cap_info[0] &
+	    IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ)
+		return true;
+
+	/* MCS 10-14 imply LDPC support, we only check 10-13 here */
+	if (!from_ap) {
+		const struct ieee80211_eht_mcs_nss_supp_20mhz_only *mcs_nss;
+
+		mcs_nss = &eht_cap->eht_mcs_nss_supp.only_20mhz;
+
+		if (mcs_nss->rx_tx_mcs11_max_nss ||
+		    mcs_nss->rx_tx_mcs13_max_nss)
+			return true;
+
+		nss = mcs_nss->rx_tx_mcs7_max_nss;
+	} else {
+		const struct ieee80211_eht_mcs_nss_supp_bw *mcs_nss;
+
+		mcs_nss = &eht_cap->eht_mcs_nss_supp.bw._80;
+
+		if (mcs_nss->rx_tx_mcs11_max_nss ||
+		    mcs_nss->rx_tx_mcs13_max_nss)
+			return true;
+
+		nss = mcs_nss->rx_tx_mcs9_max_nss;
+	}
+
+	/* NSS > 4 implies LDPC support */
+	return u8_get_bits(nss, IEEE80211_EHT_MCS_NSS_RX) > 4 ||
+	       u8_get_bits(nss, IEEE80211_EHT_MCS_NSS_TX) > 4;
+}
+
 static __le16
 iwl_mld_get_tlc_cmd_flags(struct iwl_mld *mld,
-			  struct iwl_mld_tlc_sta_capa *capa)
+			  struct ieee80211_vif *vif,
+			  struct iwl_mld_tlc_sta_capa *capa,
+			  enum iwl_tlc_mng_cfg_mode mode,
+			  enum iwl_tlc_mng_cfg_cw max_bw)
 {
 	const struct ieee80211_sta_ht_cap *ht_cap = capa->ht_cap;
 	const struct ieee80211_sta_vht_cap *vht_cap = capa->vht_cap;
@@ -61,64 +112,79 @@ iwl_mld_get_tlc_cmd_flags(struct iwl_mld *mld,
 	const struct ieee80211_sta_he_cap *own_he_cap = capa->own_he_cap;
 	const struct ieee80211_sta_eht_cap *own_eht_cap = capa->own_eht_cap;
 	const struct ieee80211_sta_uhr_cap *own_uhr_cap = capa->own_uhr_cap;
-	bool has_vht = vht_cap && vht_cap->vht_supported;
+	bool stbc_possible = mld->cfg->ht_params.stbc &&
+			     hweight8(iwl_mld_get_valid_tx_ant(mld)) > 1;
 	u16 flags = 0;
 
-	/* STBC flags */
-	if (mld->cfg->ht_params.stbc &&
-	    (hweight8(iwl_mld_get_valid_tx_ant(mld)) > 1)) {
-		if (he_cap && he_cap->has_he &&
-		    he_cap->he_cap_elem.phy_cap_info[2] &
-				IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ)
+	switch (mode) {
+	case IWL_TLC_MNG_MODE_NON_HT:
+		break;
+	case IWL_TLC_MNG_MODE_HT:
+		if (WARN_ON(!ht_cap || !ht_cap->ht_supported))
+			return 0;
+		if (stbc_possible &&
+		    ht_cap->cap & IEEE80211_HT_CAP_RX_STBC)
 			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
-		else if (vht_cap &&
-			 vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
+		if (mld->cfg->ht_params.ldpc &&
+		    ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
+		break;
+	case IWL_TLC_MNG_MODE_VHT:
+		if (WARN_ON(!vht_cap || !vht_cap->vht_supported))
+			return 0;
+		if (stbc_possible &&
+		    vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
 			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
-		else if (ht_cap && ht_cap->cap & IEEE80211_HT_CAP_RX_STBC)
+		if (mld->cfg->ht_params.ldpc &&
+		    vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
+		break;
+	case IWL_TLC_MNG_MODE_HE:
+		if (WARN_ON(!he_cap || !he_cap->has_he || !own_he_cap))
+			return 0;
+		if (stbc_possible &&
+		    he_cap->he_cap_elem.phy_cap_info[2] &
+				IEEE80211_HE_PHY_CAP2_STBC_RX_UNDER_80MHZ &&
+		    (max_bw <= IWL_TLC_MNG_CH_WIDTH_80MHZ ||
+		     he_cap->he_cap_elem.phy_cap_info[7] &
+				IEEE80211_HE_PHY_CAP7_STBC_RX_ABOVE_80MHZ))
 			flags |= IWL_TLC_MNG_CFG_FLAGS_STBC_MSK;
+		if (he_cap->he_cap_elem.phy_cap_info[1] &
+				IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD &&
+		    own_he_cap->he_cap_elem.phy_cap_info[1] &
+				IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
+		if (he_cap->he_cap_elem.phy_cap_info[3] &
+				IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_MASK &&
+		    own_he_cap->he_cap_elem.phy_cap_info[3] &
+				IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_MASK)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_1_MSK;
+		break;
+	case IWL_TLC_MNG_MODE_UHR:
+		if (WARN_ON(!uhr_cap || !uhr_cap->has_uhr || !own_uhr_cap))
+			return 0;
+		if (uhr_cap->phy.cap & cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_RX) &&
+		    own_uhr_cap->phy.cap & cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_TX))
+			flags |= IWL_TLC_MNG_CFG_FLAGS_UHR_ELR_1_5_MBPS_MSK |
+				 IWL_TLC_MNG_CFG_FLAGS_UHR_ELR_3_MBPS_MSK;
+		/* uses most config from EHT */
+		fallthrough;
+	case IWL_TLC_MNG_MODE_EHT:
+		if (WARN_ON(!own_he_cap || !he_cap || !he_cap->has_he ||
+			    !own_eht_cap || !eht_cap || !eht_cap->has_eht))
+			return 0;
+		if (own_eht_cap->eht_cap_elem.phy_cap_info[5] &
+				IEEE80211_EHT_PHY_CAP5_SUPP_EXTRA_EHT_LTF &&
+		    eht_cap->eht_cap_elem.phy_cap_info[5] &
+				IEEE80211_EHT_PHY_CAP5_SUPP_EXTRA_EHT_LTF)
+			flags |= IWL_TLC_MNG_CFG_FLAGS_EHT_EXTRA_LTF_MSK;
+		/* no STBC in EHT */
+		if (iwl_mld_eht_ldpc_support(he_cap, eht_cap,
+					     vif->type == NL80211_IFTYPE_STATION))
+			flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
+		break;
 	}
 
-	/* LDPC */
-	if (mld->cfg->ht_params.ldpc &&
-	    ((ht_cap && ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING) ||
-	     (has_vht && (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))))
-		flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
-
-	if (he_cap && he_cap->has_he &&
-	    (he_cap->he_cap_elem.phy_cap_info[1] &
-			IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD))
-		flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
-
-	if (own_he_cap &&
-	    !(own_he_cap->he_cap_elem.phy_cap_info[1] &
-			IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD))
-		flags &= ~IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
-
-	/* DCM */
-	if (he_cap && he_cap->has_he &&
-	    (he_cap->he_cap_elem.phy_cap_info[3] &
-	     IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_RX_MASK &&
-	     own_he_cap &&
-	     own_he_cap->he_cap_elem.phy_cap_info[3] &
-			IEEE80211_HE_PHY_CAP3_DCM_MAX_CONST_TX_MASK))
-		flags |= IWL_TLC_MNG_CFG_FLAGS_HE_DCM_NSS_1_MSK;
-
-	/* Extra EHT LTF */
-	if (own_eht_cap &&
-	    own_eht_cap->eht_cap_elem.phy_cap_info[5] &
-			IEEE80211_EHT_PHY_CAP5_SUPP_EXTRA_EHT_LTF &&
-	    eht_cap && eht_cap->has_eht &&
-	    eht_cap->eht_cap_elem.phy_cap_info[5] &
-			IEEE80211_EHT_PHY_CAP5_SUPP_EXTRA_EHT_LTF) {
-		flags |= IWL_TLC_MNG_CFG_FLAGS_EHT_EXTRA_LTF_MSK;
-	}
-
-	if (uhr_cap && uhr_cap->has_uhr && own_uhr_cap &&
-	    uhr_cap->phy.cap & cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_RX) &&
-	    own_uhr_cap->phy.cap & cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_TX))
-		flags |= IWL_TLC_MNG_CFG_FLAGS_UHR_ELR_1_5_MBPS_MSK |
-			 IWL_TLC_MNG_CFG_FLAGS_UHR_ELR_3_MBPS_MSK;
-
 	return cpu_to_le16(flags);
 }
 
@@ -478,7 +544,6 @@ static void iwl_mld_send_tlc_cmd(struct iwl_mld *mld,
 		.max_ch_width = mld_sta->sta_state > IEEE80211_STA_ASSOC ?
 			iwl_mld_fw_bw_from_sta_bw(capa->bandwidth) :
 			IWL_TLC_MNG_CH_WIDTH_20MHZ,
-		.flags = iwl_mld_get_tlc_cmd_flags(mld, capa),
 		.chains = iwl_mld_get_fw_chains(mld),
 		.sgi_ch_width_supp = iwl_mld_get_fw_sgi(capa),
 		.max_mpdu_len = cpu_to_le16(capa->max_amsdu_len),
@@ -493,6 +558,8 @@ static void iwl_mld_send_tlc_cmd(struct iwl_mld *mld,
 	cmd.phy_id = cpu_to_le32(phy_id);
 
 	iwl_mld_fill_supp_rates(mld, vif, capa, &cmd);
+	cmd.flags = iwl_mld_get_tlc_cmd_flags(mld, vif, capa, cmd.mode,
+					      cmd.max_ch_width);
 
 	if (cmd_ver == 6) {
 		cmd_ptr = &cmd;
-- 
2.34.1

