Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AB44FD795
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860725; cv=none; b=ccGZUbXQFCcspyluYsV2iog0YBPJcW1VXl/oSmUz/Yhxfsqkx6elADr5EftfJqSCNNM6q/DcG3KnO25llXuQxm9kosY6q7BN9eP6x9U38hcRbSgK0YJCAqkNIaX7bxMQJyD/wgZzazrQNbqg3kMhCQXT9J7sOQe6TLRixpjEDRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860725; c=relaxed/simple;
	bh=U1rB4WS/dAVVQAMDhRyEEaH96xcwhHwQAGozPOhK9vE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KABp8UJqxxjdZ1PB2uO2hp1ihuFHoNSAnazgs1MnDvyPi6v2Cg1xz5Ua9E6bMzvhCUAynRMAfFp117C8eFBrgtWj8G6mRqh8FqMFtG856AiKdD2My0s4Tw6HOl7C/u9r0tBvDAzdTDUVMIv+VKuWlA05yk+yvS53w/wmdUiLsrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NXzw2DVD; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NXzw2DVD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860723; x=1822396723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U1rB4WS/dAVVQAMDhRyEEaH96xcwhHwQAGozPOhK9vE=;
  b=NXzw2DVDEyhJhaYaU6RUuIWe5Po3eSsD18/sRJEiwPsJfRoddoo7MuEO
   XufA9VV/zfKSZbKgAdxM9NaxciobFO0Xq+TEh8M4N6wyWZ87zelt5gycl
   BFXuAoYfPP5A0fBDK//ErnrdxzvwmZdVEUW6fGMxL+hP1W+POBkZPalMT
   XHqIdoI4EOj3aQYjhIEy8z5gE4vuFzvV6BYELOvDTTTwhj+Wkonnct2Px
   oYN/p+4/R7Y14dS5ONRqHNOX86JMrD2OFZC2KUzXD6And9hqRMTv20H/p
   VafS+r5IXs7iW0sFHZptEos7PL+Lj16Coch4BKA4mKpPmvVvg3sFQ0vZH
   A==;
X-CSE-ConnectionGUID: 7Q3slO/NQHubWZv2drX5HQ==
X-CSE-MsgGUID: M6SMolMtTGGLi++20/FSdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423632"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423632"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:42 -0700
X-CSE-ConnectionGUID: sIR5jc8qQAmUfNc+smgp2w==
X-CSE-MsgGUID: FNYPAIxUS0a05TTk9NK93Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485539"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:42 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 08/15] wifi: iwlwifi: mld: remove UHR TB U-SIG2 B2 validate bit
Date: Thu,  1 Oct 2026 16:20:21 +0300
Message-Id: <20261001161715.56c9dd83eb39.I4482c69e48aa4661d11aecc23aab03fb9fef5ead@changeid>
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

Clearly the existing code is wrong. Since it's not clear that
the value is reported by hardware, and we probably won't need
it, remove it for now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 60d653b5b755..076c4fd6f37c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1354,9 +1354,6 @@ static void iwl_mld_decode_uhr_usig_tb(struct iwl_mld_rx_phy_data *phy_data,
 	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
 				    OFDM_RX_FRAME_UHR_PPDU_TYPE,
 				    IEEE80211_RADIOTAP_UHR_USIG2_TB_B0_B1_PPDU_TYPE);
-	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
-				    IEEE80211_RADIOTAP_UHR_USIG2_MU_B2_COBF_COSR,
-				    IEEE80211_RADIOTAP_UHR_USIG2_TB_B2_VALIDATE);
 	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
 				    OFDM_RX_FRAME_UHR_TRIG_SPATIAL_REUSE_1,
 				    IEEE80211_RADIOTAP_UHR_USIG2_TB_B3_B6_SPATIAL_REUSE_1);
-- 
2.34.1

