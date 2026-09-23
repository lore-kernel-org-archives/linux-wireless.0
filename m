Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F9C51D536
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168607; cv=none; b=rgtN+pqCC3xJpcnpTaPzTpMrYFAxhtgnLSNJEjxGayv4i7Tr4TUUsCPK7lazKGcuOwXR+FmnlOo+4E+aoaIOBTrwrmKlu27BYnACdgNerduwvyVO2LE51Yl0FhvYk7o+keMugjzfer44ZyQ6jFMFgD4Kt2qGK4gQvnC24CEkBdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168607; c=relaxed/simple;
	bh=c7ZLD4z0VIDSU7vz1tWVE5od9XgtLXUayrXUlE1r/Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gJqir6fKy2VD3AlNNLc3OmjYSis1IAwgKwN+UNazDt5JIm24xgEOPljRAOiL3CQFB9FQLaLrO61TPCFDFjM1f1ftsMvedzCBkL8T0HUrCmzxsw6hfoZwZwWzoW0+/pX8zPTlz+F4NxZQuPD0e3WOH1KI2Ioy9gUTZE+ybPJKcTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FiRZl9d5; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FiRZl9d5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168604; x=1821704604;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c7ZLD4z0VIDSU7vz1tWVE5od9XgtLXUayrXUlE1r/Mg=;
  b=FiRZl9d5wkdEB/4quwlXnUcaZuPGZOiBnbPY6kW2H7HschrKD+dcg6zT
   qDhGXmF2vmgmEyCmpeGcgxfWYVeppVA1Mc5lVg4+T944l5vU1C3HE9LRF
   sHmViRn7Pxo1OiOvBugqd7dlIFKqdvjPy2Vb+qaT3hpEOMXQTEYkBilAx
   gQwncEGIZ03s5E3R3i/Eprk9iHia07BmIzSops40TYNLyHQF0GZ8pMb5O
   PpXtVT7L9CvoMk0zCslHB6jpBsKd/Iqb3K4IHyv7WbXId8QQ75EICRjK8
   /VtE0F7Dun6wBMbjmfd2nMOxX7WK00x+2DrO/mqPOBNGILE92pLNWvSyh
   A==;
X-CSE-ConnectionGUID: 6b6tSm3bTACVp+rpvqycbg==
X-CSE-MsgGUID: vJmgq/l8Sqae05L9ivcgbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781363"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781363"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:21 -0700
X-CSE-ConnectionGUID: r0WMgHiUT7ucjbQYzHSnGQ==
X-CSE-MsgGUID: lN/dzutUQRWWGX/U0F/RVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697117"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:20 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: add standalone WRSS/EWSS BIOS table loading
Date: Wed, 23 Sep 2026 16:04:58 +0300
Message-Id: <20260923160318.9a8eb3ff9512.Id79836e772136e1e38f107b578007faf39b13b4e@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Add support for reading WRSS and EWSS standalone SAR tables
from the BIOS in the ACPI and UEFI paths.

WRDS/EWRD tables describe SAR limits for concurrent Wi-Fi
and Bluetooth operation. When Bluetooth is not active,
those limits can unnecessarily restrict Wi-Fi transmit power.
WRSS/EWSS provide separate standalone SAR profiles for Wi-Fi-only
operation, allowing the firmware to select the appropriate
higher-power limits while still respecting the platform-specific
regulatory constraints.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  | 272 +++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h  |  16 ++
 drivers/net/wireless/intel/iwlwifi/fw/init.c  |   2 +
 .../wireless/intel/iwlwifi/fw/regulatory.c    |   2 +
 .../wireless/intel/iwlwifi/fw/regulatory.h    |   5 +
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   7 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c  | 133 ++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h  |  14 +
 8 files changed, 377 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index 21470b8ae8e9..7b11316a3062 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -525,6 +525,83 @@ iwl_acpi_parse_chains_table(union acpi_object *table,
 	return 0;
 }
 
