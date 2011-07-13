Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab1GMRuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 13:50:54 -0400
Subject: [PATCH] mac80211: let key iteration get keys in install order
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 19:50:53 +0200
Message-ID: <1310579453.3873.12.camel@jlt3.sipsolutions.net> (sfid-20110713_195057_926559_A0B796B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_iter_keys() currently returns keys in
the backward order they were installed in, which
is a bit confusing. Add them to the tail of the
key list to make sure iterations go in the same
order that keys were originally installed in.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/key.c     |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/net/mac80211/key.c	2011-07-13 19:24:20.000000000 +0200
+++ b/net/mac80211/key.c	2011-07-13 19:28:17.000000000 +0200
@@ -278,7 +278,7 @@ static void __ieee80211_key_replace(stru
 	bool defunikey, defmultikey, defmgmtkey;
 
 	if (new)
-		list_add(&new->list, &sdata->key_list);
+		list_add_tail(&new->list, &sdata->key_list);
 
 	if (sta && pairwise) {
 		rcu_assign_pointer(sta->ptk, new);
--- a/include/net/mac80211.h	2011-07-13 19:24:20.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-13 19:28:17.000000000 +0200
@@ -2986,6 +2986,10 @@ void ieee80211_sta_block_awake(struct ie
  * needs reprogramming of the keys during suspend. Note that due
  * to locking reasons, it is also only safe to call this at few
  * spots since it must hold the RTNL and be able to sleep.
+ *
+ * The order in which the keys are iterated matches the order
+ * in which they were originally installed and handed to the
+ * set_key callback.
  */
 void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,


