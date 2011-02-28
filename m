Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52743 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1B1Qtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:49:50 -0500
Received: by eyx24 with SMTP id 24so1359025eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:49:48 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/9] [cfg80211] add preliminary radar processing code
Date: Mon, 28 Feb 2011 17:48:49 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281748.50054.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 net/wireless/Makefile |    2 +-
 net/wireless/core.c   |    6 +++
 net/wireless/radar.c  |   86 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/radar.h  |   48 +++++++++++++++++++++++++++
 net/wireless/reg.c    |    2 +
 5 files changed, 143 insertions(+), 1 deletions(-)
 create mode 100644 net/wireless/radar.c
 create mode 100644 net/wireless/radar.h

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 55a28ab..2d29d06 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_WEXT_SPY) += wext-spy.o
 obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
-cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o
+cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o radar.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
diff --git a/net/wireless/core.c b/net/wireless/core.c
index fe01de2..55984ca 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -26,6 +26,7 @@
 #include "debugfs.h"
 #include "wext-compat.h"
 #include "ethtool.h"
+#include "radar.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -912,6 +913,9 @@ static int __init cfg80211_init(void)
 	if (err)
 		goto out_fail_reg;
 
+	radar_init();
+	radar_debugfs_add(ieee80211_debugfs_dir);
+
 	cfg80211_wq = create_singlethread_workqueue("cfg80211");
 	if (!cfg80211_wq)
 		goto out_fail_wq;
@@ -935,7 +939,9 @@ subsys_initcall(cfg80211_init);
 
 static void __exit cfg80211_exit(void)
 {
+	radar_debugfs_remove();
 	debugfs_remove(ieee80211_debugfs_dir);
+	radar_deinit();
 	nl80211_exit();
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 	wiphy_sysfs_exit();
diff --git a/net/wireless/radar.c b/net/wireless/radar.c
new file mode 100644
index 0000000..779fd8c
--- /dev/null
+++ b/net/wireless/radar.c
@@ -0,0 +1,86 @@
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
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include "radar.h"
+
+static struct radar_parameters regdomain_params[] = {
+	{ 60, 1800, 1000 },	/* FCC, correct? */
+	{ 60, 1800, 1000 },	/* ETSI */
+	{ 60, 1800, 1000 },	/* JP, correct? */
+};
+
+static struct radar radar;
+
+void radar_update_params(u8 dfs_region)
+{
+	mutex_lock(&radar.lock);
+	switch (dfs_region) {
+	case NL80211_CFLAG_DFS_ETSI:
+		radar.params = &regdomain_params[1];
+		break;
+	case NL80211_CFLAG_DFS_JP:
+		radar.params = &regdomain_params[2];
+		break;
+	default:
+		radar.params = &regdomain_params[0];
+		break;
+	}
+	mutex_unlock(&radar.lock);
+}
+
+static void radar_timer(unsigned long data)
+{
+}
+
+void radar_init(void)
+{
+	/*
+	 * NB: use FCC by default, will be updated later once regulatory
+	 *     information are available.
+	 */
+	radar.params = &regdomain_params[0];
+
+	mutex_init(&radar.lock);
+	setup_timer(&radar.timer, radar_timer, (unsigned long)0);
+}
+
+void radar_deinit(void)
+{
+	del_timer_sync(&radar.timer);
+	mutex_destroy(&radar.lock);
+}
+
+#ifdef CONFIG_CFG80211_DEBUGFS
+
+static int radar_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static struct dentry *radar_debugfs_dir;
+
+#define DEBUGFS_ADD(name)						\
+	debugfs_create_file(#name, S_IRUGO, radar_debugfs_dir, NULL,	\
+			    &name## _ops);
+
+void radar_debugfs_add(struct dentry *ieee80211_debugfs_dir)
+{
+	radar_debugfs_dir = debugfs_create_dir("radar", ieee80211_debugfs_dir);
+}
+
+void radar_debugfs_remove()
+{
+	debugfs_remove_recursive(radar_debugfs_dir);
+}
+
+#endif
diff --git a/net/wireless/radar.h b/net/wireless/radar.h
new file mode 100644
index 0000000..053ceb6
--- /dev/null
+++ b/net/wireless/radar.h
@@ -0,0 +1,48 @@
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
+struct radar_parameters {
+
+	/* Time in seconds for a CAC period. */
+	int cac_period;
+
+	/* Time in seconds a channel is on the no operations list. */
+	int nol_period;
+
+	/*
+	 * Time in ms after which a channel must be closed (=no transmission)
+	 * when interference has been detected.
+	 */
+	int close_time;
+};
+
+struct radar {
+	struct radar_parameters *params;
+	struct mutex lock;
+	struct timer_list timer;
+};
+
+void radar_update_params(u8 dfs_region);
+void radar_init(void);
+void radar_deinit(void);
+
+#ifdef CONFIG_CFG80211_DEBUGFS
+void radar_debugfs_add(struct dentry *ieee80211_debugfs_dir);
+void radar_debugfs_remove(void);
+#else
+static inline void radar_debugfs_add(struct dentry *ieee80211_debugfs_dir) {}
+static inline void radar_debugfs_remove() {}
+#endif
+
+#endif
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1f1312f..ca76b8d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -47,6 +47,7 @@
 #include "reg.h"
 #include "regdb.h"
 #include "nl80211.h"
+#include "radar.h"
 
 #ifdef CONFIG_CFG80211_REG_DEBUG
 #define REG_DBG_PRINT(format, args...) \
@@ -1140,6 +1141,7 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
 out:
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
+	radar_update_params(last_request->dfs_region);
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, last_request);
 }
-- 
1.7.2.3
