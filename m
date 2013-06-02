Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:46658
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752632Ab3FBPfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 11:35:39 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 2/2] cw1200:  rename the cw1200 platform definition header
Date: Sun,  2 Jun 2013 11:35:32 -0400
Message-Id: <1370187332-18813-2-git-send-email-pizza@shaftnet.org> (sfid-20130602_173542_420355_44077295)
In-Reply-To: <1370187332-18813-1-git-send-email-pizza@shaftnet.org>
References: <1370187332-18813-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My previous patch just moved the file, but it also needed to be renamed
to conform to proper conventions.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_sdio.c     |  2 +-
 drivers/net/wireless/cw1200/cw1200_spi.c      |  2 +-
 include/linux/platform_data/cw1200_platform.h | 81 ---------------------------
 include/linux/platform_data/net-cw1200.h      | 81 +++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 83 deletions(-)
 delete mode 100644 include/linux/platform_data/cw1200_platform.h
 create mode 100644 include/linux/platform_data/net-cw1200.h

diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index 913a3eb..808257e 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -21,7 +21,7 @@
 
 #include "cw1200.h"
 #include "hwbus.h"
-#include <linux/platform_data/cw1200_platform.h>
+#include <linux/platform_data/net-cw1200.h>
 #include "hwio.h"
 
 MODULE_AUTHOR("Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>");
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 5eacf9e..61406e7 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -26,7 +26,7 @@
 
 #include "cw1200.h"
 #include "hwbus.h"
-#include <linux/platform_data/cw1200_platform.h>
+#include <linux/platform_data/net-cw1200.h>
 #include "hwio.h"
 
 MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
