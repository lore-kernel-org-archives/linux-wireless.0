Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9764B4887
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790861490; cv=none; b=rdDZsFG19y0yuvqusc2E1kwzjKKBHsltph4uASLgidSghZ8g7bJlQptYkkXx6uq7a+quu3LDMlQRD28gCEDkDMkXvqw1v0rBBP8tSu30nIsGgXL9vN6ZKM8wKX4TaCaWSaaYdZX0yRGrbpz7vjBpfowy2Xi6n1huWZzSJ3oVDzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790861490; c=relaxed/simple;
	bh=1upXUMTiEcn30jZtW8KCb2aJYAY8cXgzyRtAUxodFM4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=geaS767gn98419nv3/0jrWFXv0fMcqRYZ8ALIW+efP+/EG/aSAM9mh9Ek8YrYcj/tlgNojHCLPakQdPgmWajr4ChlEe4OtxxqsNYLPeIvcOYA4MJ+TkhXr0YY8TFEklmBy5gy8qRRdwpIKBcRYY99+/vujR7xo20KW+YJonXG+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OmIlWL0p; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OmIlWL0p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790861486; x=1822397486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1upXUMTiEcn30jZtW8KCb2aJYAY8cXgzyRtAUxodFM4=;
  b=OmIlWL0p3DGT4im9FVRyLNS6X8zR+UJJcoDu5NPCsdF9GBNplMNI2z8K
   i6tKIgtfvgpN/SHsQwHgeMfluJsMMM/aCDfgvEZpN5c1Cn7p4kE6bD777
   T9joO/pmiKR7WcjmEuZ028HrJ7xrx0x+MM1MBJsyESUQCqVIr6C73C3Ol
   bSUsA/45Tqk6JzVF3aUcbBvyO32JRkTRwZ1PqH2URmBrRjIHrAgTst8eV
   wVXQ6dA9TIQjtdU38BlPfXeEHmasleT7lFpkU8L6jHOqsN/hm0YOcLZwG
   K7qKfQ361raFLjNUtIN89qXZWKxFSkYywGG9U0Rkj8ENDoUnhLOn1iKUs
   Q==;
X-CSE-ConnectionGUID: 79HHr+lERc6QBcdduxgS9g==
X-CSE-MsgGUID: 5hZC2U0iRQ2mhHg2fo8tQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="90750532"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="90750532"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:21 -0700
X-CSE-ConnectionGUID: FRxlXmNxSk6wOZfy4tDkGg==
X-CSE-MsgGUID: l+Rzkw2USDmFJohhI0fQdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="26451"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:31:20 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH wireless-next 5/7] wifi: ieee80211: add NAN service ID list attribute definitions
Date: Thu,  1 Oct 2026 16:33:09 +0300
Message-Id: <20261001162941.0f657bc4809c.I18746e32616c09296cfe1f3ac592a5c96c10441a@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
References: <20261001133311.3367683-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

Add the Service ID List and Subscribe Service ID List NAN attribute
IDs. These are needed to filter in NAN beacons during Instant
Communication.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/linux/ieee80211-nan.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ieee80211-nan.h b/include/linux/ieee80211-nan.h
index b332a94671ba..7815a6cf8160 100644
--- a/include/linux/ieee80211-nan.h
+++ b/include/linux/ieee80211-nan.h
@@ -40,6 +40,8 @@
 /* NAN attributes, as defined in Wi-Fi Aware (TM) specification 4.0 Table 42 */
 #define NAN_ATTR_MASTER_INDICATION		0x00
 #define NAN_ATTR_CLUSTER_INFO			0x01
+#define NAN_ATTR_SERVICE_ID_LIST		0x02
+#define NAN_ATTR_SUBSCRIBE_SERVICE_ID_LIST	0x28
 
 struct ieee80211_nan_attr {
 	u8 attr;
-- 
2.34.1

