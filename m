Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36404 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaCaLn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 07:43:29 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so4689184wes.33
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 04:43:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 11/13] mac80211: fix racy usage of chanctx->refcount
Date: Mon, 31 Mar 2014 12:39:29 +0200
Message-Id: <1396262371-6466-12-git-send-email-michal.kazior@tieto.com> (sfid-20140331_134339_938432_8507CA86)
In-Reply-To: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
 <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
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
v2:
 * use rcu_dereference_protected() [Eliad/Johannes]

 net/mac80211/cfg.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 821143c..caa351b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3282,7 +3282,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *chanctx;
 	int err, num_chanctx, changed = 0;
 
@@ -3299,23 +3299,24 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
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

