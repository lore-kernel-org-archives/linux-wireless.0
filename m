Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2231 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab1FIOp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/21] staging: brcm80211: #include reduction
Date: Thu, 9 Jun 2011 16:44:43 +0200
Message-ID: <1307630701-9170-4-git-send-email-rvossen@broadcom.com> (sfid-20110609_164540_470531_01545ABC)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Number of includes has been reduced by only including what
is necessary.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |   23 ++++++------------
 drivers/staging/brcm80211/brcmsmac/alloc.c         |   13 +---------
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |   10 --------
 drivers/staging/brcm80211/brcmsmac/antsel.c        |   19 +++------------
 drivers/staging/brcm80211/brcmsmac/bmac.c          |   25 ++-----------------
 drivers/staging/brcm80211/brcmsmac/bmac.h          |    3 ++
 drivers/staging/brcm80211/brcmsmac/channel.c       |   14 +---------
 drivers/staging/brcm80211/brcmsmac/d11.h           |    4 +++
 drivers/staging/brcm80211/brcmsmac/dma.c           |   12 +++------
 drivers/staging/brcm80211/brcmsmac/dma.h           |    5 ----
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |   11 +--------
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |    3 ++
 drivers/staging/brcm80211/brcmsmac/main.c          |   17 +------------
 drivers/staging/brcm80211/brcmsmac/main.h          |    6 ++++
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   13 ++++------
 drivers/staging/brcm80211/brcmsmac/nicpci.h        |    2 +
 drivers/staging/brcm80211/brcmsmac/otp.c           |   14 ++--------
 drivers/staging/brcm80211/brcmsmac/otp.h           |    2 +
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   23 +++++++-----------
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |    6 +---
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |    6 +---
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |   21 ++++------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h   |    2 +
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   22 +++++++----------
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c |    2 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.h |    2 +
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |    6 +---
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.h    |    3 ++
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |    7 +----
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |    3 ++
 drivers/staging/brcm80211/brcmsmac/phy_shim.c      |   24 ++----------------
 drivers/staging/brcm80211/brcmsmac/phy_shim.h      |    2 +
 drivers/staging/brcm80211/brcmsmac/pmu.c           |    6 +---
 drivers/staging/brcm80211/brcmsmac/pmu.h           |    5 +---
 drivers/staging/brcm80211/brcmsmac/pub.h           |    5 ++-
 drivers/staging/brcm80211/brcmsmac/rate.c          |    8 +-----
 drivers/staging/brcm80211/brcmsmac/rate.h          |    2 +
 drivers/staging/brcm80211/brcmsmac/scb.h           |    4 ++-
 drivers/staging/brcm80211/brcmsmac/srom.c          |   17 +++++--------
 drivers/staging/brcm80211/brcmsmac/srom.h          |    2 +
 drivers/staging/brcm80211/brcmsmac/stf.c           |   12 +--------
 drivers/staging/brcm80211/brcmsmac/stf.h           |    2 +
 drivers/staging/brcm80211/brcmsmac/types.h         |    6 ++++
 drivers/staging/brcm80211/brcmsmac/ucode_loader.c  |    2 +-
 drivers/staging/brcm80211/brcmutil/utils.c         |   10 --------
 drivers/staging/brcm80211/brcmutil/wifi.c          |    5 ----
 drivers/staging/brcm80211/include/brcmu_utils.h    |    2 +
 drivers/staging/brcm80211/include/defs.h           |    2 +
 48 files changed, 136 insertions(+), 279 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index fee8966..4b908f7 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -13,26 +13,19 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-
 #include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <defs.h>
-#include "types.h"
-#include <linux/module.h>
 #include <linux/pci.h>
-#include <brcmu_utils.h>
-#include <aiutils.h>
-#include <soc.h>
+
+#include <defs.h>
 #include <chipcommon.h>
+#include <brcmu_utils.h>
 #include <brcm_hw_ids.h>
-
-/* ********** from siutils.c *********** */
-#include <nicpci.h>
+#include "types.h"
+#include "pub.h"
+#include "pmu.h"
 #include "srom.h"
