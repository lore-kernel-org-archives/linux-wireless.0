Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917694749D8
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246395; cv=none; b=bZygSDvvxdgZIz6BbfT5LyZlgPqIFZqQfMHUlcq01CZPEDHPkFIhCYuknEGhiExDk+/N+U3lyPKNKTHww8Q1hBsbqEbEbFOR9a4p/EkZ4pvflpNfZtk79AKzy69dDb+zn8aIEEspKOzEaXX1BuNQcaHAu7LBmbFnMJ+X8uU7wAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246395; c=relaxed/simple;
	bh=Be9HZyuKyY41mic3pfyqmDm0y03ta51b2PK4gSb1Nhk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FHm00cHF5Yw0L+urQbMUgP+O1aukPsvJivzTBIU3Flhhbwx633/I9F/KVyExWmSoGO/Pg/A7u6C2VvbuYDQ7FEHJakocGEYEd9fUdUko8C1RnjMpgqvDZZFDZ43AiqjuG/lHrBMdKnY90eaiVVn6Dim24dAFspJMtrBdRsMSYjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UXdFTWyB; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UXdFTWyB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790246394; x=1821782394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Be9HZyuKyY41mic3pfyqmDm0y03ta51b2PK4gSb1Nhk=;
  b=UXdFTWyBODF7Q4f11+iKaO1o5xJQAea+IrO2UYI/UsJTmVDrqxJdjDLI
   0jym+Ubz9q0EBxXidrEyfi4KUBZwoc7ecTVtT/XSYsZo0FKWTQGonAwqu
   JkTFVJHXCOnMt1PWMvpvqy/Xqosyexp+9oHq0of7klY01CIOj+IHAD0pt
   dh4THkUbkAq6sw8AQ6gs8kahd61BulDTnIS1uLc/8Y35A9bo0pvXgQdJY
   GOY+qqpYEEjH+eZEwQ815ahiWTCNITIO4cuVn4iIDlrjtttYsNtXcckQ1
   SN+Csvo1B6HE0v6qgXGJTbI6bNQ+9LI5nimvVQ3kRFGFgrRh9mTenpeZO
   w==;
X-CSE-ConnectionGUID: 851LzZdaTtaRvDRlBijkjQ==
X-CSE-MsgGUID: NeHqkmKrSlKRtITXbS4oIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="90134917"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="90134917"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:53 -0700
X-CSE-ConnectionGUID: 4CGBKi/uRGODvpmP8eBP4g==
X-CSE-MsgGUID: uODXy42/RuezG4fzuB7l2A==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 03:39:52 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: disable HE ER mode
Date: Thu, 24 Sep 2026 13:41:29 +0300
Message-Id: <20260924133942.ce2e4278f779.I5dcf9ed88b2b73bc09c81c0d9c841dc624447faf@changeid>
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

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

HE ER mode (~3 Mbps) provides marginal range benefit over legacy rates,
while effective coverage remains constrained by beacon reception. In
addition, ~3 Mbps is insufficient for laptop connectivity.

Furthermore, any range benefit in 5 and 6 GHz is more easily achieved
by roaming to 2.4 GHz, while avoiding degrading 5 and 6 GHz aggregate
network capacity with low-rate links. Therefore, disable HE ER mode.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 6bb27d7f1166..413dd55115f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -612,7 +612,6 @@ static const struct ieee80211_sband_iftype_data iwl_iftype_cap[] = {
 					IEEE80211_HE_PHY_CAP7_POWER_BOOST_FACTOR_SUPP |
 					IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI,
 				.phy_cap_info[8] =
-					IEEE80211_HE_PHY_CAP8_HE_ER_SU_PPDU_4XLTF_AND_08_US_GI |
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_40MHZ_HE_PPDU_IN_2G |
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
 					IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU |
@@ -747,7 +746,6 @@ static const struct ieee80211_sband_iftype_data iwl_iftype_cap[] = {
 				.phy_cap_info[7] =
 					IEEE80211_HE_PHY_CAP7_HE_SU_MU_PPDU_4XLTF_AND_08_US_GI,
 				.phy_cap_info[8] =
-					IEEE80211_HE_PHY_CAP8_HE_ER_SU_PPDU_4XLTF_AND_08_US_GI |
 					IEEE80211_HE_PHY_CAP8_DCM_MAX_RU_242,
 				.phy_cap_info[9] =
 					IEEE80211_HE_PHY_CAP9_TX_1024_QAM_LESS_THAN_242_TONE_RU |
-- 
2.34.1

