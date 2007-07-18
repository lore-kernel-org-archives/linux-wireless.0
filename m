Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765889AbXGSKHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 06:07:04 -0400
Subject: [PATCH] nl80211: use new generic netlink multicast API
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 00:08:45 +0200
Message-Id: <1184796525.8125.33.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch again updates nl80211 to use the again changed generic
netlink multicast API.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I just proposed a change to the genetlink multicast API to make sure
people do use the group registration functions. This patch changes
nl80211 to follow that change, but I don't know yet whether the change
will be accepted. But if it is then this is what nl80211 needs to
follow. Of course it depends on the previous patch to use the new
generic netlink multicast API in nl80211.

 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/net/wireless/nl80211.c	2007-07-19 00:04:37.760937160 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-07-19 00:04:41.430937160 +0200
@@ -964,7 +964,7 @@ void nl80211_notify_dev_rename(struct cf
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&rdev->wiphy));
 
 	genlmsg_end(msg, hdr);
-	genlmsg_multicast(msg, 0, nl80211_config_mcgrp.id, GFP_KERNEL);
+	genlmsg_multicast(msg, 0, &nl80211_config_mcgrp, GFP_KERNEL);
 
 	return;
 


