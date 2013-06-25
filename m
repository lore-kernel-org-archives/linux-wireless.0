Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:58782 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3FYHRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 03:17:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] nl80211: fix mgmt tx status and testmode reporting for netns
Date: Tue, 25 Jun 2013 09:17:17 +0200
Message-ID: <1372144637-1676-1-git-send-email-michal.kazior@tieto.com> (sfid-20130625_091731_566419_454D464B)
In-Reply-To: <1372074644-15280-1-git-send-email-michal.kazior@tieto.com>
References: <1372074644-15280-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two events were sent to the default network
namespace.

This caused AP mode in a non-default netns to not
work correctly. Mgmt tx status was multicasted to
a different (default) netns instead of the one the
AP was in.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2: push testmode event to the right netns (thanks Johannes!)

 net/wireless/nl80211.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b14b7e3..db8ead9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6588,12 +6588,14 @@ EXPORT_SYMBOL(cfg80211_testmode_alloc_event_skb);
 
 void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 {
+	struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
-	genlmsg_multicast(skb, 0, nl80211_testmode_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), skb, 0,
+				nl80211_testmode_mcgrp.id, gfp);
 }
 EXPORT_SYMBOL(cfg80211_testmode_event);
 #endif
@@ -10028,7 +10030,8 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
-- 
1.7.9.5

