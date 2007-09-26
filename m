Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:41073 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbXIZSBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 14:01:46 -0400
Message-id: <22584316032010514103@pripojeni.net>
Subject: [PATCH 1/4 try 4] Net: ath5k, make its own directory
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <mcgrof@gmail.com>
Date: Wed, 26 Sep 2007 14:01:46 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k, make its own directory

also remove ath5_ prefix from the filenames

Changes-licensed-under: ISC
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>

---
commit 4dae5c12636df0f0ee94fc2d6a9ab53c24873878
tree 9dbe7eb60ff0255e60c40e04beb741b9c2fb7cb0
parent 657bdad86e3a284f0195df4b78b833d21beb727f
author Jiri Slaby <jirislaby@gmail.com> Tue, 25 Sep 2007 09:41:14 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 25 Sep 2007 09:41:14 +0200

 drivers/net/wireless/Makefile       |    3 +--
 drivers/net/wireless/ath5k/Makefile |    2 ++
 drivers/net/wireless/ath5k/ath5k.h  |    4 ++--
 drivers/net/wireless/ath5k/base.c   |    4 ++--
 drivers/net/wireless/ath5k/base.h   |    0 
 drivers/net/wireless/ath5k/hw.c     |    2 +-
 drivers/net/wireless/ath5k/hw.h     |    0 
 drivers/net/wireless/ath5k/reg.h    |    0 
 drivers/net/wireless/ath5k/regdom.c |    2 +-
 drivers/net/wireless/ath5k/regdom.h |    0 
 10 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 02f8b71..638865d 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -48,5 +48,4 @@ obj-$(CONFIG_LIBERTAS)      += libertas/
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
-obj-$(CONFIG_ATH5K)	+= ath5k.o
-ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o
+obj-$(CONFIG_ATH5K)	+= ath5k/
diff --git a/drivers/net/wireless/ath5k/Makefile b/drivers/net/wireless/ath5k/Makefile
new file mode 100644
index 0000000..b145c03
--- /dev/null
+++ b/drivers/net/wireless/ath5k/Makefile
@@ -0,0 +1,2 @@
+ath5k-objs		= base.o hw.o regdom.o
+obj-$(CONFIG_ATH5K)	+= ath5k.o
diff --git a/drivers/net/wireless/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
similarity index 100%
rename from drivers/net/wireless/ath5k.h
rename to drivers/net/wireless/ath5k/ath5k.h
index a6f7995..da9547d 100644
--- a/drivers/net/wireless/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -31,8 +31,8 @@
 #include <linux/types.h>
 #include <net/mac80211.h>
 
-#include "ath5k_hw.h"
-#include "ath5k_regdom.h"
+#include "hw.h"
+#include "regdom.h"
 
 /* PCI IDs */
 #define PCI_DEVICE_ID_ATHEROS_AR5210 		0x0007 /* AR5210 */
diff --git a/drivers/net/wireless/ath5k_base.c b/drivers/net/wireless/ath5k/base.c
similarity index 100%
rename from drivers/net/wireless/ath5k_base.c
rename to drivers/net/wireless/ath5k/base.c
index fead9a7..716b10c 100644
--- a/drivers/net/wireless/ath5k_base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -41,8 +41,8 @@
 
 #include <asm/unaligned.h>
 
-#include "ath5k_base.h"
-#include "ath5k_reg.h"
+#include "base.h"
+#include "reg.h"
 
 #define ATH_DEBUG_MODES		0 /* Show found modes in the log? */
 #define ATH_DUMP_SKB		0 /* show skb contents */
diff --git a/drivers/net/wireless/ath5k_base.h b/drivers/net/wireless/ath5k/base.h
similarity index 100%
rename from drivers/net/wireless/ath5k_base.h
rename to drivers/net/wireless/ath5k/base.h
diff --git a/drivers/net/wireless/ath5k_hw.c b/drivers/net/wireless/ath5k/hw.c
similarity index 100%
rename from drivers/net/wireless/ath5k_hw.c
rename to drivers/net/wireless/ath5k/hw.c
index e4cc307..48c5be4 100644
--- a/drivers/net/wireless/ath5k_hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -25,7 +25,7 @@
 #include <linux/delay.h>
 
 #include "ath5k.h"
-#include "ath5k_reg.h"
+#include "reg.h"
 
 /*Rate tables*/
 static const struct ath5k_rate_table ath5k_rt_11a = AR5K_RATES_11A;
diff --git a/drivers/net/wireless/ath5k_hw.h b/drivers/net/wireless/ath5k/hw.h
similarity index 100%
rename from drivers/net/wireless/ath5k_hw.h
rename to drivers/net/wireless/ath5k/hw.h
diff --git a/drivers/net/wireless/ath5k_reg.h b/drivers/net/wireless/ath5k/reg.h
similarity index 100%
rename from drivers/net/wireless/ath5k_reg.h
rename to drivers/net/wireless/ath5k/reg.h
diff --git a/drivers/net/wireless/ath5k_regdom.c b/drivers/net/wireless/ath5k/regdom.c
similarity index 99%
rename from drivers/net/wireless/ath5k_regdom.c
rename to drivers/net/wireless/ath5k/regdom.c
index 10d3158..e851957 100644
--- a/drivers/net/wireless/ath5k_regdom.c
+++ b/drivers/net/wireless/ath5k/regdom.c
@@ -21,7 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 
-#include "ath5k_regdom.h"
+#include "regdom.h"
 
 static const struct ath5k_regdommap {
 	enum ath5k_regdom dmn;
diff --git a/drivers/net/wireless/ath5k_regdom.h b/drivers/net/wireless/ath5k/regdom.h
similarity index 100%
rename from drivers/net/wireless/ath5k_regdom.h
rename to drivers/net/wireless/ath5k/regdom.h
