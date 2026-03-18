Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2372DB781
	for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2026 20:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773867288; cv=none; b=qmHG9oW9StfUQV+IzIXkawuxzm77jBBI+rWn/fu5DVkkRZipPq5g6lPHLE1dFn7K2PgoeO0UGegTp32h3vK0LZLcJ9a383DFWE0cMw6WsnF92h5CLhvVSmx+klEnDYZjqHjtw7PPoqBT6GhhMkNFBE/Je+pxYMXXv+d0/LGssOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773867288; c=relaxed/simple;
	bh=aNb8XFOjPZNLJv/njv+EGC094aXkCDPFJRips7NQgwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R9t2o8IJsX7J/LRDwcS61ECxIEnSTmTfImmd37d2CA1h1tcIFpd4pOMvuMR2oTfumaO4t2tDhJRM6FsjxiUzwSGkbNhvGLD+kGn5qZTBpdx4Hzg+AAyO/dIXpwsICCGuJVp8mLszEsPAQgUHuQG7AkCTf06RJimQvj247dzfI7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AAj2kuqB; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AAj2kuqB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773867287; x=1805403287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aNb8XFOjPZNLJv/njv+EGC094aXkCDPFJRips7NQgwE=;
  b=AAj2kuqBhpECHz1DfabHOkYAbIL622rL5V9pmnuf7Yk40UHRbso4nxGu
   yJs3ovXLCTqJyM54+crVZYm+1RMosAHoUQbQ9+793nDyAyM7Feg3mj3jr
   Rlbh7Q9/A1TuZOSU+/YcvTPyPiev5icjDxUJHjTDj1IemFeyDv672T4R1
   jkouydzSu/HIF6kNqmb35u9jeVrcJP7Qbt2LjoN1BSlzskD+YOOHkekKl
   ZoUu7oWeAUgaI0D3SMKitAJw20jxb+Alx1zyq15CKZ+t6dYTmCty88O6S
   GkpN2qynDfETBmZrDeGV8PEdPXlvScL7xVXacZotNI4Gfl6+q19mZYJoJ
   g==;
X-CSE-ConnectionGUID: 1bje4Nn8RMSvHUtxD4D72w==
X-CSE-MsgGUID: 2PRc+e/fRVS/Lj49RdXVzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="75010010"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="75010010"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 13:54:46 -0700
X-CSE-ConnectionGUID: RxAiSl4fQoalf2KQu3trfg==
X-CSE-MsgGUID: wOxCkULFStiuEg+1+uI+Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="222793861"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 13:54:45 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 03/15] wifi: iwlwifi: uefi: decouple UEFI and firmware APIs
Date: Wed, 18 Mar 2026 22:54:18 +0200
Message-Id: <20260318225236.db39a64073db.I21486dedb7357570151437cb0211b697e0efb61d@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260318205430.614577-1-miriam.rachel.korenblit@intel.com>
References: <20260318205430.614577-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The APIs in uefi.h are not firmware API files nor are they pure software
objects. They really reflect a specific layout we expect to see in the
UEFI tables.
Since the UEFI objects are encoded into the BIOS, we can't use the same
values for the declaration of the UEFI objects and for the pure software
object like iwl_sar_profile in the firmware runtime object.

Decouple the two types.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h | 23 ++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
index 99170a72c3f1..c6940a3c03ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
@@ -76,13 +76,24 @@ struct uefi_cnv_common_step_data {
 	u8 radio2;
 } __packed;
 
+#define UEFI_SAR_MAX_SUB_BANDS_NUM	11
+#define UEFI_SAR_MAX_CHAINS_PER_PROFILE	4
+
+/*
+ * struct uefi_sar_profile_chain - per-chain values of a SAR profile
+ * @subbands: the SAR value for each subband
+ */
+struct uefi_sar_profile_chain {
+	u8 subbands[UEFI_SAR_MAX_SUB_BANDS_NUM];
+};
+
 /*
  * struct uefi_sar_profile - a SAR profile as defined in UEFI
  *
  * @chains: a per-chain table of SAR values
  */
 struct uefi_sar_profile {
-	struct iwl_sar_profile_chain chains[BIOS_SAR_MAX_CHAINS_PER_PROFILE];
+	struct uefi_sar_profile_chain chains[UEFI_SAR_MAX_CHAINS_PER_PROFILE];
 } __packed;
 
 /*
@@ -125,6 +136,14 @@ struct uefi_cnv_var_wgds {
 	struct iwl_geo_profile geo_profiles[BIOS_GEO_MAX_PROFILE_NUM];
 } __packed;
 
+/*
+ * struct uefi_ppag_chain - PPAG table for a specific chain
+ * @subbands: the PPAG values for band
+ */
+struct uefi_ppag_chain {
+	s8 subbands[UEFI_SAR_MAX_SUB_BANDS_NUM];
+};
+
 /*
  * struct uefi_cnv_var_ppag - PPAG table as defined in UEFI
  * @revision: the revision of the table
@@ -134,7 +153,7 @@ struct uefi_cnv_var_wgds {
 struct uefi_cnv_var_ppag {
 	u8 revision;
 	u32 ppag_modes;
-	struct iwl_ppag_chain ppag_chains[IWL_NUM_CHAIN_LIMITS];
+	struct uefi_ppag_chain ppag_chains[IWL_NUM_CHAIN_LIMITS];
 } __packed;
 
 /* struct uefi_cnv_var_wtas - WTAS tabled as defined in UEFI
-- 
2.34.1

