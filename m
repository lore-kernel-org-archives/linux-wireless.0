Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945964Ab2LFQr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:27 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/24] regulatory: don't allocate too much memory
Date: Thu,  6 Dec 2012 17:47:26 +0100
Message-Id: <1354812468-15709-3-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174757_115371_C54D5F1F)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to allocate one reg rule more
than will be used, reduce the allocations. The
allocation in nl80211 already doesn't allocate
too much space.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4197359..70255c9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -319,8 +319,9 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 	int size_of_regd = 0;
 	unsigned int i;
 
-	size_of_regd = sizeof(struct ieee80211_regdomain) +
-	  ((src_regd->n_reg_rules + 1) * sizeof(struct ieee80211_reg_rule));
+	size_of_regd =
+		sizeof(struct ieee80211_regdomain) +
+		src_regd->n_reg_rules * sizeof(struct ieee80211_reg_rule);
 
 	regd = kzalloc(size_of_regd, GFP_KERNEL);
 	if (!regd)
@@ -642,7 +643,7 @@ static struct ieee80211_regdomain *regdom_intersect(
 		return NULL;
 
 	size_of_regd = sizeof(struct ieee80211_regdomain) +
-		((num_rules + 1) * sizeof(struct ieee80211_reg_rule));
+		       num_rules * sizeof(struct ieee80211_reg_rule);
 
 	rd = kzalloc(size_of_regd, GFP_KERNEL);
 	if (!rd)
-- 
1.8.0

