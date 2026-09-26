Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C9F1E7660
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442944; cv=none; b=MUZBqpj5E2+RE/v7ez/TL5qqAgauEpsNcszXUwvmA8HNx2zMeiQgFsJvvwRTP0YubfIYrRQjxcT6WDBjW59PNVMHx3EY0oZk2fFv1f/ahW8q5qyxpRnCwR7i+MUzeiF5xaKICsruMwXnFOKwG5McUttoI1bvgV3Rzd9WPukZ4ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442944; c=relaxed/simple;
	bh=HNysII698xbPGSnE9hHFMciGlnp6Vpus5sI6kuKPDws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tLg8BFKQzF88qTP/RmWOab0HobF2yn7h+ilveslS14k9L3H/r+3DP9cGtpnlViC09IS1ad6yM26XBc/BeRnbAtH2E1XlbxQvLilw1YDQI1b31hGURpunho4M1KLPBFbLe0QVzWVJcPYS9kZUT0cAAZkiEITFH+YBUlj+jUqrcoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GagPZVW4; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GagPZVW4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442944; x=1821978944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HNysII698xbPGSnE9hHFMciGlnp6Vpus5sI6kuKPDws=;
  b=GagPZVW4wDl4v7qAk68pjLJuUA8OK2kicN5LbzDechTM6JJc05fNshBT
   JQpGTctNYnRH+QWWQ3Lb2H1RDa+ZjBwPj7zLfpsC3M0Tta77bNjlhc1Qp
   rqzd2to92hSF0EQaV7b6MzuQxgP48pDzw71dE1kUhKZDZqBQdVwkBUdLE
   1Gm9pZbBCeU/9pvPfMlZytdRlvzvKzK5d3zK3Y1T3dk91QT/inHF+iK0H
   3aEW9QgYeI+/4sY19aJMZnVxjeesBBoIjKcfC2vDy7vdXbuz15zHeivm2
   mfWMYlbV7J/H+uRZwOpuMgqaDRC0bHRItaN6pOTjMFvYOlAGj5dUaRhdI
   w==;
X-CSE-ConnectionGUID: fiEAixQ8TKyQadM4zAT9Ag==
X-CSE-MsgGUID: T9hTuYekSbyN+heLP/cYEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533281"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533281"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:44 -0700
X-CSE-ConnectionGUID: iEINKqZJTsmQe1SKXal4TQ==
X-CSE-MsgGUID: 4UhiQwveRwecfRPdUj5FJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274196950"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:43 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH v2 iwlwifi-next 05/15] wifi: iwlwifi: uefi: Fix SAR enable check to use mode parameter correctly
Date: Sat, 26 Sep 2026 20:17:24 +0300
Message-Id: <20260926201527.60160602581b.Ib184c201e677cb6d95f64e725a1e39148234fa41@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

The iwl_uefi_set_sar_profile() function was receiving a bool parameter,
which would treat any non-zero value as enabled. This is incorrect because
the SAR mode value contains additional bits beyond the enable flag.

Change the parameter from bool enabled to u32 mode and properly extract
the enable bit using IWL_SAR_ENABLE_MSK bitmask. This ensures that only
the designated enable bit determines whether SAR is enabled, not arbitrary
non-zero values.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 79fd95d08732..86825318c543 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -549,7 +549,7 @@ IWL_EXPORT_SYMBOL(iwl_uefi_get_uneb_table);
 
 static void iwl_uefi_set_sar_profile(struct iwl_sar_profile *profiles,
 				     const u8 *vals, u8 prof_index,
-				     u8 num_subbands, bool enabled)
+				     u8 num_subbands, u32 mode)
 {
 	struct iwl_sar_profile *sar_prof = &profiles[prof_index];
 
@@ -573,7 +573,7 @@ static void iwl_uefi_set_sar_profile(struct iwl_sar_profile *profiles,
 				vals[chain * num_subbands + subband];
 	}
 
-	sar_prof->enabled = enabled & IWL_SAR_ENABLE_MSK;
+	sar_prof->enabled = mode & IWL_SAR_ENABLE_MSK;
 }
 
 int iwl_uefi_get_wrds_table(struct iwl_fw_runtime *fwrt)
-- 
2.34.1

