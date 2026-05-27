Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3428C3B19D0
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 20:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779912334; cv=none; b=jKL8DGG8Phjopv9vMd6eY1Z8roE5AxiCq5UNbhPg2/ZqhNHNssSXBkY6es76BhnHAj1/TuWrVdO0+s6dtK3+RU6yrln7nFO/Cm4f+dpw+ZscO9TSESRKshSUzVRsEV3zOrpG4em50DM2E3EArkHiHJaqwl1kST/mWRcRrp4hmsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779912334; c=relaxed/simple;
	bh=1RJWoWBs8h23R4whuVJ5rNTuw6vLTyad49veAk+GReg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LP5T5D9HPKB5mOpLQ/xEt7vzpJEo0yCSD24c7q8FtE343i1fUsR1BOSYzHbtiYIFDH17i2rV/D+xvuOyRNLvs6uyA4m6mEndTu6N2ssLSMrpwgWgaeJ4XEBs8CxYPefNkbnF0ZpsRW5kTGJsa4+rvAeOcNCJk1ukdb6/fvNE/GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qy/oOxoU; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qy/oOxoU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779912334; x=1811448334;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=1RJWoWBs8h23R4whuVJ5rNTuw6vLTyad49veAk+GReg=;
  b=Qy/oOxoUILSA1gLOnbRcCD4/ylo8aZpHKCmrfmPyfCexzZIXy1bTnq0l
   mVjRsqlYV5nFt4ADfFrDpFpshJGrqIClqSmkOZwEBdCptXbtft1+o1qS+
   6ixPswxMOYXI/NvHYUYIVvNNk49ADvgHGEvgYslsTYna/MjVQHqFMktrv
   EQrTOtfwADzdSeqN7f2Mujq8X6i/ogds6erk6Y02EGbWuHxICLb+MW1FF
   unbB6d32SsMTFEl0vLC/hDpBVG5D0UByrvHABMaLaBE2FxsRAs0l4o4mH
   CWelcvgxIHEG+g2Y1AsvqAJCyEBaOs2GrEjywiqTMt/j19+aEx/+h9hvx
   w==;
X-CSE-ConnectionGUID: 1XXQlHmjRfaXA1NwRs7XJw==
X-CSE-MsgGUID: TKt4ug3dSN+qyHDQXsdLBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80940859"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80940859"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 13:05:33 -0700
X-CSE-ConnectionGUID: 9rgOsbsnTo6oxrPJ6H0iYg==
X-CSE-MsgGUID: kJec5zBZQkCTrTzi6yX8jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="247286952"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 13:05:31 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH iwlwifi-next 04/15] wifi: iwlwifi: mld: fix smatch warning
Date: Wed, 27 May 2026 23:05:01 +0300
Message-Id: <20260527200512.506707-2-miriam.rachel.korenblit@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527200512.506707-1-miriam.rachel.korenblit@intel.com>
References: <20260527200512.506707-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

We dereference the mld_sta pointer before checking for NULL.
But we do check the sta pointer, and sta != NULL means mld_sta != NULL,
so there is no real issue.
Fix it anyway to silence the warning.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index 1e8716cbb4ce..2185dade95f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -563,7 +563,8 @@ iwl_mld_fill_tx_cmd(struct iwl_mld *mld, struct sk_buff *skb,
 	 * - when no sta is given.
 	 * - frames that are sent to an NMI sta, which is only used for management.
 	 */
-	if (unlikely(!sta || mld_sta->vif->type == NL80211_IFTYPE_NAN ||
+	if (unlikely(!sta ||
+		     (mld_sta && mld_sta->vif->type == NL80211_IFTYPE_NAN) ||
 		     info->control.flags & IEEE80211_TX_CTRL_RATE_INJECT)) {
 		flags |= IWL_TX_FLAGS_CMD_RATE;
 		rate_n_flags = iwl_mld_get_tx_rate_n_flags(mld, info, sta,
-- 
2.34.1

