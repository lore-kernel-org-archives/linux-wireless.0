Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0JGLLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 07:11:21 -0400
Subject: [PATCH] cfg80211: constify WDS address
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bill Jordan <bjordan@rajant.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:11:09 +0200
Message-ID: <1286449869.3657.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for the WDS peer address
to not be const, so make it const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    2 +-
 net/mac80211/cfg.c     |    2 +-
 net/wireless/nl80211.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-10-07 13:07:06.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-10-07 13:07:31.000000000 +0200
@@ -1229,7 +1229,7 @@ struct cfg80211_ops {
 	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
 
 	int	(*set_wds_peer)(struct wiphy *wiphy, struct net_device *dev,
-				u8 *addr);
+				const u8 *addr);
 
 	void	(*rfkill_poll)(struct wiphy *wiphy);
 
--- wireless-testing.orig/net/mac80211/cfg.c	2010-10-07 13:07:06.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-10-07 13:07:31.000000000 +0200
@@ -1363,7 +1363,7 @@ static int ieee80211_get_tx_power(struct
 }
 
 static int ieee80211_set_wds_peer(struct wiphy *wiphy, struct net_device *dev,
-				  u8 *addr)
+				  const u8 *addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
--- wireless-testing.orig/net/wireless/nl80211.c	2010-10-07 13:07:19.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-10-07 13:07:31.000000000 +0200
@@ -879,7 +879,7 @@ static int nl80211_set_wds_peer(struct s
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	u8 *bssid;
+	const u8 *bssid;
 
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;


