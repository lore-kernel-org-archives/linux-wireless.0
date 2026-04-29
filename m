Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF92A3EF66B
	for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 11:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777462874; cv=none; b=Ug5sJbLWP/YgOswf0fDbhPy0Xn5rbguYEgDxBneV3KHaHsoMVQWpdQWgA7qijV/mFPfEitEcnbv7ACTK2kU/MBaHVgyr49MrFbzX7ZZUaR0AMhcpetrjAURmwNlVzBzkCwHGH3Ga/yjURgmE1p9+EW3z6snQJzt6ZjHocNjKUgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777462874; c=relaxed/simple;
	bh=miKmvEqEdUIzwoi1c0JPrxhyYgiVCwSSfrMU9+SOb7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KWB1Ek75RelGwb3qBw0mFGV0sxywCOonOh8jGE/Vb8VtGvqmjnzPhtrsBn2iaKviNdFEdPO+yfcyGOR18sdfeb8UzqrdiGDnrBeAHATf9YH6AdD4uRngS0EyksjXrTOkKewQJhqBIPqIk43AuE2euYNPJdLIOJsWYKSxOOD7Z/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bmdn6WY8; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bmdn6WY8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777462874; x=1808998874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=miKmvEqEdUIzwoi1c0JPrxhyYgiVCwSSfrMU9+SOb7o=;
  b=Bmdn6WY8oCEbmmOAKR7lIPIn2qRhQNRS5oYzOYpQjefg/2sEVmEPthob
   kw+3WidYGs3W5ztgcIz+yFKo0oXhztgdTy17rF5OgQSvf3I3Ker/0XLUI
   SFCyh7WJ5ZXs2cAnn/t4ASThTB5Cc2hrTyGJBvIYB3N1e7mY/efybswaU
   h2ZmyiVUDn/+k823jTJMZQth6vg0D+LkoUJgSDZW9y3LOlHR+RXp2vrWg
   gp9Vf9Z8IOtWkmmTW7+bI0iUIii2BncmMahe5zkkAl6snW9TDB1BMI2lL
   JTy2yoVQ+ptXfQl12Q8akbc6rqiI58S33tukLZa1Eiv9JPX/GJEqUFAZY
   g==;
X-CSE-ConnectionGUID: he6ZDsFSSiW8zDEBI8d9wA==
X-CSE-MsgGUID: hSEdgcj6R0KW7NU5MI4X1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11770"; a="88986121"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="88986121"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 04:41:14 -0700
X-CSE-ConnectionGUID: E90FpHX9RHKocVQty9QTNQ==
X-CSE-MsgGUID: vCya6kopRsCsjUeFivy9MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="234505137"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 04:41:12 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH v2 wireless-next 08/15] wifi: mac80211_hwsim: remove unused nan_vif struct member
Date: Wed, 29 Apr 2026 14:40:42 +0300
Message-Id: <20260429143813.b09e2428aa61.I35d3eae582461af7ee25c63c56b13adff17cf20f@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260429114049.4167111-1-miriam.rachel.korenblit@intel.com>
References: <20260429114049.4167111-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

The struct also contains nan_device_vif and that is the member that is
being used.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 1fcf5d0d2e13..7ab0765cb482 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -765,7 +765,6 @@ struct mac80211_hwsim_data {
 	enum nl80211_band nan_curr_dw_band;
 	struct hrtimer nan_timer;
 	bool notify_dw;
-	struct ieee80211_vif *nan_vif;
 };
 
 static const struct rhashtable_params hwsim_rht_params = {
-- 
2.34.1

