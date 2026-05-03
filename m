Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140A43B0AC7
	for <linux-wireless@vger.kernel.org>; Sun,  3 May 2026 08:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798771; cv=none; b=Kfv75A4prpMbKPwiNpO42l+tRG1hYExJdP5sfAYa6+TPMv20DAZdNs9LJsW8tV1M8MMJ5OfbaPk6/h/obdsRuv/EwXG/9T6uWn62QFNED0+cZtpivc8+9bP/86Ffw2EjyKzjlF17s1lVSNIcEezPFs/RQdsPVBsLOSkC/qGcaUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798771; c=relaxed/simple;
	bh=ywvEHQH1LKhefXukMDwkR3KBPTdE8zvRCasjF/R3d4Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e2PKkaIBGp20SnrEb5R7r7NTQg+v7s8pCPeqqrpt3XdNMWARbcb1nkIYNaxPv//jDAKR6a6w8j3gmgVuZk72tgm7MUhzYsPlds/xza64537s2o1fZ98lyx4XJORloYl4tGlxZZZx6oDumFFdUqM8Qks4FpbdIVOg7huuZFaTkr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=frPjV58A; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="frPjV58A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777798769; x=1809334769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ywvEHQH1LKhefXukMDwkR3KBPTdE8zvRCasjF/R3d4Y=;
  b=frPjV58AksE2Ka7gT9QbcExwhYs8Ufx0qGHM6BG/Uttjkik627lSYD3V
   h+zNZMLnvmm0Okp4Ln11l59HiEVbcjfzc9zJ+bjn5UAgOqN6auyhQzWVL
   FTQTTK5NtzqNhFdUCnVo+ADpB3BheL1NNhVhlPnfgZkO5vsBCfFiDdaVh
   FLJwazR/3ESZibtlor8GFWa+WXSXrSXANxjnFGEcNHRCbt7s7R7P5tOdy
   6sqSowGSttn+Rp/ByLXIh+0uSSmv+N8V7E6FTFJLzH/NCWqz+jp31kfyK
   ZRo38ygTKEG/Tkbs2doLLH2yplu2MMj+K4fXmNKnyvyfFeQBqdB+tcScX
   Q==;
X-CSE-ConnectionGUID: VLp4ti2SQBqN4lQlqHaoJw==
X-CSE-MsgGUID: m1msI0gFQEqg07ZrlSNEOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="89380402"
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="89380402"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 01:59:28 -0700
X-CSE-ConnectionGUID: biT0N01nQxeMbkktPKwgXA==
X-CSE-MsgGUID: 2TsNMIhAS8WRqrmLt1J0bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="235123794"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 01:59:27 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 wireless-next 06/15] wifi: mac80211: avoid out-of-bounds access in monitor
Date: Sun,  3 May 2026 11:58:58 +0300
Message-Id: <20260503115440.346c9893d136.I15919027597c04ec35c6217db6e52e2a605e5cfc@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260503085907.257378-1-miriam.rachel.korenblit@intel.com>
References: <20260503085907.257378-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

In NAN, we don't know on what band the frame will be sent. Therefore we
set info->band to NUM_NL80211_BANDS. However, this leads to out-of-bound
access in ieee80211_add_tx_radiotap_header when we try to access the
sbands array.

Fix it by not accessing the array if the band is NUM_NL80211_BANDS.
This means that we will not report rate info for legacy rate in NAN.
But nobody really cares about it.

Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/status.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4b38aa0e902a..8716eda8317d 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2008-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2021-2025  Intel Corporation
+ * Copyright 2021-2026  Intel Corporation
  */
 
 #include <linux/export.h>
@@ -295,9 +295,10 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 						 RATE_INFO_FLAGS_VHT_MCS |
 						 RATE_INFO_FLAGS_HE_MCS)))
 			legacy_rate = status_rate->rate_idx.legacy;
-	} else if (info->status.rates[0].idx >= 0 &&
-		 !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
-						  IEEE80211_TX_RC_VHT_MCS))) {
+	} else if (info->band < NUM_NL80211_BANDS &&
+		   info->status.rates[0].idx >= 0 &&
+		   !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
+						    IEEE80211_TX_RC_VHT_MCS))) {
 		struct ieee80211_supported_band *sband;
 
 		sband = local->hw.wiphy->bands[info->band];
-- 
2.34.1

