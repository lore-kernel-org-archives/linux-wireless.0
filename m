Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:53526 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1HaNjG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 09:39:06 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id C5DB9C7FEB
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 16:39:04 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 92537158A64
	for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 16:39:00 +0300 (EEST)
Subject: [PATCH] ath6kl: add testmode support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Wed, 31 Aug 2011 16:39:00 +0300
Message-ID: <20110831133900.28842.29247.stgit@localhost6.localdomain6> (sfid-20110831_153911_995506_3F739687)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is port from the staging version of ath6kl. The interface to user space
is exactly same.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Makefile   |    1 
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 
 drivers/net/wireless/ath/ath6kl/core.h     |    8 +
 drivers/net/wireless/ath/ath6kl/init.c     |   26 ++++
 drivers/net/wireless/ath/ath6kl/main.c     |    5 +
 drivers/net/wireless/ath/ath6kl/testmode.c |  167 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/testmode.h |   20 +++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   29 +++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    1 
 9 files changed, 257 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/testmode.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/testmode.h

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index e1bb07e..c598bd3 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -33,3 +33,4 @@ ath6kl-y += txrx.o
 ath6kl-y += wmi.o
 ath6kl-y += node.o
 ath6kl-y += sdio.o
+ath6kl-$(CONFIG_NL80211_TESTMODE) += testmode.o
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 9128aa3..b1b1bb5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -18,6 +18,7 @@
 #include "cfg80211.h"
 #include "debug.h"
 #include "hif-ops.h"
+#include "testmode.h"
 
 #define RATETAB_ENT(_rate, _rateid, _flags) {   \
 	.bitrate    = (_rate),                  \
@@ -1454,6 +1455,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.set_pmksa = ath6kl_set_pmksa,
 	.del_pmksa = ath6kl_del_pmksa,
 	.flush_pmksa = ath6kl_flush_pmksa,
+	CFG80211_TESTMODE_CMD(ath6kl_tm_cmd)
 #ifdef CONFIG_PM
 	.suspend = ar6k_cfg80211_suspend,
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c5537b3..58bc934 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -64,6 +64,7 @@
 #define AR6003_REV2_PATCH_DOWNLOAD_ADDRESS  0x57e910
 #define AR6003_REV2_OTP_FILE                "ath6k/AR6003/hw2.0/otp.bin.z77"
 #define AR6003_REV2_FIRMWARE_FILE           "ath6k/AR6003/hw2.0/athwlan.bin.z77"
+#define AR6003_REV2_TCMD_FIRMWARE_FILE      "ath6k/AR6003/hw2.0/athtcmd_ram.bin"
 #define AR6003_REV2_PATCH_FILE              "ath6k/AR6003/hw2.0/data.patch.bin"
 #define AR6003_REV2_BOARD_DATA_FILE         "ath6k/AR6003/hw2.0/bdata.bin"
 #define AR6003_REV2_DEFAULT_BOARD_DATA_FILE "ath6k/AR6003/hw2.0/bdata.SD31.bin"
@@ -72,6 +73,7 @@
 #define AR6003_REV3_VERSION                 0x30000582
 #define AR6003_REV3_OTP_FILE                "ath6k/AR6003/hw2.1.1/otp.bin"
 #define AR6003_REV3_FIRMWARE_FILE           "ath6k/AR6003/hw2.1.1/athwlan.bin"
+#define AR6003_REV3_TCMD_FIRMWARE_FILE    "ath6k/AR6003/hw2.1.1/athtcmd_ram.bin"
 #define AR6003_REV3_PATCH_FILE            "ath6k/AR6003/hw2.1.1/data.patch.bin"
 #define AR6003_REV3_BOARD_DATA_FILE       "ath6k/AR6003/hw2.1.1/bdata.bin"
 #define AR6003_REV3_DEFAULT_BOARD_DATA_FILE	\
