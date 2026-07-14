Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7147144CAFC
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037764; cv=none; b=oTD0t3TmvhiQsI4HBYJ+LD+hQitEH3sCSs9gYXcc8Bjb592Ouzdfpspteek9GW2fwFf/SbrgwsZDShZV46Y0xznDjKXgOmPQ5zkeEi5cx8TOnEc5vorPt8IE7RV4QqXEvQXPaQjz07YCeTaw8EcbxKAKRhd7/T94c48lPAgcRlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037764; c=relaxed/simple;
	bh=lgdY2i2zY0yJXwsvhw/nNRTH7tXzSuNZr3zyw1eFAQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GVPILNpukSQwt0xCYTFf1w3VUoJlqq5ZpHyCAOmLJN88gTool3V9SIaomre9nLMITuYSSljzyIzkyX/EeSTHXNJsC3kr7l1MWU0HT1DA4GTf1OvabmTA9vjwD2TZDo90iznRJBSkckbpelbx/5S/zCJv7IJOemDnCQqYvdFNSOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mrOULGHa; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mrOULGHa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784037762; x=1815573762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lgdY2i2zY0yJXwsvhw/nNRTH7tXzSuNZr3zyw1eFAQc=;
  b=mrOULGHad84oUZRQvkJo+9y+ooK6l0nihzKJZqJ2dJgcUmr/cXyD19ix
   gS8R9gh66vR/kErT0FZyJMXuFd3mYf2LpZf2fls5RGAZnwEFPGUmiNixj
   7hZfvaVm8oon98N5Av/yzHkCrOVN2nWaOnmLolNwWISl2f5Ww4B5bI73x
   T9660TvMpZ6K4Uqbijzv0APB9hziP/Lvj0uIjkG7DPEWWvT0WUmJTd0iy
   p8XS7ADmVqnK7M9qf0GNsDdwK7YKMmE1KTCtJxrROYqwQ+PAeqc9jTRLm
   j7viNMDBVONKC42SJ1QdCxXo1DYYKErO1zOQDB9b3imr3+Phy8/w1Oi6e
   w==;
X-CSE-ConnectionGUID: kaWmKIDoQ56EljhKLXPEIg==
X-CSE-MsgGUID: 9rHvWw61RkaOdvN8FbC23Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84855058"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="84855058"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:02:42 -0700
X-CSE-ConnectionGUID: hEddqk7OTTiYHCEk9/6nNA==
X-CSE-MsgGUID: +RcCpdfrQI2AWDYX3Pms6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="254737839"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 07:02:41 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 01/15] wifi: iwlwifi: add a compile time check for too long hcmds
Date: Tue, 14 Jul 2026 17:02:04 +0300
Message-Id: <20260714165826.a549b9499e3e.Id1a95bbbf92b5862862becaf57419bb9fe1385e5@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260714140218.2887000-1-miriam.rachel.korenblit@intel.com>
References: <20260714140218.2887000-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

A host command that is bigger than the allowed payload length should be
sent with the NOCOPY flag. If it is sent without, we will get a warning.

We do know at compile time what is the maximum size of a hcmd payload that
the transport supports, so in order to catch bugs early,
add a compile time check to iwl_*_send_cmd_pdu to catch that.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/hcmd.h |  9 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 20 ++++++++++++++-----
 .../net/wireless/intel/iwlwifi/mvm/utils.c    |  8 ++++----
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/hcmd.h b/drivers/net/wireless/intel/iwlwifi/mld/hcmd.h
index 64a8d4248324..19e1c9e509cf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/hcmd.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/hcmd.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 #ifndef __iwl_mld_hcmd_h__
 #define __iwl_mld_hcmd_h__
@@ -42,7 +42,12 @@ __iwl_mld_send_cmd_with_flags_pdu(struct iwl_mld *mld, u32 id,
 
 #define _iwl_mld_send_cmd_with_flags_pdu(mld, id, flags, data, len,	\
 					 ignored...)			\
-	__iwl_mld_send_cmd_with_flags_pdu(mld, id, flags, data, len)
+	({								\
+		BUILD_BUG_ON(__builtin_constant_p(len) &&		\
+			     (u16)(len) > IWL_MAX_CMD_PAYLOAD_SIZE);	\
+		__iwl_mld_send_cmd_with_flags_pdu(mld, id, flags,	\
+						  data, len);		\
+	})
 #define iwl_mld_send_cmd_with_flags_pdu(mld, id, flags, data, len...)	\
 	_iwl_mld_send_cmd_with_flags_pdu(mld, id, flags, data, ##len,	\
 					 sizeof(*(data)))
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 683cac56822c..1b56a2695bde 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1675,14 +1675,24 @@ u32 iwl_mvm_get_systime(struct iwl_mvm *mvm);
 /* Tx / Host Commands */
 int iwl_mvm_send_cmd(struct iwl_mvm *mvm,
 		     struct iwl_host_cmd *cmd);
-int iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u32 id,
-			 u32 flags, u16 len, const void *data);
+int _iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u32 id,
+			  u32 flags, u16 len, const void *data);
+#define iwl_mvm_send_cmd_pdu(mvm, id, flags, len, data) ({		\
+	BUILD_BUG_ON(__builtin_constant_p(len) &&			\
+		     (u16)(len) > IWL_MAX_CMD_PAYLOAD_SIZE);		\
+	_iwl_mvm_send_cmd_pdu(mvm, id, flags, len, data);		\
+})
 int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm,
 			    struct iwl_host_cmd *cmd,
 			    u32 *status);
-int iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id,
-				u16 len, const void *data,
-				u32 *status);
+int _iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id,
+				 u16 len, const void *data,
+				 u32 *status);
+#define iwl_mvm_send_cmd_pdu_status(mvm, id, len, data, status) ({	\
+	BUILD_BUG_ON(__builtin_constant_p(len) &&			\
+		     (u16)(len) > IWL_MAX_CMD_PAYLOAD_SIZE);		\
+	_iwl_mvm_send_cmd_pdu_status(mvm, id, len, data, status);	\
+})
 int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
 		       struct ieee80211_sta *sta);
 int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 2e12f93ad32b..849342c96ae7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -73,8 +73,8 @@ int iwl_mvm_send_cmd(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd)
 	return ret;
 }
 
-int iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u32 id,
-			 u32 flags, u16 len, const void *data)
+int _iwl_mvm_send_cmd_pdu(struct iwl_mvm *mvm, u32 id,
+			  u32 flags, u16 len, const void *data)
 {
 	struct iwl_host_cmd cmd = {
 		.id = id,
@@ -137,8 +137,8 @@ int iwl_mvm_send_cmd_status(struct iwl_mvm *mvm, struct iwl_host_cmd *cmd,
 /*
  * We assume that the caller set the status to the sucess value
  */
-int iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id, u16 len,
-				const void *data, u32 *status)
+int _iwl_mvm_send_cmd_pdu_status(struct iwl_mvm *mvm, u32 id, u16 len,
+				 const void *data, u32 *status)
 {
 	struct iwl_host_cmd cmd = {
 		.id = id,
-- 
2.34.1

