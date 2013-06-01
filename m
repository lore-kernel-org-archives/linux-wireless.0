Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:46523 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3FALZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 07:25:10 -0400
Subject: [PATCH v2 08/29] ath10k: add debug.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Sat, 01 Jun 2013 14:25:06 +0300
Message-ID: <20130601112506.32443.68113.stgit@localhost6.localdomain6> (sfid-20130601_132512_410683_0C5E3F38)
In-Reply-To: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
References: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.h |   90 +++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/debug.h

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
new file mode 100644
index 0000000..168140c
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -0,0 +1,90 @@
+/*
+ * Copyright (c) 2005-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2013 Qualcomm Atheros, Inc.
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
+#ifndef _DEBUG_H_
+#define _DEBUG_H_
+
+#include <linux/types.h>
+#include "trace.h"
+
+enum ath10k_debug_mask {
+	ATH10K_DBG_PCI		= 0x00000001,
+	ATH10K_DBG_WMI		= 0x00000002,
+	ATH10K_DBG_HTC		= 0x00000004,
+	ATH10K_DBG_HTT		= 0x00000008,
+	ATH10K_DBG_MAC		= 0x00000010,
+	ATH10K_DBG_CORE		= 0x00000020,
+	ATH10K_DBG_PCI_DUMP	= 0x00000040,
+	ATH10K_DBG_HTT_DUMP	= 0x00000080,
+	ATH10K_DBG_MGMT		= 0x00000100,
+	ATH10K_DBG_DATA		= 0x00000200,
+	ATH10K_DBG_ANY		= 0xffffffff,
+};
+
+extern unsigned int ath10k_debug_mask;
+
+extern __printf(1, 2) int ath10k_info(const char *fmt, ...);
+extern __printf(1, 2) int ath10k_err(const char *fmt, ...);
+extern __printf(1, 2) int ath10k_warn(const char *fmt, ...);
+
+#ifdef CONFIG_ATH10K_DEBUGFS
+int ath10k_debug_create(struct ath10k *ar);
+void ath10k_debug_read_service_map(struct ath10k *ar,
+				   void *service_map,
+				   size_t map_size);
+void ath10k_debug_read_target_stats(struct ath10k *ar,
+				    struct wmi_stats_event *ev);
+
+#else
+static inline int ath10k_debug_create(struct ath10k *ar)
+{
+	return 0;
+}
+
+static inline void ath10k_debug_read_service_map(struct ath10k *ar,
+						 void *service_map,
+						 size_t map_size)
+{
+}
+
+static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
+						  struct wmi_stats_event *ev)
+{
+}
+#endif /* CONFIG_ATH10K_DEBUGFS */
+
+#ifdef CONFIG_ATH10K_DEBUG
+extern __printf(2, 3) void ath10k_dbg(enum ath10k_debug_mask mask,
+				      const char *fmt, ...);
+void ath10k_dbg_dump(enum ath10k_debug_mask mask,
+		     const char *msg, const char *prefix,
+		     const void *buf, size_t len);
+#else /* CONFIG_ATH10K_DEBUG */
+
+static inline int ath10k_dbg(enum ath10k_debug_mask dbg_mask,
+			     const char *fmt, ...)
+{
+	return 0;
+}
+
+static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
+				   const char *msg, const char *prefix,
+				   const void *buf, size_t len)
+{
+}
+#endif /* CONFIG_ATH10K_DEBUG */
+#endif /* _DEBUG_H_ */

