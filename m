Received: from mta1.migadu.com (out-144.mta1.migadu.com [95.215.58.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32D94F55DD
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 09:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846334; cv=none; b=ZxcMCZSRXdl3ah7QFQjyFm21fWAT1ux1p/20Xs4m0Eb3mq8FyZT60oDAqf/iS5PY9ZVB+1GDQkczzWCb+UrhSRFW07+MRhcHvn3RYyC5A7+cGvAJKvJ7ff0whDP+zf7Wh3MbdqCu0uJlwJZ7hfOZWIe7oImrsXCZTQ0g+VwVGFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846334; c=relaxed/simple;
	bh=GF+U/hw7WcPHBVh+HSbJ3knj3l/vkqtYcF1qErvdvEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4t+Z/6ic3CUwUynAzPzmppTNJyI31xfXyOcDMi1dLOfXCHTeVJowiFYnGxc+7w75gAZ2P1r4hHyqfFs/cbwRqmsZvapeAw8IxG5JPrW1nzCs2PJqPsuH0PxHFMgunVTnudDHHZwublscPXuaVBkk6qsytjZhFB7dZlzSmKMzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tp3c0qhR; arc=none smtp.client-ip=95.215.58.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tp3c0qhR"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GF+U/hw7WcPHBVh+HSbJ3knj3l/vkqtYcF1qErvdvEI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790846330; v=1; x=1791451130;
 b=Tp3c0qhR+Mb4niqIUH9IYHjKsLdQdic8M2NdmXmht+rPyWyN0Tkffox8yQJ3vFValW3zSp1B
 XMXp22WoQlqvg+ExoMwOXqeiBpGZBe03tJx2ime+mZLxBwkDBcTm0Ow5pgMrDjleeBqD4iwLsR3
 oeEO/RF81WQv9PFb+8RgyJXQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 226c18779b8ff65b;
	Thu, 01 Oct 2026 09:18:50 +0000
X-Mizu-Trace-ID: 226c18779b8ff65b
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v6 5/6] wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
Date: Thu,  1 Oct 2026 11:18:34 +0200
Message-ID: <20261001091835.67909-6-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001091835.67909-1-luka.gejak@linux.dev>
References: <20261001091835.67909-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the SDIO module for the RTL8723BS, the SDIO variant of the
RTL8723B. It binds the Realtek SDIO device ids to the shared rtw88 SDIO
probe and points it at the RTL8723B chip information.

The device id table carries the same six ids the staging rtl8723bs
driver binds to this chip, so the staging driver can be dropped without
losing hardware support. I only have the 0xb723 variant to test with.
The other five are included for parity with staging, which has carried
them for years, rather than being left behind.

The RTL8723B chip support is based on the initial work by
Michael Straube <straube.linux@gmail.com>.
Link: https://github.com/mistraube/rtw88/tree/rtl8723bs

Co-developed-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 .../net/wireless/realtek/rtw88/rtw8723bs.c    | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723bs.c b/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
new file mode 100644
index 000000000000..62ad44db20de
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2026  Realtek Corporation
+ * Copyright(c) Michael Straube <straube.linux@gmail.com>
+ * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
+ */
+
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/module.h>
+#include "main.h"
+#include "rtw8723b.h"
+#include "sdio.h"
+
+static const struct sdio_device_id rtw_8723bs_id_table[] = {
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
+			    SDIO_DEVICE_ID_REALTEK_RTW8723BS),
+		.driver_data = (kernel_ulong_t)&rtw8723b_hw_spec,
+	},
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK, 0x0523),
+		.driver_data = (kernel_ulong_t)&rtw8723b_hw_spec,
+	},
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK, 0x0525),
+		.driver_data = (kernel_ulong_t)&rtw8723b_hw_spec,
+	},
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK, 0x0623),
+		.driver_data = (kernel_ulong_t)&rtw8723b_hw_spec,
+	},
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK, 0x0626),
+		.driver_data = (kernel_ulong_t)&rtw8723b_hw_spec,
+	},
+	{
+		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK, 0x0627),
+		.driver_data = (kernel_ulong_t)&rtw8723b_hw_spec,
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(sdio, rtw_8723bs_id_table);
+
+static struct sdio_driver rtw_8723bs_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = rtw_8723bs_id_table,
+	.probe = rtw_sdio_probe,
+	.remove = rtw_sdio_remove,
+	.shutdown = rtw_sdio_shutdown,
+	.drv = {
+		.pm = &rtw_sdio_pm_ops,
+	}
+};
+module_sdio_driver(rtw_8723bs_driver);
+
+MODULE_AUTHOR("Luka Gejak <luka.gejak@linux.dev>");
+MODULE_AUTHOR("Michael Straube <straube.linux@gmail.com>");
+MODULE_DESCRIPTION("Realtek 802.11n wireless 8723bs driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.55.0

