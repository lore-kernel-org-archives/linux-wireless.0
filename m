Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19123 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbbHNKA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 06:00:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t7EA05sc013053
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 03:00:27 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1w92ub1gqw-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 03:00:26 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: control WLAN and bluetooth coexistence modes
Date: Fri, 14 Aug 2015 02:59:31 -0700
Message-ID: <1439546371-3218-1-git-send-email-akarwar@marvell.com> (sfid-20150814_120032_230809_75864AFB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By default our chip will be in spatial coexistence mode.
This patch adds a provision to change it to timeshare mode
via sysfs command.

Enable timeshare coexistence mode
   echo 1 > /sys/class/net/mlan0/timeshare_coex

Go back to spacial coexistence mode
   echo 0 > /sys/class/net/mlan0/timeshare_coex

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwifiex/Makefile      |  1 +
 drivers/net/wireless/mwifiex/cfg80211.c    |  3 ++
 drivers/net/wireless/mwifiex/fw.h          | 16 +++++++
 drivers/net/wireless/mwifiex/main.h        |  2 +
 drivers/net/wireless/mwifiex/sta_cmd.c     | 31 +++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 25 ++++++++++
 drivers/net/wireless/mwifiex/sysfs.c       | 73 ++++++++++++++++++++++++++++++
 7 files changed, 151 insertions(+)
 create mode 100644 drivers/net/wireless/mwifiex/sysfs.c

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index fdfd9bf..fe5925f 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -42,6 +42,7 @@ mwifiex-y += cfg80211.o
 mwifiex-y += ethtool.o
 mwifiex-y += 11h.o
 mwifiex-y += tdls.o
+mwifiex-y += sysfs.o
 mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_MWIFIEX) += mwifiex.o
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ff63cb5..7e71dd7 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2734,6 +2734,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 	mdev_priv = netdev_priv(dev);
 	*((unsigned long *) mdev_priv) = (unsigned long) priv;
+	dev->ml_priv = priv;
 
 	SET_NETDEV_DEV(dev, adapter->dev);
 
@@ -2791,6 +2792,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_init(priv);
 #endif
+	mwifiex_sysfs_register(priv);
 
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -2825,6 +2827,7 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_remove(priv);
 #endif
+	mwifiex_sysfs_unregister(priv);
 
 	mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 9a8c1832..bf5056b 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -101,6 +101,9 @@ enum KEY_TYPE_ID {
 #define FIRMWARE_READY_SDIO				0xfedc
 #define FIRMWARE_READY_PCIE				0xfedcba00
 
+#define MWIFIEX_COEX_MODE_TIMESHARE			0x01
+#define MWIFIEX_COEX_MODE_SPATIAL			0x82
+
 enum mwifiex_usb_ep {
 	MWIFIEX_USB_EP_CMD_EVENT = 1,
 	MWIFIEX_USB_EP_DATA = 2,
@@ -162,6 +165,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_CHANRPT_11H_BASIC  (PROPRIETARY_TLV_BASE_ID + 91)
 #define TLV_TYPE_UAP_RETRY_LIMIT    (PROPRIETARY_TLV_BASE_ID + 93)
 #define TLV_TYPE_WAPI_IE            (PROPRIETARY_TLV_BASE_ID + 94)
+#define TLV_TYPE_ROBUST_COEX        (PROPRIETARY_TLV_BASE_ID + 96)
 #define TLV_TYPE_UAP_MGMT_FRAME     (PROPRIETARY_TLV_BASE_ID + 104)
 #define TLV_TYPE_MGMT_IE            (PROPRIETARY_TLV_BASE_ID + 105)
 #define TLV_TYPE_AUTO_DS_PARAM      (PROPRIETARY_TLV_BASE_ID + 113)
@@ -352,6 +356,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HostCmd_CMD_AMSDU_AGGR_CTRL                   0x00df
 #define HostCmd_CMD_TXPWR_CFG                         0x00d1
 #define HostCmd_CMD_TX_RATE_CFG                       0x00d6
+#define HostCmd_CMD_ROBUST_COEX                       0x00e0
 #define HostCmd_CMD_802_11_PS_MODE_ENH                0x00e4
 #define HostCmd_CMD_802_11_HS_CFG_ENH                 0x00e5
 #define HostCmd_CMD_P2P_MODE_CFG                      0x00eb
@@ -1874,6 +1879,11 @@ struct mwifiex_ie_types_btcoex_aggr_win_size {
 	u8 reserved;
 } __packed;
 
+struct mwifiex_ie_types_robust_coex {
+	struct mwifiex_ie_types_header header;
+	__le32 mode;
+} __packed;
+
 struct host_cmd_ds_version_ext {
 	u8 version_str_sel;
 	char version_str[128];
@@ -2059,6 +2069,11 @@ struct host_cmd_ds_multi_chan_policy {
 	__le16 policy;
 } __packed;
 
+struct host_cmd_ds_robust_coex {
+	__le16 action;
+	__le16 reserved;
+} __packed;
+
 struct host_cmd_ds_command {
 	__le16 command;
 	__le16 size;
@@ -2128,6 +2143,7 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_chan_rpt_req chan_rpt_req;
 		struct host_cmd_sdio_sp_rx_aggr_cfg sdio_rx_aggr_cfg;
 		struct host_cmd_ds_multi_chan_policy mc_policy;
+		struct host_cmd_ds_robust_coex coex;
 	} params;
 } __packed;
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index face747..1cf5328 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1188,6 +1188,8 @@ int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *resp);
 int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
 					 void *buf);
