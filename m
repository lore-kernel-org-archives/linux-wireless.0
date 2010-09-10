Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40965 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0IJWFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 18:05:36 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [virtual-sta 3/3] mac80211:  Allow multiple STA on same BSS.
Date: Fri, 10 Sep 2010 15:04:58 -0700
Message-Id: <1284156298-15863-3-git-send-email-greearb@candelatech.com>
In-Reply-To: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When adding an STA, the old code checked if there was already
an STA with the same BSS.  Instead, check to see if there is
exactly the same STA in order to allow multiple STA to be
associated with the same AP.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 687077e... db751f1... M	net/mac80211/sta_info.c
 net/mac80211/sta_info.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 687077e..db751f1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -440,7 +440,7 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
-	if (sta_info_get_bss(sdata, sta->sta.addr)) {
+	if (sta_info_get(sdata, sta->sta.addr)) {
 		spin_unlock_irqrestore(&local->sta_lock, flags);
 		mutex_unlock(&local->sta_mtx);
 		rcu_read_lock();
-- 
1.7.2.2

