Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:33547 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759316Ab2CBU0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 15:26:48 -0500
Received: from zeta.dmz-us.st.com (ns4.st.com [167.4.16.71])
	by beta.dmz-us.st.com (STMicroelectronics) with ESMTP id 919A671
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 20:26:33 +0000 (GMT)
Received: from relay2.stm.gmessaging.net (unknown [10.230.100.18])
	by zeta.dmz-us.st.com (STMicroelectronics) with ESMTP id C4A5757
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 18:57:20 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay2.stm.gmessaging.net (Postfix) with ESMTPS id 66C63A8065
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 21:26:37 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCHv2 02/21] cw1200: cw1200_plat.h, definition of the driver'ss platform data.
Date: Fri, 2 Mar 2012 21:26:24 +0100
Message-ID: <1330720003-15866-3-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_212655_257109_F7855BDC)
In-Reply-To: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <983b0e2d75af161b8e4dec02fc3497926a0080df-submit>
 <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cw1200 driver requires platform data to be provided by arch code.
The purpose of the platform data is to expose resources for out-of-band
(comparing to main interface, sdio etc) signaling, like OOB irq, clock,
power and reset control.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/net/wireless/cw1200/cw1200_plat.h |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/cw1200/cw1200_plat.h

diff --git a/drivers/net/wireless/cw1200/cw1200_plat.h b/drivers/net/wireless/cw1200/cw1200_plat.h
new file mode 100644
index 0000000..3a73183
--- /dev/null
+++ b/drivers/net/wireless/cw1200/cw1200_plat.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011-2012
+ *
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef CW1200_PLAT_H_INCLUDED
+#define CW1200_PLAT_H_INCLUDED
+
+#include <linux/ioport.h>
+
+struct cw1200_platform_data {
+	const char *mmc_id;
+	const struct resource *irq;
+	const struct resource *reset;
+	int (*power_ctrl)(const struct cw1200_platform_data *pdata,
+			  bool enable);
+	int (*clk_ctrl)(const struct cw1200_platform_data *pdata,
+			  bool enable);
+	int (*prcmu_ctrl)(const struct cw1200_platform_data *pdata,
+			  bool enable);
+};
+
+/* Declaration only. Should be implemented in arch/xxx/mach-yyy */
+const struct cw1200_platform_data *cw1200_get_platform_data(void);
+
+#endif /* CW1200_PLAT_H_INCLUDED */
-- 
1.7.9

