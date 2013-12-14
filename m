Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65363 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab3LNCde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 21:33:34 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: download cal-data from device-tree to firmware
Date: Fri, 13 Dec 2013 18:33:01 -0800
Message-ID: <1386988382-30023-3-git-send-email-bzhao@marvell.com> (sfid-20131214_033348_057553_C7BD180F)
In-Reply-To: <1386988382-30023-1-git-send-email-bzhao@marvell.com>
References: <1386988382-30023-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently only conf file based cal-data downloading is supported.
On embedded platforms a better place to store the cal-data is in
device tree. Add cal-data downloading from device tree to firmware.
Both methods can co-exist.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h    |  2 ++
 drivers/net/wireless/mwifiex/sta_cmd.c | 61 +++++++++++++++++++++++++++++++---
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index dc34457..2f50354 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -32,6 +32,7 @@
 #include <net/lib80211.h>
 #include <linux/firmware.h>
 #include <linux/ctype.h>
+#include <linux/of.h>
 
 #include "decl.h"
 #include "ioctl.h"
@@ -739,6 +740,7 @@ struct mwifiex_adapter {
 	u8 scan_delay_cnt;
 	u8 empty_tx_q_cnt;
 	const struct firmware *cal_data;
+	struct device_node *dt_node;
 
 	/* 11AC */
 	u32 is_hw_11ac_capable;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 2368c7f..6a95086 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1156,19 +1156,58 @@ static u32 mwifiex_parse_cal_cfg(u8 *src, size_t len, u8 *dst)
 	return d - dst;
 }
 
+static int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
+				   struct device_node *node, const char *prefix)
+{
+#ifdef CONFIG_OF
+	struct property *prop;
+	size_t len = strlen(prefix);
+	int ret;
+
+	/* look for all matching property names */
+	for_each_property_of_node(node, prop) {
+		if (len > strlen(prop->name) ||
+		    strncmp(prop->name, prefix, len))
+			continue;
+
+		/* property header is 6 bytes */
+		if (prop && prop->value && prop->length > 6) {
+			ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_CFG_DATA,
+						    HostCmd_ACT_GEN_SET, 0,
+						    prop);
+			if (ret)
+				return ret;
+		}
+	}
+#endif
+	return 0;
+}
+
 /* This function prepares command of set_cfg_data. */
 static int mwifiex_cmd_cfg_data(struct mwifiex_private *priv,
-				struct host_cmd_ds_command *cmd)
+				struct host_cmd_ds_command *cmd, void *data_buf)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
+	struct property *prop = data_buf;
 	u32 len;
 	u8 *data = (u8 *)cmd + S_DS_GEN;
+	int ret;
 
-	if ((adapter->cal_data->data) && (adapter->cal_data->size > 0))
+	if (prop) {
+		len = prop->length;
+		ret = of_property_read_u8_array(adapter->dt_node, prop->name,
+						data, len);
+		if (ret)
+			return ret;
+		dev_dbg(adapter->dev,
+			"download cfg_data from device tree: %s\n", prop->name);
+	} else if (adapter->cal_data->data && adapter->cal_data->size > 0) {
 		len = mwifiex_parse_cal_cfg((u8 *)adapter->cal_data->data,
 					    adapter->cal_data->size, data);
-	else
+		dev_dbg(adapter->dev, "download cfg_data from config file\n");
+	} else {
 		return -1;
+	}
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_CFG_DATA);
 	cmd->size = cpu_to_le16(S_DS_GEN + len);
@@ -1259,7 +1298,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 		ret = mwifiex_cmd_get_hw_spec(priv, cmd_ptr);
 		break;
 	case HostCmd_CMD_CFG_DATA:
-		ret = mwifiex_cmd_cfg_data(priv, cmd_ptr);
+		ret = mwifiex_cmd_cfg_data(priv, cmd_ptr, data_buf);
 		break;
 	case HostCmd_CMD_MAC_CONTROL:
 		ret = mwifiex_cmd_mac_control(priv, cmd_ptr, cmd_action,
@@ -1519,7 +1558,19 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 		if (ret)
 			return -1;
 
-		/* Download calibration data to firmware */
+		/* Download calibration data to firmware.
+		 * The cal-data can be read from device tree and/or
+		 * a configuration file and downloaded to firmware.
+		 */
+		adapter->dt_node =
+				of_find_node_by_name(NULL, "marvell_cfgdata");
+		if (adapter->dt_node) {
+			ret = mwifiex_dnld_dt_cfgdata(priv, adapter->dt_node,
+						      "marvell,caldata");
+			if (ret)
+				return -1;
+		}
+
 		if (adapter->cal_data) {
 			ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_CFG_DATA,
 						HostCmd_ACT_GEN_SET, 0, NULL);
-- 
1.8.2.3

