Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2510 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab1FIOpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/21] staging: brcm80211: fixed double #include problem
Date: Thu, 9 Jun 2011 16:44:50 +0200
Message-ID: <1307630701-9170-11-git-send-email-rvossen@broadcom.com> (sfid-20110609_164528_351466_6EE49448)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Removed one redundant include and reshuffled #include order as
to include Linux header files first.

Reported-by: julie Sullivan <kernelmail.jms@gmail.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    7 ++---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   20 +++++++---------
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |   19 +++++++--------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   10 ++++----
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   14 +++++-----
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   13 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   15 +++++------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   24 ++++++++-----------
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   18 +++++----------
 drivers/staging/brcm80211/brcmsmac/bmac.c          |    2 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |    8 +++---
 drivers/staging/brcm80211/brcmsmac/otp.c           |    2 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |    1 -
 14 files changed, 70 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index b3bdd48..3d0c8e7 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -19,15 +19,14 @@
 #include <linux/netdevice.h>
 #include <linux/pci_ids.h>
 #include <linux/sched.h>
+
 #include <defs.h>
 #include <brcm_hw_ids.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include <soc.h>
-
-#include <bcmsdbus.h>		/* common SDIO/controller interface */
-#include <sbsdio.h>		/* BRCM sdio device core */
-
+#include "bcmsdbus.h"		/* common SDIO/controller interface */
+#include "sbsdio.h"		/* BRCM sdio device core */
 #include "dngl_stats.h"
 #include "dhd.h"
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 66e204b..b90d7d0 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -16,22 +16,20 @@
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/mmc/sdio.h>
-#include <defs.h>
-#include <brcm_hw_ids.h>
-#include <brcmu_utils.h>
-#include <brcmu_wifi.h>
-#include "sdio_host.h"
-#include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
-#include <sdiovar.h>		/* ioctl/iovars */
-
 #include <linux/mmc/core.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/suspend.h>
 
-#include <dngl_stats.h>
-#include <dhd.h>
-
+#include <defs.h>
+#include <brcm_hw_ids.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
+#include "sdio_host.h"
+#include "bcmsdbus.h"		/* bcmsdh to/from specific controller APIs */
+#include "sdiovar.h"		/* ioctl/iovars */
+#include "dngl_stats.h"
+#include "dhd.h"
 #include "bcmsdh_sdmmc.h"
 
 extern int sdio_function_init(void);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 9fc491d..5f17b8f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -16,19 +16,18 @@
 #include <linux/types.h>
 #include <linux/sched.h>	/* request_irq() */
 #include <linux/netdevice.h>
-#include <net/cfg80211.h>
-#include <defs.h>
-#include <brcmu_utils.h>
-#include <brcmu_wifi.h>
-#include "sdio_host.h"
-#include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
-#include <sdiovar.h>		/* to get msglevel bit values */
-
 #include <linux/mmc/core.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
+#include <net/cfg80211.h>
 
+#include <defs.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
+#include "sdio_host.h"
+#include "bcmsdbus.h"		/* bcmsdh to/from specific controller APIs */
+#include "sdiovar.h"		/* to get msglevel bit values */
 #include "dngl_stats.h"
 #include "dhd.h"
 
@@ -53,8 +52,8 @@
 
 #include <bcmsdh_sdmmc.h>
 
-#include <dhd_dbg.h>
-#include <wl_cfg80211.h>
+#include "dhd_dbg.h"
+#include "wl_cfg80211.h"
 
 extern void sdioh_sdmmc_devintr_off(sdioh_info_t *sd);
 extern void sdioh_sdmmc_devintr_on(sdioh_info_t *sd);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 2220941..bf3fe99 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -22,11 +22,11 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
