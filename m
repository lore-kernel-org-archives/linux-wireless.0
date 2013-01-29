Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3A2VlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:41:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove free_priv BSS API
Date: Tue, 29 Jan 2013 22:41:39 +0100
Message-Id: <1359495699-32332-1-git-send-email-johannes@sipsolutions.net> (sfid-20130129_224135_592532_B8A43956)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that mac80211 no longer uses this API, remove
it completely. If anyone needs it again, we can
revert this patch of course, but mac80211 was the
only user right now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 3 ---
 net/wireless/scan.c    | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4d28631..5eb20bc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1301,7 +1301,6 @@ struct cfg80211_bss_ies {
  * @beacon_ies: the information elements from the last Beacon frame
  * @proberesp_ies: the information elements from the last Probe Response frame
  * @signal: signal strength value (type depends on the wiphy's signal_type)
- * @free_priv: function pointer to free private data
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
 struct cfg80211_bss {
@@ -1313,8 +1312,6 @@ struct cfg80211_bss {
 	const struct cfg80211_bss_ies __rcu *beacon_ies;
 	const struct cfg80211_bss_ies __rcu *proberesp_ies;
 
-	void (*free_priv)(struct cfg80211_bss *bss);
-
 	s32 signal;
 
 	u16 beacon_interval;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 01592d7..ca367c5 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -31,9 +31,6 @@ static void bss_release(struct kref *ref)
 	if (WARN_ON(atomic_read(&bss->hold)))
 		return;
 
-	if (bss->pub.free_priv)
-		bss->pub.free_priv(&bss->pub);
-
 	ies = (void *)rcu_access_pointer(bss->pub.beacon_ies);
 	if (ies)
 		kfree_rcu(ies, rcu_head);
-- 
1.8.0

