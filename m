Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34195 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbLLNWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2015 08:22:53 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Lior David <qca_liord@qca.qualcomm.com>
Subject: [PATCH 2/2] wil6210: support for platform specific crash recovery
Date: Sat, 12 Dec 2015 15:22:45 +0200
Message-Id: <1449926565-888-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20151212_142259_378683_C5B33FFD)
In-Reply-To: <1449926565-888-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1449926565-888-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added a simple interface for platform to perform crash
recovery.
When firmware crashes, wil driver can notify the platform
which can trigger a crash recovery process. During
the process the platform can request a ram dump
from the wil driver as well as control when firmware
recovery will start. This interface allows the platform
to implement a more advanced crash recovery, for
example to reset dependent subsystems in proper order, or
to provide its own notifications during the recovery process.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c      |  8 +++--
 drivers/net/wireless/ath/wil6210/pcie_bus.c       | 30 ++++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h        |  1 +
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c |  3 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c   |  3 +-
 drivers/net/wireless/ath/wil6210/wil_platform.h   | 38 +++++++++++++++++++++--
 6 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 50c136e..4f2ffa5 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -394,9 +394,13 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 		wil_fw_core_dump(wil);
 		wil_notify_fw_error(wil);
 		isr &= ~ISR_MISC_FW_ERROR;
-		wil_fw_error_recovery(wil);
+		if (wil->platform_ops.notify_crash) {
+			wil_err(wil, "notify platform driver about FW crash");
+			wil->platform_ops.notify_crash(wil->platform_handle);
+		} else {
+			wil_fw_error_recovery(wil);
+		}
 	}
-
 	if (isr & ISR_MISC_MBOX_EVT) {
 		wil_dbg_irq(wil, "MBOX event\n");
 		wmi_recv_cmd(wil);
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 1a3142c3..e36f2a0 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -125,11 +125,37 @@ static int wil_if_pcie_disable(struct wil6210_priv *wil)
 	return 0;
 }
 
+static int wil_platform_rop_ramdump(void *wil_handle, void *buf, uint32_t size)
+{
+	struct wil6210_priv *wil = wil_handle;
+
+	if (!wil)
+		return -EINVAL;
+
+	return wil_fw_copy_crash_dump(wil, buf, size);
+}
+
+static int wil_platform_rop_fw_recovery(void *wil_handle)
+{
+	struct wil6210_priv *wil = wil_handle;
+
+	if (!wil)
+		return -EINVAL;
+
+	wil_fw_error_recovery(wil);
+
+	return 0;
+}
+
 static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct wil6210_priv *wil;
 	struct device *dev = &pdev->dev;
 	int rc;
+	const struct wil_platform_rops rops = {
+		.ramdump = wil_platform_rop_ramdump,
+		.fw_recovery = wil_platform_rop_fw_recovery,
+	};
 
 	/* check HW */
 	dev_info(&pdev->dev, WIL_NAME
@@ -154,7 +180,7 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* rollback to if_free */
 
 	wil->platform_handle =
-			wil_platform_init(&pdev->dev, &wil->platform_ops);
+		wil_platform_init(&pdev->dev, &wil->platform_ops, &rops, wil);
 	if (!wil->platform_handle) {
 		rc = -ENODEV;
 		wil_err(wil, "wil_platform_init failed\n");
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index ade5f3b8..235e205 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -828,6 +828,7 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime);
 int wil_suspend(struct wil6210_priv *wil, bool is_runtime);
 int wil_resume(struct wil6210_priv *wil, bool is_runtime);
 
+int wil_fw_copy_crash_dump(struct wil6210_priv *wil, void *dest, u32 size);
 void wil_fw_core_dump(struct wil6210_priv *wil);
 
 #endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
index 7e70934..b57d280 100644
--- a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
+++ b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
@@ -51,8 +51,7 @@ static int wil_fw_get_crash_dump_bounds(struct wil6210_priv *wil,
 	return 0;
 }
 
-static int wil_fw_copy_crash_dump(struct wil6210_priv *wil, void *dest,
-				  u32 size)
+int wil_fw_copy_crash_dump(struct wil6210_priv *wil, void *dest, u32 size)
 {
 	int i;
 	const struct fw_map *map;
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.c b/drivers/net/wireless/ath/wil6210/wil_platform.c
index 2e831bf..4eed05bd 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.c
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.c
@@ -33,7 +33,8 @@ void wil_platform_modexit(void)
  * It returns a handle which is used with the rest of the API
  *
  */
-void *wil_platform_init(struct device *dev, struct wil_platform_ops *ops)
+void *wil_platform_init(struct device *dev, struct wil_platform_ops *ops,
+			const struct wil_platform_rops *rops, void *wil_handle)
 {
 	void *handle = ops; /* to return some non-NULL for 'void' impl. */
 
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index d7fa19b..9a949d9 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2014-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -20,16 +20,48 @@
 struct device;
 
 /**
- * struct wil_platform_ops - wil platform module callbacks
+ * struct wil_platform_ops - wil platform module calls from this
+ * driver to platform driver
  */
 struct wil_platform_ops {
 	int (*bus_request)(void *handle, uint32_t kbps /* KBytes/Sec */);
 	int (*suspend)(void *handle);
 	int (*resume)(void *handle);
 	void (*uninit)(void *handle);
+	int (*notify_crash)(void *handle);
 };
 
-void *wil_platform_init(struct device *dev, struct wil_platform_ops *ops);
+/**
+ * struct wil_platform_rops - wil platform module callbacks from
+ * platform driver to this driver
+ * @ramdump: store a ramdump from the wil firmware. The platform
+ *	driver may add additional data to the ramdump to
+ *	generate the final crash dump.
+ * @fw_recovery: start a firmware recovery process. Called as
+ *      part of a crash recovery process which may include other
+ *      related platform subsystems.
+ */
+struct wil_platform_rops {
+	int (*ramdump)(void *wil_handle, void *buf, uint32_t size);
+	int (*fw_recovery)(void *wil_handle);
+};
+
+/**
+ * wil_platform_init - initialize the platform driver
+ *
+ * @dev - pointer to the wil6210 device
+ * @ops - structure with platform driver operations. Platform
+ *	driver will fill this structure with function pointers.
+ * @rops - structure with callbacks from platform driver to
+ *	this driver. The platform driver copies the structure to
+ *	its own storage. Can be NULL if this driver does not
+ *	support crash recovery.
+ * @wil_handle - context for this driver that will be passed
+ *      when platform driver invokes one of the callbacks in
+ *      rops. May be NULL if rops is NULL.
+ */
+void *wil_platform_init(struct device *dev, struct wil_platform_ops *ops,
+			const struct wil_platform_rops *rops, void *wil_handle);
 
 int __init wil_platform_modinit(void);
 void wil_platform_modexit(void);
-- 
1.8.5.2

