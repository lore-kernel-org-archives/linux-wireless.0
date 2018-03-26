Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42790 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbeCZFj2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:39:28 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH 03/12] ath10k: Add ath10k QMI client driver
Date: Mon, 26 Mar 2018 11:09:21 +0530
Message-Id: <1522042761-25716-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_073931_902612_16D7F621)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add QMI client driver for Q6 integrated WLAN connectivity
subsystem. This module is responsible for communicating WLAN
control messages to FW over QUALCOMM MSM Interface (QMI).

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig  |   2 +-
 drivers/net/wireless/ath/ath10k/Makefile |   4 +
 drivers/net/wireless/ath/ath10k/qmi.c    | 121 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/qmi.h    |  24 ++++++
 4 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 84f071a..9978ad5e 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -42,7 +42,7 @@ config ATH10K_USB
 
 config ATH10K_SNOC
         tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
-        depends on ATH10K && ARCH_QCOM
+        depends on ATH10K && ARCH_QCOM && QCOM_QMI_HELPERS
         ---help---
           This module adds support for integrated WCN3990 chip connected
           to system NOC(SNOC). Currently work in progress and will not
diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index 44d60a6..1730d1d 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -38,5 +38,9 @@ ath10k_usb-y += usb.o
 obj-$(CONFIG_ATH10K_SNOC) += ath10k_snoc.o
 ath10k_snoc-y += snoc.o
 
+obj-$(CONFIG_ATH10K_SNOC) += ath10k_qmi.o
+ath10k_qmi-y += qmi.o \
+		qmi_svc_v01.o
+
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
new file mode 100644
index 0000000..2235182
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -0,0 +1,121 @@
+/*
+ * Copyright (c) 2018 The Linux Foundation. All rights reserved.
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/qrtr.h>
+#include <linux/net.h>
+#include <linux/completion.h>
+#include <linux/idr.h>
+#include <linux/string.h>
+#include <net/sock.h>
+#include <linux/soc/qcom/qmi.h>
+#include "qmi.h"
+#include "qmi_svc_v01.h"
+
+static struct ath10k_qmi *qmi;
+
+static int ath10k_qmi_new_server(struct qmi_handle *qmi_hdl,
+				 struct qmi_service *service)
+{
+	return 0;
+}
+
+static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
+				  struct qmi_service *service)
+{
+}
+
+static struct qmi_ops ath10k_qmi_ops = {
+	.new_server = ath10k_qmi_new_server,
+	.del_server = ath10k_qmi_del_server,
+};
+
+static int ath10k_qmi_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	qmi = devm_kzalloc(&pdev->dev, sizeof(*qmi),
+			   GFP_KERNEL);
+	if (!qmi)
+		return -ENOMEM;
+
+	qmi->pdev = pdev;
+	platform_set_drvdata(pdev, qmi);
+	ret = qmi_handle_init(&qmi->qmi_hdl,
+			      WLFW_BDF_DOWNLOAD_REQ_MSG_V01_MAX_MSG_LEN,
+			      &ath10k_qmi_ops, NULL);
+	if (ret < 0)
+		goto err;
+
+	ret = qmi_add_lookup(&qmi->qmi_hdl, WLFW_SERVICE_ID_V01,
+			     WLFW_SERVICE_VERS_V01, 0);
+	if (ret < 0)
+		goto err;
+
+	pr_debug("qmi client driver probed successfully\n");
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static int ath10k_qmi_remove(struct platform_device *pdev)
+{
+	struct ath10k_qmi *qmi = platform_get_drvdata(pdev);
+
+	qmi_handle_release(&qmi->qmi_hdl);
+
+	return 0;
+}
+
+static const struct of_device_id ath10k_qmi_dt_match[] = {
+	{.compatible = "qcom,ath10k-qmi"},
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, ath10k_qmi_dt_match);
+
+static struct platform_driver ath10k_qmi_clinet = {
+	.probe  = ath10k_qmi_probe,
+	.remove = ath10k_qmi_remove,
+	.driver = {
+		.name = "ath10k QMI client",
+		.owner = THIS_MODULE,
+		.of_match_table = ath10k_qmi_dt_match,
+	},
+};
+
+static int __init ath10k_qmi_init(void)
+{
+	return platform_driver_register(&ath10k_qmi_clinet);
+}
+
+static void __exit ath10k_qmi_exit(void)
+{
+	platform_driver_unregister(&ath10k_qmi_clinet);
+}
+
+module_init(ath10k_qmi_init);
+module_exit(ath10k_qmi_exit);
+
+MODULE_AUTHOR("Qualcomm");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("ath10k QMI client driver");
diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
new file mode 100644
index 0000000..ad256ef
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2018 The Linux Foundation. All rights reserved.
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
+#ifndef _QMI_H_
+#define _QMI_H_
+
+struct ath10k_qmi {
+	struct platform_device *pdev;
+	struct qmi_handle qmi_hdl;
+	struct sockaddr_qrtr sq;
+};
+#endif /* _QMI_H_ */
-- 
1.9.1
