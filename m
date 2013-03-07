Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3CGLzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 06:55:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net
Subject: [PATCH 3.9] cfg80211: fix potential BSS memory leak and update
Date: Thu,  7 Mar 2013 12:55:45 +0100
Message-Id: <1362657345-16164-1-git-send-email-johannes@sipsolutions.net> (sfid-20130307_125553_226292_852022A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the odd case that while updating information from a beacon,
a BSS was found that is part of a hidden group, we drop the
new information. In this case, however, we leak the IE buffer
from the update, and erroneously update the entry's timestamp
so it will never time out. Fix both these issues.

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 674aadc..e93bd31 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -698,11 +698,6 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 	found = rb_find_bss(dev, tmp, BSS_CMP_REGULAR);
 
 	if (found) {
-		found->pub.beacon_interval = tmp->pub.beacon_interval;
-		found->pub.signal = tmp->pub.signal;
-		found->pub.capability = tmp->pub.capability;
-		found->ts = tmp->ts;
-
 		/* Update IEs */
 		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
 			const struct cfg80211_bss_ies *old;
@@ -723,6 +718,8 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 
 			if (found->pub.hidden_beacon_bss &&
 			    !list_empty(&found->hidden_list)) {
+				const struct cfg80211_bss_ies *f;
+
 				/*
 				 * The found BSS struct is one of the probe
 				 * response members of a group, but we're
@@ -732,6 +729,10 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 				 * SSID to showing it, which is confusing so
 				 * drop this information.
 				 */
+
+				f = rcu_access_pointer(tmp->pub.beacon_ies);
+				kfree_rcu((struct cfg80211_bss_ies *)f,
+					  rcu_head);
 				goto drop;
 			}
 
@@ -761,6 +762,11 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 				kfree_rcu((struct cfg80211_bss_ies *)old,
 					  rcu_head);
 		}
+
+		found->pub.beacon_interval = tmp->pub.beacon_interval;
+		found->pub.signal = tmp->pub.signal;
+		found->pub.capability = tmp->pub.capability;
+		found->ts = tmp->ts;
 	} else {
 		struct cfg80211_internal_bss *new;
 		struct cfg80211_internal_bss *hidden;
-- 
1.8.0

