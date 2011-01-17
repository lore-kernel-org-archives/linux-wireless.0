Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:14155 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1AQQUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:04 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 11:05:30 +0100
Subject: [PATCH 3/5] mac80211: add NOL functionality
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161133.792EB2082@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NOL is a list of channels on which radar interference has been detected.
Such channels are not allowed to be used for a certain amount of time.
---
 include/net/mac80211.h |    8 +++++
 net/mac80211/radar.c   |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/radar.h   |    9 ++++++
 3 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b158be5..4ebc080 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2773,6 +2773,14 @@ void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw);
 void ieee80211_radar_update_params(struct ieee80211_hw *hw,
 				   const struct ieee80211_regdomain *regd);
 
+/**
+ * ieee80211_radar_interference - report interference on a channel
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @channel: the channel on which the event occurred
+ */
+int ieee80211_radar_interference(struct ieee80211_hw *hw,
+				 struct ieee80211_channel *chan);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/radar.c b/net/mac80211/radar.c
index 9f41dd7..e90b8bf 100644
--- a/net/mac80211/radar.c
+++ b/net/mac80211/radar.c
@@ -15,6 +15,67 @@
 #include "driver-ops.h"
 #include "radar.h"
 
+static void nol_timer(unsigned long data)
+{
+	struct ieee80211_local *local = (void *) data;
+	struct ieee80211_radar *radar = &local->radar;
+	struct ieee80211_radar_nol_list *nol, *tmp;
+
+	list_for_each_entry_safe(nol, tmp, &radar->nol_list, list) {
+		if (time_is_before_jiffies(nol->timeout)) {
+			struct ieee80211_channel *chan = nol->chan;
+
+			printk(KERN_INFO "remove NOL chan %d\n",
+			       chan->center_freq);
+
+			mutex_lock(&radar->mtx);
+			chan->flags &= ~IEEE80211_CHAN_RADAR_INTERFERENCE;
+			list_del(&nol->list);
+			mutex_unlock(&radar->mtx);
+			kfree(nol);
+		}
+	}
+
+	mod_timer(&radar->nol_timer, jiffies + msecs_to_jiffies(1000));
+}
+
+int ieee80211_radar_interference(struct ieee80211_hw *hw,
+				 struct ieee80211_channel *chan)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_radar *radar = &local->radar;
+	struct ieee80211_radar_nol_list *nol, *tmp;
+
+	list_for_each_entry_safe(nol, tmp, &radar->nol_list, list) {
+		if (nol->chan == chan) {
+			mutex_lock(&radar->mtx);
+			list_del(&nol->list);
+			mutex_unlock(&radar->mtx);
+			kfree(nol);
+			break;
+		}
+	}
+
+	nol = kmalloc(sizeof(struct ieee80211_radar_nol_list), GFP_KERNEL);
+	if (nol == NULL)
+		return -ENOMEM;
+
+	nol->chan = chan;
+	nol->timeout = jiffies +
+		msecs_to_jiffies(radar->params->nol_period * 1000);
+
+	printk(KERN_INFO "add NOL chan %d\n", chan->center_freq);
+
+	mutex_lock(&radar->mtx);
+	chan->flags &= ~IEEE80211_CHAN_RADAR_CLEAR;
+	chan->flags |= IEEE80211_CHAN_RADAR_INTERFERENCE;
+	list_add_tail(&nol->list, &radar->nol_list);
+	mutex_unlock(&radar->mtx);
+
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_radar_interference);
+
 int ieee80211_radar_detection_enable(struct ieee80211_local *local,
 				     struct ieee80211_channel *chan)
 {
@@ -74,11 +135,24 @@ void ieee80211_radar_init(struct ieee80211_local *local)
 	radar->params = &regdomain_params[0];
 
 	mutex_init(&radar->mtx);
+
+	INIT_LIST_HEAD(&radar->nol_list);
+	setup_timer(&radar->nol_timer, nol_timer, (unsigned long)local);
+	mod_timer(&radar->nol_timer, jiffies + msecs_to_jiffies(1000));
 }
 
 void ieee80211_radar_deinit(struct ieee80211_local *local)
 {
 	struct ieee80211_radar *radar = &local->radar;
+	struct ieee80211_radar_nol_list *nol, *tmp;
+
+	del_timer_sync(&radar->nol_timer);
+	mutex_lock(&radar->mtx);
+	list_for_each_entry_safe(nol, tmp, &radar->nol_list, list) {
+		list_del(&nol->list);
+		kfree(nol);
+	}
+	mutex_unlock(&radar->mtx);
 
 	mutex_destroy(&radar->mtx);
 }
diff --git a/net/mac80211/radar.h b/net/mac80211/radar.h
index 6536e28..79684b5 100644
--- a/net/mac80211/radar.h
+++ b/net/mac80211/radar.h
@@ -21,9 +21,18 @@ struct ieee80211_radar_parameters {
 	int nol_period;
 };
 
+struct ieee80211_radar_nol_list {
+	struct ieee80211_channel *chan;
+	unsigned long timeout;
+	struct list_head list;
+};
+
 struct ieee80211_radar {
 	struct mutex mtx;
 	struct ieee80211_radar_parameters *params;
+
+	struct timer_list nol_timer;
+	struct list_head nol_list;
 };
 
 int ieee80211_radar_detection_enable(struct ieee80211_local *local,
-- 
1.5.6.5

