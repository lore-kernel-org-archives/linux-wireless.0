Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:48472 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbZLUMhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 07:37:12 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nBLCant9014403
	for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 14:37:09 +0200
Received: from [127.0.1.1] (trdhcp21540.nmp.nokia.com [172.22.215.40])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nBLCaVZL016449
	for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 14:36:32 +0200
Subject: [RFC PATCH] wl1271: add testmode support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 21 Dec 2009 14:36:32 +0200
Message-ID: <20091221123632.18850.74951.stgit@tikku>
In-Reply-To: <20091221120745.18850.67739.stgit@tikku>
References: <20091221120745.18850.67739.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Testmode will be used to send PLT (Production Line Testing) commands
from user space.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/Makefile          |    1 
 drivers/net/wireless/wl12xx/wl1271.h          |    2 
 drivers/net/wireless/wl12xx/wl1271_main.c     |    2 
 drivers/net/wireless/wl12xx/wl1271_testmode.c |  305 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_testmode.h |   31 +++
 5 files changed, 340 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_testmode.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_testmode.h

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 62e37ad..d089b5d 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -11,4 +11,5 @@ wl1271-objs		= wl1271_main.o  wl1271_spi.o wl1271_cmd.o  \
 			  wl1271_event.o wl1271_tx.o  wl1271_rx.o   \
 			  wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
 			  wl1271_init.o  wl1271_debugfs.o
+wl1271-$(CONFIG_NL80211_TESTMODE)	+= wl1271_testmode.o
 obj-$(CONFIG_WL1271)	+= wl1271.o
diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index d0938db..5f2f9f6 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -43,7 +43,7 @@ enum {
 	DEBUG_SPI	= BIT(1),
 	DEBUG_BOOT	= BIT(2),
 	DEBUG_MAILBOX	= BIT(3),
-	DEBUG_NETLINK	= BIT(4),
+	DEBUG_TESTMODE	= BIT(4),
 	DEBUG_EVENT	= BIT(5),
 	DEBUG_TX	= BIT(6),
 	DEBUG_RX	= BIT(7),
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index bc882c9..b33188a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -46,6 +46,7 @@
 #include "wl1271_debugfs.h"
 #include "wl1271_cmd.h"
 #include "wl1271_boot.h"
+#include "wl1271_testmode.h"
 
 #define WL1271_BOOT_RETRIES 3
 
@@ -1877,6 +1878,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.hw_scan = wl1271_op_hw_scan,
 	.bss_info_changed = wl1271_op_bss_info_changed,
 	.set_rts_threshold = wl1271_op_set_rts_threshold,
+	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
 };
 
 static int wl1271_register_hw(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/wl1271_testmode.c b/drivers/net/wireless/wl12xx/wl1271_testmode.c
new file mode 100644
index 0000000..453f767
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_testmode.c
@@ -0,0 +1,305 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#include "wl1271_testmode.h"
+
+#include <net/genetlink.h>
+
+#include "wl1271.h"
+#include "wl1271_spi.h"
+#include "wl1271_acx.h"
+
+#define WL1271_TM_MAX_DATA_LENGTH 1024
+
+enum wl1271_tm_commands {
+	WL1271_TM_CMD_UNSPEC,
+	WL1271_TM_CMD_TEST,
+	WL1271_TM_CMD_INTERROGATE,
+	WL1271_TM_CMD_CONFIGURE,
+	WL1271_TM_CMD_NVS_PUSH,
+	WL1271_TM_CMD_SET_PLT_MODE,
+
+	__WL1271_TM_CMD_AFTER_LAST
+};
+#define WL1271_TM_CMD_MAX (__WL1271_TM_CMD_AFTER_LAST - 1)
+
+enum wl1271_tm_attrs {
+	WL1271_TM_ATTR_UNSPEC,
+	WL1271_TM_ATTR_CMD_ID,
+	WL1271_TM_ATTR_ANSWER,
+	WL1271_TM_ATTR_DATA,
+	WL1271_TM_ATTR_IE_ID,
+	WL1271_TM_ATTR_PLT_MODE,
+
+	__WL1271_TM_ATTR_AFTER_LAST
+};
+#define WL1271_TM_ATTR_MAX (__WL1271_TM_ATTR_AFTER_LAST - 1)
+
+static struct nla_policy wl1271_tm_policy[WL1271_TM_ATTR_MAX + 1] = {
+	[WL1271_TM_ATTR_CMD_ID] =	{ .type = NLA_U32 },
+	[WL1271_TM_ATTR_ANSWER] =	{ .type = NLA_U8 },
+	[WL1271_TM_ATTR_DATA] =		{ .type = NLA_BINARY,
+					  .len = WL1271_TM_MAX_DATA_LENGTH },
+	[WL1271_TM_ATTR_IE_ID] =	{ .type = NLA_U32 },
+	[WL1271_TM_ATTR_PLT_MODE] =	{ .type = NLA_U32 },
+};
+
+
+static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
+{
+	int buf_len, ret, len;
+	struct wl1271_command *cmd;
+	struct sk_buff *skb;
+	char *buf;
+	u8 answer = 0;
+
+	wl1271_debug(DEBUG_TESTMODE, "testmode cmd test");
+
+	if (!tb[WL1271_TM_ATTR_DATA])
+		return -EINVAL;
+
+	buf = nla_data(tb[WL1271_TM_ATTR_DATA]);
+	buf_len = nla_len(tb[WL1271_TM_ATTR_DATA]);
+
+	if (tb[WL1271_TM_ATTR_ANSWER])
+		answer = nla_get_u8(tb[WL1271_TM_ATTR_ANSWER]);
+
+	if (buf_len > sizeof(*cmd))
+		return -EMSGSIZE;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	/* copy the buffer to make it work with dma */
+	memcpy(cmd, buf, buf_len);
+
+	mutex_lock(&wl->mutex);
+	ret = wl1271_cmd_test(wl, cmd, buf_len, answer);
+	mutex_unlock(&wl->mutex);
+
+	if (ret < 0) {
+		wl1271_warning("testmode cmd test failed: %d", ret);
+		return ret;
+	}
+
+	if (answer) {
+		len = nla_total_size(buf_len);
+		skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, len);
+		if (!skb)
+			return -ENOMEM;
+
+		NLA_PUT(skb, WL1271_TM_ATTR_DATA, buf_len, cmd);
+		ret = cfg80211_testmode_reply(skb);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+
+nla_put_failure:
+	kfree_skb(skb);
+	return -EMSGSIZE;
+}
+
+static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
+{
+	int ret;
+	struct wl1271_command *cmd;
+	struct sk_buff *skb;
+	u8 ie_id;
+
+	wl1271_debug(DEBUG_TESTMODE, "testmode cmd interrogate");
+
+	if (!tb[WL1271_TM_ATTR_IE_ID])
+		return -EINVAL;
+
+	ie_id = nla_get_u8(tb[WL1271_TM_ATTR_IE_ID]);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	mutex_lock(&wl->mutex);
+	ret = wl1271_cmd_interrogate(wl, ie_id, cmd, sizeof(*cmd));
+	mutex_unlock(&wl->mutex);
+
+	if (ret < 0) {
+		wl1271_warning("testmode cmd interrogate failed: %d", ret);
+		return ret;
+	}
+
+	skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	NLA_PUT(skb, WL1271_TM_ATTR_DATA, sizeof(*cmd), cmd);
+
+	return 0;
+
+nla_put_failure:
+	kfree_skb(skb);
+	return -EMSGSIZE;
+}
+
+static int wl1271_tm_cmd_configure(struct wl1271 *wl, struct nlattr *tb[])
+{
+	int buf_len, ret;
+	struct wl1271_command *cmd;
+	char *buf;
+	u8 ie_id;
+
+	wl1271_debug(DEBUG_TESTMODE, "testmode cmd configure");
+
+	if (!tb[WL1271_TM_ATTR_DATA])
+		return -EINVAL;
+	if (!tb[WL1271_TM_ATTR_IE_ID])
+		return -EINVAL;
+
+	ie_id = nla_get_u8(tb[WL1271_TM_ATTR_IE_ID]);
+	buf = nla_data(tb[WL1271_TM_ATTR_DATA]);
+	buf_len = nla_len(tb[WL1271_TM_ATTR_DATA]);
+
+	if (buf_len > sizeof(*cmd))
+		return -EMSGSIZE;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	/* copy the buffer to make it work with dma */
+	memcpy(cmd, buf, buf_len);
+
+	mutex_lock(&wl->mutex);
+	ret = wl1271_cmd_configure(wl, ie_id, cmd, buf_len);
+	mutex_unlock(&wl->mutex);
+
+	if (ret < 0) {
+		wl1271_warning("testmode cmd configure failed: %d", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int wl1271_tm_cmd_nvs_push(struct wl1271 *wl, struct nlattr *tb[])
+{
+	int ret = 0, len;
+	void *buf;
+
+	wl1271_debug(DEBUG_TESTMODE, "testmode cmd nvs push");
+
+	if (!tb[WL1271_TM_ATTR_DATA])
+		return -EINVAL;
+
+	len = nla_len(tb[WL1271_TM_ATTR_DATA]);
+
+	if (len % 4) {
+		wl1271_warning("NVS size is not multiple of 32: %d", len);
+		ret = -EILSEQ;
+		goto out;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	wl->nvs_len = len;
+
+	/* If we already have an NVS, we should free it */
+	kfree(wl->nvs);
+
+	buf = kzalloc(wl->nvs_len, GFP_KERNEL);
+
+	if (!buf) {
+		wl1271_warning("can't allocate nvs in testmode");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* If we already have an NVS, we should free it */
+	kfree(wl->nvs);
+
+	wl->nvs = buf;
+	memcpy(wl->nvs, nla_data(tb[WL1271_TM_ATTR_DATA]), wl->nvs_len);
+
+	wl1271_debug(DEBUG_TESTMODE, "testmode push nvs (%d B)", wl->nvs_len);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static int wl1271_tm_cmd_set_plt_mode(struct wl1271 *wl, struct nlattr *tb[])
+{
+	u32 val;
+	int ret;
+
+	wl1271_debug(DEBUG_TESTMODE, "testmode cmd set plt mode");
+
+	if (!tb[WL1271_TM_ATTR_PLT_MODE])
+		return -EINVAL;
+
+	val = nla_get_u32(tb[WL1271_TM_ATTR_PLT_MODE]);
+
+	switch (val) {
+	case 0:
+		ret = wl1271_plt_stop(wl);
+		break;
+	case 1:
+		ret = wl1271_plt_start(wl);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
+{
+	struct wl1271 *wl = hw->priv;
+	struct nlattr *tb[WL1271_TM_ATTR_MAX + 1];
+	int err;
+
+	err = nla_parse(tb, WL1271_TM_ATTR_MAX, data, len, wl1271_tm_policy);
+	if (err)
+		return err;
+
+	if (!tb[WL1271_TM_ATTR_CMD_ID])
+		return -EINVAL;
+
+	switch (nla_get_u32(tb[WL1271_TM_ATTR_CMD_ID])) {
+	case WL1271_TM_CMD_TEST:
+		return wl1271_tm_cmd_test(wl, tb);
+	case WL1271_TM_CMD_INTERROGATE:
+		return wl1271_tm_cmd_interrogate(wl, tb);
+	case WL1271_TM_CMD_CONFIGURE:
+		return wl1271_tm_cmd_configure(wl, tb);
+	case WL1271_TM_CMD_NVS_PUSH:
+		return wl1271_tm_cmd_nvs_push(wl, tb);
+	case WL1271_TM_CMD_SET_PLT_MODE:
+		return wl1271_tm_cmd_set_plt_mode(wl, tb);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_testmode.h b/drivers/net/wireless/wl12xx/wl1271_testmode.h
new file mode 100644
index 0000000..f3ce4b8
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_testmode.h
@@ -0,0 +1,31 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL1271_TESTMODE_H__
+#define __WL1271_TESTMODE_H__
+
+#include <net/mac80211.h>
+
+int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len);
+
+#endif /* __WL1271_TESTMODE_H__ */

