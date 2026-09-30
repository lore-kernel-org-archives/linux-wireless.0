Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24B9478E51
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790759911; cv=none; b=GH86Lam/1+monvGcaydzjwxt0K2vxIlcvjAMnCAMJOGfwwwFQoQfgFbkKpZ15vH5BDKh454tdLSOSw5JBrNaziwHbkFtGjjGdH4sQ9laYK+qy0uef9jxwkg0q2BEe+m0zq2v9qi9iXl2et2xNdjfM0VE/T4yWI3Sr80DOGXRbg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790759911; c=relaxed/simple;
	bh=eOLQdp9qIif6T5+vt5GglzHKqV8LxNIBD/cC5Yn1s6I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AZzR6Qw6M3zplgaBqxjW62kxSon8rHgZS/fR28ydTVw7VlbG+tqWv72FIMr6VtzgXiXHPGeQSqbgTrrhfvcTlmlXEIeCf5BQaXWxdceDwf+QftEp9lwgrIu7SklLQyaPHcpLprYS94qgRBnH2RarA3bXXuuLSHbL2L31w9FxwCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j2piKkYo; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j2piKkYo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790759905; x=1822295905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eOLQdp9qIif6T5+vt5GglzHKqV8LxNIBD/cC5Yn1s6I=;
  b=j2piKkYoaL8y8FsQCAi7bf500R2fev/q0ycrL6dey0xovrZbeeY2IluO
   8RkfKvUSq9C7GXL+9PXU2S4lzOrwIeRQsiHBd1rtC6NyUtJNRgkdZfQI+
   TpbMJQLnHV8S+5tUgISIewJdUkS5efr9yufcYR4jl5p4v1JtmpKIMtM2q
   HgTvAn9NqIMQu2W9F/7uK0DIWz0tlAYR80BaVtW/Y9Evi7qXdRgqtepx5
   UA2LGlNE62cJrS3v8SoxaVQ14jMs0tC1SzLfp3C+zANl3wFyN0y67hqeb
   lrdNBExeYPjkdRX1qVlVFWdwOjIEueZ7LsqY0kirlcD1zzUxLhoOpgklo
   A==;
X-CSE-ConnectionGUID: Xiz5Fg1CSBSIUd8RrhAzHg==
X-CSE-MsgGUID: 9BxyHKhbQ4iBJylqlHrZGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90447038"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90447038"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:23 -0700
X-CSE-ConnectionGUID: 14DfAxVMSQG89u6d7nRhNA==
X-CSE-MsgGUID: r0SWdzCkTPqhJd1/hyOOfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="275673611"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 02:18:21 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 15/15] wifi: iwlwifi: mld: remove unused fields from the firmware API
Date: Wed, 30 Sep 2026 12:19:52 +0300
Message-Id: <20260930121740.157e71ac8641.Iac2bd1f57b2c4bbdfe33efab31111a7de02bdf16@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
References: <20260930091952.1490467-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

ENABLE_STORE_BEACON is not defined in the firmware API and is never set
by the driver.

STA_CONFIG_CMD's trig_rnd_alloc was never used by the firmware either.

Remove both.

Assisted-by: LLM
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h | 3 +--
 drivers/net/wireless/intel/iwlwifi/mld/sta.c   | 7 +------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
index d3bed0216df4..9f7407c4f980 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/d3.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -366,7 +366,6 @@ enum iwl_wowlan_flags {
 	ENABLE_L3_FILTERING	= BIT(1),
 	ENABLE_NBNS_FILTERING	= BIT(2),
 	ENABLE_DHCP_FILTERING	= BIT(3),
-	ENABLE_STORE_BEACON	= BIT(4),
 	HAS_BEACON_PROTECTION	= BIT(5),
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index 7957ac11b0cd..97f013330f06 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -465,8 +465,8 @@ int iwl_mld_add_modify_sta_cmd(struct iwl_mld *mld,
 	struct iwl_mld_sta *mld_sta = iwl_mld_sta_from_mac80211(sta);
 	struct iwl_sta_cfg_cmd cmd = {};
 	int fw_id = iwl_mld_fw_sta_id_from_link_sta(mld, link_sta);
-	bool is_6ghz, uora_exists;
 	u32 link_mask;
+	bool is_6ghz;
 
 	lockdep_assert_wiphy(mld->wiphy);
 
@@ -479,7 +479,6 @@ int iwl_mld_add_modify_sta_cmd(struct iwl_mld *mld,
 			return -EINVAL;
 
 		is_6ghz = false;
-		uora_exists = false;
 
 		link_mask = iwl_mld_get_nan_link_mask(mld);
 	} else {
@@ -495,7 +494,6 @@ int iwl_mld_add_modify_sta_cmd(struct iwl_mld *mld,
 
 		link_mask = BIT(mld_link->fw_id);
 		is_6ghz = link->chanreq.oper.chan->band == NL80211_BAND_6GHZ;
-		uora_exists = link->uora_exists;
 	}
 
 	cmd.sta_id = cpu_to_le32(fw_id);
@@ -554,9 +552,6 @@ int iwl_mld_add_modify_sta_cmd(struct iwl_mld *mld,
 	}
 
 	if (link_sta->he_cap.has_he) {
-		cmd.trig_rnd_alloc =
-			cpu_to_le32(uora_exists ? 1 : 0);
-
 		/* PPE Thresholds */
 		iwl_mld_fill_pkt_ext(mld, link_sta, &cmd.pkt_ext);
 
-- 
2.34.1

