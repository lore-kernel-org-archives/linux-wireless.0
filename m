Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A23457E4E
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754896; cv=none; b=uVaitDmvxBM23VLeRayDMN58etO3HaGIQ+oBOC6yxNglaHzzs5qUW4jDIQ4Ooa2HEbI4lgiUOTpPPouWqGZPAfGzkGn8FaUGlBgc8vgKBOt5l1MHmOWYN5AOZmoncI2/IVYC4DtLqSkUT1UxmHUnHMk1sQfoHk1lOQDrgGtw0bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754896; c=relaxed/simple;
	bh=tXdp+tVi1vZjR8eQiJwtLghS+qlVzD7Gmm1aYmNnNV0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NLqD8G7VZI5rVPtWa7sm6+YiqfgETcNkYd7n6rS4Dn+l21PYd5Jc6jL2T8pakbX4UlhKx4tAsmyQGSBkcnQeqadGVsHCVHH1fH3qhbq1NSp6sP4VEjZAdNybJKSstWPC0BFAtJcrwTRW/CvCsfiE5NMnvJkqzCcnz9qBLQt04Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EZRBfvPr; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EZRBfvPr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790754894; x=1822290894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tXdp+tVi1vZjR8eQiJwtLghS+qlVzD7Gmm1aYmNnNV0=;
  b=EZRBfvPr3WiWzeEgU3ChZIEBtmeoOYtORclRdx5+/YnfOUVDBvNbqQUc
   gqJaPuMckIzEktsanvUc5QC6KHr4CcEZY1WyHAmmTArH9maM1q0aNNV50
   wNFcRD2hvbxjE665K3h4tIh91cBEMpqR34pOz/ONMaUDhbGfIBLXlyBIc
   0sD/FvBWXg2k8DnYeUnZClkjxBdPRAj8LWm24SX+385nzCh3Gdah3ZdxB
   MOdKxp/3TPbBboh+5m8ZfuXwI7D/ZQc/cRGhyTTuCgXEUfvuXlWrt2+fS
   n7g4PYJ8fGyG5eZezNhGA4A4ESIJz1IDJibG9/Pnfpnqn69Xvre2JACeU
   g==;
X-CSE-ConnectionGUID: Aa7CrPqQRKq/LjI5vLFTeQ==
X-CSE-MsgGUID: oZBeeyVbRAK8ihzI9NS1Rg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="95296821"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="95296821"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:54 -0700
X-CSE-ConnectionGUID: H39m7HD9QFWFQHgQQmJoCw==
X-CSE-MsgGUID: Pi7+4rx4Rb2Y4q2L328Pfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="278962924"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 00:54:53 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: mld: report RX time from channel survey
Date: Wed, 30 Sep 2026 10:56:33 +0300
Message-Id: <20260930104824.77122fab0960.I9509587622fa7c6493b6baee53372c548bf60ed8@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
References: <20260930075643.1264585-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

Newer firmware versions will start reporting a separate RX time value
that represents for how long the channel was busy with Wi-Fi frames.
Previously the reported value for RX time was equal to the busy time.

As such, report the information as it will be useful in the future.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/scan.c | 5 ++++-
 drivers/net/wireless/intel/iwlwifi/mld/scan.h | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.c b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
index e44b24904c19..b942ac1e7ccc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
@@ -2273,6 +2273,7 @@ void iwl_mld_handle_channel_survey_notif(struct iwl_mld *mld,
 	/* Times are all in ms */
 	info->time = le32_to_cpu(notif->active_time);
 	info->time_busy = le32_to_cpu(notif->busy_time);
+	info->time_rx = le32_to_cpu(notif->rx_time);
 	info->noise =
 		iwl_average_neg_dbm(notif->noise, ARRAY_SIZE(notif->noise));
 }
@@ -2321,9 +2322,11 @@ int iwl_mld_mac80211_get_survey(struct ieee80211_hw *hw, int idx,
 			/* Found (the next) channel to report */
 			survey->channel = &sband->channels[per_band_idx];
 			survey->filled = SURVEY_INFO_TIME |
-					 SURVEY_INFO_TIME_BUSY;
+					 SURVEY_INFO_TIME_BUSY |
+					 SURVEY_INFO_TIME_RX;
 			survey->time = info->time;
 			survey->time_busy = info->time_busy;
+			survey->time_rx = info->time_rx;
 			survey->noise = info->noise;
 			if (survey->noise < 0)
 				survey->filled |= SURVEY_INFO_NOISE_DBM;
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.h b/drivers/net/wireless/intel/iwlwifi/mld/scan.h
index dc299fe2f999..74ebe8296693 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 #ifndef __iwl_mld_scan_h__
 #define __iwl_mld_scan_h__
@@ -151,11 +151,13 @@ struct iwl_mld_scan {
  *
  * @time: time in ms the radio was on the channel
  * @time_busy: time in ms the channel was sensed busy
+ * @time_rx: time in ms the channel was sensed to carry Wi-Fi frames
  * @noise: channel noise in dBm
  */
 struct iwl_mld_survey_channel {
 	u32 time;
 	u32 time_busy;
+	u32 time_rx;
 	s8 noise;
 };
 
-- 
2.34.1