-#include <pmu.h>
-#include <scb.h>
-#include <pub.h>
+#include "nicpci.h"
+#include "aiutils.h"
 
 /* slow_clk_ctl */
 #define SCC_SS_MASK		0x00000007	/* slow clock source mask */
diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index a884ae4..486cd49 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -13,23 +13,12 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <linux/kernel.h>
-#include <linux/types.h>
 
-#include <defs.h>
 #include <brcmu_utils.h>
-#include <aiutils.h>
-#include "dma.h"
-
-#include "d11.h"
 #include "types.h"
-#include "scb.h"
 #include "pub.h"
-#include "alloc.h"
-#include "rate.h"
-#include "phy/phy_hal.h"
-#include "channel.h"
 #include "main.h"
+#include "alloc.h"
 
 static struct wlc_bsscfg *wlc_bsscfg_malloc(uint unit);
 static void wlc_bsscfg_mfree(struct wlc_bsscfg *cfg);
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 7cf0018..17552f2 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -13,22 +13,12 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <linux/kernel.h>
 #include <net/mac80211.h>
 
-#include <defs.h>
-#include <brcmu_utils.h>
-#include <aiutils.h>
-#include "dma.h"
-#include <d11.h>
-
-#include "types.h"
 #include "rate.h"
 #include "scb.h"
-#include "pub.h"
 #include "phy/phy_hal.h"
 #include "antsel.h"
-#include "channel.h"
 #include "main.h"
 #include "ampdu.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index f967c59..5356e2a 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -14,24 +14,13 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-
-#include <defs.h>
-#include <brcmu_utils.h>
-#include <aiutils.h>
-#include <brcm_hw_ids.h>
-#include "dma.h"
-
-#include "d11.h"
-#include "rate.h"
-#include "scb.h"
-#include "pub.h"
-#include "phy/phy_hal.h"
+#include <linux/slab.h>
+#include <net/mac80211.h>
+
+#include "types.h"
 #include "bmac.h"
-#include "channel.h"
 #include "main.h"
+#include "phy_shim.h"
 #include "antsel.h"
 
 #define ANT_SELCFG_AUTO		0x80	/* bit indicates antenna sel AUTO */
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 417cf54..e501e06 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -13,39 +13,20 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-
-
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
+#include <net/mac80211.h>
 
-#include <defs.h>
+#include "types.h"
 #include <brcm_hw_ids.h>
-#include <brcmu_wifi.h>
 #include <aiutils.h>
-#include "srom.h"
-#include "otp.h"
-#include <brcmu_utils.h>
 #include <chipcommon.h>
-#include <nicpci.h>
-#include "dma.h"
-
-#include "types.h"
-#include "pmu.h"
-#include "d11.h"
 #include "rate.h"
-#include "scb.h"
-#include "pub.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
 #include "ucode_loader.h"
-#include "antsel.h"
-#include "alloc.h"
-#include "bmac.h"
 #include "mac80211_if.h"
+#include "bmac.h"
 
 #define	TIMER_INTERVAL_WATCHDOG_BMAC	1000	/* watchdog timer, in unit of ms */
 
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.h b/drivers/staging/brcm80211/brcmsmac/bmac.h
index de8b809..58d9830 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.h
@@ -16,6 +16,9 @@
 #ifndef _BRCM_BOTTOM_MAC_H_
 #define _BRCM_BOTTOM_MAC_H_
 
