Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FED4519BF
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 14:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791124222; cv=none; b=FPG/VxE1r7fsdzViG6AEC0me8Y00TSRwk1nx4OCgBlniNtTLGe8EPNw7gFfZz4Q6PkfGTm9b5fdXXz/KXpQYxCk/8K67Zgua08qOYwLlwJoNtrjqw5g/UnmzI1EPvmUADj2PUXVkIKcRQZU1uTiOibSTaGdYvKIg6RuXGWSAhc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791124222; c=relaxed/simple;
	bh=G/hyGOGaFMuTlO/GtXLHQob+nHJsQ6K+7XuuzQ/MTaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erxdiIvt7coX7eee/HUulWsfVh4TnSqF0lreo4evc+qdb8tj1VqMBYGWHoyWVRq56yMWd3+2ra+FTXlNZhsedFbKNqGcpbtscgROrpLSBxsxsbWoQxwPWkmJugkm8Dvw/OsLZ9/4ociirqhCJELl64/3VzozrpJz0uABGhOZmoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OiO9Y2h2; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OiO9Y2h2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791124222; x=1822660222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G/hyGOGaFMuTlO/GtXLHQob+nHJsQ6K+7XuuzQ/MTaw=;
  b=OiO9Y2h2PnLlUpW1L2d1G/Fg1/aoR7mGR+yBpiNJilhCOeJzbYN/AYK7
   t6XHZObJfXE7Eyj1YIWd841hTwoN08a9K6FvdxSZxSmeX8kBKB9r01i8h
   7TW9GHpd+CghupwgArVb+jCtb4e+uTpFAGGSrlCUJUsW9GweNid06re6Y
   W3hQoeZKjYJySVZzM5LuyYd/wV14lzZ9fPrrxcZVM4d50RmI2DQknOL0p
   B2gjt2KbDmmpPSWcJ+A6DGNwFSWzd5EGlBaBYT7l9ywYu+KDiXTq9ydWE
   MRKddJIfd5utP79r3sZ8Eu5HXEBHw52sXztv7/IZIJvotZhsIxdstUORl
   g==;
X-CSE-ConnectionGUID: IUdFtF7rQNyQ6kVqqzIZZw==
X-CSE-MsgGUID: pX9X/GthR+mztlnWGCLKJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="113591432"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="113591432"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 07:30:21 -0700
X-CSE-ConnectionGUID: 59WKC1YAQGCLEjlF6McmEA==
X-CSE-MsgGUID: pcr5jvb2RfudsFS2iER8Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304576894"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 07:30:19 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v3 06/11] wifi: mac80211: accept NAN beacons only when IC is enabled
Date: Mon,  5 Oct 2026 11:44:53 +0300
Message-ID: <20261005084458.3666739-7-ilan.peer@intel.com>
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

Accept NAN beacons in the Rx path only when Instant Communication
(IC) is enabled in the NAN configuration.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/mac80211/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f5893f9c07c6..1121e650b0dd 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4687,7 +4687,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		 * Accept only frames that are addressed to the NAN cluster
 		 * (based on the Cluster ID). From these frames, accept only
 		 *  - public action frames,
-		 *  - authentication frames to the local address, and
+		 *  - authentication frames to the local address,
+		 *  - NAN beacons, when Instant Communication is enabled, and
 		 *  - robust management frames except disassoc.
 		 */
 		if (!ether_addr_equal(sdata->u.nan.conf.cluster_id, hdr->addr3))
@@ -4697,6 +4698,9 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (ieee80211_is_auth(hdr->frame_control) &&
 		    ether_addr_equal(sdata->vif.addr, hdr->addr1))
 			return true;
+		if (ieee80211_is_nan_beacon((struct ieee80211_mgmt *)hdr,
+					    skb->len))
+			return sdata->u.nan.conf.instant_comm;
 		if (!ieee80211_is_disassoc(hdr->frame_control) &&
 		    ieee80211_is_robust_mgmt_frame(skb))
 			return true;
-- 
2.55.0

