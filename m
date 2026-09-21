Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A852C38B7DD
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023179; cv=none; b=qlJumniABs4ICdFJidBFATA8c0hft3CaRpoOBmwwjZTT9pg8Q/Yb0Mux4wNblJw5yiTfxOLBDJAcphNZhHLoupgID18WYLK/vc9S/1Nla0BYd/IJkrVuoh+t39izdWKXc2kPNYW2o7qHeLFj44FnzDnbxKMf6C/2/5VnFWUEL1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023179; c=relaxed/simple;
	bh=XMz4iTTwOUAcSefMH1FHRBeyKzArOVkSS25+IgSQafg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ELfuJ3SxXfylzanDqvq/Jx1R/7+pfWFEBZFsLx8ZXUYrNHAlJqGtlnBVFeHTw1DCExdfuJbNjhMv+medOoo+zySzuLVtn43LN58AIz1oAyNnCMmHr/36JEdP2F60ZiGrN6M5H0PAiybsI0wR2YbSUI6hidNkAGut2hglM26p/Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F/ivihw8; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F/ivihw8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023177; x=1821559177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XMz4iTTwOUAcSefMH1FHRBeyKzArOVkSS25+IgSQafg=;
  b=F/ivihw8vQ11mEf5pf6R9P7Cfug4CQar3oIjfpXnjsSHVxsrkU3IP+Xs
   oImH5Ew98Fl/30rwPPXHkISG8CyxC7dnd0S179mj8nWVX0mF87RLTdCxW
   WP75W4jPQNa4arfmzyRWC5oM/BqvtCxziNO5GZNB+O7HJlZak1GEBgJs5
   3Q/mxa2NO5uaKTboteLSAP7YXh5VSMqn17JZ25yoP5BaitkfL+Z6hM/C1
   YFM9UjiKz6xJ3TzHMf3phHpwudX8Qg9R/vKb74eX2Xf+qWjFjaTp/u4q8
   A6EyG+S8mHkdXzDefn3njKuDkqHIbZaCwiK/AZjWSi6GjVM5mfu0dxreE
   g==;
X-CSE-ConnectionGUID: hDVcT03xRBuxke2HKi6ZKA==
X-CSE-MsgGUID: iDf+LpUkRfKhVGb686Qenw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128772"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128772"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:37 -0700
X-CSE-ConnectionGUID: 1VFzpGu+SaW8lRsH8U7QUw==
X-CSE-MsgGUID: E89dvW2bSievcckNm+583w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300761971"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:36 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH iwlwifi-next 04/15] wifi: iwlwifi: document MIC delay resolution
Date: Mon, 21 Sep 2026 23:41:14 +0300
Message-Id: <20260921233730.0947a2665f17.Ic994dae3eddf50955eac4cf79cb6388887c75b67@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
References: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

This delay is given in the same format as in the CIP capabilities.
Update the comment to make it clear that the resolution is 4 us.

Fixes: a1346ceab52a ("wifi: iwlwifi: Add a new version for sta config command")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
index 09b2cddc4ad2..01db6765855c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h
@@ -868,8 +868,8 @@ struct iwl_sta_cfg_cmd_v1 {
  * @dps_pad_time: DPS (Dynamic Power Save) padding delay resolution to ensure
  *	proper timing alignment
  * @dps_trans_delay: DPS minimal time that takes the peer to return to low power
- * @mic_prep_pad_delay: MIC prep time padding
- * @mic_compute_pad_delay: MIC compute time padding
+ * @mic_prep_pad_delay: MIC prep time padding (4 us resolution)
+ * @mic_compute_pad_delay: MIC compute time padding (4 us resolution)
  * @reserved: Reserved for alignment
  */
 struct iwl_sta_cfg_cmd_v2 {
@@ -942,8 +942,8 @@ struct iwl_sta_cfg_cmd_v2 {
  *	proper timing alignment
  * @dps_trans_delay: DPS minimal time that takes the peer to return to low power
  * @dps_enabled: flag indicating whether or not DPS is enabled
- * @mic_prep_pad_delay: MIC prep time padding
- * @mic_compute_pad_delay: MIC compute time padding
+ * @mic_prep_pad_delay: MIC prep time padding (4 us resolution)
+ * @mic_compute_pad_delay: MIC compute time padding (4 us resolution)
  * @nmi_sta_id: for an NDI peer STA, the NMI peer STA ID it relates to
  * @ndi_local_addr: for an NDI peer STA or NAN multicast data station,
  *	the local NDI interface MAC address
-- 
2.34.1