+static int
+iwl_acpi_parse_extended_sar_profiles(union acpi_object *wifi_pkg,
+				     struct iwl_sar_profile *sar_profiles,
+				     u8 num_sub_bands, bool has_cdb)
+{
+	int n_profiles, pos, ret;
+	bool enabled;
+
+	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER ||
+	    wifi_pkg->package.elements[2].type != ACPI_TYPE_INTEGER)
+		return -EINVAL;
+
+	if (WARN_ON(ACPI_SAR_NUM_CHAINS_REV0 * num_sub_bands >
+		    ARRAY_SIZE(sar_profiles[0].chains) *
+		    ARRAY_SIZE(sar_profiles[0].chains[0].subbands)))
+		return -EINVAL;
+
+	enabled = !!(wifi_pkg->package.elements[1].integer.value);
+	n_profiles = wifi_pkg->package.elements[2].integer.value;
+
+	if (n_profiles >= BIOS_SAR_MAX_PROFILE_NUM)
+		return -EINVAL;
+
+	/* the tables start at element 3 */
+	pos = 3;
+
+	BUILD_BUG_ON(ACPI_SAR_NUM_CHAINS_REV0 != ACPI_SAR_NUM_CHAINS_REV1);
+	BUILD_BUG_ON(ACPI_SAR_NUM_CHAINS_REV2 != 2 * ACPI_SAR_NUM_CHAINS_REV0);
+
+	/* parse non-cdb chains for all profiles */
+	for (int i = 0; i < n_profiles; i++) {
+		union acpi_object *table = &wifi_pkg->package.elements[pos];
+
+		ret = iwl_acpi_parse_chains_table(table,
+						  sar_profiles[i + 1].chains,
+						  ACPI_SAR_NUM_CHAINS_REV0,
+						  num_sub_bands);
+		if (ret < 0)
+			return ret;
+
+		/* go to the next table */
+		pos += ACPI_SAR_NUM_CHAINS_REV0 * num_sub_bands;
+	}
+
+	if (!has_cdb)
+		goto set_enabled;
+
+	if (WARN_ON(ACPI_SAR_NUM_CHAINS_REV0 * 2 * num_sub_bands >
+		    ARRAY_SIZE(sar_profiles[0].chains) *
+		    ARRAY_SIZE(sar_profiles[0].chains[0].subbands)))
+		return -EINVAL;
+
+	/* parse cdb chains for all profiles */
+	for (int i = 0; i < n_profiles; i++) {
+		struct iwl_sar_profile_chain *chains;
+		union acpi_object *table;
+
+		table = &wifi_pkg->package.elements[pos];
+		chains = &sar_profiles[i + 1].chains[ACPI_SAR_NUM_CHAINS_REV0];
+		ret = iwl_acpi_parse_chains_table(table,
+						  chains,
+						  ACPI_SAR_NUM_CHAINS_REV0,
+						  num_sub_bands);
+		if (ret < 0)
+			return ret;
+
+		/* go to the next table */
+		pos += ACPI_SAR_NUM_CHAINS_REV0 * num_sub_bands;
+	}
+
+set_enabled:
+	for (int i = 0; i < n_profiles; i++)
+		sar_profiles[i + 1].enabled = enabled;
+
+	return 0;
+}
+
 int iwl_acpi_get_wrds_table(struct iwl_fw_runtime *fwrt)
 {
 	union acpi_object *wifi_pkg, *table, *data;
@@ -629,8 +706,12 @@ int iwl_acpi_get_wrds_table(struct iwl_fw_runtime *fwrt)
 	 */
 	ret = iwl_acpi_parse_chains_table(table, fwrt->sar_profiles[0].chains,
 					  num_chains, num_sub_bands);
-	if (!ret && flags & IWL_SAR_ENABLE_MSK)
+	if (ret)
+		goto out_free;
+
+	if (flags & IWL_SAR_ENABLE_MSK)
 		fwrt->sar_profiles[0].enabled = true;
+	fwrt->wrds_table_revision = tbl_rev;
 
 out_free:
 	kfree(data);
@@ -640,8 +721,7 @@ int iwl_acpi_get_wrds_table(struct iwl_fw_runtime *fwrt)
 int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 {
 	union acpi_object *wifi_pkg, *data;
-	bool enabled;
-	int i, n_profiles, tbl_rev, pos;
+	int tbl_rev;
 	int ret = 0;
 	u8 num_sub_bands;
 
@@ -713,93 +793,147 @@ int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 	goto out_free;
 
 read_table:
-	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER ||
-	    wifi_pkg->package.elements[2].type != ACPI_TYPE_INTEGER) {
-		ret = -EINVAL;
+	ret = iwl_acpi_parse_extended_sar_profiles(wifi_pkg,
+						   fwrt->sar_profiles,
+						   num_sub_bands,
+						   tbl_rev >= 2);
+	if (ret)
 		goto out_free;
+
+	fwrt->ewrd_table_revision = tbl_rev;
+
+out_free:
+	kfree(data);
+	return ret;
+}
+
+int iwl_acpi_get_wsss_table(struct iwl_fw_runtime *fwrt)
+{
+	union acpi_object *data __free(kfree) = NULL;
+	union acpi_object *wifi_pkg, *table;
+	u8 num_chains, num_sub_bands;
+	int ret, tbl_rev;
+	u32 flags;
+
+	if (fwrt->wrds_table_revision == IWL_BIOS_REVISION_UNSET) {
+		IWL_DEBUG_RADIO(fwrt,
+				"Skipping standalone SAR: WRDS table was not read\n");
+		return -EINVAL;
 	}
 
-	if (WARN_ON(ACPI_SAR_NUM_CHAINS_REV0 * num_sub_bands >
-		    ARRAY_SIZE(fwrt->sar_profiles[0].chains) *
-		    ARRAY_SIZE(fwrt->sar_profiles[0].chains[0].subbands))) {
-		ret = -EINVAL;
-		goto out_free;
+	data = iwl_acpi_get_object(fwrt->dev, ACPI_WSSS_METHOD);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	switch (fwrt->wrds_table_revision) {
+	case 3:
+		wifi_pkg = iwl_acpi_get_wifi_pkg(fwrt->dev, data,
+						 ACPI_WRDS_WIFI_DATA_SIZE_REV3,
+						 &tbl_rev);
+		num_chains = ACPI_SAR_NUM_CHAINS_REV2;
+		num_sub_bands = ACPI_SAR_NUM_SUB_BANDS_REV3;
+		break;
+	case 2:
+		wifi_pkg = iwl_acpi_get_wifi_pkg(fwrt->dev, data,
+						 ACPI_WRDS_WIFI_DATA_SIZE_REV2,
+						 &tbl_rev);
+		num_chains = ACPI_SAR_NUM_CHAINS_REV2;
+		num_sub_bands = ACPI_SAR_NUM_SUB_BANDS_REV2;
+		break;
+	default:
+		return -EINVAL;
 	}
 
-	enabled = !!(wifi_pkg->package.elements[1].integer.value);
-	n_profiles = wifi_pkg->package.elements[2].integer.value;
+	if (IS_ERR(wifi_pkg))
+		return PTR_ERR(wifi_pkg);
 
-	/*
-	 * Check the validity of n_profiles.  The EWRD profiles start
-	 * from index 1, so the maximum value allowed here is
-	 * ACPI_SAR_PROFILES_NUM - 1.
-	 */
-	if (n_profiles >= BIOS_SAR_MAX_PROFILE_NUM) {
-		ret = -EINVAL;
-		goto out_free;
+	if (fwrt->wrds_table_revision != tbl_rev) {
+		IWL_DEBUG_RADIO(fwrt,
+				"Skipping standalone SAR: WRDS/WSSS revision mismatch (WRDS rev %d, WSSS rev %d)\n",
+				fwrt->wrds_table_revision,
+				tbl_rev);
+		return -EINVAL;
 	}
 
-	/* the tables start at element 3 */
-	pos = 3;
+	if (wifi_pkg->package.elements[1].type != ACPI_TYPE_INTEGER)
+		return -EINVAL;
 
-	BUILD_BUG_ON(ACPI_SAR_NUM_CHAINS_REV0 != ACPI_SAR_NUM_CHAINS_REV1);
-	BUILD_BUG_ON(ACPI_SAR_NUM_CHAINS_REV2 != 2 * ACPI_SAR_NUM_CHAINS_REV0);
+	if (WARN_ON(num_chains * num_sub_bands >
+		    ARRAY_SIZE(fwrt->sar_standalone_profiles[0].chains) *
+		    ARRAY_SIZE(fwrt->sar_standalone_profiles[0].chains[0].subbands)))
+		return -EINVAL;
 
-	/* parse non-cdb chains for all profiles */
-	for (i = 0; i < n_profiles; i++) {
-		union acpi_object *table = &wifi_pkg->package.elements[pos];
+	IWL_DEBUG_RADIO(fwrt, "Reading WSSS (WRDS Standalone) tbl_rev=%d\n",
+			tbl_rev);
 
-		/* The EWRD profiles officially go from 2 to 4, but we
-		 * save them in sar_profiles[1-3] (because we don't
-		 * have profile 0).  So in the array we start from 1.
-		 */
-		ret = iwl_acpi_parse_chains_table(table,
-						  fwrt->sar_profiles[i + 1].chains,
-						  ACPI_SAR_NUM_CHAINS_REV0,
-						  num_sub_bands);
-		if (ret < 0)
-			goto out_free;
+	flags = wifi_pkg->package.elements[1].integer.value;
 
-		/* go to the next table */
-		pos += ACPI_SAR_NUM_CHAINS_REV0 * num_sub_bands;
-	}
+	/* position of the actual table */
+	table = &wifi_pkg->package.elements[2];
 
-	/* non-cdb table revisions */
-	if (tbl_rev < 2)
-		goto set_enabled;
+	ret = iwl_acpi_parse_chains_table(table,
+					  fwrt->sar_standalone_profiles[0].chains,
+					  num_chains, num_sub_bands);
+	if (ret)
+		return ret;
 
-	if (WARN_ON(ACPI_SAR_NUM_CHAINS_REV0 * 2 * num_sub_bands >
-		    ARRAY_SIZE(fwrt->sar_profiles[0].chains) *
-		    ARRAY_SIZE(fwrt->sar_profiles[0].chains[0].subbands))) {
-		ret = -EINVAL;
-		goto out_free;
+	if (flags & IWL_SAR_ENABLE_MSK)
+		fwrt->sar_standalone_profiles[0].enabled = true;
+
+	return ret;
+}
+
+int iwl_acpi_get_ewss_table(struct iwl_fw_runtime *fwrt)
+{
+	union acpi_object *data __free(kfree) = NULL;
+	union acpi_object *wifi_pkg;
+	u8 num_sub_bands;
+	int tbl_rev;
+
+	if (fwrt->ewrd_table_revision == IWL_BIOS_REVISION_UNSET) {
+		IWL_DEBUG_RADIO(fwrt,
+				"Skipping standalone SAR: EWRD table was not read\n");
+		return -EINVAL;
 	}
 
-	/* parse cdb chains for all profiles */
-	for (i = 0; i < n_profiles; i++) {
-		struct iwl_sar_profile_chain *chains;
-		union acpi_object *table;
+	data = iwl_acpi_get_object(fwrt->dev, ACPI_EWSS_METHOD);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
-		table = &wifi_pkg->package.elements[pos];
-		chains = &fwrt->sar_profiles[i + 1].chains[ACPI_SAR_NUM_CHAINS_REV0];
-		ret = iwl_acpi_parse_chains_table(table,
-						  chains,
-						  ACPI_SAR_NUM_CHAINS_REV0,
-						  num_sub_bands);
-		if (ret < 0)
-			goto out_free;
+	switch (fwrt->ewrd_table_revision) {
+	case 3:
+		wifi_pkg = iwl_acpi_get_wifi_pkg(fwrt->dev, data,
+						 ACPI_EWRD_WIFI_DATA_SIZE_REV3,
+						 &tbl_rev);
+		num_sub_bands = ACPI_SAR_NUM_SUB_BANDS_REV3;
+		break;
+	case 2:
+		wifi_pkg = iwl_acpi_get_wifi_pkg(fwrt->dev, data,
+						 ACPI_EWRD_WIFI_DATA_SIZE_REV2,
+						 &tbl_rev);
+		num_sub_bands = ACPI_SAR_NUM_SUB_BANDS_REV2;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-		/* go to the next table */
-		pos += ACPI_SAR_NUM_CHAINS_REV0 * num_sub_bands;
+	if (IS_ERR(wifi_pkg))
+		return PTR_ERR(wifi_pkg);
+
+	if (fwrt->ewrd_table_revision != tbl_rev) {
+		IWL_DEBUG_RADIO(fwrt,
+				"Skipping standalone SAR: EWRD/EWSS revision mismatch (EWRD rev %d, EWSS rev %d)\n",
+				fwrt->ewrd_table_revision, tbl_rev);
+		return -EINVAL;
 	}
 
-set_enabled:
-	for (i = 0; i < n_profiles; i++)
-		fwrt->sar_profiles[i + 1].enabled = enabled;
+	IWL_DEBUG_RADIO(fwrt, "Reading EWSS (EWRD Standalone) tbl_rev=%d\n",
+			tbl_rev);
 
-out_free:
-	kfree(data);
-	return ret;
+	return iwl_acpi_parse_extended_sar_profiles(wifi_pkg,
+						    fwrt->sar_standalone_profiles,
+						    num_sub_bands,
+						    fwrt->ewrd_table_revision >= 2);
 }
 
 int iwl_acpi_get_wgds_table(struct iwl_fw_runtime *fwrt)
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
index 426b0c51abec..b722beae2f00 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.h
@@ -14,6 +14,8 @@
 
 #define ACPI_WRDS_METHOD	"WRDS"
 #define ACPI_EWRD_METHOD	"EWRD"
+#define ACPI_WSSS_METHOD	"WSSS"
+#define ACPI_EWSS_METHOD	"EWSS"
 #define ACPI_WGDS_METHOD	"WGDS"
 #define ACPI_WRDD_METHOD	"WRDD"
 #define ACPI_SPLC_METHOD	"SPLC"
@@ -175,6 +177,10 @@ int iwl_acpi_get_wrds_table(struct iwl_fw_runtime *fwrt);
 
 int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt);
 
+int iwl_acpi_get_wsss_table(struct iwl_fw_runtime *fwrt);
+
+int iwl_acpi_get_ewss_table(struct iwl_fw_runtime *fwrt);
+
 int iwl_acpi_get_wgds_table(struct iwl_fw_runtime *fwrt);
 
 int iwl_acpi_get_tas_table(struct iwl_fw_runtime *fwrt,
@@ -229,6 +235,16 @@ static inline int iwl_acpi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 	return -ENOENT;
 }
 
+static inline int iwl_acpi_get_wsss_table(struct iwl_fw_runtime *fwrt)
+{
+	return -ENOENT;
+}
+
+static inline int iwl_acpi_get_ewss_table(struct iwl_fw_runtime *fwrt)
+{
+	return -ENOENT;
+}
+
 static inline int iwl_acpi_get_wgds_table(struct iwl_fw_runtime *fwrt)
 {
 	return 1;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
index d69757b0149d..f62c6a69f0dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/init.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -23,6 +23,8 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 	int i;
 
 	memset(fwrt, 0, sizeof(*fwrt));
+	fwrt->wrds_table_revision = IWL_BIOS_REVISION_UNSET;
+	fwrt->ewrd_table_revision = IWL_BIOS_REVISION_UNSET;
 	fwrt->trans = trans;
 	fwrt->fw = fw;
 	fwrt->dev = trans->dev;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
index 5dbb3cdb9916..137303e4a29b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.c
@@ -30,6 +30,8 @@ IWL_EXPORT_SYMBOL(iwl_bios_get_ ## __name)
 
 IWL_BIOS_TABLE_LOADER(wrds_table);
 IWL_BIOS_TABLE_LOADER(ewrd_table);
+IWL_BIOS_TABLE_LOADER(wsss_table);
+IWL_BIOS_TABLE_LOADER(ewss_table);
 IWL_BIOS_TABLE_LOADER(wgds_table);
 IWL_BIOS_TABLE_LOADER(ppag_table);
 IWL_BIOS_TABLE_LOADER(phy_filters);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
index f7bd09195ab4..bd7ea0ff3d19 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
@@ -31,6 +31,7 @@
 
 #define IWL_SAR_ENABLE_MSK		BIT(0)
 #define IWL_REDUCE_POWER_FLAGS_POS	1
+#define IWL_BIOS_REVISION_UNSET		0xFF
 
 /* PPAG gain value bounds in 1/8 dBm */
 #define IWL_PPAG_MIN_LB	-16
@@ -223,6 +224,10 @@ int iwl_bios_get_wrds_table(struct iwl_fw_runtime *fwrt);
 
 int iwl_bios_get_ewrd_table(struct iwl_fw_runtime *fwrt);
 
+int iwl_bios_get_wsss_table(struct iwl_fw_runtime *fwrt);
+
+int iwl_bios_get_ewss_table(struct iwl_fw_runtime *fwrt);
+
 int iwl_bios_get_wgds_table(struct iwl_fw_runtime *fwrt);
 
 int iwl_bios_get_ppag_table(struct iwl_fw_runtime *fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index d0709ab2f593..33ce06f1a60a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -112,6 +112,10 @@ struct iwl_txf_iter_data {
  *	see &enum iwl_uefi_cnv_guid_status.
  *	Trust the UEFI variables if locked or in test mode.
  * @sar_profiles: sar profiles as read from WRDS/EWRD BIOS tables
+ * @sar_standalone_profiles: standalone sar profiles as read from
+ *	WSSS/EWSS BIOS tables (for Wi-Fi HB/UHB without concurrent BT)
+ * @wrds_table_revision: revision of WRDS BIOS table
+ * @ewrd_table_revision: revision of EWRD BIOS table
  * @geo_profiles: geographic profiles as read from WGDS BIOS table
  * @geo_bios_source: see &enum bios_source
  * @phy_filters: specific phy filters as read from WPFC BIOS table
@@ -206,6 +210,9 @@ struct iwl_fw_runtime {
 	bool tpc_enabled;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 	struct iwl_sar_profile sar_profiles[BIOS_SAR_MAX_PROFILE_NUM];
+	struct iwl_sar_profile sar_standalone_profiles[BIOS_SAR_MAX_PROFILE_NUM];
+	u8 wrds_table_revision;
+	u8 ewrd_table_revision;
 	u8 sar_chain_a_profile;
 	u8 sar_chain_b_profile;
 	u8 reduced_power_flags;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index 871d8f5db9c3..79fd95d08732 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -547,11 +547,11 @@ void iwl_uefi_get_uneb_table(struct iwl_trans *trans,
 }
 IWL_EXPORT_SYMBOL(iwl_uefi_get_uneb_table);
 
-static void iwl_uefi_set_sar_profile(struct iwl_fw_runtime *fwrt,
+static void iwl_uefi_set_sar_profile(struct iwl_sar_profile *profiles,
 				     const u8 *vals, u8 prof_index,
 				     u8 num_subbands, bool enabled)
 {
-	struct iwl_sar_profile *sar_prof = &fwrt->sar_profiles[prof_index];
+	struct iwl_sar_profile *sar_prof = &profiles[prof_index];
 
 	/*
 	 * Make sure fwrt has enough room to hold the data
@@ -573,7 +573,7 @@ static void iwl_uefi_set_sar_profile(struct iwl_fw_runtime *fwrt,
 				vals[chain * num_subbands + subband];
 	}
 
-	fwrt->sar_profiles[prof_index].enabled = enabled & IWL_SAR_ENABLE_MSK;
+	sar_prof->enabled = enabled & IWL_SAR_ENABLE_MSK;
 }
 
 int iwl_uefi_get_wrds_table(struct iwl_fw_runtime *fwrt)
@@ -617,8 +617,9 @@ int iwl_uefi_get_wrds_table(struct iwl_fw_runtime *fwrt)
 	/* The profile from WRDS is officially profile 1, but goes
 	 * into sar_profiles[0] (because we don't have a profile 0).
 	 */
-	iwl_uefi_set_sar_profile(fwrt, data->vals, 0,
+	iwl_uefi_set_sar_profile(fwrt->sar_profiles, data->vals, 0,
 				 num_subbands, data->mode);
+	fwrt->wrds_table_revision = data->revision;
 out:
 	kfree(data);
 	return ret;
@@ -670,14 +671,136 @@ int iwl_uefi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 		 * save them in sar_profiles[1-3] (because we don't
 		 * have profile 0).  So in the array we start from 1.
 		 */
-		iwl_uefi_set_sar_profile(fwrt, &data->vals[i * profile_size],
+		iwl_uefi_set_sar_profile(fwrt->sar_profiles,
+					 &data->vals[i * profile_size],
 					 i + 1, num_subbands, data->mode);
 
+	fwrt->ewrd_table_revision = data->revision;
+
 out:
 	kfree(data);
 	return ret;
 }
 
+int iwl_uefi_get_wsss_table(struct iwl_fw_runtime *fwrt)
+{
+	struct uefi_cnv_var_wrds *data __free(kfree) = NULL;
+	unsigned long expected_size;
+	unsigned long size;
+	int num_subbands;
+
+	if (fwrt->wrds_table_revision == IWL_BIOS_REVISION_UNSET) {
+		IWL_DEBUG_RADIO(fwrt,
+				"Skipping standalone SAR: WRDS table was not read\n");
+		return -EINVAL;
+	}
+
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_WSSS_NAME,
+					      "WSSS",
+					      UEFI_SAR_WRDS_TABLE_SIZE_REV2,
+					      &size);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	switch (data->revision) {
+	case 2:
+		expected_size = UEFI_SAR_WRDS_TABLE_SIZE_REV2;
+		num_subbands = UEFI_SAR_SUB_BANDS_NUM_REV2;
+		break;
+	case 3:
+		expected_size = UEFI_SAR_WRDS_TABLE_SIZE_REV3;
+		num_subbands = UEFI_SAR_SUB_BANDS_NUM_REV3;
+		break;
+	default:
+		IWL_DEBUG_RADIO(fwrt,
+				"Unsupported UEFI WSSS revision:%d\n",
+				data->revision);
+		return -EINVAL;
+	}
+
+	if (size != expected_size)
+		return -EINVAL;
+
+	if (fwrt->wrds_table_revision != data->revision) {
+		IWL_DEBUG_RADIO(fwrt,
+				"Skipping standalone SAR: WRDS/WSSS revision mismatch (WRDS rev %d, WSSS rev %d)\n",
+				fwrt->wrds_table_revision,
+				data->revision);
+		return -EINVAL;
+	}
+
+	IWL_DEBUG_RADIO(fwrt, "Reading WSSS (WRDS Standalone) tbl_rev=%d\n",
+			data->revision);
+	iwl_uefi_set_sar_profile(fwrt->sar_standalone_profiles,
+				 data->vals, 0,
+				 num_subbands,
+				 data->mode);
+	return 0;
+}
+
+int iwl_uefi_get_ewss_table(struct iwl_fw_runtime *fwrt)
+{
+	struct uefi_cnv_var_ewrd *data __free(kfree) = NULL;
+	unsigned long expected_size;
+	unsigned long size;
+	int num_subbands;
+	int profile_size;
+	int i;
+
+	if (fwrt->ewrd_table_revision == IWL_BIOS_REVISION_UNSET) {
+		IWL_DEBUG_RADIO(fwrt,
+				"Skipping standalone SAR: EWRD table was not read\n");
+		return -EINVAL;
+	}
+
+	data = iwl_uefi_get_verified_wifi_var(fwrt,
+					      IWL_UEFI_EWSS_NAME,
+					      "EWSS",
+					      UEFI_SAR_EWRD_TABLE_SIZE_REV2,
+					      &size);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	switch (data->revision) {
+	case 3:
+		expected_size = UEFI_SAR_EWRD_TABLE_SIZE_REV3;
+		num_subbands = UEFI_SAR_SUB_BANDS_NUM_REV3;
+		profile_size = UEFI_SAR_PROFILE_SIZE_REV3;
+		break;
+	case 2:
+		expected_size = UEFI_SAR_EWRD_TABLE_SIZE_REV2;
+		num_subbands = UEFI_SAR_SUB_BANDS_NUM_REV2;
+		profile_size = UEFI_SAR_PROFILE_SIZE_REV2;
+		break;
+	default:
+		IWL_DEBUG_RADIO(fwrt,
+				"Unsupported UEFI EWSS revision:%d\n",
+				data->revision);
+		return -EINVAL;
+	}
+
+	if (size != expected_size ||
+	    data->num_profiles >= BIOS_SAR_MAX_PROFILE_NUM)
+		return -EINVAL;
+
+	if (fwrt->ewrd_table_revision != data->revision) {
+		IWL_DEBUG_RADIO(fwrt,
+				"Skipping standalone SAR: EWRD/EWSS revision mismatch (EWRD rev %d, EWSS rev %d)\n",
+				fwrt->ewrd_table_revision,
+				data->revision);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < data->num_profiles; i++)
+		iwl_uefi_set_sar_profile(fwrt->sar_standalone_profiles,
+					 &data->vals[i * profile_size],
+					 i + 1, num_subbands,
+					 data->mode);
+
+	return 0;
+}
+
 int iwl_uefi_get_wgds_table(struct iwl_fw_runtime *fwrt)
 {
 	struct uefi_cnv_var_wgds *data;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
index 64fa1a78aacf..f4f7a447e528 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
@@ -15,6 +15,8 @@
 #define IWL_UEFI_WRDS_NAME		L"UefiCnvWlanWRDS"
 #define IWL_UEFI_GLUI_NAME		L"UefiCnvCommonGLUI"
 #define IWL_UEFI_EWRD_NAME		L"UefiCnvWlanEWRD"
+#define IWL_UEFI_WSSS_NAME		L"UefiCnvWlanWSSS"
+#define IWL_UEFI_EWSS_NAME		L"UefiCnvWlanEWSS"
 #define IWL_UEFI_WGDS_NAME		L"UefiCnvWlanWGDS"
 #define IWL_UEFI_PPAG_NAME		L"UefiCnvWlanPPAG"
 #define IWL_UEFI_WTAS_NAME		L"UefiCnvWlanWTAS"
@@ -337,6 +339,8 @@ int iwl_uefi_handle_tlv_mem_desc(struct iwl_trans *trans, const u8 *data,
 				 u32 tlv_len, struct iwl_pnvm_image *pnvm_data);
 int iwl_uefi_get_wrds_table(struct iwl_fw_runtime *fwrt);
 int iwl_uefi_get_ewrd_table(struct iwl_fw_runtime *fwrt);
+int iwl_uefi_get_wsss_table(struct iwl_fw_runtime *fwrt);
+int iwl_uefi_get_ewss_table(struct iwl_fw_runtime *fwrt);
 int iwl_uefi_get_wgds_table(struct iwl_fw_runtime *fwrt);
 int iwl_uefi_get_ppag_table(struct iwl_fw_runtime *fwrt);
 int iwl_uefi_get_tas_table(struct iwl_fw_runtime *fwrt,
@@ -399,6 +403,16 @@ static inline int iwl_uefi_get_ewrd_table(struct iwl_fw_runtime *fwrt)
 	return -ENOENT;
 }
 
+static inline int iwl_uefi_get_wsss_table(struct iwl_fw_runtime *fwrt)
+{
+	return -ENOENT;
+}
+
+static inline int iwl_uefi_get_ewss_table(struct iwl_fw_runtime *fwrt)
+{
+	return -ENOENT;
+}
+
 static inline int iwl_uefi_get_wgds_table(struct iwl_fw_runtime *fwrt)
 {
 	return -ENOENT;
-- 
2.34.1

