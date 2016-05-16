Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13266 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbcEPTYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 15:24:12 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 5/6] wil6210: add pm_notify handling
Date: Mon, 16 May 2016 22:23:34 +0300
Message-Id: <1463426615-15523-6-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160516_212418_500255_5574CD91)
In-Reply-To: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding pm_notify to allow the following:
1. Check if suspend is allowed in an earlier stage to prevent
starting the suspend procedure in case it is not allowed
2. Notify the platform driver on the suspend request

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c     | 68 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/pm.c           | 25 ++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h      |  5 ++
 drivers/net/wireless/ath/wil6210/wil_platform.h |  4 +-
 4 files changed, 98 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index aeb72c4..7b5c422 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -18,13 +18,20 @@
 #include <linux/pci.h>
 #include <linux/moduleparam.h>
 #include <linux/interrupt.h>
-
+#include <linux/suspend.h>
 #include "wil6210.h"
 
 static bool use_msi = true;
 module_param(use_msi, bool, S_IRUGO);
 MODULE_PARM_DESC(use_msi, " Use MSI interrupt, default - true");
 
+#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
+static int wil6210_pm_notify(struct notifier_block *notify_block,
+			     unsigned long mode, void *unused);
+#endif /* CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM */
+
 static
 void wil_set_capabilities(struct wil6210_priv *wil)
 {
@@ -238,6 +245,18 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto bus_disable;
 	}
 
+#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
+	wil->pm_notify.notifier_call = wil6210_pm_notify;
+	rc = register_pm_notifier(&wil->pm_notify);
+	if (rc)
+		/* Do not fail the driver initialization, as suspend can
+		 * be prevented in a later phase if needed
+		 */
+		wil_err(wil, "register_pm_notifier failed: %d\n", rc);
+#endif /* CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM */
+
 	wil6210_debugfs_init(wil);
 
 
@@ -267,6 +286,12 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 
+#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
+	unregister_pm_notifier(&wil->pm_notify);
+#endif /* CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM */
+
 	wil6210_debugfs_remove(wil);
 	wil_if_remove(wil);
 	wil_if_pcie_disable(wil);
@@ -335,6 +360,45 @@ static int wil6210_resume(struct device *dev, bool is_runtime)
 	return rc;
 }
 
+static int wil6210_pm_notify(struct notifier_block *notify_block,
+			     unsigned long mode, void *unused)
+{
+	struct wil6210_priv *wil = container_of(
+		notify_block, struct wil6210_priv, pm_notify);
+	int rc = 0;
+	enum wil_platform_event evt;
+
+	wil_dbg_pm(wil, "%s: mode (%ld)\n", __func__, mode);
+
+	switch (mode) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+	case PM_RESTORE_PREPARE:
+		rc = wil_can_suspend(wil, false);
+		if (rc)
+			break;
+		evt = WIL_PLATFORM_EVT_PRE_SUSPEND;
+		if (wil->platform_ops.notify)
+			rc = wil->platform_ops.notify(wil->platform_handle,
+						      evt);
+		break;
+	case PM_POST_SUSPEND:
+	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
+		evt = WIL_PLATFORM_EVT_POST_SUSPEND;
+		if (wil->platform_ops.notify)
+			rc = wil->platform_ops.notify(wil->platform_handle,
+						      evt);
+		break;
+	default:
+		wil_dbg_pm(wil, "unhandled notify mode %ld\n", mode);
+		break;
+	}
+
+	wil_dbg_pm(wil, "notification mode %ld: rc (%d)\n", mode, rc);
+	return rc;
+}
+
 static int wil6210_pm_suspend(struct device *dev)
 {
 	return wil6210_suspend(dev, false);
diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index 0b7ecbc..11ee24d 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2014,2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -24,10 +24,32 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime)
 	wil_dbg_pm(wil, "%s(%s)\n", __func__,
 		   is_runtime ? "runtime" : "system");
 
+	if (!netif_running(wil_to_ndev(wil))) {
+		/* can always sleep when down */
+		wil_dbg_pm(wil, "Interface is down\n");
+		goto out;
+	}
+	if (test_bit(wil_status_resetting, wil->status)) {
+		wil_dbg_pm(wil, "Delay suspend when resetting\n");
+		rc = -EBUSY;
+		goto out;
+	}
+	if (wil->recovery_state != fw_recovery_idle) {
+		wil_dbg_pm(wil, "Delay suspend during recovery\n");
+		rc = -EBUSY;
+		goto out;
+	}
+
+	/* interface is running */
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
+		if (test_bit(wil_status_fwconnecting, wil->status)) {
+			wil_dbg_pm(wil, "Delay suspend when connecting\n");
+			rc = -EBUSY;
+			goto out;
+		}
 		break;
 	/* AP-like interface - can't suspend */
 	default:
@@ -36,6 +58,7 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime)
 		break;
 	}
 
+out:
 	wil_dbg_pm(wil, "%s(%s) => %s (%d)\n", __func__,
 		   is_runtime ? "runtime" : "system", rc ? "No" : "Yes", rc);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index aa09cbc..1feaf5a 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -662,6 +662,11 @@ struct wil6210_priv {
 	/* High Access Latency Policy voting */
 	struct wil_halp halp;
 
+#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
+	struct notifier_block pm_notify;
+#endif /* CONFIG_PM_SLEEP */
+#endif /* CONFIG_PM */
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index 33d4a34..f8c4117 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014-2015 Qualcomm Atheros, Inc.
+ * Copyright (c) 2014-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -23,6 +23,8 @@ enum wil_platform_event {
 	WIL_PLATFORM_EVT_FW_CRASH = 0,
 	WIL_PLATFORM_EVT_PRE_RESET = 1,
 	WIL_PLATFORM_EVT_FW_RDY = 2,
+	WIL_PLATFORM_EVT_PRE_SUSPEND = 3,
+	WIL_PLATFORM_EVT_POST_SUSPEND = 4,
 };
 
 /**
-- 
1.8.5.2

