Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:49695 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab0JJIgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 04:36:31 -0400
From: Kalle Valo <kvalo@adurom.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>
Subject: [PATCH 2/3] wl1251: move to it's own directory
Date: Sun, 10 Oct 2010 11:28:32 +0300
Message-Id: <1286699313-7774-3-git-send-email-kvalo@adurom.com>
In-Reply-To: <1286699313-7774-1-git-send-email-kvalo@adurom.com>
References: <1286699313-7774-1-git-send-email-kvalo@adurom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1271 driver is under heavy development but on the other hand the older
wl1251 driver is currently considered more as a legacy driver. To make it
easier to develop wl1271 features move wl1251 to it's own directory,
drivers/net/wireless/wl1251.

There are no functional changes, only moving of files. One regression
is that Kconfig won't be updated automatically and user needs to enable
wl1251 manually with an older config file.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/wl1251/Kconfig                |   33 +++++++++++++++++++
 drivers/net/wireless/wl1251/Makefile               |    7 ++++
 .../wireless/{wl12xx/wl1251_acx.c => wl1251/acx.c} |    8 ++--
 .../wireless/{wl12xx/wl1251_acx.h => wl1251/acx.h} |    2 +-
 .../{wl12xx/wl1251_boot.c => wl1251/boot.c}        |   12 +++---
 .../{wl12xx/wl1251_boot.h => wl1251/boot.h}        |    0
 .../wireless/{wl12xx/wl1251_cmd.c => wl1251/cmd.c} |   10 +++---
 .../wireless/{wl12xx/wl1251_cmd.h => wl1251/cmd.h} |    0
 .../{wl12xx/wl1251_debugfs.c => wl1251/debugfs.c}  |    6 ++--
 .../{wl12xx/wl1251_debugfs.h => wl1251/debugfs.h}  |    0
 .../{wl12xx/wl1251_event.c => wl1251/event.c}      |    8 ++--
 .../{wl12xx/wl1251_event.h => wl1251/event.h}      |    0
 .../{wl12xx/wl1251_init.c => wl1251/init.c}        |    8 ++--
 .../{wl12xx/wl1251_init.h => wl1251/init.h}        |    0
 .../wireless/{wl12xx/wl1251_io.c => wl1251/io.c}   |    4 +-
 .../wireless/{wl12xx/wl1251_io.h => wl1251/io.h}   |    0
 .../{wl12xx/wl1251_main.c => wl1251/main.c}        |   20 ++++++------
 .../wireless/{wl12xx/wl1251_ps.c => wl1251/ps.c}   |    8 ++--
 .../wireless/{wl12xx/wl1251_ps.h => wl1251/ps.h}   |    2 +-
 .../wireless/{wl12xx/wl1251_reg.h => wl1251/reg.h} |    0
 .../wireless/{wl12xx/wl1251_rx.c => wl1251/rx.c}   |   10 +++---
 .../wireless/{wl12xx/wl1251_rx.h => wl1251/rx.h}   |    0
 .../{wl12xx/wl1251_sdio.c => wl1251/sdio.c}        |    0
 .../wireless/{wl12xx/wl1251_spi.c => wl1251/spi.c} |    4 +-
 .../wireless/{wl12xx/wl1251_spi.h => wl1251/spi.h} |    6 ++--
 .../wireless/{wl12xx/wl1251_tx.c => wl1251/tx.c}   |    8 ++--
 .../wireless/{wl12xx/wl1251_tx.h => wl1251/tx.h}   |    2 +-
 drivers/net/wireless/{wl12xx => wl1251}/wl1251.h   |    0
 drivers/net/wireless/wl12xx/Kconfig                |   34 --------------------
 drivers/net/wireless/wl12xx/Makefile               |    9 -----
 32 files changed, 101 insertions(+), 102 deletions(-)
 create mode 100644 drivers/net/wireless/wl1251/Kconfig
 create mode 100644 drivers/net/wireless/wl1251/Makefile
 rename drivers/net/wireless/{wl12xx/wl1251_acx.c => wl1251/acx.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_acx.h => wl1251/acx.h} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_boot.c => wl1251/boot.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_boot.h => wl1251/boot.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_cmd.c => wl1251/cmd.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_cmd.h => wl1251/cmd.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_debugfs.c => wl1251/debugfs.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_debugfs.h => wl1251/debugfs.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_event.c => wl1251/event.c} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_event.h => wl1251/event.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_init.c => wl1251/init.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_init.h => wl1251/init.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_io.c => wl1251/io.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_io.h => wl1251/io.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_main.c => wl1251/main.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_ps.c => wl1251/ps.c} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_ps.h => wl1251/ps.h} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_reg.h => wl1251/reg.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_rx.c => wl1251/rx.c} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_rx.h => wl1251/rx.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_sdio.c => wl1251/sdio.c} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_spi.c => wl1251/spi.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_spi.h => wl1251/spi.h} (96%)
 rename drivers/net/wireless/{wl12xx/wl1251_tx.c => wl1251/tx.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_tx.h => wl1251/tx.h} (99%)
 rename drivers/net/wireless/{wl12xx => wl1251}/wl1251.h (100%)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 174e344..4de4410 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -279,6 +279,7 @@ source "drivers/net/wireless/libertas/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
