Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40644 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3HTRlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 13:41:47 -0400
Received: by mail-lb0-f180.google.com with SMTP id a16so712470lbj.39
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 10:41:46 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH 08/16] wcn36xx: Add pmc.h
Date: Tue, 20 Aug 2013 19:41:11 +0200
Message-Id: <1377020479-16935-9-git-send-email-k.eugene.e@gmail.com> (sfid-20130820_194152_400688_9E1F9BFC)
In-Reply-To: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding pmc.h

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/pmc.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.h

diff --git a/drivers/net/wireless/ath/wcn36xx/pmc.h b/drivers/net/wireless/ath/wcn36xx/pmc.h
new file mode 100644
index 0000000..b00d425
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/pmc.h
@@ -0,0 +1,32 @@
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
+int wcn36xx_pmc_init(struct wcn36xx *wcn);
+int wcn36xx_pmc_enter_bmps_state(struct wcn36xx *wcn, u64 tbtt);
+int wcn36xx_pmc_exit_bmps_state(struct wcn36xx *wcn);
+int wcn36xx_enable_keep_alive_null_packet(struct wcn36xx *wcn);
+int wcn36xx_enable_keep_alive_null_packet(struct wcn36xx *wcn);
+#endif	/* _WCN36XX_PMC_H_ */
-- 
1.8.2.2