@@ -371,6 +373,7 @@ struct ath6kl_req_key {
 #define NETDEV_REGISTERED    10
 #define SKIP_SCAN	     11
 #define WLAN_ENABLED	     12
+#define TESTMODE	     13
 
 struct ath6kl {
 	struct device *dev;
@@ -444,6 +447,11 @@ struct ath6kl {
 #define AR_MCAST_FILTER_MAC_ADDR_SIZE  4
 	u8 auto_auth_stage;
 
+	struct {
+		void *rx_report;
+		size_t rx_report_len;
+	} tm;
+
 	u16 conf_flags;
 	wait_queue_head_t event_wq;
 	struct ath6kl_mbox_info mbox_info;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index ad9716c..38a5e9f 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -23,8 +23,10 @@
 #include "hif-ops.h"
 
 unsigned int debug_mask;
+static unsigned int testmode;
 
 module_param(debug_mask, uint, 0644);
+module_param(testmode, uint, 0644);
 
 /*
  * Include definitions here that can be used to tune the WLAN module
@@ -884,6 +886,28 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 	u32 address;
 	int ret;
 
+	if (testmode) {
+		switch (ar->version.target_ver) {
+		case AR6003_REV2_VERSION:
+			filename = AR6003_REV2_TCMD_FIRMWARE_FILE;
+			break;
+		case AR6003_REV3_VERSION:
+			filename = AR6003_REV3_TCMD_FIRMWARE_FILE;
+			break;
+		case AR6004_REV1_VERSION:
+			ath6kl_warn("testmode not supported with ar6004\n");
+			return -EOPNOTSUPP;
+		default:
+			ath6kl_warn("unknown target version: 0x%x\n",
+				       ar->version.target_ver);
+			return -EINVAL;
+		}
+
+		set_bit(TESTMODE, &ar->flag);
+
+		goto get_fw;
+	}
+
 	switch (ar->version.target_ver) {
 	case AR6003_REV2_VERSION:
 		filename = AR6003_REV2_FIRMWARE_FILE;
@@ -896,6 +920,8 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 		break;
 	}
 
+get_fw:
+
 	if (ar->fw == NULL) {
 		ret = ath6kl_get_fw(ar, filename, &ar->fw, &ar->fw_len);
 		if (ret) {
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index b64b2a3..d03039e 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -870,9 +870,10 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 	set_bit(WMI_READY, &ar->flag);
 	wake_up(&ar->event_wq);
 
-	ath6kl_info("hw %s fw %s\n",
+	ath6kl_info("hw %s fw %s%s\n",
 		    get_hw_id_string(ar->wdev->wiphy->hw_version),
-		    ar->wdev->wiphy->fw_version);
+		    ar->wdev->wiphy->fw_version,
+		    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
 }
 
 void ath6kl_scan_complete_evt(struct ath6kl *ar, int status)
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.c b/drivers/net/wireless/ath/ath6kl/testmode.c
new file mode 100644
index 0000000..381eb66
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/testmode.c
@@ -0,0 +1,167 @@
+/*
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "testmode.h"
+
+#include <net/netlink.h>
+
+enum ath6kl_tm_attr {
+	__ATH6KL_TM_ATTR_INVALID	= 0,
+	ATH6KL_TM_ATTR_CMD		= 1,
+	ATH6KL_TM_ATTR_DATA		= 2,
+
+	/* keep last */
+	__ATH6KL_TM_ATTR_AFTER_LAST,
+	ATH6KL_TM_ATTR_MAX		= __ATH6KL_TM_ATTR_AFTER_LAST - 1,
+};
+
+enum ath6kl_tm_cmd {
+	ATH6KL_TM_CMD_TCMD		= 0,
+	ATH6KL_TM_CMD_RX_REPORT		= 1,
+};
+
+#define ATH6KL_TM_DATA_MAX_LEN		5000
+
+static const struct nla_policy ath6kl_tm_policy[ATH6KL_TM_ATTR_MAX + 1] = {
+	[ATH6KL_TM_ATTR_CMD]		= { .type = NLA_U32 },
+	[ATH6KL_TM_ATTR_DATA]		= { .type = NLA_BINARY,
+					    .len = ATH6KL_TM_DATA_MAX_LEN },
+};
+
+void ath6kl_tm_rx_report_event(struct ath6kl *ar, void *buf, size_t buf_len)
+{
+	if (down_interruptible(&ar->sem))
+		return;
+
+	kfree(ar->tm.rx_report);
+
+	ar->tm.rx_report = kmemdup(buf, buf_len, GFP_KERNEL);
+	ar->tm.rx_report_len = buf_len;
+
+	up(&ar->sem);
+
+	wake_up(&ar->event_wq);
+}
+
+static int ath6kl_tm_rx_report(struct ath6kl *ar, void *buf, size_t buf_len,
+			       struct sk_buff *skb)
+{
+	int ret = 0;
+	long left;
+
+	if (down_interruptible(&ar->sem))
+		return -ERESTARTSYS;
+
+	if (!test_bit(WMI_READY, &ar->flag)) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (test_bit(DESTROY_IN_PROGRESS, &ar->flag)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (ath6kl_wmi_test_cmd(ar->wmi, buf, buf_len) < 0) {
+		up(&ar->sem);
+		return -EIO;
+	}
+
+	left = wait_event_interruptible_timeout(ar->event_wq,
+						ar->tm.rx_report != NULL,
+						WMI_TIMEOUT);
+
+	if (left == 0) {
+		ret = -ETIMEDOUT;
+		goto out;
+	} else if (left < 0) {
+		ret = left;
+		goto out;
+	}
+
+	if (ar->tm.rx_report == NULL || ar->tm.rx_report_len == 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	NLA_PUT(skb, ATH6KL_TM_ATTR_DATA, ar->tm.rx_report_len,
+		ar->tm.rx_report);
+
+	kfree(ar->tm.rx_report);
+	ar->tm.rx_report = NULL;
+
+out:
+	up(&ar->sem);
+
+	return ret;
+
+nla_put_failure:
+	ret = -ENOBUFS;
+	goto out;
+}
+
+int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len)
+{
+	struct ath6kl *ar = wiphy_priv(wiphy);
+	struct nlattr *tb[ATH6KL_TM_ATTR_MAX + 1];
+	int err, buf_len, reply_len;
+	struct sk_buff *skb;
+	void *buf;
+
+	err = nla_parse(tb, ATH6KL_TM_ATTR_MAX, data, len,
+			ath6kl_tm_policy);
+	if (err)
+		return err;
+
+	if (!tb[ATH6KL_TM_ATTR_CMD])
+		return -EINVAL;
+
+	switch (nla_get_u32(tb[ATH6KL_TM_ATTR_CMD])) {
+	case ATH6KL_TM_CMD_TCMD:
+		if (!tb[ATH6KL_TM_ATTR_DATA])
+			return -EINVAL;
+
+		buf = nla_data(tb[ATH6KL_TM_ATTR_DATA]);
+		buf_len = nla_len(tb[ATH6KL_TM_ATTR_DATA]);
+
+		ath6kl_wmi_test_cmd(ar->wmi, buf, buf_len);
+
+		return 0;
+
+		break;
+	case ATH6KL_TM_CMD_RX_REPORT:
+		if (!tb[ATH6KL_TM_ATTR_DATA])
+			return -EINVAL;
+
+		buf = nla_data(tb[ATH6KL_TM_ATTR_DATA]);
+		buf_len = nla_len(tb[ATH6KL_TM_ATTR_DATA]);
+
+		reply_len = nla_total_size(ATH6KL_TM_DATA_MAX_LEN);
+		skb = cfg80211_testmode_alloc_reply_skb(wiphy, reply_len);
+		if (!skb)
+			return -ENOMEM;
+
+		err = ath6kl_tm_rx_report(ar, buf, buf_len, skb);
+		if (err < 0) {
+			kfree_skb(skb);
+			return err;
+		}
+
+		return cfg80211_testmode_reply(skb);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.h b/drivers/net/wireless/ath/ath6kl/testmode.h
new file mode 100644
index 0000000..2e6b723
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/testmode.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2010-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "core.h"
+
+void ath6kl_tm_rx_report_event(struct ath6kl *ar, void *buf, size_t buf_len);
+int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d116d0e..b446b9e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -17,6 +17,7 @@
 #include <linux/ip.h>
 #include "core.h"
 #include "debug.h"
+#include "testmode.h"
 
 static int ath6kl_wmi_sync_point(struct wmi *wmi);
 
@@ -941,6 +942,13 @@ static int ath6kl_wmi_bitrate_reply_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
+static int ath6kl_wmi_tcmd_test_report_rx(struct wmi *wmi, u8 *datap, int len)
+{
+	ath6kl_tm_rx_report_event(wmi->parent_dev, datap, len);
+
+	return 0;
+}
+
 static int ath6kl_wmi_ratemask_reply_rx(struct wmi *wmi, u8 *datap, int len)
 {
 	if (len < sizeof(struct wmi_fix_rates_reply))
@@ -2308,6 +2316,23 @@ int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl)
 	return ret;
 }
 
+int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(len);
+	if (!skb)
+		return -ENOMEM;
+
+	memcpy(skb->data, buf, len);
+
+	ret = ath6kl_wmi_cmd_send(wmi, skb, WMI_TEST_CMDID, NO_SYNC_WMIFLAG);
+
+	return ret;
+}
+
+
 s32 ath6kl_wmi_get_rate(s8 rate_index)
 {
 	if (rate_index == RATE_AUTO)
@@ -2611,6 +2636,10 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 	case WMI_REPORT_ROAM_DATA_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REPORT_ROAM_DATA_EVENTID\n");
 		break;
+	case WMI_TEST_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TEST_EVENTID\n");
+		ret = ath6kl_wmi_tcmd_test_report_rx(wmi, datap, len);
+		break;
 	case WMI_GET_FIXRATES_CMDID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_GET_FIXRATES_CMDID\n");
 		ret = ath6kl_wmi_ratemask_reply_rx(wmi, datap, len);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 8fa5d6e..aafa744 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1994,6 +1994,7 @@ int ath6kl_wmi_get_tx_pwr_cmd(struct wmi *wmi);
 
 int ath6kl_wmi_set_wmm_txop(struct wmi *wmi, enum wmi_txop_cfg cfg);
 int ath6kl_wmi_set_keepalive_cmd(struct wmi *wmi, u8 keep_alive_intvl);
+int ath6kl_wmi_test_cmd(struct wmi *wmi, void *buf, size_t len);
 
 s32 ath6kl_wmi_get_rate(s8 rate_index);
 

