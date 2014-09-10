Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4690 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaIJNfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:18 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Dedy Lansky <qca_dlansky@qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/22] wil6210: platform specific module
Date: Wed, 10 Sep 2014 16:34:35 +0300
Message-ID: <1410356091-19219-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153531_024391_F936BE1F)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New module (wil_platform) for handling platform specific tasks

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Kconfig           |   9 +
 drivers/net/wireless/ath/wil6210/Makefile          |   2 +
 drivers/net/wireless/ath/wil6210/main.c            |   7 +
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |   8 +
 drivers/net/wireless/ath/wil6210/wil6210.h         |   7 +
 drivers/net/wireless/ath/wil6210/wil_platform.c    |  49 ++++
 drivers/net/wireless/ath/wil6210/wil_platform.h    |  34 +++
 .../net/wireless/ath/wil6210/wil_platform_msm.c    | 257 +++++++++++++++++++++
 .../net/wireless/ath/wil6210/wil_platform_msm.h    |  24 ++
 9 files changed, 397 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform_msm.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform_msm.h

diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index ce8c038..481680a 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -39,3 +39,12 @@ config WIL6210_TRACING
 	  option if you are interested in debugging the driver.
 
 	  If unsure, say Y to make it easier to debug problems.
+
+config WIL6210_PLATFORM_MSM
+	bool "wil6210 MSM platform specific support"
+	depends on WIL6210
+	depends on ARCH_MSM
+	default y
+	---help---
+	  Say Y here to enable wil6210 driver support for MSM
+	  platform specific features
diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index dc788a1..a471d74 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -12,6 +12,8 @@ wil6210-y += debug.o
 wil6210-y += rx_reorder.o
 wil6210-y += fw.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
+wil6210-y += wil_platform.o
+wil6210-$(CONFIG_WIL6210_PLATFORM_MSM) += wil_platform_msm.o
 
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 4a884b4..8afd8a2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -603,6 +603,10 @@ static int __wil_up(struct wil6210_priv *wil)
 	napi_enable(&wil->napi_tx);
 	set_bit(wil_status_napi_en, &wil->status);
 
+	if (wil->platform_ops.bus_request)
+		wil->platform_ops.bus_request(wil->platform_handle,
+					      WIL_MAX_BUS_REQUEST_KBPS);
+
 	return 0;
 }
 
