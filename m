Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4783AA1AE
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2026 19:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778787913; cv=none; b=Tp8tFYInGIfPBu91bgl1QnF1dnMPTrG9RTF6dr0HRKElI3UMvOCm+a1v+WCy1YjqpcpOGdjPbD/AF3LcEzxz9CwiHsnraBCZogQYNjeoGmF3Xv7B/OXqYrkcOJXaPOLwe6kbOtqyyQgzq/7cEBcAyWt022tZgtdbV7enO3+dovs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778787913; c=relaxed/simple;
	bh=wClORBy9VhIJ4YdlVpnz6KvNJUTeSqLAp75ElW4c9O4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lMG5zh4mZ8HVNejMvlm/mNefjnwygOKzF5y4tyxACN6PIknU0tZs7L0+XED1hZzVTaWmqYA963guMl6rY4cImeIgKkRHkcCLwacgu0/pV0oGO5myS4rXh8MzVDLvZAys6c9mbEPpeSyGySRmcWM6IV5r55DtMaOU1FrfUd7OAf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j7x7r35m; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j7x7r35m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778787911; x=1810323911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wClORBy9VhIJ4YdlVpnz6KvNJUTeSqLAp75ElW4c9O4=;
  b=j7x7r35mAgP+myVeqW4wD5O2ajwK+qa8JbUq5ZXVG6UE+w58jOw+I7Ln
   RcoTHR2M/JWfmUD1+f5xkH0kU2S6YU11u5h3NC/HFpNDAmQY44X6S3vLw
   j+/t9r13GWlPkiGw7ULenii2BcpTj7bYnAUGbvJ2X9suxXaUUUlsRcVu9
   EbUd7dQJEmypPZKgZjleypg3x5CQbEzTNqe1l1XfhTsUP9j8upgAtniRu
   1rsZF9KdOCUs/+Rpyr4PHcjU3JrcSD9Don3IgdrjD3kuI1nI1hSfVw4E2
   Dz/MI9074RjsU+O0TxhB5uihUDf4CWUIDnLRGbNf2GSNzFZj2QVa091Z9
   Q==;
X-CSE-ConnectionGUID: 4Hb3Cq4eSjmxMMwdA19KRQ==
X-CSE-MsgGUID: j0AezBXbRBaPxHS7+Qq7ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="83352626"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="83352626"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 12:45:11 -0700
X-CSE-ConnectionGUID: IVt2ylyPTJWK1WCj9YIT1w==
X-CSE-MsgGUID: UlKXR7d2QaWAbIvKYmYs/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="237616396"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 12:45:09 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: mld: disallow puncturing in US/CA for WH
Date: Thu, 14 May 2026 22:44:34 +0300
Message-Id: <20260514224230.f1421d30fde1.I900c9e2e3dd722619db12ba10d0879a56a2a55f2@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514194434.401241-1-miriam.rachel.korenblit@intel.com>
References: <20260514194434.401241-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

FM continues to follow the BIOS/MCC policy, while WH sets
DISALLOW_PUNCTURING for US/CA and clears it for other MCC values.
Update the MCC handling accordingly.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mcc.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
index 16bb1b4904f9..8502129abe49 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mcc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 
 #include <net/cfg80211.h>
@@ -129,7 +129,7 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 
 	mld->mcc_src = resp->source_id;
 
-	/* FM is the earliest supported and later always do puncturing */
+	/* FM follows BIOS/MCC policy, WH disallows puncturing only in US/CA. */
 	if (CSR_HW_RFID_TYPE(mld->trans->info.hw_rf_id) == IWL_CFG_RF_TYPE_FM) {
 		if (!iwl_puncturing_is_allowed_in_bios(mld->bios_enable_puncturing,
 						       le16_to_cpu(resp->mcc)))
@@ -137,6 +137,15 @@ iwl_mld_get_regdomain(struct iwl_mld *mld,
 		else
 			__clear_bit(IEEE80211_HW_DISALLOW_PUNCTURING,
 				    mld->hw->flags);
+	} else if (CSR_HW_RFID_TYPE(mld->trans->info.hw_rf_id) ==
+			IWL_CFG_RF_TYPE_WH) {
+		u16 mcc = le16_to_cpu(resp->mcc);
+
+		if (mcc == IWL_MCC_US || mcc == IWL_MCC_CANADA)
+			ieee80211_hw_set(mld->hw, DISALLOW_PUNCTURING);
+		else
+			__clear_bit(IEEE80211_HW_DISALLOW_PUNCTURING,
+				    mld->hw->flags);
 	}
 
 out:
-- 
2.34.1

