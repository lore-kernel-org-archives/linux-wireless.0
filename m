Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33303 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaGKACL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:11 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so5434364wib.2
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:02:10 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/14] wlcore: handle smart config vendor commands
Date: Fri, 11 Jul 2014 03:01:32 +0300
Message-Id: <1405036899-27396-8-git-send-email-eliad@wizery.com> (sfid-20140711_020215_132435_118BB7D4)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

userspace can ask to perform various smart config
actions via custom vendor commands.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/Makefile     |   2 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c | 184 ++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/vendor_cmd.h |  36 ++++++
 3 files changed, 221 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ti/wlcore/vendor_cmd.c
 create mode 100644 drivers/net/wireless/ti/wlcore/vendor_cmd.h

diff --git a/drivers/net/wireless/ti/wlcore/Makefile b/drivers/net/wireless/ti/wlcore/Makefile
index 4f23931..0a69c13 100644
--- a/drivers/net/wireless/ti/wlcore/Makefile
+++ b/drivers/net/wireless/ti/wlcore/Makefile
@@ -1,5 +1,5 @@
 wlcore-objs		= main.o cmd.o io.o event.o tx.o rx.o ps.o acx.o \
-			  boot.o init.o debugfs.o scan.o sysfs.o
+			  boot.o init.o debugfs.o scan.o sysfs.o vendor_cmd.o
 
 wlcore_spi-objs 	= spi.o
 wlcore_sdio-objs	= sdio.o
diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.c b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
new file mode 100644
index 0000000..98852b2
--- /dev/null
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
@@ -0,0 +1,184 @@
+/*
+ * This file is part of wlcore
+ *
+ * Copyright (C) 2014 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <net/mac80211.h>
+#include <net/netlink.h>
+
+#include "wlcore.h"
+#include "debug.h"
+#include "ps.h"
+#include "hw_ops.h"
+#include "vendor_cmd.h"
+
+static const
+struct nla_policy wlcore_vendor_attr_policy[NUM_WLCORE_VENDOR_ATTR] = {
+	[WLCORE_VENDOR_ATTR_FREQ]		= { .type = NLA_U32 },
+	[WLCORE_VENDOR_ATTR_GROUP_ID]		= { .type = NLA_U32 },
+	[WLCORE_VENDOR_ATTR_GROUP_KEY]		= { .type = NLA_U32,
+						    .len = WLAN_MAX_KEY_LEN },
+};
+
+static int
+wlcore_vendor_cmd_smart_config_start(struct wiphy *wiphy,
+				     struct wireless_dev *wdev,
+				     const void *data, int data_len)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct wl1271 *wl = hw->priv;
+	struct nlattr *tb[NUM_WLCORE_VENDOR_ATTR];
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "vendor cmd smart config start");
+
+	if (!data)
+		return -EINVAL;
+
+	ret = nla_parse(tb, MAX_WLCORE_VENDOR_ATTR, data, data_len,
+			wlcore_vendor_attr_policy);
+	if (ret)
+		return ret;
+
+	if (!tb[WLCORE_VENDOR_ATTR_GROUP_ID])
+		return -EINVAL;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_smart_config_start(wl,
+			nla_get_u32(tb[WLCORE_VENDOR_ATTR_GROUP_ID]));
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+
+	return 0;
+}
+
+static int
+wlcore_vendor_cmd_smart_config_stop(struct wiphy *wiphy,
+				    struct wireless_dev *wdev,
+				    const void *data, int data_len)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "testmode cmd smart config stop");
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_smart_config_stop(wl);
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static int
+wlcore_vendor_cmd_smart_config_set_group_key(struct wiphy *wiphy,
+					     struct wireless_dev *wdev,
+					     const void *data, int data_len)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct wl1271 *wl = hw->priv;
+	struct nlattr *tb[NUM_WLCORE_VENDOR_ATTR];
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "testmode cmd smart config set group key");
+
+	if (!data)
+		return -EINVAL;
+
+	ret = nla_parse(tb, MAX_WLCORE_VENDOR_ATTR, data, data_len,
+			wlcore_vendor_attr_policy);
+	if (ret)
+		return ret;
+
+	if (!tb[WLCORE_VENDOR_ATTR_GROUP_ID] ||
+	    !tb[WLCORE_VENDOR_ATTR_GROUP_KEY])
+		return -EINVAL;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_smart_config_set_group_key(wl,
+			nla_get_u32(tb[WLCORE_VENDOR_ATTR_GROUP_ID]),
+			nla_len(tb[WLCORE_VENDOR_ATTR_GROUP_KEY]),
+			nla_data(tb[WLCORE_VENDOR_ATTR_GROUP_KEY]));
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static const struct wiphy_vendor_command wlcore_vendor_commands[] = {
+	{
+		.info = {
+			.vendor_id = TI_OUI,
+			.subcmd = WLCORE_VENDOR_CMD_SMART_CONFIG_START,
+		},
+		.flags = WIPHY_VENDOR_CMD_NEED_NETDEV |
+			 WIPHY_VENDOR_CMD_NEED_RUNNING,
+		.doit = wlcore_vendor_cmd_smart_config_start,
+	},
+	{
+		.info = {
+			.vendor_id = TI_OUI,
+			.subcmd = WLCORE_VENDOR_CMD_SMART_CONFIG_STOP,
+		},
+		.flags = WIPHY_VENDOR_CMD_NEED_NETDEV |
+			 WIPHY_VENDOR_CMD_NEED_RUNNING,
+		.doit = wlcore_vendor_cmd_smart_config_stop,
+	},
+	{
+		.info = {
+			.vendor_id = TI_OUI,
+			.subcmd = WLCORE_VENDOR_CMD_SMART_CONFIG_SET_GROUP_KEY,
+		},
+		.flags = WIPHY_VENDOR_CMD_NEED_NETDEV |
+			 WIPHY_VENDOR_CMD_NEED_RUNNING,
+		.doit = wlcore_vendor_cmd_smart_config_set_group_key,
+	},
+};
+
+void wlcore_set_vendor_commands(struct wiphy *wiphy)
+{
+	wiphy->vendor_commands = wlcore_vendor_commands;
+	wiphy->n_vendor_commands = ARRAY_SIZE(wlcore_vendor_commands);
+}
diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.h b/drivers/net/wireless/ti/wlcore/vendor_cmd.h
new file mode 100644
index 0000000..7e8e92f
--- /dev/null
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.h
@@ -0,0 +1,36 @@
+/*
+ * This file is part of wlcore
+ *
+ * Copyright (C) 2014 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#ifndef __WLCORE_VENDOR_H__
+#define __WLCORE_VENDOR_H__
+
+#define TI_OUI	0x080028
+
+enum wlcore_vendor_commands {
+	WLCORE_VENDOR_CMD_SMART_CONFIG_START,
+	WLCORE_VENDOR_CMD_SMART_CONFIG_STOP,
+	WLCORE_VENDOR_CMD_SMART_CONFIG_SET_GROUP_KEY,
+
+	NUM_WLCORE_VENDOR_CMD,
+	MAX_WLCORE_VENDOR_CMD = NUM_WLCORE_VENDOR_CMD - 1
+};
+
+enum wlcore_vendor_attributes {
+	WLCORE_VENDOR_ATTR_FREQ,
+	WLCORE_VENDOR_ATTR_PSK,
+	WLCORE_VENDOR_ATTR_SSID,
+	WLCORE_VENDOR_ATTR_GROUP_ID,
+	WLCORE_VENDOR_ATTR_GROUP_KEY,
+
+	NUM_WLCORE_VENDOR_ATTR,
+	MAX_WLCORE_VENDOR_ATTR = NUM_WLCORE_VENDOR_ATTR - 1
+};
+
+#endif /* __WLCORE_VENDOR_H__ */
-- 
1.8.5.1.109.g3d252a9