@@ -621,6 +625,9 @@ static int __wil_down(struct wil6210_priv *wil)
 {
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
+	if (wil->platform_ops.bus_request)
+		wil->platform_ops.bus_request(wil->platform_handle, 0);
+
 	clear_bit(wil_status_napi_en, &wil->status);
 	napi_disable(&wil->napi_rx);
 	napi_disable(&wil->napi_tx);
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 38dcbea..968f0d6 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -180,6 +180,10 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	wil->board = board;
 
 	wil6210_clear_irq(wil);
+
+	wil->platform_handle =
+			wil_platform_init(&pdev->dev, &wil->platform_ops);
+
 	/* FW should raise IRQ when ready */
 	rc = wil_if_pcie_enable(wil);
 	if (rc) {
@@ -204,6 +208,8 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  bus_disable:
 	wil_if_pcie_disable(wil);
  if_free:
+	if (wil->platform_ops.uninit)
+		wil->platform_ops.uninit(wil->platform_handle);
 	wil_if_free(wil);
  err_iounmap:
 	pci_iounmap(pdev, csr);
@@ -223,6 +229,8 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 	wil6210_debugfs_remove(wil);
 	wil_if_pcie_disable(wil);
 	wil_if_remove(wil);
+	if (wil->platform_ops.uninit)
+		wil->platform_ops.uninit(wil->platform_handle);
 	wil_if_free(wil);
 	pci_iounmap(pdev, csr);
 	pci_release_region(pdev, 0);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 5f20fab..d2e710e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -21,10 +21,14 @@
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
 #include <linux/timex.h>
+#include "wil_platform.h"
+
 
 #define WIL_NAME "wil6210"
 #define WIL_FW_NAME "wil6210.fw"
 
+#define WIL_MAX_BUS_REQUEST_KBPS 800000 /* ~6.1Gbps */
+
 struct wil_board {
 	int board;
 #define WIL_BOARD_MARLON	(1)
@@ -437,6 +441,9 @@ struct wil6210_priv {
 	/* debugfs */
 	struct dentry *debug;
 	struct debugfs_blob_wrapper blobs[ARRAY_SIZE(fw_mapping)];
+
+	void *platform_handle;
+	struct wil_platform_ops platform_ops;
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.c b/drivers/net/wireless/ath/wil6210/wil_platform.c
new file mode 100644
index 0000000..8f1d78f
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.c
@@ -0,0 +1,49 @@
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
+#include "linux/device.h"
+#include "wil_platform.h"
+
+#ifdef CONFIG_WIL6210_PLATFORM_MSM
+#include "wil_platform_msm.h"
+#endif
+
+/**
+ * wil_platform_init() - wil6210 platform module init
+ *
+ * The function must be called before all other functions in this module.
+ * It returns a handle which is used with the rest of the API
+ *
+ */
+void *wil_platform_init(struct device *dev, struct wil_platform_ops *ops)
+{
+	void *handle = NULL;
+
+	if (!ops) {
+		dev_err(dev, "Invalid parameter. Cannot init platform module\n");
+		return NULL;
+	}
+
+#ifdef CONFIG_WIL6210_PLATFORM_MSM
+	handle = wil_platform_msm_init(dev, ops);
+	if (handle)
+		return handle;
+#endif
+
+	/* other platform specific init functions should be called here */
+
+	return handle;
+}
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
new file mode 100644
index 0000000..158c73b
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -0,0 +1,34 @@
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
+#ifndef __WIL_PLATFORM_H__
+#define __WIL_PLATFORM_H__
+
+struct device;
+
+/**
+ * struct wil_platform_ops - wil platform module callbacks
+ */
+struct wil_platform_ops {
+	int (*bus_request)(void *handle, uint32_t kbps /* KBytes/Sec */);
+	int (*suspend)(void *handle);
+	int (*resume)(void *handle);
+	void (*uninit)(void *handle);
+};
+
+void *wil_platform_init(struct device *dev, struct wil_platform_ops *ops);
+
+#endif /* __WIL_PLATFORM_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform_msm.c b/drivers/net/wireless/ath/wil6210/wil_platform_msm.c
new file mode 100644
index 0000000..b354a74
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wil_platform_msm.c
@@ -0,0 +1,257 @@
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
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/msm-bus.h>
+
+#include "wil_platform.h"
+#include "wil_platform_msm.h"
+
+/**
+ * struct wil_platform_msm - wil6210 msm platform module info
+ *
+ * @dev: device object
+ * @msm_bus_handle: handle for using msm_bus API
+ * @pdata: bus scale info retrieved from DT
+ */
+struct wil_platform_msm {
+	struct device *dev;
+	uint32_t msm_bus_handle;
+	struct msm_bus_scale_pdata *pdata;
+};
+
+#define KBTOB(a) (a * 1000ULL)
+
+/**
+ * wil_platform_get_pdata() - Generate bus client data from device tree
+ * provided by clients.
+ *
+ * dev: device object
+ * of_node: Device tree node to extract information from
+ *
+ * The function returns a valid pointer to the allocated bus-scale-pdata
+ * if the vectors were correctly read from the client's device node.
+ * Any error in reading or parsing the device node will return NULL
+ * to the caller.
+ */
+static struct msm_bus_scale_pdata *wil_platform_get_pdata(
+		struct device *dev,
+		struct device_node *of_node)
+{
+	struct msm_bus_scale_pdata *pdata;
+	struct msm_bus_paths *usecase;
+	int i, j, ret, len;
+	unsigned int num_usecases, num_paths, mem_size;
+	const uint32_t *vec_arr;
+	struct msm_bus_vectors *vectors;
+
+	/* first read num_usecases and num_paths so we can calculate
+	 * amount of memory to allocate
+	 */
+	ret = of_property_read_u32(of_node, "qcom,msm-bus,num-cases",
+				   &num_usecases);
+	if (ret) {
+		dev_err(dev, "Error: num-usecases not found\n");
+		return NULL;
+	}
+
+	ret = of_property_read_u32(of_node, "qcom,msm-bus,num-paths",
+				   &num_paths);
+	if (ret) {
+		dev_err(dev, "Error: num_paths not found\n");
+		return NULL;
+	}
+
+	/* pdata memory layout:
+	 *   msm_bus_scale_pdata
+	 *   msm_bus_paths[num_usecases]
+	 *   msm_bus_vectors[num_usecases][num_paths]
+	 */
+	mem_size = sizeof(struct msm_bus_scale_pdata) +
+		   sizeof(struct msm_bus_paths) * num_usecases +
+		   sizeof(struct msm_bus_vectors) * num_usecases * num_paths;
+
+	pdata = kzalloc(mem_size, GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	ret = of_property_read_string(of_node, "qcom,msm-bus,name",
+				      &pdata->name);
+	if (ret) {
+		dev_err(dev, "Error: Client name not found\n");
+		goto err;
+	}
+
+	if (of_property_read_bool(of_node, "qcom,msm-bus,active-only")) {
+		pdata->active_only = 1;
+	} else {
+		dev_info(dev, "active_only flag absent.\n");
+		dev_info(dev, "Using dual context by default\n");
+	}
+
+	pdata->num_usecases = num_usecases;
+	pdata->usecase = (struct msm_bus_paths *)(pdata + 1);
+
+	vec_arr = of_get_property(of_node, "qcom,msm-bus,vectors-KBps", &len);
+	if (vec_arr == NULL) {
+		dev_err(dev, "Error: Vector array not found\n");
+		goto err;
+	}
+
+	if (len != num_usecases * num_paths * sizeof(uint32_t) * 4) {
+		dev_err(dev, "Error: Length-error on getting vectors\n");
+		goto err;
+	}
+
+	vectors = (struct msm_bus_vectors *)(pdata->usecase + num_usecases);
+	for (i = 0; i < num_usecases; i++) {
+		usecase = &pdata->usecase[i];
+		usecase->num_paths = num_paths;
+		usecase->vectors = &vectors[i];
+
+		for (j = 0; j < num_paths; j++) {
+			int index = ((i * num_paths) + j) * 4;
+
+			usecase->vectors[j].src = be32_to_cpu(vec_arr[index]);
+			usecase->vectors[j].dst =
+				be32_to_cpu(vec_arr[index + 1]);
+			usecase->vectors[j].ab = (uint64_t)
+				KBTOB(be32_to_cpu(vec_arr[index + 2]));
+			usecase->vectors[j].ib = (uint64_t)
+				KBTOB(be32_to_cpu(vec_arr[index + 3]));
+		}
+	}
+
+	return pdata;
+
+err:
+	kfree(pdata);
+
+	return NULL;
+}
+
+/* wil_platform API (callbacks) */
+
+static int wil_platform_bus_request(void *handle,
+				    uint32_t kbps /* KBytes/Sec */)
+{
+	int rc, i;
+	struct wil_platform_msm *msm = (struct wil_platform_msm *)handle;
+	int vote = 0; /* vote 0 in case requested kbps cannot be satisfied */
+	struct msm_bus_paths *usecase;
+	uint32_t usecase_kbps;
+	uint32_t min_kbps = ~0;
+
+	/* find the lowest usecase that is bigger than requested kbps */
+	for (i = 0; i < msm->pdata->num_usecases; i++) {
+		usecase = &msm->pdata->usecase[i];
+		/* assume we have single path (vectors[0]). If we ever
+		 * have multiple paths, need to define the behavior */
+		usecase_kbps = div64_u64(usecase->vectors[0].ib, 1000);
+		if (usecase_kbps >= kbps && usecase_kbps < min_kbps) {
+			min_kbps = usecase_kbps;
+			vote = i;
+		}
+	}
+
+	rc = msm_bus_scale_client_update_request(msm->msm_bus_handle, vote);
+	if (rc)
+		dev_err(msm->dev, "Failed msm_bus voting. kbps=%d vote=%d, rc=%d\n",
+			kbps, vote, rc);
+	else
+		/* TOOD: remove */
+		dev_info(msm->dev, "msm_bus_scale_client_update_request succeeded. kbps=%d vote=%d\n",
+			 kbps, vote);
+
+	return rc;
+}
+
+static void wil_platform_uninit(void *handle)
+{
+	struct wil_platform_msm *msm = (struct wil_platform_msm *)handle;
+
+	dev_info(msm->dev, "wil_platform_uninit\n");
+
+	if (msm->msm_bus_handle)
+		msm_bus_scale_unregister_client(msm->msm_bus_handle);
+
+	kfree(msm->pdata);
+	kfree(msm);
+}
+
+static int wil_platform_msm_bus_register(struct wil_platform_msm *msm,
+					 struct device_node *node)
+{
+	msm->pdata = wil_platform_get_pdata(msm->dev, node);
+	if (!msm->pdata) {
+		dev_err(msm->dev, "Failed getting DT info\n");
+		return -EINVAL;
+	}
+
+	msm->msm_bus_handle = msm_bus_scale_register_client(msm->pdata);
+	if (!msm->msm_bus_handle) {
+		dev_err(msm->dev, "Failed msm_bus registration\n");
+		return -EINVAL;
+	}
+
+	dev_info(msm->dev, "msm_bus registration succeeded! handle 0x%x\n",
+		 msm->msm_bus_handle);
+
+	return 0;
+}
+
+/**
+ * wil_platform_msm_init() - wil6210 msm platform module init
+ *
+ * The function must be called before all other functions in this module.
+ * It returns a handle which is used with the rest of the API
+ *
+ */
+void *wil_platform_msm_init(struct device *dev, struct wil_platform_ops *ops)
+{
+	struct device_node *of_node;
+	struct wil_platform_msm *msm;
+	int rc;
+
+	of_node = of_find_compatible_node(NULL, NULL, "qcom,wil6210");
+	if (!of_node) {
+		/* this could mean non-msm platform */
+		dev_err(dev, "DT node not found\n");
+		return NULL;
+	}
+
+	msm = kzalloc(sizeof(*msm), GFP_KERNEL);
+	if (!msm)
+		return NULL;
+
+	msm->dev = dev;
+
+	/* register with msm_bus module for scaling requests */
+	rc = wil_platform_msm_bus_register(msm, of_node);
+	if (rc)
+		goto cleanup;
+
+	memset(ops, 0, sizeof(*ops));
+	ops->bus_request = wil_platform_bus_request;
+	ops->uninit = wil_platform_uninit;
+
+	return (void *)msm;
+
+cleanup:
+	kfree(msm);
+	return NULL;
+}
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform_msm.h b/drivers/net/wireless/ath/wil6210/wil_platform_msm.h
new file mode 100644
index 0000000..2f2229e
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wil_platform_msm.h
@@ -0,0 +1,24 @@
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
+#ifndef __WIL_PLATFORM__MSM_H__
+#define __WIL_PLATFORM_MSM_H__
+
+#include "wil_platform.h"
+
+void *wil_platform_msm_init(struct device *dev, struct wil_platform_ops *ops);
+
+#endif /* __WIL_PLATFORM__MSM_H__ */
-- 
1.9.1

