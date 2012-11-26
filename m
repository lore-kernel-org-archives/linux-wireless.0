Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab2KZL56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 06:57:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: remove unnecessary checks
Date: Mon, 26 Nov 2012 12:58:25 +0100
Message-Id: <1353931105-10805-1-git-send-email-johannes@sipsolutions.net> (sfid-20121126_125802_517449_444EA480)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The CQM TX-error rate/interval can't be less than
zero since they're unsigned values, remove checks.
Also fix indentation of the function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 250649c..8d1e103 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6578,14 +6578,13 @@ nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] __read_mostly = {
 };
 
 static int nl80211_set_cqm_txe(struct genl_info *info,
-				u32 rate, u32 pkts, u32 intvl)
+			       u32 rate, u32 pkts, u32 intvl)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev;
 	struct net_device *dev = info->user_ptr[1];
 
-	if ((rate < 0 || rate > 100) ||
-	    (intvl < 0 || intvl > NL80211_CQM_TXE_MAX_INTVL))
+	if (rate > 100 || intvl > NL80211_CQM_TXE_MAX_INTVL)
 		return -EINVAL;
 
 	wdev = dev->ieee80211_ptr;
-- 
1.8.0

