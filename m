Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0082.outbound.protection.outlook.com ([104.47.34.82]:40832
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754187AbeEaJLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:11:25 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH 5/6] qtnfmac: add support for PTA configuration
Date: Thu, 31 May 2018 12:11:01 +0300
Message-Id: <20180531091102.28666-6-sergey.matyukevich.os@quantenna.com> (sfid-20180531_111138_208822_E70B6122)
In-Reply-To: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Shevchenko <ashevchenko@quantenna.com>

Implement support for PTA (Packet Traffic Arbitration) configuration.
The PTA mechanism is used to coordinate sharing of the medium between
WiFi and other 2.4 wireless networks, e.g. Bluetooth or ZigBee.

This patch implements core infrastructure and vendor specific commands
to control PTA functionality in firmware.

Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Makefile   |   4 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |   4 +
 drivers/net/wireless/quantenna/qtnfmac/commands.c |  51 ++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  60 +++++++++
 drivers/net/wireless/quantenna/qtnfmac/vendor.c   | 145 ++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/vendor.h   |  35 ++++++
 7 files changed, 299 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/vendor.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/vendor.h

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/wireless/quantenna/qtnfmac/Makefile
index 97f760a3d599..9e058617d694 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -15,8 +15,8 @@ qtnfmac-objs += \
 	cfg80211.o \
 	event.o \
 	util.o \
-	qlink_util.o
-
+	qlink_util.o \
+	vendor.o
 #
 
 obj-$(CONFIG_QTNFMAC_PEARL_PCIE) += qtnfmac_pearl_pcie.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 307ab5c59bfd..956852748cb1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -26,6 +26,7 @@
 #include "core.h"
 #include "util.h"
 #include "bus.h"
+#include "vendor.h"
 
 /* Supported rates to be advertised to the cfg80211 */
 static struct ieee80211_rate qtnf_rates_2g[] = {
@@ -1052,6 +1053,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 		sizeof(wiphy->fw_version));
 	wiphy->hw_version = hw_info->hw_version;
 
+	wiphy->vendor_commands = qtnf_vendor_cmds;
+	wiphy->n_vendor_commands = qtnf_vendor_get_cmds_number();
+
 	ret = wiphy_register(wiphy);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 10836695c5f5..45a2effa3eab 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -22,6 +22,7 @@
 #include "qlink_util.h"
 #include "bus.h"
 #include "commands.h"
+#include "vendor.h"
 
 static int qtnf_cmd_check_reply_header(const struct qlink_resp *resp,
 				       u16 cmd_id, u8 mac_id, u8 vif_id,
@@ -2831,3 +2832,53 @@ int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, u8 pm_mode, int timeout)
 	qtnf_bus_unlock(bus);
 	return ret;
 }
+
+int qtnf_cmd_setget_pta_param(struct qtnf_wmac *mac,
+			      int param_id, bool set_op, int *param_val)
+{
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_pta_param *cmd;
+	const struct qlink_resp_pta_param *resp;
+	struct sk_buff *resp_skb = NULL;
+	u16 res_code;
+	int ret;
+
+	if (!param_val)
+		return -EINVAL;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
+					    QLINK_CMD_PTA_PARAM,
+					    sizeof(*cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	cmd = (struct qlink_cmd_pta_param *)cmd_skb->data;
+	cmd->pta_param_id = param_id;
+	if (set_op) {
+		cmd->set_op = 1;
+		cmd->pta_param_value = cpu_to_le32(*param_val);
+	} else {
+		cmd->set_op = 0;
+	}
+
+	qtnf_bus_lock(mac->bus);
+	ret = qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb,
+				       &res_code, sizeof(*resp), NULL);
+	qtnf_bus_unlock(mac->bus);
+
+	if (ret)
+		goto out;
+
+	if (res_code != QLINK_CMD_RESULT_OK) {
+		pr_err("cmd exec failed: 0x%x\n", res_code);
+		ret = -EFAULT;
+		goto out;
+	}
+
+	resp = (const struct qlink_resp_pta_param *)resp_skb->data;
+
+	*param_val = le32_to_cpu(resp->pta_param_value);
+out:
+	consume_skb(resp_skb);
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 03a57e37a665..59e86db5e982 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -77,5 +77,6 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 			 const struct cfg80211_acl_data *params);
 int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, u8 pm_mode, int timeout);
