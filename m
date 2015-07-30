Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64261 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbbG3Kyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:50 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 17/19] wil6210: system power management
Date: Thu, 30 Jul 2015 13:52:05 +0300
Message-Id: <1438253527-3372-18-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125455_077573_3F696D81)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for the system suspend/resume.
In preparation for the run-time PM, implementation made
run-time PM friendly: common for system and run-time PM
code factored out as generic functions, albeit is_runtime
parameter value is always false currently.

For debug purposes, "PM" debug category introduced.

Policy: AP-like interface can't be suspended; otherwise
suspend is allowed. Hardware brought down if interface
was up. Connection, if existed, get lost.
Interface will be brought up upon resume if it was up
before suspend.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile   |  1 +
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 69 ++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/pm.c       | 98 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  5 ++
 4 files changed, 173 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/pm.c

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index 050506f..64b4326 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -12,6 +12,7 @@ wil6210-y += debug.o
 wil6210-y += rx_reorder.o
 wil6210-y += ioctl.o
 wil6210-y += fw.o
+wil6210-y += pm.o
 wil6210-y += pmc.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 wil6210-y += wil_platform.o
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index c37838d..feff1ef 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -259,11 +259,80 @@ static const struct pci_device_id wil6210_pcie_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, wil6210_pcie_ids);
 
+#ifdef CONFIG_PM
+
+static int wil6210_suspend(struct device *dev, bool is_runtime)
+{
+	int rc = 0;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+
+	wil_dbg_pm(wil, "%s(%s)\n", __func__,
+		   is_runtime ? "runtime" : "system");
+
+	rc = wil_can_suspend(wil, is_runtime);
+	if (rc)
+		goto out;
+
+	rc = wil_suspend(wil, is_runtime);
+	if (rc)
+		goto out;
+
+	/* TODO: how do I bring card in low power state? */
+
+	/* disable bus mastering */
+	pci_clear_master(pdev);
+	/* PCI will call pci_save_state(pdev) and pci_prepare_to_sleep(pdev) */
+
+out:
+	return rc;
+}
+
+static int wil6210_resume(struct device *dev, bool is_runtime)
+{
+	int rc = 0;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct wil6210_priv *wil = pci_get_drvdata(pdev);
+
+	wil_dbg_pm(wil, "%s(%s)\n", __func__,
+		   is_runtime ? "runtime" : "system");
+
+	/* allow master */
+	pci_set_master(pdev);
+
+	rc = wil_resume(wil, is_runtime);
+	if (rc)
+		pci_clear_master(pdev);
+
+	return rc;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int wil6210_pm_suspend(struct device *dev)
+{
+	return wil6210_suspend(dev, false);
+}
+
+static int wil6210_pm_resume(struct device *dev)
+{
+	return wil6210_resume(dev, false);
+}
+#endif /* CONFIG_PM_SLEEP */
+
+#endif /* CONFIG_PM */
+
+static const struct dev_pm_ops wil6210_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(wil6210_pm_suspend, wil6210_pm_resume)
+};
+
 static struct pci_driver wil6210_driver = {
 	.probe		= wil_pcie_probe,
 	.remove		= wil_pcie_remove,
 	.id_table	= wil6210_pcie_ids,
 	.name		= WIL_NAME,
+	.driver		= {
+		.pm = &wil6210_pm_ops,
+	},
 };
 
 static int __init wil6210_driver_init(void)
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
new file mode 100644
index 0000000..0b7ecbc
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -0,0 +1,98 @@
+/*
+ * Copyright (c) 2014 Qualcomm Atheros, Inc.
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
+#include "wil6210.h"
+
+int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime)
+{
+	int rc = 0;
+	struct wireless_dev *wdev = wil->wdev;
+
+	wil_dbg_pm(wil, "%s(%s)\n", __func__,
+		   is_runtime ? "runtime" : "system");
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		break;
+	/* AP-like interface - can't suspend */
+	default:
+		wil_dbg_pm(wil, "AP-like interface\n");
+		rc = -EBUSY;
+		break;
+	}
+
+	wil_dbg_pm(wil, "%s(%s) => %s (%d)\n", __func__,
+		   is_runtime ? "runtime" : "system", rc ? "No" : "Yes", rc);
+
+	return rc;
+}
+
+int wil_suspend(struct wil6210_priv *wil, bool is_runtime)
+{
+	int rc = 0;
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	wil_dbg_pm(wil, "%s(%s)\n", __func__,
+		   is_runtime ? "runtime" : "system");
+
+	/* if netif up, hardware is alive, shut it down */
+	if (ndev->flags & IFF_UP) {
+		rc = wil_down(wil);
+		if (rc) {
+			wil_err(wil, "wil_down : %d\n", rc);
+			goto out;
+		}
+	}
+
+	if (wil->platform_ops.suspend)
+		rc = wil->platform_ops.suspend(wil->platform_handle);
+
+out:
+	wil_dbg_pm(wil, "%s(%s) => %d\n", __func__,
+		   is_runtime ? "runtime" : "system", rc);
+	return rc;
+}
+
+int wil_resume(struct wil6210_priv *wil, bool is_runtime)
+{
+	int rc = 0;
+	struct net_device *ndev = wil_to_ndev(wil);
+
+	wil_dbg_pm(wil, "%s(%s)\n", __func__,
+		   is_runtime ? "runtime" : "system");
+
+	if (wil->platform_ops.resume) {
+		rc = wil->platform_ops.resume(wil->platform_handle);
+		if (rc) {
+			wil_err(wil, "platform_ops.resume : %d\n", rc);
+			goto out;
+		}
+	}
+
+	/* if netif up, bring hardware up
+	 * During open(), IFF_UP set after actual device method
+	 * invocation. This prevent recursive call to wil_up()
+	 */
+	if (ndev->flags & IFF_UP)
+		rc = wil_up(wil);
+
+out:
+	wil_dbg_pm(wil, "%s(%s) => %d\n", __func__,
+		   is_runtime ? "runtime" : "system", rc);
+	return rc;
+}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c6b0fa2..dd4ea92 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -647,6 +647,7 @@ void wil_info(struct wil6210_priv *wil, const char *fmt, ...);
 #define wil_dbg_txrx(wil, fmt, arg...) wil_dbg(wil, "DBG[TXRX]" fmt, ##arg)
 #define wil_dbg_wmi(wil, fmt, arg...) wil_dbg(wil, "DBG[ WMI]" fmt, ##arg)
 #define wil_dbg_misc(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
+#define wil_dbg_pm(wil, fmt, arg...) wil_dbg(wil, "DBG[ PM ]" fmt, ##arg)
 
 /* target operations */
 /* register read */
@@ -815,4 +816,8 @@ int wil_iftype_nl2wmi(enum nl80211_iftype type);
 int wil_ioctl(struct wil6210_priv *wil, void __user *data, int cmd);
 int wil_request_firmware(struct wil6210_priv *wil, const char *name);
 
+int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime);
+int wil_suspend(struct wil6210_priv *wil, bool is_runtime);
+int wil_resume(struct wil6210_priv *wil, bool is_runtime);
+
 #endif /* __WIL6210_H__ */
-- 
2.1.4

