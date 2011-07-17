Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:55290 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1GQKWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 06:22:21 -0400
Subject: [PATCH v2 09/23] ath6kl: add hif-ops.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: joe@perches.com, devel@linuxdriverproject.org, gregkh@suse.de,
	error27@gmail.com
Date: Sun, 17 Jul 2011 13:22:14 +0300
Message-ID: <20110717102214.18367.59872.stgit@localhost6.localdomain6> (sfid-20110717_122223_199525_27F688D3)
In-Reply-To: <20110717101844.18367.44984.stgit@localhost6.localdomain6>
References: <20110717101844.18367.44984.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif-ops.h |   67 +++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/hif-ops.h

diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
new file mode 100644
index 0000000..ad49669
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -0,0 +1,67 @@
+/*
+ * Copyright (c) 2004-2011 Atheros Communications Inc.
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
+#ifndef HIF_OPS_H
+#define HIF_OPS_H
+
+#include "hif.h"
+
+static inline int hif_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
+				      u32 len, u32 request)
+{
+	return ar->hif_ops->read_write_sync(ar, addr, buf, len, request);
+}
+
+static inline int hif_write_async(struct ath6kl *ar, u32 address, u8 *buffer,
+				  u32 length, u32 request,
+				  struct htc_packet *packet)
+{
+	return ar->hif_ops->write_async(ar, address, buffer, length,
+					request, packet);
+}
+static inline void ath6kl_hif_irq_enable(struct ath6kl *ar)
+{
+	return ar->hif_ops->irq_enable(ar);
+}
+
+static inline void ath6kl_hif_irq_disable(struct ath6kl *ar)
+{
+	return ar->hif_ops->irq_disable(ar);
+}
+
+static inline struct hif_scatter_req *hif_scatter_req_get(struct ath6kl *ar)
+{
+	return ar->hif_ops->scatter_req_get(ar);
+}
+
+static inline void hif_scatter_req_add(struct ath6kl *ar,
+				       struct hif_scatter_req *s_req)
+{
+	return ar->hif_ops->scatter_req_add(ar, s_req);
+}
+
+static inline int ath6kl_hif_enable_scatter(struct ath6kl *ar,
+					    struct hif_dev_scat_sup_info *info)
+{
+	return ar->hif_ops->enable_scatter(ar, info);
+}
+
+static inline void ath6kl_hif_cleanup_scatter(struct ath6kl *ar)
+{
+	return ar->hif_ops->cleanup_scatter(ar);
+}
+
+#endif

