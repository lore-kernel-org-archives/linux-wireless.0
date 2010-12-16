Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49138 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab0LPUpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 15:45:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8192ce: drop 'rtl8192c-' prefix from files
Date: Thu, 16 Dec 2010 15:43:36 -0500
Message-Id: <1292532216-14491-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Any objections?  It's less to type/read/whatever...

 drivers/net/wireless/rtlwifi/rtl8192ce/Makefile    |   18 +++++++++---------
 .../rtlwifi/rtl8192ce/{rtl8192c-def.h => def.h}    |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-dm.c => dm.c}      |   10 +++++-----
 .../rtlwifi/rtl8192ce/{rtl8192c-dm.h => dm.h}      |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-fw.c => fw.c}      |    8 ++++----
 .../rtlwifi/rtl8192ce/{rtl8192c-fw.h => fw.h}      |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-hw.c => hw.c}      |   14 +++++++-------
 .../rtlwifi/rtl8192ce/{rtl8192c-hw.h => hw.h}      |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-led.c => led.c}    |    4 ++--
 .../rtlwifi/rtl8192ce/{rtl8192c-led.h => led.h}    |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-phy.c => phy.c}    |   12 ++++++------
 .../rtlwifi/rtl8192ce/{rtl8192c-phy.h => phy.h}    |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-reg.h => reg.h}    |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-rf.c => rf.c}      |   10 +++++-----
 .../rtlwifi/rtl8192ce/{rtl8192c-rf.h => rf.h}      |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-sw.c => sw.c}      |   16 ++++++++--------
 .../rtlwifi/rtl8192ce/{rtl8192c-sw.h => sw.h}      |    0
 .../rtl8192ce/{rtl8192c-table.c => table.c}        |    2 +-
 .../rtl8192ce/{rtl8192c-table.h => table.h}        |    0
 .../rtlwifi/rtl8192ce/{rtl8192c-trx.c => trx.c}    |   10 +++++-----
 .../rtlwifi/rtl8192ce/{rtl8192c-trx.h => trx.h}    |    0
 21 files changed, 52 insertions(+), 52 deletions(-)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-def.h => def.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-dm.c => dm.c} (99%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-dm.h => dm.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-fw.c => fw.c} (99%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-fw.h => fw.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-hw.c => hw.c} (99%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-hw.h => hw.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-led.c => led.c} (98%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-led.h => led.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-phy.c => phy.c} (99%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-phy.h => phy.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-reg.h => reg.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-rf.c => rf.c} (99%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-rf.h => rf.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-sw.c => sw.c} (97%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-sw.h => sw.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-table.c => table.c} (99%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-table.h => table.h} (100%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-trx.c => trx.c} (99%)
 rename drivers/net/wireless/rtlwifi/rtl8192ce/{rtl8192c-trx.h => trx.h} (100%)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile b/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
index f3d7682..0f0be7c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
@@ -1,12 +1,12 @@
 rtl8192ce-objs :=		\
-	rtl8192c-dm.o		\
-	rtl8192c-fw.o		\
-	rtl8192c-hw.o		\
-	rtl8192c-led.o		\
-	rtl8192c-phy.o		\
-	rtl8192c-rf.o		\
-	rtl8192c-sw.o		\
-	rtl8192c-table.o	\
-	rtl8192c-trx.o
+		dm.o		\
+		fw.o		\
+		hw.o		\
+		led.o		\
+		phy.o		\
+		rf.o		\
+		sw.o		\
+		table.o		\
+		trx.o
 
 obj-$(CONFIG_RTL8192CE) += rtl8192ce.o
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-def.h b/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-def.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-dm.c b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
similarity index 99%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-dm.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
index 4896899..62e7c64 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
@@ -29,11 +29,11 @@
 
 #include "../wifi.h"
 #include "../base.h"
-#include "rtl8192c-reg.h"
-#include "rtl8192c-def.h"
-#include "rtl8192c-phy.h"
-#include "rtl8192c-dm.h"
-#include "rtl8192c-fw.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "dm.h"
+#include "fw.h"
 
 struct dig_t dm_digtable;
 static struct ps_t dm_pstable;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-dm.h b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-dm.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-fw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
