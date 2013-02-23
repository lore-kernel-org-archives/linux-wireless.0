Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59754 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab3BWSCS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 13:02:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.9] mac80211: fix monitor mode channel reporting
Date: Sat, 23 Feb 2013 19:02:14 +0100
Message-Id: <1361642534-39566-1-git-send-email-nbd@openwrt.org> (sfid-20130223_190223_309269_F3418739)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When not using channel contexts with only monitor mode interfaces being
active, report local->monitor_chandef to userspace.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 09d96a8..808f5fc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3285,13 +3285,19 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 				     struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	int ret = -ENODATA;
 
 	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (chanctx_conf) {
-		*chandef = chanctx_conf->def;
+	if (local->use_chanctx) {
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (chanctx_conf) {
+			*chandef = chanctx_conf->def;
+			ret = 0;
+		}
+	} else if (local->open_count == local->monitors) {
+		*chandef = local->monitor_chandef;
 		ret = 0;
 	}
 	rcu_read_unlock();
-- 
1.8.0.2

