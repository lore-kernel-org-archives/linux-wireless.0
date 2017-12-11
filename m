Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43098 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdLKLe3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 06:34:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix nl80211_send_iface() error paths
Date: Mon, 11 Dec 2017 12:34:26 +0100
Message-Id: <20171211113426.32257-1-johannes@sipsolutions.net> (sfid-20171211_123433_187871_B6842119)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Evidently I introduced a locking bug in my change here,
the nla_put_failure sometimes needs to unlock. Fix it.

Fixes: 44905265bc15 ("nl80211: don't expose wdev->ssid for most interfaces")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b1ac23ca20c8..213d0c498c97 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2610,7 +2610,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	case NL80211_IFTYPE_AP:
 		if (wdev->ssid_len &&
 		    nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
-			goto nla_put_failure;
+			goto nla_put_failure_locked;
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
@@ -2623,7 +2623,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		if (!ssid_ie)
 			break;
 		if (nla_put(msg, NL80211_ATTR_SSID, ssid_ie[1], ssid_ie + 2))
-			goto nla_put_failure;
+			goto nla_put_failure_locked;
 		break;
 		}
 	default:
@@ -2635,6 +2635,8 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	genlmsg_end(msg, hdr);
 	return 0;
 
+ nla_put_failure_locked:
+	wdev_unlock(wdev);
  nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
-- 
2.14.2