-
+int qtnf_cmd_setget_pta_param(struct qtnf_wmac *mac,
+			      int param_id, bool set_op, int *param_val);
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 8fbef67fbbb8..582d82ceaeef 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -258,6 +258,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_CONNECT		= 0x0060,
 	QLINK_CMD_DISCONNECT		= 0x0061,
 	QLINK_CMD_PM_SET		= 0x0062,
+	QLINK_CMD_PTA_PARAM		= 0x0064,
 };
 
 /**
@@ -694,6 +695,52 @@ struct qlink_cmd_pm_set {
 	u8 pm_mode;
 } __packed;
 
+/**
+ * enum qlink_pta_mode - Packet Traffic Arbiter operating modes
+ *
+ * @QLINK_PTA_MODE_DISABLED: PTA is disabled
+ * @QLINK_PTA_MODE_2_WIRE: enable PTA 2-wire mode
+ */
+enum qlink_pta_mode {
+	QLINK_PTA_MODE_DISABLED = 0,
+	QLINK_PTA_MODE_2_WIRE = 2
+};
+
+/**
+ * enum qlink_pta_param - parameters to configure Packet Traffic Arbiter block
+ *
+ * @QLINK_PTA_PARAM_MODE: PTA operating mode. Supported parameter
+ *	values are defined by &enum qlink_pta_mode
+ * @QLINK_PTA_PARAM_REQ_POL: request polarity, (0 or 1).
+ * @QLINK_PTA_PARAM_GNT_POL: grant polarity, (0 or 1).
+ * @QLINK_PTA_PARAM_REQ_TIMEOUT: request timeout, ms.
+ * @QLINK_PTA_PARAM_GNT_TIMEOUT: grant timeout, ms.
+ * @QLINK_PTA_PARAM_IFS_TIMEOUT: IFS timeout, ms.
+ */
+enum qlink_pta_param {
+	QLINK_PTA_PARAM_MODE = 0,
+	QLINK_PTA_PARAM_REQ_POL,
+	QLINK_PTA_PARAM_GNT_POL,
+	QLINK_PTA_PARAM_REQ_TIMEOUT,
+	QLINK_PTA_PARAM_GNT_TIMEOUT,
+	QLINK_PTA_PARAM_IFS_TIMEOUT
+};
+
+/**
+ * struct qlink_cmd_pta_param - data for QLINK_CMD_PTA_PARAM command
+ *
+ * @pta_param_id: identifies PTA parameter, one of &enum qlink_pta_param
+ * @set_op: set or get operation flag (0 - get, 1 - set)
+ * @pta_param_value: value of PTA parameter to set
+ */
+struct qlink_cmd_pta_param {
+	struct qlink_cmd chdr;
+	u8 pta_param_id;
+	u8 set_op;
+	u8 rsvd[2];
+	__le32 pta_param_value;
+} __packed;
+
 /* QLINK Command Responses messages related definitions
  */
 
@@ -895,6 +942,19 @@ struct qlink_resp_channel_get {
 	struct qlink_chandef chan;
 } __packed;
 
