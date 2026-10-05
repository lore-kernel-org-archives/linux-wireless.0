Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC74C4534AE
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124223; cv=none; b=Vo5S7U8I09Lle0eN0IaCN2DTXFy0j1yeMhL/4D2me8Q+PuqvQ0jl6avnwH3d6QUpnUjfiEVUFQgH9KcxGuoC2WarAUnckrcgrVVyNgzRFxkNU4pj8G9EjNYHoaf05OyR2OQq7Ec3LJL+wC7gYOG930gzJX4BV0LCujZLDOGO5xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124223; c=relaxed/simple;
	bh=coiTEVXeDxBMzNF8PAapFcUQB2y2KgzPXWQ1QzaHLKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkR8rwHKdl7yph4yWv0xtxcsEETewb45Gd+PHeYpPb5I2BCGu+lI5S+9XLuKJfmMkIexI7WHBxQUxvej13mIbeJzuiAcYBV+TEq/lnvC0MYwg+djXk6ASGJ6ZYEbR2AOS3MfluoRNIF4vphN9e8QtviCa6jt8Uyj3v8a8D4zMCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ekYidYrx; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ekYidYrx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124223; x=1822660223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=coiTEVXeDxBMzNF8PAapFcUQB2y2KgzPXWQ1QzaHLKU=;
  b=ekYidYrxFZeZaOajQSpUVnaf18FxLAbtAbNu3sI4bOFno4gkx0mj3EY4
   oBLo33dUQpbqn4B+Y7Zyh7fGfTJ7Fi0qsaYQJGYLHKnto/Cvy523PuXXY
   N0TWcsRmeJBJGc3EAu5ED0Og1Oow1TdOEJ575NnMibsbhM0HG2bGnIOra
   9QdJqpepGq6S1QcCQlhPlDQGbYrQuIbcN+sDNEbL0fJcen2EKWEDPpn7e
   uRju062ewJ/q8Jx1S1jFYDPnppDvNHov3Et/9YHEzx5HQN71Hilq6XXpH
   RcosPvDuicryU8P6262mWEXY7wUFyiUjigVPCxQxjcGKIAoCs13MXRZXP
   Q==;
X-CSE-ConnectionGUID: uUHLMUrvQHe0xIcJ3Z2Dvg==
X-CSE-MsgGUID: mBSrxf9YSQCHaXBfLP60oQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591434"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591434"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:22 -0700
X-CSE-ConnectionGUID: v+O1jURTS1u3VeDDViQDTg==
X-CSE-MsgGUID: AHJ3G64ISa+rNACwYM8IvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576900"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:20 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v3 07/11] wifi: ieee80211: add NAN service ID list attribute definitions
Date: Mon,  5 Oct 2026 11:44:54 +0300
Message-ID: <20261005084458.3666739-8-ilan.peer@intel.com>
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
2.55.0

