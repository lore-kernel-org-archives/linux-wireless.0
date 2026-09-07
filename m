Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11D551D53D
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 17:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801921; cv=none; b=aK4raucCwRX24UZqJd6GFyV0dadffF7bXEZRqJU92kjMdrk4IcxE25z2Vfc668t3XmDMaP/0SLw+3RFIjDfSgvDXODq/QjjXDJ18MTA2+wHn2KPPssIYoEuVgLPZoS+mIPdnG7BumOrOdk9KewQoPGU0jhP+1xUs4j0ihhVu6XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801921; c=relaxed/simple;
	bh=O4LYEL/R50Nj8g+F/HZ7n+25liL9Tc+YoiVCvFj8ne0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oa92smmh74nw7iJjHIaSUnRn5t0zCRoVKpIZllwxrv4gOaOkLRLGmmEfNbyxDr4YsRbHmRGghPg7iyryyLGVCqxN2xzUDhhf0xHkzuDH2WPZ15pO3dXO80MIyFzw/p21STT7Ucvv/rixYGHVgkIPVhANW8wdS5GMnhXPlvV8KD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJoVqQk3; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJoVqQk3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788801920; x=1820337920;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O4LYEL/R50Nj8g+F/HZ7n+25liL9Tc+YoiVCvFj8ne0=;
  b=EJoVqQk3U9Ckp272pyrAs78gTHSULW0xFoyDPIkJi5321efQOrGqQioB
   3o48ZMGm4ICmEWxh1AbbbWd69vTZ+o/drlTz5D5x7NG7kEOHHaQY4VF2B
   jvteqo6HHgnkzI+vz68d3QZF6je1GrwuyPHNJL33tDmPJxFZ2njjJV86S
   +MxCKHWgtSPSpz8YPaxy7HOFrrlhD7IV051mWYejkTryE/g5p3/aicjTX
   OQdBwSxT8WnBdFDNwmj0QRsYwYM0opErP6W4XevUeQuM9qjb/ShjZBJui
   5npc80IVDntb6pgLlHoe1b9Bk4zFb7gOahBNHKwWJaY42rBM0hllgrdHs
   g==;
X-CSE-ConnectionGUID: BwiqwEQVTXeEb2pgxJME5A==
X-CSE-MsgGUID: aHIA32VdSd6NySdrGvEFmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="89239763"
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="89239763"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:25:19 -0700
X-CSE-ConnectionGUID: kXcO6w/BTcKfhmxYJCoVtQ==
X-CSE-MsgGUID: x9pZRQVrSWue8Lh9HArzfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="270740036"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:25:18 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless] wifi: cfg80211: fix NAN regulatory enforcement
Date: Mon,  7 Sep 2026 20:27:19 +0300
Message-Id: <20260907202714.43a3b3f06074.Ib90696e3fa49b1698c27d64db5360d51f6f187a9@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

reg_wdev_chan_valid() returns early for any wdev that has no netdev,
which is fine for P2P originally (and later PD still), but NAN has
no netdev and yet enforcement code was added and is needed, but is
dead code right now.

Use wdev_running() instead so that netdev-less wdevs aren't skipped.
P2P/PD don't do anything in the later switch, but NAN code can now
be reached.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1e8214d6b6d8..3454afa038bf 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2345,7 +2345,7 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	iftype = wdev->iftype;
 
 	/* make sure the interface is active */
-	if (!wdev->netdev || !netif_running(wdev->netdev))
+	if (!wdev_running(wdev))
 		return true;
 
 	/* NAN doesn't have links, handle it separately */
-- 
2.34.1

