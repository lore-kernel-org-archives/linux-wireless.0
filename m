Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.techwires.net ([79.140.39.242]:27285 "EHLO mx.techwires.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab1AQQUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 11:20:05 -0500
In-Reply-To: <201101171621.29863.bernhard.schmidt@saxnet.de>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 17 Jan 2011 10:16:37 +0100
Subject: [PATCH 2/5] mac80211: initialize radar params + add driver API
Cc: <lrodriguez@atheros.com>, <nbd@openwrt.org>, <dubowoj@neratec.com>,
	<zefir.kurtisi@neratec.com>, <simon.wunderlich@saxnet.de>
Message-Id: <20110117161133.6EEA42080@mx.techwires.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- ieee80211_radar_update_params() can be used by drivers to update regdomain
  related parameters on regulatory changes.
- radar_detection is used to identify if a driver has support for radar
  detection or not. It is called when switching from and to a channel
  marked as radar detection required.
---
 include/net/mac80211.h      |   11 ++++++
 net/mac80211/Makefile       |    3 +-
 net/mac80211/cfg.c          |    5 +++
 net/mac80211/driver-ops.h   |   14 +++++++
 net/mac80211/driver-trace.h |   21 +++++++++++
 net/mac80211/ieee80211_i.h  |    3 ++
 net/mac80211/main.c         |    5 +++
 net/mac80211/radar.c        |   84 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/radar.h        |   36 ++++++++++++++++++
 9 files changed, 181 insertions(+), 1 deletions(-)
 create mode 100644 net/mac80211/radar.c
 create mode 100644 net/mac80211/radar.h

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 62c0ce2..b158be5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1767,6 +1767,8 @@ enum ieee80211_ampdu_mlme_action {
  *	ieee80211_remain_on_channel_expired(). This callback may sleep.
  * @cancel_remain_on_channel: Requests that an ongoing off-channel period is
  *	aborted before it expires. This callback may sleep.
+ *
+ * @radar_detection: Enable or disable radar detection on current channel.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1845,6 +1847,8 @@ struct ieee80211_ops {
 				 enum nl80211_channel_type channel_type,
 				 int duration);
 	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
+
+	int (*radar_detection)(struct ieee80211_hw *hw, int enable);
 };
 
 /**
@@ -2762,6 +2766,13 @@ void ieee80211_ready_on_channel(struct ieee80211_hw *hw);
  */
 void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw);
 
+/**
+ * ieee80211_radar_update_params - update regdomain related radar parameteters
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ */
+void ieee80211_radar_update_params(struct ieee80211_hw *hw,
+				   const struct ieee80211_regdomain *regd);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index fdb54e6..deff05b 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -24,7 +24,8 @@ mac80211-y := \
 	util.o \
 	wme.o \
 	event.o \
-	chan.o
+	chan.o \
+	radar.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4bc8a92..a6a2c0b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -18,6 +18,7 @@
 #include "cfg.h"
 #include "rate.h"
 #include "mesh.h"
+#include "radar.h"
 
 static struct net_device *ieee80211_add_iface(struct wiphy *wiphy, char *name,
 					      enum nl80211_iftype type,
@@ -1232,6 +1233,8 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 		break;
 	}
 
+	ieee80211_radar_detection_disable(local, local->oper_channel);
+
 	local->oper_channel = chan;
 
 	if (!ieee80211_set_channel_type(local, sdata, channel_type))
@@ -1241,6 +1244,8 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
 
+	ieee80211_radar_detection_enable(local, chan);
+
 	return 0;
 }
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 98d5899..b8bcf46 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -495,4 +495,18 @@ static inline int drv_cancel_remain_on_channel(struct ieee80211_local *local)
 	return ret;
 }
 
+static inline int drv_radar_detection(struct ieee80211_local *local, int enable)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	trace_drv_radar_detection(local, enable);
+	if (local->ops->radar_detection)
+		ret = local->ops->radar_detection(&local->hw, enable);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 49c8421..09cd205 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1250,6 +1250,27 @@ TRACE_EVENT(api_remain_on_channel_expired,
 	)
 );
 
