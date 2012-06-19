Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2FSOvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 05/17] nl80211: use __cfg80211_rdev_from_attrs for testmode
Date: Tue, 19 Jun 2012 16:50:44 +0200
Message-Id: <1340117456-10154-6-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165115_503956_60A325B5)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To fix the testmode cross-namespace access problem,
use __cfg80211_rdev_from_attrs() to get the device
instead of open-coding similar functionality.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7e94d4d..06623d0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5230,21 +5230,18 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 				  nl80211_policy);
 		if (err)
 			return err;
-		if (nl80211_fam.attrbuf[NL80211_ATTR_WIPHY]) {
-			phy_idx = nla_get_u32(
-				nl80211_fam.attrbuf[NL80211_ATTR_WIPHY]);
-		} else {
-			struct net_device *netdev;
 
-			err = get_rdev_dev_by_ifindex(sock_net(skb->sk),
-						      nl80211_fam.attrbuf,
-						      &rdev, &netdev);
-			if (err)
-				return err;
-			dev_put(netdev);
-			phy_idx = rdev->wiphy_idx;
-			cfg80211_unlock_rdev(rdev);
+		mutex_lock(&cfg80211_mutex);
+		rdev = __cfg80211_rdev_from_attrs(sock_net(skb->sk),
+						  nl80211_fam.attrbuf);
+		if (IS_ERR(rdev)) {
+			mutex_unlock(&cfg80211_mutex);
+			return PTR_ERR(rdev);
 		}
+		phy_idx = rdev->wiphy_idx;
+		rdev = NULL;
+		mutex_unlock(&cfg80211_mutex);
+
 		if (nl80211_fam.attrbuf[NL80211_ATTR_TESTDATA])
 			cb->args[1] =
 				(long)nl80211_fam.attrbuf[NL80211_ATTR_TESTDATA];
-- 
1.7.10

