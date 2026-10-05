Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED143921E9
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120376; cv=none; b=Uk6syWO7d8NxzXjnsnr6ftZqzkBPnZ++u0QQ02qadpLdAw63SUQk2AanHjQXYTM9hiwBDAjXj+Nt7ursROQRJYMbN1VBSfrAfaWFvAn6jmXfg4WM7ZGbpHz7klAPjMh56YgRzroHcSXhmvEZ+6mpwwW7aCEQWaC4Ys5aOM7xqNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120376; c=relaxed/simple;
	bh=HAOTAsMmMnsQEZKxKrFUq7TlLDklME9eOOfpyqUihvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfZaqj7PzVP47HG+xQgAA5ErF9oyVR0lnw5BduFQi1X44UZtM2R4TVAykr4zFQYYln9d/KyrxUcOV4VUff+gH88FvykoY6HW4hfDOVtF8Zws4wkHPsAoMDu9UfYBD6YHUg9NgyNPlgVh40IqizEXLkNU5hMpwYDXs15WNVFp4lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OD+Wq1od; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OD+Wq1od"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120375; x=1822656375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HAOTAsMmMnsQEZKxKrFUq7TlLDklME9eOOfpyqUihvA=;
  b=OD+Wq1odgeDBcsBdl1a22FWwz/AjcSrzs6xCspRN/SZLCUSxQbwtsCRu
   RJmKcVjCMRnvl6yJx3ZhKNONj8ATkE4fH51lHYL525SriL++z4ACWsEqb
   o4ju+xOY5uIZ+XPx2RqCC0mW1wNNVIYrL8F6sr6OX5Msj5vlyUzlqB44m
   t6f95CgeLIcZuZIkw6e8GHD7fdKtCyga/tqKAJadBaRkL5Fs3T+89rPKe
   wOiSnKS252tdF7J0z3GitGf1q3uE55qfIeIuFC0bmYSuLfiE0wS0sXwsh
   d/RDyMHulqIPdgzjQEQ2yya/f/Iv1uFEIq59Yn6p6iB1xZoJBPRKz34lw
   Q==;
X-CSE-ConnectionGUID: ESMU/qujRoehEte7PLC7WQ==
X-CSE-MsgGUID: f3XfZ1lWRPyp4eHpT+t2AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328696"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328696"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:14 -0700
X-CSE-ConnectionGUID: KVxIrn1/Qz68r+mq7VeJcA==
X-CSE-MsgGUID: wnlB3TuoQVGUaWgXJCj0zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569124"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:13 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v2 05/11] wifi: mac80211: nan: allow Rx registration for NAN beacons
Date: Mon,  5 Oct 2026 10:40:30 +0300
Message-ID: <20261005074037.3506633-6-ilan.peer@intel.com>
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
let it register for Rx of beacons on a NAN interface.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a59837b9f480..9553ea77cfe8 100644
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

