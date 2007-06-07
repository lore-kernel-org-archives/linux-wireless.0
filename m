Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50901 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765854AbXFGUWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 16:22:04 -0400
Date: Thu, 7 Jun 2007 22:22:10 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: rc80211_lowest, a dumb rate control algorithm
Message-ID: <20070607222210.1a445cd7@griffin.suse.cz>
In-Reply-To: <20070607222113.0f752bf8@griffin.suse.cz>
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
	<20070607221939.444e9d74@griffin.suse.cz>
	<20070607222113.0f752bf8@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows the lowest rate to be used all time.

To switch to this algorithm:
echo -n lowest > {your_debugfs_mount_point}/ieee80211/phy?/rate_ctrl_alg

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/Makefile         |    2 
 net/mac80211/rc80211_lowest.c |  105 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+), 1 deletion(-)

--- mac80211-dev.orig/net/mac80211/Makefile
+++ mac80211-dev/net/mac80211/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
+obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o rc80211_lowest.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
 mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
--- /dev/null
+++ mac80211-dev/net/mac80211/rc80211_lowest.c
@@ -0,0 +1,105 @@
+/*
+ * Copyright 2002-2005, Instant802 Networks, Inc.
+ * Copyright 2005, Devicescape Software, Inc.
+ * Copyright (c) 2006-2007 Jiri Benc <jbenc@suse.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/netdevice.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/compiler.h>
+
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+#include "ieee80211_rate.h"
+#include "debugfs.h"
+
+static void rate_control_lowest_tx_status(void *priv, struct net_device *dev,
+					  struct sk_buff *skb,
+					  struct ieee80211_tx_status *status)
+{
+}
+
+static struct ieee80211_rate *
+rate_control_lowest_get_rate(void *priv, struct net_device *dev,
+			     struct sk_buff *skb,
+			     struct rate_control_extra *extra)
+{
+	struct ieee80211_hw_mode *mode = extra->mode;
+	int i;
+
+	for (i = 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *rate = &mode->rates[i];
+
+		if (rate->flags & IEEE80211_RATE_SUPPORTED)
+			return rate;
+	}
+	return &mode->rates[0];
+}
+
+static void rate_control_lowest_rate_init(void *priv, void *priv_sta,
+					  struct ieee80211_local *local,
+					  struct sta_info *sta)
+{
+	sta->txrate = 0;
+}
+
+static void *rate_control_lowest_alloc(struct ieee80211_local *local)
+{
+	return local;
+}
+
+static void rate_control_lowest_free(void *priv)
+{
+}
+
+static void rate_control_lowest_clear(void *priv)
+{
+}
+
+static void *rate_control_lowest_alloc_sta(void *priv, gfp_t gfp)
+{
+	return priv;
+}
+
+static void rate_control_lowest_free_sta(void *priv, void *priv_sta)
+{
+}
+
+static struct rate_control_ops rate_control_lowest = {
+	.module = THIS_MODULE,
+	.name = "lowest",
+	.tx_status = rate_control_lowest_tx_status,
+	.get_rate = rate_control_lowest_get_rate,
+	.rate_init = rate_control_lowest_rate_init,
+	.clear = rate_control_lowest_clear,
+	.alloc = rate_control_lowest_alloc,
+	.free = rate_control_lowest_free,
+	.alloc_sta = rate_control_lowest_alloc_sta,
+	.free_sta = rate_control_lowest_free_sta,
+};
+
+static int __init rate_control_lowest_init(void)
+{
+	return ieee80211_rate_control_register(&rate_control_lowest);
+}
+
+
+static void __exit rate_control_lowest_exit(void)
+{
+	ieee80211_rate_control_unregister(&rate_control_lowest);
+}
+
+
+module_init(rate_control_lowest_init);
+module_exit(rate_control_lowest_exit);
+
+MODULE_DESCRIPTION("Forced 1 mbps rate control module for mac80211");
+MODULE_LICENSE("GPL");


-- 
Jiri Benc
SUSE Labs
