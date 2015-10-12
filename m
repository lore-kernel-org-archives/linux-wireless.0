Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13261 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbJLH7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:59:50 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 30/41] staging: wilc1000: remove wilc_wlan.c included in wilc_wfi_cfgoperations.c
Date: Mon, 12 Oct 2015 16:56:04 +0900
Message-ID: <1444636575-2486-30-git-send-email-tony.cho@atmel.com> (sfid-20151012_095952_824515_E5F25725)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes "wilc_wlan.c" from the wilc_wfi_cfgoperation.c file and
adds wilc_wlan.o into Makefile to compile it because there is few benefits.
This patch also adds "wilc_wfi_netdevice.h" in the wilc_wlan.c file to avoid
the compile errors.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/Makefile                 | 3 ++-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 -
 drivers/staging/wilc1000/wilc_wlan.c              | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index f495061..64c2f1b 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -21,7 +21,8 @@ ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_msgqueue.o \
 			coreconfigurator.o host_interface.o \
-			wilc_sdio.o wilc_spi.o wilc_wlan_cfg.o wilc_debugfs.o
+			wilc_sdio.o wilc_spi.o wilc_wlan_cfg.o wilc_debugfs.o \
+			wilc_wlan.o
 
 wilc1000-$(CONFIG_WILC1000_SDIO) += linux_wlan_sdio.o
 wilc1000-$(CONFIG_WILC1000_SPI) += linux_wlan_spi.o
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 11f9d46..7abdd53 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -11,7 +11,6 @@
  */
 
 #include "wilc_wfi_cfgoperations.h"
-#include "wilc_wlan.c"
 #ifdef WILC_SDIO
 #include "linux_wlan_sdio.h"
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e11d3d3..1d23bad 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -8,7 +8,7 @@
 /* //////////////////////////////////////////////////////////////////////////// */
 
 #include "wilc_wlan_if.h"
-#include "wilc_wlan.h"
+#include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
 /********************************************
-- 
1.9.1

