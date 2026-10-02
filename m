Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC66443C02
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 07:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790926752; cv=none; b=OhtKWi/9o6PmSMnycpGit3tvjtdePuf63pIXmsApyv5eluED3kGV4sAKjAiwemh5pgDDqoN+jrl/NVfYDknTY81fcFji7VjWGn1UmEaRcuSZdENF/J2ILWigEYewWeWvcOziYkGVWyRMjRcZnLwCSCJoidQ7CIzJq8/8SCShxc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790926752; c=relaxed/simple;
	bh=GF+U/hw7WcPHBVh+HSbJ3knj3l/vkqtYcF1qErvdvEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkLejc6GxRvJxyqoOGd3jqFI63IrbKb6P7ocbfyHAexT20kNaTtGqriPnydo04ob6NJMZyj06j8NvmP/vRlWwf0FGVlgF0uuZGWCbmzYRBpk4iCQNUXW3OAC4mS2mb8AsqfV8ZFsO7HqCmtBuvY6WMrkzOvh7eAsFdEITI5xb4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ja+Zq61G; arc=none smtp.client-ip=91.218.175.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ja+Zq61G"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GF+U/hw7WcPHBVh+HSbJ3knj3l/vkqtYcF1qErvdvEI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790926748; v=1; x=1791531548;
 b=Ja+Zq61GcC+QTpsyXKWqEWAv4cX5VQNJ1mPEH0Oi+oYFh5PtA1gNBfLxo8PdjYRgNeTx+GXM
 k5hrYdmpbKRZPW6LOMQAfSjg89GXakundM2WXKpyidu6HZRbd+Y2LXmdtZMw1ETcjiyrvI5rYP2
 Psdi8BR/n71djWvCikw+1DYY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f376e38fe06fdc94;
	Fri, 02 Oct 2026 07:39:08 +0000
X-Mizu-Trace-ID: f376e38fe06fdc94
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH rtw-next v7 5/6] wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
Date: Fri,  2 Oct 2026 09:38:44 +0200
Message-ID: <20261002073845.31486-6-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002073845.31486-1-luka.gejak@linux.dev>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
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

