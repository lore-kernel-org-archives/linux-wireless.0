Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:60411 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3IVWmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 18:42:46 -0400
Received: by mail-la0-f54.google.com with SMTP id ea20so2001631lab.27
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 15:42:45 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v4 08/16] wcn36xx: add pmc.h
Date: Sun, 22 Sep 2013 23:42:05 +0100
Message-Id: <1379889733-6215-9-git-send-email-k.eugene.e@gmail.com> (sfid-20130923_004256_384971_E78C99CA)
In-Reply-To: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
References: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding pmc.h

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/pmc.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.h

diff --git a/drivers/net/wireless/ath/wcn36xx/pmc.h b/drivers/net/wireless/ath/wcn36xx/pmc.h
new file mode 100644
index 0000000..f72ed68
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/pmc.h
@@ -0,0 +1,33 @@
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
+#ifndef _WCN36XX_PMC_H_
+#define _WCN36XX_PMC_H_
+
+struct wcn36xx;
+
+enum wcn36xx_power_state {
+	WCN36XX_FULL_POWER,
+	WCN36XX_BMPS
+};
+
+int wcn36xx_pmc_enter_bmps_state(struct wcn36xx *wcn,
+				 struct ieee80211_vif *vif);
+int wcn36xx_pmc_exit_bmps_state(struct wcn36xx *wcn,
+				struct ieee80211_vif *vif);
+int wcn36xx_enable_keep_alive_null_packet(struct wcn36xx *wcn,
+					  struct ieee80211_vif *vif);
+#endif	/* _WCN36XX_PMC_H_ */
-- 
1.8.1.2

