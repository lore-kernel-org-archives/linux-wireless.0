Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B276646982B
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246382; cv=none; b=Z8vSQtpeGFiQto7WGTHM4BGpJ3231j+8LrO9hIop1V+bXgSqhy55S+SD4M+u8m1I+dqpLfgqaVfhb1e97en8KK6ZwfjQcr1KE58idJPM08eNRryR+09oaQ2xTb3pQmNyjCege23jfkdoFhUphX9khzGTVIYBhMczIG9ou25/Ki4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246382; c=relaxed/simple;
	bh=HNysII698xbPGSnE9hHFMciGlnp6Vpus5sI6kuKPDws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hyCU9ImbSwbfabwzxT5Dnwsh1voSVlce0WnuEw/klKvK3b6DQCLCr4bd6HyyjrTVDBlWaXhPKA19xUe9kCZiewEGij5qDBFjJYGxvr49egP76PBZCZHWpF0oPp68WqdG78Ym8Vflsjk4OksirHUpEZNSjaHGZHePwT7LMfsWePU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMHuqqUm; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMHuqqUm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246380; x=1821782380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HNysII698xbPGSnE9hHFMciGlnp6Vpus5sI6kuKPDws=;
  b=nMHuqqUmCBkk/89pHWsJMdFQihhXu/KDZd6/6CZLYqNrPjtGOjQAeC5A
   7+BhwDV/hAk4tKG6iJuSwF0qO3XuO7WIATQsiWPm35ZKLjUgOt+K486Lc
   /BmPdh9wCvBJLdu24sf26zPI1RXkBVKv5HrryIPRIFub+uzD9FkdBhWZT
   ar1Lkht7TbixxXDAgvcUUQ9oTQn9PsFDRJTHQGjSgF8s23CS2/J6E8/VG
   /3LEe/3++Xjad8VrwEanKwdjxSkrlY8xkdVXlSui9ve7ObpO868lln7sS
   JQus7MnJCFhoDBJfgLwLTDO7s61wz9jVHW2MyI1cbg1G29YRBlT485VEe
   w==;
X-CSE-ConnectionGUID: C1wVgyAVTcm7QgH/N34V5A==
X-CSE-MsgGUID: zcAe4Z3wRruTXcCyiPNgiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134877"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134877"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:39 -0700
X-CSE-ConnectionGUID: Ry+F6WiJRc6CBTmsxcjy/Q==
X-CSE-MsgGUID: oATdqDUQRrqVTVBuxLUk1Q==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:38 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: uefi: Fix SAR enable check to use mode parameter correctly
Date: Thu, 24 Sep 2026 13:41:19 +0300
Message-Id: <20260924133942.fead36334640.Ib184c201e677cb6d95f64e725a1e39148234fa41@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
References: <20260924104129.162876-1-miriam.rachel.korenblit@intel.com>
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

