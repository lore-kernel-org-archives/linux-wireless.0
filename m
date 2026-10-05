Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E9845560C
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124220; cv=none; b=ZXaQPkGiirtdsOaiWwzkY+Ezj0duzACxYJU/4WEbSkfworpyqpiOIJQ5VZOSqhjNY/M4FddUslp078OCtbyHDDi1mlZbPcmEhGYeJBMU6jC1mOEk6+B6FOUA2GF9oU98SwtY2UVvDogpN2VHhWF671L2an5XIuTFfMGqvEZCxvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124220; c=relaxed/simple;
	bh=GaYrvpQrB0N5+2JYEf0XJ0KXmpc+mTyZkPidp2LmuRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yj7ZHtGI7xXp8dRnQbzOfBA4yJusAZRYRwFD+5Udm9QEEMQIIfEwp4bpmwAQ7YWN3SfkLDao1KIeL/7jqTjuCzmYvGxxVLgzFeWA7Q8KxT9OjMwSBRCL/pOwc6KdgbOfUPBcYqRW5IE/qUA+fwUofHY1ZDgk5UFnzJ6sbVY7aOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QdpzyZ5T; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QdpzyZ5T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124220; x=1822660220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GaYrvpQrB0N5+2JYEf0XJ0KXmpc+mTyZkPidp2LmuRE=;
  b=QdpzyZ5TIOybq3wt3ql76iUiVfolcjJ6gnIgwtFAg6TIFWlVqxMnhee2
   IGftktr2SnWWButqbn8jMwFVQ+iJ6eAZLGN3KFBk2NR5hQBWz0qfXHMPU
   iG7fbzgqIVhyPf+naGig1Iewz+mbyclbouMo7VKIa4lMEoyytSSaJtIpk
   OE+m4C1SYThN5qN1GEKEwWlXlNalqiyaL5ICXIeoOo+Yg0UX9j7I4TjLZ
   UnK8t5lwczRTDilfWwnKj9SPdfePPSLz493+d4iMFym0sp/wc0raHpiK/
   ZiPG/HgLmaNkzuE94C50K4uLCQvXCAiivapPNr+7TaAzPzBY2rlWPtHDC
   w==;
X-CSE-ConnectionGUID: uYXafNjFRPOecF4c3qMANQ==
X-CSE-MsgGUID: ZmxcLMqzSHCmbuDTDzAN+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591430"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591430"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:20 -0700
X-CSE-ConnectionGUID: 9U3sC6s1TMqJC1cDzSZl2g==
X-CSE-MsgGUID: G6YW3bgJRfOXu7GOsE+Uwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576890"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:18 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v3 05/11] wifi: mac80211: nan: allow Rx registration for NAN beacons
Date: Mon,  5 Oct 2026 11:44:52 +0300
Message-ID: <20261005084458.3666739-6-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005084458.3666739-1-ilan.peer@intel.com>
References: <20261005084458.3666739-1-ilan.peer@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instant Communication requires user space to track the NAN beacons, so
let it register for Rx of beacons on a NAN interface.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7816395681fa..b889d2a7ef75 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -745,8 +745,13 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 	[NL80211_IFTYPE_NAN] = {
 		.tx = 0xffff,
+		/*
+		 * Beacon Rx registration is needed to let user space handle
+		 * service discovery when Instant Communication is enabled.
+		 */
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
-			BIT(IEEE80211_STYPE_AUTH >> 4),
+			BIT(IEEE80211_STYPE_AUTH >> 4) |
+			BIT(IEEE80211_STYPE_BEACON >> 4),
 	},
 	[NL80211_IFTYPE_NAN_DATA] = {
 		.tx = 0xffff,
-- 
2.55.0

