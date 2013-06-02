Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:44224
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab3FBNxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 09:53:08 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 1/3] cw1200:  move platform_data header to correct location.
Date: Sun,  2 Jun 2013 09:53:01 -0400
Message-Id: <1370181183-11424-1-git-send-email-pizza@shaftnet.org> (sfid-20130602_155326_322763_8F8CFDC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(As suggested by Arnd Bergmann)

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200_sagrad.c   |  2 +-
 drivers/net/wireless/cw1200/cw1200_sdio.c     |  2 +-
 drivers/net/wireless/cw1200/cw1200_spi.c      |  2 +-
 include/linux/cw1200_platform.h               | 46 ---------------------------
 include/linux/platform_data/cw1200_platform.h | 46 +++++++++++++++++++++++++++
 5 files changed, 49 insertions(+), 49 deletions(-)
 delete mode 100644 include/linux/cw1200_platform.h
 create mode 100644 include/linux/platform_data/cw1200_platform.h

diff --git a/drivers/net/wireless/cw1200/cw1200_sagrad.c b/drivers/net/wireless/cw1200/cw1200_sagrad.c
index a5ada0e..14c2a18 100644
--- a/drivers/net/wireless/cw1200/cw1200_sagrad.c
+++ b/drivers/net/wireless/cw1200/cw1200_sagrad.c
@@ -10,7 +10,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/cw1200_platform.h>
+#include <linux/platform_data/cw1200_platform.h>
 
 MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
 MODULE_DESCRIPTION("ST-Ericsson CW1200 Platform glue driver");
diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index 0865f92..d5bdbeb 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -21,7 +21,7 @@
 
 #include "cw1200.h"
 #include "hwbus.h"
-#include <linux/cw1200_platform.h>
+#include <linux/platform_data/cw1200_platform.h>
 #include "hwio.h"
 
 MODULE_AUTHOR("Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>");
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index 22db584..d77848a 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -26,7 +26,7 @@
 
 #include "cw1200.h"
 #include "hwbus.h"
-#include <linux/cw1200_platform.h>
+#include <linux/platform_data/cw1200_platform.h>
 #include "hwio.h"
 
 MODULE_AUTHOR("Solomon Peachy <speachy@sagrad.com>");
diff --git a/include/linux/cw1200_platform.h b/include/linux/cw1200_platform.h
deleted file mode 100644
index c168fa5..0000000
--- a/include/linux/cw1200_platform.h
+++ /dev/null
@@ -1,46 +0,0 @@
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
-	const struct resource *reset;   /* GPIO to RSTn signal */
-	const struct resource *powerup; /* GPIO to POWERUP signal */
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
-	const struct resource *irq;     /* if using GPIO for IRQ */
-	bool have_5ghz;
-	bool no_nptb;                   /* SDIO hardware does not support non-power-of-2-blocksizes */
-	const struct resource *reset;   /* GPIO to RSTn signal */
-	const struct resource *powerup; /* GPIO to POWERUP signal */
-	int (*power_ctrl)(const struct cw1200_platform_data_sdio *pdata,
-			  bool enable); /* Control 3v3 / 1v8 supply */
-	int (*clk_ctrl)(const struct cw1200_platform_data_sdio *pdata,
-			bool enable); /* Control CLK32K */
-	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
-	const char *sdd_file;  /* if NULL, will use default for detected hw type */
-};
-
-const void *cw1200_get_platform_data(void);
-
-#endif /* CW1200_PLAT_H_INCLUDED */
diff --git a/include/linux/platform_data/cw1200_platform.h b/include/linux/platform_data/cw1200_platform.h
new file mode 100644
index 0000000..c168fa5
--- /dev/null
+++ b/include/linux/platform_data/cw1200_platform.h
@@ -0,0 +1,46 @@
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
+	const struct resource *reset;   /* GPIO to RSTn signal */
+	const struct resource *powerup; /* GPIO to POWERUP signal */
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
+	const struct resource *irq;     /* if using GPIO for IRQ */
+	bool have_5ghz;
+	bool no_nptb;                   /* SDIO hardware does not support non-power-of-2-blocksizes */
+	const struct resource *reset;   /* GPIO to RSTn signal */
+	const struct resource *powerup; /* GPIO to POWERUP signal */
+	int (*power_ctrl)(const struct cw1200_platform_data_sdio *pdata,
+			  bool enable); /* Control 3v3 / 1v8 supply */
+	int (*clk_ctrl)(const struct cw1200_platform_data_sdio *pdata,
+			bool enable); /* Control CLK32K */
+	const u8 *macaddr;  /* if NULL, use cw1200_mac_template module parameter */
+	const char *sdd_file;  /* if NULL, will use default for detected hw type */
+};
+
+const void *cw1200_get_platform_data(void);
+
+#endif /* CW1200_PLAT_H_INCLUDED */
-- 
1.8.2.1