+source "drivers/net/wireless/wl1251/Kconfig"
 source "drivers/net/wireless/wl12xx/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index a13a602..06f8ca2 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_ATH_COMMON)	+= ath/
 
 obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
 
+obj-$(CONFIG_WL1251)	+= wl1251/
 obj-$(CONFIG_WL12XX)	+= wl12xx/
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx/
 
diff --git a/drivers/net/wireless/wl1251/Kconfig b/drivers/net/wireless/wl1251/Kconfig
new file mode 100644
index 0000000..1fb6584
--- /dev/null
+++ b/drivers/net/wireless/wl1251/Kconfig
@@ -0,0 +1,33 @@
+menuconfig WL1251
+	tristate "TI wl1251 driver support"
+	depends on MAC80211 && EXPERIMENTAL && GENERIC_HARDIRQS
+	select FW_LOADER
+	select CRC7
+	---help---
+	  This will enable TI wl1251 driver support. The drivers make
+	  use of the mac80211 stack.
+
+	  If you choose to build a module, it'll be called wl1251. Say
+	  N if unsure.
+
+config WL1251_SPI
+	tristate "TI wl1251 SPI support"
+	depends on WL1251 && SPI_MASTER
+	---help---
+	  This module adds support for the SPI interface of adapters using
+	  TI wl1251 chipset.  Select this if your platform is using
+	  the SPI bus.
+
+	  If you choose to build a module, it'll be called wl1251_spi.
+	  Say N if unsure.
+
+config WL1251_SDIO
+	tristate "TI wl1251 SDIO support"
+	depends on WL1251 && MMC
+	---help---
+	  This module adds support for the SDIO interface of adapters using
+	  TI wl1251 chipset.  Select this if your platform is using
+	  the SDIO bus.
+
+	  If you choose to build a module, it'll be called
+	  wl1251_sdio. Say N if unsure.
diff --git a/drivers/net/wireless/wl1251/Makefile b/drivers/net/wireless/wl1251/Makefile
new file mode 100644
index 0000000..25e9b36
--- /dev/null
+++ b/drivers/net/wireless/wl1251/Makefile
@@ -0,0 +1,7 @@
+wl1251-objs		= main.o event.o tx.o rx.o ps.o cmd.o \
+			  acx.o boot.o init.o debugfs.o io.o
+
+obj-$(CONFIG_WL1251)	+= wl1251.o
+obj-$(CONFIG_WL1251_SPI)	+= spi.o
+obj-$(CONFIG_WL1251_SDIO)	+= sdio.o
+
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl1251/acx.c
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_acx.c
rename to drivers/net/wireless/wl1251/acx.c
index 2f8a2ba..64a0214 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -1,13 +1,13 @@
-#include "wl1251_acx.h"
+#include "acx.h"
 
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/crc7.h>
 
 #include "wl1251.h"
-#include "wl1251_reg.h"
-#include "wl1251_cmd.h"
-#include "wl1251_ps.h"
+#include "reg.h"
+#include "cmd.h"
+#include "ps.h"
 
 int wl1251_acx_frame_rates(struct wl1251 *wl, u8 ctrl_rate, u8 ctrl_mod,
 			   u8 mgt_rate, u8 mgt_mod)
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl1251/acx.h
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_acx.h
rename to drivers/net/wireless/wl1251/acx.h
index c7cc5c1..e54b21a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl1251/acx.h
@@ -24,7 +24,7 @@
 #define __WL1251_ACX_H__
 
 #include "wl1251.h"
