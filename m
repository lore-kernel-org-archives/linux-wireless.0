Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E94431E65
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716736; cv=none; b=kluc/FRQorx/IB51/FVrk3LqtAx1d0ODLXApcrTEvIAtAbFA4b58pp4umSo99yRHXU0KNn+LtDulzZztjOMk10veGT12oK0GKEpOqcHTNcqx2TcVVoNUJpMVKKar7EeyHQmq2yw8zFgig/jsY2EFg9CBOV8v/s4Ejllhyew6vxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716736; c=relaxed/simple;
	bh=S1t0W/rgqtSb3mxvTuyFQoY14pbw6LHs3RJG5u6cOdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OcZctekntDhUMTe7O1EbFmZzMwPYMBpoisrJwOVFFhmo/NMwmrYEUnocvrY3If/Jo6OD/q0jZxcr+ln2rzbJ44G8l+6aY5oshxFc4xLhd+YoipzPA05P5oSdeZ7EjnIz5NtXZnzrLlmYcCpVsagM8OYqsv4VfhSc8Lm7MghD4Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JCB05yA0; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JCB05yA0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716736; x=1823252736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S1t0W/rgqtSb3mxvTuyFQoY14pbw6LHs3RJG5u6cOdc=;
  b=JCB05yA0F7z1RfBQoBdWa1osRf2qspGWhVp0Gfd18SUqsdzPfgauDorp
   cezzvOYkC6127w8EX9EZn2tlEeCVvWrM+MkIYmdol1LF9ZXkw6kdLUV9p
   3SOYAiRPsJavn+EzutDT3yx8/gxaNexfYumYQ0EzZKobQs6qnnd2Ew1W8
   DfKhCfC/T4FhqRuqCw+wjgpbhtAwNuI/6AnAjlc5952uSq8kGeM6u4NBJ
   2LQudyL5vYIKm77qIj8HvH2ICmTEon+/y7LBVpJkE5GLLfednBsQi3Lxn
   /8uNjU7tENGIjiOUcCm3Ug8ix7p/GawY0kJUFxG3nzqSCmXEsXynfFU+E
   Q==;
X-CSE-ConnectionGUID: Tciz9DJrRymosXJA7cAhOg==
X-CSE-MsgGUID: JztZLi7uSbSRzvVhNc01WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454185"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454185"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:36 -0700
X-CSE-ConnectionGUID: edrTCLgPQCmad98Imcj9iQ==
X-CSE-MsgGUID: 9wtt1xOVTDGtLAbw2PmhQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="651028"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:34 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 11/13] wifi: iwlwifi: mvm: uninline iwl_mvm_ftm_start versions
Date: Sun, 11 Oct 2026 14:07:12 +0300
Message-Id: <20261011140453.97f5c8503204.Ib88f908b0638889e84753ae334525c4c52064838@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This is not a performance-critical path, and with clang
and KASAN it can use a lot of stack space. Uninline the
various versions to avoid that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 49 +++++++++++--------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 4c39a452564d..dd1b80561f8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -519,8 +519,9 @@ static int iwl_mvm_ftm_send_cmd(struct iwl_mvm *mvm, struct iwl_host_cmd *hcmd)
 	return err;
 }
 
-static int iwl_mvm_ftm_start_v5(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				struct cfg80211_pmsr_request *req)
+static int noinline_for_stack
+iwl_mvm_ftm_start_v5(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		     struct cfg80211_pmsr_request *req)
 {
 	struct iwl_tof_range_req_cmd_v5 cmd_v5;
 	struct iwl_host_cmd hcmd = {
@@ -545,8 +546,9 @@ static int iwl_mvm_ftm_start_v5(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return iwl_mvm_ftm_send_cmd(mvm, &hcmd);
 }
 
-static int iwl_mvm_ftm_start_v7(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				struct cfg80211_pmsr_request *req)
+static int noinline_for_stack
+iwl_mvm_ftm_start_v7(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		     struct cfg80211_pmsr_request *req)
 {
 	struct iwl_tof_range_req_cmd_v7 cmd_v7;
 	struct iwl_host_cmd hcmd = {
@@ -575,8 +577,9 @@ static int iwl_mvm_ftm_start_v7(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return iwl_mvm_ftm_send_cmd(mvm, &hcmd);
 }
 
-static int iwl_mvm_ftm_start_v8(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				struct cfg80211_pmsr_request *req)
+static int noinline_for_stack
+iwl_mvm_ftm_start_v8(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		     struct cfg80211_pmsr_request *req)
 {
 	struct iwl_tof_range_req_cmd_v8 cmd;
 	struct iwl_host_cmd hcmd = {
@@ -601,8 +604,10 @@ static int iwl_mvm_ftm_start_v8(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return iwl_mvm_ftm_send_cmd(mvm, &hcmd);
 }
 
-static int iwl_mvm_ftm_start_v9(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				struct cfg80211_pmsr_request *req)
+
+static int noinline_for_stack
+iwl_mvm_ftm_start_v9(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		     struct cfg80211_pmsr_request *req)
 {
 	struct iwl_tof_range_req_cmd_v9 cmd;
 	struct iwl_host_cmd hcmd = {
@@ -735,9 +740,10 @@ iwl_mvm_ftm_put_target_v7(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 					      &target->initiator_ap_flags);
 }
 
-static int iwl_mvm_ftm_start_v11(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif,
-				 struct cfg80211_pmsr_request *req)
+static int noinline_for_stack
+iwl_mvm_ftm_start_v11(struct iwl_mvm *mvm,
+		      struct ieee80211_vif *vif,
+		      struct cfg80211_pmsr_request *req)
 {
 	struct iwl_tof_range_req_cmd_v11 cmd;
 	struct iwl_host_cmd hcmd = {
@@ -807,9 +813,10 @@ iwl_mvm_ftm_put_target_v8(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return 0;
 }
 
-static int iwl_mvm_ftm_start_v12(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif,
-				 struct cfg80211_pmsr_request *req)
+static int noinline_for_stack
+iwl_mvm_ftm_start_v12(struct iwl_mvm *mvm,
+		      struct ieee80211_vif *vif,
+		      struct cfg80211_pmsr_request *req)
 {
 	struct iwl_tof_range_req_cmd_v12 cmd;
 	struct iwl_host_cmd hcmd = {
@@ -835,9 +842,10 @@ static int iwl_mvm_ftm_start_v12(struct iwl_mvm *mvm,
 	return iwl_mvm_ftm_send_cmd(mvm, &hcmd);
 }
 
-static int iwl_mvm_ftm_start_v13(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif,
-				 struct cfg80211_pmsr_request *req)
+static int noinline_for_stack
+iwl_mvm_ftm_start_v13(struct iwl_mvm *mvm,
+		      struct ieee80211_vif *vif,
+		      struct cfg80211_pmsr_request *req)
 {
 	struct iwl_tof_range_req_cmd_v13 cmd;
 	struct iwl_host_cmd hcmd = {
@@ -951,9 +959,10 @@ iwl_mvm_ftm_put_target_v10(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return 0;
 }
 
-static int iwl_mvm_ftm_start_v14(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif,
-				 struct cfg80211_pmsr_request *req)
+static int noinline_for_stack
+iwl_mvm_ftm_start_v14(struct iwl_mvm *mvm,
+		      struct ieee80211_vif *vif,
+		      struct cfg80211_pmsr_request *req)
 {
 	struct iwl_tof_range_req_cmd cmd;
 	struct iwl_host_cmd hcmd = {
-- 
2.34.1

