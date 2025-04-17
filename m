Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6B824EABF
	for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2025 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.160.252.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744898086; cv=none; b=BhWSuAADSEq1GrTfTqcWNamD0vK4TSo+8zxFqiP7aZnV+K26AhUBFGBV65OfSdz7CDAnaNxt3LxbiwNvnRldCRbHQfzDQasvdG3fBsbyJLVrttCbbVKXExGf9dGPbLOIfwGdOv88c5+jR20TnifvHQy0CNLNuxO/Ip7x+AmdLzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744898086; c=relaxed/simple;
	bh=CSv+Y7Ei5d0ps/8dtEgtZloQ+D8G/rpyNduaZ4hDX0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=dslbqLKogncMnjapB2fXsW8GE1Ld9KkQ0/PWpveH37Avx2PgzY4xsX3mH5M6ExyYuL8p3h4GxdAstLHSA+1E+EJQS6HBIz/iLufAXrj9Zk0LfNeYC+ecBxkeaWCjD7nsWRKcgW6yHqXDY7/ZsdcOvIMyDSnMQ+No+2h0aehzeWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com; spf=pass smtp.mailfrom=bp.renesas.com; arc=none smtp.client-ip=210.160.252.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bp.renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bp.renesas.com
X-CSE-ConnectionGUID: iG2QPO3NQYiM1oKaC5dFWw==
X-CSE-MsgGUID: WbAol+0DSPaG4HCLU8t37Q==
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 17 Apr 2025 22:54:44 +0900
Received: from localhost.localdomain (unknown [10.14.100.3])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id 9F61F401009B;
	Thu, 17 Apr 2025 22:54:40 +0900 (JST)
From: Alexander Savchenko <oleksandr.savchenko.dn@bp.renesas.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Sergiy Petrov <sergiy.petrov.ue@bp.renesas.com>,
	Viktor Barna <viktor.barna.rj@bp.renesas.com>,
	Gal Gur <gal.gur.jx@renesas.com>,
	Alexander Savchenko <oleksandr.savchenko.dn@bp.renesas.com>
Subject: [PATCH 28/38] ra6w: add sdio.h
Date: Thu, 17 Apr 2025 16:52:26 +0300
Message-Id: <20250417135236.52410-29-oleksandr.savchenko.dn@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250417135236.52410-1-oleksandr.savchenko.dn@bp.renesas.com>
References: <20250417135236.52410-1-oleksandr.savchenko.dn@bp.renesas.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

Part of the split. Please, take a look at the cover letter for more details

Reviewed-by: Viktor Barna <viktor.barna.rj@bp.renesas.com>
Reviewed-by: Gal Gur <gal.gur.jx@renesas.com>
Signed-off-by: Alexander Savchenko <oleksandr.savchenko.dn@bp.renesas.com>
---
 drivers/net/wireless/renesas/ra6w/sdio.h | 38 ++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 drivers/net/wireless/renesas/ra6w/sdio.h

diff --git a/drivers/net/wireless/renesas/ra6w/sdio.h b/drivers/net/wireless/renesas/ra6w/sdio.h
new file mode 100644
index 000000000000..6b7d0c7d7bbc
--- /dev/null
+++ b/drivers/net/wireless/renesas/ra6w/sdio.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) [2022-2025] Renesas Electronics Corporation and/or its affiliates.
+ */
+
+#ifndef RA6W_SDIO_H
+#define RA6W_SDIO_H
+
+#include <linux/mmc/sdio_func.h>
+
+#define RA6W_SDIO_VENDOR_ID_RENESAS		0x5245
+#define RA6W_SDIO_DEVICE_ID_RA6W		0x4154
+#define RA6W_SDIO_MAX_BLOCK_CNT			5
+#define RA6W_SDIO_BLOCK_SIZE			512
+#define RA6W_SDIO_HOST_GP_REG			0x24
+#define RA6W_SDIO_CHIP_GP_REG			0x28
+#define RA6W_SDIO_CODE_SUCCESS			0x00022000
+#define RA6W_SDIO_CODE_CRC_CHECKING		0xf0f0f0f0
+#define RA6W_SDIO_CODE_BOOT_NG			0x20000002
+#define RA6W_SDIO_ADDR_RESET			0xdeadffff
+#define RA6W_SDIO_ADDR_READ			0x0001
+#define RA6W_SDIO_ADDR_WRITE			0x0002
+#define RA6W_SDIO_ADDR_STATUS			0x0010
+
+#define RA6W_SDIO_FW_NAME			"fmacfw_sdio.bin"
+
+#define RA6W_SDIO_GET_CNT(len, blk_size)	(((u32)(len)) / (blk_size))
+#define RA6W_SDIO_GET_REMAIN(len, blk_size)	(((u32)(len)) % (blk_size))
+
+#define RA6W_SDIO_ACK_CNT_MAX			10
+#define RA6W_SDIO_WAIT_SYNC_CNT_MAX		20
+#define RA6W_SDIO_CRC_CHECK_RETRY_MAX		20
+#define RA6W_SDIO_CRC_CHECK_SLEEP_MIN_US	10000
+#define RA6W_SDIO_CRC_CHECK_SLEEP_MAX_US	11000
+
+void ra6w_sdio_reprobe(struct sdio_func *func);
+
+#endif /* RA6W_SDIO_H */
-- 
2.17.1