diff --git a/include/linux/platform_data/cw1200_platform.h b/include/linux/platform_data/cw1200_platform.h
deleted file mode 100644
index c6fbc3c..0000000
--- a/include/linux/platform_data/cw1200_platform.h
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2011
- *
- * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
- * License terms: GNU General Public License (GPL) version 2
- */
-
-#ifndef CW1200_PLAT_H_INCLUDED
-#define CW1200_PLAT_H_INCLUDED
-
-struct cw1200_platform_data_spi {
-	u8 spi_bits_per_word;           /* REQUIRED */
-	u16 ref_clk;                    /* REQUIRED (in KHz) */
-
-	/* All others are optional */
-	bool have_5ghz;
-	int reset;                     /* GPIO to RSTn signal (0 disables) */
-	int powerup;                   /* GPIO to POWERUP signal (0 disables) */
-	int (*power_ctrl)(const struct cw1200_platform_data_spi *pdata,
-			  bool enable); /* Control 3v3 / 1v8 supply */
-	int (*clk_ctrl)(const struct cw1200_platform_data_spi *pdata,
-			bool enable); /* Control CLK32K */
-	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
-	const char *sdd_file;  /* if NULL, will use default for detected hw type */
-};
-
-struct cw1200_platform_data_sdio {
-	u16 ref_clk;                    /* REQUIRED (in KHz) */
-
-	/* All others are optional */
-	bool have_5ghz;
-	bool no_nptb;       /* SDIO hardware does not support non-power-of-2-blocksizes */
-	int reset;          /* GPIO to RSTn signal (0 disables) */
-	int powerup;        /* GPIO to POWERUP signal (0 disables) */
-	int irq;            /* IRQ line or 0 to use SDIO IRQ */
-	int (*power_ctrl)(const struct cw1200_platform_data_sdio *pdata,
-			  bool enable); /* Control 3v3 / 1v8 supply */
-	int (*clk_ctrl)(const struct cw1200_platform_data_sdio *pdata,
-			bool enable); /* Control CLK32K */
-	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
-	const char *sdd_file;  /* if NULL, will use default for detected hw type */
-};
-
-
-/* An example of SPI support in your board setup file:
-
-   static struct cw1200_platform_data_spi cw1200_platform_data = {
-       .ref_clk = 38400,
-       .spi_bits_per_word = 16,
-       .reset = GPIO_RF_RESET,
-       .powerup = GPIO_RF_POWERUP,
-       .macaddr = wifi_mac_addr,
-       .sdd_file = "sdd_sagrad_1091_1098.bin",
-  };
-  static struct spi_board_info myboard_spi_devices[] __initdata = {
-       {
-               .modalias = "cw1200_wlan_spi",
-               .max_speed_hz = 52000000,
-               .bus_num = 0,
-               .irq = WIFI_IRQ,
-               .platform_data = &cw1200_platform_data,
-               .chip_select = 0,
-       },
-  };
-
- */
-
-/* An example of SDIO support in your board setup file:
-
-  static struct cw1200_platform_data_sdio my_cw1200_platform_data = {
-	.ref_clk = 38400,
-	.have_5ghz = false,
-	.sdd_file = "sdd_myplatform.bin",
-  };
-  cw1200_sdio_set_platform_data(&my_cw1200_platform_data);
-
- */
-
-void __init cw1200_sdio_set_platform_data(struct cw1200_platform_data_sdio *pdata);
-
-#endif /* CW1200_PLAT_H_INCLUDED */
diff --git a/include/linux/platform_data/net-cw1200.h b/include/linux/platform_data/net-cw1200.h
new file mode 100644
index 0000000..c6fbc3c
--- /dev/null
+++ b/include/linux/platform_data/net-cw1200.h
@@ -0,0 +1,81 @@
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
+struct cw1200_platform_data_spi {
+	u8 spi_bits_per_word;           /* REQUIRED */
+	u16 ref_clk;                    /* REQUIRED (in KHz) */
+
+	/* All others are optional */
+	bool have_5ghz;
+	int reset;                     /* GPIO to RSTn signal (0 disables) */
+	int powerup;                   /* GPIO to POWERUP signal (0 disables) */
+	int (*power_ctrl)(const struct cw1200_platform_data_spi *pdata,
+			  bool enable); /* Control 3v3 / 1v8 supply */
+	int (*clk_ctrl)(const struct cw1200_platform_data_spi *pdata,
+			bool enable); /* Control CLK32K */
+	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
+	const char *sdd_file;  /* if NULL, will use default for detected hw type */
+};
+
+struct cw1200_platform_data_sdio {
+	u16 ref_clk;                    /* REQUIRED (in KHz) */
+
+	/* All others are optional */
+	bool have_5ghz;
+	bool no_nptb;       /* SDIO hardware does not support non-power-of-2-blocksizes */
+	int reset;          /* GPIO to RSTn signal (0 disables) */
+	int powerup;        /* GPIO to POWERUP signal (0 disables) */
+	int irq;            /* IRQ line or 0 to use SDIO IRQ */
+	int (*power_ctrl)(const struct cw1200_platform_data_sdio *pdata,
+			  bool enable); /* Control 3v3 / 1v8 supply */
+	int (*clk_ctrl)(const struct cw1200_platform_data_sdio *pdata,
+			bool enable); /* Control CLK32K */
+	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
+	const char *sdd_file;  /* if NULL, will use default for detected hw type */
+};
+
+
+/* An example of SPI support in your board setup file:
+
+   static struct cw1200_platform_data_spi cw1200_platform_data = {
+       .ref_clk = 38400,
+       .spi_bits_per_word = 16,
+       .reset = GPIO_RF_RESET,
+       .powerup = GPIO_RF_POWERUP,
+       .macaddr = wifi_mac_addr,
+       .sdd_file = "sdd_sagrad_1091_1098.bin",
+  };
+  static struct spi_board_info myboard_spi_devices[] __initdata = {
+       {
+               .modalias = "cw1200_wlan_spi",
+               .max_speed_hz = 52000000,
+               .bus_num = 0,
+               .irq = WIFI_IRQ,
+               .platform_data = &cw1200_platform_data,
+               .chip_select = 0,
+       },
+  };
+
+ */
+
+/* An example of SDIO support in your board setup file:
+
+  static struct cw1200_platform_data_sdio my_cw1200_platform_data = {
+	.ref_clk = 38400,
+	.have_5ghz = false,
+	.sdd_file = "sdd_myplatform.bin",
+  };
+  cw1200_sdio_set_platform_data(&my_cw1200_platform_data);
+
+ */
+
+void __init cw1200_sdio_set_platform_data(struct cw1200_platform_data_sdio *pdata);
+
+#endif /* CW1200_PLAT_H_INCLUDED */
-- 
1.8.2.1

