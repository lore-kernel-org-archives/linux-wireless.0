Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:43109 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab3FXMGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 08:06:06 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] nl80211: fix mgmt tx status and testmode reporting for netns
Date: Mon, 24 Jun 2013 13:50:44 +0200
Message-ID: <1372074644-15280-1-git-send-email-michal.kazior@tieto.com> (sfid-20130624_140622_807454_BC123040)
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
 net/wireless/nl80211.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b14b7e3..7bafce2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6593,7 +6593,10 @@ void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
-	genlmsg_multicast(skb, 0, nl80211_testmode_mcgrp.id, gfp);
+
+	rcu_read_lock();
+	genlmsg_multicast_allns(skb, 0, nl80211_testmode_mcgrp.id, GFP_ATOMIC);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(cfg80211_testmode_event);
 #endif
@@ -10028,7 +10031,8 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
-- 
1.7.9.5