+TRACE_EVENT(drv_radar_detection,
+	TP_PROTO(struct ieee80211_local *local, int enable),
+
+	TP_ARGS(local, enable),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, enable)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->enable = enable;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " enable:%d",
+		LOCAL_PR_ARG, __entry->enable
+	)
+);
+
 /*
  * Tracing for internal functions
  * (which may also be called in response to driver calls)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..5c46b14 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -29,6 +29,7 @@
 #include <net/mac80211.h>
 #include "key.h"
 #include "sta_info.h"
+#include "radar.h"
 
 struct ieee80211_local;
 
@@ -929,6 +930,8 @@ struct ieee80211_local {
 	struct notifier_block network_latency_notifier;
 	struct notifier_block ifa_notifier;
 
+	struct ieee80211_radar radar;
+
 	/*
 	 * The dynamic ps timeout configured from user space via WEXT -
 	 * this will override whatever chosen by mac80211 internally.
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a46ff06..5841920 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -32,6 +32,7 @@
 #include "led.h"
 #include "cfg.h"
 #include "debugfs.h"
+#include "radar.h"
 
 
 bool ieee80211_disable_40mhz_24ghz;
@@ -621,6 +622,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	ieee80211_hw_roc_setup(local);
 
+	ieee80211_radar_init(local);
+
 	return local_to_hw(local);
 }
 EXPORT_SYMBOL(ieee80211_alloc_hw);
@@ -891,6 +894,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	ieee80211_radar_deinit(local);
+
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
 
diff --git a/net/mac80211/radar.c b/net/mac80211/radar.c
new file mode 100644
index 0000000..9f41dd7
--- /dev/null
+++ b/net/mac80211/radar.c
@@ -0,0 +1,84 @@
+/*
+ * Radar handling
+ *
+ * Copyright 2011 Bernhard Schmidt <bernhard.schmidt@saxnet.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <net/mac80211.h>
+#include <net/rtnetlink.h>
+
+#include "ieee80211_i.h"
+#include "driver-ops.h"
+#include "radar.h"
+
+int ieee80211_radar_detection_enable(struct ieee80211_local *local,
+				     struct ieee80211_channel *chan)
+{
+	int ret = 0;
+
+	if ((chan->flags & IEEE80211_CHAN_RADAR))
+		ret = drv_radar_detection(local, 1);
+
+	return ret;
+}
+
+int ieee80211_radar_detection_disable(struct ieee80211_local *local,
+				      struct ieee80211_channel *chan)
+{
+	int ret = 0;
+
+	if ((chan->flags & IEEE80211_CHAN_RADAR))
+		ret = drv_radar_detection(local, 0);
+
+	return ret;
+}
+
+static struct ieee80211_radar_parameters regdomain_params[] = {
+	{ .cac_period = 60, .nol_period = 1800 },	/* FCC, correct? */
+	{ .cac_period = 60, .nol_period = 1800 },	/* ETSI */
+	{ .cac_period = 60, .nol_period = 1800 },	/* JP, correct? */
+};
+
+void ieee80211_radar_update_params(struct ieee80211_hw *hw,
+				   const struct ieee80211_regdomain *regd)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_radar *radar = &local->radar;
+
+	switch (regd->flags & NL80211_CFLAG_ALL_DFS_FLAGS) {
+	case NL80211_CFLAG_DFS_ETSI:
+		radar->params = &regdomain_params[1];
+		break;
+	case NL80211_CFLAG_DFS_JP:
+		radar->params = &regdomain_params[2];
+		break;
+	default:
+		radar->params = &regdomain_params[0];
+		break;
+	}
+}
+EXPORT_SYMBOL(ieee80211_radar_update_params);
+
+void ieee80211_radar_init(struct ieee80211_local *local)
+{
+	struct ieee80211_radar *radar = &local->radar;
+
+	/*
+	 * NB: use FCC by default, will be updated later once regulatory
+	 *     information are available.
+	 */
+	radar->params = &regdomain_params[0];
+
+	mutex_init(&radar->mtx);
+}
+
+void ieee80211_radar_deinit(struct ieee80211_local *local)
+{
+	struct ieee80211_radar *radar = &local->radar;
+
+	mutex_destroy(&radar->mtx);
+}
diff --git a/net/mac80211/radar.h b/net/mac80211/radar.h
new file mode 100644
index 0000000..6536e28
--- /dev/null
+++ b/net/mac80211/radar.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright 2011 Bernhard Schmidt <bernhard.schmidt@saxnet.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef RADAR_H
+#define RADAR_H
+
+/*
+ * Regdomain related parameters.
+ */
+struct ieee80211_radar_parameters {
+
+	/* Time in seconds for a CAC period. */
+	int cac_period;
+
+	/* Time in seconds a channel is on the no operations list. */
+	int nol_period;
+};
+
+struct ieee80211_radar {
+	struct mutex mtx;
+	struct ieee80211_radar_parameters *params;
+};
+
+int ieee80211_radar_detection_enable(struct ieee80211_local *local,
+				     struct ieee80211_channel *chan);
+int ieee80211_radar_detection_disable(struct ieee80211_local *local,
+				      struct ieee80211_channel *chan);
+void ieee80211_radar_init(struct ieee80211_local *local);
+void ieee80211_radar_deinit(struct ieee80211_local *local);
+
+#endif
-- 
1.5.6.5

