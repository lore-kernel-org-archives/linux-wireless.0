Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761706Ab2FEKQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 06:16:52 -0400
Message-ID: <1338891410.4514.27.camel@jlt3.sipsolutions.net> (sfid-20120605_121656_172146_31F2CAEE)
Subject: [PATCH 3.5] cfg80211: fix interface combinations check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jun 2012 12:16:50 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a given interface combination doesn't contain
a required interface type then we missed checking
that and erroneously allowed it even though iface
type wasn't there at all. Add a check that makes
sure that all interface types are accounted for.

Cc: stable@kernel.org
Reported-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/net/wireless/util.c	2012-06-05 11:35:57.000000000 +0200
+++ b/net/wireless/util.c	2012-06-05 11:38:58.000000000 +0200
@@ -935,6 +935,7 @@ int cfg80211_can_change_interface(struct
 				  enum nl80211_iftype iftype)
 {
 	struct wireless_dev *wdev_iter;
+	u32 used_iftypes = BIT(iftype);
 	int num[NUM_NL80211_IFTYPES];
 	int total = 1;
 	int i, j;
@@ -961,6 +962,7 @@ int cfg80211_can_change_interface(struct
 
 		num[wdev_iter->iftype]++;
 		total++;
+		used_iftypes |= BIT(wdev_iter->iftype);
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
@@ -970,6 +972,7 @@ int cfg80211_can_change_interface(struct
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
+		u32 all_iftypes = 0;
 
 		c = &rdev->wiphy.iface_combinations[i];
 
@@ -984,6 +987,7 @@ int cfg80211_can_change_interface(struct
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
+				all_iftypes |= limits[j].types;
 				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
@@ -991,7 +995,20 @@ int cfg80211_can_change_interface(struct
 				limits[j].max -= num[iftype];
 			}
 		}
-		/* yay, it fits */
+
+		/*
+		 * Finally check that all iftypes that we're currently
+		 * using are actually part of this combination. If they
+		 * aren't then we can't use this combination and have
+		 * to continue to the next.
+		 */
+		if ((all_iftypes & used_iftypes) != used_iftypes)
+			goto cont;
+
+		/*
+		 * This combination covered all interface types and
+		 * supported the requested numbers, so we're good.
+		 */
 		kfree(limits);
 		return 0;
  cont:


