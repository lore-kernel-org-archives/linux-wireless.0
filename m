Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D747ECE3
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2026 12:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778847021; cv=none; b=CbZcRUmA7FXQhATzCgTviUJ3tYA0eJ/OjDM4jRP30XpcYtcFsq15jawlDGc7aRISdteDmVGWpyShE6VHOavk5BzutGBUmDdK0biBKgSn/WiKZjm9R7YUMXB3Wk+dYq7z9TIQJA9+19GTkR24m/E1huUgRZ8he0HrTDak30/gCCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778847021; c=relaxed/simple;
	bh=Ww27I9VL6mfwPpc8AWTX+2rHK2+DsU2opn46FV+tRuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ra9kXItQWJh6H6oEXypuZLhyYdeeOYiMooSFDzT2X8R5+9A3MLJ5A4EO8uTs/0ajKuQEmS7pdzPgA7G6u7NVlXeP9hcPG/NeKzMu3qtchT34zFce8nU9TvTQYi2FPcL58YmI5rxt2rsFGGAk3f5ZDHTkX1a125rNfNCuHy0n/yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NnJJa4Rl; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NnJJa4Rl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778847020; x=1810383020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ww27I9VL6mfwPpc8AWTX+2rHK2+DsU2opn46FV+tRuI=;
  b=NnJJa4RlyqMck2iLvqF0eN7SSpMv17/kRHzZhYxHCU5ZR+KdmprUDJ2s
   eZak3oLyDvTQrBbJiTWzMl/BA3zgsICZl9KI48G65I9uXTZlLS0VdtLM4
   +ha8vduf1FiSM9Q0t9WqjG2oBru9EWAPm6fhEmwrfpFupuk2wVj/+LS+1
   rZblddC5JZzywbleWm87oXwCc5v/z3sZg4rqZqXv6KMbPnvM2Ie2cqLsK
   3NXQKp4kw5uqZyxbIKKOao669XsqCuNl6sMexSKB0xcKuQef7pgPYyCEQ
   7rCYZxUjKCvb6gzKoTl8n3Grnop+eLujZfDxicSGICPC9H4/ruzMzSWxV
   w==;
X-CSE-ConnectionGUID: rNP34cElSx2xvHoEoHUl+g==
X-CSE-MsgGUID: nQ3NpR3qT2agkSo6+1t8/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="91185687"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="91185687"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 05:10:19 -0700
X-CSE-ConnectionGUID: qcn8/i8QToOyEP/hO2FH/w==
X-CSE-MsgGUID: E3bQXxSxSNCgDoJAZeEf6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="243650058"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 05:10:18 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 12/15] wifi: iwlwifi: api: clean up/fix some kernel-doc references
Date: Fri, 15 May 2026 15:09:45 +0300
Message-Id: <20260515150751.1e65dc357cbf.I454805593324e51ff71ec5e6bac83aa6dace5383@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260515120948.1157329-1-miriam.rachel.korenblit@intel.com>
References: <20260515120948.1157329-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Some of these structs just don't exist (any more), or other
versions should be referenced, clean that up.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h | 7 +++----
 drivers/net/wireless/intel/iwlwifi/fw/api/location.h | 7 ++++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index 24bac3f00310..abd259350589 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -57,8 +57,7 @@ enum iwl_legacy_cmds {
 	/**
 	 * @UCODE_ALIVE_NTFY:
 	 * Alive data from the firmware, as described in
-	 * &struct iwl_alive_ntf_v3 or &struct iwl_alive_ntf_v4 or
-	 * &struct iwl_alive_ntf_v5 or &struct iwl_alive_ntf_v7.
+	 * &struct iwl_alive_ntf_v3 or &struct iwl_alive_ntf_v7.
 	 */
 	UCODE_ALIVE_NTFY = 0x1,
 
@@ -384,7 +383,7 @@ enum iwl_legacy_cmds {
 	 * @STATISTICS_NOTIFICATION:
 	 * one of &struct iwl_notif_statistics_v10,
 	 * &struct iwl_notif_statistics_v11,
-	 * &struct iwl_notif_statistic,
+	 * &struct iwl_notif_statistics,
 	 * &struct iwl_statistics_operational_ntfy_ver_14
 	 * &struct iwl_statistics_operational_ntfy
 	 */
@@ -558,7 +557,7 @@ enum iwl_legacy_cmds {
 	WOWLAN_CONFIGURATION = 0xe1,
 
 	/**
-	 * @WOWLAN_TSC_RSC_PARAM: &struct iwl_wowlan_rsc_tsc_params_cmd_v4,
+	 * @WOWLAN_TSC_RSC_PARAM: &struct iwl_wowlan_rsc_tsc_params_cmd_ver_2,
 	 *	&struct iwl_wowlan_rsc_tsc_params_cmd
 	 */
 	WOWLAN_TSC_RSC_PARAM = 0xe2,
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
index 2ee3a48aa5df..d3f774ffacde 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  * Copyright (C) 2018-2022 Intel Corporation
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 #ifndef __iwl_fw_api_location_h__
 #define __iwl_fw_api_location_h__
@@ -81,8 +81,9 @@ enum iwl_location_subcmd_ids {
 	 * @TOF_RANGE_RESPONSE_NOTIF: ranging response, using one of
 	 *	&struct iwl_tof_range_rsp_ntfy_v5,
 	 *	&struct iwl_tof_range_rsp_ntfy_v6,
-	 *	&struct iwl_tof_range_rsp_ntfy_v7 or
-	 *	&struct iwl_tof_range_rsp_ntfy_v8
+	 *	&struct iwl_tof_range_rsp_ntfy_v7,
+	 *	&struct iwl_tof_range_rsp_ntfy_v9 or
+	 *	&struct iwl_tof_range_rsp_ntfy
 	 */
 	TOF_RANGE_RESPONSE_NOTIF = 0xFF,
 };
-- 
2.34.1

