Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F55A3F3263
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 11:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164675; cv=none; b=GxrklUEnzNn3pmIQEaAi41jl91f3ySxOIsEO3jnnx3o2hRNRZGed5UUHLNh33ofvkoV+8KqcwfNztI1BR/deceqjA/mdC8eL/tciY6V2IBFiypiiZdN7yBxFor2XqTZZ5kldNghniluOYKa6LqAzvf7rFQ6CQ/I9PdlmBYE8eb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164675; c=relaxed/simple;
	bh=kdO1crdJQ1X4R/rUGQ5XD5P7RMF2Znuwg0K4QZbRQuA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nMB0mBJGhKRARpQR5vpLHybrIdza8gHP6oYwdY125DfgKINkFIZezk0aQBGJWIMa+3vAPLy23Q6wiw/Q3HKcwz4zA5CA/axgh5YJxSs9ffv1Shq4D6k1h4RGhikMoZDNTxRkFJ5Gg3nUQZgQfBOIHgdnlUNB375y50Y9kENr7fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P86olndg; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P86olndg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790164664; x=1821700664;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kdO1crdJQ1X4R/rUGQ5XD5P7RMF2Znuwg0K4QZbRQuA=;
  b=P86olndgS7OAYKLpYW2669VloFaRtPNU42QgVFud+t02EwtxNUyLcaui
   +dhzlqhnWOQO2vQp8/ERwioQWoxh1gjWG85wOyeWX2kO33u4c4dhnd2Um
   uTdej88q2r0OK93rSJ755Kie/tqR7UbkDvCE5Oiusl05OHvxzUPeJZrMI
   AsxVaN6xuYaB8Pw+4TcMP3hda3yBisBK9lioXMmW2ZvTtqlS9QjKXQRDh
   vDRTXG4gGzqcWCySw+JWswp53LAeru6UbprrBT9q+hnaklB1Hz9As/2na
   tUE1AfeUpAp69/+srun8a+PJ7uGiQEdv+6l2Df6amUN4GbAsZIVSNk7Uo
   g==;
X-CSE-ConnectionGUID: RdzsGDFXQlqMARhvV+SWPA==
X-CSE-MsgGUID: P6U9bBr1TBe2vsGBEonChA==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="116373024"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="116373024"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 04:57:37 -0700
X-CSE-ConnectionGUID: 32HJeM1TTEOTvzQsdwfStw==
X-CSE-MsgGUID: A9sdbuFtRrmeZpaFXtubQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="301494879"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 04:57:35 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: radiotap: correct UHR TB U-SIG 1 B20:25
Date: Wed, 23 Sep 2026 14:59:34 +0300
Message-Id: <20260923145929.32cf9cecb4ab.I51027582b573cd43ba533461a2b316559b36b625@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The mask here needs to cover six bits, not just five,
fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/net/ieee80211_radiotap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 733b5128a6df..782c3dcd8b52 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -626,7 +626,7 @@ enum ieee80211_radiotap_uhr_usig_mu {
 
 enum ieee80211_radiotap_uhr_usig_tb {
 	/* USIG-1 */
-	IEEE80211_RADIOTAP_UHR_USIG1_TB_B20_B25_DISREGARD	= 0x0000001f,
+	IEEE80211_RADIOTAP_UHR_USIG1_TB_B20_B25_DISREGARD	= 0x0000003f,
 
 	/* USIG-2 */
 	IEEE80211_RADIOTAP_UHR_USIG2_TB_B0_B1_PPDU_TYPE		= 0x000000c0,
-- 
2.34.1