-#include "wl1251_cmd.h"
+#include "cmd.h"
 
 /* Target's information element */
 struct acx_header {
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl1251/boot.c
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_boot.c
rename to drivers/net/wireless/wl1251/boot.c
index 468b47b..61572df 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl1251/boot.c
@@ -22,12 +22,12 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
-#include "wl1251_reg.h"
-#include "wl1251_boot.h"
-#include "wl1251_io.h"
-#include "wl1251_spi.h"
-#include "wl1251_event.h"
-#include "wl1251_acx.h"
+#include "reg.h"
+#include "boot.h"
+#include "io.h"
+#include "spi.h"
+#include "event.h"
+#include "acx.h"
 
 void wl1251_boot_target_enable_interrupts(struct wl1251 *wl)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.h b/drivers/net/wireless/wl1251/boot.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_boot.h
rename to drivers/net/wireless/wl1251/boot.h
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl1251/cmd.c
similarity index 98%
rename from drivers/net/wireless/wl12xx/wl1251_cmd.c
rename to drivers/net/wireless/wl1251/cmd.c
index 15fb68c..0ade4bd 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl1251/cmd.c
@@ -1,14 +1,14 @@
-#include "wl1251_cmd.h"
+#include "cmd.h"
 
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/crc7.h>
 
 #include "wl1251.h"
-#include "wl1251_reg.h"
-#include "wl1251_io.h"
-#include "wl1251_ps.h"
-#include "wl1251_acx.h"
+#include "reg.h"
+#include "io.h"
+#include "ps.h"
+#include "acx.h"
 
 /**
  * send command to firmware
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl1251/cmd.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_cmd.h
rename to drivers/net/wireless/wl1251/cmd.h
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.c b/drivers/net/wireless/wl1251/debugfs.c
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_debugfs.c
rename to drivers/net/wireless/wl1251/debugfs.c
index 6ffe4cd..6e5caaa 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.c
+++ b/drivers/net/wireless/wl1251/debugfs.c
@@ -19,14 +19,14 @@
  *
  */
 
-#include "wl1251_debugfs.h"
+#include "debugfs.h"
 
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 
 #include "wl1251.h"
-#include "wl1251_acx.h"
-#include "wl1251_ps.h"
+#include "acx.h"
+#include "ps.h"
 
 /* ms */
 #define WL1251_DEBUGFS_STATS_LIFETIME 1000
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.h b/drivers/net/wireless/wl1251/debugfs.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_debugfs.h
rename to drivers/net/wireless/wl1251/debugfs.h
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl1251/event.c
similarity index 97%
rename from drivers/net/wireless/wl12xx/wl1251_event.c
rename to drivers/net/wireless/wl1251/event.c
index 5422355..712372e 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl1251/event.c
@@ -21,10 +21,10 @@
  */
 
 #include "wl1251.h"
-#include "wl1251_reg.h"
-#include "wl1251_io.h"
-#include "wl1251_event.h"
-#include "wl1251_ps.h"
+#include "reg.h"
+#include "io.h"
+#include "event.h"
+#include "ps.h"
 
 static int wl1251_event_scan_complete(struct wl1251 *wl,
 				      struct event_mailbox *mbox)
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.h b/drivers/net/wireless/wl1251/event.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_event.h
rename to drivers/net/wireless/wl1251/event.h
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.c b/drivers/net/wireless/wl1251/init.c
similarity index 98%
rename from drivers/net/wireless/wl12xx/wl1251_init.c
rename to drivers/net/wireless/wl1251/init.c
index c5daec0..89b43d3 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.c
+++ b/drivers/net/wireless/wl1251/init.c
@@ -23,11 +23,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
-#include "wl1251_init.h"
+#include "init.h"
 #include "wl12xx_80211.h"
-#include "wl1251_acx.h"
-#include "wl1251_cmd.h"
-#include "wl1251_reg.h"
+#include "acx.h"
+#include "cmd.h"
+#include "reg.h"
 
 int wl1251_hw_init_hwenc_config(struct wl1251 *wl)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.h b/drivers/net/wireless/wl1251/init.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_init.h
rename to drivers/net/wireless/wl1251/init.h
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.c b/drivers/net/wireless/wl1251/io.c
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_io.c
rename to drivers/net/wireless/wl1251/io.c
index ad6ca68..cdcadbf 100644
--- a/drivers/net/wireless/wl12xx/wl1251_io.c
+++ b/drivers/net/wireless/wl1251/io.c
@@ -20,8 +20,8 @@
  */
 
 #include "wl1251.h"
-#include "wl1251_reg.h"
-#include "wl1251_io.h"
+#include "reg.h"
+#include "io.h"
 
 /* FIXME: this is static data nowadays and the table can be removed */
 static enum wl12xx_acx_int_reg wl1251_io_reg_table[ACX_REG_TABLE_LEN] = {
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.h b/drivers/net/wireless/wl1251/io.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_io.h
rename to drivers/net/wireless/wl1251/io.h
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl1251/main.c
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_main.c
rename to drivers/net/wireless/wl1251/main.c
index faf221c..7a87625 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -31,16 +31,16 @@
 
 #include "wl1251.h"
 #include "wl12xx_80211.h"
-#include "wl1251_reg.h"
-#include "wl1251_io.h"
-#include "wl1251_cmd.h"
-#include "wl1251_event.h"
-#include "wl1251_tx.h"
-#include "wl1251_rx.h"
-#include "wl1251_ps.h"
-#include "wl1251_init.h"
-#include "wl1251_debugfs.h"
-#include "wl1251_boot.h"
+#include "reg.h"
+#include "io.h"
+#include "cmd.h"
+#include "event.h"
+#include "tx.h"
+#include "rx.h"
+#include "ps.h"
+#include "init.h"
+#include "debugfs.h"
+#include "boot.h"
 
 void wl1251_enable_interrupts(struct wl1251 *wl)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl1251/ps.c
similarity index 97%
rename from drivers/net/wireless/wl12xx/wl1251_ps.c
rename to drivers/net/wireless/wl1251/ps.c
index 0b997bd..5ed47c8 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl1251/ps.c
@@ -19,10 +19,10 @@
  *
  */
 
-#include "wl1251_reg.h"
-#include "wl1251_ps.h"
-#include "wl1251_cmd.h"
-#include "wl1251_io.h"
+#include "reg.h"
+#include "ps.h"
+#include "cmd.h"
+#include "io.h"
 
 /* in ms */
 #define WL1251_WAKEUP_TIMEOUT 100
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.h b/drivers/net/wireless/wl1251/ps.h
similarity index 97%
rename from drivers/net/wireless/wl12xx/wl1251_ps.h
rename to drivers/net/wireless/wl1251/ps.h
index e5db81f..55c3dda 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.h
+++ b/drivers/net/wireless/wl1251/ps.h
@@ -24,7 +24,7 @@
 #define __WL1251_PS_H__
 
 #include "wl1251.h"
-#include "wl1251_acx.h"
+#include "acx.h"
 
 int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode);
 void wl1251_ps_elp_sleep(struct wl1251 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1251_reg.h b/drivers/net/wireless/wl1251/reg.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_reg.h
rename to drivers/net/wireless/wl1251/reg.h
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl1251/rx.c
similarity index 97%
rename from drivers/net/wireless/wl12xx/wl1251_rx.c
rename to drivers/net/wireless/wl1251/rx.c
index 2576459..efa5360 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl1251/rx.c
@@ -25,11 +25,11 @@
 #include <net/mac80211.h>
 
 #include "wl1251.h"
-#include "wl1251_reg.h"
-#include "wl1251_io.h"
-#include "wl1251_rx.h"
-#include "wl1251_cmd.h"
-#include "wl1251_acx.h"
+#include "reg.h"
+#include "io.h"
+#include "rx.h"
+#include "cmd.h"
+#include "acx.h"
 
 static void wl1251_rx_header(struct wl1251 *wl,
 			     struct wl1251_rx_descriptor *desc)
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.h b/drivers/net/wireless/wl1251/rx.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_rx.h
rename to drivers/net/wireless/wl1251/rx.h
diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl1251/sdio.c
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251_sdio.c
rename to drivers/net/wireless/wl1251/sdio.c
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl1251/spi.c
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_spi.c
rename to drivers/net/wireless/wl1251/spi.c
index 320de79..88fa8e6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl1251/spi.c
@@ -27,8 +27,8 @@
 #include <linux/wl12xx.h>
 
 #include "wl1251.h"
-#include "wl1251_reg.h"
-#include "wl1251_spi.h"
+#include "reg.h"
+#include "spi.h"
 
 static irqreturn_t wl1251_irq(int irq, void *cookie)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.h b/drivers/net/wireless/wl1251/spi.h
similarity index 96%
rename from drivers/net/wireless/wl12xx/wl1251_spi.h
rename to drivers/net/wireless/wl1251/spi.h
index 7dcf3cf..16d5069 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.h
+++ b/drivers/net/wireless/wl1251/spi.h
@@ -23,9 +23,9 @@
 #ifndef __WL1251_SPI_H__
 #define __WL1251_SPI_H__
 
-#include "wl1251_cmd.h"
-#include "wl1251_acx.h"
-#include "wl1251_reg.h"
+#include "cmd.h"
+#include "acx.h"
+#include "reg.h"
 
 #define WSPI_CMD_READ                 0x40000000
 #define WSPI_CMD_WRITE                0x00000000
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl1251/tx.c
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_tx.c
rename to drivers/net/wireless/wl1251/tx.c
index 388492a..554b4f9 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl1251/tx.c
@@ -24,10 +24,10 @@
 #include <linux/module.h>
 
 #include "wl1251.h"
-#include "wl1251_reg.h"
-#include "wl1251_tx.h"
-#include "wl1251_ps.h"
-#include "wl1251_io.h"
+#include "reg.h"
+#include "tx.h"
+#include "ps.h"
+#include "io.h"
 
 static bool wl1251_tx_double_buffer_busy(struct wl1251 *wl, u32 data_out_count)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.h b/drivers/net/wireless/wl1251/tx.h
similarity index 99%
rename from drivers/net/wireless/wl12xx/wl1251_tx.h
rename to drivers/net/wireless/wl1251/tx.h
index 96011e7..81338d3 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.h
+++ b/drivers/net/wireless/wl1251/tx.h
@@ -24,7 +24,7 @@
 #define __WL1251_TX_H__
 
 #include <linux/bitops.h>
-#include "wl1251_acx.h"
+#include "acx.h"
 
 /*
  *
diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
similarity index 100%
rename from drivers/net/wireless/wl12xx/wl1251.h
rename to drivers/net/wireless/wl1251/wl1251.h
diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 4a8bb25..b447559 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -5,40 +5,6 @@ menuconfig WL12XX
 	  This will enable TI wl12xx driver support. The drivers make
 	  use of the mac80211 stack.
 
-config WL1251
-	tristate "TI wl1251 support"
-	depends on WL12XX && GENERIC_HARDIRQS
-	select FW_LOADER
-	select CRC7
-	---help---
-	  This module adds support for wireless adapters based on
-	  TI wl1251 chipset.
-
-	  If you choose to build a module, it'll be called wl1251. Say
-	  N if unsure.
-
-config WL1251_SPI
-	tristate "TI wl1251 SPI support"
-	depends on WL1251 && SPI_MASTER
-	---help---
-	  This module adds support for the SPI interface of adapters using
-	  TI wl1251 chipset.  Select this if your platform is using
-	  the SPI bus.
-
-	  If you choose to build a module, it'll be called wl1251_spi.
-	  Say N if unsure.
-
-config WL1251_SDIO
-	tristate "TI wl1251 SDIO support"
-	depends on WL1251 && MMC
-	---help---
-	  This module adds support for the SDIO interface of adapters using
-	  TI wl1251 chipset.  Select this if your platform is using
-	  the SDIO bus.
-
-	  If you choose to build a module, it'll be called
-	  wl1251_sdio. Say N if unsure.
-
 config WL1271
 	tristate "TI wl1271 support"
 	depends on WL12XX && GENERIC_HARDIRQS
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 0d334d6..3a80744 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,12 +1,3 @@
-wl1251-objs		= wl1251_main.o wl1251_event.o \
-			  wl1251_tx.o wl1251_rx.o wl1251_ps.o wl1251_cmd.o \
-			  wl1251_acx.o wl1251_boot.o wl1251_init.o \
-			  wl1251_debugfs.o wl1251_io.o
-
-obj-$(CONFIG_WL1251)	+= wl1251.o
-obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
-obj-$(CONFIG_WL1251_SDIO)	+= wl1251_sdio.o
-
 wl1271-objs		= wl1271_main.o  wl1271_cmd.o wl1271_io.o \
 			  wl1271_event.o wl1271_tx.o  wl1271_rx.o   \
 			  wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
-- 
1.7.0.4

