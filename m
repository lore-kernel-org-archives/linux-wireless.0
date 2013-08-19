Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39268 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3HSPM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 11:12:29 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 6/6] nl80211: enable IBSS support for channel switch announcements
Date: Mon, 19 Aug 2013 17:12:20 +0200
Message-Id: <1376925141-15353-7-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130819_171236_838546_19DEAE3A)
In-Reply-To: <1376925141-15353-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1376925141-15353-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/wireless/nl80211.c |   49 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 334697d..85ff8cc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5632,15 +5632,26 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
 	u8 radar_detect_width = 0;
 	int err;
+	bool need_new_beacon = false;
 
 	if (!rdev->ops->channel_switch ||
 	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
 		return -EOPNOTSUPP;
 
-	/* may add IBSS support later */
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+	switch (dev->ieee80211_ptr->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		need_new_beacon = true;
+
+		/* useless if AP is not running */
+		if (!wdev->beacon_interval)
+			return -EINVAL;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
 
 	memset(&params, 0, sizeof(params));
 
@@ -5649,15 +5660,16 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* only important for AP, IBSS and mesh create IEs internally */
-	if (!info->attrs[NL80211_ATTR_CSA_IES])
-		return -EINVAL;
-
-	/* useless if AP is not running */
-	if (!wdev->beacon_interval)
+	if (need_new_beacon &&
+	    (!info->attrs[NL80211_ATTR_CSA_IES] ||
+	     !info->attrs[NL80211_ATTR_CSA_C_OFF_BEACON]))
 		return -EINVAL;
 
 	params.count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
 
+	if (!need_new_beacon)
+		goto skip_beacons;
+
 	err = nl80211_parse_beacon(info->attrs, &params.beacon_after);
 	if (err)
 		return err;
@@ -5697,6 +5709,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+skip_beacons:
 	err = nl80211_parse_chandef(rdev, info, &params.chandef);
 	if (err)
 		return err;
@@ -5704,12 +5717,17 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
-	if (err < 0) {
-		return err;
-	} else if (err) {
-		radar_detect_width = BIT(params.chandef.width);
-		params.radar_required = true;
+	/* DFS channels are only supported for AP/P2P GO ... for now. */
+	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
+	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_P2P_GO) {
+		err = cfg80211_chandef_dfs_required(wdev->wiphy,
+						    &params.chandef);
+		if (err < 0) {
+			return err;
+		} else if (err) {
+			radar_detect_width = BIT(params.chandef.width);
+			params.radar_required = true;
+		}
 	}
 
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
@@ -10733,7 +10751,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 	wdev_lock(wdev);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
+		    wdev->iftype != NL80211_IFTYPE_ADHOC))
 		goto out;
 
 	wdev->channel = chandef->chan;
-- 
1.7.10.4

