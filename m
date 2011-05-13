Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35098 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab1EMIgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 04:36:09 -0400
Subject: [PATCH] compat-wireless: make WEXT patch apply over sched_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 10:36:05 +0200
Message-ID: <1305275765.3487.6.camel@jlt3.sipsolutions.net> (sfid-20110513_103613_531466_A4A0717C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The sched_scan patches changed context for a patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/10-add-wext-handlers-to-netdev.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/patches/10-add-wext-handlers-to-netdev.patch b/patches/10-add-wext-handlers-to-netdev.patch
index 3600c6f..cd35cf6 100644
--- a/patches/10-add-wext-handlers-to-netdev.patch
+++ b/patches/10-add-wext-handlers-to-netdev.patch
@@ -21,7 +21,7 @@ CONFIG_WIRELESS_EXT in compat-wireless.
 @@ -373,10 +373,6 @@ struct wiphy *wiphy_new(const struct cfg
  	INIT_LIST_HEAD(&rdev->bss_list);
  	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
- 
+ 	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
 -#ifdef CONFIG_CFG80211_WEXT
 -	rdev->wiphy.wext = &cfg80211_wext_handler;
 -#endif
-- 
1.7.5.1



