Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9013CF1F2;
	Wed, 17 Jun 2026 11:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781695388; cv=none; b=UhZSop11cnC8CJkk8241TPCYvuIKDCWKQAedYyaJZ96QQjcQcB5YH9JkOTn5CYWibM/M6jAZsNHCgJRB/q5Y0pDatedEgkF9grQeCs5Ngk+dQJVmxwXFP93KTxw5J84pG+NoBl7f21Wc1PYvNXeyFYtiqvEEbRUYHO0gHAbnHT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781695388; c=relaxed/simple;
	bh=pS9Yd/+y7lPNyPDfBRK6hqQitRjz8hvumFdISqWJsXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVypwH2O/45pOgmXN9alw3REVhsDluIqx2eSJqr9khuiV99rZSwirCH/r0uXTt6qoYPVSQnwTHCLmquQ/a0i+4/RUlaqoKq3C/xa3RbhHxPY8A3S8xBqLijhAwz7GWarYfgb93889PbydfpbG3Wy7eUMkA9RdPXdOLhZeCL1mx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i1jlWVKB; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i1jlWVKB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781695379; x=1813231379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pS9Yd/+y7lPNyPDfBRK6hqQitRjz8hvumFdISqWJsXU=;
  b=i1jlWVKBxaDbO7OgJub8gVgFvihBccDU2H4Nrm/W6grxkYnpyxWwFbYn
   bPzn9dao74TFXYdy80CYjjQ40y86L1xHmBsxkp55jnQxCa2NlZPIR/xSy
   2adABGjA5zz7x6QcoHSxga35In7BP8WSVzYXllrC4ZopbbRcq3+D/pCVu
   3bZBgtXFcKoMlxL2dwwb4Tei6exNaXaWxB0GNuRiKQd/FQ4iEAw+W/cRc
   f1tPkMKmEsPE/Kmft3YDkKv93HNeepc/fStfuIWreTWpryAMqn6ZR51Cl
   AMmyEqjRqPzz/BUG+maKorkXmI8fQOh4YhEIhvMruQ945uXMWGAHJgf8w
   A==;
X-CSE-ConnectionGUID: Z8HiVNfSRtS9BvlOKaz2IA==
X-CSE-MsgGUID: 4Q69MRtAQMOeRrrUQx9H5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11819"; a="100048619"
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="100048619"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2026 04:22:58 -0700
X-CSE-ConnectionGUID: iTrkh8ZCRvib38V2yztR8A==
X-CSE-MsgGUID: UvSLcVZgQniTRjKhYu5LgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,209,1774335600"; 
   d="scan'208";a="271756532"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa002.fm.intel.com with ESMTP; 17 Jun 2026 04:22:56 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 7F2C799; Wed, 17 Jun 2026 13:22:55 +0200 (CEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Johannes Berg <johannes.berg@intel.com>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 2/2] wifi: nl80211: Call size_add() only once
Date: Wed, 17 Jun 2026 13:12:37 +0200
Message-ID: <20260617112250.2791461-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260617112250.2791461-1-andriy.shevchenko@linux.intel.com>
References: <20260617112250.2791461-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since size_add() may take a few arguments at once, call it only once.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/wireless/nl80211.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 53b4b3f76697..98f92c268944 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11560,13 +11560,10 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 	     attrs[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST]))
 		return ERR_PTR(-EINVAL);
 
-	size = struct_size(request, channels, n_channels);
-	size = size_add(size, array_size(sizeof(*request->ssids), n_ssids));
-	size = size_add(size, array_size(sizeof(*request->match_sets),
-					 n_match_sets));
-	size = size_add(size, array_size(sizeof(*request->scan_plans),
-					 n_plans));
-	size = size_add(size, ie_len);
+	size = size_add(struct_size(request, channels, n_channels), ie_len,
+			array_size(sizeof(*request->ssids), n_ssids),
+			array_size(sizeof(*request->match_sets), n_match_sets),
+			array_size(sizeof(*request->scan_plans), n_plans));
 	request = kzalloc(size, GFP_KERNEL);
 	if (!request)
 		return ERR_PTR(-ENOMEM);
-- 
2.50.1

