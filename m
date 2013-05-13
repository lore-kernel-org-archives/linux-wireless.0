Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3EMJBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 05:01:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] nl80211: Add wdev identifier to some nl80211 notifications
Date: Mon, 13 May 2013 11:01:18 +0200
Message-Id: <1368435678-11855-1-git-send-email-johannes@sipsolutions.net> (sfid-20130513_110133_981272_2BD645A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9cdcd9e..0dcc4e5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10008,6 +10008,7 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    (netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
 					netdev->ifindex)) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)) ||
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, freq) ||
 	    (sig_dbm &&
 	     nla_put_u32(msg, NL80211_ATTR_RX_SIGNAL_DBM, sig_dbm)) ||
@@ -10048,6 +10049,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    (netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
 				   netdev->ifindex)) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)) ||
 	    nla_put(msg, NL80211_ATTR_FRAME, len, buf) ||
 	    nla_put_u64(msg, NL80211_ATTR_COOKIE, cookie) ||
 	    (ack && nla_put_flag(msg, NL80211_ATTR_ACK)))
-- 
1.8.0

