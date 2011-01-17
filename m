Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:27287 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1AQQUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:05 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 11:24:54 +0100
Subject: [PATCH 4/5] mac80211: add primarily CAC support
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161133.8150D2084@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 net/mac80211/radar.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/radar.h |    4 +++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/radar.c b/net/mac80211/radar.c
index e90b8bf..afb2ae1 100644
--- a/net/mac80211/radar.c
+++ b/net/mac80211/radar.c
@@ -15,6 +15,66 @@
 #include "driver-ops.h"
 #include "radar.h"
 
+static void cac_timer(unsigned long data)
+{
+	struct ieee80211_local *local = (void *) data;
+	struct ieee80211_radar *radar = &local->radar;
+	struct ieee80211_channel *chan;
+
+	printk(KERN_INFO "CAC done\n");
+
+	chan = local->oper_channel;
+	mutex_lock(&radar->mtx);
+	if ((chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE) == 0) {
+		chan->flags |= IEEE80211_CHAN_RADAR_CLEAR;
+	}
+	radar->cac = 0;
+	mutex_unlock(&radar->mtx);
+}
+
+int ieee80211_radar_cac(struct wiphy *wiphy, int enable)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_radar *radar = &local->radar;
+	struct ieee80211_channel *chan = local->oper_channel;
+	int ret;
+
+	ret = ieee80211_radar_detection_enable(local, chan);
+	if (ret != 0)
+		return ret;
+
+	if (!enable && !radar->cac)
+		return -EINVAL;
+	if (!enable && radar->cac) {
+		printk(KERN_INFO "stopping CAC\n");
+
+		del_timer_sync(&radar->cac_timer);
+		mutex_lock(&radar->mtx);
+		radar->cac = 0;
+		mutex_unlock(&radar->mtx);
+		return 0;
+	}
+	if (enable) {
+		if ((chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE))
+			return -EINVAL;
+
+		printk(KERN_INFO "starting CAC\n");
+
+		del_timer_sync(&radar->cac_timer);
+		mutex_lock(&radar->mtx);
+		if ((chan->flags & IEEE80211_CHAN_RADAR) &&
+		    (chan->flags & IEEE80211_CHAN_RADAR_CLEAR)) {
+			chan->flags &= ~IEEE80211_CHAN_RADAR_CLEAR;
+		}
+		radar->cac = 1;
+		mutex_unlock(&radar->mtx);
+		mod_timer(&radar->cac_timer, jiffies +
+			  msecs_to_jiffies(radar->params->cac_period * 1000));
+	}
+
+	return 0;
+}
+
 static void nol_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
@@ -136,6 +196,9 @@ void ieee80211_radar_init(struct ieee80211_local *local)
 
 	mutex_init(&radar->mtx);
 
+	radar->cac = 0;
+	setup_timer(&radar->cac_timer, cac_timer, (unsigned long)local);
+
 	INIT_LIST_HEAD(&radar->nol_list);
 	setup_timer(&radar->nol_timer, nol_timer, (unsigned long)local);
 	mod_timer(&radar->nol_timer, jiffies + msecs_to_jiffies(1000));
@@ -146,6 +209,8 @@ void ieee80211_radar_deinit(struct ieee80211_local *local)
 	struct ieee80211_radar *radar = &local->radar;
 	struct ieee80211_radar_nol_list *nol, *tmp;
 
+	del_timer_sync(&radar->cac_timer);
+
 	del_timer_sync(&radar->nol_timer);
 	mutex_lock(&radar->mtx);
 	list_for_each_entry_safe(nol, tmp, &radar->nol_list, list) {
diff --git a/net/mac80211/radar.h b/net/mac80211/radar.h
index 79684b5..6e8bc36 100644
--- a/net/mac80211/radar.h
+++ b/net/mac80211/radar.h
@@ -31,10 +31,14 @@ struct ieee80211_radar {
 	struct mutex mtx;
 	struct ieee80211_radar_parameters *params;
 
+	int cac;
+	struct timer_list cac_timer;
+
 	struct timer_list nol_timer;
 	struct list_head nol_list;
 };
 
+int ieee80211_radar_cac(struct wiphy *wiphy, int enable);
 int ieee80211_radar_detection_enable(struct ieee80211_local *local,
 				     struct ieee80211_channel *chan);
 int ieee80211_radar_detection_disable(struct ieee80211_local *local,
-- 
1.5.6.5

