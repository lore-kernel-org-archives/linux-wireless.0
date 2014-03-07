Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:45051 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaCGLZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 06:25:23 -0500
Received: by mail-ee0-f42.google.com with SMTP id d17so1679016eek.29
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 03:25:22 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] mac80211: fix racy usage of chanctx->refcount
Date: Fri,  7 Mar 2014 12:19:54 +0100
Message-Id: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com> (sfid-20140307_122528_234458_D44AF2A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel context refcount is protected by
chanctx_mtx. Accessing the value without holding
the mutex is racy. RCU section didn't guarantee
anything here.

Theoretically ieee80211_channel_switch() could
fail to see refcount change and read "1" instead
of, e.g. "2". This means mac80211 could accept CSA
even though it shouldn't have.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aaa59d7..a79875c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3233,23 +3233,23 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				       &sdata->vif.bss_conf.chandef))
 		return -EINVAL;
 
-	rcu_read_lock();
+	mutex_lock(&local->chanctx_mtx);
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (!chanctx_conf) {
-		rcu_read_unlock();
+		mutex_unlock(&local->chanctx_mtx);
 		return -EBUSY;
 	}
 
 	/* don't handle for multi-VIF cases */
 	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
 	if (chanctx->refcount > 1) {
-		rcu_read_unlock();
+		mutex_unlock(&local->chanctx_mtx);
 		return -EBUSY;
 	}
 	num_chanctx = 0;
 	list_for_each_entry_rcu(chanctx, &local->chanctx_list, list)
 		num_chanctx++;
-	rcu_read_unlock();
+	mutex_unlock(&local->chanctx_mtx);
 
 	if (num_chanctx > 1)
 		return -EBUSY;
-- 
1.8.5.3

