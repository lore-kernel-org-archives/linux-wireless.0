Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 09/11] ath9k: clarify what hw code is and remove ath9k.h from a few files
Date: Mon, 14 Sep 2009 04:37:26 -0400
Message-Id: <1252917448-10744-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw code will be shared between ath9k and ath9k_htc.
Just a few more files are left to clean up, mark them as well.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile      |   14 +++++++++-----
 drivers/net/wireless/ath/ath9k/ani.c         |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h       |    1 -
 drivers/net/wireless/ath/ath9k/btcoex.c      |    2 +-
 drivers/net/wireless/ath/ath9k/calib.c       |    1 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    1 -
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    1 -
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |    1 -
 drivers/net/wireless/ath/ath9k/hw.c          |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h          |    2 ++
 drivers/net/wireless/ath/ath9k/mac.c         |    1 -
 drivers/net/wireless/ath/ath9k/phy.c         |    2 +-
 12 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index ff2c9a2..f85dc82 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -1,19 +1,23 @@
-ath9k-y +=	hw.o \
-		eeprom.o \
+ATH9K_HW_FIX +=	eeprom.o \
+		mac.o \
+
+ATH9K_HW +=	hw.o \
 		eeprom_def.o \
 		eeprom_4k.o \
 		eeprom_9287.o \
-		mac.o \
 		calib.o \
 		ani.o \
 		phy.o \
+		btcoex.o
+
+ath9k-y +=	$(ATH9K_HW) \
+		$(ATH9K_HW_FIX) \
 		beacon.o \
 		main.o \
 		recv.o \
 		xmit.o \
 		virtual.o \
-		rc.o \
-		btcoex.o
+		rc.o
 
 ath9k-$(CONFIG_PCI) += pci.o
 ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index bb0a6d9..ecb23f3 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
+#include "hw.h"
 
 static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 					struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e512d51..9aff11d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -499,7 +499,6 @@ struct ath_led {
  * Used when PCI device not fully initialized by bootrom/BIOS
 */
 #define DEFAULT_CACHELINE       32
-#define	ATH_DEFAULT_NOISE_FLOOR -95
 #define ATH_REGCLASSIDS_MAX     10
 #define ATH_CABQ_READY_TIME     80      /* % of beacon interval */
 #define ATH_MAX_SW_RETRIES      10
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 5d1095f..0c54489 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
+#include "hw.h"
 
 enum ath_bt_mode {
 	ATH_BT_COEX_MODE_LEGACY,        /* legacy rx_clear mode */
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index ce0b759..aa66242 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -14,7 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
 #include "hw.h"
 
 /* We can tune this as we go by monitoring really low values */
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 079dd20..c2ac85c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -14,7 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
 #include "hw.h"
 
 static int ath9k_hw_4k_get_eeprom_ver(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 6ffe85d..839eed8 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -14,7 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
 #include "hw.h"
 
 static int ath9k_hw_AR9287_get_eeprom_ver(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 567d939..50d733c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -14,7 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
 #include "hw.h"
 
 static void ath9k_get_txgain_index(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f993631..1ac9c16 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -18,7 +18,7 @@
 #include <asm/unaligned.h>
 
 #include "hw.h"
-#include "ath9k.h"
+#include "rc.h"
 #include "initvals.h"
 
 #define ATH9K_CLOCK_RATE_CCK		22
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 047b5b8..df1920c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -53,6 +53,8 @@
 
 #define ATH_AMPDU_LIMIT_MAX        (64 * 1024 - 1)
 
+#define	ATH_DEFAULT_NOISE_FLOOR -95
+
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
 	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 926f201..1796ac7 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -15,7 +15,6 @@
  */
 
 #include "ath9k.h"
-#include "hw.h"
 
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index b263025..eec4f10 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
+#include "hw.h"
 
 void
 ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex, u32 freqIndex,
-- 
1.6.3.3

