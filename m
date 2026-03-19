Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C44A3BA229
	for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2026 09:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773911391; cv=none; b=fkcUMRbM7kx7FzRCIXtSYVKFmrVx4L+5fnV5pcihI+KiZLa7F9ftHLeJlM/whOH74kBaqog8/vW7E8MmUrGBAoS4x911BaXf24iatfRdRVoVMWlBfR52p9AJlMyDo9AxHalyHdT4yQV/m0Cr51WK4BZe+Fhqy6ChpxypCFnVt9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773911391; c=relaxed/simple;
	bh=CC4/VtxKmd+Ob47TiVXgkieXlyNUh2oJYcwMlDlkIZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ke8HV5fDmRdB2lEC+4XnGfDyQPxgsU9OCTSar6pWCUWPoi8WT4t6aiUE4LdiSBTfB2OKp2QGkJKeHjBu/U1XgMjvrOJUA4YrpvDbhkBm5dSCywV6DLYKtZcrvBwFWpHAbGcM000a1TYKHnmKWXSPFffAnozaL9qsWvMrOv/N2gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UFPtM0/g; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UFPtM0/g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773911388; x=1805447388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CC4/VtxKmd+Ob47TiVXgkieXlyNUh2oJYcwMlDlkIZw=;
  b=UFPtM0/gM2Jjvi6kAanvbUUDE6b4afZkRUpBhVd3DucHeXkTBQa0e7VY
   yeSbRyktrlE0WyiZ57huGhYD8REtIt2QMYA8XnQKnk769/ZMXmhVn+bd6
   ZcIACjWW17YeV/SelsHeXFYc1yCRJ0+Wn4LL7JN13vV42sPMW9eljNvdv
   LqKzAYb9vwDGATOiPNJN6drm6lA3gOAIoHZVOXmgLxipbEo9MbYReGaWl
   Yx4KZLzn7xpVXMlz/N3+skC6HoNiKYjDu7zT9+dQXfAE2ewnYIMlkpX5d
   B867F4tJPKf5GXZme/viNNXbuem7SYHFUdUYUgQY0Mk5TXZ6nnxJBiW3w
   w==;
X-CSE-ConnectionGUID: bOAN/WUdTCiXAoCF4u8eHw==
X-CSE-MsgGUID: KFm2/wHhQpKxMJ/9bMNZGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="73992712"
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="73992712"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 02:09:47 -0700
X-CSE-ConnectionGUID: 0f179kPuTyOh+7G4HgTWjg==
X-CSE-MsgGUID: cAKSR8ssSbOVib87eJOh6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,129,1770624000"; 
   d="scan'208";a="218387135"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2026 02:09:46 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 iwlwifi-next 06/15] wifi: iwlwifi: mld: remove unused scan expire time constants
Date: Thu, 19 Mar 2026 11:09:18 +0200
Message-Id: <20260319110722.4be7221113cf.I13e32d575bb854709af374519332b998bc1fed4a@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319090927.1090112-1-miriam.rachel.korenblit@intel.com>
References: <20260319090927.1090112-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Remove the unused IWL_MLD_SCAN_EXPIRE_TIME_SEC constant from
constants.h and its corresponding IWL_MLD_SCAN_EXPIRE_TIME
macro definition from mlo.c. These definitions are no longer
referenced.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/constants.h | 1 -
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c       | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/constants.h b/drivers/net/wireless/intel/iwlwifi/mld/constants.h
index 5d23a618ae3c..e2a5eecc18c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/constants.h
@@ -36,7 +36,6 @@
 #define IWL_MLD_PS_HEAVY_RX_THLD_PACKETS	8
 
 #define IWL_MLD_TRIGGER_LINK_SEL_TIME_SEC	30
-#define IWL_MLD_SCAN_EXPIRE_TIME_SEC		20
 
 #define IWL_MLD_TPT_COUNT_WINDOW (5 * HZ)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
index f842f5183223..f693f92e42b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
@@ -110,7 +110,6 @@ void iwl_mld_emlsr_tmp_non_bss_done_wk(struct wiphy *wiphy,
 }
 
 #define IWL_MLD_TRIGGER_LINK_SEL_TIME	(HZ * IWL_MLD_TRIGGER_LINK_SEL_TIME_SEC)
-#define IWL_MLD_SCAN_EXPIRE_TIME	(HZ * IWL_MLD_SCAN_EXPIRE_TIME_SEC)
 
 /* Exit reasons that can cause longer EMLSR prevention */
 #define IWL_MLD_PREVENT_EMLSR_REASONS	(IWL_MLD_EMLSR_EXIT_MISSED_BEACON	| \
-- 
2.34.1

