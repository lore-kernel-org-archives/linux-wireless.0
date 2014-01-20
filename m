Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58400 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaATOZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:25:45 -0500
Received: by mail-ea0-f172.google.com with SMTP id g15so2547316eak.31
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:25:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/7] mac80211: deny attempts at using chanctx during CSA
Date: Mon, 20 Jan 2014 15:21:09 +0100
Message-Id: <1390227670-19030-7-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152553_235589_4F76AC02)
In-Reply-To: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to connect STA when AP CSA was in
progress which clearly was a bug.

Deny attempts to increase chanctx refcount or
create chanctx.

This effectively denies starting a new interface
and radar detection while CSA is in progress.

Existing interfaces (including those with active
CSA) can be stopped though.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c        |  7 +++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/util.c        | 18 ++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f43613a..9057b66 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -517,6 +517,13 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 
 	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
 
+	/* Do not allow an interface to bind to channel contexts during CSA as
+	 * it would end up with the interface being dragged to a different
+	 * channel once CSA completes. It's safe to unbind from channel
+	 * contexts though. */
+	if (ieee80211_is_csa_active(local))
+		return -EBUSY;
+
 	mutex_lock(&local->chanctx_mtx);
 	__ieee80211_vif_release_channel(sdata);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a6cda02..763a0ca 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1465,6 +1465,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 int ieee80211_channel_switch(struct wiphy *wiphy,
 			     struct cfg80211_csa_settings *params,
 			     int num_params);
+bool ieee80211_is_csa_active(struct ieee80211_local *local);
 
 /* interface handling */
 int ieee80211_iface_init(void);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 676dc09..3e77c41 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2775,3 +2775,21 @@ void ieee80211_recalc_dtim(struct ieee80211_local *local,
 
 	ps->dtim_count = dtim_count;
 }
+
+bool ieee80211_is_csa_active(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_held(&local->mtx);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->vif.csa_active) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+
+	return false;
+}
-- 
1.8.4.rc3

