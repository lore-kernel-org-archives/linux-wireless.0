Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27109 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755581AbdAKQNy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 11:13:54 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 01/12] wil6210: add sysfs file for FTM calibration
Date: Wed, 11 Jan 2017 18:12:37 +0200
Message-Id: <1484151168-894-2-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170111_171357_751997_2641E696)
In-Reply-To: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484151168-894-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

In fine timing measurements, the calculation is affected by
2 parts: timing of packets over the air, which is platform
independent, and platform-specific delays, which are dependent
on things like antenna cable length and type.
Add a sysfs file which allows to get/set these platform specific
delays, separated into the TX and RX components.
There are 2 key scenarios where the file can be used:
1. Calibration - start with some initial values (for example,
the default values at startup), make measurements at a known
distance, then iteratively change the values until the
measurement results match the known distance.
2. Adjust the delays when platform starts up, based on known
values.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile   |   1 +
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   2 +
 drivers/net/wireless/ath/wil6210/sysfs.c    | 126 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |   2 +
 4 files changed, 131 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/sysfs.c

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index 11b544b..1aded6a 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -5,6 +5,7 @@ wil6210-y += netdev.o
 wil6210-y += cfg80211.o
 wil6210-y += pcie_bus.o
 wil6210-y += debugfs.o
+wil6210-y += sysfs.o
 wil6210-y += wmi.o
 wil6210-y += interrupt.o
 wil6210-y += txrx.o
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 44746ca..a216d99 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -263,6 +263,7 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 #endif /* CONFIG_PM */
 
 	wil6210_debugfs_init(wil);
+	wil6210_sysfs_init(wil);
 
 
 	return 0;
@@ -297,6 +298,7 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 #endif /* CONFIG_PM_SLEEP */
 #endif /* CONFIG_PM */
 
+	wil6210_sysfs_remove(wil);
 	wil6210_debugfs_remove(wil);
 	rtnl_lock();
 	wil_p2p_wdev_free(wil);
diff --git a/drivers/net/wireless/ath/wil6210/sysfs.c b/drivers/net/wireless/ath/wil6210/sysfs.c
new file mode 100644
index 0000000..d1fd7db
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/sysfs.c
@@ -0,0 +1,126 @@
+/*
+ * Copyright (c) 2016 Qualcomm Atheros, Inc.
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
+#include <linux/device.h>
+#include <linux/sysfs.h>
+
+#include "wil6210.h"
+#include "wmi.h"
+
+static ssize_t
+wil_ftm_txrx_offset_sysfs_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct wil6210_priv *wil = dev_get_drvdata(dev);
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_tof_get_tx_rx_offset_event evt;
+	} __packed reply;
+	int rc;
+	ssize_t len;
+
+	if (!test_bit(WMI_FW_CAPABILITY_FTM, wil->fw_capabilities))
+		return -EOPNOTSUPP;
+
+	memset(&reply, 0, sizeof(reply));
+	rc = wmi_call(wil, WMI_TOF_GET_TX_RX_OFFSET_CMDID, NULL, 0,
+		      WMI_TOF_GET_TX_RX_OFFSET_EVENTID,
+		      &reply, sizeof(reply), 100);
+	if (rc < 0)
+		return rc;
+	if (reply.evt.status) {
+		wil_err(wil, "get_tof_tx_rx_offset failed, error %d\n",
+			reply.evt.status);
+		return -EIO;
+	}
+	len = snprintf(buf, PAGE_SIZE, "%d %d\n",
+		       le32_to_cpu(reply.evt.tx_offset),
+		       le32_to_cpu(reply.evt.rx_offset));
+	return len;
+}
+
+static ssize_t
+wil_ftm_txrx_offset_sysfs_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct wil6210_priv *wil = dev_get_drvdata(dev);
+	struct wmi_tof_set_tx_rx_offset_cmd cmd;
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_tof_set_tx_rx_offset_event evt;
+	} __packed reply;
+	u32 tx_offset, rx_offset;
+	int rc;
+
+	if (sscanf(buf, "%d %d", &tx_offset, &rx_offset) != 2)
+		return -EINVAL;
+
+	if (!test_bit(WMI_FW_CAPABILITY_FTM, wil->fw_capabilities))
+		return -EOPNOTSUPP;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.tx_offset = cpu_to_le32(tx_offset);
+	cmd.rx_offset = cpu_to_le32(rx_offset);
+	memset(&reply, 0, sizeof(reply));
+	rc = wmi_call(wil, WMI_TOF_SET_TX_RX_OFFSET_CMDID, &cmd, sizeof(cmd),
+		      WMI_TOF_SET_TX_RX_OFFSET_EVENTID,
+		      &reply, sizeof(reply), 100);
+	if (rc < 0)
+		return rc;
+	if (reply.evt.status) {
+		wil_err(wil, "set_tof_tx_rx_offset failed, error %d\n",
+			reply.evt.status);
+		return -EIO;
+	}
+	return count;
+}
+
+static DEVICE_ATTR(ftm_txrx_offset, 0644,
+		   wil_ftm_txrx_offset_sysfs_show,
+		   wil_ftm_txrx_offset_sysfs_store);
+
+static struct attribute *wil6210_sysfs_entries[] = {
+	&dev_attr_ftm_txrx_offset.attr,
+	NULL
+};
+
+static struct attribute_group wil6210_attribute_group = {
+	.name = "wil6210",
+	.attrs = wil6210_sysfs_entries,
+};
+
+int wil6210_sysfs_init(struct wil6210_priv *wil)
+{
+	struct device *dev = wil_to_dev(wil);
+	int err;
+
+	err = sysfs_create_group(&dev->kobj, &wil6210_attribute_group);
+	if (err) {
+		wil_err(wil, "failed to create sysfs group: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+void wil6210_sysfs_remove(struct wil6210_priv *wil)
+{
+	struct device *dev = wil_to_dev(wil);
+
+	sysfs_remove_group(&dev->kobj, &wil6210_attribute_group);
+}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 237e166..e1da68d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -869,6 +869,8 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 int wil6210_debugfs_init(struct wil6210_priv *wil);
 void wil6210_debugfs_remove(struct wil6210_priv *wil);
+int wil6210_sysfs_init(struct wil6210_priv *wil);
+void wil6210_sysfs_remove(struct wil6210_priv *wil);
 int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 		       struct station_info *sinfo);
 
-- 
1.9.1
