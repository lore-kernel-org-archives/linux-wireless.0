Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E514AA3EE
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367957; cv=none; b=jbIk4RzduPo3hdxt6I9feL4BOr4EdS0B4AliKQwf6n9IuxCmJpvq0Kecw/2MC4U2rtscCO8e3sq4td/8l7yODaZtcQq9Yn3rxV+nrJwiLTYOgWU3s9QlyFzs+KiJSmvCxKTTdkvT4nrVpaPuVOzXwaWSWdC7p3NZ3gISMAa7MTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367957; c=relaxed/simple;
	bh=TlFGTc2CgDAmwHJ2t9uWj2GL8cSKKyMMpA4hv6ZIjo8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T4Yki4BXN6x+1t7OB+XPIDwaW8nBgIHrwvuYAvGAWz6kd3Fkz6KxAW6f+woYjC97XBTA/gYYGB7bqHlKlrAv+T42q9SW23oGxFd1vEV1Bcy9Pj41Y/SpSzfhQx8emj/10y8nC+vbOFVRoJad5qjcsY4RZ8UqzKslKu7tkGPR/To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=C/OP9t4N; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="C/OP9t4N"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788367955; x=1819903955;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TlFGTc2CgDAmwHJ2t9uWj2GL8cSKKyMMpA4hv6ZIjo8=;
  b=C/OP9t4NOAKqOY+u2H73HGPPpZDTcMX0Xjp+IP8TqnjMs5t9oGs03ryg
   Kuw6vQzTDWcZV9Mso68XJqsqJ1lhsw2IUk0SWbrJ6vxGDhWnp0KaxpO9B
   +ISSoGO+nzt1SBhfNy1kslpiZxWOHO/k1Cey/0p+o1paR56oPh4rSTtyd
   4=;
X-CSE-ConnectionGUID: 5gMWgwn9TvC4ifHqbGGZaA==
X-CSE-MsgGUID: WhQhF520RN6OUEN+DXwCmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="145161121"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="145161121"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:52:33 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:52:32 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:52:31 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 06/25] wifi: inffmac: add chip_{cyw5591x/acw74xx}.c/h
Date: Wed, 2 Sep 2026 16:50:37 +0000
Message-ID: <20260902165057.456447-7-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE808.infineon.com (172.23.29.34) To
 MUCSE827.infineon.com (172.23.29.20)

Chip family specific initialization and definitions for Infineon's new
generation secure chipsets CYW5591x and ACW74xx.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 .../wireless/infineon/inffmac/chip_acw74xx.c  | 35 ++++++++++++++++++
 .../wireless/infineon/inffmac/chip_acw74xx.h  | 19 ++++++++++
 .../wireless/infineon/inffmac/chip_cyw5591x.c | 33 +++++++++++++++++
 .../wireless/infineon/inffmac/chip_cyw5591x.h | 37 +++++++++++++++++++
 4 files changed, 124 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip_acw74xx.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip_acw74xx.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip_cyw5591x.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip_cyw5591x.h