similarity index 99%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-fw.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
index 80ee6ff..11dd22b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
@@ -31,10 +31,10 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../base.h"
-#include "rtl8192c-reg.h"
-#include "rtl8192c-def.h"
-#include "rtl8192c-fw.h"
-#include "rtl8192c-table.h"
+#include "reg.h"
+#include "def.h"
+#include "fw.h"
+#include "table.h"
 
 static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-fw.h b/drivers/net/wireless/rtlwifi/rtl8192ce/fw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-fw.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/fw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
similarity index 99%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-hw.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index c649f65..1266dbe 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -33,13 +33,13 @@
 #include "../cam.h"
 #include "../ps.h"
 #include "../pci.h"
-#include "rtl8192c-reg.h"
-#include "rtl8192c-def.h"
-#include "rtl8192c-phy.h"
-#include "rtl8192c-dm.h"
-#include "rtl8192c-fw.h"
-#include "rtl8192c-led.h"
-#include "rtl8192c-hw.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "dm.h"
+#include "fw.h"
+#include "led.h"
+#include "hw.h"
 
 #define LLT_CONFIG	5
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-hw.h b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-hw.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-led.c b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
similarity index 98%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-led.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/led.c
index 6091084..78a0569 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
@@ -29,8 +29,8 @@
 
 #include "../wifi.h"
 #include "../pci.h"
-#include "rtl8192c-reg.h"
-#include "rtl8192c-led.h"
+#include "reg.h"
+#include "led.h"
 
 void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled)
 {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-led.h b/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-led.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
similarity index 99%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-phy.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index 13d7b38..4504411 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -30,12 +30,12 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../ps.h"
-#include "rtl8192c-reg.h"
-#include "rtl8192c-def.h"
-#include "rtl8192c-phy.h"
-#include "rtl8192c-rf.h"
-#include "rtl8192c-dm.h"
-#include "rtl8192c-table.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "rf.h"
+#include "dm.h"
+#include "table.h"
 
 static u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
 					 enum radio_path rfpath, u32 offset);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-phy.h b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-phy.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-reg.h b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-reg.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-rf.c b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
similarity index 99%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-rf.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
index a2d58df..ffd8e04 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -28,11 +28,11 @@
  *****************************************************************************/
 
 #include "../wifi.h"
-#include "rtl8192c-reg.h"
-#include "rtl8192c-def.h"
-#include "rtl8192c-phy.h"
-#include "rtl8192c-rf.h"
-#include "rtl8192c-dm.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "rf.h"
+#include "dm.h"
 
 static bool _rtl92c_phy_rf6052_config_parafile(struct ieee80211_hw *hw);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-rf.h b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-rf.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
similarity index 97%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index 4c76ad6..b366e88 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -32,14 +32,14 @@
 #include "../wifi.h"
 #include "../core.h"
 #include "../pci.h"
-#include "rtl8192c-reg.h"
-#include "rtl8192c-def.h"
-#include "rtl8192c-phy.h"
-#include "rtl8192c-dm.h"
-#include "rtl8192c-hw.h"
-#include "rtl8192c-sw.h"
-#include "rtl8192c-trx.h"
-#include "rtl8192c-led.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "dm.h"
+#include "hw.h"
+#include "sw.h"
+#include "trx.h"
+#include "led.h"
 
 int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.h b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-sw.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-table.c b/drivers/net/wireless/rtlwifi/rtl8192ce/table.c
similarity index 99%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-table.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/table.c
index 2a9bbbe..ba938b9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-table.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/table.c
@@ -29,7 +29,7 @@
  *
  *****************************************************************************/
 
-#include "rtl8192c-table.h"
+#include "table.h"
 
 
 u32 RTL8192CEPHY_REG_2TARRAY[PHY_REG_2TARRAY_LENGTH] = {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-table.h b/drivers/net/wireless/rtlwifi/rtl8192ce/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-table.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
similarity index 99%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.c
rename to drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index cf35418..bf5852f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -30,11 +30,11 @@
 #include "../wifi.h"
 #include "../pci.h"
 #include "../base.h"
-#include "rtl8192c-reg.h"
-#include "rtl8192c-def.h"
-#include "rtl8192c-phy.h"
-#include "rtl8192c-trx.h"
-#include "rtl8192c-led.h"
+#include "reg.h"
+#include "def.h"
+#include "phy.h"
+#include "trx.h"
+#include "led.h"
 
 static enum rtl_desc_qsel _rtl92ce_map_hwqueue_to_fwqueue(u16 fc,
 							  unsigned int
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.h b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192c-trx.h
rename to drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
-- 
1.7.3.3

