Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92833AEF52
	for <linux-wireless@vger.kernel.org>; Sun,  3 May 2026 08:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777798771; cv=none; b=dKMzPfFBZQ1K2nVDHAqRGiLguqMO4gNpTg0TDpP/T8YPqz7NAAzxS1C3lYo3pfli4ap3T8FfTvhDTZ2Gu8GhyC+qvGL+XEwsSLuI5lxTbRRQF/ckF7a6ODl9l9eN9b8fhzSuJojBvw3p3ZSU08O5Sr5qiYidMNxbbbFyEUs/xso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777798771; c=relaxed/simple;
	bh=LLxUu9T6uw2wV340GCpsc7SiUDyV6XxgEEynqCAByWU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JwnI8ZoGyuIwc4s6zwSoWqiJqQxFdbMXKin3W4mShB628ekik/aoz2WDdaCbpLplOVsXIXclBEXqFigTtD0sc84wP45HPFYr5/xm/criJyiaRVnKyvSxkuO2OHB8huzWW1Ra+cya8hpTUQk0d+BAREZYXew1S9mhyLHvlxeP6Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nak/1eyh; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nak/1eyh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777798767; x=1809334767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LLxUu9T6uw2wV340GCpsc7SiUDyV6XxgEEynqCAByWU=;
  b=nak/1eyh0+adDTdCc3Tp12MMvFl3js41iYtv1bJXNMZKh0mGOgRH95or
   xI0UBbNtG/IjLRxwzn29sPNyxkxNXik5mLTx5Y+kSe3KH49x00nmQ+Mja
   5Pwm88vrz3W6EyTuotdvWuQzKEDAIjf/4j4m8pjDHdldIrH4tGweV2Bs+
   V0e9viaqFYzcPoLW4O4uxHM0mFT1DyZ81xznIUWNjaCfF5RYUXM7OVwiQ
   HVgGF9jfnVupsDGHTvR/VcSVDJLp1b4D59ETMiVE42xMb48KRNU2FTtPF
   G8ymrPSyug5wZjW0v017ncgwak3n5mDoNFBmFA5pzTHSlpQZ3HaoxAbOd
   g==;
X-CSE-ConnectionGUID: YH8+Bz+bRy2u291si2gzgA==
X-CSE-MsgGUID: 1GjU5/yFTvioLfwIRc7ZOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="89380398"
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="89380398"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 01:59:26 -0700
X-CSE-ConnectionGUID: yAxu2ZOETUqoo+ycWAH4Sg==
X-CSE-MsgGUID: M6++n4SrTtux1mydT1GQyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="235123788"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 01:59:25 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 wireless-next 04/15] wifi: mac80211: Allow setting MAC address on interface creation
Date: Sun,  3 May 2026 11:58:56 +0300
Message-Id: <20260503115440.d268b245037b.I351e16270c34ee734fed98da25db848211ab7cc2@changeid>
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

From: Ilan Peer <ilan.peer@intel.com>

Allow setting the interface MAC address for NAN Device interfaces
and P2P Device interfaces on interface creation.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/iface.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 95b779c4d627..683d8db4da14 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2280,7 +2280,12 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		sdata->dev = NULL;
 		strscpy(sdata->name, name, IFNAMSIZ);
-		ieee80211_assign_perm_addr(local, wdev->address, type);
+
+		if (is_valid_ether_addr(params->macaddr))
+			memcpy(wdev->address, params->macaddr, ETH_ALEN);
+		else
+			ieee80211_assign_perm_addr(local, wdev->address, type);
+
 		memcpy(sdata->vif.addr, wdev->address, ETH_ALEN);
 		ether_addr_copy(sdata->vif.bss_conf.addr, sdata->vif.addr);
 
-- 
2.34.1

