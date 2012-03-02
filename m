Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:35134 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756630Ab2CBBll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 20:41:41 -0500
Received: from zeta.dmz-ap.st.com (ns6.st.com [138.198.234.13])
	by beta.dmz-ap.st.com (STMicroelectronics) with ESMTP id E6468CE
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:33:11 +0000 (GMT)
Received: from relay2.stm.gmessaging.net (unknown [10.230.100.18])
	by zeta.dmz-ap.st.com (STMicroelectronics) with ESMTP id 803923C0
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 01:41:36 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay2.stm.gmessaging.net (Postfix) with ESMTPS id D8DB5A8065
	for <linux-wireless@vger.kernel.org>; Fri,  2 Mar 2012 02:41:34 +0100 (CET)
From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 03/21] cw1200: sbus.h, common device interface abstraction.
Date: Fri, 2 Mar 2012 02:41:17 +0100
Message-ID: <1330652495-25837-4-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024148_186285_B2D3BEB9)
In-Reply-To: <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch contains definition of hardware abstraction layer between
cw1200 core driver and physical device interface. A bunch of wrappers
can be build using this interface: sdio, spi, c2c etc.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 drivers/staging/cw1200/sbus.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/cw1200/sbus.h

diff --git a/drivers/staging/cw1200/sbus.h b/drivers/staging/cw1200/sbus.h
new file mode 100644
index 0000000..49bd06d
--- /dev/null
+++ b/drivers/staging/cw1200/sbus.h
@@ -0,0 +1,39 @@
+/*
+ * Common sbus abstraction layer interface for cw1200 wireless driver
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CW1200_SBUS_H
+#define CW1200_SBUS_H
+
+/*
+ * sbus priv forward definition.
+ * Implemented and instantiated in particular modules.
+ */
+struct sbus_priv;
+
+typedef void (*sbus_irq_handler)(void *priv);
+
+struct sbus_ops {
+	int (*sbus_memcpy_fromio)(struct sbus_priv *self, unsigned int addr,
+					void *dst, int count);
+	int (*sbus_memcpy_toio)(struct sbus_priv *self, unsigned int addr,
+					const void *src, int count);
+	void (*lock)(struct sbus_priv *self);
+	void (*unlock)(struct sbus_priv *self);
+	int (*irq_subscribe)(struct sbus_priv *self, sbus_irq_handler handler,
+				void *priv);
+	int (*irq_unsubscribe)(struct sbus_priv *self);
+	int (*reset)(struct sbus_priv *self);
+	size_t (*align_size)(struct sbus_priv *self, size_t size);
+	int (*power_mgmt)(struct sbus_priv *self, bool suspend);
+	int (*set_block_size)(struct sbus_priv *self, size_t size);
+};
+
+#endif /* CW1200_SBUS_H */
-- 
1.7.9

