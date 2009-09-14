Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 10/11] ath9k: move ATH9K_RSSI_BAD to hw.h
Date: Mon, 14 Sep 2009 04:37:27 -0400
Message-Id: <1252917448-10744-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac.c is now core driver independent.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile |    7 +++----
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/hw.h     |    2 ++
 drivers/net/wireless/ath/ath9k/mac.c    |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index f85dc82..2f21c67 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -1,6 +1,4 @@
-ATH9K_HW_FIX +=	eeprom.o \
-		mac.o \
-
+ATH9K_HW_FIX +=	eeprom.o
 ATH9K_HW +=	hw.o \
 		eeprom_def.o \
 		eeprom_4k.o \
@@ -8,7 +6,8 @@ ATH9K_HW +=	hw.o \
 		calib.o \
 		ani.o \
 		phy.o \
-		btcoex.o
+		btcoex.o \
+		mac.o \
 
 ath9k-y +=	$(ATH9K_HW) \
 		$(ATH9K_HW_FIX) \
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9aff11d..8768e60 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -288,7 +288,6 @@ struct ath_tx_control {
 
 #define ATH_RSSI_LPF_LEN 		10
 #define RSSI_LPF_THRESHOLD		-20
-#define ATH9K_RSSI_BAD			0x80
 #define ATH_RSSI_EP_MULTIPLIER     (1<<7)
 #define ATH_EP_MUL(x, mul)         ((x) * (mul))
 #define ATH_RSSI_IN(x)             (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index df1920c..be9763e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -55,6 +55,8 @@
 
 #define	ATH_DEFAULT_NOISE_FLOOR -95
 
+#define ATH9K_RSSI_BAD			0x80
+
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
 	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 1796ac7..3be658d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
+#include "hw.h"
 
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
-- 
1.6.3.3

