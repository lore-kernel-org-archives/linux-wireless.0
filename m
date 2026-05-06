Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AC42E1EFC
	for <linux-wireless@vger.kernel.org>; Wed,  6 May 2026 03:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778039103; cv=none; b=Azm79EgfwEpuFGvHVPOMeVB9lUKDoHfYfxIDe/u5m0ZYsCzjyl8xKHAnCxAB3n/y7pjAWLscBaXwJsWg07AL80xWMPYn4ev/HKtGF93oVsC7k4RAuqkx4xdntLKm+rJ8FiPMpFQXSsx70UGF49pECu2jfooMtS7I43CQk6fIrBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778039103; c=relaxed/simple;
	bh=Tr/Bsjw6MLJDGuXQvBc/wnsfzNApCDid7MPEKTS378Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IeKdnkRRUmU8AC+mDLAAA0RCQ2d00S7PCdm1TMV36Qlergvbq6pdK0iz6wcxMVoVQ2rqTXzAwatvIFNUXWzaBEHwY7GIUTTJpYIwooXR2KWw8qhkWN2QCzngcqy957joZOvQESak/8U6r3WI3N0+UBKpCMi5byNd0ECdw1a6qk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WqLpg3fx; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WqLpg3fx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778039102; x=1809575102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tr/Bsjw6MLJDGuXQvBc/wnsfzNApCDid7MPEKTS378Y=;
  b=WqLpg3fxdTBncpr4bWm76Po7Sp6N9bCqz0d8BZM0sV2mTxmUpjFjwN74
   Jj8lLIBiTwbz3aOApzt7JxxVQBNMSwmTrieEfrhl1tw8YMawmGVxtuE//
   jxByDLw1HXI6sDReESVr+AVZmMgGuHnJMAv9oYr6ug/4CCdA90VSuvge4
   FkTtodCptUS8ciL50Qt9EJSbVlhIW2tJVne8EV1KJZv81jQz34P6h79JY
   puyIUDcFRBoeVaXe7p9XEIv4p1XjemiBGqXpVUK/ExipAvxwvf49i8Kb7
   nFL2Vv5LKa6l2EYNg7VGXdHai2J6vTg00vrrRf3Hy6ytdlS8KzRXm49L5
   g==;
X-CSE-ConnectionGUID: /zoFnNSHQfeeckbueRQe4Q==
X-CSE-MsgGUID: uJYvpSZ9TcyI7Bu2ZW4PvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="82791303"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="82791303"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:45:02 -0700
X-CSE-ConnectionGUID: 0WC0/ZJTS5GRff7CsH/20A==
X-CSE-MsgGUID: NTWtaQ1vRXSK2sPkQ1TB3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="237777857"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:45:01 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Daniel Gabay <daniel.gabay@intel.com>
Subject: [PATCH v2 wireless-next 12/14] wifi: mac80211_hwsim: enable NAN_DATA interface simulation support
Date: Wed,  6 May 2026 06:44:31 +0300
Message-Id: <20260506064301.d4bd95959bfa.I450087714bd55189242ab6a72ce6650be36edbcb@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506034433.3328362-1-miriam.rachel.korenblit@intel.com>
References: <20260506034433.3328362-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Daniel Gabay <daniel.gabay@intel.com>

Enable NAN_DATA interface simulation support by adding it to the
supported interface types. This completes the NAN Data Path
simulation introduced in the previous patches.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 2b228ae3029a..bf45d48a3fe0 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -6765,12 +6765,9 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		param.p2p_device = true;
 	}
 
-	/* ensure both flag and iftype support is honored */
-	if (param.nan_device ||
-	    param.iftypes & BIT(NL80211_IFTYPE_NAN)) {
-		param.iftypes |= BIT(NL80211_IFTYPE_NAN);
-		param.nan_device = true;
-	}
+	if (param.nan_device)
+		param.iftypes |= BIT(NL80211_IFTYPE_NAN) |
+				 BIT(NL80211_IFTYPE_NAN_DATA);
 
 	if (info->attrs[HWSIM_ATTR_CIPHER_SUPPORT]) {
 		u32 len = nla_len(info->attrs[HWSIM_ATTR_CIPHER_SUPPORT]);
-- 
2.34.1

