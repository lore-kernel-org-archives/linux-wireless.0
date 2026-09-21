Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110A139A04A
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 19:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018929; cv=none; b=Zs1SsCPXeJB/E9TfbrFvL0A5FAZ2upSEYbSKrExeJHOvg0YpfopaQsQ5m8VrUTYpFSyTTb/v9feOe/jSjRtJhcvS9V1R5RL6nBVeuM8XGKzFhAFqT4mfcm4Dyw4CVVkUbVwZlpdBND/rPGrJOJ+WYKowiL2o4xX8h/xs9iF/+mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018929; c=relaxed/simple;
	bh=4kQw9/OfsCZOeP+w1B4lzcJ+8YOfX44tfHK35dOGEyk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fqerIALVUgEkLHMlmoo18ADDZyC3vFRyxfHmBubBxKYHYzn0FMREHppf8/NKPWnlMVPIe7ljpNjspaY0OdXTIYeVM/zAU1jjeQandfucGNRgvf4E7fEMhna3Qa+toRy90AoCBoZwdYg19zI0A0S8rjVaeYz36B2GcjQuNhttI+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I1XDwk6T; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I1XDwk6T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790018923; x=1821554923;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4kQw9/OfsCZOeP+w1B4lzcJ+8YOfX44tfHK35dOGEyk=;
  b=I1XDwk6TLUgOffBywi6MHBRLG3ybFc0quyomiHDjePpRM471+ycwLM9i
   w+iPDmEgK2fEaDY4LvsRo+yGJSf2qD/hNDe0+qkeENFF/Fg11yvr0DX4f
   1IJ88rs1NWyvXRjV3IF8FWdxWtf/a4gbzmI7NQnMkTI4YdmllxtsHnACG
   FpSKH9avCJFLb3YjvV1GBAT0m+50Xjh9xaSZoHeYMEhiwtCMsUMje8iIB
   /bjJjkBhAPtrcly5sraqZABIZyv44pQtK2MxXvvrFDYeJZ1U1gVz5OR9A
   6ScJvrDXg8RpCxTN37LCniJ5uYbql/xnDJzmVK1M98o1JhmBZ1A+Nygmw
   A==;
X-CSE-ConnectionGUID: Q5+CzBQSS3m82fXdtJ4Wsg==
X-CSE-MsgGUID: Ap6yozHpSSOGRbwr5X0WcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78121532"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78121532"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 12:28:41 -0700
X-CSE-ConnectionGUID: EGZZWh3cTj29SfyXX+43hg==
X-CSE-MsgGUID: Cqhc+hICSSCwAtrEMfNyJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="271317442"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 12:28:39 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: radiotap: add definitions for UHR U-SIG
Date: Mon, 21 Sep 2026 22:30:38 +0300
Message-Id: <20260921223016.8f871c68a709.I1cdbb85ac81e33fb84548e8679b78ee1cd1db6c4@changeid>
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

There are three different formats for MU, TB and ELR, add the
necessary definitions for them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/net/ieee80211_radiotap.h | 45 +++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index ffdfbade25b8..733b5128a6df 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2017		Intel Deutschland GmbH
- * Copyright (c) 2018-2019, 2021-2022, 2025 Intel Corporation
+ * Copyright (c) 2018-2019, 2021-2022, 2025-2026 Intel Corporation
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -608,6 +608,49 @@ enum ieee80211_radiotap_eht_usig_tb {
 	IEEE80211_RADIOTAP_EHT_USIG2_TB_B20_B25_TAIL		= 0xfc000000,
 };
 
+enum ieee80211_radiotap_uhr_usig_mu {
+	/* USIG-1 */
+	IEEE80211_RADIOTAP_UHR_USIG1_MU_BSS_COLOR_2		= 0x0000003f,
+	IEEE80211_RADIOTAP_UHR_USIG1_MU_B20_B24_DISREGARD	= 0x0000001f,
+	IEEE80211_RADIOTAP_UHR_USIG1_MU_B25_VALIDATE		= 0x00000020,
+	/* USIG-2 */
+	IEEE80211_RADIOTAP_UHR_USIG2_MU_B0_B1_PPDU_TYPE		= 0x000000c0,
+	IEEE80211_RADIOTAP_UHR_USIG2_MU_B2_COBF_COSR		= 0x00000100,
+	IEEE80211_RADIOTAP_UHR_USIG2_MU_B3_B7_PUNCTURED_INFO	= 0x00003e00,
+	IEEE80211_RADIOTAP_UHR_USIG2_MU_B8_VALIDATE		= 0x00004000,
+	IEEE80211_RADIOTAP_UHR_USIG2_MU_B9_B10_SIG_MCS		= 0x00018000,
+	IEEE80211_RADIOTAP_UHR_USIG2_MU_B11_B15_UHR_SIG_SYMBOLS	= 0x003e0000,
+	IEEE80211_RADIOTAP_UHR_USIG2_MU_B16_B19_CRC		= 0x03c00000,
+	IEEE80211_RADIOTAP_UHR_USIG2_MU_B20_B25_TAIL		= 0xfc000000,
+};
+
+enum ieee80211_radiotap_uhr_usig_tb {
+	/* USIG-1 */
+	IEEE80211_RADIOTAP_UHR_USIG1_TB_B20_B25_DISREGARD	= 0x0000001f,
+
+	/* USIG-2 */
+	IEEE80211_RADIOTAP_UHR_USIG2_TB_B0_B1_PPDU_TYPE		= 0x000000c0,
+	IEEE80211_RADIOTAP_UHR_USIG2_TB_B2_VALIDATE		= 0x00000100,
+	IEEE80211_RADIOTAP_UHR_USIG2_TB_B3_B6_SPATIAL_REUSE_1	= 0x00001e00,
+	IEEE80211_RADIOTAP_UHR_USIG2_TB_B7_B10_SPATIAL_REUSE_2	= 0x0001e000,
+	IEEE80211_RADIOTAP_UHR_USIG2_TB_B11_B15_DISREGARD	= 0x003e0000,
+	IEEE80211_RADIOTAP_UHR_USIG2_TB_B16_B19_CRC		= 0x03c00000,
+	IEEE80211_RADIOTAP_UHR_USIG2_TB_B20_B25_TAIL		= 0xfc000000,
+};
+
+enum ieee80211_radiotap_uhr_usig_elr {
+	/* USIG-1 */
+	IEEE80211_RADIOTAP_UHR_USIG1_ELR_B20_B24_DISREGARD	= 0x0000001f,
+	IEEE80211_RADIOTAP_UHR_USIG1_ELR_B25_VALIDATE		= 0x00000020,
+
+	/* USIG-2 */
+	IEEE80211_RADIOTAP_UHR_USIG2_ELR_B0_B1_PPDU_TYPE	= 0x000000c0,
+	IEEE80211_RADIOTAP_UHR_USIG2_ELR_B2_B12_STA_ID		= 0x0007ff00,
+	IEEE80211_RADIOTAP_UHR_USIG2_ELR_B13_B15_VALIDATE	= 0x00380000,
+	IEEE80211_RADIOTAP_UHR_USIG2_ELR_B16_B19_CRC		= 0x03c00000,
+	IEEE80211_RADIOTAP_UHR_USIG2_ELR_B20_B25_TAIL		= 0xfc000000,
+};
+
 /*
  * ieee80211_radiotap_uhr_elr - content of UHR-ELR TLV (type 37)
  * see https://www.radiotap.org/fields/UHR-ELR for details
-- 
2.34.1

