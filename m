Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63307 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2GRMgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:36:06 -0400
Received: by weyx8 with SMTP id x8so916918wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:36:04 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: flush stations before stop beaconing
Date: Wed, 18 Jul 2012 15:36:04 +0300
Message-Id: <1342614964-5826-1-git-send-email-eliad@wizery.com> (sfid-20120718_143613_583758_51D85D7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When AP interface is going down, the stations
are flushed (in ieee80211_do_stop()) only after
the beaconing was stopped.

However, drivers might rely on stations being
removed before the beaconing was stopped, in
order to clean up properly.

Fix it by flushing the stations on ap stop.

(we already do the same for other interface
types, e.g. in ieee80211_set_disassoc())

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6e4098e..c7df257 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -924,6 +924,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 
 	kfree_rcu(old, rcu_head);
 
+	sta_info_flush(sdata->local, sdata);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
 	return 0;
-- 
1.7.6.401.g6a319

