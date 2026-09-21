Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50007446BF8
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023175; cv=none; b=hLtT4q57Ts06X0VI5eED/BLZYc0WRwIHvUm4rnKfXfIiPnFcdtcOfPVbCqAb5GVYd77kpxppOey6gRCOHSoh/7IKEc4CFhFn/1hHj1i+R9NRH86xV/E65K8tFGFrWQ3CevQGXiYyzCi9j32VTCH2NjGQ9zeOgfx3FQajaaD6HCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023175; c=relaxed/simple;
	bh=FB2+b0446uh8oEEF+YyeTA3mJDWt7vlk69t4laXy888=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hm2U9VLmSJ2KjJijxQJ8CB9JJqSsdy2lP+5PVVR2AlhItmm8Y5rgsiERel5M56GuDeI/X3xerDn5dGNoQ11Rw7Gdsyfvo5QHZbOy1oRYg9j+9yEatw7Ou5A+22JpaVjhF5KnZbjQE0a66PSyuy21jA+YtoXrOdU9KmqVax7fg0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mJ5dW45n; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mJ5dW45n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023173; x=1821559173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FB2+b0446uh8oEEF+YyeTA3mJDWt7vlk69t4laXy888=;
  b=mJ5dW45nySsoKION22tqlAZSWCeykEIe6C4aiGO/sPJamBL71puoQH4S
   /PrW0XCsFiYTMN0SnBvIYgJJ99j4Jv35ZFhbC8cw961LhSOC6Ir2QmcAe
   cMnwhzPv59Fucu3VSD5kFZjB2D9RP8cMxMkPSsT/tfR//PGrgeHvUm272
   M2xSjuInxte2yVXmM8c3NjaB1I/58FC8DiRLViwVXqtkS9ad9gaK3GhOZ
   8y12iBsLSe33votf4K3Xoz2PJLJU1t5UiJ5UJ2GiOtmFvTQlQMOHP30Lp
   UKnmZtj9rjr2SFbx3/oZC68GzevRiY8cp7hz0gPZZa1mGXkNk5AdtxuNC
   g==;
X-CSE-ConnectionGUID: q9ywssQ5SgWD2YLZmEnDUw==
X-CSE-MsgGUID: TIO1PT49Q0a/UIeL6W7SRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128766"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128766"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:32 -0700
X-CSE-ConnectionGUID: Rky/mz+5TEOBKYk/pMCegw==
X-CSE-MsgGUID: Dk+KGgscQxeCkNQb3GS9bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300761922"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:32 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH iwlwifi-next 01/15] wifi: iwlwifi: mld: Add support for (Re)association req/resp encryption
Date: Mon, 21 Sep 2026 23:41:11 +0300
Message-Id: <20260921233730.25ccedf95d32.Ie2834534bd644593b61a063d4ec5f7e323be4370@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
References: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

Introduce support for (re)association request/response encryption if
supported by the firmware.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/fw/file.h         | 2 ++
 drivers/net/wireless/intel/iwlwifi/mld/key.c         | 6 ++++++
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c    | 4 ++++
 4 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
index c8eb016e1a7e..b17babef71c0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h
@@ -643,6 +643,7 @@ struct iwl_scd_queue_cfg_cmd {
  * @IWL_SEC_KEY_FLAG_MFP: MFP is in used for this key
  * @IWL_SEC_KEY_FLAG_MCAST_KEY: this is a multicast key
  * @IWL_SEC_KEY_FLAG_SPP_AMSDU: SPP A-MSDU should be used
+ * @IWL_SEC_KEY_FLAG_ASSOC_ENC: use this key for (Re)Assoc Req/Resp encryption
  */
 enum iwl_sec_key_flags {
 	IWL_SEC_KEY_FLAG_CIPHER_MASK	= 0x07,
@@ -655,6 +656,7 @@ enum iwl_sec_key_flags {
 	IWL_SEC_KEY_FLAG_MFP		= 0x20,
 	IWL_SEC_KEY_FLAG_MCAST_KEY	= 0x40,
 	IWL_SEC_KEY_FLAG_SPP_AMSDU	= 0x80,
+	IWL_SEC_KEY_FLAG_ASSOC_ENC	= 0x200,
 };
 
 #define IWL_SEC_WEP_KEY_OFFSET	3
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 664ac25754e9..3a986b394dd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -452,6 +452,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  *	table data. For LARI_CONFIG_CHANGE command version 13 and above, this
  *	capability is obsolete since raw DSM values are accepted by default.
  * @IWL_UCODE_TLV_CAPA_NAN_SYNC_SUPPORT: Supports NAN synchronization
+ * @IWL_UCODE_TLV_CAPA_ASSOC_ENC_SUPPORT: firmware supports association frame encryption
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -556,6 +557,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_RESET_DURING_ASSERT		= (__force iwl_ucode_tlv_capa_t)(4 * 32 + 0),
 	IWL_UCODE_TLV_CAPA_FW_ACCEPTS_RAW_DSM_TABLE 	= (__force iwl_ucode_tlv_capa_t)(4 * 32 + 1),
 	IWL_UCODE_TLV_CAPA_NAN_SYNC_SUPPORT		= (__force iwl_ucode_tlv_capa_t)(4 * 32 + 2),
+	IWL_UCODE_TLV_CAPA_ASSOC_ENC_SUPPORT		= (__force iwl_ucode_tlv_capa_t)(4 * 32 + 4),
 	NUM_IWL_UCODE_TLV_CAPA
 /*
  * This construction make both sparse (which cannot increment the previous
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/key.c b/drivers/net/wireless/intel/iwlwifi/mld/key.c
index bf80b4770b5a..f2c87f830ba3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/key.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/key.c
@@ -37,6 +37,12 @@ static u32 iwl_mld_get_key_flags(struct iwl_mld *mld,
 		break;
 	}
 
+	/* Note that sta->mfp might not be set yet, as it is set only
+	 * after association.
+	 */
+	if (sta && pairwise && sta->epp_peer)
+		flags |= IWL_SEC_KEY_FLAG_ASSOC_ENC | IWL_SEC_KEY_FLAG_MFP;
+
 	/* If we are installing an iGTK (in AP or STA mode), we need to tell
 	 * the firmware this key will en/decrypt MGMT frames.
 	 * Same goes if we are installing a pairwise key for an MFP station.
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 3a4c8fda68d0..0b121114d47c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -395,6 +395,10 @@ static void iwl_mac_hw_set_wiphy(struct iwl_mld *mld)
 	if (fw_has_capa(ucode_capa, IWL_UCODE_TLV_CAPA_PROTECTED_TWT))
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_PROTECTED_TWT);
 
+	if (fw_has_capa(ucode_capa, IWL_UCODE_TLV_CAPA_ASSOC_ENC_SUPPORT))
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_ASSOC_FRAME_ENCRYPTION);
+
 	if (iwlmld_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
 		wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
 	else
-- 
2.34.1

