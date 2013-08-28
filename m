Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:52428 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3H1H5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 03:57:43 -0400
Received: by mail-lb0-f179.google.com with SMTP id v1so4317931lbd.24
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 00:57:41 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v3 03/16] wcn36xx: add debug.h
Date: Wed, 28 Aug 2013 09:56:33 +0200
Message-Id: <1377676606-23033-4-git-send-email-k.eugene.e@gmail.com> (sfid-20130828_095748_142679_638EF887)
In-Reply-To: <1377676606-23033-1-git-send-email-k.eugene.e@gmail.com>
References: <1377676606-23033-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add debug.h

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/debug.h | 49 ++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/debug.h

diff --git a/drivers/net/wireless/ath/wcn36xx/debug.h b/drivers/net/wireless/ath/wcn36xx/debug.h
new file mode 100644
index 0000000..46307aa
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/debug.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (c) 2013 Eugene Krasnikov <k.eugene.e@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _WCN36XX_DEBUG_H_
+#define _WCN36XX_DEBUG_H_
+
+#include <linux/kernel.h>
+
+#define WCN36xx_MAX_DUMP_ARGS	5
+
+#ifdef CONFIG_WCN36XX_DEBUGFS
+struct wcn36xx_dfs_file {
+	struct dentry *dentry;
+	u32 value;
+};
+
+struct wcn36xx_dfs_entry {
+	struct dentry *rootdir;
+	struct wcn36xx_dfs_file file_bmps_switcher;
+	struct wcn36xx_dfs_file file_dump;
+};
+
+void wcn36xx_debugfs_init(struct wcn36xx *wcn);
+void wcn36xx_debugfs_exit(struct wcn36xx *wcn);
+
+#else
+static inline void wcn36xx_debugfs_init(struct wcn36xx *wcn)
+{
+}
+static inline void wcn36xx_debugfs_exit(struct wcn36xx *wcn)
+{
+}
+
+#endif /* CONFIG_WCN36XX_DEBUGFS */
+
+#endif	/* _WCN36XX_DEBUG_H_ */
-- 
1.8.2.2

