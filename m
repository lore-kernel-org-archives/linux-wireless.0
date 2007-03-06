Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47948
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965425AbXCFSDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 13:03:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: Properly kill tasklets before shutdown
Date: Tue, 6 Mar 2007 19:01:59 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703061902.00001.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to do tasklet_kill() on any tasklet on unregister
to make sure the tasklet is not running _and_ scheduled anymore.
(tasklet_disable() only ensures it's not running anymore).

This fixes the tasklet related crash that was reported some time ago.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: bu3sch-wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- bu3sch-wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-06 15:55:53.000000000 +0100
+++ bu3sch-wireless-dev/net/mac80211/ieee80211.c	2007-03-06 15:58:10.000000000 +0100
@@ -4761,8 +4761,8 @@
 	struct ieee80211_sub_if_data *sdata, *tmp;
 	int i;
 
-	tasklet_disable(&local->tasklet);
-	/* TODO: skb_queue should be empty here, no need to do anything? */
+	tasklet_kill(&local->tx_pending_tasklet);
+	tasklet_kill(&local->tasklet);
 
 	rtnl_lock();
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;

-- 
Greetings Michael.
