Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C985438030
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141903; cv=none; b=WdmoRYZRR/dqP2tYFGgKILSS+4N48oHOs0bDw6IXNaf7byZWw+6yTt7A13okdom8BQE9Az1uUkS1p8n1u7duIUE0dNYJ8qV2tv9GL8ekN9CbDTrO8+ULxxhciCXRKWbMtXBrpDRm5yXGDrIcWqSMoIlSJ3enJg+JtiAauijORCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141903; c=relaxed/simple;
	bh=SrL7Uwtj30YP+vPU2uFuJsboj+XtmHVfh1COGjef0vY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ld/4M52OmOYJZzEMOf5gMmmMoP6HdD0+PCDlt318GrEFxtkhKZpNew85IC1yr18bwDjln1hrMsKpX94EUzamjAtavUDxQS9llnarFGnz1Y9Hx8nKeogsNUdnzhMIefvEPXRIFgZE6EanQSicx+JcoYK9IvC/yE122bmtF7V6zNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FKkQraHn; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FKkQraHn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141897; x=1815677897;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SrL7Uwtj30YP+vPU2uFuJsboj+XtmHVfh1COGjef0vY=;
  b=FKkQraHnSR5MqqgMxotlJpQZfjJvtOVPBSpthAYBwTVdDCDJJvgUxeWT
   lshxopwCdDpwpmFvAicOk5Fqn2m0SmvIQ0L1v3/xy1FabKjL9vkovi9RB
   U8zM3NY1kfu+5amLSPVvNqgpkt58nhahfzimeddoRgOaFWSHxa09x0Z4M
   L0Hli/hM7B+ZPhvuzXCqo7bg+EOsF/LTuRWTmCYuB1/iSJ642bw1IycDG
   L7ScEpR+YIVeamK2mEdpZiplO5OSjd23dQf4YKrqJae+5ktZ0bSpU/J4T
   BnloMF+cGkQXVuJI8B8RPOcEs66OTDYhtUNZx3gMbzSAuJ59bsp+7FkS2
   A==;
X-CSE-ConnectionGUID: 7EUoQ3rcTDy/IZxNR5Ahjw==
X-CSE-MsgGUID: u4BoS9HLTaGeQqJqgnQaRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160934"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160934"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:58:00 -0700
X-CSE-ConnectionGUID: uWzrWtPESu6GLgvi19YjDA==
X-CSE-MsgGUID: Dcf68JBaQ1uYzTHg7+BjBg==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:59 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-fixes 15/15] wifi: iwlwifi: adapt ND match notif sizing to fixed matches array
Date: Wed, 15 Jul 2026 21:57:15 +0300
Message-Id: <20260715215523.4c4346140bcc.I44313ac41daca352e6aecdba09a1c3570c3eea06@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Switch iwl_scan_offload_match_info::matches to a fixed-size array and
adjust D3 netdetect size handling accordingly.

In MVM D3 paths, compute expected payload size as
offsetof(struct iwl_scan_offload_match_info, matches) + matches_len to
preserve previous behavior after the struct layout change.

In MLD D3 netdetect handling, keep the simple full-notification size
assumption and validate against sizeof(*notif) before accessing data.

This keeps scan offload / netdetect functionality unchanged while
making length checks consistent with the new struct definition.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c      | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 08f4cc3ea1c3..ee78371082b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1319,7 +1319,7 @@ struct iwl_scan_offload_match_info {
 	u8 resume_while_scanning;
 	u8 self_recovery;
 	__le16 reserved;
-	struct iwl_scan_offload_profile_match matches[];
+	struct iwl_scan_offload_profile_match matches[IWL_SCAN_MAX_PROFILES_V2];
 } __packed; /* SCAN_OFFLOAD_PROFILES_QUERY_RSP_S_VER_3 and
 	     * SCAN_OFFLOAD_MATCH_INFO_NOTIFICATION_S_VER_1
 	     */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 109265149963..6b11fa32ea5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2459,13 +2459,15 @@ iwl_mvm_netdetect_query_results(struct iwl_mvm *mvm,
 
 	if (fw_has_api(&mvm->fw->ucode_capa,
 		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
-		query_len = sizeof(struct iwl_scan_offload_match_info);
 		matches_len = sizeof(struct iwl_scan_offload_profile_match) *
 			max_profiles;
+		query_len = offsetof(struct iwl_scan_offload_match_info,
+				     matches) + matches_len;
 	} else {
-		query_len = sizeof(struct iwl_scan_offload_profiles_query_v1);
 		matches_len = sizeof(struct iwl_scan_offload_profile_match_v1) *
 			max_profiles;
+		query_len = sizeof(struct iwl_scan_offload_profiles_query_v1) +
+			matches_len;
 	}
 
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
@@ -2819,7 +2821,8 @@ static void iwl_mvm_nd_match_info_handler(struct iwl_mvm *mvm,
 	if (IS_ERR_OR_NULL(vif))
 		return;
 
-	if (len < sizeof(struct iwl_scan_offload_match_info) + matches_len) {
+	if (len < offsetof(struct iwl_scan_offload_match_info, matches) +
+		    matches_len) {
 		IWL_ERR(mvm, "Invalid scan match info notification\n");
 		return;
 	}
-- 
2.34.1

