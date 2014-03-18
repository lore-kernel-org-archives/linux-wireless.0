Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:46809 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbaCRN7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:21 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so5417747eek.34
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:20 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 11/21] mac80211: fix racy usage of chanctx->refcount
Date: Tue, 18 Mar 2014 14:53:14 +0100
Message-Id: <1395150804-24090-12-git-send-email-michal.kazior@tieto.com> (sfid-20140318_145938_007831_D3FBBA3D)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
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
 net/mac80211/cfg.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 137d379..61b62f4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3225,7 +3225,7 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
 	int err, num_chanctx, changed = 0;
 
@@ -3241,23 +3241,24 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				       &sdata->vif.bss_conf.chandef))
 		return -EINVAL;
 
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (!chanctx_conf) {
-		rcu_read_unlock();
+	mutex_lock(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		mutex_unlock(&local->chanctx_mtx);
 		return -EBUSY;
 	}
 
 	/* don't handle for multi-VIF cases */
-	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
+	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
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

