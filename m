Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4334DD3B4
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790168597; cv=none; b=NjRxW5BWpj4Rtpa+5C8pkIsFq3+kBpOqYGDluMLbXKwjP3lUgtyu6478MH4jxQK4NtDkRZrhkNZVu4NIYwNBShxYt5Toii2+EkXtGOIz+cuXB2JRAttYA8arU2W6hREafzcHcdQZV+JELNiDjjHMBK0Cr2QBfQA25zr2gewYgWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790168597; c=relaxed/simple;
	bh=iethINhzF3CJn+cPqns8NjxPn9w+GTr17W5QPd7OcbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lTLz4KyZgXJ8vbmP5lNZiX0UWIUjD/914p6EPGE9VQuJjEFOuUqcWVwQNZj4QjXgcs3ahzNX+h/5aIqpW3HrUoU1p3QwU1WD35eF7unT8ZZ4Xu/Ouqq5bbnlzQ7G8K+JwLeF5t9RiJjR2recVV6+dlCEI2vQ1pUeASExKOkxgEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SsQ/bs12; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SsQ/bs12"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790168594; x=1821704594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iethINhzF3CJn+cPqns8NjxPn9w+GTr17W5QPd7OcbI=;
  b=SsQ/bs12UT7GJ35IjGWDw6TlNo/ui7ScwhMvydykON2YkBzkgQ+kDRL+
   RODJ7DD2MhKNRNSvj5MbtHOO0WN/srK51H72oBPpY7Y9ax5MB5rRGSZXR
   7BjUA2DmuvWSjnEofAMhsRLntw2kNHXpRlrDV0PqqMMsnYCP9vxh9sKhy
   wVYDbBwyKJmc1j25OwyuyaRJJhlLcjnHY6zovZh+79vgoRqx7SO+cxqDD
   XTjrbwc40VjIqfN6en0mPyPbck0YtrdxdXoqWI4IhKpTKawlHMnIE0ZLY
   1ANES4lSlAvRP2Gvz1rTRQJ5vi0UcELhAXuPND8f80+tHf//XPQpO5uRS
   g==;
X-CSE-ConnectionGUID: VEpkW6uzSR6PMPRjud/5WQ==
X-CSE-MsgGUID: lgD75El0Sjmwlx2UNdgChg==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="89781325"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="89781325"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:09 -0700
X-CSE-ConnectionGUID: VX9+PqKVRNOOFhTHvaO9uw==
X-CSE-MsgGUID: JpQfNb+2SNebchFktXNoUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4697045"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 06:03:08 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 06/15] wifi: iwlwifi: mld: correct EHT U-SIG-1 B20:25 report
Date: Wed, 23 Sep 2026 16:04:49 +0300
Message-Id: <20260923160318.e65cdac4424f.I23b05c26fc788081ad8aa2673e104e2215697416@changeid>
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

This needs to be combined from two places, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index 82da642146a7..5f18aa551af5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -818,7 +818,8 @@ static void iwl_mld_decode_eht_usig_tb(struct iwl_mld_rx_phy_data *phy_data,
 	__le32 usig_a2 = phy_data->ntfy->sigs.eht_tb.usig_a2_eht;
 
 	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a1,
-				    OFDM_RX_FRAME_EHT_USIG1_DISREGARD,
+				    OFDM_RX_FRAME_EHT_USIG1_DISREGARD |
+				    OFDM_RX_FRAME_EHT_USIG1_VALIDATE,
 				    IEEE80211_RADIOTAP_EHT_USIG1_TB_B20_B25_DISREGARD);
 	IWL_MLD_ENC_USIG_VALUE_MASK(usig, usig_a2,
 				    OFDM_RX_FRAME_EHT_PPDU_TYPE,
-- 
2.34.1

