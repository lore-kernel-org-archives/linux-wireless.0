Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAB84AA418
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860723; cv=none; b=AOyDcFFjJL81vpgxjkH7B1fsG5wqXi83jZAoLg6qDkeT2ShSSjPueNBiDjPc46FyAhSMTERExkk3cSydZWhNAiEG4jLxiL8Tnfx32MQjgIyO8IeywRWQXof0j/si8Hd8rtJBYGnK07lFULbH3d32A1oSpWnkQuzMGRBt+Mbt/R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860723; c=relaxed/simple;
	bh=SXLikVkqJlbT/RsnjxbzpOCL0F1CRSv0aO157ZkOw7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=irw88qaW6RPTLBjvUC/c5zrtkk8QHlI4BLuDu3BR5bNjLG5KwyMD4UkLuIovdbFSKk/Igg7Sw7z6p0+dHKklwTqfb5Ro+kuoqk8gt5UWePp4u1thAO/PKAnxSoXQccQlliHBiKo7WTasGb8wK9nS3Yihb0dY4SJQrq3GXMPzkUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WmtgJsEW; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmtgJsEW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860720; x=1822396720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SXLikVkqJlbT/RsnjxbzpOCL0F1CRSv0aO157ZkOw7s=;
  b=WmtgJsEWP75VBzXD7jVTxss36XhRTfryPLKJqSwuhkCK5zc1w7qC21Ej
   KMKrjI8c599CG7pF5/zTDa2ixEZRTFQfdBfhIbztzDWfJo5eLCrDG2ntm
   BgvdR0q0+N/1+AWLNcMlvaE3oTYtqKhXgg8HwN+3H0keePNEjM6XP5C5K
   O7BAawvx2k9WweQJP8xQy1/f6YAjtrPi9CLk2iAdEr3gJPrtwF11m9wb8
   m1dB2zGGCreR9SiyijZfZHSgMdDNkJ0SLJ99hNR5+OTI3IFKZT20PkKpI
   HhHDuImfsWxfpPGRnAWMoeafxjSupAWjNv1N8Je4/XeOoPXALx+8hwZAk
   g==;
X-CSE-ConnectionGUID: ZGMiSFD2SySQeJEOu27Qzw==
X-CSE-MsgGUID: vProRXtRSmyvQSDkvq1Nww==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423625"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423625"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:38 -0700
X-CSE-ConnectionGUID: 4RhHmKiuQMGj8MUS/ogIeg==
X-CSE-MsgGUID: nhD6+zy8ScK56kj/U5AGwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485524"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:38 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: mld: report UHR per-user NSS
Date: Thu,  1 Oct 2026 16:20:18 +0300
Message-Id: <20261001161715.72614c2740f4.I34ad1e61e97e410eae7aa36018876277440da12f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Given that the sniffer only receives a single user's data and
only reports such in radiotap, simply add the NSS value.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index cb3872cb9e56..e59f33c39a57 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1841,6 +1841,7 @@ static void iwl_mld_decode_uhr_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 	if (phy_data->with_data) {
 		uhr->user[0].known |=
 			cpu_to_le32(IEEE80211_RADIOTAP_UHR_USER_KNOWN_MCS |
+				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_NSS |
 				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_2X_LDPC |
 				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_CODING |
 				    IEEE80211_RADIOTAP_UHR_USER_KNOWN_USER_CAPTURED);
@@ -1849,6 +1850,10 @@ static void iwl_mld_decode_uhr_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 			le32_encode_bits(u32_get_bits(rate_n_flags,
 						      RATE_MCS_CODE_MSK),
 					 IEEE80211_RADIOTAP_UHR_USER_INFO_MCS);
+		uhr->user[0].info |=
+			le32_encode_bits(u32_get_bits(rate_n_flags,
+						      RATE_MCS_NSS_MSK),
+					 IEEE80211_RADIOTAP_UHR_USER_INFO_NSS);
 
 		if (phy_data->phy_info & IWL_RX_MPDU_PHY_2X_LDPC)
 			uhr->user[0].info |=
-- 
2.34.1

