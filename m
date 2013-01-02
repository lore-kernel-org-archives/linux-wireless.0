Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3948 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3ABOXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:07 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/18] brcmfmac: define pr_fmt in one place
Date: Wed, 2 Jan 2013 15:22:41 +0100
Message-ID: <1357136572-18273-9-git-send-email-arend@broadcom.com> (sfid-20130102_152314_164353_3305A540)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several source files (but not all) define the pr_fmt() macro in exactly
the same way. Instead this commit defines it in a header file so driver
logging is consistent.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c      |    2 --
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c    |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c     |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c  |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h     |   17 +++++------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c   |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c    |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c   |    2 --
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    2 --
 9 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index be35a2f..11fd1c7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -15,8 +15,6 @@
  */
 /* ****************** SDIO CARD Interface Functions **************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/export.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d33e559..d92d373 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/mmc/sdio.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 8392355..0c83998 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -19,8 +19,6 @@
  * For certain dcmd codes, the dongle interprets string data from the host.
  ******************************************************************************/
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/types.h>
 #include <linux/netdevice.h>
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index f8b52e5..4544342 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index f2ab01c..968dcb0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -34,19 +34,12 @@
 #define BRCMF_SCAN_VAL	0x4000
 #define BRCMF_CONN_VAL	0x8000
 
-/* Macro for error messages. net_ratelimit() is used when driver
- * debugging is not selected. When debugging the driver error
- * messages are as important as other tracing or even more so.
- */
-#ifdef CONFIG_BRCMDBG
+/* set default print format */
+#undef pr_fmt
+#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+
+/* error messages are always logged */
 #define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
-#else
-#define brcmf_err(fmt, ...)						\
-	do {								\
-		if (net_ratelimit())					\
-			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
-	} while (0)
-#endif
 
 #if defined(DEBUG)
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 16efcb4..6520b58 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index cf857f1..651474b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index b1bb46c..14be2d5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -15,8 +15,6 @@
  */
 /* ***** SDIO interface chip backplane handle functions ***** */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/mmc/card.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index ee4eb44..1ec2d57 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -16,8 +16,6 @@
 
 /* Toplevel file. Relies on dhd_linux.c to send commands to the dongle. */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <net/cfg80211.h>
-- 
1.7.10.4


