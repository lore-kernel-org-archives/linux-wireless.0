Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:33356 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2AQSJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 13:09:41 -0500
Subject: [PATCH v3 7/8] ath6kl: create ath6kl_core.ko
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 17 Jan 2012 20:09:36 +0200
Message-ID: <20120117180936.29995.84210.stgit@localhost6.localdomain6> (sfid-20120117_190944_888627_090A6BFD)
In-Reply-To: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
References: <20120117180827.29995.67922.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now ath6kl is ready for splitting core code to ath6kl_core.ko module.
This also makes it possible to link both sdio and usb code to kernel
at the same time, which earlier failed miserably.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Makefile   |   28 +++++++++++++++-------------
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 +++
 drivers/net/wireless/ath/ath6kl/core.c     |    9 +++++++++
 drivers/net/wireless/ath/ath6kl/debug.c    |    3 +++
 drivers/net/wireless/ath/ath6kl/hif.c      |    5 +++++
 drivers/net/wireless/ath/ath6kl/init.c     |    3 +++
 6 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 854694b..cbdc31c 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -21,16 +21,18 @@
 # Author(s): ="Atheros"
 #------------------------------------------------------------------------------
 
-obj-$(CONFIG_ATH6KL) := ath6kl.o
-ath6kl-y += debug.o
-ath6kl-y += hif.o
-ath6kl-y += htc.o
-ath6kl-y += bmi.o
-ath6kl-y += cfg80211.o
-ath6kl-y += init.o
-ath6kl-y += main.o
-ath6kl-y += txrx.o
-ath6kl-y += wmi.o
-ath6kl-y += core.o
-ath6kl-y += sdio.o
-ath6kl-$(CONFIG_NL80211_TESTMODE) += testmode.o
+obj-$(CONFIG_ATH6KL) += ath6kl_core.o
+ath6kl_core-y += debug.o
+ath6kl_core-y += hif.o
+ath6kl_core-y += htc.o
+ath6kl_core-y += bmi.o
+ath6kl_core-y += cfg80211.o
+ath6kl_core-y += init.o
+ath6kl_core-y += main.o
+ath6kl_core-y += txrx.o
+ath6kl_core-y += wmi.o
+ath6kl_core-y += core.o
+ath6kl_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
+
+obj-$(CONFIG_ATH6KL_SDIO) += ath6kl_sdio.o
+ath6kl_sdio-y += sdio.o
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7ff9806..594d246 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -16,6 +16,7 @@
 
 #include <linux/moduleparam.h>
 #include <linux/inetdevice.h>
+#include <linux/export.h>
 
 #include "core.h"
 #include "cfg80211.h"
@@ -1935,6 +1936,7 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 	return 0;
 }
+EXPORT_SYMBOL(ath6kl_cfg80211_suspend);
 
 int ath6kl_cfg80211_resume(struct ath6kl *ar)
 {
@@ -1986,6 +1988,7 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
 
 	return 0;
 }
+EXPORT_SYMBOL(ath6kl_cfg80211_resume);
 
 #ifdef CONFIG_PM
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 9990c33..aefda09 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -16,7 +16,9 @@
 
 #include "core.h"
 
+#include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/export.h>
 
 #include "debug.h"
 #include "hif-ops.h"
@@ -203,6 +205,7 @@ err_wq:
 
 	return ret;
 }
+EXPORT_SYMBOL(ath6kl_core_init);
 
 struct ath6kl *ath6kl_core_create(struct device *dev)
 {
@@ -258,6 +261,7 @@ struct ath6kl *ath6kl_core_create(struct device *dev)
 
 	return ar;
 }
+EXPORT_SYMBOL(ath6kl_core_create);
 
 void ath6kl_core_cleanup(struct ath6kl *ar)
 {
@@ -283,9 +287,14 @@ void ath6kl_core_cleanup(struct ath6kl *ar)
 
 	ath6kl_cfg80211_cleanup(ar);
 }
+EXPORT_SYMBOL(ath6kl_core_cleanup);
 
 void ath6kl_core_destroy(struct ath6kl *ar)
 {
 	ath6kl_cfg80211_destroy(ar);
 }
+EXPORT_SYMBOL(ath6kl_core_destroy);
 
+MODULE_AUTHOR("Qualcomm Atheros");
+MODULE_DESCRIPTION("Core module for AR600x SDIO and USB devices.");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 4ba6560..6b546dc 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -54,6 +54,7 @@ int ath6kl_printk(const char *level, const char *fmt, ...)
 
 	return rtn;
 }
+EXPORT_SYMBOL(ath6kl_printk);
 
 #ifdef CONFIG_ATH6KL_DEBUG
 
@@ -74,6 +75,7 @@ void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...)
 
 	va_end(args);
 }
+EXPORT_SYMBOL(ath6kl_dbg);
 
 void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
 		     const char *msg, const char *prefix,
@@ -86,6 +88,7 @@ void ath6kl_dbg_dump(enum ATH6K_DEBUG_MASK mask,
 		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
 	}
 }
+EXPORT_SYMBOL(ath6kl_dbg_dump);
 
 #define REG_OUTPUT_LEN_PER_LINE	25
 #define REGTYPE_STR_LEN		100
diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
index 7118868..d912da6 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.c
+++ b/drivers/net/wireless/ath/ath6kl/hif.c
@@ -15,6 +15,8 @@
  */
 #include "hif.h"
 
+#include <linux/export.h>
+
 #include "core.h"
 #include "target.h"
 #include "hif-ops.h"
@@ -59,6 +61,8 @@ int ath6kl_hif_rw_comp_handler(void *context, int status)
 
 	return 0;
 }
+EXPORT_SYMBOL(ath6kl_hif_rw_comp_handler);
+
 #define REG_DUMP_COUNT_AR6003   60
 #define REGISTER_DUMP_LEN_MAX   60
 
@@ -560,6 +564,7 @@ int ath6kl_hif_intr_bh_handler(struct ath6kl *ar)
 
 	return status;
 }
+EXPORT_SYMBOL(ath6kl_hif_intr_bh_handler);
 
 static int ath6kl_hif_enable_intrs(struct ath6kl_device *dev)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 06a7c9b..0d62f47 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -17,8 +17,10 @@
 
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/export.h>
 #include <linux/of.h>
 #include <linux/mmc/sdio_func.h>
+
 #include "core.h"
 #include "cfg80211.h"
 #include "target.h"
@@ -1612,3 +1614,4 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 
 	clear_bit(WLAN_ENABLED, &ar->flag);
 }
+EXPORT_SYMBOL(ath6kl_stop_txrx);

