Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932372AbeCJOPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:25 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v3 09/20] firmware: move firmware loader into its own directory
Date: Sat, 10 Mar 2018 06:14:50 -0800
Message-Id: <20180310141501.2214-10-mcgrof@kernel.org> (sfid-20180310_151836_133182_4B545971)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will make it much easier to manage as we manage to
keep trimming componnents down into their own files to more
easily manage and maintain this codebase.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 MAINTAINERS                                                       | 2 +-
 drivers/base/Makefile                                             | 7 ++-----
 drivers/base/firmware_loader/Makefile                             | 7 +++++++
 drivers/base/{firmware_fallback.c => firmware_loader/fallback.c}  | 4 ++--
 drivers/base/{firmware_fallback.h => firmware_loader/fallback.h}  | 0
 .../fallback_table.c}                                             | 4 ++--
 drivers/base/{firmware_loader.h => firmware_loader/firmware.h}    | 0
 drivers/base/{firmware_loader.c => firmware_loader/main.c}        | 8 ++++----
 8 files changed, 18 insertions(+), 14 deletions(-)
 create mode 100644 drivers/base/firmware_loader/Makefile
 rename drivers/base/{firmware_fallback.c => firmware_loader/fallback.c} (99%)
 rename drivers/base/{firmware_fallback.h => firmware_loader/fallback.h} (100%)
 rename drivers/base/{firmware_fallback_table.c => firmware_loader/fallback_table.c} (90%)
 rename drivers/base/{firmware_loader.h => firmware_loader/firmware.h} (100%)
 rename drivers/base/{firmware_loader.c => firmware_loader/main.c} (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index e03a130902cd..6ddd6f4aaffa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5589,7 +5589,7 @@ M:	Luis R. Rodriguez <mcgrof@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/firmware_class/
-F:	drivers/base/firmware*.c
+F:	drivers/base/firmware_loader/
 F:	include/linux/firmware.h
 
 FLASH ADAPTER DRIVER (IBM Flash Adapter 900GB Full Height PCI Flash Card)
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index b946a408256d..b9539abec675 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -5,17 +5,14 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o property.o cacheinfo.o \
-			   firmware_fallback_table.o
+			   topology.o container.o property.o cacheinfo.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_ISA_BUS_API)	+= isa.o
-obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
-firmware_class-objs := firmware_loader.o
-firmware_class-$(CONFIG_FW_LOADER_USER_HELPER) += firmware_fallback.o
+obj-y				+= firmware_loader/
 obj-$(CONFIG_NUMA)	+= node.o
 obj-$(CONFIG_MEMORY_HOTPLUG_SPARSE) += memory.o
 ifeq ($(CONFIG_SYSFS),y)
diff --git a/drivers/base/firmware_loader/Makefile b/drivers/base/firmware_loader/Makefile
new file mode 100644
index 000000000000..a97eeb0be1d8
--- /dev/null
+++ b/drivers/base/firmware_loader/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for the Linux firmware loader
+
+obj-y			:= fallback_table.o
+obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
+firmware_class-objs := main.o
+firmware_class-$(CONFIG_FW_LOADER_USER_HELPER) += fallback.o
diff --git a/drivers/base/firmware_fallback.c b/drivers/base/firmware_loader/fallback.c
similarity index 99%
rename from drivers/base/firmware_fallback.c
rename to drivers/base/firmware_loader/fallback.c
index 47690207e0ee..9b65837256d6 100644
--- a/drivers/base/firmware_fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -8,8 +8,8 @@
 #include <linux/highmem.h>
 #include <linux/umh.h>
 
-#include "firmware_fallback.h"
-#include "firmware_loader.h"
+#include "fallback.h"
+#include "firmware.h"
 
 /*
  * firmware fallback mechanism
diff --git a/drivers/base/firmware_fallback.h b/drivers/base/firmware_loader/fallback.h
similarity index 100%
rename from drivers/base/firmware_fallback.h
rename to drivers/base/firmware_loader/fallback.h
diff --git a/drivers/base/firmware_fallback_table.c b/drivers/base/firmware_loader/fallback_table.c
similarity index 90%
rename from drivers/base/firmware_fallback_table.c
rename to drivers/base/firmware_loader/fallback_table.c
index 53cc4e492520..981419044c7e 100644
--- a/drivers/base/firmware_fallback_table.c
+++ b/drivers/base/firmware_loader/fallback_table.c
@@ -9,8 +9,8 @@
 #include <linux/umh.h>
 #include <linux/sysctl.h>
 
-#include "firmware_fallback.h"
-#include "firmware_loader.h"
+#include "fallback.h"
+#include "firmware.h"
 
 /*
  * firmware fallback configuration table
diff --git a/drivers/base/firmware_loader.h b/drivers/base/firmware_loader/firmware.h
similarity index 100%
rename from drivers/base/firmware_loader.h
rename to drivers/base/firmware_loader/firmware.h
diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader/main.c
similarity index 99%
rename from drivers/base/firmware_loader.c
rename to drivers/base/firmware_loader/main.c
index 21dd31ef08ae..c8966c84bd44 100644
--- a/drivers/base/firmware_loader.c
+++ b/drivers/base/firmware_loader/main.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * firmware_class.c - Multi purpose firmware loading support
+ * main.c - Multi purpose firmware loading support
  *
  * Copyright (c) 2003 Manuel Estrada Sainz
  *
@@ -36,9 +36,9 @@
 
 #include <generated/utsrelease.h>
 
-#include "base.h"
-#include "firmware_loader.h"
-#include "firmware_fallback.h"
+#include "../base.h"
+#include "firmware.h"
+#include "fallback.h"
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
-- 
2.16.2
