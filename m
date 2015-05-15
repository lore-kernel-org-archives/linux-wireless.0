Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33641 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbbEOG1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 02:27:25 -0400
Received: by igbpi8 with SMTP id pi8so29958427igb.0
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2015 23:27:24 -0700 (PDT)
From: Varka Bhadram <varkabhadram@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH wireless-next] mac80211: fix double flush workqueue
Date: Fri, 15 May 2015 11:56:50 +0530
Message-Id: <1431671210-6761-1-git-send-email-varkab@cdac.in> (sfid-20150515_082729_946176_9D8046F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In suspend functionality flushing of the workqueue is done
with ieee80211_stop_device(). This patch avoid flushing
the workqueue for two times.

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 net/mac80211/pm.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ac6ad62..e433d6e 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -47,8 +47,6 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	/* make quiescing visible to timers everywhere */
 	mb();
 
-	flush_workqueue(local->workqueue);
-
 	/* Don't try to run timers while suspended. */
 	del_timer_sync(&local->sta_cleanup);
 
-- 
1.7.9.5