+#include <brcmu_wifi.h>
+#include "types.h"
+
 /* dup state between BMAC(struct wlc_hw_info) and HIGH(struct wlc_info)
    driver */
 struct wlc_bmac_state {
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 9583140..011c490 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -14,26 +14,16 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/module.h>
-#include <linux/pci.h>
+#include <net/mac80211.h>
 
 #include <defs.h>
-#include <brcmu_utils.h>
-#include <aiutils.h>
-#include "dma.h"
-
-#include "types.h"
-#include "d11.h"
-#include "scb.h"
 #include "pub.h"
 #include "phy/phy_hal.h"
 #include "bmac.h"
-#include "rate.h"
-#include "channel.h"
 #include "main.h"
 #include "stf.h"
+#include "channel.h"
 
 #define	VALID_CHANNEL20_DB(wlc, val) wlc_valid_channel20_db((wlc)->cmi, val)
 #define	VALID_CHANNEL20_IN_BAND(wlc, bandunit, val) \
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 1b03039..44f4bc0 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -19,6 +19,10 @@
 
 #include <linux/ieee80211.h>
 
+#include <defs.h>
+#include "pub.h"
+#include "dma.h"
+
 #define	BCN_TMPL_LEN		512	/* length of the BCN template area */
 
 /* RX FIFO numbers */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index ce02324..642c9921 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -13,17 +13,13 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/delay.h>
 #include <linux/pci.h>
-#include <defs.h>
-#include <brcm_hw_ids.h>
-#include <soc.h>
+
 #include <brcmu_utils.h>
 #include <aiutils.h>
-
 #include "types.h"
 #include "dma.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 20991f0..ae411a5 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -19,11 +19,6 @@
 
 #include "types.h"		/* forward structure declarations */
 
-#ifndef _dma_pub_
-#define _dma_pub_
-struct dma_pub;
-#endif				/* _dma_pub_ */
-
 /* DMA structure:
  *  support two DMA engines: 32 bits address or 64 bit addressing
  *  basic DMA register set is per channel(transmit or receive)
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 78f8348..ecad659 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -16,24 +16,15 @@
 
 #define __UNDEF_NO_VERSION__
 
-#include <linux/kernel.h>
 #include <linux/etherdevice.h>
-#include <linux/types.h>
-#include <linux/pci_ids.h>
-#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/firmware.h>
 #include <net/mac80211.h>
 #include <defs.h>
-#include <brcmu_wifi.h>
-#include <brcmu_utils.h>
-#include <nicpci.h>
-#include "dma.h"
-
+#include "nicpci.h"
 #include "phy/phy_int.h"
 #include "d11.h"
-#include "types.h"
 #include "channel.h"
 #include "scb.h"
 #include "pub.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index c56707a..6227455 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -17,6 +17,9 @@
 #ifndef _BRCM_MAC80211_IF_H_
 #define _BRCM_MAC80211_IF_H_
 
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+
 /* softmac ioctl definitions */
 #define WLC_SET_SHORTSLOT_OVERRIDE		146
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 3613900..c8d6679 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -13,36 +13,23 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <linux/kernel.h>
-#include <linux/ctype.h>
-#include <linux/etherdevice.h>
+
 #include <linux/pci_ids.h>
 #include <net/mac80211.h>
 
-#include <defs.h>
 #include <brcm_hw_ids.h>
-#include <brcmu_utils.h>
-#include <brcmu_wifi.h>
 #include <aiutils.h>
-#include "srom.h"
-#include "dma.h"
-
-#include "pmu.h"
-#include "d11.h"
-#include "types.h"
 #include "rate.h"
 #include "scb.h"
-#include "pub.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
-#include "main.h"
 #include "bmac.h"
-#include "phy_hal.h"
 #include "antsel.h"
 #include "stf.h"
 #include "ampdu.h"
 #include "alloc.h"
 #include "mac80211_if.h"
+#include "main.h"
 
 /*
  * WPA(2) definitions
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 0065a40..1d28b76 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -17,6 +17,12 @@
 #ifndef _BRCM_MAIN_H_
 #define _BRCM_MAIN_H_
 
+#include <linux/etherdevice.h>
+
+#include <brcmu_utils.h>
+#include "types.h"
+#include "d11.h"
+
 #define MA_WINDOW_SZ		8	/* moving average window size */
 #define	WL_HWRXOFF		38	/* chip rx buffer offset */
 #define	INVCHANNEL		255	/* invalid channel */
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index ca781c4..5a19182 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -14,19 +14,16 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/slab.h>
 #include <linux/delay.h>
-#include <linux/string.h>
 #include <linux/pci.h>
+
 #include <defs.h>
-#include "types.h"
-#include <brcmu_utils.h>
-#include <aiutils.h>
 #include <soc.h>
-#include <brcm_hw_ids.h>
 #include <chipcommon.h>
-#include <scb.h>
-#include <pub.h>
-#include <nicpci.h>
+#include "aiutils.h"
+#include "pub.h"
+#include "nicpci.h"
 
 /* SPROM offsets */
 #define SRSH_ASPM_OFFSET		4	/* word 4 */
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index c44b705..826c162 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -17,6 +17,8 @@
 #ifndef	_BRCM_NICPCI_H_
 #define	_BRCM_NICPCI_H_
 
+#include "types.h"
+
 /* PCI configuration address space size */
 #define PCI_SZPCR		256
 
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index d21d6ca..d09f913 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -14,19 +14,11 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/delay.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/crc-ccitt.h>
-
-#include <defs.h>
+#include <linux/io.h>
+#include <linux/errno.h>
+
 #include <brcm_hw_ids.h>
-#include "types.h"
-#include <brcmu_utils.h>
-#include <aiutils.h>
-#include <soc.h>
+#include "aiutils.h"
 #include <chipcommon.h>
 #include "otp.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.h b/drivers/staging/brcm80211/brcmsmac/otp.h
index c1eb347..f6d3a56 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.h
+++ b/drivers/staging/brcm80211/brcmsmac/otp.h
@@ -17,6 +17,8 @@
 #ifndef	_BRCM_OTP_H_
 #define	_BRCM_OTP_H_
 
+#include "types.h"
+
 /* OTP regions */
 #define OTP_HW_RGN	1
 #define OTP_SW_RGN	2
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 0185788..79008a9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -14,23 +14,18 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/bitops.h>
 #include <linux/delay.h>
-#include <linux/module.h>
-#include <linux/pci.h>
 
-#include <defs.h>
-#include <chipcommon.h>
 #include <brcm_hw_ids.h>
-#include <dma.h>
-
-#include <types.h>
-#include <phy_int.h>
-#include <phyreg_n.h>
-#include <phy_radio.h>
-#include <phy_lcn.h>
+#include <chipcommon.h>
+#include <aiutils.h>
+#include <d11.h>
+#include <phy_shim.h>
+#include "phy_hal.h"
+#include "phy_int.h"
+#include "phy_radio.h"
+#include "phy_lcn.h"
+#include "phyreg_n.h"
 
 u32 phyhal_msg_level = PHYHAL_ERROR;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 587a545..db99440 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -21,11 +21,9 @@
 #ifndef _BRCM_PHY_HAL_H_
 #define _BRCM_PHY_HAL_H_
 
-#include <aiutils.h>
-#include <d11.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
 #include <phy_shim.h>
-#include <net/mac80211.h>	/* struct wiphy */
-#include "brcmu_wifi.h"		/* chanspec_t */
 
 #define	IDCODE_VER_MASK		0x0000000f
 #define	IDCODE_VER_SHIFT	0
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 48149a7..1e6885c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -17,11 +17,9 @@
 #ifndef _BRCM_PHY_INT_H_
 #define _BRCM_PHY_INT_H_
 
-#include <linux/kernel.h>
-#include <defs.h>
+#include <types.h>
 #include <brcmu_utils.h>
-
-#include <phy_hal.h>
+#include <brcmu_wifi.h>
 
 #define	PHY_VERSION			{ 1, 82, 8, 0 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 84d50c2..efa985c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -14,25 +14,16 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/bitops.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
-#include <brcmu_utils.h>
-#include <aiutils.h>
-#include <pmu.h>
-#include <scb.h>
-#include <pub.h>
-
-#include <brcm_hw_ids.h>
-#include <dma.h>
 
-#include "phy_radio.h"
-#include "phy_int.h"
+#include <pmu.h>
+#include <d11.h>
+#include <phy_shim.h>
 #include "phy_qmath.h"
-#include "phy_lcn.h"
+#include "phy_hal.h"
+#include "phy_radio.h"
 #include "phytbl_lcn.h"
+#include "phy_lcn.h"
 
 #define PLL_2064_NDIV		90
 #define PLL_2064_LOW_END_VCO 	3000
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
index efa8c90..d360714 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
@@ -17,6 +17,8 @@
 #ifndef _BRCM_PHY_LCN_H_
 #define _BRCM_PHY_LCN_H_
 
+#include <types.h>
+
 struct phy_info_lcnphy {
 	int lcnphy_txrf_sp_9_override;
 	u8 lcnphy_full_cal_channel;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index e10f98d..bc5da60 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14,23 +14,19 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <defs.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
+
+#include <brcm_hw_ids.h>
 #include <aiutils.h>
 #include <chipcommon.h>
 #include <pmu.h>
-
-#include <brcm_hw_ids.h>
-#include <dma.h>
-
-#include <types.h>
-#include <phy_radio.h>
-#include <phy_int.h>
-#include <phyreg_n.h>
-#include <phytbl_n.h>
+#include <d11.h>
+#include <phy_shim.h>
+#include "phy_int.h"
+#include "phy_hal.h"
+#include "phy_radio.h"
+#include "phyreg_n.h"
+#include "phytbl_n.h"
 
 #define	READ_RADIO_REG2(pi, radio_type, jspace, core, reg_name) \
 	read_radio_reg(pi, radio_type##_##jspace##_##reg_name | \
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
index 801c7c0..01ff0c8 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/types.h>
-
 #include "phy_qmath.h"
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.h
index 49f57f4..20e3783 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.h
@@ -17,6 +17,8 @@
 #ifndef _BRCM_QMATH_H_
 #define _BRCM_QMATH_H_
 
+#include <types.h>
+
 u16 qm_mulu16(u16 op1, u16 op2);
 
 s16 qm_muls16(s16 op1, s16 op2);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 4dcc691..6439d81 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -14,10 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/types.h>
-#include <dma.h>
-#include <phy_int.h>
-#include <phytbl_lcn.h>
+#include <types.h>
+#include "phytbl_lcn.h"
 
 const u32 dot11lcn_gain_tbl_rev0[] = {
 	0x00000000,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
index 97cab33..96f5a68 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
@@ -14,6 +14,9 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <types.h>
+#include "phy_int.h"
+
 extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_rev0[];
 extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev0;
 extern const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
index 1dd613a..84b4f69 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
@@ -14,11 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-
-#include <dma.h>
-#include <phy_int.h>
-#include <phytbl_n.h>
+#include <types.h>
+#include "phytbl_n.h"
 
 const u32 frame_struct_rev0[] = {
 	0x08004a04,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
index 5033c9f..a02b73c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
@@ -16,6 +16,9 @@
 
 #define ANT_SWCTRL_TBL_REV3_IDX (0)
 
+#include <types.h>
+#include "phy_int.h"
+
 extern const mimophytbl_info_t mimophytbl_info_rev0[],
     mimophytbl_info_rev0_volatile[];
 extern const u32 mimophytbl_info_sz_rev0, mimophytbl_info_sz_rev0_volatile;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index d497573..3fa2cfb 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -20,31 +20,13 @@
  *   On the PHY->WL driver direction, all calls go through this layer since PHY doesn't have the
  *   access to wlc_hw pointer.
  */
+#include <linux/slab.h>
+#include <net/mac80211.h>
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include <defs.h>
-#include <brcmu_utils.h>
-#include <brcmu_wifi.h>
-#include <aiutils.h>
-#include <chipcommon.h>
-#include "dma.h"
-#include <pmu.h>
-
-#include "types.h"
-#include "d11.h"
-#include "rate.h"
-#include "scb.h"
-#include "pub.h"
-#include "phy/phy_hal.h"
-#include "channel.h"
-#include "srom.h"
 #include "bmac.h"
-#include "phy_hal.h"
 #include "main.h"
-#include "phy_shim.h"
 #include "mac80211_if.h"
+#include "phy_shim.h"
 
 /* PHY SHIM module specific state */
 struct wlc_phy_shim_info {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index dddae81..4e1a51d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -21,6 +21,8 @@
 #ifndef _BRCM_PHY_SHIM_H_
 #define _BRCM_PHY_SHIM_H_
 
+#include "types.h"
+
 #define RADAR_TYPE_NONE		0	/* Radar type None */
 #define RADAR_TYPE_ETSI_1	1	/* ETSI 1 Radar type */
 #define RADAR_TYPE_ETSI_2	2	/* ETSI 2 Radar type */
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index b822d40..0b7ab82 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -13,17 +13,15 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <linux/kernel.h>
-#include <linux/types.h>
+
 #include <linux/delay.h>
 #include <linux/io.h>
 
 #include <brcm_hw_ids.h>
-#include "types.h"
 #include <chipcommon.h>
 #include <brcmu_utils.h>
-#include "scb.h"
 #include "pub.h"
+#include "aiutils.h"
 #include "pmu.h"
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.h b/drivers/staging/brcm80211/brcmsmac/pmu.h
index eff8d5b..9a98890 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.h
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.h
@@ -18,10 +18,7 @@
 #ifndef _BRCM_PMU_H_
 #define _BRCM_PMU_H_
 
-#include <linux/types.h>
-
-#include <aiutils.h>
-
+#include "types.h"
 /*
  * LDO selections used in si_pmu_set_ldo_voltage
  */
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 3c10a02..cdb4cc6 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -17,8 +17,9 @@
 #ifndef _BRCM_PUB_H_
 #define _BRCM_PUB_H_
 
-#include "types.h"		/* forward structure declarations */
-#include "brcmu_wifi.h"		/* for chanspec_t */
+#include <brcmu_wifi.h>
+#include "types.h"
+#include "defs.h"
 
 #define	WLC_NUMRATES	16	/* max # of rates in a rateset */
 #define	MAXMULTILIST	32	/* max # multicast addresses */
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index 5162ec2..f19b512 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -13,17 +13,11 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <linux/kernel.h>
-#include <linux/module.h>
 
-#include <defs.h>
+#include <brcmu_wifi.h>
 #include <brcmu_utils.h>
-#include <aiutils.h>
-#include "dma.h"
 
-#include "types.h"
 #include "d11.h"
-#include "scb.h"
 #include "pub.h"
 #include "rate.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 421f04d..36cb91b 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -17,6 +17,8 @@
 #ifndef _WLC_RATE_H_
 #define _WLC_RATE_H_
 
+#include "types.h"
+
 extern const u8 rate_info[];
 extern const struct wlc_rateset cck_ofdm_mimo_rates;
 extern const struct wlc_rateset ofdm_mimo_rates;
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index 2e3b5f4..fa5c0b3 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -17,8 +17,10 @@
 #ifndef _BRCM_SCB_H_
 #define _BRCM_SCB_H_
 
-#include <linux/if_ether.h>	/* for ETH_ALEN */
+#include <linux/if_ether.h>
+#include <brcmu_utils.h>
 #include <defs.h>
+#include "types.h"
 
 #define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
 /* structure to store per-tid state for the ampdu initiator */
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 17e0f2a..8aa6d01 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -13,22 +13,19 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
+
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/io.h>
 #include <linux/etherdevice.h>
-#include <defs.h>
-#include <linux/module.h>
-#include <linux/pci.h>
 #include <stdarg.h>
-#include "types.h"
-#include <brcmu_utils.h>
-#include <soc.h>
+
 #include <chipcommon.h>
-#include <brcm_hw_ids.h>
-#include <nicpci.h>
-#include <aiutils.h>
-#include "srom.h"
+#include <brcmu_utils.h>
+#include "nicpci.h"
+#include "aiutils.h"
 #include "otp.h"
+#include "srom.h"
 
 #define SROM_OFFSET(sih) ((sih->ccrev > 31) ? \
 	(((sih->cccaps & CC_CAP_SROM) == 0) ? NULL : \
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.h b/drivers/staging/brcm80211/brcmsmac/srom.h
index ee4f880..efc4d1e 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.h
+++ b/drivers/staging/brcm80211/brcmsmac/srom.h
@@ -17,6 +17,8 @@
 #ifndef	_BRCM_SROM_H_
 #define	_BRCM_SROM_H_
 
+#include "types.h"
+
 /* Prototypes */
 extern int srom_var_init(struct si_pub *sih, uint bus, void *curmap,
 			 char **vars, uint *count);
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 5f98804..625252a 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -14,20 +14,12 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-
-#include <defs.h>
-#include <brcmu_utils.h>
-#include <aiutils.h>
-#include <brcmu_wifi.h>
-#include "dma.h"
+#include <net/mac80211.h>
 
 #include "types.h"
+
 #include "d11.h"
 #include "rate.h"
-#include "scb.h"
-#include "pub.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.h b/drivers/staging/brcm80211/brcmsmac/stf.h
index 75e8205..0b48f4d 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.h
+++ b/drivers/staging/brcm80211/brcmsmac/stf.h
@@ -17,6 +17,8 @@
 #ifndef _BRCM_STF_H_
 #define _BRCM_STF_H_
 
+#include "types.h"
+
 extern int wlc_stf_attach(struct wlc_info *wlc);
 extern void wlc_stf_detach(struct wlc_info *wlc);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index dd0bcf9..1619e6a 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -17,6 +17,8 @@
 #ifndef _BRCM_TYPES_H_
 #define _BRCM_TYPES_H_
 
+#include <linux/types.h>
+
 /* Bus types */
 #define	SI_BUS			0	/* SOC Interconnect */
 #define	PCI_BUS			1	/* PCI target */
@@ -365,6 +367,10 @@ struct dma_pub;
 struct wlc_bsscfg;
 struct brcmu_strbuf;
 struct si_pub;
+struct wiphy;
+struct brcmu_iovar;
+struct wlc_txq_info;
+struct wlcband;
 
 typedef struct gpioh_item gpioh_item_t;
 typedef struct si_info si_info_t;
diff --git a/drivers/staging/brcm80211/brcmsmac/ucode_loader.c b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
index 32d5196..bf733fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/types.h>
 #include <defs.h>
+#include "types.h"
 #include <ucode_loader.h>
 
 enum {
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index ab11c4b..2819c1d 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -14,18 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/ctype.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/netdevice.h>
-#include <linux/sched.h>
-#include <linux/printk.h>
-#include <defs.h>
-#include <stdarg.h>
 #include <brcmu_utils.h>
-#include <brcm_hw_ids.h>
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver utilities.");
diff --git a/drivers/staging/brcm80211/brcmutil/wifi.c b/drivers/staging/brcm80211/brcmutil/wifi.c
index bacf345..af88dcb 100644
--- a/drivers/staging/brcm80211/brcmutil/wifi.c
+++ b/drivers/staging/brcm80211/brcmutil/wifi.c
@@ -13,11 +13,6 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <linux/ctype.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <defs.h>
-#include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
 /*
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index e3308e8..863b3c7 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -17,6 +17,8 @@
 #ifndef	_BRCMU_UTILS_H_
 #define	_BRCMU_UTILS_H_
 
+#include <linux/skbuff.h>
+
 /* Buffer structure for collecting string-formatted data
 * using brcmu_bprintf() API.
 * Use brcmu_binit() to initialize before use
diff --git a/drivers/staging/brcm80211/include/defs.h b/drivers/staging/brcm80211/include/defs.h
index 768df8d..20e1407 100644
--- a/drivers/staging/brcm80211/include/defs.h
+++ b/drivers/staging/brcm80211/include/defs.h
@@ -17,6 +17,8 @@
 #ifndef	_BRCM_DEFS_H_
 #define	_BRCM_DEFS_H_
 
+#include <linux/types.h>
+
 #define	SI_BUS			0
 #define	PCI_BUS			1
 #define	PCMCIA_BUS		2
-- 
1.7.4.1


