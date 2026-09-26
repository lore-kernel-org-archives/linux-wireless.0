Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFBC36C9CC
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 17:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790442960; cv=none; b=k347INlexYKCVuxfhuJbwd5o7a8nAMDBnPth/ws6/vSOwNzIHsjtII06QPFE1Dz7R7YPsOerNUtFs4puwpHkBJphvJhhGt2dY4Y57bYOGguOnNgYbqIOXyoHUk2EU8A+1byaP8Uksk8xRvCyABIvJyBueA5Hvti+XBkFU88Gp5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790442960; c=relaxed/simple;
	bh=Be9HZyuKyY41mic3pfyqmDm0y03ta51b2PK4gSb1Nhk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oz65RVEIF2LgpU4aOErZClGRSwsYkQLc8dhrFv45owT6nbfJqSDNixe7injKZ2743PXUXENuEEAqBMkHka84fV8cIgMFWG1xZSAY9dYUwWnIdUnyA8zH12fwnJziTtgiPBzvp5aAqFQzbi1LLk+zj9t4hF5RRSsOIFST8jkmMOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Is8BsNaN; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Is8BsNaN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790442959; x=1821978959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Be9HZyuKyY41mic3pfyqmDm0y03ta51b2PK4gSb1Nhk=;
  b=Is8BsNaNsl80YAcg5uJExf3DHrB8is1WKWjtGQRcoUAtsR9HufBa9RQk
   5p+JliV5w0tuVWEgoPIwLT8ZyXd1nv7m4Jasu4BYkdHjjTwrfryrvFRnz
   +mUEcYwEHhskbXDJmDCMiArRto3eD11O8Ac4mB97TWpYGMGEkamgICxw6
   t8pCq/QRJkzcYBKn2KoMM131Z7irWcQuk9zVbDpRRF2jmNd0P/8AAiGq8
   vi3KQ3kW+9P79tTVkOxOEMq1Pp7s93MU/lYUto+UEKEo75juY6OmZ0PtV
   dDZnFD0POXI9sw3hhgvSuq+mpW5ysnQtXEJsjwz55nihMTYJbdXxxV17T
   Q==;
X-CSE-ConnectionGUID: JMp7kkOrQkmnqfvRPoYkPw==
X-CSE-MsgGUID: TCflxuA0Rz+od6X3iF5Z9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="100533304"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="100533304"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:59 -0700
X-CSE-ConnectionGUID: Ee3DBW3eTBCyN4p2o4lFFg==
X-CSE-MsgGUID: 7vP8I3HZSim0z80gCGbh2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="274197036"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 10:15:58 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH v2 iwlwifi-next 15/15] wifi: iwlwifi: disable HE ER mode
Date: Sat, 26 Sep 2026 20:17:34 +0300
Message-Id: <20260926201527.aac48f46b60e.I5dcf9ed88b2b73bc09c81c0d9c841dc624447faf@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
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

