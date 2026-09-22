Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7659479873
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077704; cv=none; b=ebMNkEbvS8UfWc7eM8b6q8Bs04vqHWLqGlVHebyWrENvYEqgr8flejEHW8rMZXMNfsaR599R2rrCmgCW8Aq2hpQZMx0yBj6HuvCLMf2lK77211aYRTBA6eisexdIwG07UGlbPsGEVchaAjrCyY6JM2AVBXY8W/n0GthSR3HLaDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077704; c=relaxed/simple;
	bh=tLamC25mOpAoVnJRr6KDXFKf2FQBnsZPiudIKVMhp7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fPDTOVFd4kukFcElcKy6aUiBhNihHRBSY+gQSG1oUWpD6lcLPce/QisZzoLOQ4qY99VZmsB2CrfsA0dFLKOElelOqziPeuwTNxgDp9zATsU6pyKW6j76Lb2Tki1p9AvSpm1DCo7X2oubeSLd+FPH3kTKyJpE4Dz4fQkUcrZXv8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FOltEm8w; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FOltEm8w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077702; x=1821613702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tLamC25mOpAoVnJRr6KDXFKf2FQBnsZPiudIKVMhp7g=;
  b=FOltEm8wrVhWddDpme4X2/Uf1NcYMNho/yo2oG3rZYkwMj4H8U4x597D
   jGp+GhznQguVq939/k0wJTjMjkO7rVC762OnKd9fSdg0fFsLF3sJHebvM
   amyiKYCAhG6VK3rr94pcEJJHS2QpOJsRYlsAcuj9qcymOw5+LI36ZUZTW
   5+zPjSKZRaEbewSXOapG2n7blWU98H4r7Zs6tCg79zTafNYj0EvR6nfqe
   PohKaAnVUa1gZ6XvJDIA/Qj7Z2jOX4OF+oXopizzUExXt8p2N1LAmg/nv
   X2GxzMeSkp2KuP2Fw0kkHHr1zr3nz2e4vwLcTUYk13DKlPkm8R+am0WVX
   w==;
X-CSE-ConnectionGUID: Y2uKOeQ8TfOi61VnqAfk6A==
X-CSE-MsgGUID: R+KZQkgARHeRbFhLv8QXCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170530"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170530"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:13 -0700
X-CSE-ConnectionGUID: swjHHh8gT+Gwlk1Q0+1AMg==
X-CSE-MsgGUID: tTNnejAUT9Oy43jSkGTrXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275371"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:11 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 06/15] wifi: iwlwifi: add multi-BSS/EMCCA max BSSID indicator to LINK cmd
Date: Tue, 22 Sep 2026 14:49:53 +0300
Message-Id: <20260922144819.fafac4d1052d.I91be3bcfcd25d23b5c10c043d6cd639de4efa214@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Add support for version 9 of the LINK context config command, which
carries the max BSSID indicator N, where 2**N is the maximal number of
BSSIDs the physical AP can support.
The firmware uses this to mask N bits of the transmitter address for
NPCA OBSS and inter/intra BSS NAV decisions. N=0 disables the feature.

Assisted-by: GithubCopilot:claude-opus-4.8
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/mac-cfg.h   | 28 ++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mld/link.c |  5 ++++
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
index 4a494563aa8c..9579e691cc87 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
@@ -665,7 +665,13 @@ struct iwl_npca_params {
  * @puncture_mask: puncture mask for EHT (removed in VER_3)
  * @frame_time_rts_th: HE duration RTS threshold, in units of 32us
  * @flags: a combination from &enum iwl_link_ctx_flags
- * @flags_mask: what of %flags have changed. Also &enum iwl_link_ctx_flags
+ * @flags_mask: what of %flags have changed. Also &enum iwl_link_ctx_flags.
+ *	Removed in _VER_6, reused as @reserved4 / @max_bssid_indicator
+ *	in _VER_9.
+ * @reserved4: reserved
+ * @max_bssid_indicator: N where 2**N is the max number of BSSIDs the physical
+ *	AP can support (multi-BSS or EMCCA set). 0 disables the feature.
+ *	Since _VER_9.
  * Below fields are for multi-bssid:
  * @ref_bssid_addr: reference BSSID used by the AP
  * @reserved_for_ref_bssid_addr: reserved
@@ -706,17 +712,23 @@ struct iwl_link_config_cmd {
 	/* MAC_QOS_PARAM_API_S_VER_1 */
 	__le32 qos_flags;
 	struct iwl_ac_qos ac[AC_NUM + 1];
-	u8 htc_trig_based_pkt_ext;
-	u8 rand_alloc_ecwmin;
-	u8 rand_alloc_ecwmax;
+	u8 htc_trig_based_pkt_ext; /* removed in _VER_9 */
+	u8 rand_alloc_ecwmin;      /* removed in _VER_9 */
+	u8 rand_alloc_ecwmax;      /* removed in _VER_9 */
 	u8 ndp_fdbk_buff_th_exp;
 	struct iwl_he_backoff_conf trig_based_txf[AC_NUM];
 	__le32 bi;
 	__le32 dtim_interval;
 	__le16 puncture_mask; /* removed in _VER_3 */
-	__le16 frame_time_rts_th;
+	__le16 frame_time_rts_th; /* removed in _VER_9 */
 	__le32 flags;
-	__le32 flags_mask; /* removed in _VER_6 */
+	union {
+		__le32 flags_mask; /* removed in _VER_6 */
+		struct {
+			u8 reserved4[3];
+			u8 max_bssid_indicator; /* since _VER_9 */
+		};
+	};
 	/* The below fields are for multi-bssid */
 	u8 ref_bssid_addr[6];
 	__le16 reserved_for_ref_bssid_addr;
@@ -730,7 +742,9 @@ struct iwl_link_config_cmd {
 	struct iwl_ac_qos prio_edca_params; /* since _VER_7 */
 	__le32 reserved3[4];
 } __packed; /* LINK_CONTEXT_CONFIG_CMD_API_S_VER_1, _VER_2, _VER_3, _VER_4,
-	     *				    _VER_5, _VER_6, _VER_7, _VER_8 */
+	     *				    _VER_5, _VER_6, _VER_7, _VER_8,
+	     *				    _VER_9
+	     */
 
 /* Currently FW supports link ids in the range 0-3 and can have
  * at most two active links for each vif.
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index 65eddbd63016..c7d50ba30b36 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -378,6 +378,11 @@ iwl_mld_change_link_in_fw(struct iwl_mld *mld, struct ieee80211_bss_conf *link,
 		cmd.bssid_index = link->bssid_index;
 	}
 
+	if (iwl_fw_lookup_cmd_ver(mld->fw,
+				  WIDE_ID(MAC_CONF_GROUP, LINK_CONFIG_CMD),
+				  0) >= 9)
+		cmd.max_bssid_indicator = link->bssid_indicator;
+
 	/* The only EHT parameter is puncturing, and starting from PHY cmd
 	 * version 6 - it is sent there. For older versions of the PHY cmd,
 	 * puncturing is not needed at all.
-- 
2.34.1

