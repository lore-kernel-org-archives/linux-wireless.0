Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55690 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab0BSB2t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 20:28:49 -0500
Subject: [PATCH 3/3] ath5k: move ath5k_hw_register_timeout() into reset.c
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 18 Feb 2010 20:28:41 -0500
Message-ID: <20100219012841.12460.64125.stgit@mj.roinet.com>
In-Reply-To: <20100219012802.12460.42239.stgit@mj.roinet.com>
References: <20100219012802.12460.42239.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_hw_register_timeout() was duplicated between phy.c and reset.c.
Since it is too big and too much used to be an inline function, move it
away from the ath5k.h header into reset.c.  Remove _ATH5K_RESET and
_ATH5K_PHY defines.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   25 ++-----------------------
 drivers/net/wireless/ath/ath5k/phy.c   |    4 ----
 drivers/net/wireless/ath/ath5k/reset.c |   25 +++++++++++++++++++++----
 3 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index f4e50ef..4de7fe0 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1172,6 +1172,8 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial);
 int ath5k_hw_on_hold(struct ath5k_hw *ah);
 int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		   struct ieee80211_channel *channel, bool change_channel);
+int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
+			      bool is_set);
 /* Power management functions */
 
 /* DMA Related Functions */
@@ -1328,29 +1330,6 @@ static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 	iowrite32(val, ah->ah_iobase + reg);
 }
 
-#if defined(_ATH5K_RESET) || defined(_ATH5K_PHY)
-/*
- * Check if a register write has been completed
- */
-static int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag,
-		u32 val, bool is_set)
-{
-	int i;
-	u32 data;
-
-	for (i = AR5K_TUNE_REGISTER_TIMEOUT; i > 0; i--) {
-		data = ath5k_hw_reg_read(ah, reg);
-		if (is_set && (data & flag))
-			break;
-		else if ((data & flag) == val)
-			break;
-		udelay(15);
-	}
-
-	return (i <= 0) ? -EAGAIN : 0;
-}
-#endif
-
 static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
 {
 	u32 retval = 0, bit, i;
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index ac2a57a..10ad877 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -20,8 +20,6 @@
  *
  */
 
-#define _ATH5K_PHY
-
 #include <linux/delay.h>
 
 #include "ath5k.h"
@@ -3144,5 +3142,3 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 
 	return ath5k_hw_txpower(ah, channel, ee_mode, txpower);
 }
-
-#undef _ATH5K_PHY
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 8decf21..8bd62c1 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -19,8 +19,6 @@
  *
  */
 
-#define _ATH5K_RESET
-
 /*****************************\
   Reset functions and helpers
 \*****************************/
@@ -34,6 +32,27 @@
 #include "base.h"
 #include "debug.h"
 
+/*
+ * Check if a register write has been completed
+ */
+int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
+			      bool is_set)
+{
+	int i;
+	u32 data;
+
+	for (i = AR5K_TUNE_REGISTER_TIMEOUT; i > 0; i--) {
+		data = ath5k_hw_reg_read(ah, reg);
+		if (is_set && (data & flag))
+			break;
+		else if ((data & flag) == val)
+			break;
+		udelay(15);
+	}
+
+	return (i <= 0) ? -EAGAIN : 0;
+}
+
 /**
  * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
  *
@@ -1386,5 +1405,3 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 	return 0;
 }
-
-#undef _ATH5K_RESET
