Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:37138 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3HWI7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 04:59:33 -0400
Received: by mail-lb0-f170.google.com with SMTP id r10so267851lbi.15
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 01:59:32 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v2 07/16] wcn36xx: add pmc.c
Date: Fri, 23 Aug 2013 10:58:10 +0200
Message-Id: <1377248299-21007-8-git-send-email-k.eugene.e@gmail.com> (sfid-20130823_105949_706653_34C2EE36)
In-Reply-To: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding pmc.c

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/pmc.c | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.c

diff --git a/drivers/net/wireless/ath/wcn36xx/pmc.c b/drivers/net/wireless/ath/wcn36xx/pmc.c
new file mode 100644
index 0000000..f72096e
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/pmc.c
@@ -0,0 +1,46 @@
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "wcn36xx.h"
+
+int wcn36xx_pmc_init(struct wcn36xx *wcn)
+{
+	wcn->pw_state = WCN36XX_FULL_POWER;
+	return 0;
+}
+
+int wcn36xx_pmc_enter_bmps_state(struct wcn36xx *wcn, u64 tsf)
+{
+	/* TODO: Make sure the TX chain clean */
+	wcn36xx_smd_enter_bmps(wcn, tsf);
+	wcn->pw_state = WCN36XX_BMPS;
+	return 0;
+}
+
+int wcn36xx_pmc_exit_bmps_state(struct wcn36xx *wcn)
+{
+	wcn36xx_smd_exit_bmps(wcn);
+	wcn->pw_state = WCN36XX_FULL_POWER;
+	return 0;
+}
+
+int wcn36xx_enable_keep_alive_null_packet(struct wcn36xx *wcn)
+{
+	wcn36xx_dbg(WCN36XX_DBG_PMC, "%s\n", __func__);
+	return wcn36xx_smd_keep_alive_req(wcn, WCN36XX_HAL_KEEP_ALIVE_NULL_PKT);
+}
-- 
1.8.2.2

