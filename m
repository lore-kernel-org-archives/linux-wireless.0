Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D0A522689
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168593; cv=none; b=k0KLFR7ydHhWYjLO+evGkG5DoGxU4lQ1oS+kb/OmYqb85UkrsJ8YFZ98SE77mNSdYisU6oj7PZr2/vpU1Dbnfx5gM/KFegFVSa9qUH+mFKMaG1O9r0U1j6A2anoA/tfknI+X/akSMdIjw59yy7qM90OrsHXpLm/1RpaccoIliLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168593; c=relaxed/simple;
	bh=1qxCBtlqLz7E3TAS7tQO90hGBZ7rFSQWtTeBVAR9fdA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bwegRJvv/SNJ/3HvhyZz4mXIrwtKq7HMA4b211yHNG+YgHBUMhVyvukRNa6GDvt0B/K3j4zE9LsIxCQ2+x7Gn52Onl+lATOJ2tZr7u84GseoIA6oDVpEsyMn5bpgHE3pucG45ZP3++dNM7VCBqzNOuGph0YPO3KcWeEdPkO2sfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SwrnSpIq; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SwrnSpIq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168591; x=1821704591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1qxCBtlqLz7E3TAS7tQO90hGBZ7rFSQWtTeBVAR9fdA=;
  b=SwrnSpIqdzzSAze0DmowH4n4dxGu3y7WJre/TLsnFsNtwSzbHB13UyZ5
   X5GWQrOe3mqoW57DWLpts0BlJCJvE7vOami62tFDTtFJFmfQT5Hsz0L+P
   V4icCWf/fu34huVsBHLGOEqC0tdUvWTs4jF+X9RkqjjUrlferCrCvlYQO
   Fq54KSaXYb/aYL2GZYOW5YiSrwoeunS6IcjzAjJJ5q7ib5L/x9Jr2Vk1R
   80AogmERKahovlupMWCNhc6haXtkoG+MuB6ORNRjgEFnPPUBzCRdpdVT9
   FZcgqxYNcPFeHLubRRAKQRjVgIpqiJdqD7KeTegZb8y7Psrk1kp9QgZeR
   w==;
X-CSE-ConnectionGUID: 3oe++lLoRkGcyQ5MmiP41g==
X-CSE-MsgGUID: Uw5UBMxiSHWyHXIceSWr8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781323"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781323"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:08 -0700
X-CSE-ConnectionGUID: /kRcIZgrTfup2a26+z1NBQ==
X-CSE-MsgGUID: eQ8hodQ6TG6ZtITQGFFWTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697028"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:05 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 04/15] wifi: iwlwifi: advertise 2xLDPC RX support for UHR
Date: Wed, 23 Sep 2026 16:04:47 +0300
Message-Id: <20260923160318.9771e88dbc3b.I22693891ed85fd0449ae17106e2502ec4ee2e086@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
References: <20260923130458.164968-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

In UHR, currently supported devices have 2x LDPC support.
Enable the bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 863d5e358152..6bb27d7f1166 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -710,7 +710,8 @@ static const struct ieee80211_sband_iftype_data iwl_iftype_cap[] = {
 			.has_uhr = true,
 			/* Note: asymmetry is fixed later */
 			.phy.cap = cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_RX |
-					       IEEE80211_UHR_PHY_CAP_ELR_TX),
+					       IEEE80211_UHR_PHY_CAP_ELR_TX |
+					       IEEE80211_UHR_PHY_CAP_2XLDPC_RX),
 			.mac.mac_cap = {
 				[0] = IEEE80211_UHR_MAC_CAP0_NPCA_SUPP |
 				      IEEE80211_UHR_MAC_CAP0_DPS_SUPP,
@@ -820,7 +821,8 @@ static const struct ieee80211_sband_iftype_data iwl_iftype_cap[] = {
 			.has_uhr = true,
 			/* Note: asymmetry is fixed later */
 			.phy.cap = cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_RX |
-					       IEEE80211_UHR_PHY_CAP_ELR_TX),
+					       IEEE80211_UHR_PHY_CAP_ELR_TX |
+					       IEEE80211_UHR_PHY_CAP_2XLDPC_RX),
 		},
 	},
 };
-- 
2.34.1

