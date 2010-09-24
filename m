Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:21126 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0IXEYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 00:24:10 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH] nl80211: Fix exit from nl80211_set_power_save
Date: Fri, 24 Sep 2010 07:23:55 +0300
Message-Id: <1285302235-18559-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If interface does not existk, when nl80211_set_power_save is called, (eg.
module has been unloaded) it has been causing kernel panic. Added new
goto target to avoid crash if get_rdev_dev_by_info_ifindex does not
return dev and rdev pointers.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 net/wireless/nl80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f15b1af..4ff827e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4990,7 +4990,7 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 
 	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
-		goto unlock_rdev;
+		goto unlock_rtnl;
 
 	wdev = dev->ieee80211_ptr;
 
@@ -5014,6 +5014,7 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 unlock_rdev:
 	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
+unlock_rtnl:
 	rtnl_unlock();
 
 out:
-- 
1.5.6.3

