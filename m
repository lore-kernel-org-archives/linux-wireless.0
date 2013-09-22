Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:59901 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab3IVWmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 18:42:47 -0400
Received: by mail-la0-f47.google.com with SMTP id eo20so1904729lab.20
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 15:42:46 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v4 09/16] wcn36xx: add pmc.c
Date: Sun, 22 Sep 2013 23:42:06 +0100
Message-Id: <1379889733-6215-10-git-send-email-k.eugene.e@gmail.com> (sfid-20130923_004254_973884_C6C4185C)
In-Reply-To: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
References: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding pmc.c

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/pmc.c | 62 ++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.c

diff --git a/drivers/net/wireless/ath/wcn36xx/pmc.c b/drivers/net/wireless/ath/wcn36xx/pmc.c
new file mode 100644
index 0000000..28b515c
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/pmc.c
@@ -0,0 +1,62 @@
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
+int wcn36xx_pmc_enter_bmps_state(struct wcn36xx *wcn,
+				 struct ieee80211_vif *vif)
+{
+	int ret = 0;
+	struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
+	/* TODO: Make sure the TX chain clean */
+	ret = wcn36xx_smd_enter_bmps(wcn, vif);
+	if (!ret) {
+		wcn36xx_dbg(WCN36XX_DBG_PMC, "Entered BMPS\n");
+		vif_priv->pw_state = WCN36XX_BMPS;
+	} else {
+		/*
+		 * One of the reasons why HW will not enter BMPS is because
+		 * driver is trying to enter bmps before first beacon was
+		 * received just after auth complete
+		 */
+		wcn36xx_err("Can not enter BMPS!\n");
+	}
+	return ret;
+}
+
+int wcn36xx_pmc_exit_bmps_state(struct wcn36xx *wcn,
+				struct ieee80211_vif *vif)
+{
+	struct wcn36xx_vif *vif_priv = (struct wcn36xx_vif *)vif->drv_priv;
+
+	if (WCN36XX_BMPS != vif_priv->pw_state) {
+		wcn36xx_err("Not in BMPS mode, no need to exit from BMPS mode!\n");
+		return -EINVAL;
+	}
+	wcn36xx_smd_exit_bmps(wcn, vif);
+	vif_priv->pw_state = WCN36XX_FULL_POWER;
+	return 0;
+}
+
+int wcn36xx_enable_keep_alive_null_packet(struct wcn36xx *wcn,
+					  struct ieee80211_vif *vif)
+{
+	wcn36xx_dbg(WCN36XX_DBG_PMC, "%s\n", __func__);
+	return wcn36xx_smd_keep_alive_req(wcn, vif,
+					  WCN36XX_HAL_KEEP_ALIVE_NULL_PKT);
+}
-- 
1.8.1.2

