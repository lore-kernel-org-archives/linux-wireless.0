Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab1IGQVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 12:21:53 -0400
Subject: [PATCH IGNORE AT YOUR PERIL] cfg80211: force interface
 combinations to be advertised
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 18:21:52 +0200
Message-ID: <1315412512.4002.10.camel@jlt3.sipsolutions.net> (sfid-20110907_182203_669205_5D3FA4B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

So my "sunset" period idea didn't work, nobody
worked on getting interface combinations added.
Almost 4 months after introducing this flag, no
drivers have been changed to advertise their
interface combinations. Force them now if they
want to keep multiple virtual interfaces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I told you this would happen :-)

 include/net/cfg80211.h |    5 -----
 net/wireless/core.c    |    4 ----
 net/wireless/util.c    |    7 -------
 3 files changed, 16 deletions(-)

--- a/include/net/cfg80211.h	2011-09-07 18:16:22.000000000 +0200
+++ b/include/net/cfg80211.h	2011-09-07 18:16:27.000000000 +0200
@@ -1601,10 +1601,6 @@ struct cfg80211_ops {
  *	hints read the documenation for regulatory_hint_found_beacon()
  * @WIPHY_FLAG_NETNS_OK: if not set, do not allow changing the netns of this
  *	wiphy at all
- * @WIPHY_FLAG_ENFORCE_COMBINATIONS: Set this flag to enforce interface
- *	combinations for this device. This flag is used for backward
- *	compatibility only until all drivers advertise combinations and
- *	they will always be enforced.
  * @WIPHY_FLAG_PS_ON_BY_DEFAULT: if set to true, powersave will be enabled
  *	by default -- this flag will be set depending on the kernel's default
  *	on wiphy_new(), but can be changed by the driver if it has a good
@@ -1632,7 +1628,6 @@ enum wiphy_flags {
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(11),
-	WIPHY_FLAG_ENFORCE_COMBINATIONS		= BIT(12),
 };
 
 /**
--- a/net/wireless/core.c	2011-09-07 18:14:10.000000000 +0200
+++ b/net/wireless/core.c	2011-09-07 18:16:16.000000000 +0200
@@ -422,10 +422,6 @@ static int wiphy_verify_combinations(str
 	const struct ieee80211_iface_combination *c;
 	int i, j;
 
-	/* If we have combinations enforce them */
-	if (wiphy->n_iface_combinations)
-		wiphy->flags |= WIPHY_FLAG_ENFORCE_COMBINATIONS;
-
 	for (i = 0; i < wiphy->n_iface_combinations; i++) {
 		u32 cnt = 0;
 		u16 all_iftypes = 0;
--- a/net/wireless/util.c	2011-09-07 18:14:56.000000000 +0200
+++ b/net/wireless/util.c	2011-09-07 18:16:08.000000000 +0200
@@ -948,13 +948,6 @@ int cfg80211_can_change_interface(struct
 	if (rdev->wiphy.software_iftypes & BIT(iftype))
 		return 0;
 
-	/*
-	 * Drivers will gradually all set this flag, until all
-	 * have it we only enforce for those that set it.
-	 */
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_ENFORCE_COMBINATIONS))
-		return 0;
-
 	memset(num, 0, sizeof(num));
 
 	num[iftype] = 1;


