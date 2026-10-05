Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94636391832
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120374; cv=none; b=q/S+Fp0E31SHBdACIwLBfyhxfzSM9Ch7NnmKtE+MvzNrAG0sGvQFHEKeWWCsMxBZDr4gu0BcZpdaDm3GiWS87DXwrfWl72FaKM/H0uHmPjzCzZcZFmHwf09U96UbEufGsMvzlYI5yXOVjKHjYIzLNyRT7SHUM2efSdKM0N1W30Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120374; c=relaxed/simple;
	bh=mmucttl371VW8eOkmUcWvtpTLBHzKa4P2/CoCI3g53Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaVz6nwfSkEKv9vh2Peov6NfRUcF2jYnsMkCxWW9bbF9Rzn2WJJpJLonTWSrEObwRc1sVDzI+D5AidHP56B8SNVF69XFpIjCIW+WV8U5Q10MSoRryEXdWzhERu5sOdX9t665W4yoqCax948da6QCT1TJabW0uRgbU5OSy5FeJMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h5NGKyW1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h5NGKyW1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120372; x=1822656372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mmucttl371VW8eOkmUcWvtpTLBHzKa4P2/CoCI3g53Q=;
  b=h5NGKyW1pzki7JSKzaV2iqxCPT3V4s1AUwf9ZD8g0mNFUb5g4mP7XjbP
   N3DdwZGAeVVEOhdOX9Mrj7GLA6y9cTHxAitWbhpYLOH0hJNNjauu0adCZ
   TWt3nhI7SqBWbmkWVo98q5/bAclefl7qaoz2VQo4bUeVlj6bIoqeSuCeO
   gp2U4SJtqKTSqaYC72gW8LzjtKJlPN04Mi3c1zU17hV5zbxrNKSefy42K
   yZa3xruhDK0EjesfDT68v95977tUMrI+XMuZ/8fYg7Q5izKUV697BiyzF
   5s0jpO8gr/P5i3shdEhdCizUQcNes4nhL/H1uDLbXxYGNMQ3BDPgWKWKB
   g==;
X-CSE-ConnectionGUID: HdUuhVHOT6Kk0Yb2U1BfMg==
X-CSE-MsgGUID: P2GcSZtCSKCR7iVyr7ofTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328692"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328692"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:12 -0700
X-CSE-ConnectionGUID: PDmuUdXtRb6h0Ez1qRxBCA==
X-CSE-MsgGUID: hWk1vdp9REqF26DRLiwduQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569110"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:10 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v2 03/11] wifi: cfg80211: nan: check Rx registration for NAN beacons
Date: Mon,  5 Oct 2026 10:40:28 +0300
Message-ID: <20261005074037.3506633-4-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005074037.3506633-1-ilan.peer@intel.com>
References: <20261005074037.3506633-1-ilan.peer@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instant Communication requires user space to track the NAN beacons, so
fail device registration when the device declares NAN Device support
for Instant Communication but doesn't support Rx registration for
beacon frames.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 068db5de24f3..fc9b97888191 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -893,6 +893,13 @@ int wiphy_register(struct wiphy *wiphy)
 		      WIPHY_NAN_FLAGS_CONFIGURABLE_SYNC)))
 		return -EINVAL;
 
+	/* Instant Communication requires user space to track NAN beacons */
+	if (WARN_ON((wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_INSTANT_COMM) &&
+		    (!wiphy->mgmt_stypes ||
+		     !(wiphy->mgmt_stypes[NL80211_IFTYPE_NAN].rx &
+		       BIT(IEEE80211_STYPE_BEACON >> 4)))))
+		return -EINVAL;
+
 	if (WARN_ON(wiphy->interface_modes & BIT(NL80211_IFTYPE_WDS)))
 		return -EINVAL;
 
-- 
2.55.0

