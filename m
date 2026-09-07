Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97D42BDC1C
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 17:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788802919; cv=none; b=uOUhQXYo+Sfhmam2j5icifudFr3fmYunj+ozN6TXJ1GAWRf8g+X2AG/7/wi9WgXvTdjjKqTMbNSV/j3QwvCmX5NOPi95h58sUFcD6o/nra0oSSFShntqtZ1LdCLO9OGiODWEQEIoiXJigUtc+SWBXZ33KwlmXjEDbtg3Xsu/n+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788802919; c=relaxed/simple;
	bh=d/c9dZg389lsp7GU5Lr7sEgc9Q3STScSfoKrrCIxtjc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MP7/2bnrWJQlDUWTfF24NN9Kpncuun8C+nnLibNZA/xv3ldbcTe3GGDoBOEFgFvA4TBg6hAdkCWaLXeAg3a464QsSMmC21eO914Swkg/Ui5ATsZYIzFOLU8nLuJDtcU8QGnYqqdKyi5a+srOGtMQ1ZTTHNhsarEuL5/P3pw//b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A3HCLy8M; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A3HCLy8M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788802918; x=1820338918;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d/c9dZg389lsp7GU5Lr7sEgc9Q3STScSfoKrrCIxtjc=;
  b=A3HCLy8Mr+O0qH7hXq9AyE7WVi9jFcjXO1JGdiu6ALwoghKf/djfqoYU
   x/d+aQ3yx9fttp3huDQ/0dbIGdii8ftm7Hf8GgkkUyHxY7MIlWiDrZSdM
   VygD//NB+gc2TQr5wl8AgHuBPojzlSjYC79JsS7gq/q3DlXpf2IsZHHkR
   ZX5LwxniEzU6Qe36HTbr/JElA8L6ev/3qD8h6P0wN8UzO26JngNsSzlWV
   JSSDLyBTm2VpDCxO49BWGvQkTAk7LIpC3KHHMVzgrjlAZ5dI9q4DucnGu
   kMkZkzDMHhGV3FTtTMDzqwnP5Pl9O0PhvGxnSbfZgwayds+oQVx2BqzcJ
   A==;
X-CSE-ConnectionGUID: ywSU2cl6QBupX99JnxbWOA==
X-CSE-MsgGUID: 4Ri2+xKmS3WEOmtEbvrh+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="111981878"
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="111981878"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:41:57 -0700
X-CSE-ConnectionGUID: QDuiY1VEQXqUBsGhVxUFPg==
X-CSE-MsgGUID: rUtletlHRDu2TtOzJJ5czw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="269452864"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:41:56 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH wireless-next] wifi: cfg80211: fix NAN local schedule update ordering and allocation
Date: Mon,  7 Sep 2026 20:43:57 +0300
Message-Id: <20260907204351.a9a08f59fb8d.I0b45103342d4a911142a2325b9259258758a0670@changeid>
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
 net/wireless/core.c | 53 +++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2f46243773f9..3e1d2c00b502 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -288,6 +288,8 @@ int cfg80211_nan_set_local_schedule(struct cfg80211_registered_device *rdev,
 				    struct wireless_dev *wdev,
 				    struct cfg80211_nan_local_sched *sched)
 {
+	struct cfg80211_chan_def *chandefs = NULL, *old_chandefs;
+	u8 old_n_channels;
 	int ret;
 
 	lockdep_assert_held(&rdev->wiphy.mtx);
@@ -298,29 +300,42 @@ int cfg80211_nan_set_local_schedule(struct cfg80211_registered_device *rdev,
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
 
-	wdev->u.nan.chandefs = kcalloc(sched->n_channels,
-				       sizeof(*wdev->u.nan.chandefs),
-				       GFP_KERNEL);
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

