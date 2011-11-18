Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab1KRPXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 10:23:05 -0500
Subject: [PATCH] nl80211: make get_vlan logic more common
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:23:01 +0100
Message-ID: <1321629781.10266.61.camel@jlt3.sipsolutions.net> (sfid-20111118_162309_255144_1F681588)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

get_vlan() sets the output parameter even if it
returns an error, which is a bit odd. Instead,
convert it to use ERR_PTR.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   52 ++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

--- a/net/wireless/nl80211.c	2011-11-18 15:33:05.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-18 16:18:57.000000000 +0100
@@ -2480,26 +2480,34 @@ static int nl80211_get_station(struct sk
 /*
  * Get vlan interface making sure it is running and on the right wiphy.
  */
-static int get_vlan(struct genl_info *info,
-		    struct cfg80211_registered_device *rdev,
-		    struct net_device **vlan)
+static struct net_device *get_vlan(struct genl_info *info,
+				   struct cfg80211_registered_device *rdev)
 {
 	struct nlattr *vlanattr = info->attrs[NL80211_ATTR_STA_VLAN];
-	*vlan = NULL;
+	struct net_device *v;
+	int ret;
 
-	if (vlanattr) {
-		*vlan = dev_get_by_index(genl_info_net(info),
-					 nla_get_u32(vlanattr));
-		if (!*vlan)
-			return -ENODEV;
-		if (!(*vlan)->ieee80211_ptr)
-			return -EINVAL;
-		if ((*vlan)->ieee80211_ptr->wiphy != &rdev->wiphy)
-			return -EINVAL;
-		if (!netif_running(*vlan))
-			return -ENETDOWN;
+	if (!vlanattr)
+		return NULL;
+
+	v = dev_get_by_index(genl_info_net(info), nla_get_u32(vlanattr));
+	if (!v)
+		return ERR_PTR(-ENODEV);
+
+	if (!v->ieee80211_ptr || v->ieee80211_ptr->wiphy != &rdev->wiphy) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	if (!netif_running(v)) {
+		ret = -ENETDOWN;
+		goto error;
 	}
-	return 0;
+
+	return v;
+ error:
+	dev_put(v);
+	return ERR_PTR(ret);
 }
 
 static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
@@ -2549,9 +2557,9 @@ static int nl80211_set_station(struct sk
 		params.plink_state =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
 
-	err = get_vlan(info, rdev, &params.vlan);
-	if (err)
-		goto out;
+	params.vlan = get_vlan(info, rdev);
+	if (IS_ERR(params.vlan))
+		return PTR_ERR(params.vlan);
 
 	/* validate settings */
 	err = 0;
@@ -2719,9 +2727,9 @@ static int nl80211_new_station(struct sk
 	      (rdev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP)))
 		return -EINVAL;
 
-	err = get_vlan(info, rdev, &params.vlan);
-	if (err)
-		goto out;
+	params.vlan = get_vlan(info, rdev);
+	if (IS_ERR(params.vlan))
+		return PTR_ERR(params.vlan);
 
 	/* validate settings */
 	err = 0;


