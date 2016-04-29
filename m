Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:7443 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbcD2P7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2016 11:59:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3TFuYlS001608
	for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2016 08:58:59 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 22kj4xxuh3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2016 08:58:59 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: handle edmac vendor command
Date: Fri, 29 Apr 2016 08:58:03 -0700
Message-ID: <1461945483-3239-1-git-send-email-akarwar@marvell.com> (sfid-20160429_175906_796060_FCBF082F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

Userspace can configure edmac values through a custom vendor
command. They will be used by hardware for adaptivity.

Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/Makefile   |  1 +
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  2 +
 drivers/net/wireless/marvell/mwifiex/main.h     |  4 ++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c  | 20 ++++++---
 drivers/net/wireless/marvell/mwifiex/vendor.c   | 59 +++++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/vendor.h   | 27 +++++++++++
 6 files changed, 108 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wireless/marvell/mwifiex/vendor.c
 create mode 100644 drivers/net/wireless/marvell/mwifiex/vendor.h

diff --git a/drivers/net/wireless/marvell/mwifiex/Makefile b/drivers/net/wireless/marvell/mwifiex/Makefile
index fdfd9bf..8b34ce9 100644
--- a/drivers/net/wireless/marvell/mwifiex/Makefile
+++ b/drivers/net/wireless/marvell/mwifiex/Makefile
@@ -42,6 +42,7 @@ mwifiex-y += cfg80211.o
 mwifiex-y += ethtool.o
 mwifiex-y += 11h.o
 mwifiex-y += tdls.o
+mwifiex-y += vendor.o
 mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_MWIFIEX) += mwifiex.o
 
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index ff948a9..00aca7e 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4118,6 +4118,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	if (adapter->fw_api_ver == MWIFIEX_FW_V15)
 		wiphy->features |= NL80211_FEATURE_SK_TX_STATUS;
 
+	marvell_set_vendor_commands(wiphy);
+
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 0207af0..66ba5c0 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1002,6 +1002,8 @@ struct mwifiex_adapter {
 	bool usb_mc_status;
 	bool usb_mc_setup;
 	struct cfg80211_wowlan_nd_info *nd_info;
+	u8 *cfg_data;
+	int cfg_len;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
@@ -1614,6 +1616,8 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 				      struct sk_buff *event_skb);
 void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter);
 
+void marvell_set_vendor_commands(struct wiphy *wiphy);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index e436574..6b8cc39 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1487,9 +1487,10 @@ static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct property *prop = data_buf;
-	u32 len;
+	u32 len = 0;
 	u8 *data = (u8 *)cmd + S_DS_GEN;
 	int ret;
+	const struct firmware *cal_data = adapter->cal_data;
 
 	if (prop) {
 		len = prop->length;
@@ -1500,11 +1501,20 @@ static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
 		mwifiex_dbg(adapter, INFO,
 			    "download cfg_data from device tree: %s\n",
 			    prop->name);
-	} else if (adapter->cal_data->data && adapter->cal_data->size > 0) {
-		len = mwifiex_parse_cal_cfg((u8 *)adapter->cal_data->data,
-					    adapter->cal_data->size, data);
+	} else if (cal_data) {
+		if (cal_data->data && cal_data->size > 0) {
+			len = mwifiex_parse_cal_cfg((u8 *)cal_data->data,
+						    cal_data->size, data);
+			mwifiex_dbg(adapter, INFO,
+				    "download cfg_data from config file\n");
+		} else {
+			return -1;
+		}
+	} else if (adapter->cfg_data && adapter->cfg_len > 0) {
+		len = mwifiex_parse_cal_cfg(adapter->cfg_data,
+					    adapter->cfg_len, data);
 		mwifiex_dbg(adapter, INFO,
-			    "download cfg_data from config file\n");
+			    "download cfg_data from iw vendor command\n");
 	} else {
 		return -1;
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/vendor.c b/drivers/net/wireless/marvell/mwifiex/vendor.c
new file mode 100644
index 0000000..ecdc10c
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/vendor.c
@@ -0,0 +1,59 @@
+/* Marvell Wireless LAN device driver: TDLS handling
+ *
+ * Copyright (C) 2014, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available on the worldwide web at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include <net/mac80211.h>
+#include <net/netlink.h>
+#include "vendor.h"
+#include "main.h"
+
+static int
+mwifiex_vendor_cmd_set_edmac_data(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  const void *data, int data_len)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
+	int ret;
+
+	priv->adapter->cfg_data = (u8 *)data;
+	priv->adapter->cfg_len = data_len;
+
+	ret = mwifiex_send_cmd(priv, HostCmd_CMD_CFG_DATA,
+			       HostCmd_ACT_GEN_SET, 0, NULL, true);
+
+	priv->adapter->cfg_data = NULL;
+	priv->adapter->cfg_len = 0;
+
+	return 0;
+}
+
+static const struct wiphy_vendor_command marvell_vendor_commands[] = {
+	{
+		.info = {
+			.vendor_id = MARVELL_OUI,
+			.subcmd = MARVELL_VENDOR_CMD_SET_EDMAC_DATA,
+		},
+		.flags = WIPHY_VENDOR_CMD_NEED_NETDEV |
+			 WIPHY_VENDOR_CMD_NEED_RUNNING,
+		.doit = mwifiex_vendor_cmd_set_edmac_data,
+	},
+};
+
+void marvell_set_vendor_commands(struct wiphy *wiphy)
+{
+	wiphy->vendor_commands = marvell_vendor_commands;
+	wiphy->n_vendor_commands = ARRAY_SIZE(marvell_vendor_commands);
+}
diff --git a/drivers/net/wireless/marvell/mwifiex/vendor.h b/drivers/net/wireless/marvell/mwifiex/vendor.h
new file mode 100644
index 0000000..e5d6fe8
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/vendor.h
@@ -0,0 +1,27 @@
+/* Marvell Wireless LAN device driver: TDLS handling
+ *
+ * Copyright (C) 2014, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available on the worldwide web at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef __MARVELL_VENDOR_H__
+#define __MARVELL_VENDOR_H__
+
+#define MARVELL_OUI	0x005043
+
+enum marvell_vendor_commands {
+	MARVELL_VENDOR_CMD_SET_EDMAC_DATA,
+};
+
+#endif /* __MARVELL_VENDOR_H__ */
-- 
1.8.1.4