-#include <dngl_stats.h>
-#include <dhd.h>
-#include <dhd_proto.h>
-#include <dhd_bus.h>
-#include <dhd_dbg.h>
+#include "dngl_stats.h"
+#include "dhd.h"
+#include "dhd_proto.h"
+#include "dhd_bus.h"
+#include "dhd_dbg.h"
 
 struct cdc_ioctl {
 	u32 cmd;	/* ioctl command value */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 73d8b02..0a5a1a4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -16,16 +16,16 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/sched.h>
-#include <defs.h>
-#include <brcmu_wifi.h>
 #include <linux/netdevice.h>
 #include <asm/unaligned.h>
+#include <defs.h>
+#include <brcmu_wifi.h>
 #include <brcmu_utils.h>
-#include <dngl_stats.h>
-#include <dhd.h>
-#include <dhd_bus.h>
-#include <dhd_proto.h>
-#include <dhd_dbg.h>
+#include "dngl_stats.h"
+#include "dhd.h"
+#include "dhd_bus.h"
+#include "dhd_proto.h"
+#include "dhd_dbg.h"
 
 #define BRCM_OUI		"\x00\x10\x18"
 #define DOT11_OUI_LEN			3
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index 6008888..defc009 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -20,8 +20,8 @@
 #include <defs.h>
 #include <brcmu_wifi.h>
 
-#include <dngl_stats.h>
-#include <dhd.h>
+#include "dngl_stats.h"
+#include "dhd.h"
 
 #define WL_ERROR(fmt, args...) printk(fmt, ##args)
 #define WL_TRACE(fmt, args...) no_printk(fmt, ##args)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index b48447c..be6ac30 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -36,13 +36,12 @@
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
-#include <dngl_stats.h>
-#include <dhd.h>
-#include <dhd_bus.h>
-#include <dhd_proto.h>
-#include <dhd_dbg.h>
-
-#include <wl_cfg80211.h>
+#include "dngl_stats.h"
+#include "dhd.h"
+#include "dhd_bus.h"
+#include "dhd_proto.h"
+#include "dhd_dbg.h"
+#include "wl_cfg80211.h"
 
 #define EPI_VERSION_STR		"4.218.248.5"
 #define ETH_P_BRCM			0x886c
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 330703b..a803848 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -23,12 +23,11 @@
 #include <linux/mmc/sdio.h>
 #include <asm/unaligned.h>
 #include <defs.h>
-#include "sdio_host.h"
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include <brcm_hw_ids.h>
-
 #include <soc.h>
+#include "sdio_host.h"
 
 /* register access macros */
 #ifndef __BIG_ENDIAN
@@ -162,13 +161,13 @@ typedef struct {
 #endif				/* DHD_DEBUG */
 #include <chipcommon.h>
 
-#include <sbsdio.h>
+#include "sbsdio.h"
 
-#include <dngl_stats.h>
-#include <dhd.h>
-#include <dhd_bus.h>
-#include <dhd_proto.h>
-#include <dhd_dbg.h>
+#include "dngl_stats.h"
+#include "dhd.h"
+#include "dhd_bus.h"
+#include "dhd_proto.h"
+#include "dhd_dbg.h"
 #include <sdiovar.h>
 #include <bcmchip.h>
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 457f5b1..e9d19c5 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -17,28 +17,24 @@
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
 #include <linux/sched.h>
-
-#include <brcmu_utils.h>
-#include <defs.h>
-#include <brcmu_wifi.h>
-
-#include <asm/uaccess.h>
-
-#include <dngl_stats.h>
-#include <dhd.h>
-
 #include <linux/kthread.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
-#include <net/cfg80211.h>
-
-#include <net/rtnetlink.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/firmware.h>
-#include <wl_cfg80211.h>
+#include <linux/uaccess.h>
+#include <net/cfg80211.h>
+#include <net/rtnetlink.h>
+
+#include <brcmu_utils.h>
+#include <defs.h>
+#include <brcmu_wifi.h>
+#include "dngl_stats.h"
+#include "dhd.h"
+#include "wl_cfg80211.h"
 
 void sdioh_sdio_set_host_pm_flags(int flag);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index c65affc..14b2e1b 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -13,29 +13,23 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-
 #include <linux/kthread.h>
 #include <linux/semaphore.h>
-#include <defs.h>
+#include <linux/ieee80211.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
+#include <linux/if_arp.h>
+#include <linux/uaccess.h>
 
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
-
-#include <linux/if_arp.h>
-#include <asm/uaccess.h>
-
-#include <dngl_stats.h>
-#include <dhd.h>
-#include <linux/ieee80211.h>
+#include <defs.h>
+#include "dngl_stats.h"
+#include "dhd.h"
 
 struct si_pub;
 
-#include <dngl_stats.h>
-#include <dhd.h>
-
 #define WPA_OUI			"\x00\x50\xF2"
 #define DOT11_MNG_RSN_ID			48
 #define DOT11_MNG_WPA_ID			221
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 448a562..9d6ee5d 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -16,10 +16,10 @@
 #include <linux/pci.h>
 #include <net/mac80211.h>
 
-#include "types.h"
 #include <brcm_hw_ids.h>
 #include <aiutils.h>
 #include <chipcommon.h>
+#include "types.h"
 #include "rate.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 642c9921..adf364c 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -18,15 +18,15 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 
+#if defined(__mips__)
+#include <asm/addrspace.h>
+#endif
+
 #include <brcmu_utils.h>
 #include <aiutils.h>
 #include "types.h"
 #include "dma.h"
 
-#if defined(__mips__)
-#include <asm/addrspace.h>
-#endif
-
 /*
  * Each descriptor ring must be 8kB aligned, and fit within a contiguous 8kB physical address.
  */
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index d09f913..2cda60f 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -18,8 +18,8 @@
 #include <linux/errno.h>
 
 #include <brcm_hw_ids.h>
-#include "aiutils.h"
 #include <chipcommon.h>
+#include "aiutils.h"
 #include "otp.h"
 
 #define OTPS_GUP_MASK		0x00000f00
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 625252a..3a264ec 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -17,7 +17,6 @@
 #include <net/mac80211.h>
 
 #include "types.h"
-
 #include "d11.h"
 #include "rate.h"
 #include "phy/phy_hal.h"
-- 
1.7.4.1


