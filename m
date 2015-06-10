Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41171 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbFJWRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:17:16 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] wireless:  Add ifname to STOP_AP event.
Date: Wed, 10 Jun 2015 15:17:05 -0700
Message-Id: <1433974625-327-1-git-send-email-greearb@candelatech.com> (sfid-20150611_001719_717886_67EBBE52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

In case user-space wants to know the name of the
device, this will save a name lookup by index, and
in case where kernel manages to fully delete the
interface before user-space can determine the name,
this will ensure user-space has proper name.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 736c474..ba73def 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12992,6 +12992,7 @@ void nl80211_send_ap_stopped(struct wireless_dev *wdev)
 		goto out;
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_string(msg, NL80211_ATTR_IFNAME, wdev->netdev->name) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex) ||
 	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
 		goto out;
-- 
1.7.11.7

