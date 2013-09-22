Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:50807 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3IVWmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 18:42:40 -0400
Received: by mail-lb0-f175.google.com with SMTP id y6so2119854lbh.6
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 15:42:39 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v4 04/16] wcn36xx: add debug.h
Date: Sun, 22 Sep 2013 23:42:01 +0100
Message-Id: <1379889733-6215-5-git-send-email-k.eugene.e@gmail.com> (sfid-20130923_004245_221813_D55F10E7)
In-Reply-To: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
References: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding debug.h

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
1.8.1.2

