Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:56014 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3KURUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 12:20:40 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCHv2 1/5] cfg80211: protect beacon changing functions with wdev-lock
Date: Thu, 21 Nov 2013 18:19:49 +0100
Message-Id: <1385054393-17238-2-git-send-email-sw@simonwunderlich.de> (sfid-20131121_182044_499270_E0FB063B)
In-Reply-To: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
References: <1385054393-17238-1-git-send-email-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To avoid race conditions in functions which modify the beacon
information, lock these using the wdev lock. This is especially required
to avoid problems for csa handling functions which modify beacons but
can not be called under rtnl lock.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
Changes to PATCH:
 * split into cfg80211/mac80211 patch
---
 net/wireless/nl80211.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e39fadc..b1db645 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3217,6 +3217,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.acl);
 	}
 
+	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
 		wdev->preset_chandef = params.chandef;
@@ -3225,6 +3226,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
 	}
+	wdev_unlock(wdev);
 
 	kfree(params.acl);
 
@@ -3253,7 +3255,11 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	return rdev_change_beacon(rdev, dev, &params);
+	wdev_lock(wdev);
+	err = rdev_change_beacon(rdev, dev, &params);
+	wdev_unlock(wdev);
+
+	return err;
 }
 
 static int nl80211_stop_ap(struct sk_buff *skb, struct genl_info *info)
@@ -4459,7 +4465,9 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct bss_parameters params;
+	int err;
 
 	memset(&params, 0, sizeof(params));
 	/* default to not changing parameters */
@@ -4525,7 +4533,11 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
-	return rdev_change_bss(rdev, dev, &params);
+	wdev_lock(wdev);
+	err = rdev_change_bss(rdev, dev, &params);
+	wdev_unlock(wdev);
+
+	return err;
 }
 
 static const struct nla_policy reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] = {
@@ -5790,7 +5802,11 @@ skip_beacons:
 	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
 		params.block_tx = true;
 
-	return rdev_channel_switch(rdev, dev, &params);
+	wdev_lock(wdev);
+	err = rdev_channel_switch(rdev, dev, &params);
+	wdev_unlock(wdev);
+
+	return err;
 }
 
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
-- 
1.7.10.4

