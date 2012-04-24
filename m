Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2DXCgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 22:36:45 -0400
Received: by iadi9 with SMTP id i9so315300iad.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 19:36:44 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 1/2] wireless: properly use pr_fmt()
Date: Mon, 23 Apr 2012 19:36:37 -0700
Message-Id: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org> (sfid-20120424_043650_596999_863DFBA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

pr_fmt() is either defined or we redefine it. Typically
drivers define it prior to including printk.h but this
is done under the assumption that no other subsystem
it uses has already defined pr_fmt(). In such cases
pr_fmt() should be undefined and redefined.

Doing this properly shaves down compilation time quite
considerably.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---

I left out only ath6kl as ath6kl folks get groggy it seems
if you do not go through their tree. Bleh.

 drivers/net/wireless/ath/ath5k/ani.c                   |    3 +++
 drivers/net/wireless/ath/ath5k/attach.c                |    2 ++
 drivers/net/wireless/ath/ath5k/base.c                  |    2 ++
 drivers/net/wireless/ath/ath5k/desc.c                  |    3 +++
 drivers/net/wireless/ath/ath5k/dma.c                   |    3 +++
 drivers/net/wireless/ath/ath5k/eeprom.c                |    2 ++
 drivers/net/wireless/ath/ath5k/initvals.c              |    3 +++
 drivers/net/wireless/ath/ath5k/led.c                   |    2 ++
 drivers/net/wireless/ath/ath5k/mac80211-ops.c          |    3 +++
 drivers/net/wireless/ath/ath5k/pci.c                   |    2 ++
 drivers/net/wireless/ath/ath5k/phy.c                   |    2 ++
 drivers/net/wireless/ath/ath5k/qcu.c                   |    3 +++
 drivers/net/wireless/ath/ath5k/reset.c                 |    2 ++
 drivers/net/wireless/ath/ath5k/sysfs.c                 |    2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c          |    3 +++
 drivers/net/wireless/ath/ath9k/htc_hst.c               |    3 +++
 drivers/net/wireless/ath/ath9k/init.c                  |    2 ++
 drivers/net/wireless/ath/ath9k/pci.c                   |    2 ++
 drivers/net/wireless/ath/main.c                        |    2 ++
 drivers/net/wireless/ath/regd.c                        |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c       |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c      |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c     |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    2 ++
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 ++
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c      |    2 ++
 drivers/net/wireless/brcm80211/brcmsmac/dma.c          |    3 ++-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 ++
 drivers/net/wireless/brcm80211/brcmsmac/main.c         |    2 ++
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    2 ++
 drivers/net/wireless/brcm80211/brcmutil/utils.c        |    2 ++
 drivers/net/wireless/iwlegacy/3945-mac.c               |    2 ++
 drivers/net/wireless/iwlegacy/4965-mac.c               |    2 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c                 |    2 ++
 drivers/net/wireless/iwlwifi/iwl-pci.c                 |    2 ++
 drivers/net/wireless/libertas/cfg.c                    |    2 ++
 drivers/net/wireless/libertas/if_cs.c                  |    2 ++
 drivers/net/wireless/libertas/if_sdio.c                |    2 ++
 drivers/net/wireless/libertas/if_spi.c                 |    2 ++
 drivers/net/wireless/libertas/if_usb.c                 |    2 ++
 drivers/net/wireless/libertas/main.c                   |    2 ++
 drivers/net/wireless/libertas/mesh.c                   |    2 ++
 drivers/net/wireless/libertas/rx.c                     |    2 ++
 drivers/net/wireless/libertas_tf/cmd.c                 |    2 ++
 drivers/net/wireless/libertas_tf/if_usb.c              |    2 ++
 drivers/net/wireless/libertas_tf/main.c                |    2 ++
 drivers/net/wireless/rtlwifi/wifi.h                    |    2 ++
 net/wireless/core.c                                    |    2 ++
 net/wireless/lib80211.c                                |    2 ++
 net/wireless/lib80211_crypt_tkip.c                     |    2 ++
 net/wireless/reg.c                                     |    2 ++
 54 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 5c00875..f6a2e0d 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -14,8 +14,11 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 7106547..1fe4f08 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -20,8 +20,10 @@
 * Attach/Detach Functions and helpers *
 \*************************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include "ath5k.h"
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 49e3b19..04a5fc0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -40,8 +40,10 @@
  *
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index bd8d439..7068be2 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -21,8 +21,11 @@
  Hardware Descriptor Functions
 \******************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index ce86f15..c9d42d0 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -29,8 +29,11 @@
  * status registers (ISR).
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 4026c90..e32524e 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -21,8 +21,10 @@
 * EEPROM access functions and helpers *
 \*************************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/slab.h>
 
 #include "ath5k.h"
diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index ee1c2fa..7fc4016 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -19,8 +19,11 @@
  *
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index b9f708a..c044476 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -39,8 +39,10 @@
  *
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/pci.h>
 #include "ath5k.h"
 
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 22b80af..6d9a4d1 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -41,11 +41,14 @@
  *
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <net/mac80211.h>
 #include <asm/unaligned.h>
 
+#include <linux/printk.h>
+
 #include "ath5k.h"
 #include "base.h"
 #include "reg.h"
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index dff48fb..076b33f 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -14,8 +14,10 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/nl80211.h>
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 8b71a2d..903ddcc 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -22,8 +22,10 @@
 * PHY related functions *
 \***********************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <asm/unaligned.h>
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 65fe929..fbe1add 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -20,8 +20,11 @@
 Queue Control Unit, DCF Control Unit Functions
 \********************************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 0c2dd47..ca06e35 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -23,10 +23,12 @@
   Reset function and helpers
 \****************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <asm/unaligned.h>
 
+#include <linux/printk.h>
 #include <linux/pci.h>		/* To determine if a card is pci-e */
 #include <linux/log2.h>
 #include <linux/platform_device.h>
diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
index 04cf0ca..1aec168 100644
--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -1,5 +1,7 @@
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/device.h>
 #include <linux/pci.h>
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 25213d5..809c357 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -14,8 +14,11 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "htc.h"
 
 MODULE_AUTHOR("Atheros Communications");
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 4a9570d..caff822 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -14,8 +14,11 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
+
 #include "htc.h"
 
 static int htc_issue_send(struct htc_target *target, struct sk_buff* skb,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index dee9e09..3bbfd4a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -14,8 +14,10 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/ath9k_platform.h>
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a856b51..1c048aa 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -14,8 +14,10 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/nl80211.h>
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
index 8e99540..5e04536 100644
--- a/drivers/net/wireless/ath/main.c
+++ b/drivers/net/wireless/ath/main.c
@@ -14,9 +14,11 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/module.h>
 
 #include "ath.h"
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index d816980..c927f20 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -14,9 +14,11 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/export.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index e925290..eaa5c92 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -15,8 +15,10 @@
  */
 /* ****************** SDIO CARD Interface Functions **************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/export.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 4688904..a963d6c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -14,8 +14,10 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/mmc/sdio.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index a5c15ca..5530e48 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -19,8 +19,10 @@
  * For certain dcmd codes, the dongle interprets string data from the host.
  ******************************************************************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/sched.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 236cb9f..2962900 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -14,9 +14,11 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 8933f9b..f6d5d83 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -14,10 +14,12 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/kthread.h>
 #include <linux/slab.h>
 #include <linux/skbuff.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a83fbea..09d5e6d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/types.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 1534efc..0facbf4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -15,8 +15,10 @@
  */
 /* ***** SDIO interface chip backplane handle functions ***** */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/mmc/card.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d13ae9c..65e48d7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -16,9 +16,11 @@
 
 /* Toplevel file. Relies on dhd_linux.c to send commands to the dongle. */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/if_arp.h>
 #include <linux/sched.h>
 #include <linux/kthread.h>
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index c93ea35..671cf5b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -16,8 +16,10 @@
  * File contents: support functions for PCI/PCIe
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 11054ae..e898266 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -13,9 +13,10 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index aa15558..1248023 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -15,8 +15,10 @@
  */
 
 #define __UNDEF_NO_VERSION__
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/etherdevice.h>
 #include <linux/sched.h>
 #include <linux/firmware.h>
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index b4d9279..7d0f6b6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -14,8 +14,10 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/pci_ids.h>
 #include <linux/if_ether.h>
 #include <net/mac80211.h>
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index 812b6e3..b55b1fa 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -14,9 +14,11 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/delay.h>
 #include <linux/cordic.h>
 
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index b45ab34..b327d35 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -14,8 +14,10 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
 
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index faec404..db47836 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -27,9 +27,11 @@
  *
  *****************************************************************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index f2baf94..1a03a09 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -27,9 +27,11 @@
  *
  *****************************************************************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 202043a..c9e1d0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -27,8 +27,10 @@
  *
  *****************************************************************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 3b41b84..2fb4b3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -61,8 +61,10 @@
  *
  *****************************************************************************/
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 2fa879b..08864c1 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -6,8 +6,10 @@
  *
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/hardirq.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 16beaf3..aa0bd91 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -21,8 +21,10 @@
 
 */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 76caeba..2b45a94 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -26,9 +26,11 @@
  * if_sdio_card_to_host() to pad the data.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/firmware.h>
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 9604a1c..93dc5445 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -17,8 +17,10 @@
  * (at your option) any later version.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/hardirq.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 75403e6..b9b29da 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -2,8 +2,10 @@
  * This file contains functions used in USB interface module.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/firmware.h>
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index e96ee0a..f889f16 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -4,8 +4,10 @@
  * thread etc..
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index e87c031..bd807cd 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -1,5 +1,7 @@
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/hardirq.h>
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index c7366b0..707ecfc 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -2,8 +2,10 @@
  * This file contains the handling of RX in wlan driver.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/etherdevice.h>
 #include <linux/hardirq.h>
 #include <linux/slab.h>
diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index 909ac36..3e35c71 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -7,8 +7,10 @@
  *  the Free Software Foundation; either version 2 of the License, or (at
  *  your option) any later version.
  */
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/hardirq.h>
 #include <linux/slab.h>
 #include <linux/export.h>
diff --git a/drivers/net/wireless/libertas_tf/if_usb.c b/drivers/net/wireless/libertas_tf/if_usb.c
index 7ced130..05fa172 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/libertas_tf/if_usb.c
@@ -9,11 +9,13 @@
  */
 #define DRV_NAME "lbtf_usb"
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include "libertas_tf.h"
 #include "if_usb.h"
 
+#include <linux/printk.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/firmware.h>
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index a034572..50c17f0 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -7,8 +7,10 @@
  *  the Free Software Foundation; either version 2 of the License, or (at
  *  your option) any later version.
  */
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/hardirq.h>
 #include <linux/slab.h>
 
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index bd816ae..00881fe 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -30,8 +30,10 @@
 #ifndef __RTL_WIFI_H__
 #define __RTL_WIFI_H__
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/sched.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 39f2538..61eb9a4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -4,8 +4,10 @@
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index a55c27b..4b35cd0 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -13,8 +13,10 @@
  *
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/ieee80211.h>
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 3873484..ff6bf45 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -10,8 +10,10 @@
  * more details.
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/printk.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 15f3474..d75026c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -42,9 +42,11 @@
  *
  */
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/printk.h>
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/list.h>
-- 
1.7.10.rc1.22.gf5241

