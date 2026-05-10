Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21EC33DEC0
	for <linux-wireless@vger.kernel.org>; Sun, 10 May 2026 20:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778446154; cv=none; b=qexlnYj3O8PLmCP7LYKh16VCuMfNn9x50KznaERrYbxO4bQ2IOPPkI+NhSh6T3jXJLdRhe+xL7jPIR8LwS4Wz4S1ysD6+YTu/GWcgtUGsWrltWPm0KAG7U68hED+rRC95LV2Gg8MeN0Jgjscx2ttquEmedqK76qU+vSlIz7zw2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778446154; c=relaxed/simple;
	bh=VY9L3z3KgSwyXwiSLNvgGy+QV1I/w8saoHan9RnnGq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MKNKkeTWq9EqC9+YJNtVrKAUAPK+M3uAPrAW/d+RD9kYNZVNlJtL3/dxYtnOY/E1fKEmKjJ7g3iR+ciXZbaPkv/OLw8Dxkw49ri8Ttm5A7o8gBcxh2VIXw+sAdQRsQCP6PpA1z7r0EWhEeX8mb2zq1VpVrwqYHrcHYZPksgpKaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DxgqEBgO; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DxgqEBgO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778446153; x=1809982153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VY9L3z3KgSwyXwiSLNvgGy+QV1I/w8saoHan9RnnGq0=;
  b=DxgqEBgO/SSxh04XQmApAPrBdgG+lUyRoqDpon2kMVh8RxjBYZgCDFnJ
   DdAEK1Hos08YC7Jxez6/cka0rWazMXdNpIvz0dcZQzVlqxSuWLhqICH1W
   FnIK4+gktNSEHGoadGuVAxYI0zeP7zJNo8Xsp/6BY4Z/eL1BA5dxL+gsi
   1sI9O5/iulrWgKd3NAM1GTBeT67xYT+MCe0I6x6AGieQCOMMD+3HWltUU
   8yGvjP+IvR5+3FDayYVSObSYJA/sWY5tz96SxD2bO55iY6HSlG4P2mzrJ
   DEfmnHMSzQaXdhUYjkvAFmn9d1y7lMmU8HBeIqxGdZmNYmtvFqXibJhxx
   Q==;
X-CSE-ConnectionGUID: FbRGYIGdSuuMgztW+TKCgg==
X-CSE-MsgGUID: re1db+maQe6otQjhtDneEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11782"; a="81904763"
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="81904763"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 13:49:13 -0700
X-CSE-ConnectionGUID: 5GZOkX+6SmSSAESt0Seu2A==
X-CSE-MsgGUID: ovRqXrPkQ0SnbAPxY46UqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="239095087"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 13:49:12 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 15/15] wifi: iwlwifi: mld: don't allow softAP with NAN
Date: Sun, 10 May 2026 23:48:40 +0300
Message-Id: <20260510234534.fafa2298ffc5.I3cd256f3075d6e93b1fd9afc905af0a6a633ed4b@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260510204840.133723-1-miriam.rachel.korenblit@intel.com>
References: <20260510204840.133723-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

SoftAP in concurrency with NAN is not supported. Update the interface
combinations accordingly.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/mld/mac80211.c   | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 49c75d4ee9a6..1106ad651cfe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -69,11 +69,6 @@ static const struct ieee80211_iface_limit iwl_mld_limits_nan[] = {
 		.max = 1,
 		.types = BIT(NL80211_IFTYPE_NAN),
 	},
-	/* Removed when two channels are permitted */
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_AP),
-	},
 };
 
 static const struct ieee80211_iface_combination
@@ -90,19 +85,13 @@ iwl_mld_iface_combinations[] = {
 		.limits = iwl_mld_limits_ap,
 		.n_limits = ARRAY_SIZE(iwl_mld_limits_ap),
 	},
-	/* NAN combinations follow, these exclude P2P */
+	/* NAN combination follow, this excludes P2P and AP */
 	{
 		.num_different_channels = 2,
 		.max_interfaces = 3,
 		.limits = iwl_mld_limits_nan,
-		.n_limits = ARRAY_SIZE(iwl_mld_limits_nan) - 1,
-	},
-	{
-		.num_different_channels = 1,
-		.max_interfaces = 4,
-		.limits = iwl_mld_limits_nan,
 		.n_limits = ARRAY_SIZE(iwl_mld_limits_nan),
-	}
+	},
 };
 
 static const u8 ext_capa_base[IWL_MLD_STA_EXT_CAPA_SIZE] = {
@@ -376,7 +365,7 @@ static void iwl_mac_hw_set_wiphy(struct iwl_mld *mld)
 	} else {
 		/* Do not include NAN combinations */
 		wiphy->n_iface_combinations =
-			ARRAY_SIZE(iwl_mld_iface_combinations) - 2;
+			ARRAY_SIZE(iwl_mld_iface_combinations) - 1;
 	}
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
-- 
2.34.1

