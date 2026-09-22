Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD88385D72
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072486; cv=none; b=ZTEePcdv6vp6MNH0Ivm5je1MJNSzpg96F64On5l8f3JFOzXoJ5N4EBgZWg//gBygWApF1zK5NgHdulE5Qch8Z5OyL5GphBbDcE0Ijo2Pq8NhqbtrpuyhCrjOmwlv0jVXIn9EoIVhBFKshvuP+6Qxa37jXquWy8uMRqm7ylVR2+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072486; c=relaxed/simple;
	bh=JsM1HG5KnDWUmvv13cuAN27JIJJVa7U4D7WVGlLADyg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MGB7S6HMq9LTzSVWZ3TBbZnczheZelFrT8teQjxk/mw2ErTNnmKYVWCuRq+JJUgGI6LFCBOe4UIagduIAcvZMVc/TgumuKt9uHZVY2aOoooDceuOv7rJY2dBeOreCuQEbc/gJk4hqtxrr3Z5XwXFuIrmNZUNjGqAnkQJSWnP3aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gj7dbyuu; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gj7dbyuu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790072483; x=1821608483;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JsM1HG5KnDWUmvv13cuAN27JIJJVa7U4D7WVGlLADyg=;
  b=gj7dbyuui/DAOGki/qodnI66fv6nU6cGG0hM6AJOZ2bK5yADrSP0MN7L
   odn1WhptHp0QchE7zrzc1ApcHmNOEg9IJ1I5pGqUvpWMJu3MeCqTrnbS9
   5FyCbujilX7o090YSe1Ya0vcTbLNujFOcwV2EBT8nbigvJrBE1fL26YwH
   TlW1DabXZraN4f5l7Awm5O9Vdd28X3pnGegROW8jKRniQEn7pV4Flkand
   +qVhU0LQ3vDTl4bx7ZEXWsEhQJnr/jz57JtlDNum86McrvaUgxAj5Auec
   nV+DDs1Rhz4PXK1R6K7VNNn3ZEiakIykJReuy2YS5Mjzj1+sv7Ll/oEAw
   A==;
X-CSE-ConnectionGUID: A+RoDEFQSluADbtSbCu3Ew==
X-CSE-MsgGUID: PIElaoNnRGC6v9phPxExfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="89585059"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="89585059"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:21:22 -0700
X-CSE-ConnectionGUID: cOvfe6GISz2WRbCSXMNRcQ==
X-CSE-MsgGUID: Ed2SMiooQ3isVE1aC45NYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="277855208"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 03:21:20 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH v2 wireless-next] wifi: cfg80211: fix NAN local schedule update ordering and allocation
Date: Tue, 22 Sep 2026 13:23:16 +0300
Message-Id: <20260922132247.d0665fa8a5c1.I0b45103342d4a911142a2325b9259258758a0670@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

In cfg80211_nan_set_local_schedule(), after calling the driver,
the old channel definitions were freed and only then the new ones were
allocated and stored.
This had two problems:

 - On allocation failure the previous channel definitions had already been
   freed while the driver had already applied the new schedule, leaving
   the wdev with no channel definitions.
 - If the driver completes a deferred schedule update synchronously,
   the completion notification to user space fired before the new
   channel definitions were stored, exposing an inconsistent state.

Allocate and fill the new channel definitions before calling the driver,
swap them in, and roll back on failure. Also set the pending flag before
the driver call so that a synchronous deferred completion can clear it.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
v2: rebased on latest wireless-next/main

 net/wireless/core.c | 52 +++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3ac3b2a67a9c..dc1e0522340a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -312,6 +312,8 @@ int cfg80211_nan_set_local_schedule(struct cfg80211_registered_device *rdev,
 				    struct wireless_dev *wdev,
 				    struct cfg80211_nan_local_sched *sched)
 {
+	struct cfg80211_chan_def *chandefs = NULL, *old_chandefs;
+	u8 old_n_channels;
 	int ret;
 
 	lockdep_assert_held(&rdev->wiphy.mtx);
@@ -322,28 +324,42 @@ int cfg80211_nan_set_local_schedule(struct cfg80211_registered_device *rdev,
 	if (wdev->u.nan.sched_update_pending)
 		return -EBUSY;
 
-	ret = rdev_nan_set_local_sched(rdev, wdev, sched);
-	if (ret)
-		return ret;
-
-	wdev->u.nan.sched_update_pending = sched->deferred;
-
-	kfree(wdev->u.nan.chandefs);
-	wdev->u.nan.chandefs = NULL;
-	wdev->u.nan.n_channels = 0;
+	/*
+	 * Pre-allocate chandefs, so we don't ruin the current
+	 * schedule on allocation failure.
+	 */
+	if (sched->n_channels) {
+		chandefs = kcalloc(sched->n_channels, sizeof(*chandefs),
+				   GFP_KERNEL);
+		if (!chandefs)
+			return -ENOMEM;
 
-	if (!sched->n_channels)
-		return 0;
+		for (int i = 0; i < sched->n_channels; i++)
+			chandefs[i] = sched->nan_channels[i].chandef;
+	}
 
-	wdev->u.nan.chandefs = kzalloc_objs(*wdev->u.nan.chandefs,
-					    sched->n_channels);
-	if (!wdev->u.nan.chandefs)
-		return -ENOMEM;
+	/*
+	 * Swap in the new chandefs before calling the driver and set the
+	 * deferred flag, so if the driver completes the update synchronously
+	 * the new schedule will be already in place.
+	 */
+	old_chandefs = wdev->u.nan.chandefs;
+	old_n_channels = wdev->u.nan.n_channels;
+	wdev->u.nan.chandefs = chandefs;
+	wdev->u.nan.n_channels = sched->n_channels;
+	wdev->u.nan.sched_update_pending = sched->deferred;
 
-	for (int i = 0; i < sched->n_channels; i++)
-		wdev->u.nan.chandefs[i] = sched->nan_channels[i].chandef;
+	ret = rdev_nan_set_local_sched(rdev, wdev, sched);
+	if (ret) {
+		/* Restore the previous schedule on failure */
+		wdev->u.nan.sched_update_pending = false;
+		wdev->u.nan.chandefs = old_chandefs;
+		wdev->u.nan.n_channels = old_n_channels;
+		kfree(chandefs);
+		return ret;
+	}
 
-	wdev->u.nan.n_channels = sched->n_channels;
+	kfree(old_chandefs);
 
 	return 0;
 }
-- 
2.34.1