+/**
+ * struct qlink_resp_pta_param - response for QLINK_CMD_PTA_PARAM command
+ *
+ * @pta_param_id: identifies PTA parameter, one of &enum qlink_pta_param
+ * @pta_param_value: value of PTA parameter
+ */
+struct qlink_resp_pta_param {
+	struct qlink_resp rhdr;
+	u8 pta_param_id;
+	u8 rsvd[3];
+	__le32 pta_param_value;
+} __packed;
+
 /* QLINK Events messages related definitions
  */
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/vendor.c b/drivers/net/wireless/quantenna/qtnfmac/vendor.c
new file mode 100644
index 000000000000..dbd290632e8b
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/vendor.c
@@ -0,0 +1,145 @@
+/*
+ * Copyright (c) 2018 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/kernel.h>
+#include <net/cfg80211.h>
+#include <net/netlink.h>
+#include "qlink.h"
+#include "commands.h"
+#include "vendor.h"
+
+static int
+qtnf_vendor_parse_pta_param_id(const void *data, int len, int *param_id)
+{
+	struct nlattr *attr;
+
+	attr = nla_find((const struct nlattr *)data, len,
+			QTNF_VENDOR_ATTR_PTA_PARAM_ID);
+	if (!attr) {
+		pr_err("attribute does not exist\n");
+		return -ENOENT;
+	}
+
+	if (nla_len(attr) != sizeof(u8)) {
+		pr_err("invalid attribute type\n");
+		return -EINVAL;
+	}
+
+	*param_id = nla_get_u8(attr);
+
+	return 0;
+}
+
+static int
+qtnf_vendor_parse_pta_param_val(const void *data, int len, int *param_val)
+{
+	struct nlattr *attr;
+
+	attr = nla_find((const struct nlattr *)data, len,
+			QTNF_VENDOR_ATTR_PTA_PARAM_VAL);
+	if (!attr) {
+		pr_err("attribute does not exist\n");
+		return -EINVAL;
+	}
+
+	if (nla_len(attr) != sizeof(s32)) {
+		pr_err("invalid attribute type\n");
+		return -EINVAL;
+	}
+
+	*param_val = nla_get_s32(attr);
+
+	return 0;
+}
+
+static int
+qtnf_vendor_cmd_set_pta_param(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
+			      const void *data, int data_len)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	int param_id;
+	int param_val;
+	int ret;
+
+	ret = qtnf_vendor_parse_pta_param_id(data, data_len, &param_id);
+	if (ret)
+		return ret;
+
+	ret = qtnf_vendor_parse_pta_param_val(data, data_len, &param_val);
+	if (ret)
+		return ret;
+
+	ret = qtnf_cmd_setget_pta_param(mac, param_id, true, &param_val);
+	return ret;
+}
+
+static int
+qtnf_vendor_cmd_get_pta_param(struct wiphy *wiphy,
+			      struct wireless_dev *wdev,
+			      const void *data, int data_len)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct sk_buff *reply;
+	int param_id;
+	int param_val;
+	int approx_size;
+	int ret;
+
+	ret = qtnf_vendor_parse_pta_param_id(data, data_len, &param_id);
+	if (ret)
+		return ret;
+
+	ret = qtnf_cmd_setget_pta_param(mac, param_id, false, &param_val);
+	if (ret)
+		return ret;
+
+	approx_size = nla_total_size(sizeof(s32));
+	reply = cfg80211_vendor_cmd_alloc_reply_skb(wiphy, approx_size);
+
+	if (!reply)
+		return -ENOMEM;
+
+	nla_put_u8(reply, QTNF_VENDOR_ATTR_PTA_PARAM_ID, param_id);
+	nla_put_s32(reply, QTNF_VENDOR_ATTR_PTA_PARAM_VAL, param_val);
+
+	ret = cfg80211_vendor_cmd_reply(reply);
+
+	return ret;
+}
+
+const struct wiphy_vendor_command qtnf_vendor_cmds[] = {
+	{
+		{
+			.vendor_id = QTNF_OUI,
+			.subcmd = QTNF_VENDOR_CMD_SET_PTA_PARAM
+		},
+		.flags = 0,
+		.doit = qtnf_vendor_cmd_set_pta_param
+	},
+	{
+		{
+			.vendor_id = QTNF_OUI,
+			.subcmd = QTNF_VENDOR_CMD_GET_PTA_PARAM
+		},
+		.flags = 0,
+		.doit = qtnf_vendor_cmd_get_pta_param
+	},
+};
+
+int qtnf_vendor_get_cmds_number(void)
+{
+	return ARRAY_SIZE(qtnf_vendor_cmds);
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/vendor.h b/drivers/net/wireless/quantenna/qtnfmac/vendor.h
new file mode 100644
index 000000000000..d1bb662f8eb4
--- /dev/null
+++ b/drivers/net/wireless/quantenna/qtnfmac/vendor.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c) 2018 Quantenna Communications, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef QTNFMAC_VENDOR_H
+#define QTNFMAC_VENDOR_H
+
+#define QTNF_OUI	0x002686
+
+enum qtnf_vendor_cmd {
+	QTNF_VENDOR_CMD_SET_PTA_PARAM = 0x1,
+	QTNF_VENDOR_CMD_GET_PTA_PARAM = 0x2,
+};
+
+enum qtnf_vendor_attr_pta_param {
+	QTNF_VENDOR_ATTR_PTA_PARAM_ID = 1,
+	QTNF_VENDOR_ATTR_PTA_PARAM_VAL = 2
+};
+
+extern const struct wiphy_vendor_command qtnf_vendor_cmds[];
+int qtnf_vendor_get_cmds_number(void);
+
+#endif /* QTNFMAC_VENDOR_H */
-- 
2.11.0