diff --git a/drivers/net/wireless/infineon/inffmac/chip_acw74xx.c b/drivers/net/wireless/infineon/inffmac/chip_acw74xx.c
new file mode 100644
index 000000000000..fcd64481616d
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/chip_acw74xx.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2024-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include "chip_acw74xx.h"
+
+#define ACW74XX_CR4_RAM_BASE              0x5e3b8000
+#define ACW74XX_CR4_RAM_SIZE              0x88000 /* 544 KBytes - TCM-A+TCM-B */
+#define ACW74XX_CM33_RAM_BASE             0x34002000
+#define ACW74XX_CM33_RAM_SIZE             0x25000 /* 148 KBytes */
+
+void inff_chip_acw74xx_init(struct inff_chip *chip)
+{
+	struct inff_chip_specific *chip_spec = &chip->chip_spec;
+	struct inff_fw_dataset *fw_data = &chip_spec->fwdata[0];
+
+	chip_spec->hw_chip_rambase = ACW74XX_CR4_RAM_BASE;
+	chip_spec->hw_chip_ramsize = ACW74XX_CR4_RAM_SIZE;
+	chip_spec->hw_chip_cpuss_rambase = ACW74XX_CM33_RAM_BASE;
+	chip_spec->hw_chip_cpuss_ramsize = ACW74XX_CM33_RAM_SIZE;
+
+	fw_data[INFF_FW_CODE].fwnames.extension = ".trxse";
+	fw_data[INFF_FW_CODE].fwnames.path = chip_spec->fw_name;
+	fw_data[INFF_FW_CODE].type = INFF_FW_TYPE_TRXSE;
+
+	fw_data[INFF_FW_NVRAM].fwnames.extension = ".txt";
+	fw_data[INFF_FW_NVRAM].fwnames.path = chip_spec->nvram_name;
+	fw_data[INFF_FW_NVRAM].type = INFF_FW_TYPE_NVRAM;
+
+	fw_data[INFF_FW_CLM].fwnames.extension = ".clm_blob";
+	fw_data[INFF_FW_CLM].fwnames.path = chip_spec->clm_name;
+	fw_data[INFF_FW_CLM].type = INFF_FW_TYPE_CLM;
+}
diff --git a/drivers/net/wireless/infineon/inffmac/chip_acw74xx.h b/drivers/net/wireless/infineon/inffmac/chip_acw74xx.h
new file mode 100644
index 000000000000..e3cdcaa968c6
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/chip_acw74xx.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2024-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_CHIP_ACW74XX_H
+#define INFF_CHIP_ACW74XX_H
+
+#include "chip.h"
+
+/* INFACW74XX watermark expressed in number of words */
+#define INFACW74XX_F2_WATERMARK  0x40
+#define INFACW74XX_MES_WATERMARK 0x40
+#define INFACW74XX_F1_MESBUSYCTRL        (INFACW74XX_MES_WATERMARK | \
+					    SBSDIO_MESBUSYCTRL_ENAB)
+
+void inff_chip_acw74xx_init(struct inff_chip *chip);
+#endif /* INFF_CHIP_ACW74XX_H */
diff --git a/drivers/net/wireless/infineon/inffmac/chip_cyw5591x.c b/drivers/net/wireless/infineon/inffmac/chip_cyw5591x.c
new file mode 100644
index 000000000000..754996cbab4a
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/chip_cyw5591x.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2024-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include "chip_cyw5591x.h"
+
+void inff_chip_cyw5591x_init(struct inff_chip *chip)
+{
+	struct inff_chip_specific *chip_spec = &chip->chip_spec;
+	struct inff_fw_dataset *fw_data = &chip_spec->fwdata[0];
+
+	chip_spec->hw_caps_replaycnts = INFF_CHIP_COMMON_HW_CAPS_REPLAYCNTS;
+
+	if (chip->chiprev == 0) {
+		chip_spec->hw_chip_tcam_size = INF55900_TCAM_SIZE;
+		chip_spec->hw_chip_trxhdr_size = INF55900_TRXHDR_SIZE;
+		chip_spec->hw_chip_rambase = INF55900_RAM_BASE;
+	} else {
+		chip_spec->hw_chip_tcam_size = INF55900_A1_TCAM_SIZE;
+		chip_spec->hw_chip_trxhdr_size = INF55900_A1_TRXHDR_SIZE;
+		chip_spec->hw_chip_rambase = INF55900_A1_RAM_BASE;
+	}
+
+	fw_data[INFF_FW_CP].fwnames.extension = ".hex";
+	fw_data[INFF_FW_CP].fwnames.path = chip_spec->fw_name;
+	fw_data[INFF_FW_CP].type = INFF_FW_TYPE_HEX;
+
+	fw_data[INFF_FW_BOOT].fwnames.extension = ".hex";
+	fw_data[INFF_FW_BOOT].fwnames.path = chip_spec->boot_fw_name;
+	fw_data[INFF_FW_BOOT].type = INFF_FW_TYPE_HEX;
+}
diff --git a/drivers/net/wireless/infineon/inffmac/chip_cyw5591x.h b/drivers/net/wireless/infineon/inffmac/chip_cyw5591x.h
new file mode 100644
index 000000000000..3c0810f3e601
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/chip_cyw5591x.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2024-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#include "chip.h"
+
+/* 55900-A0, Dedicated sapce for TCAM_PATCH and TRX HDR area at RAMSTART */
+#define INF55900_RAM_START	(0x3a0000)
+#define INF55900_TCAM_SIZE	(0x800)
+#define INF55900_TRXHDR_SIZE	(0x2b4)
+
+#define INF55900_RAM_BASE	(INF55900_RAM_START + INF55900_TCAM_SIZE + \
+				 INF55900_TRXHDR_SIZE)
+
+/* 55900-A1, Dedicated sapce for TCAM_PATCH and TRX HDR area at RAMSTART */
+#define INF55900_A1_TCAM_SIZE	(0x1000)
+#define INF55900_A1_TRXHDR_SIZE	(0x20)
+
+#define INF55900_A1_RAM_BASE	(INF55900_RAM_START + INF55900_A1_TCAM_SIZE + \
+				 INF55900_A1_TRXHDR_SIZE)
+
+/* INF55900 SDIO func2 block size */
+#define SDIO_INF55900_FUNC2_BLOCKSIZE	256
+
+/* INF55900 watermark expressed in number of words */
+#define INF55900_F2_WATERMARK	0x40
+#define INF55900_MES_WATERMARK	0x40
+#define INF55900_F1_MESBUSYCTRL	(INF55900_MES_WATERMARK | \
+				 SBSDIO_MESBUSYCTRL_ENAB)
+
+#define CYW5591X_BOOTFW_RAM_LD_ADDR         0x80420000
+#define CYW5591X_FWDWNLD_RAM_WR_ADDR        0x80470000
+#define CYW5591X_IMAGE_LAUNCH_ADDR          0xffffffff
+
+void inff_chip_cyw5591x_init(struct inff_chip *chip);
-- 
2.43.0

