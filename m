Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbJDHX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 03:23:59 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Lior David <liord@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 09/10] wil6210: dump firmware memory when firmware crashes
Date: Sun,  4 Oct 2015 10:23:26 +0300
Message-Id: <1443943407-6663-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151004_094654_066940_F69E9D0C)
In-Reply-To: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1443943407-6663-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When firmware crashes, just before firmware recovery,
dump the firmware memory to a devcoredump device.
The resulting dump can be read from user space to be used
in offline crash analysis.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Kconfig          |   1 +
 drivers/net/wireless/ath/wil6210/Makefile         |   1 +
 drivers/net/wireless/ath/wil6210/interrupt.c      |   3 +-
 drivers/net/wireless/ath/wil6210/wil6210.h        |   2 +
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c | 115 ++++++++++++++++++++++
 5 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_crash_dump.c

diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index ce8c038..6dfedc8 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -1,5 +1,6 @@
 config WIL6210
 	tristate "Wilocity 60g WiFi card wil6210 support"
+	select WANT_DEV_COREDUMP
 	depends on CFG80211
 	depends on PCI
 	default n
diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index 64b4326..fdf63d5 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -17,6 +17,7 @@ wil6210-y += pmc.o
 wil6210-$(CONFIG_WIL6210_TRACING) += trace.o
 wil6210-y += wil_platform.o
 wil6210-y += ethtool.o
+wil6210-y += wil_crash_dump.o
 
 # for tracing framework to find trace.h
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index f651994..06fc46f 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2015 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -391,6 +391,7 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 	wil_dbg_irq(wil, "Thread ISR MISC 0x%08x\n", isr);
 
 	if (isr & ISR_MISC_FW_ERROR) {
+		wil_fw_core_dump(wil);
 		wil_notify_fw_error(wil);
 		isr &= ~ISR_MISC_FW_ERROR;
 		wil_fw_error_recovery(wil);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 525ce2c..9a90a58 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -827,4 +827,6 @@ int wil_can_suspend(struct wil6210_priv *wil, bool is_runtime);
 int wil_suspend(struct wil6210_priv *wil, bool is_runtime);
 int wil_resume(struct wil6210_priv *wil, bool is_runtime);
 
+void wil_fw_core_dump(struct wil6210_priv *wil);
+
 #endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wil_crash_dump.c b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
new file mode 100644
index 0000000..7e70934
--- /dev/null
+++ b/drivers/net/wireless/ath/wil6210/wil_crash_dump.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
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
+#include <linux/devcoredump.h>
+
+static int wil_fw_get_crash_dump_bounds(struct wil6210_priv *wil,
+					u32 *out_dump_size, u32 *out_host_min)
+{
+	int i;
+	const struct fw_map *map;
+	u32 host_min, host_max, tmp_max;
+
+	if (!out_dump_size)
+		return -EINVAL;
+
+	/* calculate the total size of the unpacked crash dump */
+	BUILD_BUG_ON(ARRAY_SIZE(fw_mapping) == 0);
+	map = &fw_mapping[0];
+	host_min = map->host;
+	host_max = map->host + (map->to - map->from);
+
+	for (i = 1; i < ARRAY_SIZE(fw_mapping); i++) {
+		map = &fw_mapping[i];
+
+		if (map->host < host_min)
+			host_min = map->host;
+
+		tmp_max = map->host + (map->to - map->from);
+		if (tmp_max > host_max)
+			host_max = tmp_max;
+	}
+
+	*out_dump_size = host_max - host_min;
+	if (out_host_min)
+		*out_host_min = host_min;
+
+	return 0;
+}
+
+static int wil_fw_copy_crash_dump(struct wil6210_priv *wil, void *dest,
+				  u32 size)
+{
+	int i;
+	const struct fw_map *map;
+	void *data;
+	u32 host_min, dump_size, offset, len;
+
+	if (wil_fw_get_crash_dump_bounds(wil, &dump_size, &host_min)) {
+		wil_err(wil, "%s: fail to obtain crash dump size\n", __func__);
+		return -EINVAL;
+	}
+
+	if (dump_size > size) {
+		wil_err(wil, "%s: not enough space for dump. Need %d have %d\n",
+			__func__, dump_size, size);
+		return -EINVAL;
+	}
+
+	/* copy to crash dump area */
+	for (i = 0; i < ARRAY_SIZE(fw_mapping); i++) {
+		map = &fw_mapping[i];
+
+		data = (void * __force)wil->csr + HOSTADDR(map->host);
+		len = map->to - map->from;
+		offset = map->host - host_min;
+
+		wil_dbg_misc(wil, "%s() - dump %s, size %d, offset %d\n",
+			     __func__, fw_mapping[i].name, len, offset);
+
+		wil_memcpy_fromio_32((void * __force)(dest + offset),
+				     (const void __iomem * __force)data, len);
+	}
+
+	return 0;
+}
+
+void wil_fw_core_dump(struct wil6210_priv *wil)
+{
+	void *fw_dump_data;
+	u32 fw_dump_size;
+
+	if (wil_fw_get_crash_dump_bounds(wil, &fw_dump_size, NULL)) {
+		wil_err(wil, "%s: fail to get fw dump size\n", __func__);
+		return;
+	}
+
+	fw_dump_data = vzalloc(fw_dump_size);
+	if (!fw_dump_data)
+		return;
+
+	if (wil_fw_copy_crash_dump(wil, fw_dump_data, fw_dump_size)) {
+		vfree(fw_dump_data);
+		return;
+	}
+	/* fw_dump_data will be free in device coredump release function
+	 * after 5 min
+	 */
+	dev_coredumpv(wil_to_dev(wil), fw_dump_data, fw_dump_size, GFP_KERNEL);
+	wil_info(wil, "%s: fw core dumped, size %d bytes\n", __func__,
+		 fw_dump_size);
+}
-- 
2.1.4