+int mwifiex_sysfs_register(struct mwifiex_private *priv);
+void mwifiex_sysfs_unregister(struct mwifiex_private *priv);
 
 /*
  * This function checks if the queuing is RA based or not.
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index a49a80d..fd7bf94 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1531,6 +1531,33 @@ mwifiex_cmd_set_mc_policy(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int mwifiex_cmd_robust_coex(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *cmd,
+				   u16 cmd_action, bool *is_timeshare)
+{
+	struct host_cmd_ds_robust_coex *coex = &cmd->params.coex;
+	struct mwifiex_ie_types_robust_coex *coex_tlv;
+
+	cmd->command = cpu_to_le16(HostCmd_CMD_ROBUST_COEX);
+	cmd->size = cpu_to_le16(sizeof(*coex) + sizeof(*coex_tlv) + S_DS_GEN);
+
+	coex->action = cpu_to_le16(cmd_action);
+	coex_tlv = (struct mwifiex_ie_types_robust_coex *)
+				((u8 *)coex + sizeof(*coex));
+	coex_tlv->header.type = cpu_to_le16(TLV_TYPE_ROBUST_COEX);
+	coex_tlv->header.len = cpu_to_le16(sizeof(coex_tlv->mode));
+
+	if (coex->action == HostCmd_ACT_GEN_GET)
+		return 0;
+
+	if (*is_timeshare)
+		coex_tlv->mode = cpu_to_le32(MWIFIEX_COEX_MODE_TIMESHARE);
+	else
+		coex_tlv->mode = cpu_to_le32(MWIFIEX_COEX_MODE_SPATIAL);
+
+	return 0;
+}
+
 static int
 mwifiex_cmd_coalesce_cfg(struct mwifiex_private *priv,
 			 struct host_cmd_ds_command *cmd,
@@ -2040,6 +2067,10 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_set_mc_policy(priv, cmd_ptr, cmd_action,
 						data_buf);
 		break;
+	case HostCmd_CMD_ROBUST_COEX:
+		ret = mwifiex_cmd_robust_coex(priv, cmd_ptr, cmd_action,
+					      data_buf);
+		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "PREP_CMD: unknown cmd- %#x\n", cmd_no);
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 87b69d8..a218c75 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1007,6 +1007,28 @@ static int mwifiex_ret_sdio_rx_aggr_cfg(struct mwifiex_private *priv,
 	return 0;
 }
 
+static int mwifiex_ret_robust_coex(struct mwifiex_private *priv,
+				   struct host_cmd_ds_command *resp,
+				   bool *is_timeshare)
+{
+	struct host_cmd_ds_robust_coex *coex = &resp->params.coex;
+	struct mwifiex_ie_types_robust_coex *coex_tlv;
+	u16 action = le16_to_cpu(coex->action);
+	u32 mode;
+
+	coex_tlv = (struct mwifiex_ie_types_robust_coex
+		    *)((u8 *)coex + sizeof(struct host_cmd_ds_robust_coex));
+	if (action == HostCmd_ACT_GEN_GET) {
+		mode = le32_to_cpu(coex_tlv->mode);
+		if (mode == MWIFIEX_COEX_MODE_TIMESHARE)
+			*is_timeshare = true;
+		else
+			*is_timeshare = false;
+	}
+
+	return 0;
+}
+
 /*
  * This function handles the command responses.
  *
@@ -1202,6 +1224,9 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_TDLS_CONFIG:
 		break;
+	case HostCmd_CMD_ROBUST_COEX:
+		ret = mwifiex_ret_robust_coex(priv, resp, data_buf);
+		break;
 	default:
 		mwifiex_dbg(adapter, ERROR,
 			    "CMD_RESP: unknown cmd response %#x\n",
diff --git a/drivers/net/wireless/mwifiex/sysfs.c b/drivers/net/wireless/mwifiex/sysfs.c
new file mode 100644
index 0000000..6d9d63f
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/sysfs.c
@@ -0,0 +1,73 @@
+/* Marvell wireless LAN device driver: sysfs
+ *
+ * Copyright (C) 2015, Marvell International Ltd.
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
+#include "main.h"
+
+static ssize_t
+mwifiex_sysfs_get_coex_mode(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct mwifiex_private *priv = to_net_dev(dev)->ml_priv;
+	bool is_timeshare;
+
+	mwifiex_send_cmd(priv, HostCmd_CMD_ROBUST_COEX, HostCmd_ACT_GEN_GET,
+			 0, &is_timeshare, true);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", is_timeshare);
+}
+
+static ssize_t
+mwifiex_sysfs_set_coex_mode(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct mwifiex_private *priv = to_net_dev(dev)->ml_priv;
+	bool is_timeshare;
+
+	if (strtobool(buf, &is_timeshare))
+		return -EINVAL;
+
+	if (priv->adapter->fw_api_ver != MWIFIEX_FW_V15)
+		return -EOPNOTSUPP;
+
+	mwifiex_send_cmd(priv, HostCmd_CMD_ROBUST_COEX, HostCmd_ACT_GEN_SET,
+			 0, &is_timeshare, true);
+
+	return count;
+}
+
+static DEVICE_ATTR(timeshare_coex, S_IRUGO | S_IWUSR,
+		   mwifiex_sysfs_get_coex_mode,
+		   mwifiex_sysfs_set_coex_mode);
+
+int mwifiex_sysfs_register(struct mwifiex_private *priv)
+{
+	int ret;
+
+	/* Create sysfs file to control coexistence modes */
+	ret = device_create_file(&priv->netdev->dev, &dev_attr_timeshare_coex);
+	if (ret)
+		dev_err(priv->adapter->dev,
+			"failed to create sysfs file timeshare_coex\n");
+
+	return ret;
+}
+
+void mwifiex_sysfs_unregister(struct mwifiex_private *priv)
+{
+	device_remove_file(&priv->netdev->dev, &dev_attr_timeshare_coex);
+}
+
-- 
1.8.1.4

