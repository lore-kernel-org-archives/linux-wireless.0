Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10109 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2FDPrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 11:47:25 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] cfg80211: Fix incompatible interfaces combination
Date: Mon, 4 Jun 2012 21:17:16 +0530
Message-ID: <1338824836-2283-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120604_174728_231777_87330E76)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

*if any interface type is not advertised by the driver
via ieee80211_iface_combination make sure we will have it
as a single interface only. lets that we will not add
an incompatible interface if some other interface is
already present. we cannot add any other interface,
if the already present interface is an incompatible
interface. for example in ath9k we don't advertise ADHOC in
ieee80211_iface_combination structure in the driver,
so it can only exist as an single interface

*if the driver is not advertising interface combination just
return so that we don't break their multivif operation.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/wireless/util.c |   62 ++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 49 insertions(+), 13 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index c64d30f..7712ac6 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -932,22 +932,31 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 
 int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 				  struct wireless_dev *wdev,
-				  enum nl80211_iftype iftype)
+				  enum nl80211_iftype ntype)
 {
 	struct wireless_dev *wdev_iter;
 	int num[NUM_NL80211_IFTYPES];
 	int total = 1;
 	int i, j;
+	enum nl80211_iftype iftype;
+	bool ntype_single = true;
+	bool found_iface_comb = false;
+	bool iface_comb_allowed[NUM_NL80211_IFTYPES];
 
 	ASSERT_RTNL();
 
 	/* Always allow software iftypes */
-	if (rdev->wiphy.software_iftypes & BIT(iftype))
+	if (rdev->wiphy.software_iftypes & BIT(ntype))
+		return 0;
+
+	/* interface combination not advertised by the driver */
+	if (!rdev->wiphy.n_iface_combinations)
 		return 0;
 
 	memset(num, 0, sizeof(num));
+	memset(iface_comb_allowed, 0, sizeof(iface_comb_allowed));
 
-	num[iftype] = 1;
+	num[ntype] = 1;
 
 	mutex_lock(&rdev->devlist_mtx);
 	list_for_each_entry(wdev_iter, &rdev->netdev_list, list) {
@@ -967,6 +976,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	if (total == 1)
 		return 0;
 
+
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
@@ -981,24 +991,50 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			goto cont;
 
 		for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
-			if (rdev->wiphy.software_iftypes & BIT(iftype))
+
+			if (rdev->wiphy.software_iftypes & BIT(iftype)) {
+				iface_comb_allowed[iftype] = true;
 				continue;
+			}
+
 			for (j = 0; j < c->n_limits; j++) {
-				if (!(limits[j].types & BIT(iftype)))
-					continue;
-				if (limits[j].max < num[iftype])
-					goto cont;
-				limits[j].max -= num[iftype];
+
+				if (limits[j].types & BIT(ntype))
+					ntype_single = false;
+
+				if (!num[iftype] ||
+				    (limits[j].types & BIT(iftype)))
+					iface_comb_allowed[iftype] = true;
+
+				if (!found_iface_comb) {
+
+					if (!(limits[j].types & BIT(iftype)))
+						continue;
+					if (limits[j].max < num[iftype])
+						goto cont;
+					limits[j].max -= num[iftype];
+
+				}
 			}
 		}
-		/* yay, it fits */
-		kfree(limits);
-		return 0;
+
+		found_iface_comb = true;
+
  cont:
 		kfree(limits);
 	}
 
-	return -EBUSY;
+	if (ntype_single)
+		return -EOPNOTSUPP;
+
+	for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++)
+		if (!iface_comb_allowed[iftype])
+			return -EOPNOTSUPP;
+
+	if (found_iface_comb)
+		return 0;
+
+	return -EOPNOTSUPP;
 }
 
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
-- 
1.7.0.4

