Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:59890 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab2CBBlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 20:41:37 -0500
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A02972E3
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:35 +0000 (GMT)
Received: from relay1.stm.gmessaging.net (unknown [10.230.100.17])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2F0CB47AD
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:35 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay1.stm.gmessaging.net (Postfix) with ESMTPS id B388324C2C0
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 02:41:33 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 02/21] cw1200: cw1200_plat.h, definition of the driver'ss platform data.
Date: Fri, 2 Mar 2012 02:41:16 +0100
Message-ID: <1330652495-25837-3-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024141_238069_439FC58A)
In-Reply-To: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
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
 drivers/staging/cw1200/cw1200_plat.h |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/cw1200/cw1200_plat.h

diff --git a/drivers/staging/cw1200/cw1200_plat.h b/drivers/staging/cw1200/cw1200_plat.h
new file mode 100644
index 0000000..3a73183
--- /dev/null
+++ b/drivers/staging/cw1200/cw1200_plat.h
@@ -0,0 +1,28 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
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

