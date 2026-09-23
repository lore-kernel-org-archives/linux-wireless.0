Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435D84766BB
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 21:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790199373; cv=none; b=F7qjEMRZuPRcl8exEyHdp2Y6iTrZD7TQqkwCUuSJ7xklRqyxB0rSkOisy5Kn76TN8vXVHBMx84FN/QQHf/CvYkw4o4JBphwCmHeOgiGPHTuvLHpPcYP6MIPgR8eKPZbYfRm3fcUsCduA7SvOI7uejCu2pU0He+LDVDkY23FUejw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790199373; c=relaxed/simple;
	bh=0Ef8Dmf5NQ+vpk3G4Y0e0NHI/ao/AEQGsyZamzEZdZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOT7y1f+1cEKajqGsFVNjmMUVsgQu1/YOOde085Kg9UiLN8c/dT9K4Hv5nlD25gtC9W+fzNghEeWMwBeezg0FJo8v6PGHYCnOvZGMZcD0533Tnd6btOj4VF5MTeukOs4ErrnExtRdTcq5PNx92+V3vFU1AK/YndRFoASibFRpLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q+mZKc5x; arc=none smtp.client-ip=95.215.58.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q+mZKc5x"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0Ef8Dmf5NQ+vpk3G4Y0e0NHI/ao/AEQGsyZamzEZdZY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790199369; v=1; x=1790804169;
 b=Q+mZKc5xGNTIjOulCEcsib+YEt63G7/+r44cfy85rL0Sf8IUf1qC26udOEso7L4ANFHGG68t
 MRqLE/qN9WEp/QWA82Q4xQJuIwrs1cWIyQgwcPUjHV0V+o2BMiRcBJNB3r5+D527fkzrLJ0JXnT
 Cnsv2SUAL5lfvrnQfiWBB+Oc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5e2a4aaab30240da;
	Wed, 23 Sep 2026 21:36:09 +0000
X-Mizu-Trace-ID: 5e2a4aaab30240da
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v4 4/6] wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
Date: Wed, 23 Sep 2026 23:35:55 +0200
Message-ID: <20260923213557.186205-5-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923213557.186205-1-luka.gejak@linux.dev>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
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
losing hardware support. I only have the 0xb723 variant to test with;
the other five are included for parity with staging, which has carried
them for years, rather than being left behind.

The RTL8723B chip support is based on the initial work by
Michael Straube <straube.linux@gmail.com>.
Link: https://github.com/mistraube/rtw88/tree/rtl8723bs

Co-developed-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Michael Straube <straube.linux@gmail.com>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 .../net/wireless/realtek/rtw88/rtw8723bs.c    | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723bs.c b/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
new file mode 100644
index 000000000000..be2c13417a48
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723bs.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright(c) 2007-2017  Realtek Corporation
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
+MODULE_AUTHOR("Michael Straube <straube.linux@gmail.com>");
+MODULE_AUTHOR("Luka Gejak <luka.gejak@linux.dev>");
+MODULE_DESCRIPTION("Realtek 802.11n wireless 8723bs driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.55.0

