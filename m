Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbaEKIxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:53:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/7] cfg80211: accept world/same regdom from driver/user hints
Date: Sun, 11 May 2014 11:50:48 +0300
Message-Id: <1399798250-20987-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140511_105350_853410_DE0CD73C)
In-Reply-To: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Allow driver and user hints to set the "world" regulatory domain, and
also allow them to set the same reg-domain. This is useful when sending
an unknown-country ("99") request to a wiphy-specific regulatory source,
requesting it to provide the current alpha2. It may return an updated
regdomain for the "world" alpha2.

Note there's a check for regdom change at the request level, so the case
where the same alpha2 is set repeatedly is still optimized.

Change-Id: Iff04537b26a4c4153b78232ea33a5525512f902a
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/reg.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c429ec5..d6b83f9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2539,9 +2539,6 @@ static int reg_set_rd_user(const struct ieee80211_regdomain *rd,
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
 
-	if (!regdom_changes(rd->alpha2))
-		return -EALREADY;
-
 	if (!is_valid_rd(rd)) {
 		pr_err("Invalid regulatory domain detected:\n");
 		print_regdomain_info(rd);
@@ -2572,12 +2569,6 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
 	const struct ieee80211_regdomain *tmp;
 	struct wiphy *request_wiphy;
 
-	if (is_world_regdom(rd->alpha2))
-		return -EINVAL;
-
-	if (!regdom_changes(rd->alpha2))
-		return -EALREADY;
-
 	if (!is_valid_rd(rd)) {
 		pr_err("Invalid regulatory domain detected:\n");
 		print_regdomain_info(rd);
-- 
1.8.3.2

