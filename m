Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4FC47DF8D
	for <linux-wireless@vger.kernel.org>; Fri, 15 May 2026 12:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778847019; cv=none; b=Y3oublsb5wZb5ykVmc7JX9sRj6vqu1dYYUq12i9CTKYH6hmAtjFEtvl6d3XAzLFG3T6C9muWbLBBTxbxUQuGr3VL6BPkivPKCUwXqFYnMn8vK6ESRGAWDItDo+fgQvT/ZVc/wt6RPyDydbySmXhc0nlr8N69nrsSwweSdH/6jak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778847019; c=relaxed/simple;
	bh=eZmu9FgnX6OI7O1TVIjaL0XW2oeiJzCbd0ref62RtwY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uYQmpeKXD5LHNEz2vlinaQiJWgWe2GZLU1AASQiO2OO2fwUa1IOXypQ66LaNidb7djub1ZSOYi5WvoYuPXtl/7uKROLOuK0/x2NoSk5CUCAHDZYHIGSLpWXXsupJ7zbk/5u4WAjIOCjy6THGqaCU3O2xNeyAFUF+3VVqn7U31ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FgVMvtBh; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FgVMvtBh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778847018; x=1810383018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eZmu9FgnX6OI7O1TVIjaL0XW2oeiJzCbd0ref62RtwY=;
  b=FgVMvtBhA7Ug3Iz5uEGS2ttobW5afJxYrBLFWk8zuW+lQNBxu4UgB0rB
   +qlW7o+5YUtZBAv7CBe8WfqfRWFQIzPezQHEqcfolEEGR3BPgqkZ2asZk
   JR+TnX3NLwKai7otBzXHe/ks5IHxsFxn6BxGtS2PTgykZjJz9qr/ze6Te
   FhAkuxISXLPciPuLJ5hs7S7eJjYE5XFPe2BX+n6mksKyySLB37gL4F0m7
   Mv0PbI3b2TSwuWyJ48qPSixf/d2vOSI2nPgKtb3QFihU3D0yd7XMn3RKg
   uaG/+hexOZhc83lib2lND/HPO96BqHtz6uNpiK53hPamMwIrRsNcqJfx5
   Q==;
X-CSE-ConnectionGUID: Jbpn9ABHTNe4ZohR9I5B6w==
X-CSE-MsgGUID: 0mHjHlnwQVeF03yLgZgMzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="91185685"
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="91185685"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 05:10:18 -0700
X-CSE-ConnectionGUID: yhAAzn8RS46Cvd4ZaQ6LaA==
X-CSE-MsgGUID: IV0dIznrTe2mWDAJAdDeIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,236,1770624000"; 
   d="scan'208";a="243650047"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2026 05:10:17 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 iwlwifi-next 11/15] wifi: iwlwifi: api: remove NAN_GROUP
Date: Fri, 15 May 2026 15:09:44 +0300
Message-Id: <20260515150751.1427beb76b0a.I6faacff99020984b14a76d9387f3aaa6281f3552@changeid>
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

This is no longer used by the driver nor supported by firmware,
and the kernel-doc reference to enum iwl_nan_subcmd_ids is long
dead. Remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
index dcac0ba8cccf..24bac3f00310 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/commands.h
@@ -22,7 +22,6 @@
  *	&enum iwl_data_path_subcmd_ids
  * @SCAN_GROUP: scan group, uses command IDs from
  *	&enum iwl_scan_subcmd_ids
- * @NAN_GROUP: NAN group, uses command IDs from &enum iwl_nan_subcmd_ids
  * @LOCATION_GROUP: location group, uses command IDs from
  *	&enum iwl_location_subcmd_ids
  * @BT_COEX_GROUP: bt coex group, uses command IDs from
@@ -43,7 +42,6 @@ enum iwl_mvm_command_groups {
 	PHY_OPS_GROUP = 0x4,
 	DATA_PATH_GROUP = 0x5,
 	SCAN_GROUP = 0x6,
-	NAN_GROUP = 0x7,
 	LOCATION_GROUP = 0x8,
 	BT_COEX_GROUP = 0x9,
 	PROT_OFFLOAD_GROUP = 0xb,
-- 
2.34.1

