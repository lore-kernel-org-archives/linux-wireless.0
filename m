Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD39453A42
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124220; cv=none; b=qyF+vxwBX7s6/qk5IUiap7Ep+MKI8cfmNIltFZzHXDBZOsgYCA55p3ya8FDt97vRDHCx14G1rm16L4bV3zbuBSPWST4TRSAyrrBUoXy1OgBhfgRKDmG3OyTl0i+vzzmMpffuLssRqyD4ZYTv0RDyAwhLAfilxhGarv8E3Z52w08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124220; c=relaxed/simple;
	bh=gBzQQGjVZx51R47XYM8x9nK5LaNSVrWphrc9ILaRUZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeT1aKAcsZ6PKnrPS534UVHWOH2qR9jkXm0cC7zIDRVy1FvMLDL985OX6mwROnZYRyNzCrTEbVqUG/YWjXXFcW+V8dOSqEn6ZBhdnuLjQT85EhTAn3oq8r2IkkfnTNiLlZ0ui7EH5gz6FB52GwNPBFbvkB2FBEHES4DHOOlWG7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GuHybKAt; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GuHybKAt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124217; x=1822660217;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gBzQQGjVZx51R47XYM8x9nK5LaNSVrWphrc9ILaRUZY=;
  b=GuHybKAtrRrmgUPUz3MXH4b9T56rkU88XKd1a1XXoTk9zeeW+YFNHlUg
   yYwWJzEn0iWxF2ZNs2a7jJhp/EOJm/UgJZAAHIcwsnKnxeFAHMyDlmY32
   MHVvZ/FzLDRaf823NKYus8L+jhu+OfXWbb010aI18jthpVCJINT4WSJgD
   m6ZPkGChCclib72lNzAw76Wmm9qXZwPYAbl9aOZ3PzEDHNvWv9SUbhgTh
   GUFdkLz/IYraf6hy4kYF6SUG87yP9ZjcUx9qI5cYgOIKzvZs14/ET6hW9
   qJ8R2eOeOVRtSCjjmJNSmIdVRWCrn/6eCgi8Zo6WC8Ugr/WrWqjCp36ud
   A==;
X-CSE-ConnectionGUID: WHo3mMbkT9S8zQDy7pkg0Q==
X-CSE-MsgGUID: FnFLLtdzRU+0/a1OMh2kFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591424"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591424"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:17 -0700
X-CSE-ConnectionGUID: eu0eCrsNRqiLFUtd+v6m7A==
X-CSE-MsgGUID: gSaY3qrdScyRxSDAJ7TEQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576883"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:15 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v3 03/11] wifi: cfg80211: nan: check Rx registration for NAN beacons
Date: Mon,  5 Oct 2026 11:44:50 +0300
Message-ID: <20261005084458.3666739-4-ilan.peer@intel.com>
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
fail device registration when the device declares NAN Device support
for Instant Communication but doesn't support Rx registration for
beacon frames.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9176659345f0..45a1709cffe7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -969,6 +969,13 @@ int wiphy_register(struct wiphy *wiphy)
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

