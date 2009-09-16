Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZIPCzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 22:55:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	zhifeng.cai@atheros.com, Stephen.Chen@atheros.com,
	kevin@atheros.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 1/3] Move common hw code between ath9k and ath9k_htc to ath
Date: Tue, 15 Sep 2009 22:55:52 -0400
Message-Id: <1253069754-7470-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
References: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k and ath9k_htc share a lot of common hw code.
Instead of linking the common hw code twice for two
modules use a module and export the shared hw routines.

There's a few read/write ops left on pci.c and debug.c,
we'll either leave these as is or define a common debug
interface for them.

Results: 37 non-static symbols, with 129 exported symbols.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/Makefile                  |   13 +-
 drivers/net/wireless/ath/{ath9k => }/ani.c         |    2 +
 drivers/net/wireless/ath/{ath9k => }/ani.h         |    0
 drivers/net/wireless/ath/ath9k/Makefile            |   14 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    8 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   21 +-
 drivers/net/wireless/ath/ath9k/debug.h             |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                | 4218 -------------------
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    4 +-
 drivers/net/wireless/ath/ath9k/reg.h               | 1706 --------
 drivers/net/wireless/ath/{ath9k => }/btcoex.c      |    6 +
 drivers/net/wireless/ath/{ath9k => }/btcoex.h      |    0
 drivers/net/wireless/ath/{ath9k => }/calib.c       |    3 +
 drivers/net/wireless/ath/{ath9k => }/calib.h       |    0
 drivers/net/wireless/ath/{ath9k => }/eeprom.c      |    0
 drivers/net/wireless/ath/{ath9k => }/eeprom.h      |    2 +-
 drivers/net/wireless/ath/{ath9k => }/eeprom_4k.c   |    0
 drivers/net/wireless/ath/{ath9k => }/eeprom_9287.c |    0
 drivers/net/wireless/ath/{ath9k => }/eeprom_def.c  |    0
 drivers/net/wireless/ath/hw.c                      | 4252 +++++++++++++++++++-
 drivers/net/wireless/ath/{ath9k => }/hw.h          |   35 +-
 drivers/net/wireless/ath/{ath9k => }/initvals.h    |    0
 drivers/net/wireless/ath/{ath9k => }/mac.c         |   30 +
 drivers/net/wireless/ath/{ath9k => }/mac.h         |    0
 drivers/net/wireless/ath/{ath9k => }/phy.c         |    0
 drivers/net/wireless/ath/{ath9k => }/phy.h         |    0
 drivers/net/wireless/ath/{ath9k => }/rc.h          |    0
 drivers/net/wireless/ath/reg.h                     | 1688 ++++++++-
 29 files changed, 6035 insertions(+), 5971 deletions(-)
 rename drivers/net/wireless/ath/{ath9k => }/ani.c (99%)
 rename drivers/net/wireless/ath/{ath9k => }/ani.h (100%)
 delete mode 100644 drivers/net/wireless/ath/ath9k/hw.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/reg.h
 rename drivers/net/wireless/ath/{ath9k => }/btcoex.c (96%)
 rename drivers/net/wireless/ath/{ath9k => }/btcoex.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/calib.c (99%)
 rename drivers/net/wireless/ath/{ath9k => }/calib.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom.h (99%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom_4k.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom_9287.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/eeprom_def.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/hw.h (95%)
 rename drivers/net/wireless/ath/{ath9k => }/initvals.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/mac.c (96%)
 rename drivers/net/wireless/ath/{ath9k => }/mac.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/phy.c (100%)
 rename drivers/net/wireless/ath/{ath9k => }/phy.h (100%)
 rename drivers/net/wireless/ath/{ath9k => }/rc.h (100%)

diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 5c8e6b2..2165f95 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -4,8 +4,19 @@ obj-$(CONFIG_AR9170_USB)        += ar9170/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
+ATH_HW +=	hw.o \
+		eeprom.o \
+		eeprom_def.o \
+		eeprom_4k.o \
+		eeprom_9287.o \
+		calib.o \
+		ani.o \
+		phy.o \
+		btcoex.o \
+		mac.o
+
 ath-objs :=	main.o \
 		regd.o \
-		hw.o
+		$(ATH_HW)
 
 ath-$(CONFIG_ATH_DEBUG) += debug.o
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ani.c
similarity index 99%
rename from drivers/net/wireless/ath/ath9k/ani.c
rename to drivers/net/wireless/ath/ani.c
index ecb23f3..2a0cd64 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ani.c
@@ -629,6 +629,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 		}
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_ani_monitor);
 
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
@@ -756,6 +757,7 @@ void ath9k_hw_procmibevent(struct ath_hw *ah)
 		ath9k_ani_restart(ah);
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_procmibevent);
 
 void ath9k_hw_ani_setup(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ani.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/ani.h
rename to drivers/net/wireless/ath/ani.h
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index f3221af..5b38d07 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -1,17 +1,5 @@
-ATH9K_HW +=	hw.o \
-		eeprom.o \
-		eeprom_def.o \
-		eeprom_4k.o \
-		eeprom_9287.o \
-		calib.o \
-		ani.o \
-		phy.o \
-		btcoex.o \
-		mac.o \
-
-ath9k-y +=	$(ATH9K_HW) \
+ath9k-y +=	main.o \
 		beacon.o \
-		main.o \
 		recv.o \
 		xmit.o \
 		virtual.o \
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 14ff38d..431ba71 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -22,11 +22,11 @@
 #include <net/mac80211.h>
 #include <linux/leds.h>
 
-#include "hw.h"
-#include "rc.h"
-#include "debug.h"
-#include "../ath.h"
+#include "../hw.h"
+#include "../rc.h"
 #include "../debug.h"
+#include "../ath.h"
+#include "debug.h"
 
 struct ath_node;
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5dfc0e9..352914c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -18,6 +18,11 @@
 
 #include "ath9k.h"
 
+#define REG_WRITE_D(_ah, _reg, _val) \
+	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
+#define REG_READ_D(_ah, _reg) \
+	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
+
 static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
 
@@ -82,7 +87,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 
 	ath9k_ps_wakeup(sc);
 
-	REG_WRITE(ah, AR_MACMISC,
+	REG_WRITE_D(ah, AR_MACMISC,
 		  ((AR_MACMISC_DMA_OBS_LINE_8 << AR_MACMISC_DMA_OBS_S) |
 		   (AR_MACMISC_MISC_OBS_BUS_1 <<
 		    AR_MACMISC_MISC_OBS_BUS_MSB_S)));
@@ -94,7 +99,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 		if (i % 4 == 0)
 			len += snprintf(buf + len, sizeof(buf) - len, "\n");
 
-		val[i] = REG_READ(ah, AR_DMADBG_0 + (i * sizeof(u32)));
+		val[i] = REG_READ_D(ah, AR_DMADBG_0 + (i * sizeof(u32)));
 		len += snprintf(buf + len, sizeof(buf) - len, "%d: %08x ",
 				i, val[i]);
 	}
@@ -144,9 +149,9 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 		(val[6] & 0x0001e000) >> 13, (val[6] & 0x001e0000) >> 17);
 
 	len += snprintf(buf + len, sizeof(buf) - len, "pcu observe: 0x%x \n",
-			REG_READ(ah, AR_OBS_BUS_1));
+			REG_READ_D(ah, AR_OBS_BUS_1));
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"AR_CR: 0x%x \n", REG_READ(ah, AR_CR));
+			"AR_CR: 0x%x \n", REG_READ_D(ah, AR_CR));
 
 	ath9k_ps_restore(sc);
 
@@ -363,12 +368,12 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 				aphy->chan_idx, aphy->chan_is_ht);
 	}
 
-	put_unaligned_le32(REG_READ(sc->sc_ah, AR_STA_ID0), addr);
-	put_unaligned_le16(REG_READ(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
+	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
+	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"addr: %pM\n", addr);
-	put_unaligned_le32(REG_READ(sc->sc_ah, AR_BSSMSKL), addr);
-	put_unaligned_le16(REG_READ(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
+	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_BSSMSKL), addr);
+	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU) & 0xffff, addr + 4);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"addrmask: %pM\n", addr);
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 749e85d..8ce332f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -17,7 +17,7 @@
 #ifndef DEBUG_H
 #define DEBUG_H
 
-#include "hw.h"
+#include "../hw.h"
 
 struct ath_txq;
 struct ath_buf;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
deleted file mode 100644
index 1ac9c16..0000000
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ /dev/null
@@ -1,4218 +0,0 @@
-/*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/io.h>
-#include <asm/unaligned.h>
-
-#include "hw.h"
-#include "rc.h"
-#include "initvals.h"
-
-#define ATH9K_CLOCK_RATE_CCK		22
-#define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
-#define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
-
-static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
-static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan);
-static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
-			      struct ar5416_eeprom_def *pEepData,
-			      u32 reg, u32 value);
-static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
-static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
-
-/********************/
-/* Helper Functions */
-/********************/
-
-static u32 ath9k_hw_mac_usec(struct ath_hw *ah, u32 clks)
-{
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
-	if (!ah->curchan) /* should really check for CCK instead */
-		return clks / ATH9K_CLOCK_RATE_CCK;
-	if (conf->channel->band == IEEE80211_BAND_2GHZ)
-		return clks / ATH9K_CLOCK_RATE_2GHZ_OFDM;
-
-	return clks / ATH9K_CLOCK_RATE_5GHZ_OFDM;
-}
-
-static u32 ath9k_hw_mac_to_usec(struct ath_hw *ah, u32 clks)
-{
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
-	if (conf_is_ht40(conf))
-		return ath9k_hw_mac_usec(ah, clks) / 2;
-	else
-		return ath9k_hw_mac_usec(ah, clks);
-}
-
-static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
-{
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
-	if (!ah->curchan) /* should really check for CCK instead */
-		return usecs *ATH9K_CLOCK_RATE_CCK;
-	if (conf->channel->band == IEEE80211_BAND_2GHZ)
-		return usecs *ATH9K_CLOCK_RATE_2GHZ_OFDM;
-	return usecs *ATH9K_CLOCK_RATE_5GHZ_OFDM;
-}
-
-static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
-{
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-
-	if (conf_is_ht40(conf))
-		return ath9k_hw_mac_clks(ah, usecs) * 2;
-	else
-		return ath9k_hw_mac_clks(ah, usecs);
-}
-
-bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
-{
-	int i;
-
-	BUG_ON(timeout < AH_TIME_QUANTUM);
-
-	for (i = 0; i < (timeout / AH_TIME_QUANTUM); i++) {
-		if ((REG_READ(ah, reg) & mask) == val)
-			return true;
-
-		udelay(AH_TIME_QUANTUM);
-	}
-
-	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY,
-		  "timeout (%d us) on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
-		  timeout, reg, REG_READ(ah, reg), mask, val);
-
-	return false;
-}
-
-u32 ath9k_hw_reverse_bits(u32 val, u32 n)
-{
-	u32 retval;
-	int i;
-
-	for (i = 0, retval = 0; i < n; i++) {
-		retval = (retval << 1) | (val & 1);
-		val >>= 1;
-	}
-	return retval;
-}
-
-bool ath9k_get_channel_edges(struct ath_hw *ah,
-			     u16 flags, u16 *low,
-			     u16 *high)
-{
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-
-	if (flags & CHANNEL_5GHZ) {
-		*low = pCap->low_5ghz_chan;
-		*high = pCap->high_5ghz_chan;
-		return true;
-	}
-	if ((flags & CHANNEL_2GHZ)) {
-		*low = pCap->low_2ghz_chan;
-		*high = pCap->high_2ghz_chan;
-		return true;
-	}
-	return false;
-}
-
-u16 ath9k_hw_computetxtime(struct ath_hw *ah,
-			   const struct ath_rate_table *rates,
-			   u32 frameLen, u16 rateix,
-			   bool shortPreamble)
-{
-	u32 bitsPerSymbol, numBits, numSymbols, phyTime, txTime;
-	u32 kbps;
-
-	kbps = rates->info[rateix].ratekbps;
-
-	if (kbps == 0)
-		return 0;
-
-	switch (rates->info[rateix].phy) {
-	case WLAN_RC_PHY_CCK:
-		phyTime = CCK_PREAMBLE_BITS + CCK_PLCP_BITS;
-		if (shortPreamble && rates->info[rateix].short_preamble)
-			phyTime >>= 1;
-		numBits = frameLen << 3;
-		txTime = CCK_SIFS_TIME + phyTime + ((numBits * 1000) / kbps);
-		break;
-	case WLAN_RC_PHY_OFDM:
-		if (ah->curchan && IS_CHAN_QUARTER_RATE(ah->curchan)) {
-			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_QUARTER) / 1000;
-			numBits = OFDM_PLCP_BITS + (frameLen << 3);
-			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
-			txTime = OFDM_SIFS_TIME_QUARTER
-				+ OFDM_PREAMBLE_TIME_QUARTER
-				+ (numSymbols * OFDM_SYMBOL_TIME_QUARTER);
-		} else if (ah->curchan &&
-			   IS_CHAN_HALF_RATE(ah->curchan)) {
-			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_HALF) / 1000;
-			numBits = OFDM_PLCP_BITS + (frameLen << 3);
-			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
-			txTime = OFDM_SIFS_TIME_HALF +
-				OFDM_PREAMBLE_TIME_HALF
-				+ (numSymbols * OFDM_SYMBOL_TIME_HALF);
-		} else {
-			bitsPerSymbol = (kbps * OFDM_SYMBOL_TIME) / 1000;
-			numBits = OFDM_PLCP_BITS + (frameLen << 3);
-			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
-			txTime = OFDM_SIFS_TIME + OFDM_PREAMBLE_TIME
-				+ (numSymbols * OFDM_SYMBOL_TIME);
-		}
-		break;
-	default:
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "Unknown phy %u (rate ix %u)\n",
-			  rates->info[rateix].phy, rateix);
-		txTime = 0;
-		break;
-	}
-
-	return txTime;
-}
-
-void ath9k_hw_get_channel_centers(struct ath_hw *ah,
-				  struct ath9k_channel *chan,
-				  struct chan_centers *centers)
-{
-	int8_t extoff;
-
-	if (!IS_CHAN_HT40(chan)) {
-		centers->ctl_center = centers->ext_center =
-			centers->synth_center = chan->channel;
-		return;
-	}
-
-	if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
-	    (chan->chanmode == CHANNEL_G_HT40PLUS)) {
-		centers->synth_center =
-			chan->channel + HT40_CHANNEL_CENTER_SHIFT;
-		extoff = 1;
-	} else {
-		centers->synth_center =
-			chan->channel - HT40_CHANNEL_CENTER_SHIFT;
-		extoff = -1;
-	}
-
-	centers->ctl_center =
-		centers->synth_center - (extoff * HT40_CHANNEL_CENTER_SHIFT);
-	/* 25 MHz spacing is supported by hw but not on upper layers */
-	centers->ext_center =
-		centers->synth_center + (extoff * HT40_CHANNEL_CENTER_SHIFT);
-}
-
-/******************/
-/* Chip Revisions */
-/******************/
-
-static void ath9k_hw_read_revisions(struct ath_hw *ah)
-{
-	u32 val;
-
-	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
-
-	if (val == 0xFF) {
-		val = REG_READ(ah, AR_SREV);
-		ah->hw_version.macVersion =
-			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
-		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
-		ah->is_pciexpress = (val & AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
-	} else {
-		if (!AR_SREV_9100(ah))
-			ah->hw_version.macVersion = MS(val, AR_SREV_VERSION);
-
-		ah->hw_version.macRev = val & AR_SREV_REVISION;
-
-		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE)
-			ah->is_pciexpress = true;
-	}
-}
-
-static int ath9k_hw_get_radiorev(struct ath_hw *ah)
-{
-	u32 val;
-	int i;
-
-	REG_WRITE(ah, AR_PHY(0x36), 0x00007058);
-
-	for (i = 0; i < 8; i++)
-		REG_WRITE(ah, AR_PHY(0x20), 0x00010000);
-	val = (REG_READ(ah, AR_PHY(256)) >> 24) & 0xff;
-	val = ((val & 0xf0) >> 4) | ((val & 0x0f) << 4);
-
-	return ath9k_hw_reverse_bits(val, 8);
-}
-
-/************************************/
-/* HW Attach, Detach, Init Routines */
-/************************************/
-
-static void ath9k_hw_disablepcie(struct ath_hw *ah)
-{
-	if (AR_SREV_9100(ah))
-		return;
-
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x28000029);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x57160824);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x25980579);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x00000000);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
-	REG_WRITE(ah, AR_PCIE_SERDES, 0x000e1007);
-
-	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
-}
-
-static bool ath9k_hw_chip_test(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 regAddr[2] = { AR_STA_ID0, AR_PHY_BASE + (8 << 2) };
-	u32 regHold[2];
-	u32 patternData[4] = { 0x55555555,
-			       0xaaaaaaaa,
-			       0x66666666,
-			       0x99999999 };
-	int i, j;
-
-	for (i = 0; i < 2; i++) {
-		u32 addr = regAddr[i];
-		u32 wrData, rdData;
-
-		regHold[i] = REG_READ(ah, addr);
-		for (j = 0; j < 0x100; j++) {
-			wrData = (j << 16) | j;
-			REG_WRITE(ah, addr, wrData);
-			rdData = REG_READ(ah, addr);
-			if (rdData != wrData) {
-				ath_print(common, ATH_DBG_FATAL,
-					  "address test failed "
-					  "addr: 0x%08x - wr:0x%08x != "
-					  "rd:0x%08x\n",
-					  addr, wrData, rdData);
-				return false;
-			}
-		}
-		for (j = 0; j < 4; j++) {
-			wrData = patternData[j];
-			REG_WRITE(ah, addr, wrData);
-			rdData = REG_READ(ah, addr);
-			if (wrData != rdData) {
-				ath_print(common, ATH_DBG_FATAL,
-					  "address test failed "
-					  "addr: 0x%08x - wr:0x%08x != "
-					  "rd:0x%08x\n",
-					  addr, wrData, rdData);
-				return false;
-			}
-		}
-		REG_WRITE(ah, regAddr[i], regHold[i]);
-	}
-	udelay(100);
-
-	return true;
-}
-
-static const char *ath9k_hw_devname(u16 devid)
-{
-	switch (devid) {
-	case AR5416_DEVID_PCI:
-		return "Atheros 5416";
-	case AR5416_DEVID_PCIE:
-		return "Atheros 5418";
-	case AR9160_DEVID_PCI:
-		return "Atheros 9160";
-	case AR5416_AR9100_DEVID:
-		return "Atheros 9100";
-	case AR9280_DEVID_PCI:
-	case AR9280_DEVID_PCIE:
-		return "Atheros 9280";
-	case AR9285_DEVID_PCIE:
-		return "Atheros 9285";
-	case AR5416_DEVID_AR9287_PCI:
-	case AR5416_DEVID_AR9287_PCIE:
-		return "Atheros 9287";
-	}
-
-	return NULL;
-}
-
-static void ath9k_hw_init_config(struct ath_hw *ah)
-{
-	int i;
-
-	ah->config.dma_beacon_response_time = 2;
-	ah->config.sw_beacon_response_time = 10;
-	ah->config.additional_swba_backoff = 0;
-	ah->config.ack_6mb = 0x0;
-	ah->config.cwm_ignore_extcca = 0;
-	ah->config.pcie_powersave_enable = 0;
-	ah->config.pcie_clock_req = 0;
-	ah->config.pcie_waen = 0;
-	ah->config.analog_shiftreg = 1;
-	ah->config.ht_enable = 1;
-	ah->config.ofdm_trig_low = 200;
-	ah->config.ofdm_trig_high = 500;
-	ah->config.cck_trig_high = 200;
-	ah->config.cck_trig_low = 100;
-	ah->config.enable_ani = 1;
-	ah->config.diversity_control = ATH9K_ANT_VARIABLE;
-	ah->config.antenna_switch_swap = 0;
-
-	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		ah->config.spurchans[i][0] = AR_NO_SPUR;
-		ah->config.spurchans[i][1] = AR_NO_SPUR;
-	}
-
-	ah->config.intr_mitigation = true;
-
-	/*
-	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
-	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
-	 * This means we use it for all AR5416 devices, and the few
-	 * minor PCI AR9280 devices out there.
-	 *
-	 * Serialization is required because these devices do not handle
-	 * well the case of two concurrent reads/writes due to the latency
-	 * involved. During one read/write another read/write can be issued
-	 * on another CPU while the previous read/write may still be working
-	 * on our hardware, if we hit this case the hardware poops in a loop.
-	 * We prevent this by serializing reads and writes.
-	 *
-	 * This issue is not present on PCI-Express devices or pre-AR5416
-	 * devices (legacy, 802.11abg).
-	 */
-	if (num_possible_cpus() > 1)
-		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
-}
-
-static void ath9k_hw_init_defaults(struct ath_hw *ah)
-{
-	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-
-	regulatory->country_code = CTRY_DEFAULT;
-	regulatory->power_limit = MAX_RATE_POWER;
-	regulatory->tp_scale = ATH9K_TP_SCALE_MAX;
-
-	ah->hw_version.magic = AR5416_MAGIC;
-	ah->hw_version.subvendorid = 0;
-
-	ah->ah_flags = 0;
-	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
-		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
-	if (!AR_SREV_9100(ah))
-		ah->ah_flags = AH_USE_EEPROM;
-
-	ah->atim_window = 0;
-	ah->sta_id1_defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
-	ah->beacon_interval = 100;
-	ah->enable_32kHz_clock = DONT_USE_32KHZ;
-	ah->slottime = (u32) -1;
-	ah->acktimeout = (u32) -1;
-	ah->ctstimeout = (u32) -1;
-	ah->globaltxtimeout = (u32) -1;
-
-	ah->gbeacon_rate = 0;
-
-	ah->power_mode = ATH9K_PM_UNDEFINED;
-}
-
-static int ath9k_hw_rfattach(struct ath_hw *ah)
-{
-	bool rfStatus = false;
-	int ecode = 0;
-
-	rfStatus = ath9k_hw_init_rf(ah, &ecode);
-	if (!rfStatus) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "RF setup failed, status: %u\n", ecode);
-		return ecode;
-	}
-
-	return 0;
-}
-
-static int ath9k_hw_rf_claim(struct ath_hw *ah)
-{
-	u32 val;
-
-	REG_WRITE(ah, AR_PHY(0), 0x00000007);
-
-	val = ath9k_hw_get_radiorev(ah);
-	switch (val & AR_RADIO_SREV_MAJOR) {
-	case 0:
-		val = AR_RAD5133_SREV_MAJOR;
-		break;
-	case AR_RAD5133_SREV_MAJOR:
-	case AR_RAD5122_SREV_MAJOR:
-	case AR_RAD2133_SREV_MAJOR:
-	case AR_RAD2122_SREV_MAJOR:
-		break;
-	default:
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "Radio Chip Rev 0x%02X not supported\n",
-			  val & AR_RADIO_SREV_MAJOR);
-		return -EOPNOTSUPP;
-	}
-
-	ah->hw_version.analog5GhzRev = val;
-
-	return 0;
-}
-
-static int ath9k_hw_init_macaddr(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 sum;
-	int i;
-	u16 eeval;
-
-	sum = 0;
-	for (i = 0; i < 3; i++) {
-		eeval = ah->eep_ops->get_eeprom(ah, AR_EEPROM_MAC(i));
-		sum += eeval;
-		common->macaddr[2 * i] = eeval >> 8;
-		common->macaddr[2 * i + 1] = eeval & 0xff;
-	}
-	if (sum == 0 || sum == 0xffff * 3)
-		return -EADDRNOTAVAIL;
-
-	return 0;
-}
-
-static void ath9k_hw_init_rxgain_ini(struct ath_hw *ah)
-{
-	u32 rxgain_type;
-
-	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_17) {
-		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
-
-		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_backoff_13db_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_backoff_13db_rxgain_9280_2), 6);
-		else if (rxgain_type == AR5416_EEP_RXGAIN_23DB_BACKOFF)
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_backoff_23db_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_backoff_23db_rxgain_9280_2), 6);
-		else
-			INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_original_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
-	} else {
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-			ar9280Modes_original_rxgain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
-	}
-}
-
-static void ath9k_hw_init_txgain_ini(struct ath_hw *ah)
-{
-	u32 txgain_type;
-
-	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_19) {
-		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
-
-		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9280Modes_high_power_tx_gain_9280_2,
-			ARRAY_SIZE(ar9280Modes_high_power_tx_gain_9280_2), 6);
-		else
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9280Modes_original_tx_gain_9280_2,
-			ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
-	} else {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9280Modes_original_tx_gain_9280_2,
-		ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
-	}
-}
-
-static int ath9k_hw_post_init(struct ath_hw *ah)
-{
-	int ecode;
-
-	if (!ath9k_hw_chip_test(ah))
-		return -ENODEV;
-
-	ecode = ath9k_hw_rf_claim(ah);
-	if (ecode != 0)
-		return ecode;
-
-	ecode = ath9k_hw_eeprom_init(ah);
-	if (ecode != 0)
-		return ecode;
-
-	ath_print(ath9k_hw_common(ah), ATH_DBG_CONFIG,
-		  "Eeprom VER: %d, REV: %d\n",
-		  ah->eep_ops->get_eeprom_ver(ah),
-		  ah->eep_ops->get_eeprom_rev(ah));
-
-	ecode = ath9k_hw_rfattach(ah);
-	if (ecode != 0)
-		return ecode;
-
-	if (!AR_SREV_9100(ah)) {
-		ath9k_hw_ani_setup(ah);
-		ath9k_hw_ani_init(ah);
-	}
-
-	return 0;
-}
-
-static bool ath9k_hw_devid_supported(u16 devid)
-{
-	switch (devid) {
-	case AR5416_DEVID_PCI:
-	case AR5416_DEVID_PCIE:
-	case AR5416_AR9100_DEVID:
-	case AR9160_DEVID_PCI:
-	case AR9280_DEVID_PCI:
-	case AR9280_DEVID_PCIE:
-	case AR9285_DEVID_PCIE:
-	case AR5416_DEVID_AR9287_PCI:
-	case AR5416_DEVID_AR9287_PCIE:
-		return true;
-	default:
-		break;
-	}
-	return false;
-}
-
-static bool ath9k_hw_macversion_supported(u32 macversion)
-{
-	switch (macversion) {
-	case AR_SREV_VERSION_5416_PCI:
-	case AR_SREV_VERSION_5416_PCIE:
-	case AR_SREV_VERSION_9160:
-	case AR_SREV_VERSION_9100:
-	case AR_SREV_VERSION_9280:
-	case AR_SREV_VERSION_9285:
-	case AR_SREV_VERSION_9287:
-		return true;
-	/* Not yet */
-	case AR_SREV_VERSION_9271:
-	default:
-		break;
-	}
-	return false;
-}
-
-static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
-{
-	if (AR_SREV_9160_10_OR_LATER(ah)) {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			ah->iq_caldata.calData = &iq_cal_single_sample;
-			ah->adcgain_caldata.calData =
-				&adc_gain_cal_single_sample;
-			ah->adcdc_caldata.calData =
-				&adc_dc_cal_single_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
-		} else {
-			ah->iq_caldata.calData = &iq_cal_multi_sample;
-			ah->adcgain_caldata.calData =
-				&adc_gain_cal_multi_sample;
-			ah->adcdc_caldata.calData =
-				&adc_dc_cal_multi_sample;
-			ah->adcdc_calinitdata.calData =
-				&adc_init_dc_cal;
-		}
-		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
-	}
-}
-
-static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
-{
-	if (AR_SREV_9271(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271_1_0,
-			       ARRAY_SIZE(ar9271Modes_9271_1_0), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271_1_0,
-			       ARRAY_SIZE(ar9271Common_9271_1_0), 2);
-		return;
-	}
-
-	if (AR_SREV_9287_11_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
-				ARRAY_SIZE(ar9287Modes_9287_1_1), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_1,
-				ARRAY_SIZE(ar9287Common_9287_1_1), 2);
-		if (ah->config.pcie_clock_req)
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_off_L1_9287_1_1,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_1), 2);
-		else
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_always_on_L1_9287_1_1,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_1),
-					2);
-	} else if (AR_SREV_9287_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_0,
-				ARRAY_SIZE(ar9287Modes_9287_1_0), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_0,
-				ARRAY_SIZE(ar9287Common_9287_1_0), 2);
-
-		if (ah->config.pcie_clock_req)
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_off_L1_9287_1_0,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_0), 2);
-		else
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9287PciePhy_clkreq_always_on_L1_9287_1_0,
-			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_0),
-				  2);
-	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
-
-
-		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
-			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285_1_2,
-			       ARRAY_SIZE(ar9285Common_9285_1_2), 2);
-
-		if (ah->config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_off_L1_9285_1_2,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285_1_2), 2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
-				  2);
-		}
-	} else if (AR_SREV_9285_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285,
-			       ARRAY_SIZE(ar9285Modes_9285), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285,
-			       ARRAY_SIZE(ar9285Common_9285), 2);
-
-		if (ah->config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_off_L1_9285,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285), 2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			ar9285PciePhy_clkreq_always_on_L1_9285,
-			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285), 2);
-		}
-	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280_2,
-			       ARRAY_SIZE(ar9280Modes_9280_2), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280_2,
-			       ARRAY_SIZE(ar9280Common_9280_2), 2);
-
-		if (ah->config.pcie_clock_req) {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9280PciePhy_clkreq_off_L1_9280,
-			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280),2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9280PciePhy_clkreq_always_on_L1_9280,
-			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
-		}
-		INIT_INI_ARRAY(&ah->iniModesAdditional,
-			       ar9280Modes_fast_clock_9280_2,
-			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
-	} else if (AR_SREV_9280_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280,
-			       ARRAY_SIZE(ar9280Modes_9280), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280,
-			       ARRAY_SIZE(ar9280Common_9280), 2);
-	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9160,
-			       ARRAY_SIZE(ar5416Modes_9160), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9160,
-			       ARRAY_SIZE(ar5416Common_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9160,
-			       ARRAY_SIZE(ar5416Bank0_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9160,
-			       ARRAY_SIZE(ar5416BB_RfGain_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9160,
-			       ARRAY_SIZE(ar5416Bank1_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9160,
-			       ARRAY_SIZE(ar5416Bank2_9160), 2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9160,
-			       ARRAY_SIZE(ar5416Bank3_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9160,
-			       ARRAY_SIZE(ar5416Bank6_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9160,
-			       ARRAY_SIZE(ar5416Bank6TPC_9160), 3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9160,
-			       ARRAY_SIZE(ar5416Bank7_9160), 2);
-		if (AR_SREV_9160_11(ah)) {
-			INIT_INI_ARRAY(&ah->iniAddac,
-				       ar5416Addac_91601_1,
-				       ARRAY_SIZE(ar5416Addac_91601_1), 2);
-		} else {
-			INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9160,
-				       ARRAY_SIZE(ar5416Addac_9160), 2);
-		}
-	} else if (AR_SREV_9100_OR_LATER(ah)) {
-		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9100,
-			       ARRAY_SIZE(ar5416Modes_9100), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9100,
-			       ARRAY_SIZE(ar5416Common_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9100,
-			       ARRAY_SIZE(ar5416Bank0_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9100,
-			       ARRAY_SIZE(ar5416BB_RfGain_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9100,
-			       ARRAY_SIZE(ar5416Bank1_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9100,
-			       ARRAY_SIZE(ar5416Bank2_9100), 2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9100,
-			       ARRAY_SIZE(ar5416Bank3_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9100,
-			       ARRAY_SIZE(ar5416Bank6_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9100,
-			       ARRAY_SIZE(ar5416Bank6TPC_9100), 3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9100,
-			       ARRAY_SIZE(ar5416Bank7_9100), 2);
-		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9100,
-			       ARRAY_SIZE(ar5416Addac_9100), 2);
-	} else {
-		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes,
-			       ARRAY_SIZE(ar5416Modes), 6);
-		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common,
-			       ARRAY_SIZE(ar5416Common), 2);
-		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0,
-			       ARRAY_SIZE(ar5416Bank0), 2);
-		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain,
-			       ARRAY_SIZE(ar5416BB_RfGain), 3);
-		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1,
-			       ARRAY_SIZE(ar5416Bank1), 2);
-		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2,
-			       ARRAY_SIZE(ar5416Bank2), 2);
-		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3,
-			       ARRAY_SIZE(ar5416Bank3), 3);
-		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6,
-			       ARRAY_SIZE(ar5416Bank6), 3);
-		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC,
-			       ARRAY_SIZE(ar5416Bank6TPC), 3);
-		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7,
-			       ARRAY_SIZE(ar5416Bank7), 2);
-		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac,
-			       ARRAY_SIZE(ar5416Addac), 2);
-	}
-}
-
-static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
-{
-	if (AR_SREV_9287_11(ah))
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-		ar9287Modes_rx_gain_9287_1_1,
-		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_1), 6);
-	else if (AR_SREV_9287_10(ah))
-		INIT_INI_ARRAY(&ah->iniModesRxGain,
-		ar9287Modes_rx_gain_9287_1_0,
-		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_0), 6);
-	else if (AR_SREV_9280_20(ah))
-		ath9k_hw_init_rxgain_ini(ah);
-
-	if (AR_SREV_9287_11(ah)) {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9287Modes_tx_gain_9287_1_1,
-		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 6);
-	} else if (AR_SREV_9287_10(ah)) {
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-		ar9287Modes_tx_gain_9287_1_0,
-		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_0), 6);
-	} else if (AR_SREV_9280_20(ah)) {
-		ath9k_hw_init_txgain_ini(ah);
-	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
-		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
-
-		/* txgain table */
-		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9285Modes_high_power_tx_gain_9285_1_2,
-			ARRAY_SIZE(ar9285Modes_high_power_tx_gain_9285_1_2), 6);
-		} else {
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9285Modes_original_tx_gain_9285_1_2,
-			ARRAY_SIZE(ar9285Modes_original_tx_gain_9285_1_2), 6);
-		}
-
-	}
-}
-
-static void ath9k_hw_init_11a_eeprom_fix(struct ath_hw *ah)
-{
-	u32 i, j;
-
-	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
-	    test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes)) {
-
-		/* EEPROM Fixup */
-		for (i = 0; i < ah->iniModes.ia_rows; i++) {
-			u32 reg = INI_RA(&ah->iniModes, i, 0);
-
-			for (j = 1; j < ah->iniModes.ia_columns; j++) {
-				u32 val = INI_RA(&ah->iniModes, i, j);
-
-				INI_RA(&ah->iniModes, i, j) =
-					ath9k_hw_ini_fixup(ah,
-							   &ah->eeprom.def,
-							   reg, val);
-			}
-		}
-	}
-}
-
-int ath9k_hw_init(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	int r = 0;
-
-	if (!ath9k_hw_devid_supported(ah->hw_version.devid))
-		return -EOPNOTSUPP;
-
-	ath9k_hw_init_defaults(ah);
-	ath9k_hw_init_config(ah);
-
-	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Couldn't reset chip\n");
-		return -EIO;
-	}
-
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
-		ath_print(common, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
-		return -EIO;
-	}
-
-	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
-		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
-		    (AR_SREV_9280(ah) && !ah->is_pciexpress)) {
-			ah->config.serialize_regmode =
-				SER_REG_MODE_ON;
-		} else {
-			ah->config.serialize_regmode =
-				SER_REG_MODE_OFF;
-		}
-	}
-
-	ath_print(common, ATH_DBG_RESET, "serialize_regmode is %d\n",
-		ah->config.serialize_regmode);
-
-	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Mac Chip Rev 0x%02x.%x is not supported by "
-			  "this driver\n", ah->hw_version.macVersion,
-			  ah->hw_version.macRev);
-		return -EOPNOTSUPP;
-	}
-
-	if (AR_SREV_9100(ah)) {
-		ah->iq_caldata.calData = &iq_cal_multi_sample;
-		ah->supp_cals = IQ_MISMATCH_CAL;
-		ah->is_pciexpress = false;
-	}
-
-	if (AR_SREV_9271(ah))
-		ah->is_pciexpress = false;
-
-	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
-
-	ath9k_hw_init_cal_settings(ah);
-
-	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
-
-	ath9k_hw_init_mode_regs(ah);
-
-	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, 0);
-	else
-		ath9k_hw_disablepcie(ah);
-
-	r = ath9k_hw_post_init(ah);
-	if (r)
-		return r;
-
-	ath9k_hw_init_mode_gain_regs(ah);
-	ath9k_hw_fill_cap_info(ah);
-	ath9k_hw_init_11a_eeprom_fix(ah);
-
-	r = ath9k_hw_init_macaddr(ah);
-	if (r) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Failed to initialize MAC address\n");
-		return r;
-	}
-
-	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
-		ah->tx_trig_level = (AR_FTRIG_256B >> AR_FTRIG_S);
-	else
-		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
-
-	ath9k_init_nfcal_hist_buffer(ah);
-
-	return 0;
-}
-
-static void ath9k_hw_init_bb(struct ath_hw *ah,
-			     struct ath9k_channel *chan)
-{
-	u32 synthDelay;
-
-	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_B(chan))
-		synthDelay = (4 * synthDelay) / 22;
-	else
-		synthDelay /= 10;
-
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
-
-	udelay(synthDelay + BASE_ACTIVATE_DELAY);
-}
-
-static void ath9k_hw_init_qos(struct ath_hw *ah)
-{
-	REG_WRITE(ah, AR_MIC_QOS_CONTROL, 0x100aa);
-	REG_WRITE(ah, AR_MIC_QOS_SELECT, 0x3210);
-
-	REG_WRITE(ah, AR_QOS_NO_ACK,
-		  SM(2, AR_QOS_NO_ACK_TWO_BIT) |
-		  SM(5, AR_QOS_NO_ACK_BIT_OFF) |
-		  SM(0, AR_QOS_NO_ACK_BYTE_OFF));
-
-	REG_WRITE(ah, AR_TXOP_X, AR_TXOP_X_VAL);
-	REG_WRITE(ah, AR_TXOP_0_3, 0xFFFFFFFF);
-	REG_WRITE(ah, AR_TXOP_4_7, 0xFFFFFFFF);
-	REG_WRITE(ah, AR_TXOP_8_11, 0xFFFFFFFF);
-	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
-}
-
-static void ath9k_hw_init_pll(struct ath_hw *ah,
-			      struct ath9k_channel *chan)
-{
-	u32 pll;
-
-	if (AR_SREV_9100(ah)) {
-		if (chan && IS_CHAN_5GHZ(chan))
-			pll = 0x1450;
-		else
-			pll = 0x1458;
-	} else {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
-
-			if (chan && IS_CHAN_5GHZ(chan)) {
-				pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
-
-
-				if (AR_SREV_9280_20(ah)) {
-					if (((chan->channel % 20) == 0)
-					    || ((chan->channel % 10) == 0))
-						pll = 0x2850;
-					else
-						pll = 0x142c;
-				}
-			} else {
-				pll |= SM(0x2c, AR_RTC_9160_PLL_DIV);
-			}
-
-		} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-
-			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
-
-			if (chan && IS_CHAN_5GHZ(chan))
-				pll |= SM(0x50, AR_RTC_9160_PLL_DIV);
-			else
-				pll |= SM(0x58, AR_RTC_9160_PLL_DIV);
-		} else {
-			pll = AR_RTC_PLL_REFDIV_5 | AR_RTC_PLL_DIV2;
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_PLL_CLKSEL);
-
-			if (chan && IS_CHAN_5GHZ(chan))
-				pll |= SM(0xa, AR_RTC_PLL_DIV);
-			else
-				pll |= SM(0xb, AR_RTC_PLL_DIV);
-		}
-	}
-	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
-
-	udelay(RTC_PLL_SETTLE_DELAY);
-
-	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
-}
-
-static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
-{
-	int rx_chainmask, tx_chainmask;
-
-	rx_chainmask = ah->rxchainmask;
-	tx_chainmask = ah->txchainmask;
-
-	switch (rx_chainmask) {
-	case 0x5:
-		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			    AR_PHY_SWAP_ALT_CHAIN);
-	case 0x3:
-		if (((ah)->hw_version.macVersion <= AR_SREV_VERSION_9160)) {
-			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
-			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
-			break;
-		}
-	case 0x1:
-	case 0x2:
-	case 0x7:
-		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
-		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
-		break;
-	default:
-		break;
-	}
-
-	REG_WRITE(ah, AR_SELFGEN_MASK, tx_chainmask);
-	if (tx_chainmask == 0x5) {
-		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			    AR_PHY_SWAP_ALT_CHAIN);
-	}
-	if (AR_SREV_9100(ah))
-		REG_WRITE(ah, AR_PHY_ANALOG_SWAP,
-			  REG_READ(ah, AR_PHY_ANALOG_SWAP) | 0x00000001);
-}
-
-static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
-					  enum nl80211_iftype opmode)
-{
-	ah->mask_reg = AR_IMR_TXERR |
-		AR_IMR_TXURN |
-		AR_IMR_RXERR |
-		AR_IMR_RXORN |
-		AR_IMR_BCNMISC;
-
-	if (ah->config.intr_mitigation)
-		ah->mask_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
-	else
-		ah->mask_reg |= AR_IMR_RXOK;
-
-	ah->mask_reg |= AR_IMR_TXOK;
-
-	if (opmode == NL80211_IFTYPE_AP)
-		ah->mask_reg |= AR_IMR_MIB;
-
-	REG_WRITE(ah, AR_IMR, ah->mask_reg);
-	REG_WRITE(ah, AR_IMR_S2, REG_READ(ah, AR_IMR_S2) | AR_IMR_S2_GTT);
-
-	if (!AR_SREV_9100(ah)) {
-		REG_WRITE(ah, AR_INTR_SYNC_CAUSE, 0xFFFFFFFF);
-		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, AR_INTR_SYNC_DEFAULT);
-		REG_WRITE(ah, AR_INTR_SYNC_MASK, 0);
-	}
-}
-
-static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
-{
-	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
-			  "bad ack timeout %u\n", us);
-		ah->acktimeout = (u32) -1;
-		return false;
-	} else {
-		REG_RMW_FIELD(ah, AR_TIME_OUT,
-			      AR_TIME_OUT_ACK, ath9k_hw_mac_to_clks(ah, us));
-		ah->acktimeout = us;
-		return true;
-	}
-}
-
-static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
-{
-	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
-			  "bad cts timeout %u\n", us);
-		ah->ctstimeout = (u32) -1;
-		return false;
-	} else {
-		REG_RMW_FIELD(ah, AR_TIME_OUT,
-			      AR_TIME_OUT_CTS, ath9k_hw_mac_to_clks(ah, us));
-		ah->ctstimeout = us;
-		return true;
-	}
-}
-
-static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
-{
-	if (tu > 0xFFFF) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_XMIT,
-			  "bad global tx timeout %u\n", tu);
-		ah->globaltxtimeout = (u32) -1;
-		return false;
-	} else {
-		REG_RMW_FIELD(ah, AR_GTXTO, AR_GTXTO_TIMEOUT_LIMIT, tu);
-		ah->globaltxtimeout = tu;
-		return true;
-	}
-}
-
-static void ath9k_hw_init_user_settings(struct ath_hw *ah)
-{
-	ath_print(ath9k_hw_common(ah), ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
-		  ah->misc_mode);
-
-	if (ah->misc_mode != 0)
-		REG_WRITE(ah, AR_PCU_MISC,
-			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
-	if (ah->slottime != (u32) -1)
-		ath9k_hw_setslottime(ah, ah->slottime);
-	if (ah->acktimeout != (u32) -1)
-		ath9k_hw_set_ack_timeout(ah, ah->acktimeout);
-	if (ah->ctstimeout != (u32) -1)
-		ath9k_hw_set_cts_timeout(ah, ah->ctstimeout);
-	if (ah->globaltxtimeout != (u32) -1)
-		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
-}
-
-const char *ath9k_hw_probe(u16 vendorid, u16 devid)
-{
-	return vendorid == ATHEROS_VENDOR_ID ?
-		ath9k_hw_devname(devid) : NULL;
-}
-
-void ath9k_hw_detach(struct ath_hw *ah)
-{
-	if (!AR_SREV_9100(ah))
-		ath9k_hw_ani_disable(ah);
-
-	ath9k_hw_rf_free(ah);
-	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
-	kfree(ah);
-	ah = NULL;
-}
-
-/*******/
-/* INI */
-/*******/
-
-static void ath9k_hw_override_ini(struct ath_hw *ah,
-				  struct ath9k_channel *chan)
-{
-	u32 val;
-
-	if (AR_SREV_9271(ah)) {
-		/*
-		 * Enable spectral scan to solution for issues with stuck
-		 * beacons on AR9271 1.0. The beacon stuck issue is not seeon on
-		 * AR9271 1.1
-		 */
-		if (AR_SREV_9271_10(ah)) {
-			val = REG_READ(ah, AR_PHY_SPECTRAL_SCAN) | AR_PHY_SPECTRAL_SCAN_ENABLE;
-			REG_WRITE(ah, AR_PHY_SPECTRAL_SCAN, val);
-		}
-		else if (AR_SREV_9271_11(ah))
-			/*
-			 * change AR_PHY_RF_CTL3 setting to fix MAC issue
-			 * present on AR9271 1.1
-			 */
-			REG_WRITE(ah, AR_PHY_RF_CTL3, 0x3a020001);
-		return;
-	}
-
-	/*
-	 * Set the RX_ABORT and RX_DIS and clear if off only after
-	 * RXE is set for MAC. This prevents frames with corrupted
-	 * descriptor status.
-	 */
-	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
-
-
-	if (!AR_SREV_5416_20_OR_LATER(ah) ||
-	    AR_SREV_9280_10_OR_LATER(ah))
-		return;
-	/*
-	 * Disable BB clock gating
-	 * Necessary to avoid issues on AR5416 2.0
-	 */
-	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
-}
-
-static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
-			      struct ar5416_eeprom_def *pEepData,
-			      u32 reg, u32 value)
-{
-	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	switch (ah->hw_version.devid) {
-	case AR9280_DEVID_PCI:
-		if (reg == 0x7894) {
-			ath_print(common, ATH_DBG_EEPROM,
-				"ini VAL: %x  EEPROM: %x\n", value,
-				(pBase->version & 0xff));
-
-			if ((pBase->version & 0xff) > 0x0a) {
-				ath_print(common, ATH_DBG_EEPROM,
-					  "PWDCLKIND: %d\n",
-					  pBase->pwdclkind);
-				value &= ~AR_AN_TOP2_PWDCLKIND;
-				value |= AR_AN_TOP2_PWDCLKIND &
-					(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
-			} else {
-				ath_print(common, ATH_DBG_EEPROM,
-					  "PWDCLKIND Earlier Rev\n");
-			}
-
-			ath_print(common, ATH_DBG_EEPROM,
-				  "final ini VAL: %x\n", value);
-		}
-		break;
-	}
-
-	return value;
-}
-
-static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
-			      struct ar5416_eeprom_def *pEepData,
-			      u32 reg, u32 value)
-{
-	if (ah->eep_map == EEP_MAP_4KBITS)
-		return value;
-	else
-		return ath9k_hw_def_ini_fixup(ah, pEepData, reg, value);
-}
-
-static void ath9k_olc_init(struct ath_hw *ah)
-{
-	u32 i;
-
-	if (OLC_FOR_AR9287_10_LATER) {
-		REG_SET_BIT(ah, AR_PHY_TX_PWRCTRL9,
-				AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL);
-		ath9k_hw_analog_shift_rmw(ah, AR9287_AN_TXPC0,
-				AR9287_AN_TXPC0_TXPCMODE,
-				AR9287_AN_TXPC0_TXPCMODE_S,
-				AR9287_AN_TXPC0_TXPCMODE_TEMPSENSE);
-		udelay(100);
-	} else {
-		for (i = 0; i < AR9280_TX_GAIN_TABLE_SIZE; i++)
-			ah->originalGain[i] =
-				MS(REG_READ(ah, AR_PHY_TX_GAIN_TBL1 + i * 4),
-						AR_PHY_TX_GAIN);
-		ah->PDADCdelta = 0;
-	}
-}
-
-static u32 ath9k_regd_get_ctl(struct ath_regulatory *reg,
-			      struct ath9k_channel *chan)
-{
-	u32 ctl = ath_regd_get_band_ctl(reg, chan->chan->band);
-
-	if (IS_CHAN_B(chan))
-		ctl |= CTL_11B;
-	else if (IS_CHAN_G(chan))
-		ctl |= CTL_11G;
-	else
-		ctl |= CTL_11A;
-
-	return ctl;
-}
-
-static int ath9k_hw_process_ini(struct ath_hw *ah,
-				struct ath9k_channel *chan)
-{
-	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	int i, regWrites = 0;
-	struct ieee80211_channel *channel = chan->chan;
-	u32 modesIndex, freqIndex;
-
-	switch (chan->chanmode) {
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-		modesIndex = 1;
-		freqIndex = 1;
-		break;
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
-		modesIndex = 2;
-		freqIndex = 1;
-		break;
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_B:
-		modesIndex = 4;
-		freqIndex = 2;
-		break;
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
-		modesIndex = 3;
-		freqIndex = 2;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	REG_WRITE(ah, AR_PHY(0), 0x00000007);
-	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
-	ah->eep_ops->set_addac(ah, chan);
-
-	if (AR_SREV_5416_22_OR_LATER(ah)) {
-		REG_WRITE_ARRAY(&ah->iniAddac, 1, regWrites);
-	} else {
-		struct ar5416IniArray temp;
-		u32 addacSize =
-			sizeof(u32) * ah->iniAddac.ia_rows *
-			ah->iniAddac.ia_columns;
-
-		memcpy(ah->addac5416_21,
-		       ah->iniAddac.ia_array, addacSize);
-
-		(ah->addac5416_21)[31 * ah->iniAddac.ia_columns + 1] = 0;
-
-		temp.ia_array = ah->addac5416_21;
-		temp.ia_columns = ah->iniAddac.ia_columns;
-		temp.ia_rows = ah->iniAddac.ia_rows;
-		REG_WRITE_ARRAY(&temp, 1, regWrites);
-	}
-
-	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
-
-	for (i = 0; i < ah->iniModes.ia_rows; i++) {
-		u32 reg = INI_RA(&ah->iniModes, i, 0);
-		u32 val = INI_RA(&ah->iniModes, i, modesIndex);
-
-		REG_WRITE(ah, reg, val);
-
-		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->config.analog_shiftreg) {
-			udelay(100);
-		}
-
-		DO_DELAY(regWrites);
-	}
-
-	if (AR_SREV_9280(ah) || AR_SREV_9287_10_OR_LATER(ah))
-		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
-
-	if (AR_SREV_9280(ah) || AR_SREV_9285_12_OR_LATER(ah) ||
-	    AR_SREV_9287_10_OR_LATER(ah))
-		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
-
-	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
-		u32 reg = INI_RA(&ah->iniCommon, i, 0);
-		u32 val = INI_RA(&ah->iniCommon, i, 1);
-
-		REG_WRITE(ah, reg, val);
-
-		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->config.analog_shiftreg) {
-			udelay(100);
-		}
-
-		DO_DELAY(regWrites);
-	}
-
-	ath9k_hw_write_regs(ah, modesIndex, freqIndex, regWrites);
-
-	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
-		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
-				regWrites);
-	}
-
-	ath9k_hw_override_ini(ah, chan);
-	ath9k_hw_set_regs(ah, chan);
-	ath9k_hw_init_chain_masks(ah);
-
-	if (OLC_FOR_AR9280_20_LATER)
-		ath9k_olc_init(ah);
-
-	ah->eep_ops->set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(regulatory, chan),
-				 channel->max_antenna_gain * 2,
-				 channel->max_power * 2,
-				 min((u32) MAX_RATE_POWER,
-				 (u32) regulatory->power_limit));
-
-	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "ar5416SetRfRegs failed\n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
-/****************************************/
-/* Reset and Channel Switching Routines */
-/****************************************/
-
-static void ath9k_hw_set_rfmode(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	u32 rfMode = 0;
-
-	if (chan == NULL)
-		return;
-
-	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
-		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
-
-	if (!AR_SREV_9280_10_OR_LATER(ah))
-		rfMode |= (IS_CHAN_5GHZ(chan)) ?
-			AR_PHY_MODE_RF5GHZ : AR_PHY_MODE_RF2GHZ;
-
-	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan))
-		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
-
-	REG_WRITE(ah, AR_PHY_MODE, rfMode);
-}
-
-static void ath9k_hw_mark_phy_inactive(struct ath_hw *ah)
-{
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-}
-
-static inline void ath9k_hw_set_dma(struct ath_hw *ah)
-{
-	u32 regval;
-
-	/*
-	 * set AHB_MODE not to do cacheline prefetches
-	*/
-	regval = REG_READ(ah, AR_AHB_MODE);
-	REG_WRITE(ah, AR_AHB_MODE, regval | AR_AHB_PREFETCH_RD_EN);
-
-	/*
-	 * let mac dma reads be in 128 byte chunks
-	 */
-	regval = REG_READ(ah, AR_TXCFG) & ~AR_TXCFG_DMASZ_MASK;
-	REG_WRITE(ah, AR_TXCFG, regval | AR_TXCFG_DMASZ_128B);
-
-	/*
-	 * Restore TX Trigger Level to its pre-reset value.
-	 * The initial value depends on whether aggregation is enabled, and is
-	 * adjusted whenever underruns are detected.
-	 */
-	REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->tx_trig_level);
-
-	/*
-	 * let mac dma writes be in 128 byte chunks
-	 */
-	regval = REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_DMASZ_MASK;
-	REG_WRITE(ah, AR_RXCFG, regval | AR_RXCFG_DMASZ_128B);
-
-	/*
-	 * Setup receive FIFO threshold to hold off TX activities
-	 */
-	REG_WRITE(ah, AR_RXFIFO_CFG, 0x200);
-
-	/*
-	 * reduce the number of usable entries in PCU TXBUF to avoid
-	 * wrap around issues.
-	 */
-	if (AR_SREV_9285(ah)) {
-		/* For AR9285 the number of Fifos are reduced to half.
-		 * So set the usable tx buf size also to half to
-		 * avoid data/delimiter underruns
-		 */
-		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
-			  AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE);
-	} else if (!AR_SREV_9271(ah)) {
-		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
-			  AR_PCU_TXBUF_CTRL_USABLE_SIZE);
-	}
-}
-
-static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
-{
-	u32 val;
-
-	val = REG_READ(ah, AR_STA_ID1);
-	val &= ~(AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC);
-	switch (opmode) {
-	case NL80211_IFTYPE_AP:
-		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_STA_AP
-			  | AR_STA_ID1_KSRCH_MODE);
-		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
-		break;
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
-		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_ADHOC
-			  | AR_STA_ID1_KSRCH_MODE);
-		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_MONITOR:
-		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_KSRCH_MODE);
-		break;
-	}
-}
-
-static inline void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah,
-						 u32 coef_scaled,
-						 u32 *coef_mantissa,
-						 u32 *coef_exponent)
-{
-	u32 coef_exp, coef_man;
-
-	for (coef_exp = 31; coef_exp > 0; coef_exp--)
-		if ((coef_scaled >> coef_exp) & 0x1)
-			break;
-
-	coef_exp = 14 - (coef_exp - COEF_SCALE_S);
-
-	coef_man = coef_scaled + (1 << (COEF_SCALE_S - coef_exp - 1));
-
-	*coef_mantissa = coef_man >> (COEF_SCALE_S - coef_exp);
-	*coef_exponent = coef_exp - 16;
-}
-
-static void ath9k_hw_set_delta_slope(struct ath_hw *ah,
-				     struct ath9k_channel *chan)
-{
-	u32 coef_scaled, ds_coef_exp, ds_coef_man;
-	u32 clockMhzScaled = 0x64000000;
-	struct chan_centers centers;
-
-	if (IS_CHAN_HALF_RATE(chan))
-		clockMhzScaled = clockMhzScaled >> 1;
-	else if (IS_CHAN_QUARTER_RATE(chan))
-		clockMhzScaled = clockMhzScaled >> 2;
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	coef_scaled = clockMhzScaled / centers.synth_center;
-
-	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
-				      &ds_coef_exp);
-
-	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
-		      AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
-	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
-		      AR_PHY_TIMING3_DSC_EXP, ds_coef_exp);
-
-	coef_scaled = (9 * coef_scaled) / 10;
-
-	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
-				      &ds_coef_exp);
-
-	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
-		      AR_PHY_HALFGI_DSC_MAN, ds_coef_man);
-	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
-		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
-}
-
-static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
-{
-	u32 rst_flags;
-	u32 tmpReg;
-
-	if (AR_SREV_9100(ah)) {
-		u32 val = REG_READ(ah, AR_RTC_DERIVED_CLK);
-		val &= ~AR_RTC_DERIVED_CLK_PERIOD;
-		val |= SM(1, AR_RTC_DERIVED_CLK_PERIOD);
-		REG_WRITE(ah, AR_RTC_DERIVED_CLK, val);
-		(void)REG_READ(ah, AR_RTC_DERIVED_CLK);
-	}
-
-	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
-		  AR_RTC_FORCE_WAKE_ON_INT);
-
-	if (AR_SREV_9100(ah)) {
-		rst_flags = AR_RTC_RC_MAC_WARM | AR_RTC_RC_MAC_COLD |
-			AR_RTC_RC_COLD_RESET | AR_RTC_RC_WARM_RESET;
-	} else {
-		tmpReg = REG_READ(ah, AR_INTR_SYNC_CAUSE);
-		if (tmpReg &
-		    (AR_INTR_SYNC_LOCAL_TIMEOUT |
-		     AR_INTR_SYNC_RADM_CPL_TIMEOUT)) {
-			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
-			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
-		} else {
-			REG_WRITE(ah, AR_RC, AR_RC_AHB);
-		}
-
-		rst_flags = AR_RTC_RC_MAC_WARM;
-		if (type == ATH9K_RESET_COLD)
-			rst_flags |= AR_RTC_RC_MAC_COLD;
-	}
-
-	REG_WRITE(ah, AR_RTC_RC, rst_flags);
-	udelay(50);
-
-	REG_WRITE(ah, AR_RTC_RC, 0);
-	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
-			  "RTC stuck in MAC reset\n");
-		return false;
-	}
-
-	if (!AR_SREV_9100(ah))
-		REG_WRITE(ah, AR_RC, 0);
-
-	ath9k_hw_init_pll(ah, NULL);
-
-	if (AR_SREV_9100(ah))
-		udelay(50);
-
-	return true;
-}
-
-static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
-{
-	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
-		  AR_RTC_FORCE_WAKE_ON_INT);
-
-	if (!AR_SREV_9100(ah))
-		REG_WRITE(ah, AR_RC, AR_RC_AHB);
-
-	REG_WRITE(ah, AR_RTC_RESET, 0);
-	udelay(2);
-
-	if (!AR_SREV_9100(ah))
-		REG_WRITE(ah, AR_RC, 0);
-
-	REG_WRITE(ah, AR_RTC_RESET, 1);
-
-	if (!ath9k_hw_wait(ah,
-			   AR_RTC_STATUS,
-			   AR_RTC_STATUS_M,
-			   AR_RTC_STATUS_ON,
-			   AH_WAIT_TIMEOUT)) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
-			  "RTC not waking up\n");
-		return false;
-	}
-
-	ath9k_hw_read_revisions(ah);
-
-	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
-}
-
-static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
-{
-	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
-		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
-
-	switch (type) {
-	case ATH9K_RESET_POWER_ON:
-		return ath9k_hw_set_reset_power_on(ah);
-	case ATH9K_RESET_WARM:
-	case ATH9K_RESET_COLD:
-		return ath9k_hw_set_reset(ah, type);
-	default:
-		return false;
-	}
-}
-
-static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	u32 phymode;
-	u32 enableDacFifo = 0;
-
-	if (AR_SREV_9285_10_OR_LATER(ah))
-		enableDacFifo = (REG_READ(ah, AR_PHY_TURBO) &
-					 AR_PHY_FC_ENABLE_DAC_FIFO);
-
-	phymode = AR_PHY_FC_HT_EN | AR_PHY_FC_SHORT_GI_40
-		| AR_PHY_FC_SINGLE_HT_LTF1 | AR_PHY_FC_WALSH | enableDacFifo;
-
-	if (IS_CHAN_HT40(chan)) {
-		phymode |= AR_PHY_FC_DYN2040_EN;
-
-		if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
-		    (chan->chanmode == CHANNEL_G_HT40PLUS))
-			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
-
-	}
-	REG_WRITE(ah, AR_PHY_TURBO, phymode);
-
-	ath9k_hw_set11nmac2040(ah);
-
-	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
-	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
-}
-
-static bool ath9k_hw_chip_reset(struct ath_hw *ah,
-				struct ath9k_channel *chan)
-{
-	if (OLC_FOR_AR9280_20_LATER) {
-		if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
-			return false;
-	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
-		return false;
-
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
-		return false;
-
-	ah->chip_fullsleep = false;
-	ath9k_hw_init_pll(ah, chan);
-	ath9k_hw_set_rfmode(ah, chan);
-
-	return true;
-}
-
-static bool ath9k_hw_channel_change(struct ath_hw *ah,
-				    struct ath9k_channel *chan)
-{
-	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *channel = chan->chan;
-	u32 synthDelay, qnum;
-
-	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
-		if (ath9k_hw_numtxpending(ah, qnum)) {
-			ath_print(common, ATH_DBG_QUEUE,
-				  "Transmit frames pending on "
-				  "queue %d\n", qnum);
-			return false;
-		}
-	}
-
-	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
-	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
-			   AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT)) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Could not kill baseband RX\n");
-		return false;
-	}
-
-	ath9k_hw_set_regs(ah, chan);
-
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		ath9k_hw_ar9280_set_channel(ah, chan);
-	} else {
-		if (!(ath9k_hw_set_channel(ah, chan))) {
-			ath_print(common, ATH_DBG_FATAL,
-				  "Failed to set channel\n");
-			return false;
-		}
-	}
-
-	ah->eep_ops->set_txpower(ah, chan,
-			     ath9k_regd_get_ctl(regulatory, chan),
-			     channel->max_antenna_gain * 2,
-			     channel->max_power * 2,
-			     min((u32) MAX_RATE_POWER,
-			     (u32) regulatory->power_limit));
-
-	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_B(chan))
-		synthDelay = (4 * synthDelay) / 22;
-	else
-		synthDelay /= 10;
-
-	udelay(synthDelay + BASE_ACTIVATE_DELAY);
-
-	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
-
-	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
-		ath9k_hw_set_delta_slope(ah, chan);
-
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_9280_spur_mitigate(ah, chan);
-	else
-		ath9k_hw_spur_mitigate(ah, chan);
-
-	if (!chan->oneTimeCalsDone)
-		chan->oneTimeCalsDone = true;
-
-	return true;
-}
-
-static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	int bb_spur = AR_NO_SPUR;
-	int freq;
-	int bin, cur_bin;
-	int bb_spur_off, spur_subchannel_sd;
-	int spur_freq_sd;
-	int spur_delta_phase;
-	int denominator;
-	int upper, lower, cur_vit_mask;
-	int tmp, newVal;
-	int i;
-	int pilot_mask_reg[4] = { AR_PHY_TIMING7, AR_PHY_TIMING8,
-			  AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
-	};
-	int chan_mask_reg[4] = { AR_PHY_TIMING9, AR_PHY_TIMING10,
-			 AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
-	};
-	int inc[4] = { 0, 100, 0, 0 };
-	struct chan_centers centers;
-
-	int8_t mask_m[123];
-	int8_t mask_p[123];
-	int8_t mask_amt;
-	int tmp_mask;
-	int cur_bb_spur;
-	bool is2GHz = IS_CHAN_2GHZ(chan);
-
-	memset(&mask_m, 0, sizeof(int8_t) * 123);
-	memset(&mask_p, 0, sizeof(int8_t) * 123);
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	freq = centers.synth_center;
-
-	ah->config.spurmode = SPUR_ENABLE_EEPROM;
-	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
-
-		if (is2GHz)
-			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_2GHZ;
-		else
-			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_5GHZ;
-
-		if (AR_NO_SPUR == cur_bb_spur)
-			break;
-		cur_bb_spur = cur_bb_spur - freq;
-
-		if (IS_CHAN_HT40(chan)) {
-			if ((cur_bb_spur > -AR_SPUR_FEEQ_BOUND_HT40) &&
-			    (cur_bb_spur < AR_SPUR_FEEQ_BOUND_HT40)) {
-				bb_spur = cur_bb_spur;
-				break;
-			}
-		} else if ((cur_bb_spur > -AR_SPUR_FEEQ_BOUND_HT20) &&
-			   (cur_bb_spur < AR_SPUR_FEEQ_BOUND_HT20)) {
-			bb_spur = cur_bb_spur;
-			break;
-		}
-	}
-
-	if (AR_NO_SPUR == bb_spur) {
-		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
-			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
-		return;
-	} else {
-		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
-			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
-	}
-
-	bin = bb_spur * 320;
-
-	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
-
-	newVal = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
-			AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
-			AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
-			AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK);
-	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0), newVal);
-
-	newVal = (AR_PHY_SPUR_REG_MASK_RATE_CNTL |
-		  AR_PHY_SPUR_REG_ENABLE_MASK_PPM |
-		  AR_PHY_SPUR_REG_MASK_RATE_SELECT |
-		  AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI |
-		  SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
-	REG_WRITE(ah, AR_PHY_SPUR_REG, newVal);
-
-	if (IS_CHAN_HT40(chan)) {
-		if (bb_spur < 0) {
-			spur_subchannel_sd = 1;
-			bb_spur_off = bb_spur + 10;
-		} else {
-			spur_subchannel_sd = 0;
-			bb_spur_off = bb_spur - 10;
-		}
-	} else {
-		spur_subchannel_sd = 0;
-		bb_spur_off = bb_spur;
-	}
-
-	if (IS_CHAN_HT40(chan))
-		spur_delta_phase =
-			((bb_spur * 262144) /
-			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
-	else
-		spur_delta_phase =
-			((bb_spur * 524288) /
-			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
-
-	denominator = IS_CHAN_2GHZ(chan) ? 44 : 40;
-	spur_freq_sd = ((bb_spur_off * 2048) / denominator) & 0x3ff;
-
-	newVal = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
-		  SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
-		  SM(spur_delta_phase, AR_PHY_TIMING11_SPUR_DELTA_PHASE));
-	REG_WRITE(ah, AR_PHY_TIMING11, newVal);
-
-	newVal = spur_subchannel_sd << AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S;
-	REG_WRITE(ah, AR_PHY_SFCORR_EXT, newVal);
-
-	cur_bin = -6000;
-	upper = bin + 100;
-	lower = bin - 100;
-
-	for (i = 0; i < 4; i++) {
-		int pilot_mask = 0;
-		int chan_mask = 0;
-		int bp = 0;
-		for (bp = 0; bp < 30; bp++) {
-			if ((cur_bin > lower) && (cur_bin < upper)) {
-				pilot_mask = pilot_mask | 0x1 << bp;
-				chan_mask = chan_mask | 0x1 << bp;
-			}
-			cur_bin += 100;
-		}
-		cur_bin += inc[i];
-		REG_WRITE(ah, pilot_mask_reg[i], pilot_mask);
-		REG_WRITE(ah, chan_mask_reg[i], chan_mask);
-	}
-
-	cur_vit_mask = 6100;
-	upper = bin + 120;
-	lower = bin - 120;
-
-	for (i = 0; i < 123; i++) {
-		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
-
-			/* workaround for gcc bug #37014 */
-			volatile int tmp_v = abs(cur_vit_mask - bin);
-
-			if (tmp_v < 75)
-				mask_amt = 1;
-			else
-				mask_amt = 0;
-			if (cur_vit_mask < 0)
-				mask_m[abs(cur_vit_mask / 100)] = mask_amt;
-			else
-				mask_p[cur_vit_mask / 100] = mask_amt;
-		}
-		cur_vit_mask -= 100;
-	}
-
-	tmp_mask = (mask_m[46] << 30) | (mask_m[47] << 28)
-		| (mask_m[48] << 26) | (mask_m[49] << 24)
-		| (mask_m[50] << 22) | (mask_m[51] << 20)
-		| (mask_m[52] << 18) | (mask_m[53] << 16)
-		| (mask_m[54] << 14) | (mask_m[55] << 12)
-		| (mask_m[56] << 10) | (mask_m[57] << 8)
-		| (mask_m[58] << 6) | (mask_m[59] << 4)
-		| (mask_m[60] << 2) | (mask_m[61] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_1, tmp_mask);
-	REG_WRITE(ah, AR_PHY_VIT_MASK2_M_46_61, tmp_mask);
-
-	tmp_mask = (mask_m[31] << 28)
-		| (mask_m[32] << 26) | (mask_m[33] << 24)
-		| (mask_m[34] << 22) | (mask_m[35] << 20)
-		| (mask_m[36] << 18) | (mask_m[37] << 16)
-		| (mask_m[48] << 14) | (mask_m[39] << 12)
-		| (mask_m[40] << 10) | (mask_m[41] << 8)
-		| (mask_m[42] << 6) | (mask_m[43] << 4)
-		| (mask_m[44] << 2) | (mask_m[45] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_2, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_31_45, tmp_mask);
-
-	tmp_mask = (mask_m[16] << 30) | (mask_m[16] << 28)
-		| (mask_m[18] << 26) | (mask_m[18] << 24)
-		| (mask_m[20] << 22) | (mask_m[20] << 20)
-		| (mask_m[22] << 18) | (mask_m[22] << 16)
-		| (mask_m[24] << 14) | (mask_m[24] << 12)
-		| (mask_m[25] << 10) | (mask_m[26] << 8)
-		| (mask_m[27] << 6) | (mask_m[28] << 4)
-		| (mask_m[29] << 2) | (mask_m[30] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_3, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_16_30, tmp_mask);
-
-	tmp_mask = (mask_m[0] << 30) | (mask_m[1] << 28)
-		| (mask_m[2] << 26) | (mask_m[3] << 24)
-		| (mask_m[4] << 22) | (mask_m[5] << 20)
-		| (mask_m[6] << 18) | (mask_m[7] << 16)
-		| (mask_m[8] << 14) | (mask_m[9] << 12)
-		| (mask_m[10] << 10) | (mask_m[11] << 8)
-		| (mask_m[12] << 6) | (mask_m[13] << 4)
-		| (mask_m[14] << 2) | (mask_m[15] << 0);
-	REG_WRITE(ah, AR_PHY_MASK_CTL, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_00_15, tmp_mask);
-
-	tmp_mask = (mask_p[15] << 28)
-		| (mask_p[14] << 26) | (mask_p[13] << 24)
-		| (mask_p[12] << 22) | (mask_p[11] << 20)
-		| (mask_p[10] << 18) | (mask_p[9] << 16)
-		| (mask_p[8] << 14) | (mask_p[7] << 12)
-		| (mask_p[6] << 10) | (mask_p[5] << 8)
-		| (mask_p[4] << 6) | (mask_p[3] << 4)
-		| (mask_p[2] << 2) | (mask_p[1] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_1, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_15_01, tmp_mask);
-
-	tmp_mask = (mask_p[30] << 28)
-		| (mask_p[29] << 26) | (mask_p[28] << 24)
-		| (mask_p[27] << 22) | (mask_p[26] << 20)
-		| (mask_p[25] << 18) | (mask_p[24] << 16)
-		| (mask_p[23] << 14) | (mask_p[22] << 12)
-		| (mask_p[21] << 10) | (mask_p[20] << 8)
-		| (mask_p[19] << 6) | (mask_p[18] << 4)
-		| (mask_p[17] << 2) | (mask_p[16] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_2, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_30_16, tmp_mask);
-
-	tmp_mask = (mask_p[45] << 28)
-		| (mask_p[44] << 26) | (mask_p[43] << 24)
-		| (mask_p[42] << 22) | (mask_p[41] << 20)
-		| (mask_p[40] << 18) | (mask_p[39] << 16)
-		| (mask_p[38] << 14) | (mask_p[37] << 12)
-		| (mask_p[36] << 10) | (mask_p[35] << 8)
-		| (mask_p[34] << 6) | (mask_p[33] << 4)
-		| (mask_p[32] << 2) | (mask_p[31] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_3, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_45_31, tmp_mask);
-
-	tmp_mask = (mask_p[61] << 30) | (mask_p[60] << 28)
-		| (mask_p[59] << 26) | (mask_p[58] << 24)
-		| (mask_p[57] << 22) | (mask_p[56] << 20)
-		| (mask_p[55] << 18) | (mask_p[54] << 16)
-		| (mask_p[53] << 14) | (mask_p[52] << 12)
-		| (mask_p[51] << 10) | (mask_p[50] << 8)
-		| (mask_p[49] << 6) | (mask_p[48] << 4)
-		| (mask_p[47] << 2) | (mask_p[46] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
-}
-
-static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	int bb_spur = AR_NO_SPUR;
-	int bin, cur_bin;
-	int spur_freq_sd;
-	int spur_delta_phase;
-	int denominator;
-	int upper, lower, cur_vit_mask;
-	int tmp, new;
-	int i;
-	int pilot_mask_reg[4] = { AR_PHY_TIMING7, AR_PHY_TIMING8,
-			  AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
-	};
-	int chan_mask_reg[4] = { AR_PHY_TIMING9, AR_PHY_TIMING10,
-			 AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
-	};
-	int inc[4] = { 0, 100, 0, 0 };
-
-	int8_t mask_m[123];
-	int8_t mask_p[123];
-	int8_t mask_amt;
-	int tmp_mask;
-	int cur_bb_spur;
-	bool is2GHz = IS_CHAN_2GHZ(chan);
-
-	memset(&mask_m, 0, sizeof(int8_t) * 123);
-	memset(&mask_p, 0, sizeof(int8_t) * 123);
-
-	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
-		if (AR_NO_SPUR == cur_bb_spur)
-			break;
-		cur_bb_spur = cur_bb_spur - (chan->channel * 10);
-		if ((cur_bb_spur > -95) && (cur_bb_spur < 95)) {
-			bb_spur = cur_bb_spur;
-			break;
-		}
-	}
-
-	if (AR_NO_SPUR == bb_spur)
-		return;
-
-	bin = bb_spur * 32;
-
-	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
-	new = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
-		     AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
-		     AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
-		     AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK);
-
-	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0), new);
-
-	new = (AR_PHY_SPUR_REG_MASK_RATE_CNTL |
-	       AR_PHY_SPUR_REG_ENABLE_MASK_PPM |
-	       AR_PHY_SPUR_REG_MASK_RATE_SELECT |
-	       AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI |
-	       SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
-	REG_WRITE(ah, AR_PHY_SPUR_REG, new);
-
-	spur_delta_phase = ((bb_spur * 524288) / 100) &
-		AR_PHY_TIMING11_SPUR_DELTA_PHASE;
-
-	denominator = IS_CHAN_2GHZ(chan) ? 440 : 400;
-	spur_freq_sd = ((bb_spur * 2048) / denominator) & 0x3ff;
-
-	new = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
-	       SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
-	       SM(spur_delta_phase, AR_PHY_TIMING11_SPUR_DELTA_PHASE));
-	REG_WRITE(ah, AR_PHY_TIMING11, new);
-
-	cur_bin = -6000;
-	upper = bin + 100;
-	lower = bin - 100;
-
-	for (i = 0; i < 4; i++) {
-		int pilot_mask = 0;
-		int chan_mask = 0;
-		int bp = 0;
-		for (bp = 0; bp < 30; bp++) {
-			if ((cur_bin > lower) && (cur_bin < upper)) {
-				pilot_mask = pilot_mask | 0x1 << bp;
-				chan_mask = chan_mask | 0x1 << bp;
-			}
-			cur_bin += 100;
-		}
-		cur_bin += inc[i];
-		REG_WRITE(ah, pilot_mask_reg[i], pilot_mask);
-		REG_WRITE(ah, chan_mask_reg[i], chan_mask);
-	}
-
-	cur_vit_mask = 6100;
-	upper = bin + 120;
-	lower = bin - 120;
-
-	for (i = 0; i < 123; i++) {
-		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
-
-			/* workaround for gcc bug #37014 */
-			volatile int tmp_v = abs(cur_vit_mask - bin);
-
-			if (tmp_v < 75)
-				mask_amt = 1;
-			else
-				mask_amt = 0;
-			if (cur_vit_mask < 0)
-				mask_m[abs(cur_vit_mask / 100)] = mask_amt;
-			else
-				mask_p[cur_vit_mask / 100] = mask_amt;
-		}
-		cur_vit_mask -= 100;
-	}
-
-	tmp_mask = (mask_m[46] << 30) | (mask_m[47] << 28)
-		| (mask_m[48] << 26) | (mask_m[49] << 24)
-		| (mask_m[50] << 22) | (mask_m[51] << 20)
-		| (mask_m[52] << 18) | (mask_m[53] << 16)
-		| (mask_m[54] << 14) | (mask_m[55] << 12)
-		| (mask_m[56] << 10) | (mask_m[57] << 8)
-		| (mask_m[58] << 6) | (mask_m[59] << 4)
-		| (mask_m[60] << 2) | (mask_m[61] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_1, tmp_mask);
-	REG_WRITE(ah, AR_PHY_VIT_MASK2_M_46_61, tmp_mask);
-
-	tmp_mask = (mask_m[31] << 28)
-		| (mask_m[32] << 26) | (mask_m[33] << 24)
-		| (mask_m[34] << 22) | (mask_m[35] << 20)
-		| (mask_m[36] << 18) | (mask_m[37] << 16)
-		| (mask_m[48] << 14) | (mask_m[39] << 12)
-		| (mask_m[40] << 10) | (mask_m[41] << 8)
-		| (mask_m[42] << 6) | (mask_m[43] << 4)
-		| (mask_m[44] << 2) | (mask_m[45] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_2, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_31_45, tmp_mask);
-
-	tmp_mask = (mask_m[16] << 30) | (mask_m[16] << 28)
-		| (mask_m[18] << 26) | (mask_m[18] << 24)
-		| (mask_m[20] << 22) | (mask_m[20] << 20)
-		| (mask_m[22] << 18) | (mask_m[22] << 16)
-		| (mask_m[24] << 14) | (mask_m[24] << 12)
-		| (mask_m[25] << 10) | (mask_m[26] << 8)
-		| (mask_m[27] << 6) | (mask_m[28] << 4)
-		| (mask_m[29] << 2) | (mask_m[30] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_3, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_16_30, tmp_mask);
-
-	tmp_mask = (mask_m[0] << 30) | (mask_m[1] << 28)
-		| (mask_m[2] << 26) | (mask_m[3] << 24)
-		| (mask_m[4] << 22) | (mask_m[5] << 20)
-		| (mask_m[6] << 18) | (mask_m[7] << 16)
-		| (mask_m[8] << 14) | (mask_m[9] << 12)
-		| (mask_m[10] << 10) | (mask_m[11] << 8)
-		| (mask_m[12] << 6) | (mask_m[13] << 4)
-		| (mask_m[14] << 2) | (mask_m[15] << 0);
-	REG_WRITE(ah, AR_PHY_MASK_CTL, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_00_15, tmp_mask);
-
-	tmp_mask = (mask_p[15] << 28)
-		| (mask_p[14] << 26) | (mask_p[13] << 24)
-		| (mask_p[12] << 22) | (mask_p[11] << 20)
-		| (mask_p[10] << 18) | (mask_p[9] << 16)
-		| (mask_p[8] << 14) | (mask_p[7] << 12)
-		| (mask_p[6] << 10) | (mask_p[5] << 8)
-		| (mask_p[4] << 6) | (mask_p[3] << 4)
-		| (mask_p[2] << 2) | (mask_p[1] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_1, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_15_01, tmp_mask);
-
-	tmp_mask = (mask_p[30] << 28)
-		| (mask_p[29] << 26) | (mask_p[28] << 24)
-		| (mask_p[27] << 22) | (mask_p[26] << 20)
-		| (mask_p[25] << 18) | (mask_p[24] << 16)
-		| (mask_p[23] << 14) | (mask_p[22] << 12)
-		| (mask_p[21] << 10) | (mask_p[20] << 8)
-		| (mask_p[19] << 6) | (mask_p[18] << 4)
-		| (mask_p[17] << 2) | (mask_p[16] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_2, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_30_16, tmp_mask);
-
-	tmp_mask = (mask_p[45] << 28)
-		| (mask_p[44] << 26) | (mask_p[43] << 24)
-		| (mask_p[42] << 22) | (mask_p[41] << 20)
-		| (mask_p[40] << 18) | (mask_p[39] << 16)
-		| (mask_p[38] << 14) | (mask_p[37] << 12)
-		| (mask_p[36] << 10) | (mask_p[35] << 8)
-		| (mask_p[34] << 6) | (mask_p[33] << 4)
-		| (mask_p[32] << 2) | (mask_p[31] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_3, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_45_31, tmp_mask);
-
-	tmp_mask = (mask_p[61] << 30) | (mask_p[60] << 28)
-		| (mask_p[59] << 26) | (mask_p[58] << 24)
-		| (mask_p[57] << 22) | (mask_p[56] << 20)
-		| (mask_p[55] << 18) | (mask_p[54] << 16)
-		| (mask_p[53] << 14) | (mask_p[52] << 12)
-		| (mask_p[51] << 10) | (mask_p[50] << 8)
-		| (mask_p[49] << 6) | (mask_p[48] << 4)
-		| (mask_p[47] << 2) | (mask_p[46] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
-}
-
-static void ath9k_enable_rfkill(struct ath_hw *ah)
-{
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
-
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
-		    AR_GPIO_INPUT_MUX2_RFSILENT);
-
-	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
-	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
-}
-
-int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
-		    bool bChannelChange)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 saveLedState;
-	struct ath9k_channel *curchan = ah->curchan;
-	u32 saveDefAntenna;
-	u32 macStaId1;
-	int i, rx_chainmask, r;
-
-	ah->txchainmask = common->tx_chainmask;
-	ah->rxchainmask = common->rx_chainmask;
-
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
-		return -EIO;
-
-	if (curchan)
-		ath9k_hw_getnf(ah, curchan);
-
-	if (bChannelChange &&
-	    (ah->chip_fullsleep != true) &&
-	    (ah->curchan != NULL) &&
-	    (chan->channel != ah->curchan->channel) &&
-	    ((chan->channelFlags & CHANNEL_ALL) ==
-	     (ah->curchan->channelFlags & CHANNEL_ALL)) &&
-	    (!AR_SREV_9280(ah) || (!IS_CHAN_A_5MHZ_SPACED(chan) &&
-				   !IS_CHAN_A_5MHZ_SPACED(ah->curchan)))) {
-
-		if (ath9k_hw_channel_change(ah, chan)) {
-			ath9k_hw_loadnf(ah, ah->curchan);
-			ath9k_hw_start_nfcal(ah);
-			return 0;
-		}
-	}
-
-	saveDefAntenna = REG_READ(ah, AR_DEF_ANTENNA);
-	if (saveDefAntenna == 0)
-		saveDefAntenna = 1;
-
-	macStaId1 = REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_BASE_RATE_11B;
-
-	saveLedState = REG_READ(ah, AR_CFG_LED) &
-		(AR_CFG_LED_ASSOC_CTL | AR_CFG_LED_MODE_SEL |
-		 AR_CFG_LED_BLINK_THRESH_SEL | AR_CFG_LED_BLINK_SLOW);
-
-	ath9k_hw_mark_phy_inactive(ah);
-
-	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
-		REG_WRITE(ah,
-			  AR9271_RESET_POWER_DOWN_CONTROL,
-			  AR9271_RADIO_RF_RST);
-		udelay(50);
-	}
-
-	if (!ath9k_hw_chip_reset(ah, chan)) {
-		ath_print(common, ATH_DBG_FATAL, "Chip reset failed\n");
-		return -EINVAL;
-	}
-
-	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
-		ah->htc_reset_init = false;
-		REG_WRITE(ah,
-			  AR9271_RESET_POWER_DOWN_CONTROL,
-			  AR9271_GATE_MAC_CTL);
-		udelay(50);
-	}
-
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
-
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
-		/* Enable ASYNC FIFO */
-		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL);
-		REG_SET_BIT(ah, AR_PHY_MODE, AR_PHY_MODE_ASYNCFIFO);
-		REG_CLR_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
-		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
-	}
-	r = ath9k_hw_process_ini(ah, chan);
-	if (r)
-		return r;
-
-	/* Setup MFP options for CCMP */
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		/* Mask Retry(b11), PwrMgt(b12), MoreData(b13) to 0 in mgmt
-		 * frames when constructing CCMP AAD. */
-		REG_RMW_FIELD(ah, AR_AES_MUTE_MASK1, AR_AES_MUTE_MASK1_FC_MGMT,
-			      0xc7ff);
-		ah->sw_mgmt_crypto = false;
-	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-		/* Disable hardware crypto for management frames */
-		REG_CLR_BIT(ah, AR_PCU_MISC_MODE2,
-			    AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE);
-		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
-			    AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT);
-		ah->sw_mgmt_crypto = true;
-	} else
-		ah->sw_mgmt_crypto = true;
-
-	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
-		ath9k_hw_set_delta_slope(ah, chan);
-
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_9280_spur_mitigate(ah, chan);
-	else
-		ath9k_hw_spur_mitigate(ah, chan);
-
-	ah->eep_ops->set_board_values(ah, chan);
-
-	ath9k_hw_decrease_chain_power(ah, chan);
-
-	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
-	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
-		  | macStaId1
-		  | AR_STA_ID1_RTS_USE_DEF
-		  | (ah->config.
-		     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
-		  | ah->sta_id1_defaults);
-	ath9k_hw_set_operating_mode(ah, ah->opmode);
-
-	ath_hw_setbssidmask(common);
-
-	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
-
-	ath9k_hw_write_associd(ah);
-
-	REG_WRITE(ah, AR_ISR, ~0);
-
-	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
-
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_ar9280_set_channel(ah, chan);
-	else
-		if (!(ath9k_hw_set_channel(ah, chan)))
-			return -EIO;
-
-	for (i = 0; i < AR_NUM_DCU; i++)
-		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
-
-	ah->intr_txqs = 0;
-	for (i = 0; i < ah->caps.total_queues; i++)
-		ath9k_hw_resettxqueue(ah, i);
-
-	ath9k_hw_init_interrupt_masks(ah, ah->opmode);
-	ath9k_hw_init_qos(ah);
-
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
-		ath9k_enable_rfkill(ah);
-
-	ath9k_hw_init_user_settings(ah);
-
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
-		REG_WRITE(ah, AR_D_GBL_IFS_SIFS,
-			  AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR);
-		REG_WRITE(ah, AR_D_GBL_IFS_SLOT,
-			  AR_D_GBL_IFS_SLOT_ASYNC_FIFO_DUR);
-		REG_WRITE(ah, AR_D_GBL_IFS_EIFS,
-			  AR_D_GBL_IFS_EIFS_ASYNC_FIFO_DUR);
-
-		REG_WRITE(ah, AR_TIME_OUT, AR_TIME_OUT_ACK_CTS_ASYNC_FIFO_DUR);
-		REG_WRITE(ah, AR_USEC, AR_USEC_ASYNC_FIFO_DUR);
-
-		REG_SET_BIT(ah, AR_MAC_PCU_LOGIC_ANALYZER,
-			    AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768);
-		REG_RMW_FIELD(ah, AR_AHB_MODE, AR_AHB_CUSTOM_BURST_EN,
-			      AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL);
-	}
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
-		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
-				AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
-	}
-
-	REG_WRITE(ah, AR_STA_ID1,
-		  REG_READ(ah, AR_STA_ID1) | AR_STA_ID1_PRESERVE_SEQNUM);
-
-	ath9k_hw_set_dma(ah);
-
-	REG_WRITE(ah, AR_OBS, 8);
-
-	if (ah->config.intr_mitigation) {
-		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
-		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
-	}
-
-	ath9k_hw_init_bb(ah, chan);
-
-	if (!ath9k_hw_init_cal(ah, chan))
-		return -EIO;
-
-	rx_chainmask = ah->rxchainmask;
-	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
-		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
-		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
-	}
-
-	REG_WRITE(ah, AR_CFG_LED, saveLedState | AR_CFG_SCLK_32KHZ);
-
-	/*
-	 * For big endian systems turn on swapping for descriptors
-	 */
-	if (AR_SREV_9100(ah)) {
-		u32 mask;
-		mask = REG_READ(ah, AR_CFG);
-		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
-			ath_print(common, ATH_DBG_RESET,
-				"CFG Byte Swap Set 0x%x\n", mask);
-		} else {
-			mask =
-				INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
-			REG_WRITE(ah, AR_CFG, mask);
-			ath_print(common, ATH_DBG_RESET,
-				"Setting CFG 0x%x\n", REG_READ(ah, AR_CFG));
-		}
-	} else {
-		/* Configure AR9271 target WLAN */
-                if (AR_SREV_9271(ah))
-			REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
-#ifdef __BIG_ENDIAN
-                else
-			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
-#endif
-	}
-
-	if (ah->btcoex_hw.enabled)
-		ath9k_hw_btcoex_enable(ah);
-
-	return 0;
-}
-
-/************************/
-/* Key Cache Management */
-/************************/
-
-bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
-{
-	u32 keyType;
-
-	if (entry >= ah->caps.keycache_size) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "keychache entry %u out of range\n", entry);
-		return false;
-	}
-
-	keyType = REG_READ(ah, AR_KEYTABLE_TYPE(entry));
-
-	REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), AR_KEYTABLE_TYPE_CLR);
-	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), 0);
-	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), 0);
-
-	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
-		u16 micentry = entry + 64;
-
-		REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), 0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), 0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
-
-	}
-
-	return true;
-}
-
-bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
-{
-	u32 macHi, macLo;
-
-	if (entry >= ah->caps.keycache_size) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "keychache entry %u out of range\n", entry);
-		return false;
-	}
-
-	if (mac != NULL) {
-		macHi = (mac[5] << 8) | mac[4];
-		macLo = (mac[3] << 24) |
-			(mac[2] << 16) |
-			(mac[1] << 8) |
-			mac[0];
-		macLo >>= 1;
-		macLo |= (macHi & 1) << 31;
-		macHi >>= 1;
-	} else {
-		macLo = macHi = 0;
-	}
-	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), macLo);
-	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), macHi | AR_KEYTABLE_VALID);
-
-	return true;
-}
-
-bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
-				 const struct ath9k_keyval *k,
-				 const u8 *mac)
-{
-	const struct ath9k_hw_capabilities *pCap = &ah->caps;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 key0, key1, key2, key3, key4;
-	u32 keyType;
-
-	if (entry >= pCap->keycache_size) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "keycache entry %u out of range\n", entry);
-		return false;
-	}
-
-	switch (k->kv_type) {
-	case ATH9K_CIPHER_AES_OCB:
-		keyType = AR_KEYTABLE_TYPE_AES;
-		break;
-	case ATH9K_CIPHER_AES_CCM:
-		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
-			ath_print(common, ATH_DBG_ANY,
-				  "AES-CCM not supported by mac rev 0x%x\n",
-				  ah->hw_version.macRev);
-			return false;
-		}
-		keyType = AR_KEYTABLE_TYPE_CCM;
-		break;
-	case ATH9K_CIPHER_TKIP:
-		keyType = AR_KEYTABLE_TYPE_TKIP;
-		if (ATH9K_IS_MIC_ENABLED(ah)
-		    && entry + 64 >= pCap->keycache_size) {
-			ath_print(common, ATH_DBG_ANY,
-				  "entry %u inappropriate for TKIP\n", entry);
-			return false;
-		}
-		break;
-	case ATH9K_CIPHER_WEP:
-		if (k->kv_len < WLAN_KEY_LEN_WEP40) {
-			ath_print(common, ATH_DBG_ANY,
-				  "WEP key length %u too small\n", k->kv_len);
-			return false;
-		}
-		if (k->kv_len <= WLAN_KEY_LEN_WEP40)
-			keyType = AR_KEYTABLE_TYPE_40;
-		else if (k->kv_len <= WLAN_KEY_LEN_WEP104)
-			keyType = AR_KEYTABLE_TYPE_104;
-		else
-			keyType = AR_KEYTABLE_TYPE_128;
-		break;
-	case ATH9K_CIPHER_CLR:
-		keyType = AR_KEYTABLE_TYPE_CLR;
-		break;
-	default:
-		ath_print(common, ATH_DBG_FATAL,
-			  "cipher %u not supported\n", k->kv_type);
-		return false;
-	}
-
-	key0 = get_unaligned_le32(k->kv_val + 0);
-	key1 = get_unaligned_le16(k->kv_val + 4);
-	key2 = get_unaligned_le32(k->kv_val + 6);
-	key3 = get_unaligned_le16(k->kv_val + 10);
-	key4 = get_unaligned_le32(k->kv_val + 12);
-	if (k->kv_len <= WLAN_KEY_LEN_WEP104)
-		key4 &= 0xff;
-
-	/*
-	 * Note: Key cache registers access special memory area that requires
-	 * two 32-bit writes to actually update the values in the internal
-	 * memory. Consequently, the exact order and pairs used here must be
-	 * maintained.
-	 */
-
-	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
-		u16 micentry = entry + 64;
-
-		/*
-		 * Write inverted key[47:0] first to avoid Michael MIC errors
-		 * on frames that could be sent or received at the same time.
-		 * The correct key will be written in the end once everything
-		 * else is ready.
-		 */
-		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), ~key0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), ~key1);
-
-		/* Write key[95:48] */
-		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
-		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
-
-		/* Write key[127:96] and key type */
-		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
-		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
-
-		/* Write MAC address for the entry */
-		(void) ath9k_hw_keysetmac(ah, entry, mac);
-
-		if (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) {
-			/*
-			 * TKIP uses two key cache entries:
-			 * Michael MIC TX/RX keys in the same key cache entry
-			 * (idx = main index + 64):
-			 * key0 [31:0] = RX key [31:0]
-			 * key1 [15:0] = TX key [31:16]
-			 * key1 [31:16] = reserved
-			 * key2 [31:0] = RX key [63:32]
-			 * key3 [15:0] = TX key [15:0]
-			 * key3 [31:16] = reserved
-			 * key4 [31:0] = TX key [63:32]
-			 */
-			u32 mic0, mic1, mic2, mic3, mic4;
-
-			mic0 = get_unaligned_le32(k->kv_mic + 0);
-			mic2 = get_unaligned_le32(k->kv_mic + 4);
-			mic1 = get_unaligned_le16(k->kv_txmic + 2) & 0xffff;
-			mic3 = get_unaligned_le16(k->kv_txmic + 0) & 0xffff;
-			mic4 = get_unaligned_le32(k->kv_txmic + 4);
-
-			/* Write RX[31:0] and TX[31:16] */
-			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
-			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), mic1);
-
-			/* Write RX[63:32] and TX[15:0] */
-			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
-			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), mic3);
-
-			/* Write TX[63:32] and keyType(reserved) */
-			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), mic4);
-			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
-				  AR_KEYTABLE_TYPE_CLR);
-
-		} else {
-			/*
-			 * TKIP uses four key cache entries (two for group
-			 * keys):
-			 * Michael MIC TX/RX keys are in different key cache
-			 * entries (idx = main index + 64 for TX and
-			 * main index + 32 + 96 for RX):
-			 * key0 [31:0] = TX/RX MIC key [31:0]
-			 * key1 [31:0] = reserved
-			 * key2 [31:0] = TX/RX MIC key [63:32]
-			 * key3 [31:0] = reserved
-			 * key4 [31:0] = reserved
-			 *
-			 * Upper layer code will call this function separately
-			 * for TX and RX keys when these registers offsets are
-			 * used.
-			 */
-			u32 mic0, mic2;
-
-			mic0 = get_unaligned_le32(k->kv_mic + 0);
-			mic2 = get_unaligned_le32(k->kv_mic + 4);
-
-			/* Write MIC key[31:0] */
-			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
-			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
-
-			/* Write MIC key[63:32] */
-			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
-			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
-
-			/* Write TX[63:32] and keyType(reserved) */
-			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
-			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
-				  AR_KEYTABLE_TYPE_CLR);
-		}
-
-		/* MAC address registers are reserved for the MIC entry */
-		REG_WRITE(ah, AR_KEYTABLE_MAC0(micentry), 0);
-		REG_WRITE(ah, AR_KEYTABLE_MAC1(micentry), 0);
-
-		/*
-		 * Write the correct (un-inverted) key[47:0] last to enable
-		 * TKIP now that all other registers are set with correct
-		 * values.
-		 */
-		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
-	} else {
-		/* Write key[47:0] */
-		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
-		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
-
-		/* Write key[95:48] */
-		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
-		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
-
-		/* Write key[127:96] and key type */
-		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
-		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
-
-		/* Write MAC address for the entry */
-		(void) ath9k_hw_keysetmac(ah, entry, mac);
-	}
-
-	return true;
-}
-
-bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry)
-{
-	if (entry < ah->caps.keycache_size) {
-		u32 val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
-		if (val & AR_KEYTABLE_VALID)
-			return true;
-	}
-	return false;
-}
-
-/******************************/
-/* Power Management (Chipset) */
-/******************************/
-
-static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
-{
-	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
-	if (setChip) {
-		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
-			    AR_RTC_FORCE_WAKE_EN);
-		if (!AR_SREV_9100(ah))
-			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
-
-		REG_CLR_BIT(ah, (AR_RTC_RESET),
-			    AR_RTC_RESET_EN);
-	}
-}
-
-static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
-{
-	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
-	if (setChip) {
-		struct ath9k_hw_capabilities *pCap = &ah->caps;
-
-		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
-			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
-				  AR_RTC_FORCE_WAKE_ON_INT);
-		} else {
-			REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
-				    AR_RTC_FORCE_WAKE_EN);
-		}
-	}
-}
-
-static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
-{
-	u32 val;
-	int i;
-
-	if (setChip) {
-		if ((REG_READ(ah, AR_RTC_STATUS) &
-		     AR_RTC_STATUS_M) == AR_RTC_STATUS_SHUTDOWN) {
-			if (ath9k_hw_set_reset_reg(ah,
-					   ATH9K_RESET_POWER_ON) != true) {
-				return false;
-			}
-		}
-		if (AR_SREV_9100(ah))
-			REG_SET_BIT(ah, AR_RTC_RESET,
-				    AR_RTC_RESET_EN);
-
-		REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
-			    AR_RTC_FORCE_WAKE_EN);
-		udelay(50);
-
-		for (i = POWER_UP_TIME / 50; i > 0; i--) {
-			val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
-			if (val == AR_RTC_STATUS_ON)
-				break;
-			udelay(50);
-			REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
-				    AR_RTC_FORCE_WAKE_EN);
-		}
-		if (i == 0) {
-			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-				  "Failed to wakeup in %uus\n",
-				  POWER_UP_TIME / 20);
-			return false;
-		}
-	}
-
-	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
-
-	return true;
-}
-
-bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	int status = true, setChip = true;
-	static const char *modes[] = {
-		"AWAKE",
-		"FULL-SLEEP",
-		"NETWORK SLEEP",
-		"UNDEFINED"
-	};
-
-	if (ah->power_mode == mode)
-		return status;
-
-	ath_print(common, ATH_DBG_RESET, "%s -> %s\n",
-		  modes[ah->power_mode], modes[mode]);
-
-	switch (mode) {
-	case ATH9K_PM_AWAKE:
-		status = ath9k_hw_set_power_awake(ah, setChip);
-		break;
-	case ATH9K_PM_FULL_SLEEP:
-		ath9k_set_power_sleep(ah, setChip);
-		ah->chip_fullsleep = true;
-		break;
-	case ATH9K_PM_NETWORK_SLEEP:
-		ath9k_set_power_network_sleep(ah, setChip);
-		break;
-	default:
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unknown power mode %u\n", mode);
-		return false;
-	}
-	ah->power_mode = mode;
-
-	return status;
-}
-
-/*
- * Helper for ASPM support.
- *
- * Disable PLL when in L0s as well as receiver clock when in L1.
- * This power saving option must be enabled through the SerDes.
- *
- * Programming the SerDes must go through the same 288 bit serial shift
- * register as the other analog registers.  Hence the 9 writes.
- */
-void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
-{
-	u8 i;
-
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
-		return;
-
-	/* Nothing to do on restore for 11N */
-	if (restore)
-		return;
-
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		/*
-		 * AR9280 2.0 or later chips use SerDes values from the
-		 * initvals.h initialized depending on chipset during
-		 * ath9k_hw_init()
-		 */
-		for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
-			REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
-				  INI_RA(&ah->iniPcieSerdes, i, 1));
-		}
-	} else if (AR_SREV_9280(ah) &&
-		   (ah->hw_version.macRev == AR_SREV_REVISION_9280_10)) {
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
-
-		/* RX shut off when elecidle is asserted */
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xa8000019);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
-
-		/* Shut off CLKREQ active in L1 */
-		if (ah->config.pcie_clock_req)
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
-		else
-			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffd);
-
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x00043007);
-
-		/* Load the new settings */
-		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
-
-	} else {
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
-
-		/* RX shut off when elecidle is asserted */
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x28000039);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x53160824);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980579);
-
-		/*
-		 * Ignore ah->ah_config.pcie_clock_req setting for
-		 * pre-AR9280 11n
-		 */
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x001defff);
-
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
-		REG_WRITE(ah, AR_PCIE_SERDES, 0x000e3007);
-
-		/* Load the new settings */
-		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
-	}
-
-	udelay(1000);
-
-	/* set bit 19 to allow forcing of pcie core into L1 state */
-	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
-
-	/* Several PCIe massages to ensure proper behaviour */
-	if (ah->config.pcie_waen) {
-		REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
-	} else {
-		if (AR_SREV_9285(ah) || AR_SREV_9271(ah) || AR_SREV_9287(ah))
-			REG_WRITE(ah, AR_WA, AR9285_WA_DEFAULT);
-		/*
-		 * On AR9280 chips bit 22 of 0x4004 needs to be set to
-		 * otherwise card may disappear.
-		 */
-		else if (AR_SREV_9280(ah))
-			REG_WRITE(ah, AR_WA, AR9280_WA_DEFAULT);
-		else
-			REG_WRITE(ah, AR_WA, AR_WA_DEFAULT);
-	}
-}
-
-/**********************/
-/* Interrupt Handling */
-/**********************/
-
-bool ath9k_hw_intrpend(struct ath_hw *ah)
-{
-	u32 host_isr;
-
-	if (AR_SREV_9100(ah))
-		return true;
-
-	host_isr = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
-	if ((host_isr & AR_INTR_MAC_IRQ) && (host_isr != AR_INTR_SPURIOUS))
-		return true;
-
-	host_isr = REG_READ(ah, AR_INTR_SYNC_CAUSE);
-	if ((host_isr & AR_INTR_SYNC_DEFAULT)
-	    && (host_isr != AR_INTR_SPURIOUS))
-		return true;
-
-	return false;
-}
-
-bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
-{
-	u32 isr = 0;
-	u32 mask2 = 0;
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	u32 sync_cause = 0;
-	bool fatal_int = false;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (!AR_SREV_9100(ah)) {
-		if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
-			if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M)
-			    == AR_RTC_STATUS_ON) {
-				isr = REG_READ(ah, AR_ISR);
-			}
-		}
-
-		sync_cause = REG_READ(ah, AR_INTR_SYNC_CAUSE) &
-			AR_INTR_SYNC_DEFAULT;
-
-		*masked = 0;
-
-		if (!isr && !sync_cause)
-			return false;
-	} else {
-		*masked = 0;
-		isr = REG_READ(ah, AR_ISR);
-	}
-
-	if (isr) {
-		if (isr & AR_ISR_BCNMISC) {
-			u32 isr2;
-			isr2 = REG_READ(ah, AR_ISR_S2);
-			if (isr2 & AR_ISR_S2_TIM)
-				mask2 |= ATH9K_INT_TIM;
-			if (isr2 & AR_ISR_S2_DTIM)
-				mask2 |= ATH9K_INT_DTIM;
-			if (isr2 & AR_ISR_S2_DTIMSYNC)
-				mask2 |= ATH9K_INT_DTIMSYNC;
-			if (isr2 & (AR_ISR_S2_CABEND))
-				mask2 |= ATH9K_INT_CABEND;
-			if (isr2 & AR_ISR_S2_GTT)
-				mask2 |= ATH9K_INT_GTT;
-			if (isr2 & AR_ISR_S2_CST)
-				mask2 |= ATH9K_INT_CST;
-			if (isr2 & AR_ISR_S2_TSFOOR)
-				mask2 |= ATH9K_INT_TSFOOR;
-		}
-
-		isr = REG_READ(ah, AR_ISR_RAC);
-		if (isr == 0xffffffff) {
-			*masked = 0;
-			return false;
-		}
-
-		*masked = isr & ATH9K_INT_COMMON;
-
-		if (ah->config.intr_mitigation) {
-			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
-				*masked |= ATH9K_INT_RX;
-		}
-
-		if (isr & (AR_ISR_RXOK | AR_ISR_RXERR))
-			*masked |= ATH9K_INT_RX;
-		if (isr &
-		    (AR_ISR_TXOK | AR_ISR_TXDESC | AR_ISR_TXERR |
-		     AR_ISR_TXEOL)) {
-			u32 s0_s, s1_s;
-
-			*masked |= ATH9K_INT_TX;
-
-			s0_s = REG_READ(ah, AR_ISR_S0_S);
-			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
-			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
-
-			s1_s = REG_READ(ah, AR_ISR_S1_S);
-			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
-			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
-		}
-
-		if (isr & AR_ISR_RXORN) {
-			ath_print(common, ATH_DBG_INTERRUPT,
-				  "receive FIFO overrun interrupt\n");
-		}
-
-		if (!AR_SREV_9100(ah)) {
-			if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
-				u32 isr5 = REG_READ(ah, AR_ISR_S5_S);
-				if (isr5 & AR_ISR_S5_TIM_TIMER)
-					*masked |= ATH9K_INT_TIM_TIMER;
-			}
-		}
-
-		*masked |= mask2;
-	}
-
-	if (AR_SREV_9100(ah))
-		return true;
-
-	if (isr & AR_ISR_GENTMR) {
-		u32 s5_s;
-
-		s5_s = REG_READ(ah, AR_ISR_S5_S);
-		if (isr & AR_ISR_GENTMR) {
-			ah->intr_gen_timer_trigger =
-				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
-
-			ah->intr_gen_timer_thresh =
-				MS(s5_s, AR_ISR_S5_GENTIMER_THRESH);
-
-			if (ah->intr_gen_timer_trigger)
-				*masked |= ATH9K_INT_GENTIMER;
-
-		}
-	}
-
-	if (sync_cause) {
-		fatal_int =
-			(sync_cause &
-			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
-			? true : false;
-
-		if (fatal_int) {
-			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
-				ath_print(common, ATH_DBG_ANY,
-					  "received PCI FATAL interrupt\n");
-			}
-			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
-				ath_print(common, ATH_DBG_ANY,
-					  "received PCI PERR interrupt\n");
-			}
-			*masked |= ATH9K_INT_FATAL;
-		}
-		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
-			ath_print(common, ATH_DBG_INTERRUPT,
-				  "AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
-			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
-			REG_WRITE(ah, AR_RC, 0);
-			*masked |= ATH9K_INT_FATAL;
-		}
-		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
-			ath_print(common, ATH_DBG_INTERRUPT,
-				  "AR_INTR_SYNC_LOCAL_TIMEOUT\n");
-		}
-
-		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
-		(void) REG_READ(ah, AR_INTR_SYNC_CAUSE_CLR);
-	}
-
-	return true;
-}
-
-enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
-{
-	u32 omask = ah->mask_reg;
-	u32 mask, mask2;
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	ath_print(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
-
-	if (omask & ATH9K_INT_GLOBAL) {
-		ath_print(common, ATH_DBG_INTERRUPT, "disable IER\n");
-		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
-		(void) REG_READ(ah, AR_IER);
-		if (!AR_SREV_9100(ah)) {
-			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, 0);
-			(void) REG_READ(ah, AR_INTR_ASYNC_ENABLE);
-
-			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
-			(void) REG_READ(ah, AR_INTR_SYNC_ENABLE);
-		}
-	}
-
-	mask = ints & ATH9K_INT_COMMON;
-	mask2 = 0;
-
-	if (ints & ATH9K_INT_TX) {
-		if (ah->txok_interrupt_mask)
-			mask |= AR_IMR_TXOK;
-		if (ah->txdesc_interrupt_mask)
-			mask |= AR_IMR_TXDESC;
-		if (ah->txerr_interrupt_mask)
-			mask |= AR_IMR_TXERR;
-		if (ah->txeol_interrupt_mask)
-			mask |= AR_IMR_TXEOL;
-	}
-	if (ints & ATH9K_INT_RX) {
-		mask |= AR_IMR_RXERR;
-		if (ah->config.intr_mitigation)
-			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
-		else
-			mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
-		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
-			mask |= AR_IMR_GENTMR;
-	}
-
-	if (ints & (ATH9K_INT_BMISC)) {
-		mask |= AR_IMR_BCNMISC;
-		if (ints & ATH9K_INT_TIM)
-			mask2 |= AR_IMR_S2_TIM;
-		if (ints & ATH9K_INT_DTIM)
-			mask2 |= AR_IMR_S2_DTIM;
-		if (ints & ATH9K_INT_DTIMSYNC)
-			mask2 |= AR_IMR_S2_DTIMSYNC;
-		if (ints & ATH9K_INT_CABEND)
-			mask2 |= AR_IMR_S2_CABEND;
-		if (ints & ATH9K_INT_TSFOOR)
-			mask2 |= AR_IMR_S2_TSFOOR;
-	}
-
-	if (ints & (ATH9K_INT_GTT | ATH9K_INT_CST)) {
-		mask |= AR_IMR_BCNMISC;
-		if (ints & ATH9K_INT_GTT)
-			mask2 |= AR_IMR_S2_GTT;
-		if (ints & ATH9K_INT_CST)
-			mask2 |= AR_IMR_S2_CST;
-	}
-
-	ath_print(common, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
-	REG_WRITE(ah, AR_IMR, mask);
-	mask = REG_READ(ah, AR_IMR_S2) & ~(AR_IMR_S2_TIM |
-					   AR_IMR_S2_DTIM |
-					   AR_IMR_S2_DTIMSYNC |
-					   AR_IMR_S2_CABEND |
-					   AR_IMR_S2_CABTO |
-					   AR_IMR_S2_TSFOOR |
-					   AR_IMR_S2_GTT | AR_IMR_S2_CST);
-	REG_WRITE(ah, AR_IMR_S2, mask | mask2);
-	ah->mask_reg = ints;
-
-	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
-		if (ints & ATH9K_INT_TIM_TIMER)
-			REG_SET_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
-		else
-			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
-	}
-
-	if (ints & ATH9K_INT_GLOBAL) {
-		ath_print(common, ATH_DBG_INTERRUPT, "enable IER\n");
-		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
-		if (!AR_SREV_9100(ah)) {
-			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
-				  AR_INTR_MAC_IRQ);
-			REG_WRITE(ah, AR_INTR_ASYNC_MASK, AR_INTR_MAC_IRQ);
-
-
-			REG_WRITE(ah, AR_INTR_SYNC_ENABLE,
-				  AR_INTR_SYNC_DEFAULT);
-			REG_WRITE(ah, AR_INTR_SYNC_MASK,
-				  AR_INTR_SYNC_DEFAULT);
-		}
-		ath_print(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
-			  REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
-	}
-
-	return omask;
-}
-
-/*******************/
-/* Beacon Handling */
-/*******************/
-
-void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
-{
-	int flags = 0;
-
-	ah->beacon_interval = beacon_period;
-
-	switch (ah->opmode) {
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_MONITOR:
-		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
-		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, 0xffff);
-		REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
-		flags |= AR_TBTT_TIMER_EN;
-		break;
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
-		REG_SET_BIT(ah, AR_TXCFG,
-			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
-		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
-			  TU_TO_USEC(next_beacon +
-				     (ah->atim_window ? ah->
-				      atim_window : 1)));
-		flags |= AR_NDP_TIMER_EN;
-	case NL80211_IFTYPE_AP:
-		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
-		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT,
-			  TU_TO_USEC(next_beacon -
-				     ah->config.
-				     dma_beacon_response_time));
-		REG_WRITE(ah, AR_NEXT_SWBA,
-			  TU_TO_USEC(next_beacon -
-				     ah->config.
-				     sw_beacon_response_time));
-		flags |=
-			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
-		break;
-	default:
-		ath_print(ath9k_hw_common(ah), ATH_DBG_BEACON,
-			  "%s: unsupported opmode: %d\n",
-			  __func__, ah->opmode);
-		return;
-		break;
-	}
-
-	REG_WRITE(ah, AR_BEACON_PERIOD, TU_TO_USEC(beacon_period));
-	REG_WRITE(ah, AR_DMA_BEACON_PERIOD, TU_TO_USEC(beacon_period));
-	REG_WRITE(ah, AR_SWBA_PERIOD, TU_TO_USEC(beacon_period));
-	REG_WRITE(ah, AR_NDP_PERIOD, TU_TO_USEC(beacon_period));
-
-	beacon_period &= ~ATH9K_BEACON_ENA;
-	if (beacon_period & ATH9K_BEACON_RESET_TSF) {
-		beacon_period &= ~ATH9K_BEACON_RESET_TSF;
-		ath9k_hw_reset_tsf(ah);
-	}
-
-	REG_SET_BIT(ah, AR_TIMER_MODE, flags);
-}
-
-void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
-				    const struct ath9k_beacon_state *bs)
-{
-	u32 nextTbtt, beaconintval, dtimperiod, beacontimeout;
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
-
-	REG_WRITE(ah, AR_BEACON_PERIOD,
-		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
-	REG_WRITE(ah, AR_DMA_BEACON_PERIOD,
-		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
-
-	REG_RMW_FIELD(ah, AR_RSSI_THR,
-		      AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
-
-	beaconintval = bs->bs_intval & ATH9K_BEACON_PERIOD;
-
-	if (bs->bs_sleepduration > beaconintval)
-		beaconintval = bs->bs_sleepduration;
-
-	dtimperiod = bs->bs_dtimperiod;
-	if (bs->bs_sleepduration > dtimperiod)
-		dtimperiod = bs->bs_sleepduration;
-
-	if (beaconintval == dtimperiod)
-		nextTbtt = bs->bs_nextdtim;
-	else
-		nextTbtt = bs->bs_nexttbtt;
-
-	ath_print(common, ATH_DBG_BEACON, "next DTIM %d\n", bs->bs_nextdtim);
-	ath_print(common, ATH_DBG_BEACON, "next beacon %d\n", nextTbtt);
-	ath_print(common, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
-	ath_print(common, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
-
-	REG_WRITE(ah, AR_NEXT_DTIM,
-		  TU_TO_USEC(bs->bs_nextdtim - SLEEP_SLOP));
-	REG_WRITE(ah, AR_NEXT_TIM, TU_TO_USEC(nextTbtt - SLEEP_SLOP));
-
-	REG_WRITE(ah, AR_SLEEP1,
-		  SM((CAB_TIMEOUT_VAL << 3), AR_SLEEP1_CAB_TIMEOUT)
-		  | AR_SLEEP1_ASSUME_DTIM);
-
-	if (pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)
-		beacontimeout = (BEACON_TIMEOUT_VAL << 3);
-	else
-		beacontimeout = MIN_BEACON_TIMEOUT_VAL;
-
-	REG_WRITE(ah, AR_SLEEP2,
-		  SM(beacontimeout, AR_SLEEP2_BEACON_TIMEOUT));
-
-	REG_WRITE(ah, AR_TIM_PERIOD, TU_TO_USEC(beaconintval));
-	REG_WRITE(ah, AR_DTIM_PERIOD, TU_TO_USEC(dtimperiod));
-
-	REG_SET_BIT(ah, AR_TIMER_MODE,
-		    AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
-		    AR_DTIM_TIMER_EN);
-
-	/* TSF Out of Range Threshold */
-	REG_WRITE(ah, AR_TSFOOR_THRESHOLD, bs->bs_tsfoor_threshold);
-}
-
-/*******************/
-/* HW Capabilities */
-/*******************/
-
-void ath9k_hw_fill_cap_info(struct ath_hw *ah)
-{
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
-
-	u16 capField = 0, eeval;
-
-	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
-	regulatory->current_rd = eeval;
-
-	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_1);
-	if (AR_SREV_9285_10_OR_LATER(ah))
-		eeval |= AR9285_RDEXT_DEFAULT;
-	regulatory->current_rd_ext = eeval;
-
-	capField = ah->eep_ops->get_eeprom(ah, EEP_OP_CAP);
-
-	if (ah->opmode != NL80211_IFTYPE_AP &&
-	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
-		if (regulatory->current_rd == 0x64 ||
-		    regulatory->current_rd == 0x65)
-			regulatory->current_rd += 5;
-		else if (regulatory->current_rd == 0x41)
-			regulatory->current_rd = 0x43;
-		ath_print(common, ATH_DBG_REGULATORY,
-			  "regdomain mapped to 0x%x\n", regulatory->current_rd);
-	}
-
-	eeval = ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);
-	bitmap_zero(pCap->wireless_modes, ATH9K_MODE_MAX);
-
-	if (eeval & AR5416_OPFLAGS_11A) {
-		set_bit(ATH9K_MODE_11A, pCap->wireless_modes);
-		if (ah->config.ht_enable) {
-			if (!(eeval & AR5416_OPFLAGS_N_5G_HT20))
-				set_bit(ATH9K_MODE_11NA_HT20,
-					pCap->wireless_modes);
-			if (!(eeval & AR5416_OPFLAGS_N_5G_HT40)) {
-				set_bit(ATH9K_MODE_11NA_HT40PLUS,
-					pCap->wireless_modes);
-				set_bit(ATH9K_MODE_11NA_HT40MINUS,
-					pCap->wireless_modes);
-			}
-		}
-	}
-
-	if (eeval & AR5416_OPFLAGS_11G) {
-		set_bit(ATH9K_MODE_11G, pCap->wireless_modes);
-		if (ah->config.ht_enable) {
-			if (!(eeval & AR5416_OPFLAGS_N_2G_HT20))
-				set_bit(ATH9K_MODE_11NG_HT20,
-					pCap->wireless_modes);
-			if (!(eeval & AR5416_OPFLAGS_N_2G_HT40)) {
-				set_bit(ATH9K_MODE_11NG_HT40PLUS,
-					pCap->wireless_modes);
-				set_bit(ATH9K_MODE_11NG_HT40MINUS,
-					pCap->wireless_modes);
-			}
-		}
-	}
-
-	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
-	/*
-	 * For AR9271 we will temporarilly uses the rx chainmax as read from
-	 * the EEPROM.
-	 */
-	if ((ah->hw_version.devid == AR5416_DEVID_PCI) &&
-	    !(eeval & AR5416_OPFLAGS_11A) &&
-	    !(AR_SREV_9271(ah)))
-		/* CB71: GPIO 0 is pulled down to indicate 3 rx chains */
-		pCap->rx_chainmask = ath9k_hw_gpio_get(ah, 0) ? 0x5 : 0x7;
-	else
-		/* Use rx_chainmask from EEPROM. */
-		pCap->rx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
-
-	if (!(AR_SREV_9280(ah) && (ah->hw_version.macRev == 0)))
-		ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
-
-	pCap->low_2ghz_chan = 2312;
-	pCap->high_2ghz_chan = 2732;
-
-	pCap->low_5ghz_chan = 4920;
-	pCap->high_5ghz_chan = 6100;
-
-	pCap->hw_caps &= ~ATH9K_HW_CAP_CIPHER_CKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_TKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_AESCCM;
-
-	pCap->hw_caps &= ~ATH9K_HW_CAP_MIC_CKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_MIC_TKIP;
-	pCap->hw_caps |= ATH9K_HW_CAP_MIC_AESCCM;
-
-	if (ah->config.ht_enable)
-		pCap->hw_caps |= ATH9K_HW_CAP_HT;
-	else
-		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
-
-	pCap->hw_caps |= ATH9K_HW_CAP_GTT;
-	pCap->hw_caps |= ATH9K_HW_CAP_VEOL;
-	pCap->hw_caps |= ATH9K_HW_CAP_BSSIDMASK;
-	pCap->hw_caps &= ~ATH9K_HW_CAP_MCAST_KEYSEARCH;
-
-	if (capField & AR_EEPROM_EEPCAP_MAXQCU)
-		pCap->total_queues =
-			MS(capField, AR_EEPROM_EEPCAP_MAXQCU);
-	else
-		pCap->total_queues = ATH9K_NUM_TX_QUEUES;
-
-	if (capField & AR_EEPROM_EEPCAP_KC_ENTRIES)
-		pCap->keycache_size =
-			1 << MS(capField, AR_EEPROM_EEPCAP_KC_ENTRIES);
-	else
-		pCap->keycache_size = AR_KEYTABLE_SIZE;
-
-	pCap->hw_caps |= ATH9K_HW_CAP_FASTCC;
-	pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
-
-	if (AR_SREV_9285_10_OR_LATER(ah))
-		pCap->num_gpio_pins = AR9285_NUM_GPIO;
-	else if (AR_SREV_9280_10_OR_LATER(ah))
-		pCap->num_gpio_pins = AR928X_NUM_GPIO;
-	else
-		pCap->num_gpio_pins = AR_NUM_GPIO;
-
-	if (AR_SREV_9160_10_OR_LATER(ah) || AR_SREV_9100(ah)) {
-		pCap->hw_caps |= ATH9K_HW_CAP_CST;
-		pCap->rts_aggr_limit = ATH_AMPDU_LIMIT_MAX;
-	} else {
-		pCap->rts_aggr_limit = (8 * 1024);
-	}
-
-	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
-
-#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-	ah->rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
-	if (ah->rfsilent & EEP_RFSILENT_ENABLED) {
-		ah->rfkill_gpio =
-			MS(ah->rfsilent, EEP_RFSILENT_GPIO_SEL);
-		ah->rfkill_polarity =
-			MS(ah->rfsilent, EEP_RFSILENT_POLARITY);
-
-		pCap->hw_caps |= ATH9K_HW_CAP_RFSILENT;
-	}
-#endif
-
-	if ((ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9160) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9100) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9280) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9285))
-		pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
-	else
-		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;
-
-	if (AR_SREV_9280(ah) || AR_SREV_9285(ah))
-		pCap->hw_caps &= ~ATH9K_HW_CAP_4KB_SPLITTRANS;
-	else
-		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
-
-	if (regulatory->current_rd_ext & (1 << REG_EXT_JAPAN_MIDBAND)) {
-		pCap->reg_cap =
-			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
-			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
-			AR_EEPROM_EEREGCAP_EN_KK_U2 |
-			AR_EEPROM_EEREGCAP_EN_KK_MIDBAND;
-	} else {
-		pCap->reg_cap =
-			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
-			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN;
-	}
-
-	pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
-
-	pCap->num_antcfg_5ghz =
-		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_5GHZ);
-	pCap->num_antcfg_2ghz =
-		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
-
-	if (AR_SREV_9280_10_OR_LATER(ah) &&
-	    ath9k_hw_btcoex_supported(ah)) {
-		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
-		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
-
-		if (AR_SREV_9285(ah)) {
-			btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
-			btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO;
-		} else {
-			btcoex_hw->scheme = ATH_BTCOEX_CFG_2WIRE;
-		}
-	} else {
-		btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
-	}
-}
-
-bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
-			    u32 capability, u32 *result)
-{
-	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	switch (type) {
-	case ATH9K_CAP_CIPHER:
-		switch (capability) {
-		case ATH9K_CIPHER_AES_CCM:
-		case ATH9K_CIPHER_AES_OCB:
-		case ATH9K_CIPHER_TKIP:
-		case ATH9K_CIPHER_WEP:
-		case ATH9K_CIPHER_MIC:
-		case ATH9K_CIPHER_CLR:
-			return true;
-		default:
-			return false;
-		}
-	case ATH9K_CAP_TKIP_MIC:
-		switch (capability) {
-		case 0:
-			return true;
-		case 1:
-			return (ah->sta_id1_defaults &
-				AR_STA_ID1_CRPT_MIC_ENABLE) ? true :
-			false;
-		}
-	case ATH9K_CAP_TKIP_SPLIT:
-		return (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) ?
-			false : true;
-	case ATH9K_CAP_DIVERSITY:
-		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
-			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
-			true : false;
-	case ATH9K_CAP_MCAST_KEYSRCH:
-		switch (capability) {
-		case 0:
-			return true;
-		case 1:
-			if (REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_ADHOC) {
-				return false;
-			} else {
-				return (ah->sta_id1_defaults &
-					AR_STA_ID1_MCAST_KSRCH) ? true :
-					false;
-			}
-		}
-		return false;
-	case ATH9K_CAP_TXPOW:
-		switch (capability) {
-		case 0:
-			return 0;
-		case 1:
-			*result = regulatory->power_limit;
-			return 0;
-		case 2:
-			*result = regulatory->max_power_level;
-			return 0;
-		case 3:
-			*result = regulatory->tp_scale;
-			return 0;
-		}
-		return false;
-	case ATH9K_CAP_DS:
-		return (AR_SREV_9280_20_OR_LATER(ah) &&
-			(ah->eep_ops->get_eeprom(ah, EEP_RC_CHAIN_MASK) == 1))
-			? false : true;
-	default:
-		return false;
-	}
-}
-
-bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
-			    u32 capability, u32 setting, int *status)
-{
-	u32 v;
-
-	switch (type) {
-	case ATH9K_CAP_TKIP_MIC:
-		if (setting)
-			ah->sta_id1_defaults |=
-				AR_STA_ID1_CRPT_MIC_ENABLE;
-		else
-			ah->sta_id1_defaults &=
-				~AR_STA_ID1_CRPT_MIC_ENABLE;
-		return true;
-	case ATH9K_CAP_DIVERSITY:
-		v = REG_READ(ah, AR_PHY_CCK_DETECT);
-		if (setting)
-			v |= AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
-		else
-			v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
-		REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
-		return true;
-	case ATH9K_CAP_MCAST_KEYSRCH:
-		if (setting)
-			ah->sta_id1_defaults |= AR_STA_ID1_MCAST_KSRCH;
-		else
-			ah->sta_id1_defaults &= ~AR_STA_ID1_MCAST_KSRCH;
-		return true;
-	default:
-		return false;
-	}
-}
-
-/****************************/
-/* GPIO / RFKILL / Antennae */
-/****************************/
-
-static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah,
-					 u32 gpio, u32 type)
-{
-	int addr;
-	u32 gpio_shift, tmp;
-
-	if (gpio > 11)
-		addr = AR_GPIO_OUTPUT_MUX3;
-	else if (gpio > 5)
-		addr = AR_GPIO_OUTPUT_MUX2;
-	else
-		addr = AR_GPIO_OUTPUT_MUX1;
-
-	gpio_shift = (gpio % 6) * 5;
-
-	if (AR_SREV_9280_20_OR_LATER(ah)
-	    || (addr != AR_GPIO_OUTPUT_MUX1)) {
-		REG_RMW(ah, addr, (type << gpio_shift),
-			(0x1f << gpio_shift));
-	} else {
-		tmp = REG_READ(ah, addr);
-		tmp = ((tmp & 0x1F0) << 1) | (tmp & ~0x1F0);
-		tmp &= ~(0x1f << gpio_shift);
-		tmp |= (type << gpio_shift);
-		REG_WRITE(ah, addr, tmp);
-	}
-}
-
-void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio)
-{
-	u32 gpio_shift;
-
-	BUG_ON(gpio >= ah->caps.num_gpio_pins);
-
-	gpio_shift = gpio << 1;
-
-	REG_RMW(ah,
-		AR_GPIO_OE_OUT,
-		(AR_GPIO_OE_OUT_DRV_NO << gpio_shift),
-		(AR_GPIO_OE_OUT_DRV << gpio_shift));
-}
-
-u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
-{
-#define MS_REG_READ(x, y) \
-	(MS(REG_READ(ah, AR_GPIO_IN_OUT), x##_GPIO_IN_VAL) & (AR_GPIO_BIT(y)))
-
-	if (gpio >= ah->caps.num_gpio_pins)
-		return 0xffffffff;
-
-	if (AR_SREV_9287_10_OR_LATER(ah))
-		return MS_REG_READ(AR9287, gpio) != 0;
-	else if (AR_SREV_9285_10_OR_LATER(ah))
-		return MS_REG_READ(AR9285, gpio) != 0;
-	else if (AR_SREV_9280_10_OR_LATER(ah))
-		return MS_REG_READ(AR928X, gpio) != 0;
-	else
-		return MS_REG_READ(AR, gpio) != 0;
-}
-
-void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
-			 u32 ah_signal_type)
-{
-	u32 gpio_shift;
-
-	ath9k_hw_gpio_cfg_output_mux(ah, gpio, ah_signal_type);
-
-	gpio_shift = 2 * gpio;
-
-	REG_RMW(ah,
-		AR_GPIO_OE_OUT,
-		(AR_GPIO_OE_OUT_DRV_ALL << gpio_shift),
-		(AR_GPIO_OE_OUT_DRV << gpio_shift));
-}
-
-void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
-{
-	REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
-		AR_GPIO_BIT(gpio));
-}
-
-u32 ath9k_hw_getdefantenna(struct ath_hw *ah)
-{
-	return REG_READ(ah, AR_DEF_ANTENNA) & 0x7;
-}
-
-void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna)
-{
-	REG_WRITE(ah, AR_DEF_ANTENNA, (antenna & 0x7));
-}
-
-bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
-			       enum ath9k_ant_setting settings,
-			       struct ath9k_channel *chan,
-			       u8 *tx_chainmask,
-			       u8 *rx_chainmask,
-			       u8 *antenna_cfgd)
-{
-	static u8 tx_chainmask_cfg, rx_chainmask_cfg;
-
-	if (AR_SREV_9280(ah)) {
-		if (!tx_chainmask_cfg) {
-
-			tx_chainmask_cfg = *tx_chainmask;
-			rx_chainmask_cfg = *rx_chainmask;
-		}
-
-		switch (settings) {
-		case ATH9K_ANT_FIXED_A:
-			*tx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
-			*rx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
-			*antenna_cfgd = true;
-			break;
-		case ATH9K_ANT_FIXED_B:
-			if (ah->caps.tx_chainmask >
-			    ATH9K_ANTENNA1_CHAINMASK) {
-				*tx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
-			}
-			*rx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
-			*antenna_cfgd = true;
-			break;
-		case ATH9K_ANT_VARIABLE:
-			*tx_chainmask = tx_chainmask_cfg;
-			*rx_chainmask = rx_chainmask_cfg;
-			*antenna_cfgd = true;
-			break;
-		default:
-			break;
-		}
-	} else {
-		ah->config.diversity_control = settings;
-	}
-
-	return true;
-}
-
-/*********************/
-/* General Operation */
-/*********************/
-
-u32 ath9k_hw_getrxfilter(struct ath_hw *ah)
-{
-	u32 bits = REG_READ(ah, AR_RX_FILTER);
-	u32 phybits = REG_READ(ah, AR_PHY_ERR);
-
-	if (phybits & AR_PHY_ERR_RADAR)
-		bits |= ATH9K_RX_FILTER_PHYRADAR;
-	if (phybits & (AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING))
-		bits |= ATH9K_RX_FILTER_PHYERR;
-
-	return bits;
-}
-
-void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
-{
-	u32 phybits;
-
-	REG_WRITE(ah, AR_RX_FILTER, bits);
-
-	phybits = 0;
-	if (bits & ATH9K_RX_FILTER_PHYRADAR)
-		phybits |= AR_PHY_ERR_RADAR;
-	if (bits & ATH9K_RX_FILTER_PHYERR)
-		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
-	REG_WRITE(ah, AR_PHY_ERR, phybits);
-
-	if (phybits)
-		REG_WRITE(ah, AR_RXCFG,
-			  REG_READ(ah, AR_RXCFG) | AR_RXCFG_ZLFDMA);
-	else
-		REG_WRITE(ah, AR_RXCFG,
-			  REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_ZLFDMA);
-}
-
-bool ath9k_hw_phy_disable(struct ath_hw *ah)
-{
-	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM);
-}
-
-bool ath9k_hw_disable(struct ath_hw *ah)
-{
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
-		return false;
-
-	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD);
-}
-
-void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
-{
-	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	struct ath9k_channel *chan = ah->curchan;
-	struct ieee80211_channel *channel = chan->chan;
-
-	regulatory->power_limit = min(limit, (u32) MAX_RATE_POWER);
-
-	ah->eep_ops->set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(regulatory, chan),
-				 channel->max_antenna_gain * 2,
-				 channel->max_power * 2,
-				 min((u32) MAX_RATE_POWER,
-				 (u32) regulatory->power_limit));
-}
-
-void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac)
-{
-	memcpy(ath9k_hw_common(ah)->macaddr, mac, ETH_ALEN);
-}
-
-void ath9k_hw_setopmode(struct ath_hw *ah)
-{
-	ath9k_hw_set_operating_mode(ah, ah->opmode);
-}
-
-void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1)
-{
-	REG_WRITE(ah, AR_MCAST_FIL0, filter0);
-	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
-}
-
-void ath9k_hw_write_associd(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(common->curbssid));
-	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(common->curbssid + 4) |
-		  ((common->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
-}
-
-u64 ath9k_hw_gettsf64(struct ath_hw *ah)
-{
-	u64 tsf;
-
-	tsf = REG_READ(ah, AR_TSF_U32);
-	tsf = (tsf << 32) | REG_READ(ah, AR_TSF_L32);
-
-	return tsf;
-}
-
-void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64)
-{
-	REG_WRITE(ah, AR_TSF_L32, tsf64 & 0xffffffff);
-	REG_WRITE(ah, AR_TSF_U32, (tsf64 >> 32) & 0xffffffff);
-}
-
-void ath9k_hw_reset_tsf(struct ath_hw *ah)
-{
-	if (!ath9k_hw_wait(ah, AR_SLP32_MODE, AR_SLP32_TSF_WRITE_STATUS, 0,
-			   AH_TSF_WRITE_TIMEOUT))
-		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
-			  "AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
-
-	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
-}
-
-void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
-{
-	if (setting)
-		ah->misc_mode |= AR_PCU_TX_ADD_TSF;
-	else
-		ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
-}
-
-bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
-{
-	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
-			  "bad slot time %u\n", us);
-		ah->slottime = (u32) -1;
-		return false;
-	} else {
-		REG_WRITE(ah, AR_D_GBL_IFS_SLOT, ath9k_hw_mac_to_clks(ah, us));
-		ah->slottime = us;
-		return true;
-	}
-}
-
-void ath9k_hw_set11nmac2040(struct ath_hw *ah)
-{
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
-	u32 macmode;
-
-	if (conf_is_ht40(conf) && !ah->config.cwm_ignore_extcca)
-		macmode = AR_2040_JOINED_RX_CLEAR;
-	else
-		macmode = 0;
-
-	REG_WRITE(ah, AR_2040_MODE, macmode);
-}
-
-/* HW Generic timers configuration */
-
-static const struct ath_gen_timer_configuration gen_tmr_configuration[] =
-{
-	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
-	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
-	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
-	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
-	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
-	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
-	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
-	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
-	{AR_NEXT_NDP2_TIMER, AR_NDP2_PERIOD, AR_NDP2_TIMER_MODE, 0x0001},
-	{AR_NEXT_NDP2_TIMER + 1*4, AR_NDP2_PERIOD + 1*4,
-				AR_NDP2_TIMER_MODE, 0x0002},
-	{AR_NEXT_NDP2_TIMER + 2*4, AR_NDP2_PERIOD + 2*4,
-				AR_NDP2_TIMER_MODE, 0x0004},
-	{AR_NEXT_NDP2_TIMER + 3*4, AR_NDP2_PERIOD + 3*4,
-				AR_NDP2_TIMER_MODE, 0x0008},
-	{AR_NEXT_NDP2_TIMER + 4*4, AR_NDP2_PERIOD + 4*4,
-				AR_NDP2_TIMER_MODE, 0x0010},
-	{AR_NEXT_NDP2_TIMER + 5*4, AR_NDP2_PERIOD + 5*4,
-				AR_NDP2_TIMER_MODE, 0x0020},
-	{AR_NEXT_NDP2_TIMER + 6*4, AR_NDP2_PERIOD + 6*4,
-				AR_NDP2_TIMER_MODE, 0x0040},
-	{AR_NEXT_NDP2_TIMER + 7*4, AR_NDP2_PERIOD + 7*4,
-				AR_NDP2_TIMER_MODE, 0x0080}
-};
-
-/* HW generic timer primitives */
-
-/* compute and clear index of rightmost 1 */
-static u32 rightmost_index(struct ath_gen_timer_table *timer_table, u32 *mask)
-{
-	u32 b;
-
-	b = *mask;
-	b &= (0-b);
-	*mask &= ~b;
-	b *= debruijn32;
-	b >>= 27;
-
-	return timer_table->gen_timer_index[b];
-}
-
-u32 ath9k_hw_gettsf32(struct ath_hw *ah)
-{
-	return REG_READ(ah, AR_TSF_L32);
-}
-
-struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
-					  void (*trigger)(void *),
-					  void (*overflow)(void *),
-					  void *arg,
-					  u8 timer_index)
-{
-	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-	struct ath_gen_timer *timer;
-
-	timer = kzalloc(sizeof(struct ath_gen_timer), GFP_KERNEL);
-
-	if (timer == NULL) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "Failed to allocate memory"
-			  "for hw timer[%d]\n", timer_index);
-		return NULL;
-	}
-
-	/* allocate a hardware generic timer slot */
-	timer_table->timers[timer_index] = timer;
-	timer->index = timer_index;
-	timer->trigger = trigger;
-	timer->overflow = overflow;
-	timer->arg = arg;
-
-	return timer;
-}
-
-void ath9k_hw_gen_timer_start(struct ath_hw *ah,
-			      struct ath_gen_timer *timer,
-			      u32 timer_next,
-			      u32 timer_period)
-{
-	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-	u32 tsf;
-
-	BUG_ON(!timer_period);
-
-	set_bit(timer->index, &timer_table->timer_mask.timer_bits);
-
-	tsf = ath9k_hw_gettsf32(ah);
-
-	ath_print(ath9k_hw_common(ah), ATH_DBG_HWTIMER,
-		  "curent tsf %x period %x"
-		  "timer_next %x\n", tsf, timer_period, timer_next);
-
-	/*
-	 * Pull timer_next forward if the current TSF already passed it
-	 * because of software latency
-	 */
-	if (timer_next < tsf)
-		timer_next = tsf + timer_period;
-
-	/*
-	 * Program generic timer registers
-	 */
-	REG_WRITE(ah, gen_tmr_configuration[timer->index].next_addr,
-		 timer_next);
-	REG_WRITE(ah, gen_tmr_configuration[timer->index].period_addr,
-		  timer_period);
-	REG_SET_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
-		    gen_tmr_configuration[timer->index].mode_mask);
-
-	/* Enable both trigger and thresh interrupt masks */
-	REG_SET_BIT(ah, AR_IMR_S5,
-		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
-		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
-}
-
-void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
-{
-	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-
-	if ((timer->index < AR_FIRST_NDP_TIMER) ||
-		(timer->index >= ATH_MAX_GEN_TIMER)) {
-		return;
-	}
-
-	/* Clear generic timer enable bits. */
-	REG_CLR_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
-			gen_tmr_configuration[timer->index].mode_mask);
-
-	/* Disable both trigger and thresh interrupt masks */
-	REG_CLR_BIT(ah, AR_IMR_S5,
-		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
-		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
-
-	clear_bit(timer->index, &timer_table->timer_mask.timer_bits);
-}
-
-void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer)
-{
-	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-
-	/* free the hardware generic timer slot */
-	timer_table->timers[timer->index] = NULL;
-	kfree(timer);
-}
-
-/*
- * Generic Timer Interrupts handling
- */
-void ath_gen_timer_isr(struct ath_hw *ah)
-{
-	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-	struct ath_gen_timer *timer;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 trigger_mask, thresh_mask, index;
-
-	/* get hardware generic timer interrupt status */
-	trigger_mask = ah->intr_gen_timer_trigger;
-	thresh_mask = ah->intr_gen_timer_thresh;
-	trigger_mask &= timer_table->timer_mask.val;
-	thresh_mask &= timer_table->timer_mask.val;
-
-	trigger_mask &= ~thresh_mask;
-
-	while (thresh_mask) {
-		index = rightmost_index(timer_table, &thresh_mask);
-		timer = timer_table->timers[index];
-		BUG_ON(!timer);
-		ath_print(common, ATH_DBG_HWTIMER,
-			  "TSF overflow for Gen timer %d\n", index);
-		timer->overflow(timer->arg);
-	}
-
-	while (trigger_mask) {
-		index = rightmost_index(timer_table, &trigger_mask);
-		timer = timer_table->timers[index];
-		BUG_ON(!timer);
-		ath_print(common, ATH_DBG_HWTIMER,
-			  "Gen timer[%d] trigger\n", index);
-		timer->trigger(timer->arg);
-	}
-}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3223b30..d955e8a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -16,7 +16,7 @@
 
 #include <linux/nl80211.h>
 #include "ath9k.h"
-#include "btcoex.h"
+#include "../btcoex.h"
 
 static char *dev_info = "ath9k";
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a1001ff..b2a45ce 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -65,7 +65,7 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
 	struct ath_hw *ah = (struct ath_hw *) common->ah;
 
-	(void)REG_READ(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
+	common->ops->read(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
 
 	if (!ath9k_hw_wait(ah,
 			   AR_EEPROM_STATUS_DATA,
@@ -75,7 +75,7 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 		return false;
 	}
 
-	*data = MS(REG_READ(ah, AR_EEPROM_STATUS_DATA),
+	*data = MS(common->ops->read(ah, AR_EEPROM_STATUS_DATA),
 		   AR_EEPROM_STATUS_DATA_VAL);
 
 	return true;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
deleted file mode 100644
index ce12252..0000000
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ /dev/null
@@ -1,1706 +0,0 @@
-/*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef REG_H
-#define REG_H
-
-#include "../reg.h"
-
-#define AR_CR                0x0008
-#define AR_CR_RXE            0x00000004
-#define AR_CR_RXD            0x00000020
-#define AR_CR_SWI            0x00000040
-
-#define AR_RXDP              0x000C
-
-#define AR_CFG               0x0014
-#define AR_CFG_SWTD          0x00000001
-#define AR_CFG_SWTB          0x00000002
-#define AR_CFG_SWRD          0x00000004
-#define AR_CFG_SWRB          0x00000008
-#define AR_CFG_SWRG          0x00000010
-#define AR_CFG_AP_ADHOC_INDICATION 0x00000020
-#define AR_CFG_PHOK          0x00000100
-#define AR_CFG_CLK_GATE_DIS  0x00000400
-#define AR_CFG_EEBS          0x00000200
-#define AR_CFG_PCI_MASTER_REQ_Q_THRESH         0x00060000
-#define AR_CFG_PCI_MASTER_REQ_Q_THRESH_S       17
-
-#define AR_MIRT              0x0020
-#define AR_MIRT_VAL          0x0000ffff
-#define AR_MIRT_VAL_S        16
-
-#define AR_IER               0x0024
-#define AR_IER_ENABLE        0x00000001
-#define AR_IER_DISABLE       0x00000000
-
-#define AR_TIMT              0x0028
-#define AR_TIMT_LAST         0x0000ffff
-#define AR_TIMT_LAST_S       0
-#define AR_TIMT_FIRST        0xffff0000
-#define AR_TIMT_FIRST_S      16
-
-#define AR_RIMT              0x002C
-#define AR_RIMT_LAST         0x0000ffff
-#define AR_RIMT_LAST_S       0
-#define AR_RIMT_FIRST        0xffff0000
-#define AR_RIMT_FIRST_S      16
-
-#define AR_DMASIZE_4B        0x00000000
-#define AR_DMASIZE_8B        0x00000001
-#define AR_DMASIZE_16B       0x00000002
-#define AR_DMASIZE_32B       0x00000003
-#define AR_DMASIZE_64B       0x00000004
-#define AR_DMASIZE_128B      0x00000005
-#define AR_DMASIZE_256B      0x00000006
-#define AR_DMASIZE_512B      0x00000007
-
-#define AR_TXCFG             0x0030
-#define AR_TXCFG_DMASZ_MASK  0x00000007
-#define AR_TXCFG_DMASZ_4B    0
-#define AR_TXCFG_DMASZ_8B    1
-#define AR_TXCFG_DMASZ_16B   2
-#define AR_TXCFG_DMASZ_32B   3
-#define AR_TXCFG_DMASZ_64B   4
-#define AR_TXCFG_DMASZ_128B  5
-#define AR_TXCFG_DMASZ_256B  6
-#define AR_TXCFG_DMASZ_512B  7
-#define AR_FTRIG             0x000003F0
-#define AR_FTRIG_S           4
-#define AR_FTRIG_IMMED       0x00000000
-#define AR_FTRIG_64B         0x00000010
-#define AR_FTRIG_128B        0x00000020
-#define AR_FTRIG_192B        0x00000030
-#define AR_FTRIG_256B        0x00000040
-#define AR_FTRIG_512B        0x00000080
-#define AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY 0x00000800
-
-#define AR_RXCFG             0x0034
-#define AR_RXCFG_CHIRP       0x00000008
-#define AR_RXCFG_ZLFDMA      0x00000010
-#define AR_RXCFG_DMASZ_MASK  0x00000007
-#define AR_RXCFG_DMASZ_4B    0
-#define AR_RXCFG_DMASZ_8B    1
-#define AR_RXCFG_DMASZ_16B   2
-#define AR_RXCFG_DMASZ_32B   3
-#define AR_RXCFG_DMASZ_64B   4
-#define AR_RXCFG_DMASZ_128B  5
-#define AR_RXCFG_DMASZ_256B  6
-#define AR_RXCFG_DMASZ_512B  7
-
-#define AR_MIBC              0x0040
-#define AR_MIBC_COW          0x00000001
-#define AR_MIBC_FMC          0x00000002
-#define AR_MIBC_CMC          0x00000004
-#define AR_MIBC_MCS          0x00000008
-
-#define AR_TOPS              0x0044
-#define AR_TOPS_MASK         0x0000FFFF
-
-#define AR_RXNPTO            0x0048
-#define AR_RXNPTO_MASK       0x000003FF
-
-#define AR_TXNPTO            0x004C
-#define AR_TXNPTO_MASK       0x000003FF
-#define AR_TXNPTO_QCU_MASK   0x000FFC00
-
-#define AR_RPGTO             0x0050
-#define AR_RPGTO_MASK        0x000003FF
-
-#define AR_RPCNT             0x0054
-#define AR_RPCNT_MASK        0x0000001F
-
-#define AR_MACMISC           0x0058
-#define AR_MACMISC_PCI_EXT_FORCE        0x00000010
-#define AR_MACMISC_DMA_OBS              0x000001E0
-#define AR_MACMISC_DMA_OBS_S            5
-#define AR_MACMISC_DMA_OBS_LINE_0       0
-#define AR_MACMISC_DMA_OBS_LINE_1       1
-#define AR_MACMISC_DMA_OBS_LINE_2       2
-#define AR_MACMISC_DMA_OBS_LINE_3       3
-#define AR_MACMISC_DMA_OBS_LINE_4       4
-#define AR_MACMISC_DMA_OBS_LINE_5       5
-#define AR_MACMISC_DMA_OBS_LINE_6       6
-#define AR_MACMISC_DMA_OBS_LINE_7       7
-#define AR_MACMISC_DMA_OBS_LINE_8       8
-#define AR_MACMISC_MISC_OBS             0x00000E00
-#define AR_MACMISC_MISC_OBS_S           9
-#define AR_MACMISC_MISC_OBS_BUS_LSB     0x00007000
-#define AR_MACMISC_MISC_OBS_BUS_LSB_S   12
-#define AR_MACMISC_MISC_OBS_BUS_MSB     0x00038000
-#define AR_MACMISC_MISC_OBS_BUS_MSB_S   15
-#define AR_MACMISC_MISC_OBS_BUS_1       1
-
-#define AR_GTXTO    0x0064
-#define AR_GTXTO_TIMEOUT_COUNTER    0x0000FFFF
-#define AR_GTXTO_TIMEOUT_LIMIT      0xFFFF0000
-#define AR_GTXTO_TIMEOUT_LIMIT_S    16
-
-#define AR_GTTM     0x0068
-#define AR_GTTM_USEC          0x00000001
-#define AR_GTTM_IGNORE_IDLE   0x00000002
-#define AR_GTTM_RESET_IDLE    0x00000004
-#define AR_GTTM_CST_USEC      0x00000008
-
-#define AR_CST         0x006C
-#define AR_CST_TIMEOUT_COUNTER    0x0000FFFF
-#define AR_CST_TIMEOUT_LIMIT      0xFFFF0000
-#define AR_CST_TIMEOUT_LIMIT_S    16
-
-#define AR_ISR               0x0080
-#define AR_ISR_RXOK          0x00000001
-#define AR_ISR_RXDESC        0x00000002
-#define AR_ISR_RXERR         0x00000004
-#define AR_ISR_RXNOPKT       0x00000008
-#define AR_ISR_RXEOL         0x00000010
-#define AR_ISR_RXORN         0x00000020
-#define AR_ISR_TXOK          0x00000040
-#define AR_ISR_TXDESC        0x00000080
-#define AR_ISR_TXERR         0x00000100
-#define AR_ISR_TXNOPKT       0x00000200
-#define AR_ISR_TXEOL         0x00000400
-#define AR_ISR_TXURN         0x00000800
-#define AR_ISR_MIB           0x00001000
-#define AR_ISR_SWI           0x00002000
-#define AR_ISR_RXPHY         0x00004000
-#define AR_ISR_RXKCM         0x00008000
-#define AR_ISR_SWBA          0x00010000
-#define AR_ISR_BRSSI         0x00020000
-#define AR_ISR_BMISS         0x00040000
-#define AR_ISR_BNR           0x00100000
-#define AR_ISR_RXCHIRP       0x00200000
-#define AR_ISR_BCNMISC       0x00800000
-#define AR_ISR_TIM           0x00800000
-#define AR_ISR_QCBROVF       0x02000000
-#define AR_ISR_QCBRURN       0x04000000
-#define AR_ISR_QTRIG         0x08000000
-#define AR_ISR_GENTMR        0x10000000
-
-#define AR_ISR_TXMINTR       0x00080000
-#define AR_ISR_RXMINTR       0x01000000
-#define AR_ISR_TXINTM        0x40000000
-#define AR_ISR_RXINTM        0x80000000
-
-#define AR_ISR_S0               0x0084
-#define AR_ISR_S0_QCU_TXOK      0x000003FF
-#define AR_ISR_S0_QCU_TXOK_S    0
-#define AR_ISR_S0_QCU_TXDESC    0x03FF0000
-#define AR_ISR_S0_QCU_TXDESC_S  16
-
-#define AR_ISR_S1              0x0088
-#define AR_ISR_S1_QCU_TXERR    0x000003FF
-#define AR_ISR_S1_QCU_TXERR_S  0
-#define AR_ISR_S1_QCU_TXEOL    0x03FF0000
-#define AR_ISR_S1_QCU_TXEOL_S  16
-
-#define AR_ISR_S2              0x008c
-#define AR_ISR_S2_QCU_TXURN    0x000003FF
-#define AR_ISR_S2_CST          0x00400000
-#define AR_ISR_S2_GTT          0x00800000
-#define AR_ISR_S2_TIM          0x01000000
-#define AR_ISR_S2_CABEND       0x02000000
-#define AR_ISR_S2_DTIMSYNC     0x04000000
-#define AR_ISR_S2_BCNTO        0x08000000
-#define AR_ISR_S2_CABTO        0x10000000
-#define AR_ISR_S2_DTIM         0x20000000
-#define AR_ISR_S2_TSFOOR       0x40000000
-#define AR_ISR_S2_TBTT_TIME    0x80000000
-
-#define AR_ISR_S3             0x0090
-#define AR_ISR_S3_QCU_QCBROVF    0x000003FF
-#define AR_ISR_S3_QCU_QCBRURN    0x03FF0000
-
-#define AR_ISR_S4              0x0094
-#define AR_ISR_S4_QCU_QTRIG    0x000003FF
-#define AR_ISR_S4_RESV0        0xFFFFFC00
-
-#define AR_ISR_S5                   0x0098
-#define AR_ISR_S5_TIMER_TRIG        0x000000FF
-#define AR_ISR_S5_TIMER_THRESH      0x0007FE00
-#define AR_ISR_S5_TIM_TIMER         0x00000010
-#define AR_ISR_S5_DTIM_TIMER        0x00000020
-#define AR_ISR_S5_S                 0x00d8
-#define AR_IMR_S5                   0x00b8
-#define AR_IMR_S5_TIM_TIMER         0x00000010
-#define AR_IMR_S5_DTIM_TIMER        0x00000020
-#define AR_ISR_S5_GENTIMER_TRIG     0x0000FF80
-#define AR_ISR_S5_GENTIMER_TRIG_S   0
-#define AR_ISR_S5_GENTIMER_THRESH   0xFF800000
-#define AR_ISR_S5_GENTIMER_THRESH_S 16
-#define AR_ISR_S5_S                 0x00d8
-#define AR_IMR_S5_GENTIMER_TRIG     0x0000FF80
-#define AR_IMR_S5_GENTIMER_TRIG_S   0
-#define AR_IMR_S5_GENTIMER_THRESH   0xFF800000
-#define AR_IMR_S5_GENTIMER_THRESH_S 16
-
-#define AR_IMR               0x00a0
-#define AR_IMR_RXOK          0x00000001
-#define AR_IMR_RXDESC        0x00000002
-#define AR_IMR_RXERR         0x00000004
-#define AR_IMR_RXNOPKT       0x00000008
-#define AR_IMR_RXEOL         0x00000010
-#define AR_IMR_RXORN         0x00000020
-#define AR_IMR_TXOK          0x00000040
-#define AR_IMR_TXDESC        0x00000080
-#define AR_IMR_TXERR         0x00000100
-#define AR_IMR_TXNOPKT       0x00000200
-#define AR_IMR_TXEOL         0x00000400
-#define AR_IMR_TXURN         0x00000800
-#define AR_IMR_MIB           0x00001000
-#define AR_IMR_SWI           0x00002000
-#define AR_IMR_RXPHY         0x00004000
-#define AR_IMR_RXKCM         0x00008000
-#define AR_IMR_SWBA          0x00010000
-#define AR_IMR_BRSSI         0x00020000
-#define AR_IMR_BMISS         0x00040000
-#define AR_IMR_BNR           0x00100000
-#define AR_IMR_RXCHIRP       0x00200000
-#define AR_IMR_BCNMISC       0x00800000
-#define AR_IMR_TIM           0x00800000
-#define AR_IMR_QCBROVF       0x02000000
-#define AR_IMR_QCBRURN       0x04000000
-#define AR_IMR_QTRIG         0x08000000
-#define AR_IMR_GENTMR        0x10000000
-
-#define AR_IMR_TXMINTR       0x00080000
-#define AR_IMR_RXMINTR       0x01000000
-#define AR_IMR_TXINTM        0x40000000
-#define AR_IMR_RXINTM        0x80000000
-
-#define AR_IMR_S0               0x00a4
-#define AR_IMR_S0_QCU_TXOK      0x000003FF
-#define AR_IMR_S0_QCU_TXOK_S    0
-#define AR_IMR_S0_QCU_TXDESC    0x03FF0000
-#define AR_IMR_S0_QCU_TXDESC_S  16
-
-#define AR_IMR_S1              0x00a8
-#define AR_IMR_S1_QCU_TXERR    0x000003FF
-#define AR_IMR_S1_QCU_TXERR_S  0
-#define AR_IMR_S1_QCU_TXEOL    0x03FF0000
-#define AR_IMR_S1_QCU_TXEOL_S  16
-
-#define AR_IMR_S2              0x00ac
-#define AR_IMR_S2_QCU_TXURN    0x000003FF
-#define AR_IMR_S2_QCU_TXURN_S  0
-#define AR_IMR_S2_CST          0x00400000
-#define AR_IMR_S2_GTT          0x00800000
-#define AR_IMR_S2_TIM          0x01000000
-#define AR_IMR_S2_CABEND       0x02000000
-#define AR_IMR_S2_DTIMSYNC     0x04000000
-#define AR_IMR_S2_BCNTO        0x08000000
-#define AR_IMR_S2_CABTO        0x10000000
-#define AR_IMR_S2_DTIM         0x20000000
-#define AR_IMR_S2_TSFOOR       0x40000000
-
-#define AR_IMR_S3                0x00b0
-#define AR_IMR_S3_QCU_QCBROVF    0x000003FF
-#define AR_IMR_S3_QCU_QCBRURN    0x03FF0000
-#define AR_IMR_S3_QCU_QCBRURN_S  16
-
-#define AR_IMR_S4              0x00b4
-#define AR_IMR_S4_QCU_QTRIG    0x000003FF
-#define AR_IMR_S4_RESV0        0xFFFFFC00
-
-#define AR_IMR_S5              0x00b8
-#define AR_IMR_S5_TIMER_TRIG        0x000000FF
-#define AR_IMR_S5_TIMER_THRESH      0x0000FF00
-
-
-#define AR_ISR_RAC            0x00c0
-#define AR_ISR_S0_S           0x00c4
-#define AR_ISR_S0_QCU_TXOK      0x000003FF
-#define AR_ISR_S0_QCU_TXOK_S    0
-#define AR_ISR_S0_QCU_TXDESC    0x03FF0000
-#define AR_ISR_S0_QCU_TXDESC_S  16
-
-#define AR_ISR_S1_S           0x00c8
-#define AR_ISR_S1_QCU_TXERR    0x000003FF
-#define AR_ISR_S1_QCU_TXERR_S  0
-#define AR_ISR_S1_QCU_TXEOL    0x03FF0000
-#define AR_ISR_S1_QCU_TXEOL_S  16
-
-#define AR_ISR_S2_S           0x00cc
-#define AR_ISR_S3_S           0x00d0
-#define AR_ISR_S4_S           0x00d4
-#define AR_ISR_S5_S           0x00d8
-#define AR_DMADBG_0           0x00e0
-#define AR_DMADBG_1           0x00e4
-#define AR_DMADBG_2           0x00e8
-#define AR_DMADBG_3           0x00ec
-#define AR_DMADBG_4           0x00f0
-#define AR_DMADBG_5           0x00f4
-#define AR_DMADBG_6           0x00f8
-#define AR_DMADBG_7           0x00fc
-
-#define AR_NUM_QCU      10
-#define AR_QCU_0        0x0001
-#define AR_QCU_1        0x0002
-#define AR_QCU_2        0x0004
-#define AR_QCU_3        0x0008
-#define AR_QCU_4        0x0010
-#define AR_QCU_5        0x0020
-#define AR_QCU_6        0x0040
-#define AR_QCU_7        0x0080
-#define AR_QCU_8        0x0100
-#define AR_QCU_9        0x0200
-
-#define AR_Q0_TXDP           0x0800
-#define AR_Q1_TXDP           0x0804
-#define AR_Q2_TXDP           0x0808
-#define AR_Q3_TXDP           0x080c
-#define AR_Q4_TXDP           0x0810
-#define AR_Q5_TXDP           0x0814
-#define AR_Q6_TXDP           0x0818
-#define AR_Q7_TXDP           0x081c
-#define AR_Q8_TXDP           0x0820
-#define AR_Q9_TXDP           0x0824
-#define AR_QTXDP(_i)    (AR_Q0_TXDP + ((_i)<<2))
-
-#define AR_Q_TXE             0x0840
-#define AR_Q_TXE_M           0x000003FF
-
-#define AR_Q_TXD             0x0880
-#define AR_Q_TXD_M           0x000003FF
-
-#define AR_Q0_CBRCFG         0x08c0
-#define AR_Q1_CBRCFG         0x08c4
-#define AR_Q2_CBRCFG         0x08c8
-#define AR_Q3_CBRCFG         0x08cc
-#define AR_Q4_CBRCFG         0x08d0
-#define AR_Q5_CBRCFG         0x08d4
-#define AR_Q6_CBRCFG         0x08d8
-#define AR_Q7_CBRCFG         0x08dc
-#define AR_Q8_CBRCFG         0x08e0
-#define AR_Q9_CBRCFG         0x08e4
-#define AR_QCBRCFG(_i)      (AR_Q0_CBRCFG + ((_i)<<2))
-#define AR_Q_CBRCFG_INTERVAL     0x00FFFFFF
-#define AR_Q_CBRCFG_INTERVAL_S   0
-#define AR_Q_CBRCFG_OVF_THRESH   0xFF000000
-#define AR_Q_CBRCFG_OVF_THRESH_S 24
-
-#define AR_Q0_RDYTIMECFG         0x0900
-#define AR_Q1_RDYTIMECFG         0x0904
-#define AR_Q2_RDYTIMECFG         0x0908
-#define AR_Q3_RDYTIMECFG         0x090c
-#define AR_Q4_RDYTIMECFG         0x0910
-#define AR_Q5_RDYTIMECFG         0x0914
-#define AR_Q6_RDYTIMECFG         0x0918
-#define AR_Q7_RDYTIMECFG         0x091c
-#define AR_Q8_RDYTIMECFG         0x0920
-#define AR_Q9_RDYTIMECFG         0x0924
-#define AR_QRDYTIMECFG(_i)       (AR_Q0_RDYTIMECFG + ((_i)<<2))
-#define AR_Q_RDYTIMECFG_DURATION   0x00FFFFFF
-#define AR_Q_RDYTIMECFG_DURATION_S 0
-#define AR_Q_RDYTIMECFG_EN         0x01000000
-
-#define AR_Q_ONESHOTARM_SC       0x0940
-#define AR_Q_ONESHOTARM_SC_M     0x000003FF
-#define AR_Q_ONESHOTARM_SC_RESV0 0xFFFFFC00
-
-#define AR_Q_ONESHOTARM_CC       0x0980
-#define AR_Q_ONESHOTARM_CC_M     0x000003FF
-#define AR_Q_ONESHOTARM_CC_RESV0 0xFFFFFC00
-
-#define AR_Q0_MISC         0x09c0
-#define AR_Q1_MISC         0x09c4
-#define AR_Q2_MISC         0x09c8
-#define AR_Q3_MISC         0x09cc
-#define AR_Q4_MISC         0x09d0
-#define AR_Q5_MISC         0x09d4
-#define AR_Q6_MISC         0x09d8
-#define AR_Q7_MISC         0x09dc
-#define AR_Q8_MISC         0x09e0
-#define AR_Q9_MISC         0x09e4
-#define AR_QMISC(_i)       (AR_Q0_MISC + ((_i)<<2))
-#define AR_Q_MISC_FSP                     0x0000000F
-#define AR_Q_MISC_FSP_ASAP                0
-#define AR_Q_MISC_FSP_CBR                 1
-#define AR_Q_MISC_FSP_DBA_GATED           2
-#define AR_Q_MISC_FSP_TIM_GATED           3
-#define AR_Q_MISC_FSP_BEACON_SENT_GATED   4
-#define AR_Q_MISC_FSP_BEACON_RCVD_GATED   5
-#define AR_Q_MISC_ONE_SHOT_EN             0x00000010
-#define AR_Q_MISC_CBR_INCR_DIS1           0x00000020
-#define AR_Q_MISC_CBR_INCR_DIS0           0x00000040
-#define AR_Q_MISC_BEACON_USE              0x00000080
-#define AR_Q_MISC_CBR_EXP_CNTR_LIMIT_EN   0x00000100
-#define AR_Q_MISC_RDYTIME_EXP_POLICY      0x00000200
-#define AR_Q_MISC_RESET_CBR_EXP_CTR       0x00000400
-#define AR_Q_MISC_DCU_EARLY_TERM_REQ      0x00000800
-#define AR_Q_MISC_RESV0                   0xFFFFF000
-
-#define AR_Q0_STS         0x0a00
-#define AR_Q1_STS         0x0a04
-#define AR_Q2_STS         0x0a08
-#define AR_Q3_STS         0x0a0c
-#define AR_Q4_STS         0x0a10
-#define AR_Q5_STS         0x0a14
-#define AR_Q6_STS         0x0a18
-#define AR_Q7_STS         0x0a1c
-#define AR_Q8_STS         0x0a20
-#define AR_Q9_STS         0x0a24
-#define AR_QSTS(_i)       (AR_Q0_STS + ((_i)<<2))
-#define AR_Q_STS_PEND_FR_CNT          0x00000003
-#define AR_Q_STS_RESV0                0x000000FC
-#define AR_Q_STS_CBR_EXP_CNT          0x0000FF00
-#define AR_Q_STS_RESV1                0xFFFF0000
-
-#define AR_Q_RDYTIMESHDN    0x0a40
-#define AR_Q_RDYTIMESHDN_M  0x000003FF
-
-
-#define AR_NUM_DCU      10
-#define AR_DCU_0        0x0001
-#define AR_DCU_1        0x0002
-#define AR_DCU_2        0x0004
-#define AR_DCU_3        0x0008
-#define AR_DCU_4        0x0010
-#define AR_DCU_5        0x0020
-#define AR_DCU_6        0x0040
-#define AR_DCU_7        0x0080
-#define AR_DCU_8        0x0100
-#define AR_DCU_9        0x0200
-
-#define AR_D0_QCUMASK     0x1000
-#define AR_D1_QCUMASK     0x1004
-#define AR_D2_QCUMASK     0x1008
-#define AR_D3_QCUMASK     0x100c
-#define AR_D4_QCUMASK     0x1010
-#define AR_D5_QCUMASK     0x1014
-#define AR_D6_QCUMASK     0x1018
-#define AR_D7_QCUMASK     0x101c
-#define AR_D8_QCUMASK     0x1020
-#define AR_D9_QCUMASK     0x1024
-#define AR_DQCUMASK(_i)   (AR_D0_QCUMASK + ((_i)<<2))
-#define AR_D_QCUMASK         0x000003FF
-#define AR_D_QCUMASK_RESV0   0xFFFFFC00
-
-#define AR_D_TXBLK_CMD  0x1038
-#define AR_D_TXBLK_DATA(i) (AR_D_TXBLK_CMD+(i))
-
-#define AR_D0_LCL_IFS     0x1040
-#define AR_D1_LCL_IFS     0x1044
-#define AR_D2_LCL_IFS     0x1048
-#define AR_D3_LCL_IFS     0x104c
-#define AR_D4_LCL_IFS     0x1050
-#define AR_D5_LCL_IFS     0x1054
-#define AR_D6_LCL_IFS     0x1058
-#define AR_D7_LCL_IFS     0x105c
-#define AR_D8_LCL_IFS     0x1060
-#define AR_D9_LCL_IFS     0x1064
-#define AR_DLCL_IFS(_i)   (AR_D0_LCL_IFS + ((_i)<<2))
-#define AR_D_LCL_IFS_CWMIN       0x000003FF
-#define AR_D_LCL_IFS_CWMIN_S     0
-#define AR_D_LCL_IFS_CWMAX       0x000FFC00
-#define AR_D_LCL_IFS_CWMAX_S     10
-#define AR_D_LCL_IFS_AIFS        0x0FF00000
-#define AR_D_LCL_IFS_AIFS_S      20
-
-#define AR_D_LCL_IFS_RESV0    0xF0000000
-
-#define AR_D0_RETRY_LIMIT     0x1080
-#define AR_D1_RETRY_LIMIT     0x1084
-#define AR_D2_RETRY_LIMIT     0x1088
-#define AR_D3_RETRY_LIMIT     0x108c
-#define AR_D4_RETRY_LIMIT     0x1090
-#define AR_D5_RETRY_LIMIT     0x1094
-#define AR_D6_RETRY_LIMIT     0x1098
-#define AR_D7_RETRY_LIMIT     0x109c
-#define AR_D8_RETRY_LIMIT     0x10a0
-#define AR_D9_RETRY_LIMIT     0x10a4
-#define AR_DRETRY_LIMIT(_i)   (AR_D0_RETRY_LIMIT + ((_i)<<2))
-#define AR_D_RETRY_LIMIT_FR_SH       0x0000000F
-#define AR_D_RETRY_LIMIT_FR_SH_S     0
-#define AR_D_RETRY_LIMIT_STA_SH      0x00003F00
-#define AR_D_RETRY_LIMIT_STA_SH_S    8
-#define AR_D_RETRY_LIMIT_STA_LG      0x000FC000
-#define AR_D_RETRY_LIMIT_STA_LG_S    14
-#define AR_D_RETRY_LIMIT_RESV0       0xFFF00000
-
-#define AR_D0_CHNTIME     0x10c0
-#define AR_D1_CHNTIME     0x10c4
-#define AR_D2_CHNTIME     0x10c8
-#define AR_D3_CHNTIME     0x10cc
-#define AR_D4_CHNTIME     0x10d0
-#define AR_D5_CHNTIME     0x10d4
-#define AR_D6_CHNTIME     0x10d8
-#define AR_D7_CHNTIME     0x10dc
-#define AR_D8_CHNTIME     0x10e0
-#define AR_D9_CHNTIME     0x10e4
-#define AR_DCHNTIME(_i)   (AR_D0_CHNTIME + ((_i)<<2))
-#define AR_D_CHNTIME_DUR         0x000FFFFF
-#define AR_D_CHNTIME_DUR_S       0
-#define AR_D_CHNTIME_EN          0x00100000
-#define AR_D_CHNTIME_RESV0       0xFFE00000
-
-#define AR_D0_MISC        0x1100
-#define AR_D1_MISC        0x1104
-#define AR_D2_MISC        0x1108
-#define AR_D3_MISC        0x110c
-#define AR_D4_MISC        0x1110
-#define AR_D5_MISC        0x1114
-#define AR_D6_MISC        0x1118
-#define AR_D7_MISC        0x111c
-#define AR_D8_MISC        0x1120
-#define AR_D9_MISC        0x1124
-#define AR_DMISC(_i)      (AR_D0_MISC + ((_i)<<2))
-#define AR_D_MISC_BKOFF_THRESH        0x0000003F
-#define AR_D_MISC_RETRY_CNT_RESET_EN  0x00000040
-#define AR_D_MISC_CW_RESET_EN         0x00000080
-#define AR_D_MISC_FRAG_WAIT_EN        0x00000100
-#define AR_D_MISC_FRAG_BKOFF_EN       0x00000200
-#define AR_D_MISC_CW_BKOFF_EN         0x00001000
-#define AR_D_MISC_VIR_COL_HANDLING    0x0000C000
-#define AR_D_MISC_VIR_COL_HANDLING_S  14
-#define AR_D_MISC_VIR_COL_HANDLING_DEFAULT 0
-#define AR_D_MISC_VIR_COL_HANDLING_IGNORE  1
-#define AR_D_MISC_BEACON_USE          0x00010000
-#define AR_D_MISC_ARB_LOCKOUT_CNTRL   0x00060000
-#define AR_D_MISC_ARB_LOCKOUT_CNTRL_S 17
-#define AR_D_MISC_ARB_LOCKOUT_CNTRL_NONE     0
-#define AR_D_MISC_ARB_LOCKOUT_CNTRL_INTRA_FR 1
-#define AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL   2
-#define AR_D_MISC_ARB_LOCKOUT_IGNORE  0x00080000
-#define AR_D_MISC_SEQ_NUM_INCR_DIS    0x00100000
-#define AR_D_MISC_POST_FR_BKOFF_DIS   0x00200000
-#define AR_D_MISC_VIT_COL_CW_BKOFF_EN 0x00400000
-#define AR_D_MISC_BLOWN_IFS_RETRY_EN  0x00800000
-#define AR_D_MISC_RESV0               0xFF000000
-
-#define AR_D_SEQNUM      0x1140
-
-#define AR_D_GBL_IFS_SIFS         0x1030
-#define AR_D_GBL_IFS_SIFS_M       0x0000FFFF
-#define AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR 0x000003AB
-#define AR_D_GBL_IFS_SIFS_RESV0   0xFFFFFFFF
-
-#define AR_D_TXBLK_BASE            0x1038
-#define AR_D_TXBLK_WRITE_BITMASK    0x0000FFFF
-#define AR_D_TXBLK_WRITE_BITMASK_S  0
-#define AR_D_TXBLK_WRITE_SLICE      0x000F0000
-#define AR_D_TXBLK_WRITE_SLICE_S    16
-#define AR_D_TXBLK_WRITE_DCU        0x00F00000
-#define AR_D_TXBLK_WRITE_DCU_S      20
-#define AR_D_TXBLK_WRITE_COMMAND    0x0F000000
-#define AR_D_TXBLK_WRITE_COMMAND_S      24
-
-#define AR_D_GBL_IFS_SLOT         0x1070
-#define AR_D_GBL_IFS_SLOT_M       0x0000FFFF
-#define AR_D_GBL_IFS_SLOT_RESV0   0xFFFF0000
-#define AR_D_GBL_IFS_SLOT_ASYNC_FIFO_DUR   0x00000420
-
-#define AR_D_GBL_IFS_EIFS         0x10b0
-#define AR_D_GBL_IFS_EIFS_M       0x0000FFFF
-#define AR_D_GBL_IFS_EIFS_RESV0   0xFFFF0000
-#define AR_D_GBL_IFS_EIFS_ASYNC_FIFO_DUR   0x0000A5EB
-
-#define AR_D_GBL_IFS_MISC        0x10f0
-#define AR_D_GBL_IFS_MISC_LFSR_SLICE_SEL        0x00000007
-#define AR_D_GBL_IFS_MISC_TURBO_MODE            0x00000008
-#define AR_D_GBL_IFS_MISC_USEC_DURATION         0x000FFC00
-#define AR_D_GBL_IFS_MISC_DCU_ARBITER_DLY       0x00300000
-#define AR_D_GBL_IFS_MISC_RANDOM_LFSR_SLICE_DIS 0x01000000
-#define AR_D_GBL_IFS_MISC_SLOT_XMIT_WIND_LEN    0x06000000
-#define AR_D_GBL_IFS_MISC_FORCE_XMIT_SLOT_BOUND 0x08000000
-#define AR_D_GBL_IFS_MISC_IGNORE_BACKOFF        0x10000000
-
-#define AR_D_FPCTL                  0x1230
-#define AR_D_FPCTL_DCU              0x0000000F
-#define AR_D_FPCTL_DCU_S            0
-#define AR_D_FPCTL_PREFETCH_EN      0x00000010
-#define AR_D_FPCTL_BURST_PREFETCH   0x00007FE0
-#define AR_D_FPCTL_BURST_PREFETCH_S 5
-
-#define AR_D_TXPSE                 0x1270
-#define AR_D_TXPSE_CTRL            0x000003FF
-#define AR_D_TXPSE_RESV0           0x0000FC00
-#define AR_D_TXPSE_STATUS          0x00010000
-#define AR_D_TXPSE_RESV1           0xFFFE0000
-
-#define AR_D_TXSLOTMASK            0x12f0
-#define AR_D_TXSLOTMASK_NUM        0x0000000F
-
-#define AR_CFG_LED                     0x1f04
-#define AR_CFG_SCLK_RATE_IND           0x00000003
-#define AR_CFG_SCLK_RATE_IND_S         0
-#define AR_CFG_SCLK_32MHZ              0x00000000
-#define AR_CFG_SCLK_4MHZ               0x00000001
-#define AR_CFG_SCLK_1MHZ               0x00000002
-#define AR_CFG_SCLK_32KHZ              0x00000003
-#define AR_CFG_LED_BLINK_SLOW          0x00000008
-#define AR_CFG_LED_BLINK_THRESH_SEL    0x00000070
-#define AR_CFG_LED_MODE_SEL            0x00000380
-#define AR_CFG_LED_MODE_SEL_S          7
-#define AR_CFG_LED_POWER               0x00000280
-#define AR_CFG_LED_POWER_S             7
-#define AR_CFG_LED_NETWORK             0x00000300
-#define AR_CFG_LED_NETWORK_S           7
-#define AR_CFG_LED_MODE_PROP           0x0
-#define AR_CFG_LED_MODE_RPROP          0x1
-#define AR_CFG_LED_MODE_SPLIT          0x2
-#define AR_CFG_LED_MODE_RAND           0x3
-#define AR_CFG_LED_MODE_POWER_OFF      0x4
-#define AR_CFG_LED_MODE_POWER_ON       0x5
-#define AR_CFG_LED_MODE_NETWORK_OFF    0x4
-#define AR_CFG_LED_MODE_NETWORK_ON     0x6
-#define AR_CFG_LED_ASSOC_CTL           0x00000c00
-#define AR_CFG_LED_ASSOC_CTL_S         10
-#define AR_CFG_LED_ASSOC_NONE          0x0
-#define AR_CFG_LED_ASSOC_ACTIVE        0x1
-#define AR_CFG_LED_ASSOC_PENDING       0x2
-
-#define AR_CFG_LED_BLINK_SLOW          0x00000008
-#define AR_CFG_LED_BLINK_SLOW_S        3
-
-#define AR_CFG_LED_BLINK_THRESH_SEL    0x00000070
-#define AR_CFG_LED_BLINK_THRESH_SEL_S  4
-
-#define AR_MAC_SLEEP                0x1f00
-#define AR_MAC_SLEEP_MAC_AWAKE      0x00000000
-#define AR_MAC_SLEEP_MAC_ASLEEP     0x00000001
-
-#define AR_RC                0x4000
-#define AR_RC_AHB            0x00000001
-#define AR_RC_APB            0x00000002
-#define AR_RC_HOSTIF         0x00000100
-
-#define AR_WA                		0x4004
-#define AR9285_WA_DEFAULT 		0x004a05cb
-#define AR9280_WA_DEFAULT           	0x0040073f
-#define AR_WA_DEFAULT               	0x0000073f
-
-
-#define AR_PM_STATE                 0x4008
-#define AR_PM_STATE_PME_D3COLD_VAUX 0x00100000
-
-#define AR_HOST_TIMEOUT             0x4018
-#define AR_HOST_TIMEOUT_APB_CNTR    0x0000FFFF
-#define AR_HOST_TIMEOUT_APB_CNTR_S  0
-#define AR_HOST_TIMEOUT_LCL_CNTR    0xFFFF0000
-#define AR_HOST_TIMEOUT_LCL_CNTR_S  16
-
-#define AR_EEPROM                0x401c
-#define AR_EEPROM_ABSENT         0x00000100
-#define AR_EEPROM_CORRUPT        0x00000200
-#define AR_EEPROM_PROT_MASK      0x03FFFC00
-#define AR_EEPROM_PROT_MASK_S    10
-
-#define EEPROM_PROTECT_RP_0_31        0x0001
-#define EEPROM_PROTECT_WP_0_31        0x0002
-#define EEPROM_PROTECT_RP_32_63       0x0004
-#define EEPROM_PROTECT_WP_32_63       0x0008
-#define EEPROM_PROTECT_RP_64_127      0x0010
-#define EEPROM_PROTECT_WP_64_127      0x0020
-#define EEPROM_PROTECT_RP_128_191     0x0040
-#define EEPROM_PROTECT_WP_128_191     0x0080
-#define EEPROM_PROTECT_RP_192_255     0x0100
-#define EEPROM_PROTECT_WP_192_255     0x0200
-#define EEPROM_PROTECT_RP_256_511     0x0400
-#define EEPROM_PROTECT_WP_256_511     0x0800
-#define EEPROM_PROTECT_RP_512_1023    0x1000
-#define EEPROM_PROTECT_WP_512_1023    0x2000
-#define EEPROM_PROTECT_RP_1024_2047   0x4000
-#define EEPROM_PROTECT_WP_1024_2047   0x8000
-
-#define AR_SREV \
-	((AR_SREV_9100(ah)) ? 0x0600 : 0x4020)
-
-#define AR_SREV_ID \
-	((AR_SREV_9100(ah)) ? 0x00000FFF : 0x000000FF)
-#define AR_SREV_VERSION                       0x000000F0
-#define AR_SREV_VERSION_S                     4
-#define AR_SREV_REVISION                      0x00000007
-
-#define AR_SREV_ID2                           0xFFFFFFFF
-#define AR_SREV_VERSION2        	      0xFFFC0000
-#define AR_SREV_VERSION2_S                    18
-#define AR_SREV_TYPE2        	      	      0x0003F000
-#define AR_SREV_TYPE2_S                       12
-#define AR_SREV_TYPE2_CHAIN		      0x00001000
-#define AR_SREV_TYPE2_HOST_MODE		      0x00002000
-#define AR_SREV_REVISION2        	      0x00000F00
-#define AR_SREV_REVISION2_S     	      8
-
-#define AR_SREV_VERSION_5416_PCI               0xD
-#define AR_SREV_VERSION_5416_PCIE              0xC
-#define AR_SREV_REVISION_5416_10               0
-#define AR_SREV_REVISION_5416_20               1
-#define AR_SREV_REVISION_5416_22               2
-#define AR_SREV_VERSION_9100                  0x14
-#define AR_SREV_VERSION_9160        	      0x40
-#define AR_SREV_REVISION_9160_10    	      0
-#define AR_SREV_REVISION_9160_11    	      1
-#define AR_SREV_VERSION_9280                0x80
-#define AR_SREV_REVISION_9280_10            0
-#define AR_SREV_REVISION_9280_20            1
-#define AR_SREV_REVISION_9280_21            2
-#define AR_SREV_VERSION_9285                  0xC0
-#define AR_SREV_REVISION_9285_10              0
-#define AR_SREV_REVISION_9285_11              1
-#define AR_SREV_REVISION_9285_12              2
-#define AR_SREV_VERSION_9287                  0x180
-#define AR_SREV_REVISION_9287_10              0
-#define AR_SREV_REVISION_9287_11              1
-#define AR_SREV_REVISION_9287_12              2
-#define AR_SREV_VERSION_9271			0x140
-#define AR_SREV_REVISION_9271_10		0
-#define AR_SREV_REVISION_9271_11		1
-
-#define AR_SREV_5416(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
-	 ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE))
-#define AR_SREV_5416_20_OR_LATER(_ah) \
-	(((AR_SREV_5416(_ah)) && \
-	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
-	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
-#define AR_SREV_5416_22_OR_LATER(_ah) \
-	(((AR_SREV_5416(_ah)) && \
-	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22)) || \
-	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
-
-#define AR_SREV_9100(ah) \
-	((ah->hw_version.macVersion) == AR_SREV_VERSION_9100)
-#define AR_SREV_9100_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
-
-#define AR_SREV_9160(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9160))
-#define AR_SREV_9160_10_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160))
-#define AR_SREV_9160_11(_ah) \
-	(AR_SREV_9160(_ah) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9160_11))
-#define AR_SREV_9280(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280))
-#define AR_SREV_9280_10_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))
-#define AR_SREV_9280_20(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
-		((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20))
-#define AR_SREV_9280_20_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9280) || \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
-	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20)))
-
-#define AR_SREV_9285(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9285))
-#define AR_SREV_9285_10_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9285))
-#define AR_SREV_9285_11(_ah) \
-	(AR_SREV_9285(ah) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_11))
-#define AR_SREV_9285_11_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
-	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
-			       AR_SREV_REVISION_9285_11)))
-#define AR_SREV_9285_12(_ah) \
-	(AR_SREV_9285(ah) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_12))
-#define AR_SREV_9285_12_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
-	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
-			       AR_SREV_REVISION_9285_12)))
-
-#define AR_SREV_9287(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287))
-#define AR_SREV_9287_10_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9287))
-#define AR_SREV_9287_10(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_10))
-#define AR_SREV_9287_11(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_11))
-#define AR_SREV_9287_11_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
-	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
-	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_11)))
-#define AR_SREV_9287_12(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
-	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_12))
-#define AR_SREV_9287_12_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
-	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
-	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_12)))
-#define AR_SREV_9271(_ah) \
-    (((_ah))->hw_version.macVersion == AR_SREV_VERSION_9271)
-#define AR_SREV_9271_10(_ah) \
-    (AR_SREV_9271(_ah) && \
-     ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_10))
-#define AR_SREV_9271_11(_ah) \
-    (AR_SREV_9271(_ah) && \
-     ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_11))
-
-#define AR_RADIO_SREV_MAJOR                   0xf0
-#define AR_RAD5133_SREV_MAJOR                 0xc0
-#define AR_RAD2133_SREV_MAJOR                 0xd0
-#define AR_RAD5122_SREV_MAJOR                 0xe0
-#define AR_RAD2122_SREV_MAJOR                 0xf0
-
-#define AR_AHB_MODE                           0x4024
-#define AR_AHB_EXACT_WR_EN                    0x00000000
-#define AR_AHB_BUF_WR_EN                      0x00000001
-#define AR_AHB_EXACT_RD_EN                    0x00000000
-#define AR_AHB_CACHELINE_RD_EN                0x00000002
-#define AR_AHB_PREFETCH_RD_EN                 0x00000004
-#define AR_AHB_PAGE_SIZE_1K                   0x00000000
-#define AR_AHB_PAGE_SIZE_2K                   0x00000008
-#define AR_AHB_PAGE_SIZE_4K                   0x00000010
-#define AR_AHB_CUSTOM_BURST_EN                0x000000C0
-#define AR_AHB_CUSTOM_BURST_EN_S              6
-#define AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL    3
-
-#define AR_INTR_RTC_IRQ                       0x00000001
-#define AR_INTR_MAC_IRQ                       0x00000002
-#define AR_INTR_EEP_PROT_ACCESS               0x00000004
-#define AR_INTR_MAC_AWAKE                     0x00020000
-#define AR_INTR_MAC_ASLEEP                    0x00040000
-#define AR_INTR_SPURIOUS                      0xFFFFFFFF
-
-
-#define AR_INTR_SYNC_CAUSE_CLR                0x4028
-
-#define AR_INTR_SYNC_CAUSE                    0x4028
-
-#define AR_INTR_SYNC_ENABLE                   0x402c
-#define AR_INTR_SYNC_ENABLE_GPIO              0xFFFC0000
-#define AR_INTR_SYNC_ENABLE_GPIO_S            18
-
-enum {
-	AR_INTR_SYNC_RTC_IRQ = 0x00000001,
-	AR_INTR_SYNC_MAC_IRQ = 0x00000002,
-	AR_INTR_SYNC_EEPROM_ILLEGAL_ACCESS = 0x00000004,
-	AR_INTR_SYNC_APB_TIMEOUT = 0x00000008,
-	AR_INTR_SYNC_PCI_MODE_CONFLICT = 0x00000010,
-	AR_INTR_SYNC_HOST1_FATAL = 0x00000020,
-	AR_INTR_SYNC_HOST1_PERR = 0x00000040,
-	AR_INTR_SYNC_TRCV_FIFO_PERR = 0x00000080,
-	AR_INTR_SYNC_RADM_CPL_EP = 0x00000100,
-	AR_INTR_SYNC_RADM_CPL_DLLP_ABORT = 0x00000200,
-	AR_INTR_SYNC_RADM_CPL_TLP_ABORT = 0x00000400,
-	AR_INTR_SYNC_RADM_CPL_ECRC_ERR = 0x00000800,
-	AR_INTR_SYNC_RADM_CPL_TIMEOUT = 0x00001000,
-	AR_INTR_SYNC_LOCAL_TIMEOUT = 0x00002000,
-	AR_INTR_SYNC_PM_ACCESS = 0x00004000,
-	AR_INTR_SYNC_MAC_AWAKE = 0x00008000,
-	AR_INTR_SYNC_MAC_ASLEEP = 0x00010000,
-	AR_INTR_SYNC_MAC_SLEEP_ACCESS = 0x00020000,
-	AR_INTR_SYNC_ALL = 0x0003FFFF,
-
-
-	AR_INTR_SYNC_DEFAULT = (AR_INTR_SYNC_HOST1_FATAL |
-				AR_INTR_SYNC_HOST1_PERR |
-				AR_INTR_SYNC_RADM_CPL_EP |
-				AR_INTR_SYNC_RADM_CPL_DLLP_ABORT |
-				AR_INTR_SYNC_RADM_CPL_TLP_ABORT |
-				AR_INTR_SYNC_RADM_CPL_ECRC_ERR |
-				AR_INTR_SYNC_RADM_CPL_TIMEOUT |
-				AR_INTR_SYNC_LOCAL_TIMEOUT |
-				AR_INTR_SYNC_MAC_SLEEP_ACCESS),
-
-	AR_INTR_SYNC_SPURIOUS = 0xFFFFFFFF,
-
-};
-
-#define AR_INTR_ASYNC_MASK                       0x4030
-#define AR_INTR_ASYNC_MASK_GPIO                  0xFFFC0000
-#define AR_INTR_ASYNC_MASK_GPIO_S                18
-
-#define AR_INTR_SYNC_MASK                        0x4034
-#define AR_INTR_SYNC_MASK_GPIO                   0xFFFC0000
-#define AR_INTR_SYNC_MASK_GPIO_S                 18
-
-#define AR_INTR_ASYNC_CAUSE_CLR                  0x4038
-#define AR_INTR_ASYNC_CAUSE                      0x4038
-
-#define AR_INTR_ASYNC_ENABLE                     0x403c
-#define AR_INTR_ASYNC_ENABLE_GPIO                0xFFFC0000
-#define AR_INTR_ASYNC_ENABLE_GPIO_S              18
-
-#define AR_PCIE_SERDES                           0x4040
-#define AR_PCIE_SERDES2                          0x4044
-#define AR_PCIE_PM_CTRL                          0x4014
-#define AR_PCIE_PM_CTRL_ENA                      0x00080000
-
-#define AR_NUM_GPIO                              14
-#define AR928X_NUM_GPIO                          10
-#define AR9285_NUM_GPIO                          12
-#define AR9287_NUM_GPIO                          11
-
-#define AR_GPIO_IN_OUT                           0x4048
-#define AR_GPIO_IN_VAL                           0x0FFFC000
-#define AR_GPIO_IN_VAL_S                         14
-#define AR928X_GPIO_IN_VAL                       0x000FFC00
-#define AR928X_GPIO_IN_VAL_S                     10
-#define AR9285_GPIO_IN_VAL                       0x00FFF000
-#define AR9285_GPIO_IN_VAL_S                     12
-#define AR9287_GPIO_IN_VAL                       0x003FF800
-#define AR9287_GPIO_IN_VAL_S                     11
-
-#define AR_GPIO_OE_OUT                           0x404c
-#define AR_GPIO_OE_OUT_DRV                       0x3
-#define AR_GPIO_OE_OUT_DRV_NO                    0x0
-#define AR_GPIO_OE_OUT_DRV_LOW                   0x1
-#define AR_GPIO_OE_OUT_DRV_HI                    0x2
-#define AR_GPIO_OE_OUT_DRV_ALL                   0x3
-
-#define AR_GPIO_INTR_POL                         0x4050
-#define AR_GPIO_INTR_POL_VAL                     0x00001FFF
-#define AR_GPIO_INTR_POL_VAL_S                   0
-
-#define AR_GPIO_INPUT_EN_VAL                     0x4054
-#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF     0x00000004
-#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_S       2
-#define AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF    0x00000008
-#define AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_S      3
-#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_DEF       0x00000010
-#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_S         4
-#define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF        0x00000080
-#define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF_S      7
-#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB        0x00001000
-#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB_S      12
-#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB      0x00001000
-#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB_S    1
-#define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB         0x00008000
-#define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB_S       15
-#define AR_GPIO_RTC_RESET_OVERRIDE_ENABLE        0x00010000
-#define AR_GPIO_JTAG_DISABLE                     0x00020000
-
-#define AR_GPIO_INPUT_MUX1                       0x4058
-#define AR_GPIO_INPUT_MUX1_BT_ACTIVE             0x000f0000
-#define AR_GPIO_INPUT_MUX1_BT_ACTIVE_S           16
-#define AR_GPIO_INPUT_MUX1_BT_PRIORITY           0x00000f00
-#define AR_GPIO_INPUT_MUX1_BT_PRIORITY_S         8
-
-#define AR_GPIO_INPUT_MUX2                       0x405c
-#define AR_GPIO_INPUT_MUX2_CLK25                 0x0000000f
-#define AR_GPIO_INPUT_MUX2_CLK25_S               0
-#define AR_GPIO_INPUT_MUX2_RFSILENT              0x000000f0
-#define AR_GPIO_INPUT_MUX2_RFSILENT_S            4
-#define AR_GPIO_INPUT_MUX2_RTC_RESET             0x00000f00
-#define AR_GPIO_INPUT_MUX2_RTC_RESET_S           8
-
-#define AR_GPIO_OUTPUT_MUX1                      0x4060
-#define AR_GPIO_OUTPUT_MUX2                      0x4064
-#define AR_GPIO_OUTPUT_MUX3                      0x4068
-
-#define AR_INPUT_STATE                           0x406c
-
-#define AR_EEPROM_STATUS_DATA                    0x407c
-#define AR_EEPROM_STATUS_DATA_VAL                0x0000ffff
-#define AR_EEPROM_STATUS_DATA_VAL_S              0
-#define AR_EEPROM_STATUS_DATA_BUSY               0x00010000
-#define AR_EEPROM_STATUS_DATA_BUSY_ACCESS        0x00020000
-#define AR_EEPROM_STATUS_DATA_PROT_ACCESS        0x00040000
-#define AR_EEPROM_STATUS_DATA_ABSENT_ACCESS      0x00080000
-
-#define AR_OBS                  0x4080
-
-#define AR_GPIO_PDPU                             0x4088
-
-#define AR_PCIE_MSI                              0x4094
-#define AR_PCIE_MSI_ENABLE                       0x00000001
-
-
-#define AR_RTC_9160_PLL_DIV	0x000003ff
-#define AR_RTC_9160_PLL_DIV_S   0
-#define AR_RTC_9160_PLL_REFDIV  0x00003C00
-#define AR_RTC_9160_PLL_REFDIV_S 10
-#define AR_RTC_9160_PLL_CLKSEL	0x0000C000
-#define AR_RTC_9160_PLL_CLKSEL_S 14
-
-#define AR_RTC_BASE             0x00020000
-#define AR_RTC_RC \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0000) : 0x7000)
-#define AR_RTC_RC_M		0x00000003
-#define AR_RTC_RC_MAC_WARM      0x00000001
-#define AR_RTC_RC_MAC_COLD      0x00000002
-#define AR_RTC_RC_COLD_RESET    0x00000004
-#define AR_RTC_RC_WARM_RESET    0x00000008
-
-#define AR_RTC_PLL_CONTROL \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0014) : 0x7014)
-
-#define AR_RTC_PLL_DIV          0x0000001f
-#define AR_RTC_PLL_DIV_S        0
-#define AR_RTC_PLL_DIV2         0x00000020
-#define AR_RTC_PLL_REFDIV_5     0x000000c0
-#define AR_RTC_PLL_CLKSEL       0x00000300
-#define AR_RTC_PLL_CLKSEL_S     8
-
-#define AR_RTC_RESET \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0040) : 0x7040)
-#define AR_RTC_RESET_EN		(0x00000001)
-
-#define AR_RTC_STATUS \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0044) : 0x7044)
-
-#define AR_RTC_STATUS_M \
-	((AR_SREV_9100(ah)) ? 0x0000003f : 0x0000000f)
-
-#define AR_RTC_PM_STATUS_M      0x0000000f
-
-#define AR_RTC_STATUS_SHUTDOWN  0x00000001
-#define AR_RTC_STATUS_ON        0x00000002
-#define AR_RTC_STATUS_SLEEP     0x00000004
-#define AR_RTC_STATUS_WAKEUP    0x00000008
-
-#define AR_RTC_SLEEP_CLK \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0048) : 0x7048)
-#define AR_RTC_FORCE_DERIVED_CLK    0x2
-
-#define AR_RTC_FORCE_WAKE \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x004c) : 0x704c)
-#define AR_RTC_FORCE_WAKE_EN        0x00000001
-#define AR_RTC_FORCE_WAKE_ON_INT    0x00000002
-
-
-#define AR_RTC_INTR_CAUSE \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0050) : 0x7050)
-
-#define AR_RTC_INTR_ENABLE \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0054) : 0x7054)
-
-#define AR_RTC_INTR_MASK \
-	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0058) : 0x7058)
-
-/* RTC_DERIVED_* - only for AR9100 */
-
-#define AR_RTC_DERIVED_CLK           (AR_RTC_BASE + 0x0038)
-#define AR_RTC_DERIVED_CLK_PERIOD    0x0000fffe
-#define AR_RTC_DERIVED_CLK_PERIOD_S  1
-
-#define	AR_SEQ_MASK	0x8060
-
-#define AR_AN_RF2G1_CH0         0x7810
-#define AR_AN_RF2G1_CH0_OB      0x03800000
-#define AR_AN_RF2G1_CH0_OB_S    23
-#define AR_AN_RF2G1_CH0_DB      0x1C000000
-#define AR_AN_RF2G1_CH0_DB_S    26
-
-#define AR_AN_RF5G1_CH0         0x7818
-#define AR_AN_RF5G1_CH0_OB5     0x00070000
-#define AR_AN_RF5G1_CH0_OB5_S   16
-#define AR_AN_RF5G1_CH0_DB5     0x00380000
-#define AR_AN_RF5G1_CH0_DB5_S   19
-
-#define AR_AN_RF2G1_CH1         0x7834
-#define AR_AN_RF2G1_CH1_OB      0x03800000
-#define AR_AN_RF2G1_CH1_OB_S    23
-#define AR_AN_RF2G1_CH1_DB      0x1C000000
-#define AR_AN_RF2G1_CH1_DB_S    26
-
-#define AR_AN_RF5G1_CH1         0x783C
-#define AR_AN_RF5G1_CH1_OB5     0x00070000
-#define AR_AN_RF5G1_CH1_OB5_S   16
-#define AR_AN_RF5G1_CH1_DB5     0x00380000
-#define AR_AN_RF5G1_CH1_DB5_S   19
-
-#define AR_AN_TOP1                  0x7890
-#define AR_AN_TOP1_DACIPMODE	    0x00040000
-#define AR_AN_TOP1_DACIPMODE_S	    18
-
-#define AR_AN_TOP2                  0x7894
-#define AR_AN_TOP2_XPABIAS_LVL      0xC0000000
-#define AR_AN_TOP2_XPABIAS_LVL_S    30
-#define AR_AN_TOP2_LOCALBIAS        0x00200000
-#define AR_AN_TOP2_LOCALBIAS_S      21
-#define AR_AN_TOP2_PWDCLKIND        0x00400000
-#define AR_AN_TOP2_PWDCLKIND_S      22
-
-#define AR_AN_SYNTH9            0x7868
-#define AR_AN_SYNTH9_REFDIVA    0xf8000000
-#define AR_AN_SYNTH9_REFDIVA_S  27
-
-#define AR9285_AN_RF2G1              0x7820
-#define AR9285_AN_RF2G1_ENPACAL      0x00000800
-#define AR9285_AN_RF2G1_ENPACAL_S    11
-#define AR9285_AN_RF2G1_PDPADRV1     0x02000000
-#define AR9285_AN_RF2G1_PDPADRV1_S   25
-#define AR9285_AN_RF2G1_PDPADRV2     0x01000000
-#define AR9285_AN_RF2G1_PDPADRV2_S   24
-#define AR9285_AN_RF2G1_PDPAOUT      0x00800000
-#define AR9285_AN_RF2G1_PDPAOUT_S    23
-
-
-#define AR9285_AN_RF2G2              0x7824
-#define AR9285_AN_RF2G2_OFFCAL       0x00001000
-#define AR9285_AN_RF2G2_OFFCAL_S     12
-
-#define AR9285_AN_RF2G3             0x7828
-#define AR9285_AN_RF2G3_PDVCCOMP    0x02000000
-#define AR9285_AN_RF2G3_PDVCCOMP_S  25
-#define AR9285_AN_RF2G3_OB_0    0x00E00000
-#define AR9285_AN_RF2G3_OB_0_S    21
-#define AR9285_AN_RF2G3_OB_1    0x001C0000
-#define AR9285_AN_RF2G3_OB_1_S    18
-#define AR9285_AN_RF2G3_OB_2    0x00038000
-#define AR9285_AN_RF2G3_OB_2_S    15
-#define AR9285_AN_RF2G3_OB_3    0x00007000
-#define AR9285_AN_RF2G3_OB_3_S    12
-#define AR9285_AN_RF2G3_OB_4    0x00000E00
-#define AR9285_AN_RF2G3_OB_4_S    9
-
-#define AR9285_AN_RF2G3_DB1_0    0x000001C0
-#define AR9285_AN_RF2G3_DB1_0_S    6
-#define AR9285_AN_RF2G3_DB1_1    0x00000038
-#define AR9285_AN_RF2G3_DB1_1_S    3
-#define AR9285_AN_RF2G3_DB1_2    0x00000007
-#define AR9285_AN_RF2G3_DB1_2_S    0
-#define AR9285_AN_RF2G4         0x782C
-#define AR9285_AN_RF2G4_DB1_3    0xE0000000
-#define AR9285_AN_RF2G4_DB1_3_S    29
-#define AR9285_AN_RF2G4_DB1_4    0x1C000000
-#define AR9285_AN_RF2G4_DB1_4_S    26
-
-#define AR9285_AN_RF2G4_DB2_0    0x03800000
-#define AR9285_AN_RF2G4_DB2_0_S    23
-#define AR9285_AN_RF2G4_DB2_1    0x00700000
-#define AR9285_AN_RF2G4_DB2_1_S    20
-#define AR9285_AN_RF2G4_DB2_2    0x000E0000
-#define AR9285_AN_RF2G4_DB2_2_S    17
-#define AR9285_AN_RF2G4_DB2_3    0x0001C000
-#define AR9285_AN_RF2G4_DB2_3_S    14
-#define AR9285_AN_RF2G4_DB2_4    0x00003800
-#define AR9285_AN_RF2G4_DB2_4_S    11
-
-/* AR9271 : 0x7828, 0x782c different setting from AR9285 */
-#define AR9271_AN_RF2G3_OB_cck		0x001C0000
-#define AR9271_AN_RF2G3_OB_cck_S	18
-#define AR9271_AN_RF2G3_OB_psk		0x00038000
-#define AR9271_AN_RF2G3_OB_psk_S	15
-#define AR9271_AN_RF2G3_OB_qam		0x00007000
-#define AR9271_AN_RF2G3_OB_qam_S	12
-
-#define AR9271_AN_RF2G3_DB_1		0x00E00000
-#define AR9271_AN_RF2G3_DB_1_S		21
-
-#define AR9271_AN_RF2G3_CCOMP		0xFFF
-#define AR9271_AN_RF2G3_CCOMP_S		0
-
-#define AR9271_AN_RF2G4_DB_2		0xE0000000
-#define AR9271_AN_RF2G4_DB_2_S		29
-
-#define AR9285_AN_RF2G6                 0x7834
-#define AR9285_AN_RF2G6_CCOMP           0x00007800
-#define AR9285_AN_RF2G6_CCOMP_S         11
-#define AR9285_AN_RF2G6_OFFS            0x03f00000
-#define AR9285_AN_RF2G6_OFFS_S          20
-
-#define AR9271_AN_RF2G6_OFFS            0x07f00000
-#define AR9271_AN_RF2G6_OFFS_S            20
-
-#define AR9285_AN_RF2G7                 0x7838
-#define AR9285_AN_RF2G7_PWDDB           0x00000002
-#define AR9285_AN_RF2G7_PWDDB_S         1
-#define AR9285_AN_RF2G7_PADRVGN2TAB0    0xE0000000
-#define AR9285_AN_RF2G7_PADRVGN2TAB0_S  29
-
-#define AR9285_AN_RF2G8                  0x783C
-#define AR9285_AN_RF2G8_PADRVGN2TAB0     0x0001C000
-#define AR9285_AN_RF2G8_PADRVGN2TAB0_S   14
-
-
-#define AR9285_AN_RF2G9          0x7840
-#define AR9285_AN_RXTXBB1              0x7854
-#define AR9285_AN_RXTXBB1_PDRXTXBB1    0x00000020
-#define AR9285_AN_RXTXBB1_PDRXTXBB1_S  5
-#define AR9285_AN_RXTXBB1_PDV2I        0x00000080
-#define AR9285_AN_RXTXBB1_PDV2I_S      7
-#define AR9285_AN_RXTXBB1_PDDACIF      0x00000100
-#define AR9285_AN_RXTXBB1_PDDACIF_S    8
-#define AR9285_AN_RXTXBB1_SPARE9       0x00000001
-#define AR9285_AN_RXTXBB1_SPARE9_S     0
-
-#define AR9285_AN_TOP2           0x7868
-
-#define AR9285_AN_TOP3                  0x786c
-#define AR9285_AN_TOP3_XPABIAS_LVL      0x0000000C
-#define AR9285_AN_TOP3_XPABIAS_LVL_S    2
-#define AR9285_AN_TOP3_PWDDAC           0x00800000
-#define AR9285_AN_TOP3_PWDDAC_S    23
-
-#define AR9285_AN_TOP4           0x7870
-#define AR9285_AN_TOP4_DEFAULT   0x10142c00
-
-#define AR9287_AN_RF2G3_CH0             0x7808
-#define AR9287_AN_RF2G3_CH1             0x785c
-#define AR9287_AN_RF2G3_DB1             0xE0000000
-#define AR9287_AN_RF2G3_DB1_S           29
-#define AR9287_AN_RF2G3_DB2             0x1C000000
-#define AR9287_AN_RF2G3_DB2_S           26
-#define AR9287_AN_RF2G3_OB_CCK          0x03800000
-#define AR9287_AN_RF2G3_OB_CCK_S        23
-#define AR9287_AN_RF2G3_OB_PSK          0x00700000
-#define AR9287_AN_RF2G3_OB_PSK_S        20
-#define AR9287_AN_RF2G3_OB_QAM          0x000E0000
-#define AR9287_AN_RF2G3_OB_QAM_S        17
-#define AR9287_AN_RF2G3_OB_PAL_OFF      0x0001C000
-#define AR9287_AN_RF2G3_OB_PAL_OFF_S    14
-
-#define AR9287_AN_TXPC0                 0x7898
-#define AR9287_AN_TXPC0_TXPCMODE        0x0000C000
-#define AR9287_AN_TXPC0_TXPCMODE_S      14
-#define AR9287_AN_TXPC0_TXPCMODE_NORMAL    0
-#define AR9287_AN_TXPC0_TXPCMODE_TEST      1
-#define AR9287_AN_TXPC0_TXPCMODE_TEMPSENSE 2
-#define AR9287_AN_TXPC0_TXPCMODE_ATBTEST   3
-
-#define AR9287_AN_TOP2                  0x78b4
-#define AR9287_AN_TOP2_XPABIAS_LVL      0xC0000000
-#define AR9287_AN_TOP2_XPABIAS_LVL_S    30
-
-/* AR9271 specific stuff */
-#define AR9271_RESET_POWER_DOWN_CONTROL		0x50044
-#define AR9271_RADIO_RF_RST			0x20
-#define AR9271_GATE_MAC_CTL			0x4000
-
-#define AR_STA_ID0                 0x8000
-#define AR_STA_ID1                 0x8004
-#define AR_STA_ID1_SADH_MASK       0x0000FFFF
-#define AR_STA_ID1_STA_AP          0x00010000
-#define AR_STA_ID1_ADHOC           0x00020000
-#define AR_STA_ID1_PWR_SAV         0x00040000
-#define AR_STA_ID1_KSRCHDIS        0x00080000
-#define AR_STA_ID1_PCF             0x00100000
-#define AR_STA_ID1_USE_DEFANT      0x00200000
-#define AR_STA_ID1_DEFANT_UPDATE   0x00400000
-#define AR_STA_ID1_RTS_USE_DEF     0x00800000
-#define AR_STA_ID1_ACKCTS_6MB      0x01000000
-#define AR_STA_ID1_BASE_RATE_11B   0x02000000
-#define AR_STA_ID1_SECTOR_SELF_GEN 0x04000000
-#define AR_STA_ID1_CRPT_MIC_ENABLE 0x08000000
-#define AR_STA_ID1_KSRCH_MODE      0x10000000
-#define AR_STA_ID1_PRESERVE_SEQNUM 0x20000000
-#define AR_STA_ID1_CBCIV_ENDIAN    0x40000000
-#define AR_STA_ID1_MCAST_KSRCH     0x80000000
-
-#define AR_BSS_ID0          0x8008
-#define AR_BSS_ID1          0x800C
-#define AR_BSS_ID1_U16       0x0000FFFF
-#define AR_BSS_ID1_AID       0x07FF0000
-#define AR_BSS_ID1_AID_S     16
-
-#define AR_BCN_RSSI_AVE      0x8010
-#define AR_BCN_RSSI_AVE_MASK 0x00000FFF
-
-#define AR_TIME_OUT         0x8014
-#define AR_TIME_OUT_ACK      0x00003FFF
-#define AR_TIME_OUT_ACK_S    0
-#define AR_TIME_OUT_CTS      0x3FFF0000
-#define AR_TIME_OUT_CTS_S    16
-#define AR_TIME_OUT_ACK_CTS_ASYNC_FIFO_DUR    0x16001D56
-
-#define AR_RSSI_THR          0x8018
-#define AR_RSSI_THR_MASK     0x000000FF
-#define AR_RSSI_THR_BM_THR   0x0000FF00
-#define AR_RSSI_THR_BM_THR_S 8
-#define AR_RSSI_BCN_WEIGHT   0x1F000000
-#define AR_RSSI_BCN_WEIGHT_S 24
-#define AR_RSSI_BCN_RSSI_RST 0x20000000
-
-#define AR_USEC              0x801c
-#define AR_USEC_USEC         0x0000007F
-#define AR_USEC_TX_LAT       0x007FC000
-#define AR_USEC_TX_LAT_S     14
-#define AR_USEC_RX_LAT       0x1F800000
-#define AR_USEC_RX_LAT_S     23
-#define AR_USEC_ASYNC_FIFO_DUR    0x12e00074
-
-#define AR_RESET_TSF        0x8020
-#define AR_RESET_TSF_ONCE   0x01000000
-
-#define AR_MAX_CFP_DUR      0x8038
-#define AR_CFP_VAL          0x0000FFFF
-
-#define AR_RX_FILTER        0x803C
-
-#define AR_MCAST_FIL0       0x8040
-#define AR_MCAST_FIL1       0x8044
-
-#define AR_DIAG_SW                  0x8048
-#define AR_DIAG_CACHE_ACK           0x00000001
-#define AR_DIAG_ACK_DIS             0x00000002
-#define AR_DIAG_CTS_DIS             0x00000004
-#define AR_DIAG_ENCRYPT_DIS         0x00000008
-#define AR_DIAG_DECRYPT_DIS         0x00000010
-#define AR_DIAG_RX_DIS              0x00000020
-#define AR_DIAG_LOOP_BACK           0x00000040
-#define AR_DIAG_CORR_FCS            0x00000080
-#define AR_DIAG_CHAN_INFO           0x00000100
-#define AR_DIAG_SCRAM_SEED          0x0001FE00
-#define AR_DIAG_SCRAM_SEED_S        8
-#define AR_DIAG_FRAME_NV0           0x00020000
-#define AR_DIAG_OBS_PT_SEL1         0x000C0000
-#define AR_DIAG_OBS_PT_SEL1_S       18
-#define AR_DIAG_FORCE_RX_CLEAR      0x00100000
-#define AR_DIAG_IGNORE_VIRT_CS      0x00200000
-#define AR_DIAG_FORCE_CH_IDLE_HIGH  0x00400000
-#define AR_DIAG_EIFS_CTRL_ENA       0x00800000
-#define AR_DIAG_DUAL_CHAIN_INFO     0x01000000
-#define AR_DIAG_RX_ABORT            0x02000000
-#define AR_DIAG_SATURATE_CYCLE_CNT  0x04000000
-#define AR_DIAG_OBS_PT_SEL2         0x08000000
-#define AR_DIAG_RX_CLEAR_CTL_LOW    0x10000000
-#define AR_DIAG_RX_CLEAR_EXT_LOW    0x20000000
-
-#define AR_TSF_L32          0x804c
-#define AR_TSF_U32          0x8050
-
-#define AR_TST_ADDAC        0x8054
-#define AR_DEF_ANTENNA      0x8058
-
-#define AR_AES_MUTE_MASK0       0x805c
-#define AR_AES_MUTE_MASK0_FC    0x0000FFFF
-#define AR_AES_MUTE_MASK0_QOS   0xFFFF0000
-#define AR_AES_MUTE_MASK0_QOS_S 16
-
-#define AR_AES_MUTE_MASK1       0x8060
-#define AR_AES_MUTE_MASK1_SEQ   0x0000FFFF
-#define AR_AES_MUTE_MASK1_FC_MGMT 0xFFFF0000
-#define AR_AES_MUTE_MASK1_FC_MGMT_S 16
-
-#define AR_GATED_CLKS       0x8064
-#define AR_GATED_CLKS_TX    0x00000002
-#define AR_GATED_CLKS_RX    0x00000004
-#define AR_GATED_CLKS_REG   0x00000008
-
-#define AR_OBS_BUS_CTRL     0x8068
-#define AR_OBS_BUS_SEL_1    0x00040000
-#define AR_OBS_BUS_SEL_2    0x00080000
-#define AR_OBS_BUS_SEL_3    0x000C0000
-#define AR_OBS_BUS_SEL_4    0x08040000
-#define AR_OBS_BUS_SEL_5    0x08080000
-
-#define AR_OBS_BUS_1               0x806c
-#define AR_OBS_BUS_1_PCU           0x00000001
-#define AR_OBS_BUS_1_RX_END        0x00000002
-#define AR_OBS_BUS_1_RX_WEP        0x00000004
-#define AR_OBS_BUS_1_RX_BEACON     0x00000008
-#define AR_OBS_BUS_1_RX_FILTER     0x00000010
-#define AR_OBS_BUS_1_TX_HCF        0x00000020
-#define AR_OBS_BUS_1_QUIET_TIME    0x00000040
-#define AR_OBS_BUS_1_CHAN_IDLE     0x00000080
-#define AR_OBS_BUS_1_TX_HOLD       0x00000100
-#define AR_OBS_BUS_1_TX_FRAME      0x00000200
-#define AR_OBS_BUS_1_RX_FRAME      0x00000400
-#define AR_OBS_BUS_1_RX_CLEAR      0x00000800
-#define AR_OBS_BUS_1_WEP_STATE     0x0003F000
-#define AR_OBS_BUS_1_WEP_STATE_S   12
-#define AR_OBS_BUS_1_RX_STATE      0x01F00000
-#define AR_OBS_BUS_1_RX_STATE_S    20
-#define AR_OBS_BUS_1_TX_STATE      0x7E000000
-#define AR_OBS_BUS_1_TX_STATE_S    25
-
-#define AR_LAST_TSTP        0x8080
-#define AR_NAV              0x8084
-#define AR_RTS_OK           0x8088
-#define AR_RTS_FAIL         0x808c
-#define AR_ACK_FAIL         0x8090
-#define AR_FCS_FAIL         0x8094
-#define AR_BEACON_CNT       0x8098
-
-#define AR_SLEEP1               0x80d4
-#define AR_SLEEP1_ASSUME_DTIM   0x00080000
-#define AR_SLEEP1_CAB_TIMEOUT   0xFFE00000
-#define AR_SLEEP1_CAB_TIMEOUT_S 21
-
-#define AR_SLEEP2                   0x80d8
-#define AR_SLEEP2_BEACON_TIMEOUT    0xFFE00000
-#define AR_SLEEP2_BEACON_TIMEOUT_S  21
-
-#define AR_TPC                 0x80e8
-#define AR_TPC_ACK             0x0000003f
-#define AR_TPC_ACK_S           0x00
-#define AR_TPC_CTS             0x00003f00
-#define AR_TPC_CTS_S           0x08
-#define AR_TPC_CHIRP           0x003f0000
-#define AR_TPC_CHIRP_S         0x16
-
-#define AR_TFCNT           0x80ec
-#define AR_RFCNT           0x80f0
-#define AR_RCCNT           0x80f4
-#define AR_CCCNT           0x80f8
-
-#define AR_QUIET1          0x80fc
-#define AR_QUIET1_NEXT_QUIET_S         0
-#define AR_QUIET1_NEXT_QUIET_M         0x0000ffff
-#define AR_QUIET1_QUIET_ENABLE         0x00010000
-#define AR_QUIET1_QUIET_ACK_CTS_ENABLE 0x00020000
-#define AR_QUIET1_QUIET_ACK_CTS_ENABLE_S 17
-#define AR_QUIET2          0x8100
-#define AR_QUIET2_QUIET_PERIOD_S       0
-#define AR_QUIET2_QUIET_PERIOD_M       0x0000ffff
-#define AR_QUIET2_QUIET_DUR_S     16
-#define AR_QUIET2_QUIET_DUR       0xffff0000
-
-#define AR_TSF_PARM        0x8104
-#define AR_TSF_INCREMENT_M     0x000000ff
-#define AR_TSF_INCREMENT_S     0x00
-
-#define AR_QOS_NO_ACK              0x8108
-#define AR_QOS_NO_ACK_TWO_BIT      0x0000000f
-#define AR_QOS_NO_ACK_TWO_BIT_S    0
-#define AR_QOS_NO_ACK_BIT_OFF      0x00000070
-#define AR_QOS_NO_ACK_BIT_OFF_S    4
-#define AR_QOS_NO_ACK_BYTE_OFF     0x00000180
-#define AR_QOS_NO_ACK_BYTE_OFF_S   7
-
-#define AR_PHY_ERR         0x810c
-
-#define AR_PHY_ERR_DCHIRP      0x00000008
-#define AR_PHY_ERR_RADAR       0x00000020
-#define AR_PHY_ERR_OFDM_TIMING 0x00020000
-#define AR_PHY_ERR_CCK_TIMING  0x02000000
-
-#define AR_RXFIFO_CFG          0x8114
-
-
-#define AR_MIC_QOS_CONTROL 0x8118
-#define AR_MIC_QOS_SELECT  0x811c
-
-#define AR_PCU_MISC                0x8120
-#define AR_PCU_FORCE_BSSID_MATCH   0x00000001
-#define AR_PCU_MIC_NEW_LOC_ENA     0x00000004
-#define AR_PCU_TX_ADD_TSF          0x00000008
-#define AR_PCU_CCK_SIFS_MODE       0x00000010
-#define AR_PCU_RX_ANT_UPDT         0x00000800
-#define AR_PCU_TXOP_TBTT_LIMIT_ENA 0x00001000
-#define AR_PCU_MISS_BCN_IN_SLEEP   0x00004000
-#define AR_PCU_BUG_12306_FIX_ENA   0x00020000
-#define AR_PCU_FORCE_QUIET_COLL    0x00040000
-#define AR_PCU_TBTT_PROTECT        0x00200000
-#define AR_PCU_CLEAR_VMF           0x01000000
-#define AR_PCU_CLEAR_BA_VALID      0x04000000
-
-#define AR_PCU_BT_ANT_PREVENT_RX   0x00100000
-#define AR_PCU_BT_ANT_PREVENT_RX_S 20
-
-#define AR_FILT_OFDM           0x8124
-#define AR_FILT_OFDM_COUNT     0x00FFFFFF
-
-#define AR_FILT_CCK            0x8128
-#define AR_FILT_CCK_COUNT      0x00FFFFFF
-
-#define AR_PHY_ERR_1           0x812c
-#define AR_PHY_ERR_1_COUNT     0x00FFFFFF
-#define AR_PHY_ERR_MASK_1      0x8130
-
-#define AR_PHY_ERR_2           0x8134
-#define AR_PHY_ERR_2_COUNT     0x00FFFFFF
-#define AR_PHY_ERR_MASK_2      0x8138
-
-#define AR_PHY_COUNTMAX        (3 << 22)
-#define AR_MIBCNT_INTRMASK     (3 << 22)
-
-#define AR_TSFOOR_THRESHOLD       0x813c
-#define AR_TSFOOR_THRESHOLD_VAL   0x0000FFFF
-
-#define AR_PHY_ERR_EIFS_MASK   8144
-
-#define AR_PHY_ERR_3           0x8168
-#define AR_PHY_ERR_3_COUNT     0x00FFFFFF
-#define AR_PHY_ERR_MASK_3      0x816c
-
-#define AR_BT_COEX_MODE            0x8170
-#define AR_BT_TIME_EXTEND          0x000000ff
-#define AR_BT_TIME_EXTEND_S        0
-#define AR_BT_TXSTATE_EXTEND       0x00000100
-#define AR_BT_TXSTATE_EXTEND_S     8
-#define AR_BT_TX_FRAME_EXTEND      0x00000200
-#define AR_BT_TX_FRAME_EXTEND_S    9
-#define AR_BT_MODE                 0x00000c00
-#define AR_BT_MODE_S               10
-#define AR_BT_QUIET                0x00001000
-#define AR_BT_QUIET_S              12
-#define AR_BT_QCU_THRESH           0x0001e000
-#define AR_BT_QCU_THRESH_S         13
-#define AR_BT_RX_CLEAR_POLARITY    0x00020000
-#define AR_BT_RX_CLEAR_POLARITY_S  17
-#define AR_BT_PRIORITY_TIME        0x00fc0000
-#define AR_BT_PRIORITY_TIME_S      18
-#define AR_BT_FIRST_SLOT_TIME      0xff000000
-#define AR_BT_FIRST_SLOT_TIME_S    24
-
-#define AR_BT_COEX_WEIGHT          0x8174
-#define AR_BT_COEX_WGHT		   0xff55
-#define AR_STOMP_ALL_WLAN_WGHT	   0xffcc
-#define AR_STOMP_LOW_WLAN_WGHT	   0xaaa8
-#define AR_STOMP_NONE_WLAN_WGHT	   0xaa00
-#define AR_BTCOEX_BT_WGHT          0x0000ffff
-#define AR_BTCOEX_BT_WGHT_S        0
-#define AR_BTCOEX_WL_WGHT          0xffff0000
-#define AR_BTCOEX_WL_WGHT_S        16
-
-#define AR_BT_COEX_MODE2           0x817c
-#define AR_BT_BCN_MISS_THRESH      0x000000ff
-#define AR_BT_BCN_MISS_THRESH_S    0
-#define AR_BT_BCN_MISS_CNT         0x0000ff00
-#define AR_BT_BCN_MISS_CNT_S       8
-#define AR_BT_HOLD_RX_CLEAR        0x00010000
-#define AR_BT_HOLD_RX_CLEAR_S      16
-#define AR_BT_DISABLE_BT_ANT       0x00100000
-#define AR_BT_DISABLE_BT_ANT_S     20
-
-#define AR_TXSIFS              0x81d0
-#define AR_TXSIFS_TIME         0x000000FF
-#define AR_TXSIFS_TX_LATENCY   0x00000F00
-#define AR_TXSIFS_TX_LATENCY_S 8
-#define AR_TXSIFS_ACK_SHIFT    0x00007000
-#define AR_TXSIFS_ACK_SHIFT_S  12
-
-#define AR_TXOP_X          0x81ec
-#define AR_TXOP_X_VAL      0x000000FF
-
-
-#define AR_TXOP_0_3    0x81f0
-#define AR_TXOP_4_7    0x81f4
-#define AR_TXOP_8_11   0x81f8
-#define AR_TXOP_12_15  0x81fc
-
-#define AR_NEXT_NDP2_TIMER                  0x8180
-#define AR_FIRST_NDP_TIMER                  7
-#define AR_NDP2_PERIOD                      0x81a0
-#define AR_NDP2_TIMER_MODE                  0x81c0
-#define AR_NEXT_TBTT_TIMER                  0x8200
-#define AR_NEXT_DMA_BEACON_ALERT            0x8204
-#define AR_NEXT_SWBA                        0x8208
-#define AR_NEXT_CFP                         0x8208
-#define AR_NEXT_HCF                         0x820C
-#define AR_NEXT_TIM                         0x8210
-#define AR_NEXT_DTIM                        0x8214
-#define AR_NEXT_QUIET_TIMER                 0x8218
-#define AR_NEXT_NDP_TIMER                   0x821C
-
-#define AR_BEACON_PERIOD                    0x8220
-#define AR_DMA_BEACON_PERIOD                0x8224
-#define AR_SWBA_PERIOD                      0x8228
-#define AR_HCF_PERIOD                       0x822C
-#define AR_TIM_PERIOD                       0x8230
-#define AR_DTIM_PERIOD                      0x8234
-#define AR_QUIET_PERIOD                     0x8238
-#define AR_NDP_PERIOD                       0x823C
-
-#define AR_TIMER_MODE                       0x8240
-#define AR_TBTT_TIMER_EN                    0x00000001
-#define AR_DBA_TIMER_EN                     0x00000002
-#define AR_SWBA_TIMER_EN                    0x00000004
-#define AR_HCF_TIMER_EN                     0x00000008
-#define AR_TIM_TIMER_EN                     0x00000010
-#define AR_DTIM_TIMER_EN                    0x00000020
-#define AR_QUIET_TIMER_EN                   0x00000040
-#define AR_NDP_TIMER_EN                     0x00000080
-#define AR_TIMER_OVERFLOW_INDEX             0x00000700
-#define AR_TIMER_OVERFLOW_INDEX_S           8
-#define AR_TIMER_THRESH                     0xFFFFF000
-#define AR_TIMER_THRESH_S                   12
-
-#define AR_SLP32_MODE                  0x8244
-#define AR_SLP32_HALF_CLK_LATENCY      0x000FFFFF
-#define AR_SLP32_ENA                   0x00100000
-#define AR_SLP32_TSF_WRITE_STATUS      0x00200000
-
-#define AR_SLP32_WAKE              0x8248
-#define AR_SLP32_WAKE_XTL_TIME     0x0000FFFF
-
-#define AR_SLP32_INC               0x824c
-#define AR_SLP32_TST_INC           0x000FFFFF
-
-#define AR_SLP_CNT         0x8250
-#define AR_SLP_CYCLE_CNT   0x8254
-
-#define AR_SLP_MIB_CTRL    0x8258
-#define AR_SLP_MIB_CLEAR   0x00000001
-#define AR_SLP_MIB_PENDING 0x00000002
-
-#define AR_MAC_PCU_LOGIC_ANALYZER               0x8264
-#define AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768   0x20000000
-
-
-#define AR_2040_MODE                0x8318
-#define AR_2040_JOINED_RX_CLEAR 0x00000001
-
-
-#define AR_EXTRCCNT         0x8328
-
-#define AR_SELFGEN_MASK         0x832c
-
-#define AR_PCU_TXBUF_CTRL               0x8340
-#define AR_PCU_TXBUF_CTRL_SIZE_MASK     0x7FF
-#define AR_PCU_TXBUF_CTRL_USABLE_SIZE   0x700
-#define AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE   0x380
-
-#define AR_PCU_MISC_MODE2               0x8344
-#define AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE           0x00000002
-#define AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT   0x00000004
-
-#define AR_PCU_MISC_MODE2_RESERVED                     0x00000038
-#define AR_PCU_MISC_MODE2_ADHOC_MCAST_KEYID_ENABLE     0x00000040
-#define AR_PCU_MISC_MODE2_CFP_IGNORE                   0x00000080
-#define AR_PCU_MISC_MODE2_MGMT_QOS                     0x0000FF00
-#define AR_PCU_MISC_MODE2_MGMT_QOS_S                   8
-#define AR_PCU_MISC_MODE2_ENABLE_LOAD_NAV_BEACON_DURATION 0x00010000
-#define AR_PCU_MISC_MODE2_ENABLE_AGGWEP                0x00020000
-#define AR_PCU_MISC_MODE2_HWWAR1                       0x00100000
-#define AR_PCU_MISC_MODE2_HWWAR2                       0x02000000
-#define AR_PCU_MISC_MODE2_RESERVED2                    0xFFFE0000
-
-#define AR_MAC_PCU_ASYNC_FIFO_REG3                     0x8358
-#define AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL        0x00000400
-#define AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET          0x80000000
-
-
-#define AR_AES_MUTE_MASK0       0x805c
-#define AR_AES_MUTE_MASK0_FC    0x0000FFFF
-#define AR_AES_MUTE_MASK0_QOS   0xFFFF0000
-#define AR_AES_MUTE_MASK0_QOS_S 16
-
-#define AR_AES_MUTE_MASK1              0x8060
-#define AR_AES_MUTE_MASK1_SEQ          0x0000FFFF
-#define AR_AES_MUTE_MASK1_SEQ_S        0
-#define AR_AES_MUTE_MASK1_FC_MGMT      0xFFFF0000
-#define AR_AES_MUTE_MASK1_FC_MGMT_S    16
-
-#define AR_RATE_DURATION_0      0x8700
-#define AR_RATE_DURATION_31     0x87CC
-#define AR_RATE_DURATION_32     0x8780
-#define AR_RATE_DURATION(_n)    (AR_RATE_DURATION_0 + ((_n)<<2))
-
-
-#define AR_KEYTABLE_0           0x8800
-#define AR_KEYTABLE(_n)         (AR_KEYTABLE_0 + ((_n)*32))
-#define AR_KEY_CACHE_SIZE       128
-#define AR_RSVD_KEYTABLE_ENTRIES 4
-#define AR_KEY_TYPE             0x00000007
-#define AR_KEYTABLE_TYPE_40     0x00000000
-#define AR_KEYTABLE_TYPE_104    0x00000001
-#define AR_KEYTABLE_TYPE_128    0x00000003
-#define AR_KEYTABLE_TYPE_TKIP   0x00000004
-#define AR_KEYTABLE_TYPE_AES    0x00000005
-#define AR_KEYTABLE_TYPE_CCM    0x00000006
-#define AR_KEYTABLE_TYPE_CLR    0x00000007
-#define AR_KEYTABLE_ANT         0x00000008
-#define AR_KEYTABLE_VALID       0x00008000
-#define AR_KEYTABLE_KEY0(_n)    (AR_KEYTABLE(_n) + 0)
-#define AR_KEYTABLE_KEY1(_n)    (AR_KEYTABLE(_n) + 4)
-#define AR_KEYTABLE_KEY2(_n)    (AR_KEYTABLE(_n) + 8)
-#define AR_KEYTABLE_KEY3(_n)    (AR_KEYTABLE(_n) + 12)
-#define AR_KEYTABLE_KEY4(_n)    (AR_KEYTABLE(_n) + 16)
-#define AR_KEYTABLE_TYPE(_n)    (AR_KEYTABLE(_n) + 20)
-#define AR_KEYTABLE_MAC0(_n)    (AR_KEYTABLE(_n) + 24)
-#define AR_KEYTABLE_MAC1(_n)    (AR_KEYTABLE(_n) + 28)
-
-#endif
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/btcoex.c
similarity index 96%
rename from drivers/net/wireless/ath/ath9k/btcoex.c
rename to drivers/net/wireless/ath/btcoex.c
index 0c54489..fb4ac15 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/btcoex.c
@@ -95,6 +95,7 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 	for (i = 0; i < 32; i++)
 		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
 }
+EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
 
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 {
@@ -116,6 +117,7 @@ void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 	/* Configure the desired gpio port for input */
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_init_2wire);
 
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 {
@@ -141,6 +143,7 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btpriority_gpio);
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_init_3wire);
 
 static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
 {
@@ -160,6 +163,7 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
 				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
 
 static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 {
@@ -201,6 +205,7 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 
 	ah->btcoex_hw.enabled = true;
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_enable);
 
 void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 {
@@ -219,3 +224,4 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 
 	ah->btcoex_hw.enabled = false;
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_disable);
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/btcoex.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/btcoex.h
rename to drivers/net/wireless/ath/btcoex.h
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/calib.c
similarity index 99%
rename from drivers/net/wireless/ath/ath9k/calib.c
rename to drivers/net/wireless/ath/calib.c
index aa66242..4fa8610 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/calib.c
@@ -593,6 +593,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 
 	return false;
 }
+EXPORT_SYMBOL(ath9k_hw_reset_calvalid);
 
 void ath9k_hw_start_nfcal(struct ath_hw *ah)
 {
@@ -733,6 +734,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	return nf;
 }
+EXPORT_SYMBOL(ath9k_hw_getchan_noise);
 
 static void ath9k_olc_temp_compensation(struct ath_hw *ah)
 {
@@ -1031,6 +1033,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	return iscaldone;
 }
+EXPORT_SYMBOL(ath9k_hw_calibrate);
 
 static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/calib.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/calib.h
rename to drivers/net/wireless/ath/calib.h
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/eeprom.c
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/eeprom.c
rename to drivers/net/wireless/ath/eeprom.c
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/eeprom.h
similarity index 99%
rename from drivers/net/wireless/ath/ath9k/eeprom.h
rename to drivers/net/wireless/ath/eeprom.h
index 8463ba0..b3b2b51 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/eeprom.h
@@ -17,7 +17,7 @@
 #ifndef EEPROM_H
 #define EEPROM_H
 
-#include "../ath.h"
+#include "ath.h"
 #include <net/cfg80211.h>
 
 #define AH_USE_EEPROM   0x1
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/eeprom_4k.c
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/eeprom_4k.c
rename to drivers/net/wireless/ath/eeprom_4k.c
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/eeprom_9287.c
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/eeprom_9287.c
rename to drivers/net/wireless/ath/eeprom_9287.c
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/eeprom_def.c
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/eeprom_def.c
rename to drivers/net/wireless/ath/eeprom_def.c
diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index ecc9eb0..faa5d32 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -14,16 +14,4256 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/io.h>
 #include <asm/unaligned.h>
 
 #include "ath.h"
-#include "reg.h"
+#include "hw.h"
+#include "rc.h"
+#include "initvals.h"
 
-#define REG_READ	common->ops->read
-#define REG_WRITE	common->ops->write
+#define ATH9K_CLOCK_RATE_CCK		22
+#define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
+#define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
+
+static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
+static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan);
+static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
+			      struct ar5416_eeprom_def *pEepData,
+			      u32 reg, u32 value);
+static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
+static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
+
+/********************/
+/* Helper Functions */
+/********************/
+
+static u32 ath9k_hw_mac_usec(struct ath_hw *ah, u32 clks)
+{
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+
+	if (!ah->curchan) /* should really check for CCK instead */
+		return clks / ATH9K_CLOCK_RATE_CCK;
+	if (conf->channel->band == IEEE80211_BAND_2GHZ)
+		return clks / ATH9K_CLOCK_RATE_2GHZ_OFDM;
+
+	return clks / ATH9K_CLOCK_RATE_5GHZ_OFDM;
+}
+
+static u32 ath9k_hw_mac_to_usec(struct ath_hw *ah, u32 clks)
+{
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+
+	if (conf_is_ht40(conf))
+		return ath9k_hw_mac_usec(ah, clks) / 2;
+	else
+		return ath9k_hw_mac_usec(ah, clks);
+}
+
+static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
+{
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+
+	if (!ah->curchan) /* should really check for CCK instead */
+		return usecs *ATH9K_CLOCK_RATE_CCK;
+	if (conf->channel->band == IEEE80211_BAND_2GHZ)
+		return usecs *ATH9K_CLOCK_RATE_2GHZ_OFDM;
+	return usecs *ATH9K_CLOCK_RATE_5GHZ_OFDM;
+}
+
+static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
+{
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+
+	if (conf_is_ht40(conf))
+		return ath9k_hw_mac_clks(ah, usecs) * 2;
+	else
+		return ath9k_hw_mac_clks(ah, usecs);
+}
+
+bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
+{
+	int i;
+
+	BUG_ON(timeout < AH_TIME_QUANTUM);
+
+	for (i = 0; i < (timeout / AH_TIME_QUANTUM); i++) {
+		if ((REG_READ(ah, reg) & mask) == val)
+			return true;
+
+		udelay(AH_TIME_QUANTUM);
+	}
+
+	ath_print(ath9k_hw_common(ah), ATH_DBG_ANY,
+		  "timeout (%d us) on reg 0x%x: 0x%08x & 0x%08x != 0x%08x\n",
+		  timeout, reg, REG_READ(ah, reg), mask, val);
+
+	return false;
+}
+EXPORT_SYMBOL(ath9k_hw_wait);
+
+u32 ath9k_hw_reverse_bits(u32 val, u32 n)
+{
+	u32 retval;
+	int i;
+
+	for (i = 0, retval = 0; i < n; i++) {
+		retval = (retval << 1) | (val & 1);
+		val >>= 1;
+	}
+	return retval;
+}
+
+bool ath9k_get_channel_edges(struct ath_hw *ah,
+			     u16 flags, u16 *low,
+			     u16 *high)
+{
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+
+	if (flags & CHANNEL_5GHZ) {
+		*low = pCap->low_5ghz_chan;
+		*high = pCap->high_5ghz_chan;
+		return true;
+	}
+	if ((flags & CHANNEL_2GHZ)) {
+		*low = pCap->low_2ghz_chan;
+		*high = pCap->high_2ghz_chan;
+		return true;
+	}
+	return false;
+}
+
+u16 ath9k_hw_computetxtime(struct ath_hw *ah,
+			   const struct ath_rate_table *rates,
+			   u32 frameLen, u16 rateix,
+			   bool shortPreamble)
+{
+	u32 bitsPerSymbol, numBits, numSymbols, phyTime, txTime;
+	u32 kbps;
+
+	kbps = rates->info[rateix].ratekbps;
+
+	if (kbps == 0)
+		return 0;
+
+	switch (rates->info[rateix].phy) {
+	case WLAN_RC_PHY_CCK:
+		phyTime = CCK_PREAMBLE_BITS + CCK_PLCP_BITS;
+		if (shortPreamble && rates->info[rateix].short_preamble)
+			phyTime >>= 1;
+		numBits = frameLen << 3;
+		txTime = CCK_SIFS_TIME + phyTime + ((numBits * 1000) / kbps);
+		break;
+	case WLAN_RC_PHY_OFDM:
+		if (ah->curchan && IS_CHAN_QUARTER_RATE(ah->curchan)) {
+			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_QUARTER) / 1000;
+			numBits = OFDM_PLCP_BITS + (frameLen << 3);
+			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
+			txTime = OFDM_SIFS_TIME_QUARTER
+				+ OFDM_PREAMBLE_TIME_QUARTER
+				+ (numSymbols * OFDM_SYMBOL_TIME_QUARTER);
+		} else if (ah->curchan &&
+			   IS_CHAN_HALF_RATE(ah->curchan)) {
+			bitsPerSymbol =	(kbps * OFDM_SYMBOL_TIME_HALF) / 1000;
+			numBits = OFDM_PLCP_BITS + (frameLen << 3);
+			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
+			txTime = OFDM_SIFS_TIME_HALF +
+				OFDM_PREAMBLE_TIME_HALF
+				+ (numSymbols * OFDM_SYMBOL_TIME_HALF);
+		} else {
+			bitsPerSymbol = (kbps * OFDM_SYMBOL_TIME) / 1000;
+			numBits = OFDM_PLCP_BITS + (frameLen << 3);
+			numSymbols = DIV_ROUND_UP(numBits, bitsPerSymbol);
+			txTime = OFDM_SIFS_TIME + OFDM_PREAMBLE_TIME
+				+ (numSymbols * OFDM_SYMBOL_TIME);
+		}
+		break;
+	default:
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Unknown phy %u (rate ix %u)\n",
+			  rates->info[rateix].phy, rateix);
+		txTime = 0;
+		break;
+	}
+
+	return txTime;
+}
+EXPORT_SYMBOL(ath9k_hw_computetxtime);
+
+void ath9k_hw_get_channel_centers(struct ath_hw *ah,
+				  struct ath9k_channel *chan,
+				  struct chan_centers *centers)
+{
+	int8_t extoff;
+
+	if (!IS_CHAN_HT40(chan)) {
+		centers->ctl_center = centers->ext_center =
+			centers->synth_center = chan->channel;
+		return;
+	}
+
+	if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
+	    (chan->chanmode == CHANNEL_G_HT40PLUS)) {
+		centers->synth_center =
+			chan->channel + HT40_CHANNEL_CENTER_SHIFT;
+		extoff = 1;
+	} else {
+		centers->synth_center =
+			chan->channel - HT40_CHANNEL_CENTER_SHIFT;
+		extoff = -1;
+	}
+
+	centers->ctl_center =
+		centers->synth_center - (extoff * HT40_CHANNEL_CENTER_SHIFT);
+	/* 25 MHz spacing is supported by hw but not on upper layers */
+	centers->ext_center =
+		centers->synth_center + (extoff * HT40_CHANNEL_CENTER_SHIFT);
+}
+
+/******************/
+/* Chip Revisions */
+/******************/
+
+static void ath9k_hw_read_revisions(struct ath_hw *ah)
+{
+	u32 val;
+
+	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
+
+	if (val == 0xFF) {
+		val = REG_READ(ah, AR_SREV);
+		ah->hw_version.macVersion =
+			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
+		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
+		ah->is_pciexpress = (val & AR_SREV_TYPE2_HOST_MODE) ? 0 : 1;
+	} else {
+		if (!AR_SREV_9100(ah))
+			ah->hw_version.macVersion = MS(val, AR_SREV_VERSION);
+
+		ah->hw_version.macRev = val & AR_SREV_REVISION;
+
+		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE)
+			ah->is_pciexpress = true;
+	}
+}
+
+static int ath9k_hw_get_radiorev(struct ath_hw *ah)
+{
+	u32 val;
+	int i;
+
+	REG_WRITE(ah, AR_PHY(0x36), 0x00007058);
+
+	for (i = 0; i < 8; i++)
+		REG_WRITE(ah, AR_PHY(0x20), 0x00010000);
+	val = (REG_READ(ah, AR_PHY(256)) >> 24) & 0xff;
+	val = ((val & 0xf0) >> 4) | ((val & 0x0f) << 4);
+
+	return ath9k_hw_reverse_bits(val, 8);
+}
+
+/************************************/
+/* HW Attach, Detach, Init Routines */
+/************************************/
+
+static void ath9k_hw_disablepcie(struct ath_hw *ah)
+{
+	if (AR_SREV_9100(ah))
+		return;
+
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x28000029);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x57160824);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x25980579);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x00000000);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
+	REG_WRITE(ah, AR_PCIE_SERDES, 0x000e1007);
+
+	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+}
+
+static bool ath9k_hw_chip_test(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 regAddr[2] = { AR_STA_ID0, AR_PHY_BASE + (8 << 2) };
+	u32 regHold[2];
+	u32 patternData[4] = { 0x55555555,
+			       0xaaaaaaaa,
+			       0x66666666,
+			       0x99999999 };
+	int i, j;
+
+	for (i = 0; i < 2; i++) {
+		u32 addr = regAddr[i];
+		u32 wrData, rdData;
+
+		regHold[i] = REG_READ(ah, addr);
+		for (j = 0; j < 0x100; j++) {
+			wrData = (j << 16) | j;
+			REG_WRITE(ah, addr, wrData);
+			rdData = REG_READ(ah, addr);
+			if (rdData != wrData) {
+				ath_print(common, ATH_DBG_FATAL,
+					  "address test failed "
+					  "addr: 0x%08x - wr:0x%08x != "
+					  "rd:0x%08x\n",
+					  addr, wrData, rdData);
+				return false;
+			}
+		}
+		for (j = 0; j < 4; j++) {
+			wrData = patternData[j];
+			REG_WRITE(ah, addr, wrData);
+			rdData = REG_READ(ah, addr);
+			if (wrData != rdData) {
+				ath_print(common, ATH_DBG_FATAL,
+					  "address test failed "
+					  "addr: 0x%08x - wr:0x%08x != "
+					  "rd:0x%08x\n",
+					  addr, wrData, rdData);
+				return false;
+			}
+		}
+		REG_WRITE(ah, regAddr[i], regHold[i]);
+	}
+	udelay(100);
+
+	return true;
+}
+
+static const char *ath9k_hw_devname(u16 devid)
+{
+	switch (devid) {
+	case AR5416_DEVID_PCI:
+		return "Atheros 5416";
+	case AR5416_DEVID_PCIE:
+		return "Atheros 5418";
+	case AR9160_DEVID_PCI:
+		return "Atheros 9160";
+	case AR5416_AR9100_DEVID:
+		return "Atheros 9100";
+	case AR9280_DEVID_PCI:
+	case AR9280_DEVID_PCIE:
+		return "Atheros 9280";
+	case AR9285_DEVID_PCIE:
+		return "Atheros 9285";
+	case AR5416_DEVID_AR9287_PCI:
+	case AR5416_DEVID_AR9287_PCIE:
+		return "Atheros 9287";
+	}
+
+	return NULL;
+}
+
+static void ath9k_hw_init_config(struct ath_hw *ah)
+{
+	int i;
+
+	ah->config.dma_beacon_response_time = 2;
+	ah->config.sw_beacon_response_time = 10;
+	ah->config.additional_swba_backoff = 0;
+	ah->config.ack_6mb = 0x0;
+	ah->config.cwm_ignore_extcca = 0;
+	ah->config.pcie_powersave_enable = 0;
+	ah->config.pcie_clock_req = 0;
+	ah->config.pcie_waen = 0;
+	ah->config.analog_shiftreg = 1;
+	ah->config.ht_enable = 1;
+	ah->config.ofdm_trig_low = 200;
+	ah->config.ofdm_trig_high = 500;
+	ah->config.cck_trig_high = 200;
+	ah->config.cck_trig_low = 100;
+	ah->config.enable_ani = 1;
+	ah->config.diversity_control = ATH9K_ANT_VARIABLE;
+	ah->config.antenna_switch_swap = 0;
+
+	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
+		ah->config.spurchans[i][0] = AR_NO_SPUR;
+		ah->config.spurchans[i][1] = AR_NO_SPUR;
+	}
+
+	ah->config.intr_mitigation = true;
+
+	/*
+	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
+	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
+	 * This means we use it for all AR5416 devices, and the few
+	 * minor PCI AR9280 devices out there.
+	 *
+	 * Serialization is required because these devices do not handle
+	 * well the case of two concurrent reads/writes due to the latency
+	 * involved. During one read/write another read/write can be issued
+	 * on another CPU while the previous read/write may still be working
+	 * on our hardware, if we hit this case the hardware poops in a loop.
+	 * We prevent this by serializing reads and writes.
+	 *
+	 * This issue is not present on PCI-Express devices or pre-AR5416
+	 * devices (legacy, 802.11abg).
+	 */
+	if (num_possible_cpus() > 1)
+		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
+}
+
+static void ath9k_hw_init_defaults(struct ath_hw *ah)
+{
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+
+	regulatory->country_code = CTRY_DEFAULT;
+	regulatory->power_limit = MAX_RATE_POWER;
+	regulatory->tp_scale = ATH9K_TP_SCALE_MAX;
+
+	ah->hw_version.magic = AR5416_MAGIC;
+	ah->hw_version.subvendorid = 0;
+
+	ah->ah_flags = 0;
+	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
+		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
+	if (!AR_SREV_9100(ah))
+		ah->ah_flags = AH_USE_EEPROM;
+
+	ah->atim_window = 0;
+	ah->sta_id1_defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
+	ah->beacon_interval = 100;
+	ah->enable_32kHz_clock = DONT_USE_32KHZ;
+	ah->slottime = (u32) -1;
+	ah->acktimeout = (u32) -1;
+	ah->ctstimeout = (u32) -1;
+	ah->globaltxtimeout = (u32) -1;
+
+	ah->gbeacon_rate = 0;
+
+	ah->power_mode = ATH9K_PM_UNDEFINED;
+}
+
+static int ath9k_hw_rfattach(struct ath_hw *ah)
+{
+	bool rfStatus = false;
+	int ecode = 0;
+
+	rfStatus = ath9k_hw_init_rf(ah, &ecode);
+	if (!rfStatus) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "RF setup failed, status: %u\n", ecode);
+		return ecode;
+	}
+
+	return 0;
+}
+
+static int ath9k_hw_rf_claim(struct ath_hw *ah)
+{
+	u32 val;
+
+	REG_WRITE(ah, AR_PHY(0), 0x00000007);
+
+	val = ath9k_hw_get_radiorev(ah);
+	switch (val & AR_RADIO_SREV_MAJOR) {
+	case 0:
+		val = AR_RAD5133_SREV_MAJOR;
+		break;
+	case AR_RAD5133_SREV_MAJOR:
+	case AR_RAD5122_SREV_MAJOR:
+	case AR_RAD2133_SREV_MAJOR:
+	case AR_RAD2122_SREV_MAJOR:
+		break;
+	default:
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Radio Chip Rev 0x%02X not supported\n",
+			  val & AR_RADIO_SREV_MAJOR);
+		return -EOPNOTSUPP;
+	}
+
+	ah->hw_version.analog5GhzRev = val;
+
+	return 0;
+}
+
+static int ath9k_hw_init_macaddr(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 sum;
+	int i;
+	u16 eeval;
+
+	sum = 0;
+	for (i = 0; i < 3; i++) {
+		eeval = ah->eep_ops->get_eeprom(ah, AR_EEPROM_MAC(i));
+		sum += eeval;
+		common->macaddr[2 * i] = eeval >> 8;
+		common->macaddr[2 * i + 1] = eeval & 0xff;
+	}
+	if (sum == 0 || sum == 0xffff * 3)
+		return -EADDRNOTAVAIL;
+
+	return 0;
+}
+
+static void ath9k_hw_init_rxgain_ini(struct ath_hw *ah)
+{
+	u32 rxgain_type;
+
+	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_17) {
+		rxgain_type = ah->eep_ops->get_eeprom(ah, EEP_RXGAIN_TYPE);
+
+		if (rxgain_type == AR5416_EEP_RXGAIN_13DB_BACKOFF)
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_backoff_13db_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_backoff_13db_rxgain_9280_2), 6);
+		else if (rxgain_type == AR5416_EEP_RXGAIN_23DB_BACKOFF)
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_backoff_23db_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_backoff_23db_rxgain_9280_2), 6);
+		else
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_original_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
+	} else {
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+			ar9280Modes_original_rxgain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_rxgain_9280_2), 6);
+	}
+}
+
+static void ath9k_hw_init_txgain_ini(struct ath_hw *ah)
+{
+	u32 txgain_type;
+
+	if (ah->eep_ops->get_eeprom(ah, EEP_MINOR_REV) >= AR5416_EEP_MINOR_VER_19) {
+		txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
+
+		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER)
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9280Modes_high_power_tx_gain_9280_2,
+			ARRAY_SIZE(ar9280Modes_high_power_tx_gain_9280_2), 6);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9280Modes_original_tx_gain_9280_2,
+			ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
+	} else {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9280Modes_original_tx_gain_9280_2,
+		ARRAY_SIZE(ar9280Modes_original_tx_gain_9280_2), 6);
+	}
+}
+
+static int ath9k_hw_post_init(struct ath_hw *ah)
+{
+	int ecode;
+
+	if (!ath9k_hw_chip_test(ah))
+		return -ENODEV;
+
+	ecode = ath9k_hw_rf_claim(ah);
+	if (ecode != 0)
+		return ecode;
+
+	ecode = ath9k_hw_eeprom_init(ah);
+	if (ecode != 0)
+		return ecode;
+
+	ath_print(ath9k_hw_common(ah), ATH_DBG_CONFIG,
+		  "Eeprom VER: %d, REV: %d\n",
+		  ah->eep_ops->get_eeprom_ver(ah),
+		  ah->eep_ops->get_eeprom_rev(ah));
+
+	ecode = ath9k_hw_rfattach(ah);
+	if (ecode != 0)
+		return ecode;
+
+	if (!AR_SREV_9100(ah)) {
+		ath9k_hw_ani_setup(ah);
+		ath9k_hw_ani_init(ah);
+	}
+
+	return 0;
+}
+
+static bool ath9k_hw_devid_supported(u16 devid)
+{
+	switch (devid) {
+	case AR5416_DEVID_PCI:
+	case AR5416_DEVID_PCIE:
+	case AR5416_AR9100_DEVID:
+	case AR9160_DEVID_PCI:
+	case AR9280_DEVID_PCI:
+	case AR9280_DEVID_PCIE:
+	case AR9285_DEVID_PCIE:
+	case AR5416_DEVID_AR9287_PCI:
+	case AR5416_DEVID_AR9287_PCIE:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+static bool ath9k_hw_macversion_supported(u32 macversion)
+{
+	switch (macversion) {
+	case AR_SREV_VERSION_5416_PCI:
+	case AR_SREV_VERSION_5416_PCIE:
+	case AR_SREV_VERSION_9160:
+	case AR_SREV_VERSION_9100:
+	case AR_SREV_VERSION_9280:
+	case AR_SREV_VERSION_9285:
+	case AR_SREV_VERSION_9287:
+		return true;
+	/* Not yet */
+	case AR_SREV_VERSION_9271:
+	default:
+		break;
+	}
+	return false;
+}
+
+static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
+{
+	if (AR_SREV_9160_10_OR_LATER(ah)) {
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			ah->iq_caldata.calData = &iq_cal_single_sample;
+			ah->adcgain_caldata.calData =
+				&adc_gain_cal_single_sample;
+			ah->adcdc_caldata.calData =
+				&adc_dc_cal_single_sample;
+			ah->adcdc_calinitdata.calData =
+				&adc_init_dc_cal;
+		} else {
+			ah->iq_caldata.calData = &iq_cal_multi_sample;
+			ah->adcgain_caldata.calData =
+				&adc_gain_cal_multi_sample;
+			ah->adcdc_caldata.calData =
+				&adc_dc_cal_multi_sample;
+			ah->adcdc_calinitdata.calData =
+				&adc_init_dc_cal;
+		}
+		ah->supp_cals = ADC_GAIN_CAL | ADC_DC_CAL | IQ_MISMATCH_CAL;
+	}
+}
+
+static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
+{
+	if (AR_SREV_9271(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271_1_0,
+			       ARRAY_SIZE(ar9271Modes_9271_1_0), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271_1_0,
+			       ARRAY_SIZE(ar9271Common_9271_1_0), 2);
+		return;
+	}
+
+	if (AR_SREV_9287_11_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1,
+				ARRAY_SIZE(ar9287Modes_9287_1_1), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_1,
+				ARRAY_SIZE(ar9287Common_9287_1_1), 2);
+		if (ah->config.pcie_clock_req)
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_off_L1_9287_1_1,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_1), 2);
+		else
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_always_on_L1_9287_1_1,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_1),
+					2);
+	} else if (AR_SREV_9287_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_0,
+				ARRAY_SIZE(ar9287Modes_9287_1_0), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9287Common_9287_1_0,
+				ARRAY_SIZE(ar9287Common_9287_1_0), 2);
+
+		if (ah->config.pcie_clock_req)
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_off_L1_9287_1_0,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_off_L1_9287_1_0), 2);
+		else
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9287PciePhy_clkreq_always_on_L1_9287_1_0,
+			ARRAY_SIZE(ar9287PciePhy_clkreq_always_on_L1_9287_1_0),
+				  2);
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
+
+
+		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285_1_2,
+			       ARRAY_SIZE(ar9285Modes_9285_1_2), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285_1_2,
+			       ARRAY_SIZE(ar9285Common_9285_1_2), 2);
+
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9285PciePhy_clkreq_off_L1_9285_1_2,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285_1_2), 2);
+		} else {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9285PciePhy_clkreq_always_on_L1_9285_1_2,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
+				  2);
+		}
+	} else if (AR_SREV_9285_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285,
+			       ARRAY_SIZE(ar9285Modes_9285), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9285Common_9285,
+			       ARRAY_SIZE(ar9285Common_9285), 2);
+
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9285PciePhy_clkreq_off_L1_9285,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_off_L1_9285), 2);
+		} else {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			ar9285PciePhy_clkreq_always_on_L1_9285,
+			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285), 2);
+		}
+	} else if (AR_SREV_9280_20_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280_2,
+			       ARRAY_SIZE(ar9280Modes_9280_2), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280_2,
+			       ARRAY_SIZE(ar9280Common_9280_2), 2);
+
+		if (ah->config.pcie_clock_req) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			       ar9280PciePhy_clkreq_off_L1_9280,
+			       ARRAY_SIZE(ar9280PciePhy_clkreq_off_L1_9280),2);
+		} else {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+			       ar9280PciePhy_clkreq_always_on_L1_9280,
+			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
+		}
+		INIT_INI_ARRAY(&ah->iniModesAdditional,
+			       ar9280Modes_fast_clock_9280_2,
+			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
+	} else if (AR_SREV_9280_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar9280Modes_9280,
+			       ARRAY_SIZE(ar9280Modes_9280), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar9280Common_9280,
+			       ARRAY_SIZE(ar9280Common_9280), 2);
+	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9160,
+			       ARRAY_SIZE(ar5416Modes_9160), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9160,
+			       ARRAY_SIZE(ar5416Common_9160), 2);
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9160,
+			       ARRAY_SIZE(ar5416Bank0_9160), 2);
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9160,
+			       ARRAY_SIZE(ar5416BB_RfGain_9160), 3);
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9160,
+			       ARRAY_SIZE(ar5416Bank1_9160), 2);
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9160,
+			       ARRAY_SIZE(ar5416Bank2_9160), 2);
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9160,
+			       ARRAY_SIZE(ar5416Bank3_9160), 3);
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9160,
+			       ARRAY_SIZE(ar5416Bank6_9160), 3);
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9160,
+			       ARRAY_SIZE(ar5416Bank6TPC_9160), 3);
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9160,
+			       ARRAY_SIZE(ar5416Bank7_9160), 2);
+		if (AR_SREV_9160_11(ah)) {
+			INIT_INI_ARRAY(&ah->iniAddac,
+				       ar5416Addac_91601_1,
+				       ARRAY_SIZE(ar5416Addac_91601_1), 2);
+		} else {
+			INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9160,
+				       ARRAY_SIZE(ar5416Addac_9160), 2);
+		}
+	} else if (AR_SREV_9100_OR_LATER(ah)) {
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes_9100,
+			       ARRAY_SIZE(ar5416Modes_9100), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common_9100,
+			       ARRAY_SIZE(ar5416Common_9100), 2);
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0_9100,
+			       ARRAY_SIZE(ar5416Bank0_9100), 2);
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain_9100,
+			       ARRAY_SIZE(ar5416BB_RfGain_9100), 3);
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1_9100,
+			       ARRAY_SIZE(ar5416Bank1_9100), 2);
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2_9100,
+			       ARRAY_SIZE(ar5416Bank2_9100), 2);
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3_9100,
+			       ARRAY_SIZE(ar5416Bank3_9100), 3);
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6_9100,
+			       ARRAY_SIZE(ar5416Bank6_9100), 3);
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC_9100,
+			       ARRAY_SIZE(ar5416Bank6TPC_9100), 3);
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7_9100,
+			       ARRAY_SIZE(ar5416Bank7_9100), 2);
+		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9100,
+			       ARRAY_SIZE(ar5416Addac_9100), 2);
+	} else {
+		INIT_INI_ARRAY(&ah->iniModes, ar5416Modes,
+			       ARRAY_SIZE(ar5416Modes), 6);
+		INIT_INI_ARRAY(&ah->iniCommon, ar5416Common,
+			       ARRAY_SIZE(ar5416Common), 2);
+		INIT_INI_ARRAY(&ah->iniBank0, ar5416Bank0,
+			       ARRAY_SIZE(ar5416Bank0), 2);
+		INIT_INI_ARRAY(&ah->iniBB_RfGain, ar5416BB_RfGain,
+			       ARRAY_SIZE(ar5416BB_RfGain), 3);
+		INIT_INI_ARRAY(&ah->iniBank1, ar5416Bank1,
+			       ARRAY_SIZE(ar5416Bank1), 2);
+		INIT_INI_ARRAY(&ah->iniBank2, ar5416Bank2,
+			       ARRAY_SIZE(ar5416Bank2), 2);
+		INIT_INI_ARRAY(&ah->iniBank3, ar5416Bank3,
+			       ARRAY_SIZE(ar5416Bank3), 3);
+		INIT_INI_ARRAY(&ah->iniBank6, ar5416Bank6,
+			       ARRAY_SIZE(ar5416Bank6), 3);
+		INIT_INI_ARRAY(&ah->iniBank6TPC, ar5416Bank6TPC,
+			       ARRAY_SIZE(ar5416Bank6TPC), 3);
+		INIT_INI_ARRAY(&ah->iniBank7, ar5416Bank7,
+			       ARRAY_SIZE(ar5416Bank7), 2);
+		INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac,
+			       ARRAY_SIZE(ar5416Addac), 2);
+	}
+}
+
+static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
+{
+	if (AR_SREV_9287_11(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+		ar9287Modes_rx_gain_9287_1_1,
+		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_1), 6);
+	else if (AR_SREV_9287_10(ah))
+		INIT_INI_ARRAY(&ah->iniModesRxGain,
+		ar9287Modes_rx_gain_9287_1_0,
+		ARRAY_SIZE(ar9287Modes_rx_gain_9287_1_0), 6);
+	else if (AR_SREV_9280_20(ah))
+		ath9k_hw_init_rxgain_ini(ah);
+
+	if (AR_SREV_9287_11(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9287Modes_tx_gain_9287_1_1,
+		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_1), 6);
+	} else if (AR_SREV_9287_10(ah)) {
+		INIT_INI_ARRAY(&ah->iniModesTxGain,
+		ar9287Modes_tx_gain_9287_1_0,
+		ARRAY_SIZE(ar9287Modes_tx_gain_9287_1_0), 6);
+	} else if (AR_SREV_9280_20(ah)) {
+		ath9k_hw_init_txgain_ini(ah);
+	} else if (AR_SREV_9285_12_OR_LATER(ah)) {
+		u32 txgain_type = ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE);
+
+		/* txgain table */
+		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9285Modes_high_power_tx_gain_9285_1_2,
+			ARRAY_SIZE(ar9285Modes_high_power_tx_gain_9285_1_2), 6);
+		} else {
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+			ar9285Modes_original_tx_gain_9285_1_2,
+			ARRAY_SIZE(ar9285Modes_original_tx_gain_9285_1_2), 6);
+		}
+
+	}
+}
+
+static void ath9k_hw_init_11a_eeprom_fix(struct ath_hw *ah)
+{
+	u32 i, j;
+
+	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
+	    test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes)) {
+
+		/* EEPROM Fixup */
+		for (i = 0; i < ah->iniModes.ia_rows; i++) {
+			u32 reg = INI_RA(&ah->iniModes, i, 0);
+
+			for (j = 1; j < ah->iniModes.ia_columns; j++) {
+				u32 val = INI_RA(&ah->iniModes, i, j);
+
+				INI_RA(&ah->iniModes, i, j) =
+					ath9k_hw_ini_fixup(ah,
+							   &ah->eeprom.def,
+							   reg, val);
+			}
+		}
+	}
+}
+
+int ath9k_hw_init(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int r = 0;
+
+	if (!ath9k_hw_devid_supported(ah->hw_version.devid))
+		return -EOPNOTSUPP;
+
+	ath9k_hw_init_defaults(ah);
+	ath9k_hw_init_config(ah);
+
+	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Couldn't reset chip\n");
+		return -EIO;
+	}
+
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
+		ath_print(common, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
+		return -EIO;
+	}
+
+	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
+		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
+		    (AR_SREV_9280(ah) && !ah->is_pciexpress)) {
+			ah->config.serialize_regmode =
+				SER_REG_MODE_ON;
+		} else {
+			ah->config.serialize_regmode =
+				SER_REG_MODE_OFF;
+		}
+	}
+
+	ath_print(common, ATH_DBG_RESET, "serialize_regmode is %d\n",
+		ah->config.serialize_regmode);
+
+	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Mac Chip Rev 0x%02x.%x is not supported by "
+			  "this driver\n", ah->hw_version.macVersion,
+			  ah->hw_version.macRev);
+		return -EOPNOTSUPP;
+	}
+
+	if (AR_SREV_9100(ah)) {
+		ah->iq_caldata.calData = &iq_cal_multi_sample;
+		ah->supp_cals = IQ_MISMATCH_CAL;
+		ah->is_pciexpress = false;
+	}
+
+	if (AR_SREV_9271(ah))
+		ah->is_pciexpress = false;
+
+	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
+
+	ath9k_hw_init_cal_settings(ah);
+
+	ah->ani_function = ATH9K_ANI_ALL;
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
+
+	ath9k_hw_init_mode_regs(ah);
+
+	if (ah->is_pciexpress)
+		ath9k_hw_configpcipowersave(ah, 0);
+	else
+		ath9k_hw_disablepcie(ah);
+
+	r = ath9k_hw_post_init(ah);
+	if (r)
+		return r;
+
+	ath9k_hw_init_mode_gain_regs(ah);
+	ath9k_hw_fill_cap_info(ah);
+	ath9k_hw_init_11a_eeprom_fix(ah);
+
+	r = ath9k_hw_init_macaddr(ah);
+	if (r) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Failed to initialize MAC address\n");
+		return r;
+	}
+
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		ah->tx_trig_level = (AR_FTRIG_256B >> AR_FTRIG_S);
+	else
+		ah->tx_trig_level = (AR_FTRIG_512B >> AR_FTRIG_S);
+
+	ath9k_init_nfcal_hist_buffer(ah);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath9k_hw_init);
+
+static void ath9k_hw_init_bb(struct ath_hw *ah,
+			     struct ath9k_channel *chan)
+{
+	u32 synthDelay;
+
+	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
+	if (IS_CHAN_B(chan))
+		synthDelay = (4 * synthDelay) / 22;
+	else
+		synthDelay /= 10;
+
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+
+	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+}
+
+static void ath9k_hw_init_qos(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_MIC_QOS_CONTROL, 0x100aa);
+	REG_WRITE(ah, AR_MIC_QOS_SELECT, 0x3210);
+
+	REG_WRITE(ah, AR_QOS_NO_ACK,
+		  SM(2, AR_QOS_NO_ACK_TWO_BIT) |
+		  SM(5, AR_QOS_NO_ACK_BIT_OFF) |
+		  SM(0, AR_QOS_NO_ACK_BYTE_OFF));
+
+	REG_WRITE(ah, AR_TXOP_X, AR_TXOP_X_VAL);
+	REG_WRITE(ah, AR_TXOP_0_3, 0xFFFFFFFF);
+	REG_WRITE(ah, AR_TXOP_4_7, 0xFFFFFFFF);
+	REG_WRITE(ah, AR_TXOP_8_11, 0xFFFFFFFF);
+	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
+}
+
+static void ath9k_hw_init_pll(struct ath_hw *ah,
+			      struct ath9k_channel *chan)
+{
+	u32 pll;
+
+	if (AR_SREV_9100(ah)) {
+		if (chan && IS_CHAN_5GHZ(chan))
+			pll = 0x1450;
+		else
+			pll = 0x1458;
+	} else {
+		if (AR_SREV_9280_10_OR_LATER(ah)) {
+			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
+
+			if (chan && IS_CHAN_HALF_RATE(chan))
+				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
+			else if (chan && IS_CHAN_QUARTER_RATE(chan))
+				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
+
+			if (chan && IS_CHAN_5GHZ(chan)) {
+				pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
+
+
+				if (AR_SREV_9280_20(ah)) {
+					if (((chan->channel % 20) == 0)
+					    || ((chan->channel % 10) == 0))
+						pll = 0x2850;
+					else
+						pll = 0x142c;
+				}
+			} else {
+				pll |= SM(0x2c, AR_RTC_9160_PLL_DIV);
+			}
+
+		} else if (AR_SREV_9160_10_OR_LATER(ah)) {
+
+			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
+
+			if (chan && IS_CHAN_HALF_RATE(chan))
+				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
+			else if (chan && IS_CHAN_QUARTER_RATE(chan))
+				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
+
+			if (chan && IS_CHAN_5GHZ(chan))
+				pll |= SM(0x50, AR_RTC_9160_PLL_DIV);
+			else
+				pll |= SM(0x58, AR_RTC_9160_PLL_DIV);
+		} else {
+			pll = AR_RTC_PLL_REFDIV_5 | AR_RTC_PLL_DIV2;
+
+			if (chan && IS_CHAN_HALF_RATE(chan))
+				pll |= SM(0x1, AR_RTC_PLL_CLKSEL);
+			else if (chan && IS_CHAN_QUARTER_RATE(chan))
+				pll |= SM(0x2, AR_RTC_PLL_CLKSEL);
+
+			if (chan && IS_CHAN_5GHZ(chan))
+				pll |= SM(0xa, AR_RTC_PLL_DIV);
+			else
+				pll |= SM(0xb, AR_RTC_PLL_DIV);
+		}
+	}
+	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
+
+	udelay(RTC_PLL_SETTLE_DELAY);
+
+	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
+}
+
+static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
+{
+	int rx_chainmask, tx_chainmask;
+
+	rx_chainmask = ah->rxchainmask;
+	tx_chainmask = ah->txchainmask;
+
+	switch (rx_chainmask) {
+	case 0x5:
+		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
+			    AR_PHY_SWAP_ALT_CHAIN);
+	case 0x3:
+		if (((ah)->hw_version.macVersion <= AR_SREV_VERSION_9160)) {
+			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
+			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
+			break;
+		}
+	case 0x1:
+	case 0x2:
+	case 0x7:
+		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
+		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
+		break;
+	default:
+		break;
+	}
+
+	REG_WRITE(ah, AR_SELFGEN_MASK, tx_chainmask);
+	if (tx_chainmask == 0x5) {
+		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
+			    AR_PHY_SWAP_ALT_CHAIN);
+	}
+	if (AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_PHY_ANALOG_SWAP,
+			  REG_READ(ah, AR_PHY_ANALOG_SWAP) | 0x00000001);
+}
+
+static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
+					  enum nl80211_iftype opmode)
+{
+	ah->mask_reg = AR_IMR_TXERR |
+		AR_IMR_TXURN |
+		AR_IMR_RXERR |
+		AR_IMR_RXORN |
+		AR_IMR_BCNMISC;
+
+	if (ah->config.intr_mitigation)
+		ah->mask_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
+	else
+		ah->mask_reg |= AR_IMR_RXOK;
+
+	ah->mask_reg |= AR_IMR_TXOK;
+
+	if (opmode == NL80211_IFTYPE_AP)
+		ah->mask_reg |= AR_IMR_MIB;
+
+	REG_WRITE(ah, AR_IMR, ah->mask_reg);
+	REG_WRITE(ah, AR_IMR_S2, REG_READ(ah, AR_IMR_S2) | AR_IMR_S2_GTT);
+
+	if (!AR_SREV_9100(ah)) {
+		REG_WRITE(ah, AR_INTR_SYNC_CAUSE, 0xFFFFFFFF);
+		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, AR_INTR_SYNC_DEFAULT);
+		REG_WRITE(ah, AR_INTR_SYNC_MASK, 0);
+	}
+}
+
+static bool ath9k_hw_set_ack_timeout(struct ath_hw *ah, u32 us)
+{
+	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_ACK))) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "bad ack timeout %u\n", us);
+		ah->acktimeout = (u32) -1;
+		return false;
+	} else {
+		REG_RMW_FIELD(ah, AR_TIME_OUT,
+			      AR_TIME_OUT_ACK, ath9k_hw_mac_to_clks(ah, us));
+		ah->acktimeout = us;
+		return true;
+	}
+}
+
+static bool ath9k_hw_set_cts_timeout(struct ath_hw *ah, u32 us)
+{
+	if (us > ath9k_hw_mac_to_usec(ah, MS(0xffffffff, AR_TIME_OUT_CTS))) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "bad cts timeout %u\n", us);
+		ah->ctstimeout = (u32) -1;
+		return false;
+	} else {
+		REG_RMW_FIELD(ah, AR_TIME_OUT,
+			      AR_TIME_OUT_CTS, ath9k_hw_mac_to_clks(ah, us));
+		ah->ctstimeout = us;
+		return true;
+	}
+}
+
+static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
+{
+	if (tu > 0xFFFF) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_XMIT,
+			  "bad global tx timeout %u\n", tu);
+		ah->globaltxtimeout = (u32) -1;
+		return false;
+	} else {
+		REG_RMW_FIELD(ah, AR_GTXTO, AR_GTXTO_TIMEOUT_LIMIT, tu);
+		ah->globaltxtimeout = tu;
+		return true;
+	}
+}
+
+static void ath9k_hw_init_user_settings(struct ath_hw *ah)
+{
+	ath_print(ath9k_hw_common(ah), ATH_DBG_RESET, "ah->misc_mode 0x%x\n",
+		  ah->misc_mode);
+
+	if (ah->misc_mode != 0)
+		REG_WRITE(ah, AR_PCU_MISC,
+			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
+	if (ah->slottime != (u32) -1)
+		ath9k_hw_setslottime(ah, ah->slottime);
+	if (ah->acktimeout != (u32) -1)
+		ath9k_hw_set_ack_timeout(ah, ah->acktimeout);
+	if (ah->ctstimeout != (u32) -1)
+		ath9k_hw_set_cts_timeout(ah, ah->ctstimeout);
+	if (ah->globaltxtimeout != (u32) -1)
+		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
+}
+
+const char *ath9k_hw_probe(u16 vendorid, u16 devid)
+{
+	return vendorid == ATHEROS_VENDOR_ID ?
+		ath9k_hw_devname(devid) : NULL;
+}
+
+void ath9k_hw_detach(struct ath_hw *ah)
+{
+	if (!AR_SREV_9100(ah))
+		ath9k_hw_ani_disable(ah);
+
+	ath9k_hw_rf_free(ah);
+	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+	kfree(ah);
+	ah = NULL;
+}
+EXPORT_SYMBOL(ath9k_hw_detach);
+
+/*******/
+/* INI */
+/*******/
+
+static void ath9k_hw_override_ini(struct ath_hw *ah,
+				  struct ath9k_channel *chan)
+{
+	u32 val;
+
+	if (AR_SREV_9271(ah)) {
+		/*
+		 * Enable spectral scan to solution for issues with stuck
+		 * beacons on AR9271 1.0. The beacon stuck issue is not seeon on
+		 * AR9271 1.1
+		 */
+		if (AR_SREV_9271_10(ah)) {
+			val = REG_READ(ah, AR_PHY_SPECTRAL_SCAN) | AR_PHY_SPECTRAL_SCAN_ENABLE;
+			REG_WRITE(ah, AR_PHY_SPECTRAL_SCAN, val);
+		}
+		else if (AR_SREV_9271_11(ah))
+			/*
+			 * change AR_PHY_RF_CTL3 setting to fix MAC issue
+			 * present on AR9271 1.1
+			 */
+			REG_WRITE(ah, AR_PHY_RF_CTL3, 0x3a020001);
+		return;
+	}
+
+	/*
+	 * Set the RX_ABORT and RX_DIS and clear if off only after
+	 * RXE is set for MAC. This prevents frames with corrupted
+	 * descriptor status.
+	 */
+	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+
+
+	if (!AR_SREV_5416_20_OR_LATER(ah) ||
+	    AR_SREV_9280_10_OR_LATER(ah))
+		return;
+	/*
+	 * Disable BB clock gating
+	 * Necessary to avoid issues on AR5416 2.0
+	 */
+	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
+}
+
+static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
+			      struct ar5416_eeprom_def *pEepData,
+			      u32 reg, u32 value)
+{
+	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	switch (ah->hw_version.devid) {
+	case AR9280_DEVID_PCI:
+		if (reg == 0x7894) {
+			ath_print(common, ATH_DBG_EEPROM,
+				"ini VAL: %x  EEPROM: %x\n", value,
+				(pBase->version & 0xff));
+
+			if ((pBase->version & 0xff) > 0x0a) {
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PWDCLKIND: %d\n",
+					  pBase->pwdclkind);
+				value &= ~AR_AN_TOP2_PWDCLKIND;
+				value |= AR_AN_TOP2_PWDCLKIND &
+					(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
+			} else {
+				ath_print(common, ATH_DBG_EEPROM,
+					  "PWDCLKIND Earlier Rev\n");
+			}
+
+			ath_print(common, ATH_DBG_EEPROM,
+				  "final ini VAL: %x\n", value);
+		}
+		break;
+	}
+
+	return value;
+}
+
+static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
+			      struct ar5416_eeprom_def *pEepData,
+			      u32 reg, u32 value)
+{
+	if (ah->eep_map == EEP_MAP_4KBITS)
+		return value;
+	else
+		return ath9k_hw_def_ini_fixup(ah, pEepData, reg, value);
+}
+
+static void ath9k_olc_init(struct ath_hw *ah)
+{
+	u32 i;
+
+	if (OLC_FOR_AR9287_10_LATER) {
+		REG_SET_BIT(ah, AR_PHY_TX_PWRCTRL9,
+				AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL);
+		ath9k_hw_analog_shift_rmw(ah, AR9287_AN_TXPC0,
+				AR9287_AN_TXPC0_TXPCMODE,
+				AR9287_AN_TXPC0_TXPCMODE_S,
+				AR9287_AN_TXPC0_TXPCMODE_TEMPSENSE);
+		udelay(100);
+	} else {
+		for (i = 0; i < AR9280_TX_GAIN_TABLE_SIZE; i++)
+			ah->originalGain[i] =
+				MS(REG_READ(ah, AR_PHY_TX_GAIN_TBL1 + i * 4),
+						AR_PHY_TX_GAIN);
+		ah->PDADCdelta = 0;
+	}
+}
+
+static u32 ath9k_regd_get_ctl(struct ath_regulatory *reg,
+			      struct ath9k_channel *chan)
+{
+	u32 ctl = ath_regd_get_band_ctl(reg, chan->chan->band);
+
+	if (IS_CHAN_B(chan))
+		ctl |= CTL_11B;
+	else if (IS_CHAN_G(chan))
+		ctl |= CTL_11G;
+	else
+		ctl |= CTL_11A;
+
+	return ctl;
+}
+
+static int ath9k_hw_process_ini(struct ath_hw *ah,
+				struct ath9k_channel *chan)
+{
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	int i, regWrites = 0;
+	struct ieee80211_channel *channel = chan->chan;
+	u32 modesIndex, freqIndex;
+
+	switch (chan->chanmode) {
+	case CHANNEL_A:
+	case CHANNEL_A_HT20:
+		modesIndex = 1;
+		freqIndex = 1;
+		break;
+	case CHANNEL_A_HT40PLUS:
+	case CHANNEL_A_HT40MINUS:
+		modesIndex = 2;
+		freqIndex = 1;
+		break;
+	case CHANNEL_G:
+	case CHANNEL_G_HT20:
+	case CHANNEL_B:
+		modesIndex = 4;
+		freqIndex = 2;
+		break;
+	case CHANNEL_G_HT40PLUS:
+	case CHANNEL_G_HT40MINUS:
+		modesIndex = 3;
+		freqIndex = 2;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	REG_WRITE(ah, AR_PHY(0), 0x00000007);
+	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
+	ah->eep_ops->set_addac(ah, chan);
+
+	if (AR_SREV_5416_22_OR_LATER(ah)) {
+		REG_WRITE_ARRAY(&ah->iniAddac, 1, regWrites);
+	} else {
+		struct ar5416IniArray temp;
+		u32 addacSize =
+			sizeof(u32) * ah->iniAddac.ia_rows *
+			ah->iniAddac.ia_columns;
+
+		memcpy(ah->addac5416_21,
+		       ah->iniAddac.ia_array, addacSize);
+
+		(ah->addac5416_21)[31 * ah->iniAddac.ia_columns + 1] = 0;
+
+		temp.ia_array = ah->addac5416_21;
+		temp.ia_columns = ah->iniAddac.ia_columns;
+		temp.ia_rows = ah->iniAddac.ia_rows;
+		REG_WRITE_ARRAY(&temp, 1, regWrites);
+	}
+
+	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
+
+	for (i = 0; i < ah->iniModes.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniModes, i, 0);
+		u32 val = INI_RA(&ah->iniModes, i, modesIndex);
+
+		REG_WRITE(ah, reg, val);
+
+		if (reg >= 0x7800 && reg < 0x78a0
+		    && ah->config.analog_shiftreg) {
+			udelay(100);
+		}
+
+		DO_DELAY(regWrites);
+	}
+
+	if (AR_SREV_9280(ah) || AR_SREV_9287_10_OR_LATER(ah))
+		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
+
+	if (AR_SREV_9280(ah) || AR_SREV_9285_12_OR_LATER(ah) ||
+	    AR_SREV_9287_10_OR_LATER(ah))
+		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+
+	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniCommon, i, 0);
+		u32 val = INI_RA(&ah->iniCommon, i, 1);
+
+		REG_WRITE(ah, reg, val);
+
+		if (reg >= 0x7800 && reg < 0x78a0
+		    && ah->config.analog_shiftreg) {
+			udelay(100);
+		}
+
+		DO_DELAY(regWrites);
+	}
+
+	ath9k_hw_write_regs(ah, modesIndex, freqIndex, regWrites);
+
+	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
+		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
+				regWrites);
+	}
+
+	ath9k_hw_override_ini(ah, chan);
+	ath9k_hw_set_regs(ah, chan);
+	ath9k_hw_init_chain_masks(ah);
+
+	if (OLC_FOR_AR9280_20_LATER)
+		ath9k_olc_init(ah);
+
+	ah->eep_ops->set_txpower(ah, chan,
+				 ath9k_regd_get_ctl(regulatory, chan),
+				 channel->max_antenna_gain * 2,
+				 channel->max_power * 2,
+				 min((u32) MAX_RATE_POWER,
+				 (u32) regulatory->power_limit));
+
+	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "ar5416SetRfRegs failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/****************************************/
+/* Reset and Channel Switching Routines */
+/****************************************/
+
+static void ath9k_hw_set_rfmode(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	u32 rfMode = 0;
+
+	if (chan == NULL)
+		return;
+
+	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
+		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
+
+	if (!AR_SREV_9280_10_OR_LATER(ah))
+		rfMode |= (IS_CHAN_5GHZ(chan)) ?
+			AR_PHY_MODE_RF5GHZ : AR_PHY_MODE_RF2GHZ;
+
+	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan))
+		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
+
+	REG_WRITE(ah, AR_PHY_MODE, rfMode);
+}
+
+static void ath9k_hw_mark_phy_inactive(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+}
+
+static inline void ath9k_hw_set_dma(struct ath_hw *ah)
+{
+	u32 regval;
+
+	/*
+	 * set AHB_MODE not to do cacheline prefetches
+	*/
+	regval = REG_READ(ah, AR_AHB_MODE);
+	REG_WRITE(ah, AR_AHB_MODE, regval | AR_AHB_PREFETCH_RD_EN);
+
+	/*
+	 * let mac dma reads be in 128 byte chunks
+	 */
+	regval = REG_READ(ah, AR_TXCFG) & ~AR_TXCFG_DMASZ_MASK;
+	REG_WRITE(ah, AR_TXCFG, regval | AR_TXCFG_DMASZ_128B);
+
+	/*
+	 * Restore TX Trigger Level to its pre-reset value.
+	 * The initial value depends on whether aggregation is enabled, and is
+	 * adjusted whenever underruns are detected.
+	 */
+	REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->tx_trig_level);
+
+	/*
+	 * let mac dma writes be in 128 byte chunks
+	 */
+	regval = REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_DMASZ_MASK;
+	REG_WRITE(ah, AR_RXCFG, regval | AR_RXCFG_DMASZ_128B);
+
+	/*
+	 * Setup receive FIFO threshold to hold off TX activities
+	 */
+	REG_WRITE(ah, AR_RXFIFO_CFG, 0x200);
+
+	/*
+	 * reduce the number of usable entries in PCU TXBUF to avoid
+	 * wrap around issues.
+	 */
+	if (AR_SREV_9285(ah)) {
+		/* For AR9285 the number of Fifos are reduced to half.
+		 * So set the usable tx buf size also to half to
+		 * avoid data/delimiter underruns
+		 */
+		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
+			  AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE);
+	} else if (!AR_SREV_9271(ah)) {
+		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
+			  AR_PCU_TXBUF_CTRL_USABLE_SIZE);
+	}
+}
+
+static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
+{
+	u32 val;
+
+	val = REG_READ(ah, AR_STA_ID1);
+	val &= ~(AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC);
+	switch (opmode) {
+	case NL80211_IFTYPE_AP:
+		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_STA_AP
+			  | AR_STA_ID1_KSRCH_MODE);
+		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_ADHOC
+			  | AR_STA_ID1_KSRCH_MODE);
+		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_MONITOR:
+		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_KSRCH_MODE);
+		break;
+	}
+}
+
+static inline void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah,
+						 u32 coef_scaled,
+						 u32 *coef_mantissa,
+						 u32 *coef_exponent)
+{
+	u32 coef_exp, coef_man;
+
+	for (coef_exp = 31; coef_exp > 0; coef_exp--)
+		if ((coef_scaled >> coef_exp) & 0x1)
+			break;
+
+	coef_exp = 14 - (coef_exp - COEF_SCALE_S);
+
+	coef_man = coef_scaled + (1 << (COEF_SCALE_S - coef_exp - 1));
+
+	*coef_mantissa = coef_man >> (COEF_SCALE_S - coef_exp);
+	*coef_exponent = coef_exp - 16;
+}
+
+static void ath9k_hw_set_delta_slope(struct ath_hw *ah,
+				     struct ath9k_channel *chan)
+{
+	u32 coef_scaled, ds_coef_exp, ds_coef_man;
+	u32 clockMhzScaled = 0x64000000;
+	struct chan_centers centers;
+
+	if (IS_CHAN_HALF_RATE(chan))
+		clockMhzScaled = clockMhzScaled >> 1;
+	else if (IS_CHAN_QUARTER_RATE(chan))
+		clockMhzScaled = clockMhzScaled >> 2;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	coef_scaled = clockMhzScaled / centers.synth_center;
+
+	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
+				      &ds_coef_exp);
+
+	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
+		      AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
+		      AR_PHY_TIMING3_DSC_EXP, ds_coef_exp);
+
+	coef_scaled = (9 * coef_scaled) / 10;
+
+	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
+				      &ds_coef_exp);
+
+	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
+		      AR_PHY_HALFGI_DSC_MAN, ds_coef_man);
+	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
+		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
+}
+
+static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
+{
+	u32 rst_flags;
+	u32 tmpReg;
+
+	if (AR_SREV_9100(ah)) {
+		u32 val = REG_READ(ah, AR_RTC_DERIVED_CLK);
+		val &= ~AR_RTC_DERIVED_CLK_PERIOD;
+		val |= SM(1, AR_RTC_DERIVED_CLK_PERIOD);
+		REG_WRITE(ah, AR_RTC_DERIVED_CLK, val);
+		(void)REG_READ(ah, AR_RTC_DERIVED_CLK);
+	}
+
+	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
+		  AR_RTC_FORCE_WAKE_ON_INT);
+
+	if (AR_SREV_9100(ah)) {
+		rst_flags = AR_RTC_RC_MAC_WARM | AR_RTC_RC_MAC_COLD |
+			AR_RTC_RC_COLD_RESET | AR_RTC_RC_WARM_RESET;
+	} else {
+		tmpReg = REG_READ(ah, AR_INTR_SYNC_CAUSE);
+		if (tmpReg &
+		    (AR_INTR_SYNC_LOCAL_TIMEOUT |
+		     AR_INTR_SYNC_RADM_CPL_TIMEOUT)) {
+			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
+			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
+		} else {
+			REG_WRITE(ah, AR_RC, AR_RC_AHB);
+		}
+
+		rst_flags = AR_RTC_RC_MAC_WARM;
+		if (type == ATH9K_RESET_COLD)
+			rst_flags |= AR_RTC_RC_MAC_COLD;
+	}
+
+	REG_WRITE(ah, AR_RTC_RC, rst_flags);
+	udelay(50);
+
+	REG_WRITE(ah, AR_RTC_RC, 0);
+	if (!ath9k_hw_wait(ah, AR_RTC_RC, AR_RTC_RC_M, 0, AH_WAIT_TIMEOUT)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "RTC stuck in MAC reset\n");
+		return false;
+	}
+
+	if (!AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_RC, 0);
+
+	ath9k_hw_init_pll(ah, NULL);
+
+	if (AR_SREV_9100(ah))
+		udelay(50);
+
+	return true;
+}
+
+static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
+		  AR_RTC_FORCE_WAKE_ON_INT);
+
+	if (!AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_RC, AR_RC_AHB);
+
+	REG_WRITE(ah, AR_RTC_RESET, 0);
+	udelay(2);
+
+	if (!AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_RC, 0);
+
+	REG_WRITE(ah, AR_RTC_RESET, 1);
+
+	if (!ath9k_hw_wait(ah,
+			   AR_RTC_STATUS,
+			   AR_RTC_STATUS_M,
+			   AR_RTC_STATUS_ON,
+			   AH_WAIT_TIMEOUT)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "RTC not waking up\n");
+		return false;
+	}
+
+	ath9k_hw_read_revisions(ah);
+
+	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
+}
+
+static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
+{
+	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
+		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
+
+	switch (type) {
+	case ATH9K_RESET_POWER_ON:
+		return ath9k_hw_set_reset_power_on(ah);
+	case ATH9K_RESET_WARM:
+	case ATH9K_RESET_COLD:
+		return ath9k_hw_set_reset(ah, type);
+	default:
+		return false;
+	}
+}
+
+static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	u32 phymode;
+	u32 enableDacFifo = 0;
+
+	if (AR_SREV_9285_10_OR_LATER(ah))
+		enableDacFifo = (REG_READ(ah, AR_PHY_TURBO) &
+					 AR_PHY_FC_ENABLE_DAC_FIFO);
+
+	phymode = AR_PHY_FC_HT_EN | AR_PHY_FC_SHORT_GI_40
+		| AR_PHY_FC_SINGLE_HT_LTF1 | AR_PHY_FC_WALSH | enableDacFifo;
+
+	if (IS_CHAN_HT40(chan)) {
+		phymode |= AR_PHY_FC_DYN2040_EN;
+
+		if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
+		    (chan->chanmode == CHANNEL_G_HT40PLUS))
+			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
+
+	}
+	REG_WRITE(ah, AR_PHY_TURBO, phymode);
+
+	ath9k_hw_set11nmac2040(ah);
+
+	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
+	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
+}
+
+static bool ath9k_hw_chip_reset(struct ath_hw *ah,
+				struct ath9k_channel *chan)
+{
+	if (OLC_FOR_AR9280_20_LATER) {
+		if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
+			return false;
+	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
+		return false;
+
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
+		return false;
+
+	ah->chip_fullsleep = false;
+	ath9k_hw_init_pll(ah, chan);
+	ath9k_hw_set_rfmode(ah, chan);
+
+	return true;
+}
+
+static bool ath9k_hw_channel_change(struct ath_hw *ah,
+				    struct ath9k_channel *chan)
+{
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_channel *channel = chan->chan;
+	u32 synthDelay, qnum;
+
+	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
+		if (ath9k_hw_numtxpending(ah, qnum)) {
+			ath_print(common, ATH_DBG_QUEUE,
+				  "Transmit frames pending on "
+				  "queue %d\n", qnum);
+			return false;
+		}
+	}
+
+	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
+	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
+			   AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT)) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Could not kill baseband RX\n");
+		return false;
+	}
+
+	ath9k_hw_set_regs(ah, chan);
+
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		ath9k_hw_ar9280_set_channel(ah, chan);
+	} else {
+		if (!(ath9k_hw_set_channel(ah, chan))) {
+			ath_print(common, ATH_DBG_FATAL,
+				  "Failed to set channel\n");
+			return false;
+		}
+	}
+
+	ah->eep_ops->set_txpower(ah, chan,
+			     ath9k_regd_get_ctl(regulatory, chan),
+			     channel->max_antenna_gain * 2,
+			     channel->max_power * 2,
+			     min((u32) MAX_RATE_POWER,
+			     (u32) regulatory->power_limit));
+
+	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
+	if (IS_CHAN_B(chan))
+		synthDelay = (4 * synthDelay) / 22;
+	else
+		synthDelay /= 10;
+
+	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+
+	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
+
+	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
+		ath9k_hw_set_delta_slope(ah, chan);
+
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ath9k_hw_9280_spur_mitigate(ah, chan);
+	else
+		ath9k_hw_spur_mitigate(ah, chan);
+
+	if (!chan->oneTimeCalsDone)
+		chan->oneTimeCalsDone = true;
+
+	return true;
+}
+
+static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	int bb_spur = AR_NO_SPUR;
+	int freq;
+	int bin, cur_bin;
+	int bb_spur_off, spur_subchannel_sd;
+	int spur_freq_sd;
+	int spur_delta_phase;
+	int denominator;
+	int upper, lower, cur_vit_mask;
+	int tmp, newVal;
+	int i;
+	int pilot_mask_reg[4] = { AR_PHY_TIMING7, AR_PHY_TIMING8,
+			  AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
+	};
+	int chan_mask_reg[4] = { AR_PHY_TIMING9, AR_PHY_TIMING10,
+			 AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
+	};
+	int inc[4] = { 0, 100, 0, 0 };
+	struct chan_centers centers;
+
+	int8_t mask_m[123];
+	int8_t mask_p[123];
+	int8_t mask_amt;
+	int tmp_mask;
+	int cur_bb_spur;
+	bool is2GHz = IS_CHAN_2GHZ(chan);
+
+	memset(&mask_m, 0, sizeof(int8_t) * 123);
+	memset(&mask_p, 0, sizeof(int8_t) * 123);
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	freq = centers.synth_center;
+
+	ah->config.spurmode = SPUR_ENABLE_EEPROM;
+	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
+		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
+
+		if (is2GHz)
+			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_2GHZ;
+		else
+			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_5GHZ;
+
+		if (AR_NO_SPUR == cur_bb_spur)
+			break;
+		cur_bb_spur = cur_bb_spur - freq;
+
+		if (IS_CHAN_HT40(chan)) {
+			if ((cur_bb_spur > -AR_SPUR_FEEQ_BOUND_HT40) &&
+			    (cur_bb_spur < AR_SPUR_FEEQ_BOUND_HT40)) {
+				bb_spur = cur_bb_spur;
+				break;
+			}
+		} else if ((cur_bb_spur > -AR_SPUR_FEEQ_BOUND_HT20) &&
+			   (cur_bb_spur < AR_SPUR_FEEQ_BOUND_HT20)) {
+			bb_spur = cur_bb_spur;
+			break;
+		}
+	}
+
+	if (AR_NO_SPUR == bb_spur) {
+		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
+			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
+		return;
+	} else {
+		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
+			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
+	}
+
+	bin = bb_spur * 320;
+
+	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
+
+	newVal = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
+			AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
+			AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
+			AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK);
+	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0), newVal);
+
+	newVal = (AR_PHY_SPUR_REG_MASK_RATE_CNTL |
+		  AR_PHY_SPUR_REG_ENABLE_MASK_PPM |
+		  AR_PHY_SPUR_REG_MASK_RATE_SELECT |
+		  AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI |
+		  SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
+	REG_WRITE(ah, AR_PHY_SPUR_REG, newVal);
+
+	if (IS_CHAN_HT40(chan)) {
+		if (bb_spur < 0) {
+			spur_subchannel_sd = 1;
+			bb_spur_off = bb_spur + 10;
+		} else {
+			spur_subchannel_sd = 0;
+			bb_spur_off = bb_spur - 10;
+		}
+	} else {
+		spur_subchannel_sd = 0;
+		bb_spur_off = bb_spur;
+	}
+
+	if (IS_CHAN_HT40(chan))
+		spur_delta_phase =
+			((bb_spur * 262144) /
+			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+	else
+		spur_delta_phase =
+			((bb_spur * 524288) /
+			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+
+	denominator = IS_CHAN_2GHZ(chan) ? 44 : 40;
+	spur_freq_sd = ((bb_spur_off * 2048) / denominator) & 0x3ff;
+
+	newVal = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
+		  SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
+		  SM(spur_delta_phase, AR_PHY_TIMING11_SPUR_DELTA_PHASE));
+	REG_WRITE(ah, AR_PHY_TIMING11, newVal);
+
+	newVal = spur_subchannel_sd << AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S;
+	REG_WRITE(ah, AR_PHY_SFCORR_EXT, newVal);
+
+	cur_bin = -6000;
+	upper = bin + 100;
+	lower = bin - 100;
+
+	for (i = 0; i < 4; i++) {
+		int pilot_mask = 0;
+		int chan_mask = 0;
+		int bp = 0;
+		for (bp = 0; bp < 30; bp++) {
+			if ((cur_bin > lower) && (cur_bin < upper)) {
+				pilot_mask = pilot_mask | 0x1 << bp;
+				chan_mask = chan_mask | 0x1 << bp;
+			}
+			cur_bin += 100;
+		}
+		cur_bin += inc[i];
+		REG_WRITE(ah, pilot_mask_reg[i], pilot_mask);
+		REG_WRITE(ah, chan_mask_reg[i], chan_mask);
+	}
+
+	cur_vit_mask = 6100;
+	upper = bin + 120;
+	lower = bin - 120;
+
+	for (i = 0; i < 123; i++) {
+		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
+
+			/* workaround for gcc bug #37014 */
+			volatile int tmp_v = abs(cur_vit_mask - bin);
+
+			if (tmp_v < 75)
+				mask_amt = 1;
+			else
+				mask_amt = 0;
+			if (cur_vit_mask < 0)
+				mask_m[abs(cur_vit_mask / 100)] = mask_amt;
+			else
+				mask_p[cur_vit_mask / 100] = mask_amt;
+		}
+		cur_vit_mask -= 100;
+	}
+
+	tmp_mask = (mask_m[46] << 30) | (mask_m[47] << 28)
+		| (mask_m[48] << 26) | (mask_m[49] << 24)
+		| (mask_m[50] << 22) | (mask_m[51] << 20)
+		| (mask_m[52] << 18) | (mask_m[53] << 16)
+		| (mask_m[54] << 14) | (mask_m[55] << 12)
+		| (mask_m[56] << 10) | (mask_m[57] << 8)
+		| (mask_m[58] << 6) | (mask_m[59] << 4)
+		| (mask_m[60] << 2) | (mask_m[61] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_1, tmp_mask);
+	REG_WRITE(ah, AR_PHY_VIT_MASK2_M_46_61, tmp_mask);
+
+	tmp_mask = (mask_m[31] << 28)
+		| (mask_m[32] << 26) | (mask_m[33] << 24)
+		| (mask_m[34] << 22) | (mask_m[35] << 20)
+		| (mask_m[36] << 18) | (mask_m[37] << 16)
+		| (mask_m[48] << 14) | (mask_m[39] << 12)
+		| (mask_m[40] << 10) | (mask_m[41] << 8)
+		| (mask_m[42] << 6) | (mask_m[43] << 4)
+		| (mask_m[44] << 2) | (mask_m[45] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_2, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_31_45, tmp_mask);
+
+	tmp_mask = (mask_m[16] << 30) | (mask_m[16] << 28)
+		| (mask_m[18] << 26) | (mask_m[18] << 24)
+		| (mask_m[20] << 22) | (mask_m[20] << 20)
+		| (mask_m[22] << 18) | (mask_m[22] << 16)
+		| (mask_m[24] << 14) | (mask_m[24] << 12)
+		| (mask_m[25] << 10) | (mask_m[26] << 8)
+		| (mask_m[27] << 6) | (mask_m[28] << 4)
+		| (mask_m[29] << 2) | (mask_m[30] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_3, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_16_30, tmp_mask);
+
+	tmp_mask = (mask_m[0] << 30) | (mask_m[1] << 28)
+		| (mask_m[2] << 26) | (mask_m[3] << 24)
+		| (mask_m[4] << 22) | (mask_m[5] << 20)
+		| (mask_m[6] << 18) | (mask_m[7] << 16)
+		| (mask_m[8] << 14) | (mask_m[9] << 12)
+		| (mask_m[10] << 10) | (mask_m[11] << 8)
+		| (mask_m[12] << 6) | (mask_m[13] << 4)
+		| (mask_m[14] << 2) | (mask_m[15] << 0);
+	REG_WRITE(ah, AR_PHY_MASK_CTL, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_00_15, tmp_mask);
+
+	tmp_mask = (mask_p[15] << 28)
+		| (mask_p[14] << 26) | (mask_p[13] << 24)
+		| (mask_p[12] << 22) | (mask_p[11] << 20)
+		| (mask_p[10] << 18) | (mask_p[9] << 16)
+		| (mask_p[8] << 14) | (mask_p[7] << 12)
+		| (mask_p[6] << 10) | (mask_p[5] << 8)
+		| (mask_p[4] << 6) | (mask_p[3] << 4)
+		| (mask_p[2] << 2) | (mask_p[1] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_1, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_15_01, tmp_mask);
+
+	tmp_mask = (mask_p[30] << 28)
+		| (mask_p[29] << 26) | (mask_p[28] << 24)
+		| (mask_p[27] << 22) | (mask_p[26] << 20)
+		| (mask_p[25] << 18) | (mask_p[24] << 16)
+		| (mask_p[23] << 14) | (mask_p[22] << 12)
+		| (mask_p[21] << 10) | (mask_p[20] << 8)
+		| (mask_p[19] << 6) | (mask_p[18] << 4)
+		| (mask_p[17] << 2) | (mask_p[16] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_2, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_30_16, tmp_mask);
+
+	tmp_mask = (mask_p[45] << 28)
+		| (mask_p[44] << 26) | (mask_p[43] << 24)
+		| (mask_p[42] << 22) | (mask_p[41] << 20)
+		| (mask_p[40] << 18) | (mask_p[39] << 16)
+		| (mask_p[38] << 14) | (mask_p[37] << 12)
+		| (mask_p[36] << 10) | (mask_p[35] << 8)
+		| (mask_p[34] << 6) | (mask_p[33] << 4)
+		| (mask_p[32] << 2) | (mask_p[31] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_3, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_45_31, tmp_mask);
+
+	tmp_mask = (mask_p[61] << 30) | (mask_p[60] << 28)
+		| (mask_p[59] << 26) | (mask_p[58] << 24)
+		| (mask_p[57] << 22) | (mask_p[56] << 20)
+		| (mask_p[55] << 18) | (mask_p[54] << 16)
+		| (mask_p[53] << 14) | (mask_p[52] << 12)
+		| (mask_p[51] << 10) | (mask_p[50] << 8)
+		| (mask_p[49] << 6) | (mask_p[48] << 4)
+		| (mask_p[47] << 2) | (mask_p[46] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
+}
+
+static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	int bb_spur = AR_NO_SPUR;
+	int bin, cur_bin;
+	int spur_freq_sd;
+	int spur_delta_phase;
+	int denominator;
+	int upper, lower, cur_vit_mask;
+	int tmp, new;
+	int i;
+	int pilot_mask_reg[4] = { AR_PHY_TIMING7, AR_PHY_TIMING8,
+			  AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
+	};
+	int chan_mask_reg[4] = { AR_PHY_TIMING9, AR_PHY_TIMING10,
+			 AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
+	};
+	int inc[4] = { 0, 100, 0, 0 };
+
+	int8_t mask_m[123];
+	int8_t mask_p[123];
+	int8_t mask_amt;
+	int tmp_mask;
+	int cur_bb_spur;
+	bool is2GHz = IS_CHAN_2GHZ(chan);
+
+	memset(&mask_m, 0, sizeof(int8_t) * 123);
+	memset(&mask_p, 0, sizeof(int8_t) * 123);
+
+	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
+		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
+		if (AR_NO_SPUR == cur_bb_spur)
+			break;
+		cur_bb_spur = cur_bb_spur - (chan->channel * 10);
+		if ((cur_bb_spur > -95) && (cur_bb_spur < 95)) {
+			bb_spur = cur_bb_spur;
+			break;
+		}
+	}
+
+	if (AR_NO_SPUR == bb_spur)
+		return;
+
+	bin = bb_spur * 32;
+
+	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
+	new = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
+		     AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
+		     AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
+		     AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK);
+
+	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0), new);
+
+	new = (AR_PHY_SPUR_REG_MASK_RATE_CNTL |
+	       AR_PHY_SPUR_REG_ENABLE_MASK_PPM |
+	       AR_PHY_SPUR_REG_MASK_RATE_SELECT |
+	       AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI |
+	       SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
+	REG_WRITE(ah, AR_PHY_SPUR_REG, new);
+
+	spur_delta_phase = ((bb_spur * 524288) / 100) &
+		AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+
+	denominator = IS_CHAN_2GHZ(chan) ? 440 : 400;
+	spur_freq_sd = ((bb_spur * 2048) / denominator) & 0x3ff;
+
+	new = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
+	       SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
+	       SM(spur_delta_phase, AR_PHY_TIMING11_SPUR_DELTA_PHASE));
+	REG_WRITE(ah, AR_PHY_TIMING11, new);
+
+	cur_bin = -6000;
+	upper = bin + 100;
+	lower = bin - 100;
+
+	for (i = 0; i < 4; i++) {
+		int pilot_mask = 0;
+		int chan_mask = 0;
+		int bp = 0;
+		for (bp = 0; bp < 30; bp++) {
+			if ((cur_bin > lower) && (cur_bin < upper)) {
+				pilot_mask = pilot_mask | 0x1 << bp;
+				chan_mask = chan_mask | 0x1 << bp;
+			}
+			cur_bin += 100;
+		}
+		cur_bin += inc[i];
+		REG_WRITE(ah, pilot_mask_reg[i], pilot_mask);
+		REG_WRITE(ah, chan_mask_reg[i], chan_mask);
+	}
+
+	cur_vit_mask = 6100;
+	upper = bin + 120;
+	lower = bin - 120;
+
+	for (i = 0; i < 123; i++) {
+		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
+
+			/* workaround for gcc bug #37014 */
+			volatile int tmp_v = abs(cur_vit_mask - bin);
+
+			if (tmp_v < 75)
+				mask_amt = 1;
+			else
+				mask_amt = 0;
+			if (cur_vit_mask < 0)
+				mask_m[abs(cur_vit_mask / 100)] = mask_amt;
+			else
+				mask_p[cur_vit_mask / 100] = mask_amt;
+		}
+		cur_vit_mask -= 100;
+	}
+
+	tmp_mask = (mask_m[46] << 30) | (mask_m[47] << 28)
+		| (mask_m[48] << 26) | (mask_m[49] << 24)
+		| (mask_m[50] << 22) | (mask_m[51] << 20)
+		| (mask_m[52] << 18) | (mask_m[53] << 16)
+		| (mask_m[54] << 14) | (mask_m[55] << 12)
+		| (mask_m[56] << 10) | (mask_m[57] << 8)
+		| (mask_m[58] << 6) | (mask_m[59] << 4)
+		| (mask_m[60] << 2) | (mask_m[61] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_1, tmp_mask);
+	REG_WRITE(ah, AR_PHY_VIT_MASK2_M_46_61, tmp_mask);
+
+	tmp_mask = (mask_m[31] << 28)
+		| (mask_m[32] << 26) | (mask_m[33] << 24)
+		| (mask_m[34] << 22) | (mask_m[35] << 20)
+		| (mask_m[36] << 18) | (mask_m[37] << 16)
+		| (mask_m[48] << 14) | (mask_m[39] << 12)
+		| (mask_m[40] << 10) | (mask_m[41] << 8)
+		| (mask_m[42] << 6) | (mask_m[43] << 4)
+		| (mask_m[44] << 2) | (mask_m[45] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_2, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_31_45, tmp_mask);
+
+	tmp_mask = (mask_m[16] << 30) | (mask_m[16] << 28)
+		| (mask_m[18] << 26) | (mask_m[18] << 24)
+		| (mask_m[20] << 22) | (mask_m[20] << 20)
+		| (mask_m[22] << 18) | (mask_m[22] << 16)
+		| (mask_m[24] << 14) | (mask_m[24] << 12)
+		| (mask_m[25] << 10) | (mask_m[26] << 8)
+		| (mask_m[27] << 6) | (mask_m[28] << 4)
+		| (mask_m[29] << 2) | (mask_m[30] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_3, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_16_30, tmp_mask);
+
+	tmp_mask = (mask_m[0] << 30) | (mask_m[1] << 28)
+		| (mask_m[2] << 26) | (mask_m[3] << 24)
+		| (mask_m[4] << 22) | (mask_m[5] << 20)
+		| (mask_m[6] << 18) | (mask_m[7] << 16)
+		| (mask_m[8] << 14) | (mask_m[9] << 12)
+		| (mask_m[10] << 10) | (mask_m[11] << 8)
+		| (mask_m[12] << 6) | (mask_m[13] << 4)
+		| (mask_m[14] << 2) | (mask_m[15] << 0);
+	REG_WRITE(ah, AR_PHY_MASK_CTL, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_00_15, tmp_mask);
+
+	tmp_mask = (mask_p[15] << 28)
+		| (mask_p[14] << 26) | (mask_p[13] << 24)
+		| (mask_p[12] << 22) | (mask_p[11] << 20)
+		| (mask_p[10] << 18) | (mask_p[9] << 16)
+		| (mask_p[8] << 14) | (mask_p[7] << 12)
+		| (mask_p[6] << 10) | (mask_p[5] << 8)
+		| (mask_p[4] << 6) | (mask_p[3] << 4)
+		| (mask_p[2] << 2) | (mask_p[1] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_1, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_15_01, tmp_mask);
+
+	tmp_mask = (mask_p[30] << 28)
+		| (mask_p[29] << 26) | (mask_p[28] << 24)
+		| (mask_p[27] << 22) | (mask_p[26] << 20)
+		| (mask_p[25] << 18) | (mask_p[24] << 16)
+		| (mask_p[23] << 14) | (mask_p[22] << 12)
+		| (mask_p[21] << 10) | (mask_p[20] << 8)
+		| (mask_p[19] << 6) | (mask_p[18] << 4)
+		| (mask_p[17] << 2) | (mask_p[16] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_2, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_30_16, tmp_mask);
+
+	tmp_mask = (mask_p[45] << 28)
+		| (mask_p[44] << 26) | (mask_p[43] << 24)
+		| (mask_p[42] << 22) | (mask_p[41] << 20)
+		| (mask_p[40] << 18) | (mask_p[39] << 16)
+		| (mask_p[38] << 14) | (mask_p[37] << 12)
+		| (mask_p[36] << 10) | (mask_p[35] << 8)
+		| (mask_p[34] << 6) | (mask_p[33] << 4)
+		| (mask_p[32] << 2) | (mask_p[31] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_3, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_45_31, tmp_mask);
+
+	tmp_mask = (mask_p[61] << 30) | (mask_p[60] << 28)
+		| (mask_p[59] << 26) | (mask_p[58] << 24)
+		| (mask_p[57] << 22) | (mask_p[56] << 20)
+		| (mask_p[55] << 18) | (mask_p[54] << 16)
+		| (mask_p[53] << 14) | (mask_p[52] << 12)
+		| (mask_p[51] << 10) | (mask_p[50] << 8)
+		| (mask_p[49] << 6) | (mask_p[48] << 4)
+		| (mask_p[47] << 2) | (mask_p[46] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
+}
+
+static void ath9k_enable_rfkill(struct ath_hw *ah)
+{
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
+
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
+		    AR_GPIO_INPUT_MUX2_RFSILENT);
+
+	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
+	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
+}
+
+int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+		    bool bChannelChange)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 saveLedState;
+	struct ath9k_channel *curchan = ah->curchan;
+	u32 saveDefAntenna;
+	u32 macStaId1;
+	int i, rx_chainmask, r;
+
+	ah->txchainmask = common->tx_chainmask;
+	ah->rxchainmask = common->rx_chainmask;
+
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
+		return -EIO;
+
+	if (curchan)
+		ath9k_hw_getnf(ah, curchan);
+
+	if (bChannelChange &&
+	    (ah->chip_fullsleep != true) &&
+	    (ah->curchan != NULL) &&
+	    (chan->channel != ah->curchan->channel) &&
+	    ((chan->channelFlags & CHANNEL_ALL) ==
+	     (ah->curchan->channelFlags & CHANNEL_ALL)) &&
+	    (!AR_SREV_9280(ah) || (!IS_CHAN_A_5MHZ_SPACED(chan) &&
+				   !IS_CHAN_A_5MHZ_SPACED(ah->curchan)))) {
+
+		if (ath9k_hw_channel_change(ah, chan)) {
+			ath9k_hw_loadnf(ah, ah->curchan);
+			ath9k_hw_start_nfcal(ah);
+			return 0;
+		}
+	}
+
+	saveDefAntenna = REG_READ(ah, AR_DEF_ANTENNA);
+	if (saveDefAntenna == 0)
+		saveDefAntenna = 1;
+
+	macStaId1 = REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_BASE_RATE_11B;
+
+	saveLedState = REG_READ(ah, AR_CFG_LED) &
+		(AR_CFG_LED_ASSOC_CTL | AR_CFG_LED_MODE_SEL |
+		 AR_CFG_LED_BLINK_THRESH_SEL | AR_CFG_LED_BLINK_SLOW);
+
+	ath9k_hw_mark_phy_inactive(ah);
+
+	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
+		REG_WRITE(ah,
+			  AR9271_RESET_POWER_DOWN_CONTROL,
+			  AR9271_RADIO_RF_RST);
+		udelay(50);
+	}
+
+	if (!ath9k_hw_chip_reset(ah, chan)) {
+		ath_print(common, ATH_DBG_FATAL, "Chip reset failed\n");
+		return -EINVAL;
+	}
+
+	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
+		ah->htc_reset_init = false;
+		REG_WRITE(ah,
+			  AR9271_RESET_POWER_DOWN_CONTROL,
+			  AR9271_GATE_MAC_CTL);
+		udelay(50);
+	}
+
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
+
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
+		/* Enable ASYNC FIFO */
+		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL);
+		REG_SET_BIT(ah, AR_PHY_MODE, AR_PHY_MODE_ASYNCFIFO);
+		REG_CLR_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
+		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
+	}
+	r = ath9k_hw_process_ini(ah, chan);
+	if (r)
+		return r;
+
+	/* Setup MFP options for CCMP */
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		/* Mask Retry(b11), PwrMgt(b12), MoreData(b13) to 0 in mgmt
+		 * frames when constructing CCMP AAD. */
+		REG_RMW_FIELD(ah, AR_AES_MUTE_MASK1, AR_AES_MUTE_MASK1_FC_MGMT,
+			      0xc7ff);
+		ah->sw_mgmt_crypto = false;
+	} else if (AR_SREV_9160_10_OR_LATER(ah)) {
+		/* Disable hardware crypto for management frames */
+		REG_CLR_BIT(ah, AR_PCU_MISC_MODE2,
+			    AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE);
+		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
+			    AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT);
+		ah->sw_mgmt_crypto = true;
+	} else
+		ah->sw_mgmt_crypto = true;
+
+	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
+		ath9k_hw_set_delta_slope(ah, chan);
+
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ath9k_hw_9280_spur_mitigate(ah, chan);
+	else
+		ath9k_hw_spur_mitigate(ah, chan);
+
+	ah->eep_ops->set_board_values(ah, chan);
+
+	ath9k_hw_decrease_chain_power(ah, chan);
+
+	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
+	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
+		  | macStaId1
+		  | AR_STA_ID1_RTS_USE_DEF
+		  | (ah->config.
+		     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
+		  | ah->sta_id1_defaults);
+	ath9k_hw_set_operating_mode(ah, ah->opmode);
+
+	ath_hw_setbssidmask(common);
+
+	REG_WRITE(ah, AR_DEF_ANTENNA, saveDefAntenna);
+
+	ath9k_hw_write_associd(ah);
+
+	REG_WRITE(ah, AR_ISR, ~0);
+
+	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
+
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ath9k_hw_ar9280_set_channel(ah, chan);
+	else
+		if (!(ath9k_hw_set_channel(ah, chan)))
+			return -EIO;
+
+	for (i = 0; i < AR_NUM_DCU; i++)
+		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
+
+	ah->intr_txqs = 0;
+	for (i = 0; i < ah->caps.total_queues; i++)
+		ath9k_hw_resettxqueue(ah, i);
+
+	ath9k_hw_init_interrupt_masks(ah, ah->opmode);
+	ath9k_hw_init_qos(ah);
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_RFSILENT)
+		ath9k_enable_rfkill(ah);
+
+	ath9k_hw_init_user_settings(ah);
+
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_D_GBL_IFS_SIFS,
+			  AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_D_GBL_IFS_SLOT,
+			  AR_D_GBL_IFS_SLOT_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_D_GBL_IFS_EIFS,
+			  AR_D_GBL_IFS_EIFS_ASYNC_FIFO_DUR);
+
+		REG_WRITE(ah, AR_TIME_OUT, AR_TIME_OUT_ACK_CTS_ASYNC_FIFO_DUR);
+		REG_WRITE(ah, AR_USEC, AR_USEC_ASYNC_FIFO_DUR);
+
+		REG_SET_BIT(ah, AR_MAC_PCU_LOGIC_ANALYZER,
+			    AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768);
+		REG_RMW_FIELD(ah, AR_AHB_MODE, AR_AHB_CUSTOM_BURST_EN,
+			      AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL);
+	}
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
+		REG_SET_BIT(ah, AR_PCU_MISC_MODE2,
+				AR_PCU_MISC_MODE2_ENABLE_AGGWEP);
+	}
+
+	REG_WRITE(ah, AR_STA_ID1,
+		  REG_READ(ah, AR_STA_ID1) | AR_STA_ID1_PRESERVE_SEQNUM);
+
+	ath9k_hw_set_dma(ah);
+
+	REG_WRITE(ah, AR_OBS, 8);
+
+	if (ah->config.intr_mitigation) {
+		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
+		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
+	}
+
+	ath9k_hw_init_bb(ah, chan);
+
+	if (!ath9k_hw_init_cal(ah, chan))
+		return -EIO;
+
+	rx_chainmask = ah->rxchainmask;
+	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
+		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
+		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
+	}
+
+	REG_WRITE(ah, AR_CFG_LED, saveLedState | AR_CFG_SCLK_32KHZ);
+
+	/*
+	 * For big endian systems turn on swapping for descriptors
+	 */
+	if (AR_SREV_9100(ah)) {
+		u32 mask;
+		mask = REG_READ(ah, AR_CFG);
+		if (mask & (AR_CFG_SWRB | AR_CFG_SWTB | AR_CFG_SWRG)) {
+			ath_print(common, ATH_DBG_RESET,
+				"CFG Byte Swap Set 0x%x\n", mask);
+		} else {
+			mask =
+				INIT_CONFIG_STATUS | AR_CFG_SWRB | AR_CFG_SWTB;
+			REG_WRITE(ah, AR_CFG, mask);
+			ath_print(common, ATH_DBG_RESET,
+				"Setting CFG 0x%x\n", REG_READ(ah, AR_CFG));
+		}
+	} else {
+		/* Configure AR9271 target WLAN */
+                if (AR_SREV_9271(ah))
+			REG_WRITE(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB);
+#ifdef __BIG_ENDIAN
+                else
+			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
+#endif
+	}
+
+	if (ah->btcoex_hw.enabled)
+		ath9k_hw_btcoex_enable(ah);
+
+	return 0;
+}
+EXPORT_SYMBOL(ath9k_hw_reset);
+
+/************************/
+/* Key Cache Management */
+/************************/
+
+bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
+{
+	u32 keyType;
+
+	if (entry >= ah->caps.keycache_size) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "keychache entry %u out of range\n", entry);
+		return false;
+	}
+
+	keyType = REG_READ(ah, AR_KEYTABLE_TYPE(entry));
+
+	REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), AR_KEYTABLE_TYPE_CLR);
+	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), 0);
+	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), 0);
+
+	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
+		u16 micentry = entry + 64;
+
+		REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), 0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), 0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
+
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(ath9k_hw_keyreset);
+
+bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
+{
+	u32 macHi, macLo;
+
+	if (entry >= ah->caps.keycache_size) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "keychache entry %u out of range\n", entry);
+		return false;
+	}
+
+	if (mac != NULL) {
+		macHi = (mac[5] << 8) | mac[4];
+		macLo = (mac[3] << 24) |
+			(mac[2] << 16) |
+			(mac[1] << 8) |
+			mac[0];
+		macLo >>= 1;
+		macLo |= (macHi & 1) << 31;
+		macHi >>= 1;
+	} else {
+		macLo = macHi = 0;
+	}
+	REG_WRITE(ah, AR_KEYTABLE_MAC0(entry), macLo);
+	REG_WRITE(ah, AR_KEYTABLE_MAC1(entry), macHi | AR_KEYTABLE_VALID);
+
+	return true;
+}
+EXPORT_SYMBOL(ath9k_hw_keysetmac);
+
+bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
+				 const struct ath9k_keyval *k,
+				 const u8 *mac)
+{
+	const struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 key0, key1, key2, key3, key4;
+	u32 keyType;
+
+	if (entry >= pCap->keycache_size) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "keycache entry %u out of range\n", entry);
+		return false;
+	}
+
+	switch (k->kv_type) {
+	case ATH9K_CIPHER_AES_OCB:
+		keyType = AR_KEYTABLE_TYPE_AES;
+		break;
+	case ATH9K_CIPHER_AES_CCM:
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
+			ath_print(common, ATH_DBG_ANY,
+				  "AES-CCM not supported by mac rev 0x%x\n",
+				  ah->hw_version.macRev);
+			return false;
+		}
+		keyType = AR_KEYTABLE_TYPE_CCM;
+		break;
+	case ATH9K_CIPHER_TKIP:
+		keyType = AR_KEYTABLE_TYPE_TKIP;
+		if (ATH9K_IS_MIC_ENABLED(ah)
+		    && entry + 64 >= pCap->keycache_size) {
+			ath_print(common, ATH_DBG_ANY,
+				  "entry %u inappropriate for TKIP\n", entry);
+			return false;
+		}
+		break;
+	case ATH9K_CIPHER_WEP:
+		if (k->kv_len < WLAN_KEY_LEN_WEP40) {
+			ath_print(common, ATH_DBG_ANY,
+				  "WEP key length %u too small\n", k->kv_len);
+			return false;
+		}
+		if (k->kv_len <= WLAN_KEY_LEN_WEP40)
+			keyType = AR_KEYTABLE_TYPE_40;
+		else if (k->kv_len <= WLAN_KEY_LEN_WEP104)
+			keyType = AR_KEYTABLE_TYPE_104;
+		else
+			keyType = AR_KEYTABLE_TYPE_128;
+		break;
+	case ATH9K_CIPHER_CLR:
+		keyType = AR_KEYTABLE_TYPE_CLR;
+		break;
+	default:
+		ath_print(common, ATH_DBG_FATAL,
+			  "cipher %u not supported\n", k->kv_type);
+		return false;
+	}
+
+	key0 = get_unaligned_le32(k->kv_val + 0);
+	key1 = get_unaligned_le16(k->kv_val + 4);
+	key2 = get_unaligned_le32(k->kv_val + 6);
+	key3 = get_unaligned_le16(k->kv_val + 10);
+	key4 = get_unaligned_le32(k->kv_val + 12);
+	if (k->kv_len <= WLAN_KEY_LEN_WEP104)
+		key4 &= 0xff;
+
+	/*
+	 * Note: Key cache registers access special memory area that requires
+	 * two 32-bit writes to actually update the values in the internal
+	 * memory. Consequently, the exact order and pairs used here must be
+	 * maintained.
+	 */
+
+	if (keyType == AR_KEYTABLE_TYPE_TKIP && ATH9K_IS_MIC_ENABLED(ah)) {
+		u16 micentry = entry + 64;
+
+		/*
+		 * Write inverted key[47:0] first to avoid Michael MIC errors
+		 * on frames that could be sent or received at the same time.
+		 * The correct key will be written in the end once everything
+		 * else is ready.
+		 */
+		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), ~key0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), ~key1);
+
+		/* Write key[95:48] */
+		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
+		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
+
+		/* Write key[127:96] and key type */
+		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
+		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
+
+		/* Write MAC address for the entry */
+		(void) ath9k_hw_keysetmac(ah, entry, mac);
+
+		if (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) {
+			/*
+			 * TKIP uses two key cache entries:
+			 * Michael MIC TX/RX keys in the same key cache entry
+			 * (idx = main index + 64):
+			 * key0 [31:0] = RX key [31:0]
+			 * key1 [15:0] = TX key [31:16]
+			 * key1 [31:16] = reserved
+			 * key2 [31:0] = RX key [63:32]
+			 * key3 [15:0] = TX key [15:0]
+			 * key3 [31:16] = reserved
+			 * key4 [31:0] = TX key [63:32]
+			 */
+			u32 mic0, mic1, mic2, mic3, mic4;
+
+			mic0 = get_unaligned_le32(k->kv_mic + 0);
+			mic2 = get_unaligned_le32(k->kv_mic + 4);
+			mic1 = get_unaligned_le16(k->kv_txmic + 2) & 0xffff;
+			mic3 = get_unaligned_le16(k->kv_txmic + 0) & 0xffff;
+			mic4 = get_unaligned_le32(k->kv_txmic + 4);
+
+			/* Write RX[31:0] and TX[31:16] */
+			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
+			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), mic1);
+
+			/* Write RX[63:32] and TX[15:0] */
+			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
+			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), mic3);
+
+			/* Write TX[63:32] and keyType(reserved) */
+			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), mic4);
+			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
+				  AR_KEYTABLE_TYPE_CLR);
+
+		} else {
+			/*
+			 * TKIP uses four key cache entries (two for group
+			 * keys):
+			 * Michael MIC TX/RX keys are in different key cache
+			 * entries (idx = main index + 64 for TX and
+			 * main index + 32 + 96 for RX):
+			 * key0 [31:0] = TX/RX MIC key [31:0]
+			 * key1 [31:0] = reserved
+			 * key2 [31:0] = TX/RX MIC key [63:32]
+			 * key3 [31:0] = reserved
+			 * key4 [31:0] = reserved
+			 *
+			 * Upper layer code will call this function separately
+			 * for TX and RX keys when these registers offsets are
+			 * used.
+			 */
+			u32 mic0, mic2;
+
+			mic0 = get_unaligned_le32(k->kv_mic + 0);
+			mic2 = get_unaligned_le32(k->kv_mic + 4);
+
+			/* Write MIC key[31:0] */
+			REG_WRITE(ah, AR_KEYTABLE_KEY0(micentry), mic0);
+			REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
+
+			/* Write MIC key[63:32] */
+			REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), mic2);
+			REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
+
+			/* Write TX[63:32] and keyType(reserved) */
+			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
+			REG_WRITE(ah, AR_KEYTABLE_TYPE(micentry),
+				  AR_KEYTABLE_TYPE_CLR);
+		}
+
+		/* MAC address registers are reserved for the MIC entry */
+		REG_WRITE(ah, AR_KEYTABLE_MAC0(micentry), 0);
+		REG_WRITE(ah, AR_KEYTABLE_MAC1(micentry), 0);
+
+		/*
+		 * Write the correct (un-inverted) key[47:0] last to enable
+		 * TKIP now that all other registers are set with correct
+		 * values.
+		 */
+		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
+	} else {
+		/* Write key[47:0] */
+		REG_WRITE(ah, AR_KEYTABLE_KEY0(entry), key0);
+		REG_WRITE(ah, AR_KEYTABLE_KEY1(entry), key1);
+
+		/* Write key[95:48] */
+		REG_WRITE(ah, AR_KEYTABLE_KEY2(entry), key2);
+		REG_WRITE(ah, AR_KEYTABLE_KEY3(entry), key3);
+
+		/* Write key[127:96] and key type */
+		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
+		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
+
+		/* Write MAC address for the entry */
+		(void) ath9k_hw_keysetmac(ah, entry, mac);
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(ath9k_hw_set_keycache_entry);
+
+bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry)
+{
+	if (entry < ah->caps.keycache_size) {
+		u32 val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
+		if (val & AR_KEYTABLE_VALID)
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(ath9k_hw_keyisvalid);
+
+/******************************/
+/* Power Management (Chipset) */
+/******************************/
+
+static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
+{
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	if (setChip) {
+		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
+			    AR_RTC_FORCE_WAKE_EN);
+		if (!AR_SREV_9100(ah))
+			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
+
+		REG_CLR_BIT(ah, (AR_RTC_RESET),
+			    AR_RTC_RESET_EN);
+	}
+}
+
+static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
+{
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	if (setChip) {
+		struct ath9k_hw_capabilities *pCap = &ah->caps;
+
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
+				  AR_RTC_FORCE_WAKE_ON_INT);
+		} else {
+			REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
+				    AR_RTC_FORCE_WAKE_EN);
+		}
+	}
+}
+
+static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
+{
+	u32 val;
+	int i;
+
+	if (setChip) {
+		if ((REG_READ(ah, AR_RTC_STATUS) &
+		     AR_RTC_STATUS_M) == AR_RTC_STATUS_SHUTDOWN) {
+			if (ath9k_hw_set_reset_reg(ah,
+					   ATH9K_RESET_POWER_ON) != true) {
+				return false;
+			}
+		}
+		if (AR_SREV_9100(ah))
+			REG_SET_BIT(ah, AR_RTC_RESET,
+				    AR_RTC_RESET_EN);
+
+		REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
+			    AR_RTC_FORCE_WAKE_EN);
+		udelay(50);
+
+		for (i = POWER_UP_TIME / 50; i > 0; i--) {
+			val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
+			if (val == AR_RTC_STATUS_ON)
+				break;
+			udelay(50);
+			REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
+				    AR_RTC_FORCE_WAKE_EN);
+		}
+		if (i == 0) {
+			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+				  "Failed to wakeup in %uus\n",
+				  POWER_UP_TIME / 20);
+			return false;
+		}
+	}
+
+	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+
+	return true;
+}
+
+bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int status = true, setChip = true;
+	static const char *modes[] = {
+		"AWAKE",
+		"FULL-SLEEP",
+		"NETWORK SLEEP",
+		"UNDEFINED"
+	};
+
+	if (ah->power_mode == mode)
+		return status;
+
+	ath_print(common, ATH_DBG_RESET, "%s -> %s\n",
+		  modes[ah->power_mode], modes[mode]);
+
+	switch (mode) {
+	case ATH9K_PM_AWAKE:
+		status = ath9k_hw_set_power_awake(ah, setChip);
+		break;
+	case ATH9K_PM_FULL_SLEEP:
+		ath9k_set_power_sleep(ah, setChip);
+		ah->chip_fullsleep = true;
+		break;
+	case ATH9K_PM_NETWORK_SLEEP:
+		ath9k_set_power_network_sleep(ah, setChip);
+		break;
+	default:
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unknown power mode %u\n", mode);
+		return false;
+	}
+	ah->power_mode = mode;
+
+	return status;
+}
+EXPORT_SYMBOL(ath9k_hw_setpower);
+
+/*
+ * Helper for ASPM support.
+ *
+ * Disable PLL when in L0s as well as receiver clock when in L1.
+ * This power saving option must be enabled through the SerDes.
+ *
+ * Programming the SerDes must go through the same 288 bit serial shift
+ * register as the other analog registers.  Hence the 9 writes.
+ */
+void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore)
+{
+	u8 i;
+
+	if (ah->is_pciexpress != true)
+		return;
+
+	/* Do not touch SerDes registers */
+	if (ah->config.pcie_powersave_enable == 2)
+		return;
+
+	/* Nothing to do on restore for 11N */
+	if (restore)
+		return;
+
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		/*
+		 * AR9280 2.0 or later chips use SerDes values from the
+		 * initvals.h initialized depending on chipset during
+		 * ath9k_hw_init()
+		 */
+		for (i = 0; i < ah->iniPcieSerdes.ia_rows; i++) {
+			REG_WRITE(ah, INI_RA(&ah->iniPcieSerdes, i, 0),
+				  INI_RA(&ah->iniPcieSerdes, i, 1));
+		}
+	} else if (AR_SREV_9280(ah) &&
+		   (ah->hw_version.macRev == AR_SREV_REVISION_9280_10)) {
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fd00);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+
+		/* RX shut off when elecidle is asserted */
+		REG_WRITE(ah, AR_PCIE_SERDES, 0xa8000019);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
+
+		/* Shut off CLKREQ active in L1 */
+		if (ah->config.pcie_clock_req)
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
+		else
+			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffd);
+
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x00043007);
+
+		/* Load the new settings */
+		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+
+	} else {
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
+
+		/* RX shut off when elecidle is asserted */
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x28000039);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x53160824);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980579);
+
+		/*
+		 * Ignore ah->ah_config.pcie_clock_req setting for
+		 * pre-AR9280 11n
+		 */
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x001defff);
+
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x1aaabe40);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0xbe105554);
+		REG_WRITE(ah, AR_PCIE_SERDES, 0x000e3007);
+
+		/* Load the new settings */
+		REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+	}
+
+	udelay(1000);
+
+	/* set bit 19 to allow forcing of pcie core into L1 state */
+	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
+
+	/* Several PCIe massages to ensure proper behaviour */
+	if (ah->config.pcie_waen) {
+		REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
+	} else {
+		if (AR_SREV_9285(ah) || AR_SREV_9271(ah) || AR_SREV_9287(ah))
+			REG_WRITE(ah, AR_WA, AR9285_WA_DEFAULT);
+		/*
+		 * On AR9280 chips bit 22 of 0x4004 needs to be set to
+		 * otherwise card may disappear.
+		 */
+		else if (AR_SREV_9280(ah))
+			REG_WRITE(ah, AR_WA, AR9280_WA_DEFAULT);
+		else
+			REG_WRITE(ah, AR_WA, AR_WA_DEFAULT);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_configpcipowersave);
+
+/**********************/
+/* Interrupt Handling */
+/**********************/
+
+bool ath9k_hw_intrpend(struct ath_hw *ah)
+{
+	u32 host_isr;
+
+	if (AR_SREV_9100(ah))
+		return true;
+
+	host_isr = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
+	if ((host_isr & AR_INTR_MAC_IRQ) && (host_isr != AR_INTR_SPURIOUS))
+		return true;
+
+	host_isr = REG_READ(ah, AR_INTR_SYNC_CAUSE);
+	if ((host_isr & AR_INTR_SYNC_DEFAULT)
+	    && (host_isr != AR_INTR_SPURIOUS))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(ath9k_hw_intrpend);
+
+bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
+{
+	u32 isr = 0;
+	u32 mask2 = 0;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	u32 sync_cause = 0;
+	bool fatal_int = false;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!AR_SREV_9100(ah)) {
+		if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
+			if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M)
+			    == AR_RTC_STATUS_ON) {
+				isr = REG_READ(ah, AR_ISR);
+			}
+		}
+
+		sync_cause = REG_READ(ah, AR_INTR_SYNC_CAUSE) &
+			AR_INTR_SYNC_DEFAULT;
+
+		*masked = 0;
+
+		if (!isr && !sync_cause)
+			return false;
+	} else {
+		*masked = 0;
+		isr = REG_READ(ah, AR_ISR);
+	}
+
+	if (isr) {
+		if (isr & AR_ISR_BCNMISC) {
+			u32 isr2;
+			isr2 = REG_READ(ah, AR_ISR_S2);
+			if (isr2 & AR_ISR_S2_TIM)
+				mask2 |= ATH9K_INT_TIM;
+			if (isr2 & AR_ISR_S2_DTIM)
+				mask2 |= ATH9K_INT_DTIM;
+			if (isr2 & AR_ISR_S2_DTIMSYNC)
+				mask2 |= ATH9K_INT_DTIMSYNC;
+			if (isr2 & (AR_ISR_S2_CABEND))
+				mask2 |= ATH9K_INT_CABEND;
+			if (isr2 & AR_ISR_S2_GTT)
+				mask2 |= ATH9K_INT_GTT;
+			if (isr2 & AR_ISR_S2_CST)
+				mask2 |= ATH9K_INT_CST;
+			if (isr2 & AR_ISR_S2_TSFOOR)
+				mask2 |= ATH9K_INT_TSFOOR;
+		}
+
+		isr = REG_READ(ah, AR_ISR_RAC);
+		if (isr == 0xffffffff) {
+			*masked = 0;
+			return false;
+		}
+
+		*masked = isr & ATH9K_INT_COMMON;
+
+		if (ah->config.intr_mitigation) {
+			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
+				*masked |= ATH9K_INT_RX;
+		}
+
+		if (isr & (AR_ISR_RXOK | AR_ISR_RXERR))
+			*masked |= ATH9K_INT_RX;
+		if (isr &
+		    (AR_ISR_TXOK | AR_ISR_TXDESC | AR_ISR_TXERR |
+		     AR_ISR_TXEOL)) {
+			u32 s0_s, s1_s;
+
+			*masked |= ATH9K_INT_TX;
+
+			s0_s = REG_READ(ah, AR_ISR_S0_S);
+			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
+			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
+
+			s1_s = REG_READ(ah, AR_ISR_S1_S);
+			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
+			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
+		}
+
+		if (isr & AR_ISR_RXORN) {
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "receive FIFO overrun interrupt\n");
+		}
+
+		if (!AR_SREV_9100(ah)) {
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+				u32 isr5 = REG_READ(ah, AR_ISR_S5_S);
+				if (isr5 & AR_ISR_S5_TIM_TIMER)
+					*masked |= ATH9K_INT_TIM_TIMER;
+			}
+		}
+
+		*masked |= mask2;
+	}
+
+	if (AR_SREV_9100(ah))
+		return true;
+
+	if (isr & AR_ISR_GENTMR) {
+		u32 s5_s;
+
+		s5_s = REG_READ(ah, AR_ISR_S5_S);
+		if (isr & AR_ISR_GENTMR) {
+			ah->intr_gen_timer_trigger =
+				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
+
+			ah->intr_gen_timer_thresh =
+				MS(s5_s, AR_ISR_S5_GENTIMER_THRESH);
+
+			if (ah->intr_gen_timer_trigger)
+				*masked |= ATH9K_INT_GENTIMER;
+
+		}
+	}
+
+	if (sync_cause) {
+		fatal_int =
+			(sync_cause &
+			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
+			? true : false;
+
+		if (fatal_int) {
+			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
+				ath_print(common, ATH_DBG_ANY,
+					  "received PCI FATAL interrupt\n");
+			}
+			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
+				ath_print(common, ATH_DBG_ANY,
+					  "received PCI PERR interrupt\n");
+			}
+			*masked |= ATH9K_INT_FATAL;
+		}
+		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
+			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
+			REG_WRITE(ah, AR_RC, 0);
+			*masked |= ATH9K_INT_FATAL;
+		}
+		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "AR_INTR_SYNC_LOCAL_TIMEOUT\n");
+		}
+
+		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
+		(void) REG_READ(ah, AR_INTR_SYNC_CAUSE_CLR);
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(ath9k_hw_getisr);
+
+enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
+{
+	u32 omask = ah->mask_reg;
+	u32 mask, mask2;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ath_print(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
+
+	if (omask & ATH9K_INT_GLOBAL) {
+		ath_print(common, ATH_DBG_INTERRUPT, "disable IER\n");
+		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
+		(void) REG_READ(ah, AR_IER);
+		if (!AR_SREV_9100(ah)) {
+			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, 0);
+			(void) REG_READ(ah, AR_INTR_ASYNC_ENABLE);
+
+			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
+			(void) REG_READ(ah, AR_INTR_SYNC_ENABLE);
+		}
+	}
+
+	mask = ints & ATH9K_INT_COMMON;
+	mask2 = 0;
+
+	if (ints & ATH9K_INT_TX) {
+		if (ah->txok_interrupt_mask)
+			mask |= AR_IMR_TXOK;
+		if (ah->txdesc_interrupt_mask)
+			mask |= AR_IMR_TXDESC;
+		if (ah->txerr_interrupt_mask)
+			mask |= AR_IMR_TXERR;
+		if (ah->txeol_interrupt_mask)
+			mask |= AR_IMR_TXEOL;
+	}
+	if (ints & ATH9K_INT_RX) {
+		mask |= AR_IMR_RXERR;
+		if (ah->config.intr_mitigation)
+			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
+		else
+			mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
+			mask |= AR_IMR_GENTMR;
+	}
+
+	if (ints & (ATH9K_INT_BMISC)) {
+		mask |= AR_IMR_BCNMISC;
+		if (ints & ATH9K_INT_TIM)
+			mask2 |= AR_IMR_S2_TIM;
+		if (ints & ATH9K_INT_DTIM)
+			mask2 |= AR_IMR_S2_DTIM;
+		if (ints & ATH9K_INT_DTIMSYNC)
+			mask2 |= AR_IMR_S2_DTIMSYNC;
+		if (ints & ATH9K_INT_CABEND)
+			mask2 |= AR_IMR_S2_CABEND;
+		if (ints & ATH9K_INT_TSFOOR)
+			mask2 |= AR_IMR_S2_TSFOOR;
+	}
+
+	if (ints & (ATH9K_INT_GTT | ATH9K_INT_CST)) {
+		mask |= AR_IMR_BCNMISC;
+		if (ints & ATH9K_INT_GTT)
+			mask2 |= AR_IMR_S2_GTT;
+		if (ints & ATH9K_INT_CST)
+			mask2 |= AR_IMR_S2_CST;
+	}
+
+	ath_print(common, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
+	REG_WRITE(ah, AR_IMR, mask);
+	mask = REG_READ(ah, AR_IMR_S2) & ~(AR_IMR_S2_TIM |
+					   AR_IMR_S2_DTIM |
+					   AR_IMR_S2_DTIMSYNC |
+					   AR_IMR_S2_CABEND |
+					   AR_IMR_S2_CABTO |
+					   AR_IMR_S2_TSFOOR |
+					   AR_IMR_S2_GTT | AR_IMR_S2_CST);
+	REG_WRITE(ah, AR_IMR_S2, mask | mask2);
+	ah->mask_reg = ints;
+
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+		if (ints & ATH9K_INT_TIM_TIMER)
+			REG_SET_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
+		else
+			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
+	}
+
+	if (ints & ATH9K_INT_GLOBAL) {
+		ath_print(common, ATH_DBG_INTERRUPT, "enable IER\n");
+		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
+		if (!AR_SREV_9100(ah)) {
+			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
+				  AR_INTR_MAC_IRQ);
+			REG_WRITE(ah, AR_INTR_ASYNC_MASK, AR_INTR_MAC_IRQ);
+
+
+			REG_WRITE(ah, AR_INTR_SYNC_ENABLE,
+				  AR_INTR_SYNC_DEFAULT);
+			REG_WRITE(ah, AR_INTR_SYNC_MASK,
+				  AR_INTR_SYNC_DEFAULT);
+		}
+		ath_print(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
+			  REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
+	}
+
+	return omask;
+}
+EXPORT_SYMBOL(ath9k_hw_set_interrupts);
+
+/*******************/
+/* Beacon Handling */
+/*******************/
+
+void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
+{
+	int flags = 0;
+
+	ah->beacon_interval = beacon_period;
+
+	switch (ah->opmode) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_MONITOR:
+		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
+		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, 0xffff);
+		REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
+		flags |= AR_TBTT_TIMER_EN;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		REG_SET_BIT(ah, AR_TXCFG,
+			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
+		REG_WRITE(ah, AR_NEXT_NDP_TIMER,
+			  TU_TO_USEC(next_beacon +
+				     (ah->atim_window ? ah->
+				      atim_window : 1)));
+		flags |= AR_NDP_TIMER_EN;
+	case NL80211_IFTYPE_AP:
+		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
+		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT,
+			  TU_TO_USEC(next_beacon -
+				     ah->config.
+				     dma_beacon_response_time));
+		REG_WRITE(ah, AR_NEXT_SWBA,
+			  TU_TO_USEC(next_beacon -
+				     ah->config.
+				     sw_beacon_response_time));
+		flags |=
+			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
+		break;
+	default:
+		ath_print(ath9k_hw_common(ah), ATH_DBG_BEACON,
+			  "%s: unsupported opmode: %d\n",
+			  __func__, ah->opmode);
+		return;
+		break;
+	}
+
+	REG_WRITE(ah, AR_BEACON_PERIOD, TU_TO_USEC(beacon_period));
+	REG_WRITE(ah, AR_DMA_BEACON_PERIOD, TU_TO_USEC(beacon_period));
+	REG_WRITE(ah, AR_SWBA_PERIOD, TU_TO_USEC(beacon_period));
+	REG_WRITE(ah, AR_NDP_PERIOD, TU_TO_USEC(beacon_period));
+
+	beacon_period &= ~ATH9K_BEACON_ENA;
+	if (beacon_period & ATH9K_BEACON_RESET_TSF) {
+		beacon_period &= ~ATH9K_BEACON_RESET_TSF;
+		ath9k_hw_reset_tsf(ah);
+	}
+
+	REG_SET_BIT(ah, AR_TIMER_MODE, flags);
+}
+EXPORT_SYMBOL(ath9k_hw_beaconinit);
+
+void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
+				    const struct ath9k_beacon_state *bs)
+{
+	u32 nextTbtt, beaconintval, dtimperiod, beacontimeout;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
+
+	REG_WRITE(ah, AR_BEACON_PERIOD,
+		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
+	REG_WRITE(ah, AR_DMA_BEACON_PERIOD,
+		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
+
+	REG_RMW_FIELD(ah, AR_RSSI_THR,
+		      AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
+
+	beaconintval = bs->bs_intval & ATH9K_BEACON_PERIOD;
+
+	if (bs->bs_sleepduration > beaconintval)
+		beaconintval = bs->bs_sleepduration;
+
+	dtimperiod = bs->bs_dtimperiod;
+	if (bs->bs_sleepduration > dtimperiod)
+		dtimperiod = bs->bs_sleepduration;
+
+	if (beaconintval == dtimperiod)
+		nextTbtt = bs->bs_nextdtim;
+	else
+		nextTbtt = bs->bs_nexttbtt;
+
+	ath_print(common, ATH_DBG_BEACON, "next DTIM %d\n", bs->bs_nextdtim);
+	ath_print(common, ATH_DBG_BEACON, "next beacon %d\n", nextTbtt);
+	ath_print(common, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
+	ath_print(common, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
+
+	REG_WRITE(ah, AR_NEXT_DTIM,
+		  TU_TO_USEC(bs->bs_nextdtim - SLEEP_SLOP));
+	REG_WRITE(ah, AR_NEXT_TIM, TU_TO_USEC(nextTbtt - SLEEP_SLOP));
+
+	REG_WRITE(ah, AR_SLEEP1,
+		  SM((CAB_TIMEOUT_VAL << 3), AR_SLEEP1_CAB_TIMEOUT)
+		  | AR_SLEEP1_ASSUME_DTIM);
+
+	if (pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)
+		beacontimeout = (BEACON_TIMEOUT_VAL << 3);
+	else
+		beacontimeout = MIN_BEACON_TIMEOUT_VAL;
+
+	REG_WRITE(ah, AR_SLEEP2,
+		  SM(beacontimeout, AR_SLEEP2_BEACON_TIMEOUT));
+
+	REG_WRITE(ah, AR_TIM_PERIOD, TU_TO_USEC(beaconintval));
+	REG_WRITE(ah, AR_DTIM_PERIOD, TU_TO_USEC(dtimperiod));
+
+	REG_SET_BIT(ah, AR_TIMER_MODE,
+		    AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
+		    AR_DTIM_TIMER_EN);
+
+	/* TSF Out of Range Threshold */
+	REG_WRITE(ah, AR_TSFOOR_THRESHOLD, bs->bs_tsfoor_threshold);
+}
+EXPORT_SYMBOL(ath9k_hw_set_sta_beacon_timers);
+
+/*******************/
+/* HW Capabilities */
+/*******************/
+
+void ath9k_hw_fill_cap_info(struct ath_hw *ah)
+{
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+
+	u16 capField = 0, eeval;
+
+	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
+	regulatory->current_rd = eeval;
+
+	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_1);
+	if (AR_SREV_9285_10_OR_LATER(ah))
+		eeval |= AR9285_RDEXT_DEFAULT;
+	regulatory->current_rd_ext = eeval;
+
+	capField = ah->eep_ops->get_eeprom(ah, EEP_OP_CAP);
+
+	if (ah->opmode != NL80211_IFTYPE_AP &&
+	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
+		if (regulatory->current_rd == 0x64 ||
+		    regulatory->current_rd == 0x65)
+			regulatory->current_rd += 5;
+		else if (regulatory->current_rd == 0x41)
+			regulatory->current_rd = 0x43;
+		ath_print(common, ATH_DBG_REGULATORY,
+			  "regdomain mapped to 0x%x\n", regulatory->current_rd);
+	}
+
+	eeval = ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);
+	bitmap_zero(pCap->wireless_modes, ATH9K_MODE_MAX);
+
+	if (eeval & AR5416_OPFLAGS_11A) {
+		set_bit(ATH9K_MODE_11A, pCap->wireless_modes);
+		if (ah->config.ht_enable) {
+			if (!(eeval & AR5416_OPFLAGS_N_5G_HT20))
+				set_bit(ATH9K_MODE_11NA_HT20,
+					pCap->wireless_modes);
+			if (!(eeval & AR5416_OPFLAGS_N_5G_HT40)) {
+				set_bit(ATH9K_MODE_11NA_HT40PLUS,
+					pCap->wireless_modes);
+				set_bit(ATH9K_MODE_11NA_HT40MINUS,
+					pCap->wireless_modes);
+			}
+		}
+	}
+
+	if (eeval & AR5416_OPFLAGS_11G) {
+		set_bit(ATH9K_MODE_11G, pCap->wireless_modes);
+		if (ah->config.ht_enable) {
+			if (!(eeval & AR5416_OPFLAGS_N_2G_HT20))
+				set_bit(ATH9K_MODE_11NG_HT20,
+					pCap->wireless_modes);
+			if (!(eeval & AR5416_OPFLAGS_N_2G_HT40)) {
+				set_bit(ATH9K_MODE_11NG_HT40PLUS,
+					pCap->wireless_modes);
+				set_bit(ATH9K_MODE_11NG_HT40MINUS,
+					pCap->wireless_modes);
+			}
+		}
+	}
+
+	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
+	/*
+	 * For AR9271 we will temporarilly uses the rx chainmax as read from
+	 * the EEPROM.
+	 */
+	if ((ah->hw_version.devid == AR5416_DEVID_PCI) &&
+	    !(eeval & AR5416_OPFLAGS_11A) &&
+	    !(AR_SREV_9271(ah)))
+		/* CB71: GPIO 0 is pulled down to indicate 3 rx chains */
+		pCap->rx_chainmask = ath9k_hw_gpio_get(ah, 0) ? 0x5 : 0x7;
+	else
+		/* Use rx_chainmask from EEPROM. */
+		pCap->rx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_RX_MASK);
+
+	if (!(AR_SREV_9280(ah) && (ah->hw_version.macRev == 0)))
+		ah->misc_mode |= AR_PCU_MIC_NEW_LOC_ENA;
+
+	pCap->low_2ghz_chan = 2312;
+	pCap->high_2ghz_chan = 2732;
+
+	pCap->low_5ghz_chan = 4920;
+	pCap->high_5ghz_chan = 6100;
+
+	pCap->hw_caps &= ~ATH9K_HW_CAP_CIPHER_CKIP;
+	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_TKIP;
+	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_AESCCM;
+
+	pCap->hw_caps &= ~ATH9K_HW_CAP_MIC_CKIP;
+	pCap->hw_caps |= ATH9K_HW_CAP_MIC_TKIP;
+	pCap->hw_caps |= ATH9K_HW_CAP_MIC_AESCCM;
+
+	if (ah->config.ht_enable)
+		pCap->hw_caps |= ATH9K_HW_CAP_HT;
+	else
+		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
+
+	pCap->hw_caps |= ATH9K_HW_CAP_GTT;
+	pCap->hw_caps |= ATH9K_HW_CAP_VEOL;
+	pCap->hw_caps |= ATH9K_HW_CAP_BSSIDMASK;
+	pCap->hw_caps &= ~ATH9K_HW_CAP_MCAST_KEYSEARCH;
+
+	if (capField & AR_EEPROM_EEPCAP_MAXQCU)
+		pCap->total_queues =
+			MS(capField, AR_EEPROM_EEPCAP_MAXQCU);
+	else
+		pCap->total_queues = ATH9K_NUM_TX_QUEUES;
+
+	if (capField & AR_EEPROM_EEPCAP_KC_ENTRIES)
+		pCap->keycache_size =
+			1 << MS(capField, AR_EEPROM_EEPCAP_KC_ENTRIES);
+	else
+		pCap->keycache_size = AR_KEYTABLE_SIZE;
+
+	pCap->hw_caps |= ATH9K_HW_CAP_FASTCC;
+	pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
+
+	if (AR_SREV_9285_10_OR_LATER(ah))
+		pCap->num_gpio_pins = AR9285_NUM_GPIO;
+	else if (AR_SREV_9280_10_OR_LATER(ah))
+		pCap->num_gpio_pins = AR928X_NUM_GPIO;
+	else
+		pCap->num_gpio_pins = AR_NUM_GPIO;
+
+	if (AR_SREV_9160_10_OR_LATER(ah) || AR_SREV_9100(ah)) {
+		pCap->hw_caps |= ATH9K_HW_CAP_CST;
+		pCap->rts_aggr_limit = ATH_AMPDU_LIMIT_MAX;
+	} else {
+		pCap->rts_aggr_limit = (8 * 1024);
+	}
+
+	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
+
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
+	ah->rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
+	if (ah->rfsilent & EEP_RFSILENT_ENABLED) {
+		ah->rfkill_gpio =
+			MS(ah->rfsilent, EEP_RFSILENT_GPIO_SEL);
+		ah->rfkill_polarity =
+			MS(ah->rfsilent, EEP_RFSILENT_POLARITY);
+
+		pCap->hw_caps |= ATH9K_HW_CAP_RFSILENT;
+	}
+#endif
+
+	if ((ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9160) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9100) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9280) ||
+	    (ah->hw_version.macVersion == AR_SREV_VERSION_9285))
+		pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
+	else
+		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;
+
+	if (AR_SREV_9280(ah) || AR_SREV_9285(ah))
+		pCap->hw_caps &= ~ATH9K_HW_CAP_4KB_SPLITTRANS;
+	else
+		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
+
+	if (regulatory->current_rd_ext & (1 << REG_EXT_JAPAN_MIDBAND)) {
+		pCap->reg_cap =
+			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
+			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
+			AR_EEPROM_EEREGCAP_EN_KK_U2 |
+			AR_EEPROM_EEREGCAP_EN_KK_MIDBAND;
+	} else {
+		pCap->reg_cap =
+			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
+			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN;
+	}
+
+	pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
+
+	pCap->num_antcfg_5ghz =
+		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_5GHZ);
+	pCap->num_antcfg_2ghz =
+		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
+
+	if (AR_SREV_9280_10_OR_LATER(ah) &&
+	    ath9k_hw_btcoex_supported(ah)) {
+		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
+		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
+
+		if (AR_SREV_9285(ah)) {
+			btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
+			btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO;
+		} else {
+			btcoex_hw->scheme = ATH_BTCOEX_CFG_2WIRE;
+		}
+	} else {
+		btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
+	}
+}
+
+bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
+			    u32 capability, u32 *result)
+{
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	switch (type) {
+	case ATH9K_CAP_CIPHER:
+		switch (capability) {
+		case ATH9K_CIPHER_AES_CCM:
+		case ATH9K_CIPHER_AES_OCB:
+		case ATH9K_CIPHER_TKIP:
+		case ATH9K_CIPHER_WEP:
+		case ATH9K_CIPHER_MIC:
+		case ATH9K_CIPHER_CLR:
+			return true;
+		default:
+			return false;
+		}
+	case ATH9K_CAP_TKIP_MIC:
+		switch (capability) {
+		case 0:
+			return true;
+		case 1:
+			return (ah->sta_id1_defaults &
+				AR_STA_ID1_CRPT_MIC_ENABLE) ? true :
+			false;
+		}
+	case ATH9K_CAP_TKIP_SPLIT:
+		return (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) ?
+			false : true;
+	case ATH9K_CAP_DIVERSITY:
+		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
+			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
+			true : false;
+	case ATH9K_CAP_MCAST_KEYSRCH:
+		switch (capability) {
+		case 0:
+			return true;
+		case 1:
+			if (REG_READ(ah, AR_STA_ID1) & AR_STA_ID1_ADHOC) {
+				return false;
+			} else {
+				return (ah->sta_id1_defaults &
+					AR_STA_ID1_MCAST_KSRCH) ? true :
+					false;
+			}
+		}
+		return false;
+	case ATH9K_CAP_TXPOW:
+		switch (capability) {
+		case 0:
+			return 0;
+		case 1:
+			*result = regulatory->power_limit;
+			return 0;
+		case 2:
+			*result = regulatory->max_power_level;
+			return 0;
+		case 3:
+			*result = regulatory->tp_scale;
+			return 0;
+		}
+		return false;
+	case ATH9K_CAP_DS:
+		return (AR_SREV_9280_20_OR_LATER(ah) &&
+			(ah->eep_ops->get_eeprom(ah, EEP_RC_CHAIN_MASK) == 1))
+			? false : true;
+	default:
+		return false;
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_getcapability);
+
+bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
+			    u32 capability, u32 setting, int *status)
+{
+	u32 v;
+
+	switch (type) {
+	case ATH9K_CAP_TKIP_MIC:
+		if (setting)
+			ah->sta_id1_defaults |=
+				AR_STA_ID1_CRPT_MIC_ENABLE;
+		else
+			ah->sta_id1_defaults &=
+				~AR_STA_ID1_CRPT_MIC_ENABLE;
+		return true;
+	case ATH9K_CAP_DIVERSITY:
+		v = REG_READ(ah, AR_PHY_CCK_DETECT);
+		if (setting)
+			v |= AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
+		else
+			v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
+		REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
+		return true;
+	case ATH9K_CAP_MCAST_KEYSRCH:
+		if (setting)
+			ah->sta_id1_defaults |= AR_STA_ID1_MCAST_KSRCH;
+		else
+			ah->sta_id1_defaults &= ~AR_STA_ID1_MCAST_KSRCH;
+		return true;
+	default:
+		return false;
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_setcapability);
+
+/****************************/
+/* GPIO / RFKILL / Antennae */
+/****************************/
+
+static void ath9k_hw_gpio_cfg_output_mux(struct ath_hw *ah,
+					 u32 gpio, u32 type)
+{
+	int addr;
+	u32 gpio_shift, tmp;
+
+	if (gpio > 11)
+		addr = AR_GPIO_OUTPUT_MUX3;
+	else if (gpio > 5)
+		addr = AR_GPIO_OUTPUT_MUX2;
+	else
+		addr = AR_GPIO_OUTPUT_MUX1;
+
+	gpio_shift = (gpio % 6) * 5;
+
+	if (AR_SREV_9280_20_OR_LATER(ah)
+	    || (addr != AR_GPIO_OUTPUT_MUX1)) {
+		REG_RMW(ah, addr, (type << gpio_shift),
+			(0x1f << gpio_shift));
+	} else {
+		tmp = REG_READ(ah, addr);
+		tmp = ((tmp & 0x1F0) << 1) | (tmp & ~0x1F0);
+		tmp &= ~(0x1f << gpio_shift);
+		tmp |= (type << gpio_shift);
+		REG_WRITE(ah, addr, tmp);
+	}
+}
+
+void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio)
+{
+	u32 gpio_shift;
+
+	BUG_ON(gpio >= ah->caps.num_gpio_pins);
+
+	gpio_shift = gpio << 1;
+
+	REG_RMW(ah,
+		AR_GPIO_OE_OUT,
+		(AR_GPIO_OE_OUT_DRV_NO << gpio_shift),
+		(AR_GPIO_OE_OUT_DRV << gpio_shift));
+}
+EXPORT_SYMBOL(ath9k_hw_cfg_gpio_input);
+
+u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
+{
+#define MS_REG_READ(x, y) \
+	(MS(REG_READ(ah, AR_GPIO_IN_OUT), x##_GPIO_IN_VAL) & (AR_GPIO_BIT(y)))
+
+	if (gpio >= ah->caps.num_gpio_pins)
+		return 0xffffffff;
+
+	if (AR_SREV_9287_10_OR_LATER(ah))
+		return MS_REG_READ(AR9287, gpio) != 0;
+	else if (AR_SREV_9285_10_OR_LATER(ah))
+		return MS_REG_READ(AR9285, gpio) != 0;
+	else if (AR_SREV_9280_10_OR_LATER(ah))
+		return MS_REG_READ(AR928X, gpio) != 0;
+	else
+		return MS_REG_READ(AR, gpio) != 0;
+}
+EXPORT_SYMBOL(ath9k_hw_gpio_get);
+
+void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
+			 u32 ah_signal_type)
+{
+	u32 gpio_shift;
+
+	ath9k_hw_gpio_cfg_output_mux(ah, gpio, ah_signal_type);
+
+	gpio_shift = 2 * gpio;
+
+	REG_RMW(ah,
+		AR_GPIO_OE_OUT,
+		(AR_GPIO_OE_OUT_DRV_ALL << gpio_shift),
+		(AR_GPIO_OE_OUT_DRV << gpio_shift));
+}
+EXPORT_SYMBOL(ath9k_hw_cfg_output);
+
+void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
+{
+	REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
+		AR_GPIO_BIT(gpio));
+}
+EXPORT_SYMBOL(ath9k_hw_set_gpio);
+
+u32 ath9k_hw_getdefantenna(struct ath_hw *ah)
+{
+	return REG_READ(ah, AR_DEF_ANTENNA) & 0x7;
+}
+EXPORT_SYMBOL(ath9k_hw_getdefantenna);
+
+void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna)
+{
+	REG_WRITE(ah, AR_DEF_ANTENNA, (antenna & 0x7));
+}
+EXPORT_SYMBOL(ath9k_hw_setantenna);
+
+bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
+			       enum ath9k_ant_setting settings,
+			       struct ath9k_channel *chan,
+			       u8 *tx_chainmask,
+			       u8 *rx_chainmask,
+			       u8 *antenna_cfgd)
+{
+	static u8 tx_chainmask_cfg, rx_chainmask_cfg;
+
+	if (AR_SREV_9280(ah)) {
+		if (!tx_chainmask_cfg) {
+
+			tx_chainmask_cfg = *tx_chainmask;
+			rx_chainmask_cfg = *rx_chainmask;
+		}
+
+		switch (settings) {
+		case ATH9K_ANT_FIXED_A:
+			*tx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
+			*rx_chainmask = ATH9K_ANTENNA0_CHAINMASK;
+			*antenna_cfgd = true;
+			break;
+		case ATH9K_ANT_FIXED_B:
+			if (ah->caps.tx_chainmask >
+			    ATH9K_ANTENNA1_CHAINMASK) {
+				*tx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
+			}
+			*rx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
+			*antenna_cfgd = true;
+			break;
+		case ATH9K_ANT_VARIABLE:
+			*tx_chainmask = tx_chainmask_cfg;
+			*rx_chainmask = rx_chainmask_cfg;
+			*antenna_cfgd = true;
+			break;
+		default:
+			break;
+		}
+	} else {
+		ah->config.diversity_control = settings;
+	}
+
+	return true;
+}
+
+/*********************/
+/* General Operation */
+/*********************/
+
+u32 ath9k_hw_getrxfilter(struct ath_hw *ah)
+{
+	u32 bits = REG_READ(ah, AR_RX_FILTER);
+	u32 phybits = REG_READ(ah, AR_PHY_ERR);
+
+	if (phybits & AR_PHY_ERR_RADAR)
+		bits |= ATH9K_RX_FILTER_PHYRADAR;
+	if (phybits & (AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING))
+		bits |= ATH9K_RX_FILTER_PHYERR;
+
+	return bits;
+}
+EXPORT_SYMBOL(ath9k_hw_getrxfilter);
+
+void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
+{
+	u32 phybits;
+
+	REG_WRITE(ah, AR_RX_FILTER, bits);
+
+	phybits = 0;
+	if (bits & ATH9K_RX_FILTER_PHYRADAR)
+		phybits |= AR_PHY_ERR_RADAR;
+	if (bits & ATH9K_RX_FILTER_PHYERR)
+		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
+	REG_WRITE(ah, AR_PHY_ERR, phybits);
+
+	if (phybits)
+		REG_WRITE(ah, AR_RXCFG,
+			  REG_READ(ah, AR_RXCFG) | AR_RXCFG_ZLFDMA);
+	else
+		REG_WRITE(ah, AR_RXCFG,
+			  REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_ZLFDMA);
+}
+EXPORT_SYMBOL(ath9k_hw_setrxfilter);
+
+bool ath9k_hw_phy_disable(struct ath_hw *ah)
+{
+	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM);
+}
+EXPORT_SYMBOL(ath9k_hw_phy_disable);
+
+bool ath9k_hw_disable(struct ath_hw *ah)
+{
+	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
+		return false;
+
+	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD);
+}
+EXPORT_SYMBOL(ath9k_hw_disable);
+
+void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
+{
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath9k_channel *chan = ah->curchan;
+	struct ieee80211_channel *channel = chan->chan;
+
+	regulatory->power_limit = min(limit, (u32) MAX_RATE_POWER);
+
+	ah->eep_ops->set_txpower(ah, chan,
+				 ath9k_regd_get_ctl(regulatory, chan),
+				 channel->max_antenna_gain * 2,
+				 channel->max_power * 2,
+				 min((u32) MAX_RATE_POWER,
+				 (u32) regulatory->power_limit));
+}
+EXPORT_SYMBOL(ath9k_hw_set_txpowerlimit);
+
+void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac)
+{
+	memcpy(ath9k_hw_common(ah)->macaddr, mac, ETH_ALEN);
+}
+EXPORT_SYMBOL(ath9k_hw_setmac);
+
+void ath9k_hw_setopmode(struct ath_hw *ah)
+{
+	ath9k_hw_set_operating_mode(ah, ah->opmode);
+}
+EXPORT_SYMBOL(ath9k_hw_setopmode);
+
+void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1)
+{
+	REG_WRITE(ah, AR_MCAST_FIL0, filter0);
+	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
+}
+EXPORT_SYMBOL(ath9k_hw_setmcastfilter);
+
+void ath9k_hw_write_associd(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	REG_WRITE(ah, AR_BSS_ID0, get_unaligned_le32(common->curbssid));
+	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(common->curbssid + 4) |
+		  ((common->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
+}
+EXPORT_SYMBOL(ath9k_hw_write_associd);
+
+u64 ath9k_hw_gettsf64(struct ath_hw *ah)
+{
+	u64 tsf;
+
+	tsf = REG_READ(ah, AR_TSF_U32);
+	tsf = (tsf << 32) | REG_READ(ah, AR_TSF_L32);
+
+	return tsf;
+}
+EXPORT_SYMBOL(ath9k_hw_gettsf64);
+
+void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64)
+{
+	REG_WRITE(ah, AR_TSF_L32, tsf64 & 0xffffffff);
+	REG_WRITE(ah, AR_TSF_U32, (tsf64 >> 32) & 0xffffffff);
+}
+EXPORT_SYMBOL(ath9k_hw_settsf64);
+
+void ath9k_hw_reset_tsf(struct ath_hw *ah)
+{
+	if (!ath9k_hw_wait(ah, AR_SLP32_MODE, AR_SLP32_TSF_WRITE_STATUS, 0,
+			   AH_TSF_WRITE_TIMEOUT))
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
+
+	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
+}
+EXPORT_SYMBOL(ath9k_hw_reset_tsf);
+
+void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
+{
+	if (setting)
+		ah->misc_mode |= AR_PCU_TX_ADD_TSF;
+	else
+		ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
+}
+EXPORT_SYMBOL(ath9k_hw_set_tsfadjust);
+
+bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
+{
+	if (us < ATH9K_SLOT_TIME_9 || us > ath9k_hw_mac_to_usec(ah, 0xffff)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_RESET,
+			  "bad slot time %u\n", us);
+		ah->slottime = (u32) -1;
+		return false;
+	} else {
+		REG_WRITE(ah, AR_D_GBL_IFS_SLOT, ath9k_hw_mac_to_clks(ah, us));
+		ah->slottime = us;
+		return true;
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_setslottime);
+
+void ath9k_hw_set11nmac2040(struct ath_hw *ah)
+{
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
+	u32 macmode;
+
+	if (conf_is_ht40(conf) && !ah->config.cwm_ignore_extcca)
+		macmode = AR_2040_JOINED_RX_CLEAR;
+	else
+		macmode = 0;
+
+	REG_WRITE(ah, AR_2040_MODE, macmode);
+}
+
+/* HW Generic timers configuration */
+
+static const struct ath_gen_timer_configuration gen_tmr_configuration[] =
+{
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP2_TIMER, AR_NDP2_PERIOD, AR_NDP2_TIMER_MODE, 0x0001},
+	{AR_NEXT_NDP2_TIMER + 1*4, AR_NDP2_PERIOD + 1*4,
+				AR_NDP2_TIMER_MODE, 0x0002},
+	{AR_NEXT_NDP2_TIMER + 2*4, AR_NDP2_PERIOD + 2*4,
+				AR_NDP2_TIMER_MODE, 0x0004},
+	{AR_NEXT_NDP2_TIMER + 3*4, AR_NDP2_PERIOD + 3*4,
+				AR_NDP2_TIMER_MODE, 0x0008},
+	{AR_NEXT_NDP2_TIMER + 4*4, AR_NDP2_PERIOD + 4*4,
+				AR_NDP2_TIMER_MODE, 0x0010},
+	{AR_NEXT_NDP2_TIMER + 5*4, AR_NDP2_PERIOD + 5*4,
+				AR_NDP2_TIMER_MODE, 0x0020},
+	{AR_NEXT_NDP2_TIMER + 6*4, AR_NDP2_PERIOD + 6*4,
+				AR_NDP2_TIMER_MODE, 0x0040},
+	{AR_NEXT_NDP2_TIMER + 7*4, AR_NDP2_PERIOD + 7*4,
+				AR_NDP2_TIMER_MODE, 0x0080}
+};
+
+/* HW generic timer primitives */
+
+/* compute and clear index of rightmost 1 */
+static u32 rightmost_index(struct ath_gen_timer_table *timer_table, u32 *mask)
+{
+	u32 b;
+
+	b = *mask;
+	b &= (0-b);
+	*mask &= ~b;
+	b *= debruijn32;
+	b >>= 27;
+
+	return timer_table->gen_timer_index[b];
+}
+
+u32 ath9k_hw_gettsf32(struct ath_hw *ah)
+{
+	return REG_READ(ah, AR_TSF_L32);
+}
+EXPORT_SYMBOL(ath9k_hw_gettsf32);
+
+struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
+					  void (*trigger)(void *),
+					  void (*overflow)(void *),
+					  void *arg,
+					  u8 timer_index)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+	struct ath_gen_timer *timer;
+
+	timer = kzalloc(sizeof(struct ath_gen_timer), GFP_KERNEL);
+
+	if (timer == NULL) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Failed to allocate memory"
+			  "for hw timer[%d]\n", timer_index);
+		return NULL;
+	}
+
+	/* allocate a hardware generic timer slot */
+	timer_table->timers[timer_index] = timer;
+	timer->index = timer_index;
+	timer->trigger = trigger;
+	timer->overflow = overflow;
+	timer->arg = arg;
+
+	return timer;
+}
+EXPORT_SYMBOL(ath_gen_timer_alloc);
+
+void ath9k_hw_gen_timer_start(struct ath_hw *ah,
+			      struct ath_gen_timer *timer,
+			      u32 timer_next,
+			      u32 timer_period)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+	u32 tsf;
+
+	BUG_ON(!timer_period);
+
+	set_bit(timer->index, &timer_table->timer_mask.timer_bits);
+
+	tsf = ath9k_hw_gettsf32(ah);
+
+	ath_print(ath9k_hw_common(ah), ATH_DBG_HWTIMER,
+		  "curent tsf %x period %x"
+		  "timer_next %x\n", tsf, timer_period, timer_next);
+
+	/*
+	 * Pull timer_next forward if the current TSF already passed it
+	 * because of software latency
+	 */
+	if (timer_next < tsf)
+		timer_next = tsf + timer_period;
+
+	/*
+	 * Program generic timer registers
+	 */
+	REG_WRITE(ah, gen_tmr_configuration[timer->index].next_addr,
+		 timer_next);
+	REG_WRITE(ah, gen_tmr_configuration[timer->index].period_addr,
+		  timer_period);
+	REG_SET_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
+		    gen_tmr_configuration[timer->index].mode_mask);
+
+	/* Enable both trigger and thresh interrupt masks */
+	REG_SET_BIT(ah, AR_IMR_S5,
+		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
+		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
+}
+EXPORT_SYMBOL(ath9k_hw_gen_timer_start);
+
+void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+
+	if ((timer->index < AR_FIRST_NDP_TIMER) ||
+		(timer->index >= ATH_MAX_GEN_TIMER)) {
+		return;
+	}
+
+	/* Clear generic timer enable bits. */
+	REG_CLR_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
+			gen_tmr_configuration[timer->index].mode_mask);
+
+	/* Disable both trigger and thresh interrupt masks */
+	REG_CLR_BIT(ah, AR_IMR_S5,
+		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
+		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
+
+	clear_bit(timer->index, &timer_table->timer_mask.timer_bits);
+}
+EXPORT_SYMBOL(ath9k_hw_gen_timer_stop);
+
+void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+
+	/* free the hardware generic timer slot */
+	timer_table->timers[timer->index] = NULL;
+	kfree(timer);
+}
+EXPORT_SYMBOL(ath_gen_timer_free);
+
+/*
+ * Generic Timer Interrupts handling
+ */
+void ath_gen_timer_isr(struct ath_hw *ah)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+	struct ath_gen_timer *timer;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 trigger_mask, thresh_mask, index;
+
+	/* get hardware generic timer interrupt status */
+	trigger_mask = ah->intr_gen_timer_trigger;
+	thresh_mask = ah->intr_gen_timer_thresh;
+	trigger_mask &= timer_table->timer_mask.val;
+	thresh_mask &= timer_table->timer_mask.val;
+
+	trigger_mask &= ~thresh_mask;
+
+	while (thresh_mask) {
+		index = rightmost_index(timer_table, &thresh_mask);
+		timer = timer_table->timers[index];
+		BUG_ON(!timer);
+		ath_print(common, ATH_DBG_HWTIMER,
+			  "TSF overflow for Gen timer %d\n", index);
+		timer->overflow(timer->arg);
+	}
+
+	while (trigger_mask) {
+		index = rightmost_index(timer_table, &trigger_mask);
+		timer = timer_table->timers[index];
+		BUG_ON(!timer);
+		ath_print(common, ATH_DBG_HWTIMER,
+			  "Gen timer[%d] trigger\n", index);
+		timer->trigger(timer->arg);
+	}
+}
+EXPORT_SYMBOL(ath_gen_timer_isr);
 
 /**
- * ath_hw_set_bssid_mask - filter out bssids we listen
+  ath_hw_set_bssid_mask - filter out bssids we listen
  *
  * @common: the ath_common struct for the device.
  *
@@ -120,7 +4360,7 @@ void ath_hw_setbssidmask(struct ath_common *common)
 {
 	void *ah = common->ah;
 
-	REG_WRITE(ah, get_unaligned_le32(common->bssidmask), AR_BSSMSKL);
-	REG_WRITE(ah, get_unaligned_le16(common->bssidmask + 4), AR_BSSMSKU);
+	REG_WRITE_C(ah, get_unaligned_le32(common->bssidmask), AR_BSSMSKL);
+	REG_WRITE_C(ah, get_unaligned_le16(common->bssidmask + 4), AR_BSSMSKU);
 }
 EXPORT_SYMBOL(ath_hw_setbssidmask);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/hw.h
similarity index 95%
rename from drivers/net/wireless/ath/ath9k/hw.h
rename to drivers/net/wireless/ath/hw.h
index be9763e..996ca85 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/hw.h
@@ -28,9 +28,8 @@
 #include "reg.h"
 #include "phy.h"
 #include "btcoex.h"
-
-#include "../regd.h"
-#include "../debug.h"
+#include "regd.h"
+#include "debug.h"
 
 #define ATHEROS_VENDOR_ID	0x168c
 #define AR5416_DEVID_PCI	0x0023
@@ -57,12 +56,32 @@
 
 #define ATH9K_RSSI_BAD			0x80
 
-/* Register read/write primitives */
-#define REG_WRITE(_ah, _reg, _val) \
-	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
+/*
+ * Common read/write ops. These read writes are shared between
+ * ath5k, ath9k, and ath9k_htc.
+ */
+
+#define REG_READ_C			common->ops->read
+/*
+ * This write follows common kernel coding style with val first,
+ * followed by the register offset.
+  */
+#define REG_WRITE_C			common->ops->write
+
 
-#define REG_READ(_ah, _reg) \
-	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
+/*
+ * Read / write ops for ARK hw family hw only (ath9k, ath9k_htc), these take
+ * a struct ath_hw instead of a common as their first argument. This is
+ * only transition code -- it will later be replaced with just REG_READ_C and
+ * REG_WRITE_C.
+ */
+#define REG_READ			ah->common.ops->read
+/*
+ * This write has backward order from the usual kernel code style on write,
+ * we keep it for now as this is how Atheros hw code comes in as, we'll try
+ * to change this practice...
+ */
+#define REG_WRITE(ah, reg, val)		ah->common.ops->write((void *) ah, val, reg)
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/initvals.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/initvals.h
rename to drivers/net/wireless/ath/initvals.h
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/mac.c
similarity index 96%
rename from drivers/net/wireless/ath/ath9k/mac.c
rename to drivers/net/wireless/ath/mac.c
index 3be658d..e2c1ba3 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/mac.c
@@ -39,11 +39,13 @@ u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
 {
 	return REG_READ(ah, AR_QTXDP(q));
 }
+EXPORT_SYMBOL(ath9k_hw_gettxbuf);
 
 void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 {
 	REG_WRITE(ah, AR_QTXDP(q), txdp);
 }
+EXPORT_SYMBOL(ath9k_hw_puttxbuf);
 
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
@@ -51,6 +53,7 @@ void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 		  "Enable TXE on queue: %u\n", q);
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 }
+EXPORT_SYMBOL(ath9k_hw_txstart);
 
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 {
@@ -65,6 +68,7 @@ u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 
 	return npend;
 }
+EXPORT_SYMBOL(ath9k_hw_numtxpending);
 
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 {
@@ -94,6 +98,7 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 
 	return newLevel != curLevel;
 }
+EXPORT_SYMBOL(ath9k_hw_updatetxtriglevel);
 
 bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 {
@@ -173,6 +178,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 #undef ATH9K_TX_STOP_DMA_TIMEOUT
 #undef ATH9K_TIME_QUANTUM
 }
+EXPORT_SYMBOL(ath9k_hw_stoptxdma);
 
 void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			 u32 segLen, bool firstSeg,
@@ -199,6 +205,7 @@ void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
 }
+EXPORT_SYMBOL(ath9k_hw_filltxdesc);
 
 void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds)
 {
@@ -210,6 +217,7 @@ void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds)
 	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
 }
+EXPORT_SYMBOL(ath9k_hw_cleartxdesc);
 
 int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
 {
@@ -285,6 +293,7 @@ int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
 
 	return 0;
 }
+EXPORT_SYMBOL(ath9k_hw_txprocdesc);
 
 void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
@@ -320,6 +329,7 @@ void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 		ads->ds_ctl11 = 0;
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_txdesc);
 
 void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
 				  struct ath_desc *lastds,
@@ -375,6 +385,7 @@ void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
 	last_ads->ds_ctl2 = ads->ds_ctl2;
 	last_ads->ds_ctl3 = ads->ds_ctl3;
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_ratescenario);
 
 void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
 				u32 aggrLen)
@@ -385,6 +396,7 @@ void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_ctl6 &= ~AR_AggrLen;
 	ads->ds_ctl6 |= SM(aggrLen, AR_AggrLen);
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_aggr_first);
 
 void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
 				 u32 numDelims)
@@ -399,6 +411,7 @@ void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
 	ctl6 |= SM(numDelims, AR_PadDelim);
 	ads->ds_ctl6 = ctl6;
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_aggr_middle);
 
 void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds)
 {
@@ -408,6 +421,7 @@ void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds)
 	ads->ds_ctl1 &= ~AR_MoreAggr;
 	ads->ds_ctl6 &= ~AR_PadDelim;
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_aggr_last);
 
 void ath9k_hw_clr11n_aggr(struct ath_hw *ah, struct ath_desc *ds)
 {
@@ -415,6 +429,7 @@ void ath9k_hw_clr11n_aggr(struct ath_hw *ah, struct ath_desc *ds)
 
 	ads->ds_ctl1 &= (~AR_IsAggr & ~AR_MoreAggr);
 }
+EXPORT_SYMBOL(ath9k_hw_clr11n_aggr);
 
 void ath9k_hw_set11n_burstduration(struct ath_hw *ah, struct ath_desc *ds,
 				   u32 burstDuration)
@@ -424,6 +439,7 @@ void ath9k_hw_set11n_burstduration(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_ctl2 &= ~AR_BurstDur;
 	ads->ds_ctl2 |= SM(burstDuration, AR_BurstDur);
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_burstduration);
 
 void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, struct ath_desc *ds,
 				     u32 vmf)
@@ -441,6 +457,7 @@ void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs)
 	*txqs &= ah->intr_txqs;
 	ah->intr_txqs &= ~(*txqs);
 }
+EXPORT_SYMBOL(ath9k_hw_gettxintrtxqs);
 
 bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo)
@@ -512,6 +529,7 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_set_txq_props);
 
 bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 			    struct ath9k_tx_queue_info *qinfo)
@@ -550,6 +568,7 @@ bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_get_txq_props);
 
 int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			  const struct ath9k_tx_queue_info *qinfo)
@@ -617,6 +636,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 
 	return q;
 }
+EXPORT_SYMBOL(ath9k_hw_setuptxqueue);
 
 bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 {
@@ -648,6 +668,7 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_releasetxqueue);
 
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 {
@@ -805,6 +826,7 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_resettxqueue);
 
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			u32 pa, struct ath_desc *nds, u64 tsf)
@@ -886,6 +908,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 
 	return 0;
 }
+EXPORT_SYMBOL(ath9k_hw_rxprocdesc);
 
 void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
@@ -901,6 +924,7 @@ void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 		memset(&(ads->u), 0, sizeof(ads->u));
 }
+EXPORT_SYMBOL(ath9k_hw_setuprxdesc);
 
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 {
@@ -930,16 +954,19 @@ bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_setrxabort);
 
 void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp)
 {
 	REG_WRITE(ah, AR_RXDP, rxdp);
 }
+EXPORT_SYMBOL(ath9k_hw_putrxbuf);
 
 void ath9k_hw_rxena(struct ath_hw *ah)
 {
 	REG_WRITE(ah, AR_CR, AR_CR_RXE);
 }
+EXPORT_SYMBOL(ath9k_hw_rxena);
 
 void ath9k_hw_startpcureceive(struct ath_hw *ah)
 {
@@ -949,6 +976,7 @@ void ath9k_hw_startpcureceive(struct ath_hw *ah)
 
 	REG_CLR_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 }
+EXPORT_SYMBOL(ath9k_hw_startpcureceive);
 
 void ath9k_hw_stoppcurecv(struct ath_hw *ah)
 {
@@ -956,6 +984,7 @@ void ath9k_hw_stoppcurecv(struct ath_hw *ah)
 
 	ath9k_hw_disable_mib_counters(ah);
 }
+EXPORT_SYMBOL(ath9k_hw_stoppcurecv);
 
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 {
@@ -988,3 +1017,4 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 #undef AH_RX_TIME_QUANTUM
 #undef AH_RX_STOP_DMA_TIMEOUT
 }
+EXPORT_SYMBOL(ath9k_hw_stopdmarecv);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/mac.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/mac.h
rename to drivers/net/wireless/ath/mac.h
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/phy.c
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/phy.c
rename to drivers/net/wireless/ath/phy.c
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/phy.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/phy.h
rename to drivers/net/wireless/ath/phy.h
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/rc.h
similarity index 100%
rename from drivers/net/wireless/ath/ath9k/rc.h
rename to drivers/net/wireless/ath/rc.h
diff --git a/drivers/net/wireless/ath/reg.h b/drivers/net/wireless/ath/reg.h
index dfe1fbe..7412d76 100644
--- a/drivers/net/wireless/ath/reg.h
+++ b/drivers/net/wireless/ath/reg.h
@@ -17,11 +17,1695 @@
 #ifndef ATH_REGISTERS_H
 #define ATH_REGISTERS_H
 
+#define AR_CR                0x0008
+#define AR_CR_RXE            0x00000004
+#define AR_CR_RXD            0x00000020
+#define AR_CR_SWI            0x00000040
+
+#define AR_RXDP              0x000C
+
+#define AR_CFG               0x0014
+#define AR_CFG_SWTD          0x00000001
+#define AR_CFG_SWTB          0x00000002
+#define AR_CFG_SWRD          0x00000004
+#define AR_CFG_SWRB          0x00000008
+#define AR_CFG_SWRG          0x00000010
+#define AR_CFG_AP_ADHOC_INDICATION 0x00000020
+#define AR_CFG_PHOK          0x00000100
+#define AR_CFG_CLK_GATE_DIS  0x00000400
+#define AR_CFG_EEBS          0x00000200
+#define AR_CFG_PCI_MASTER_REQ_Q_THRESH         0x00060000
+#define AR_CFG_PCI_MASTER_REQ_Q_THRESH_S       17
+
+#define AR_MIRT              0x0020
+#define AR_MIRT_VAL          0x0000ffff
+#define AR_MIRT_VAL_S        16
+
+#define AR_IER               0x0024
+#define AR_IER_ENABLE        0x00000001
+#define AR_IER_DISABLE       0x00000000
+
+#define AR_TIMT              0x0028
+#define AR_TIMT_LAST         0x0000ffff
+#define AR_TIMT_LAST_S       0
+#define AR_TIMT_FIRST        0xffff0000
+#define AR_TIMT_FIRST_S      16
+
+#define AR_RIMT              0x002C
+#define AR_RIMT_LAST         0x0000ffff
+#define AR_RIMT_LAST_S       0
+#define AR_RIMT_FIRST        0xffff0000
+#define AR_RIMT_FIRST_S      16
+
+#define AR_DMASIZE_4B        0x00000000
+#define AR_DMASIZE_8B        0x00000001
+#define AR_DMASIZE_16B       0x00000002
+#define AR_DMASIZE_32B       0x00000003
+#define AR_DMASIZE_64B       0x00000004
+#define AR_DMASIZE_128B      0x00000005
+#define AR_DMASIZE_256B      0x00000006
+#define AR_DMASIZE_512B      0x00000007
+
+#define AR_TXCFG             0x0030
+#define AR_TXCFG_DMASZ_MASK  0x00000007
+#define AR_TXCFG_DMASZ_4B    0
+#define AR_TXCFG_DMASZ_8B    1
+#define AR_TXCFG_DMASZ_16B   2
+#define AR_TXCFG_DMASZ_32B   3
+#define AR_TXCFG_DMASZ_64B   4
+#define AR_TXCFG_DMASZ_128B  5
+#define AR_TXCFG_DMASZ_256B  6
+#define AR_TXCFG_DMASZ_512B  7
+#define AR_FTRIG             0x000003F0
+#define AR_FTRIG_S           4
+#define AR_FTRIG_IMMED       0x00000000
+#define AR_FTRIG_64B         0x00000010
+#define AR_FTRIG_128B        0x00000020
+#define AR_FTRIG_192B        0x00000030
+#define AR_FTRIG_256B        0x00000040
+#define AR_FTRIG_512B        0x00000080
+#define AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY 0x00000800
+
+#define AR_RXCFG             0x0034
+#define AR_RXCFG_CHIRP       0x00000008
+#define AR_RXCFG_ZLFDMA      0x00000010
+#define AR_RXCFG_DMASZ_MASK  0x00000007
+#define AR_RXCFG_DMASZ_4B    0
+#define AR_RXCFG_DMASZ_8B    1
+#define AR_RXCFG_DMASZ_16B   2
+#define AR_RXCFG_DMASZ_32B   3
+#define AR_RXCFG_DMASZ_64B   4
+#define AR_RXCFG_DMASZ_128B  5
+#define AR_RXCFG_DMASZ_256B  6
+#define AR_RXCFG_DMASZ_512B  7
+
+#define AR_MIBC              0x0040
+#define AR_MIBC_COW          0x00000001
+#define AR_MIBC_FMC          0x00000002
+#define AR_MIBC_CMC          0x00000004
+#define AR_MIBC_MCS          0x00000008
+
+#define AR_TOPS              0x0044
+#define AR_TOPS_MASK         0x0000FFFF
+
+#define AR_RXNPTO            0x0048
+#define AR_RXNPTO_MASK       0x000003FF
+
+#define AR_TXNPTO            0x004C
+#define AR_TXNPTO_MASK       0x000003FF
+#define AR_TXNPTO_QCU_MASK   0x000FFC00
+
+#define AR_RPGTO             0x0050
+#define AR_RPGTO_MASK        0x000003FF
+
+#define AR_RPCNT             0x0054
+#define AR_RPCNT_MASK        0x0000001F
+
+#define AR_MACMISC           0x0058
+#define AR_MACMISC_PCI_EXT_FORCE        0x00000010
+#define AR_MACMISC_DMA_OBS              0x000001E0
+#define AR_MACMISC_DMA_OBS_S            5
+#define AR_MACMISC_DMA_OBS_LINE_0       0
+#define AR_MACMISC_DMA_OBS_LINE_1       1
+#define AR_MACMISC_DMA_OBS_LINE_2       2
+#define AR_MACMISC_DMA_OBS_LINE_3       3
+#define AR_MACMISC_DMA_OBS_LINE_4       4
+#define AR_MACMISC_DMA_OBS_LINE_5       5
+#define AR_MACMISC_DMA_OBS_LINE_6       6
+#define AR_MACMISC_DMA_OBS_LINE_7       7
+#define AR_MACMISC_DMA_OBS_LINE_8       8
+#define AR_MACMISC_MISC_OBS             0x00000E00
+#define AR_MACMISC_MISC_OBS_S           9
+#define AR_MACMISC_MISC_OBS_BUS_LSB     0x00007000
+#define AR_MACMISC_MISC_OBS_BUS_LSB_S   12
+#define AR_MACMISC_MISC_OBS_BUS_MSB     0x00038000
+#define AR_MACMISC_MISC_OBS_BUS_MSB_S   15
+#define AR_MACMISC_MISC_OBS_BUS_1       1
+
+#define AR_GTXTO    0x0064
+#define AR_GTXTO_TIMEOUT_COUNTER    0x0000FFFF
+#define AR_GTXTO_TIMEOUT_LIMIT      0xFFFF0000
+#define AR_GTXTO_TIMEOUT_LIMIT_S    16
+
+#define AR_GTTM     0x0068
+#define AR_GTTM_USEC          0x00000001
+#define AR_GTTM_IGNORE_IDLE   0x00000002
+#define AR_GTTM_RESET_IDLE    0x00000004
+#define AR_GTTM_CST_USEC      0x00000008
+
+#define AR_CST         0x006C
+#define AR_CST_TIMEOUT_COUNTER    0x0000FFFF
+#define AR_CST_TIMEOUT_LIMIT      0xFFFF0000
+#define AR_CST_TIMEOUT_LIMIT_S    16
+
+#define AR_ISR               0x0080
+#define AR_ISR_RXOK          0x00000001
+#define AR_ISR_RXDESC        0x00000002
+#define AR_ISR_RXERR         0x00000004
+#define AR_ISR_RXNOPKT       0x00000008
+#define AR_ISR_RXEOL         0x00000010
+#define AR_ISR_RXORN         0x00000020
+#define AR_ISR_TXOK          0x00000040
+#define AR_ISR_TXDESC        0x00000080
+#define AR_ISR_TXERR         0x00000100
+#define AR_ISR_TXNOPKT       0x00000200
+#define AR_ISR_TXEOL         0x00000400
+#define AR_ISR_TXURN         0x00000800
+#define AR_ISR_MIB           0x00001000
+#define AR_ISR_SWI           0x00002000
+#define AR_ISR_RXPHY         0x00004000
+#define AR_ISR_RXKCM         0x00008000
+#define AR_ISR_SWBA          0x00010000
+#define AR_ISR_BRSSI         0x00020000
+#define AR_ISR_BMISS         0x00040000
+#define AR_ISR_BNR           0x00100000
+#define AR_ISR_RXCHIRP       0x00200000
+#define AR_ISR_BCNMISC       0x00800000
+#define AR_ISR_TIM           0x00800000
+#define AR_ISR_QCBROVF       0x02000000
+#define AR_ISR_QCBRURN       0x04000000
+#define AR_ISR_QTRIG         0x08000000
+#define AR_ISR_GENTMR        0x10000000
+
+#define AR_ISR_TXMINTR       0x00080000
+#define AR_ISR_RXMINTR       0x01000000
+#define AR_ISR_TXINTM        0x40000000
+#define AR_ISR_RXINTM        0x80000000
+
+#define AR_ISR_S0               0x0084
+#define AR_ISR_S0_QCU_TXOK      0x000003FF
+#define AR_ISR_S0_QCU_TXOK_S    0
+#define AR_ISR_S0_QCU_TXDESC    0x03FF0000
+#define AR_ISR_S0_QCU_TXDESC_S  16
+
+#define AR_ISR_S1              0x0088
+#define AR_ISR_S1_QCU_TXERR    0x000003FF
+#define AR_ISR_S1_QCU_TXERR_S  0
+#define AR_ISR_S1_QCU_TXEOL    0x03FF0000
+#define AR_ISR_S1_QCU_TXEOL_S  16
+
+#define AR_ISR_S2              0x008c
+#define AR_ISR_S2_QCU_TXURN    0x000003FF
+#define AR_ISR_S2_CST          0x00400000
+#define AR_ISR_S2_GTT          0x00800000
+#define AR_ISR_S2_TIM          0x01000000
+#define AR_ISR_S2_CABEND       0x02000000
+#define AR_ISR_S2_DTIMSYNC     0x04000000
+#define AR_ISR_S2_BCNTO        0x08000000
+#define AR_ISR_S2_CABTO        0x10000000
+#define AR_ISR_S2_DTIM         0x20000000
+#define AR_ISR_S2_TSFOOR       0x40000000
+#define AR_ISR_S2_TBTT_TIME    0x80000000
+
+#define AR_ISR_S3             0x0090
+#define AR_ISR_S3_QCU_QCBROVF    0x000003FF
+#define AR_ISR_S3_QCU_QCBRURN    0x03FF0000
+
+#define AR_ISR_S4              0x0094
+#define AR_ISR_S4_QCU_QTRIG    0x000003FF
+#define AR_ISR_S4_RESV0        0xFFFFFC00
+
+#define AR_ISR_S5                   0x0098
+#define AR_ISR_S5_TIMER_TRIG        0x000000FF
+#define AR_ISR_S5_TIMER_THRESH      0x0007FE00
+#define AR_ISR_S5_TIM_TIMER         0x00000010
+#define AR_ISR_S5_DTIM_TIMER        0x00000020
+#define AR_ISR_S5_S                 0x00d8
+#define AR_IMR_S5                   0x00b8
+#define AR_IMR_S5_TIM_TIMER         0x00000010
+#define AR_IMR_S5_DTIM_TIMER        0x00000020
+#define AR_ISR_S5_GENTIMER_TRIG     0x0000FF80
+#define AR_ISR_S5_GENTIMER_TRIG_S   0
+#define AR_ISR_S5_GENTIMER_THRESH   0xFF800000
+#define AR_ISR_S5_GENTIMER_THRESH_S 16
+#define AR_ISR_S5_S                 0x00d8
+#define AR_IMR_S5_GENTIMER_TRIG     0x0000FF80
+#define AR_IMR_S5_GENTIMER_TRIG_S   0
+#define AR_IMR_S5_GENTIMER_THRESH   0xFF800000
+#define AR_IMR_S5_GENTIMER_THRESH_S 16
+
+#define AR_IMR               0x00a0
+#define AR_IMR_RXOK          0x00000001
+#define AR_IMR_RXDESC        0x00000002
+#define AR_IMR_RXERR         0x00000004
+#define AR_IMR_RXNOPKT       0x00000008
+#define AR_IMR_RXEOL         0x00000010
+#define AR_IMR_RXORN         0x00000020
+#define AR_IMR_TXOK          0x00000040
+#define AR_IMR_TXDESC        0x00000080
+#define AR_IMR_TXERR         0x00000100
+#define AR_IMR_TXNOPKT       0x00000200
+#define AR_IMR_TXEOL         0x00000400
+#define AR_IMR_TXURN         0x00000800
+#define AR_IMR_MIB           0x00001000
+#define AR_IMR_SWI           0x00002000
+#define AR_IMR_RXPHY         0x00004000
+#define AR_IMR_RXKCM         0x00008000
+#define AR_IMR_SWBA          0x00010000
+#define AR_IMR_BRSSI         0x00020000
+#define AR_IMR_BMISS         0x00040000
+#define AR_IMR_BNR           0x00100000
+#define AR_IMR_RXCHIRP       0x00200000
+#define AR_IMR_BCNMISC       0x00800000
+#define AR_IMR_TIM           0x00800000
+#define AR_IMR_QCBROVF       0x02000000
+#define AR_IMR_QCBRURN       0x04000000
+#define AR_IMR_QTRIG         0x08000000
+#define AR_IMR_GENTMR        0x10000000
+
+#define AR_IMR_TXMINTR       0x00080000
+#define AR_IMR_RXMINTR       0x01000000
+#define AR_IMR_TXINTM        0x40000000
+#define AR_IMR_RXINTM        0x80000000
+
+#define AR_IMR_S0               0x00a4
+#define AR_IMR_S0_QCU_TXOK      0x000003FF
+#define AR_IMR_S0_QCU_TXOK_S    0
+#define AR_IMR_S0_QCU_TXDESC    0x03FF0000
+#define AR_IMR_S0_QCU_TXDESC_S  16
+
+#define AR_IMR_S1              0x00a8
+#define AR_IMR_S1_QCU_TXERR    0x000003FF
+#define AR_IMR_S1_QCU_TXERR_S  0
+#define AR_IMR_S1_QCU_TXEOL    0x03FF0000
+#define AR_IMR_S1_QCU_TXEOL_S  16
+
+#define AR_IMR_S2              0x00ac
+#define AR_IMR_S2_QCU_TXURN    0x000003FF
+#define AR_IMR_S2_QCU_TXURN_S  0
+#define AR_IMR_S2_CST          0x00400000
+#define AR_IMR_S2_GTT          0x00800000
+#define AR_IMR_S2_TIM          0x01000000
+#define AR_IMR_S2_CABEND       0x02000000
+#define AR_IMR_S2_DTIMSYNC     0x04000000
+#define AR_IMR_S2_BCNTO        0x08000000
+#define AR_IMR_S2_CABTO        0x10000000
+#define AR_IMR_S2_DTIM         0x20000000
+#define AR_IMR_S2_TSFOOR       0x40000000
+
+#define AR_IMR_S3                0x00b0
+#define AR_IMR_S3_QCU_QCBROVF    0x000003FF
+#define AR_IMR_S3_QCU_QCBRURN    0x03FF0000
+#define AR_IMR_S3_QCU_QCBRURN_S  16
+
+#define AR_IMR_S4              0x00b4
+#define AR_IMR_S4_QCU_QTRIG    0x000003FF
+#define AR_IMR_S4_RESV0        0xFFFFFC00
+
+#define AR_IMR_S5              0x00b8
+#define AR_IMR_S5_TIMER_TRIG        0x000000FF
+#define AR_IMR_S5_TIMER_THRESH      0x0000FF00
+
+
+#define AR_ISR_RAC            0x00c0
+#define AR_ISR_S0_S           0x00c4
+#define AR_ISR_S0_QCU_TXOK      0x000003FF
+#define AR_ISR_S0_QCU_TXOK_S    0
+#define AR_ISR_S0_QCU_TXDESC    0x03FF0000
+#define AR_ISR_S0_QCU_TXDESC_S  16
+
+#define AR_ISR_S1_S           0x00c8
+#define AR_ISR_S1_QCU_TXERR    0x000003FF
+#define AR_ISR_S1_QCU_TXERR_S  0
+#define AR_ISR_S1_QCU_TXEOL    0x03FF0000
+#define AR_ISR_S1_QCU_TXEOL_S  16
+
+#define AR_ISR_S2_S           0x00cc
+#define AR_ISR_S3_S           0x00d0
+#define AR_ISR_S4_S           0x00d4
+#define AR_ISR_S5_S           0x00d8
+#define AR_DMADBG_0           0x00e0
+#define AR_DMADBG_1           0x00e4
+#define AR_DMADBG_2           0x00e8
+#define AR_DMADBG_3           0x00ec
+#define AR_DMADBG_4           0x00f0
+#define AR_DMADBG_5           0x00f4
+#define AR_DMADBG_6           0x00f8
+#define AR_DMADBG_7           0x00fc
+
+#define AR_NUM_QCU      10
+#define AR_QCU_0        0x0001
+#define AR_QCU_1        0x0002
+#define AR_QCU_2        0x0004
+#define AR_QCU_3        0x0008
+#define AR_QCU_4        0x0010
+#define AR_QCU_5        0x0020
+#define AR_QCU_6        0x0040
+#define AR_QCU_7        0x0080
+#define AR_QCU_8        0x0100
+#define AR_QCU_9        0x0200
+
+#define AR_Q0_TXDP           0x0800
+#define AR_Q1_TXDP           0x0804
+#define AR_Q2_TXDP           0x0808
+#define AR_Q3_TXDP           0x080c
+#define AR_Q4_TXDP           0x0810
+#define AR_Q5_TXDP           0x0814
+#define AR_Q6_TXDP           0x0818
+#define AR_Q7_TXDP           0x081c
+#define AR_Q8_TXDP           0x0820
+#define AR_Q9_TXDP           0x0824
+#define AR_QTXDP(_i)    (AR_Q0_TXDP + ((_i)<<2))
+
+#define AR_Q_TXE             0x0840
+#define AR_Q_TXE_M           0x000003FF
+
+#define AR_Q_TXD             0x0880
+#define AR_Q_TXD_M           0x000003FF
+
+#define AR_Q0_CBRCFG         0x08c0
+#define AR_Q1_CBRCFG         0x08c4
+#define AR_Q2_CBRCFG         0x08c8
+#define AR_Q3_CBRCFG         0x08cc
+#define AR_Q4_CBRCFG         0x08d0
+#define AR_Q5_CBRCFG         0x08d4
+#define AR_Q6_CBRCFG         0x08d8
+#define AR_Q7_CBRCFG         0x08dc
+#define AR_Q8_CBRCFG         0x08e0
+#define AR_Q9_CBRCFG         0x08e4
+#define AR_QCBRCFG(_i)      (AR_Q0_CBRCFG + ((_i)<<2))
+#define AR_Q_CBRCFG_INTERVAL     0x00FFFFFF
+#define AR_Q_CBRCFG_INTERVAL_S   0
+#define AR_Q_CBRCFG_OVF_THRESH   0xFF000000
+#define AR_Q_CBRCFG_OVF_THRESH_S 24
+
+#define AR_Q0_RDYTIMECFG         0x0900
+#define AR_Q1_RDYTIMECFG         0x0904
+#define AR_Q2_RDYTIMECFG         0x0908
+#define AR_Q3_RDYTIMECFG         0x090c
+#define AR_Q4_RDYTIMECFG         0x0910
+#define AR_Q5_RDYTIMECFG         0x0914
+#define AR_Q6_RDYTIMECFG         0x0918
+#define AR_Q7_RDYTIMECFG         0x091c
+#define AR_Q8_RDYTIMECFG         0x0920
+#define AR_Q9_RDYTIMECFG         0x0924
+#define AR_QRDYTIMECFG(_i)       (AR_Q0_RDYTIMECFG + ((_i)<<2))
+#define AR_Q_RDYTIMECFG_DURATION   0x00FFFFFF
+#define AR_Q_RDYTIMECFG_DURATION_S 0
+#define AR_Q_RDYTIMECFG_EN         0x01000000
+
+#define AR_Q_ONESHOTARM_SC       0x0940
+#define AR_Q_ONESHOTARM_SC_M     0x000003FF
+#define AR_Q_ONESHOTARM_SC_RESV0 0xFFFFFC00
+
+#define AR_Q_ONESHOTARM_CC       0x0980
+#define AR_Q_ONESHOTARM_CC_M     0x000003FF
+#define AR_Q_ONESHOTARM_CC_RESV0 0xFFFFFC00
+
+#define AR_Q0_MISC         0x09c0
+#define AR_Q1_MISC         0x09c4
+#define AR_Q2_MISC         0x09c8
+#define AR_Q3_MISC         0x09cc
+#define AR_Q4_MISC         0x09d0
+#define AR_Q5_MISC         0x09d4
+#define AR_Q6_MISC         0x09d8
+#define AR_Q7_MISC         0x09dc
+#define AR_Q8_MISC         0x09e0
+#define AR_Q9_MISC         0x09e4
+#define AR_QMISC(_i)       (AR_Q0_MISC + ((_i)<<2))
+#define AR_Q_MISC_FSP                     0x0000000F
+#define AR_Q_MISC_FSP_ASAP                0
+#define AR_Q_MISC_FSP_CBR                 1
+#define AR_Q_MISC_FSP_DBA_GATED           2
+#define AR_Q_MISC_FSP_TIM_GATED           3
+#define AR_Q_MISC_FSP_BEACON_SENT_GATED   4
+#define AR_Q_MISC_FSP_BEACON_RCVD_GATED   5
+#define AR_Q_MISC_ONE_SHOT_EN             0x00000010
+#define AR_Q_MISC_CBR_INCR_DIS1           0x00000020
+#define AR_Q_MISC_CBR_INCR_DIS0           0x00000040
+#define AR_Q_MISC_BEACON_USE              0x00000080
+#define AR_Q_MISC_CBR_EXP_CNTR_LIMIT_EN   0x00000100
+#define AR_Q_MISC_RDYTIME_EXP_POLICY      0x00000200
+#define AR_Q_MISC_RESET_CBR_EXP_CTR       0x00000400
+#define AR_Q_MISC_DCU_EARLY_TERM_REQ      0x00000800
+#define AR_Q_MISC_RESV0                   0xFFFFF000
+
+#define AR_Q0_STS         0x0a00
+#define AR_Q1_STS         0x0a04
+#define AR_Q2_STS         0x0a08
+#define AR_Q3_STS         0x0a0c
+#define AR_Q4_STS         0x0a10
+#define AR_Q5_STS         0x0a14
+#define AR_Q6_STS         0x0a18
+#define AR_Q7_STS         0x0a1c
+#define AR_Q8_STS         0x0a20
+#define AR_Q9_STS         0x0a24
+#define AR_QSTS(_i)       (AR_Q0_STS + ((_i)<<2))
+#define AR_Q_STS_PEND_FR_CNT          0x00000003
+#define AR_Q_STS_RESV0                0x000000FC
+#define AR_Q_STS_CBR_EXP_CNT          0x0000FF00
+#define AR_Q_STS_RESV1                0xFFFF0000
+
+#define AR_Q_RDYTIMESHDN    0x0a40
+#define AR_Q_RDYTIMESHDN_M  0x000003FF
+
+
+#define AR_NUM_DCU      10
+#define AR_DCU_0        0x0001
+#define AR_DCU_1        0x0002
+#define AR_DCU_2        0x0004
+#define AR_DCU_3        0x0008
+#define AR_DCU_4        0x0010
+#define AR_DCU_5        0x0020
+#define AR_DCU_6        0x0040
+#define AR_DCU_7        0x0080
+#define AR_DCU_8        0x0100
+#define AR_DCU_9        0x0200
+
+#define AR_D0_QCUMASK     0x1000
+#define AR_D1_QCUMASK     0x1004
+#define AR_D2_QCUMASK     0x1008
+#define AR_D3_QCUMASK     0x100c
+#define AR_D4_QCUMASK     0x1010
+#define AR_D5_QCUMASK     0x1014
+#define AR_D6_QCUMASK     0x1018
+#define AR_D7_QCUMASK     0x101c
+#define AR_D8_QCUMASK     0x1020
+#define AR_D9_QCUMASK     0x1024
+#define AR_DQCUMASK(_i)   (AR_D0_QCUMASK + ((_i)<<2))
+#define AR_D_QCUMASK         0x000003FF
+#define AR_D_QCUMASK_RESV0   0xFFFFFC00
+
+#define AR_D_TXBLK_CMD  0x1038
+#define AR_D_TXBLK_DATA(i) (AR_D_TXBLK_CMD+(i))
+
+#define AR_D0_LCL_IFS     0x1040
+#define AR_D1_LCL_IFS     0x1044
+#define AR_D2_LCL_IFS     0x1048
+#define AR_D3_LCL_IFS     0x104c
+#define AR_D4_LCL_IFS     0x1050
+#define AR_D5_LCL_IFS     0x1054
+#define AR_D6_LCL_IFS     0x1058
+#define AR_D7_LCL_IFS     0x105c
+#define AR_D8_LCL_IFS     0x1060
+#define AR_D9_LCL_IFS     0x1064
+#define AR_DLCL_IFS(_i)   (AR_D0_LCL_IFS + ((_i)<<2))
+#define AR_D_LCL_IFS_CWMIN       0x000003FF
+#define AR_D_LCL_IFS_CWMIN_S     0
+#define AR_D_LCL_IFS_CWMAX       0x000FFC00
+#define AR_D_LCL_IFS_CWMAX_S     10
+#define AR_D_LCL_IFS_AIFS        0x0FF00000
+#define AR_D_LCL_IFS_AIFS_S      20
+
+#define AR_D_LCL_IFS_RESV0    0xF0000000
+
+#define AR_D0_RETRY_LIMIT     0x1080
+#define AR_D1_RETRY_LIMIT     0x1084
+#define AR_D2_RETRY_LIMIT     0x1088
+#define AR_D3_RETRY_LIMIT     0x108c
+#define AR_D4_RETRY_LIMIT     0x1090
+#define AR_D5_RETRY_LIMIT     0x1094
+#define AR_D6_RETRY_LIMIT     0x1098
+#define AR_D7_RETRY_LIMIT     0x109c
+#define AR_D8_RETRY_LIMIT     0x10a0
+#define AR_D9_RETRY_LIMIT     0x10a4
+#define AR_DRETRY_LIMIT(_i)   (AR_D0_RETRY_LIMIT + ((_i)<<2))
+#define AR_D_RETRY_LIMIT_FR_SH       0x0000000F
+#define AR_D_RETRY_LIMIT_FR_SH_S     0
+#define AR_D_RETRY_LIMIT_STA_SH      0x00003F00
+#define AR_D_RETRY_LIMIT_STA_SH_S    8
+#define AR_D_RETRY_LIMIT_STA_LG      0x000FC000
+#define AR_D_RETRY_LIMIT_STA_LG_S    14
+#define AR_D_RETRY_LIMIT_RESV0       0xFFF00000
+
+#define AR_D0_CHNTIME     0x10c0
+#define AR_D1_CHNTIME     0x10c4
+#define AR_D2_CHNTIME     0x10c8
+#define AR_D3_CHNTIME     0x10cc
+#define AR_D4_CHNTIME     0x10d0
+#define AR_D5_CHNTIME     0x10d4
+#define AR_D6_CHNTIME     0x10d8
+#define AR_D7_CHNTIME     0x10dc
+#define AR_D8_CHNTIME     0x10e0
+#define AR_D9_CHNTIME     0x10e4
+#define AR_DCHNTIME(_i)   (AR_D0_CHNTIME + ((_i)<<2))
+#define AR_D_CHNTIME_DUR         0x000FFFFF
+#define AR_D_CHNTIME_DUR_S       0
+#define AR_D_CHNTIME_EN          0x00100000
+#define AR_D_CHNTIME_RESV0       0xFFE00000
+
+#define AR_D0_MISC        0x1100
+#define AR_D1_MISC        0x1104
+#define AR_D2_MISC        0x1108
+#define AR_D3_MISC        0x110c
+#define AR_D4_MISC        0x1110
+#define AR_D5_MISC        0x1114
+#define AR_D6_MISC        0x1118
+#define AR_D7_MISC        0x111c
+#define AR_D8_MISC        0x1120
+#define AR_D9_MISC        0x1124
+#define AR_DMISC(_i)      (AR_D0_MISC + ((_i)<<2))
+#define AR_D_MISC_BKOFF_THRESH        0x0000003F
+#define AR_D_MISC_RETRY_CNT_RESET_EN  0x00000040
+#define AR_D_MISC_CW_RESET_EN         0x00000080
+#define AR_D_MISC_FRAG_WAIT_EN        0x00000100
+#define AR_D_MISC_FRAG_BKOFF_EN       0x00000200
+#define AR_D_MISC_CW_BKOFF_EN         0x00001000
+#define AR_D_MISC_VIR_COL_HANDLING    0x0000C000
+#define AR_D_MISC_VIR_COL_HANDLING_S  14
+#define AR_D_MISC_VIR_COL_HANDLING_DEFAULT 0
+#define AR_D_MISC_VIR_COL_HANDLING_IGNORE  1
+#define AR_D_MISC_BEACON_USE          0x00010000
+#define AR_D_MISC_ARB_LOCKOUT_CNTRL   0x00060000
+#define AR_D_MISC_ARB_LOCKOUT_CNTRL_S 17
+#define AR_D_MISC_ARB_LOCKOUT_CNTRL_NONE     0
+#define AR_D_MISC_ARB_LOCKOUT_CNTRL_INTRA_FR 1
+#define AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL   2
+#define AR_D_MISC_ARB_LOCKOUT_IGNORE  0x00080000
+#define AR_D_MISC_SEQ_NUM_INCR_DIS    0x00100000
+#define AR_D_MISC_POST_FR_BKOFF_DIS   0x00200000
+#define AR_D_MISC_VIT_COL_CW_BKOFF_EN 0x00400000
+#define AR_D_MISC_BLOWN_IFS_RETRY_EN  0x00800000
+#define AR_D_MISC_RESV0               0xFF000000
+
+#define AR_D_SEQNUM      0x1140
+
+#define AR_D_GBL_IFS_SIFS         0x1030
+#define AR_D_GBL_IFS_SIFS_M       0x0000FFFF
+#define AR_D_GBL_IFS_SIFS_ASYNC_FIFO_DUR 0x000003AB
+#define AR_D_GBL_IFS_SIFS_RESV0   0xFFFFFFFF
+
+#define AR_D_TXBLK_BASE            0x1038
+#define AR_D_TXBLK_WRITE_BITMASK    0x0000FFFF
+#define AR_D_TXBLK_WRITE_BITMASK_S  0
+#define AR_D_TXBLK_WRITE_SLICE      0x000F0000
+#define AR_D_TXBLK_WRITE_SLICE_S    16
+#define AR_D_TXBLK_WRITE_DCU        0x00F00000
+#define AR_D_TXBLK_WRITE_DCU_S      20
+#define AR_D_TXBLK_WRITE_COMMAND    0x0F000000
+#define AR_D_TXBLK_WRITE_COMMAND_S      24
+
+#define AR_D_GBL_IFS_SLOT         0x1070
+#define AR_D_GBL_IFS_SLOT_M       0x0000FFFF
+#define AR_D_GBL_IFS_SLOT_RESV0   0xFFFF0000
+#define AR_D_GBL_IFS_SLOT_ASYNC_FIFO_DUR   0x00000420
+
+#define AR_D_GBL_IFS_EIFS         0x10b0
+#define AR_D_GBL_IFS_EIFS_M       0x0000FFFF
+#define AR_D_GBL_IFS_EIFS_RESV0   0xFFFF0000
+#define AR_D_GBL_IFS_EIFS_ASYNC_FIFO_DUR   0x0000A5EB
+
+#define AR_D_GBL_IFS_MISC        0x10f0
+#define AR_D_GBL_IFS_MISC_LFSR_SLICE_SEL        0x00000007
+#define AR_D_GBL_IFS_MISC_TURBO_MODE            0x00000008
+#define AR_D_GBL_IFS_MISC_USEC_DURATION         0x000FFC00
+#define AR_D_GBL_IFS_MISC_DCU_ARBITER_DLY       0x00300000
+#define AR_D_GBL_IFS_MISC_RANDOM_LFSR_SLICE_DIS 0x01000000
+#define AR_D_GBL_IFS_MISC_SLOT_XMIT_WIND_LEN    0x06000000
+#define AR_D_GBL_IFS_MISC_FORCE_XMIT_SLOT_BOUND 0x08000000
+#define AR_D_GBL_IFS_MISC_IGNORE_BACKOFF        0x10000000
+
+#define AR_D_FPCTL                  0x1230
+#define AR_D_FPCTL_DCU              0x0000000F
+#define AR_D_FPCTL_DCU_S            0
+#define AR_D_FPCTL_PREFETCH_EN      0x00000010
+#define AR_D_FPCTL_BURST_PREFETCH   0x00007FE0
+#define AR_D_FPCTL_BURST_PREFETCH_S 5
+
+#define AR_D_TXPSE                 0x1270
+#define AR_D_TXPSE_CTRL            0x000003FF
+#define AR_D_TXPSE_RESV0           0x0000FC00
+#define AR_D_TXPSE_STATUS          0x00010000
+#define AR_D_TXPSE_RESV1           0xFFFE0000
+
+#define AR_D_TXSLOTMASK            0x12f0
+#define AR_D_TXSLOTMASK_NUM        0x0000000F
+
+#define AR_CFG_LED                     0x1f04
+#define AR_CFG_SCLK_RATE_IND           0x00000003
+#define AR_CFG_SCLK_RATE_IND_S         0
+#define AR_CFG_SCLK_32MHZ              0x00000000
+#define AR_CFG_SCLK_4MHZ               0x00000001
+#define AR_CFG_SCLK_1MHZ               0x00000002
+#define AR_CFG_SCLK_32KHZ              0x00000003
+#define AR_CFG_LED_BLINK_SLOW          0x00000008
+#define AR_CFG_LED_BLINK_THRESH_SEL    0x00000070
+#define AR_CFG_LED_MODE_SEL            0x00000380
+#define AR_CFG_LED_MODE_SEL_S          7
+#define AR_CFG_LED_POWER               0x00000280
+#define AR_CFG_LED_POWER_S             7
+#define AR_CFG_LED_NETWORK             0x00000300
+#define AR_CFG_LED_NETWORK_S           7
+#define AR_CFG_LED_MODE_PROP           0x0
+#define AR_CFG_LED_MODE_RPROP          0x1
+#define AR_CFG_LED_MODE_SPLIT          0x2
+#define AR_CFG_LED_MODE_RAND           0x3
+#define AR_CFG_LED_MODE_POWER_OFF      0x4
+#define AR_CFG_LED_MODE_POWER_ON       0x5
+#define AR_CFG_LED_MODE_NETWORK_OFF    0x4
+#define AR_CFG_LED_MODE_NETWORK_ON     0x6
+#define AR_CFG_LED_ASSOC_CTL           0x00000c00
+#define AR_CFG_LED_ASSOC_CTL_S         10
+#define AR_CFG_LED_ASSOC_NONE          0x0
+#define AR_CFG_LED_ASSOC_ACTIVE        0x1
+#define AR_CFG_LED_ASSOC_PENDING       0x2
+
+#define AR_CFG_LED_BLINK_SLOW          0x00000008
+#define AR_CFG_LED_BLINK_SLOW_S        3
+
+#define AR_CFG_LED_BLINK_THRESH_SEL    0x00000070
+#define AR_CFG_LED_BLINK_THRESH_SEL_S  4
+
+#define AR_MAC_SLEEP                0x1f00
+#define AR_MAC_SLEEP_MAC_AWAKE      0x00000000
+#define AR_MAC_SLEEP_MAC_ASLEEP     0x00000001
+
+#define AR_RC                0x4000
+#define AR_RC_AHB            0x00000001
+#define AR_RC_APB            0x00000002
+#define AR_RC_HOSTIF         0x00000100
+
+#define AR_WA                		0x4004
+#define AR9285_WA_DEFAULT 		0x004a05cb
+#define AR9280_WA_DEFAULT           	0x0040073f
+#define AR_WA_DEFAULT               	0x0000073f
+
+
+#define AR_PM_STATE                 0x4008
+#define AR_PM_STATE_PME_D3COLD_VAUX 0x00100000
+
+#define AR_HOST_TIMEOUT             0x4018
+#define AR_HOST_TIMEOUT_APB_CNTR    0x0000FFFF
+#define AR_HOST_TIMEOUT_APB_CNTR_S  0
+#define AR_HOST_TIMEOUT_LCL_CNTR    0xFFFF0000
+#define AR_HOST_TIMEOUT_LCL_CNTR_S  16
+
+#define AR_EEPROM                0x401c
+#define AR_EEPROM_ABSENT         0x00000100
+#define AR_EEPROM_CORRUPT        0x00000200
+#define AR_EEPROM_PROT_MASK      0x03FFFC00
+#define AR_EEPROM_PROT_MASK_S    10
+
+#define EEPROM_PROTECT_RP_0_31        0x0001
+#define EEPROM_PROTECT_WP_0_31        0x0002
+#define EEPROM_PROTECT_RP_32_63       0x0004
+#define EEPROM_PROTECT_WP_32_63       0x0008
+#define EEPROM_PROTECT_RP_64_127      0x0010
+#define EEPROM_PROTECT_WP_64_127      0x0020
+#define EEPROM_PROTECT_RP_128_191     0x0040
+#define EEPROM_PROTECT_WP_128_191     0x0080
+#define EEPROM_PROTECT_RP_192_255     0x0100
+#define EEPROM_PROTECT_WP_192_255     0x0200
+#define EEPROM_PROTECT_RP_256_511     0x0400
+#define EEPROM_PROTECT_WP_256_511     0x0800
+#define EEPROM_PROTECT_RP_512_1023    0x1000
+#define EEPROM_PROTECT_WP_512_1023    0x2000
+#define EEPROM_PROTECT_RP_1024_2047   0x4000
+#define EEPROM_PROTECT_WP_1024_2047   0x8000
+
+#define AR_SREV \
+	((AR_SREV_9100(ah)) ? 0x0600 : 0x4020)
+
+#define AR_SREV_ID \
+	((AR_SREV_9100(ah)) ? 0x00000FFF : 0x000000FF)
+#define AR_SREV_VERSION                       0x000000F0
+#define AR_SREV_VERSION_S                     4
+#define AR_SREV_REVISION                      0x00000007
+
+#define AR_SREV_ID2                           0xFFFFFFFF
+#define AR_SREV_VERSION2        	      0xFFFC0000
+#define AR_SREV_VERSION2_S                    18
+#define AR_SREV_TYPE2        	      	      0x0003F000
+#define AR_SREV_TYPE2_S                       12
+#define AR_SREV_TYPE2_CHAIN		      0x00001000
+#define AR_SREV_TYPE2_HOST_MODE		      0x00002000
+#define AR_SREV_REVISION2        	      0x00000F00
+#define AR_SREV_REVISION2_S     	      8
+
+#define AR_SREV_VERSION_5416_PCI               0xD
+#define AR_SREV_VERSION_5416_PCIE              0xC
+#define AR_SREV_REVISION_5416_10               0
+#define AR_SREV_REVISION_5416_20               1
+#define AR_SREV_REVISION_5416_22               2
+#define AR_SREV_VERSION_9100                  0x14
+#define AR_SREV_VERSION_9160        	      0x40
+#define AR_SREV_REVISION_9160_10    	      0
+#define AR_SREV_REVISION_9160_11    	      1
+#define AR_SREV_VERSION_9280                0x80
+#define AR_SREV_REVISION_9280_10            0
+#define AR_SREV_REVISION_9280_20            1
+#define AR_SREV_REVISION_9280_21            2
+#define AR_SREV_VERSION_9285                  0xC0
+#define AR_SREV_REVISION_9285_10              0
+#define AR_SREV_REVISION_9285_11              1
+#define AR_SREV_REVISION_9285_12              2
+#define AR_SREV_VERSION_9287                  0x180
+#define AR_SREV_REVISION_9287_10              0
+#define AR_SREV_REVISION_9287_11              1
+#define AR_SREV_REVISION_9287_12              2
+#define AR_SREV_VERSION_9271			0x140
+#define AR_SREV_REVISION_9271_10		0
+#define AR_SREV_REVISION_9271_11		1
+
+#define AR_SREV_5416(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
+	 ((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE))
+#define AR_SREV_5416_20_OR_LATER(_ah) \
+	(((AR_SREV_5416(_ah)) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_20)) || \
+	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
+#define AR_SREV_5416_22_OR_LATER(_ah) \
+	(((AR_SREV_5416(_ah)) && \
+	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_5416_22)) || \
+	 ((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
+
+#define AR_SREV_9100(ah) \
+	((ah->hw_version.macVersion) == AR_SREV_VERSION_9100)
+#define AR_SREV_9100_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9100))
+
+#define AR_SREV_9160(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9160))
+#define AR_SREV_9160_10_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9160))
+#define AR_SREV_9160_11(_ah) \
+	(AR_SREV_9160(_ah) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9160_11))
+#define AR_SREV_9280(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280))
+#define AR_SREV_9280_10_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9280))
+#define AR_SREV_9280_20(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
+		((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20))
+#define AR_SREV_9280_20_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9280) || \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9280) && \
+	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9280_20)))
+
+#define AR_SREV_9285(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9285))
+#define AR_SREV_9285_10_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9285))
+#define AR_SREV_9285_11(_ah) \
+	(AR_SREV_9285(ah) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_11))
+#define AR_SREV_9285_11_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
+	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
+			       AR_SREV_REVISION_9285_11)))
+#define AR_SREV_9285_12(_ah) \
+	(AR_SREV_9285(ah) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9285_12))
+#define AR_SREV_9285_12_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9285) || \
+	 (AR_SREV_9285(ah) && ((_ah)->hw_version.macRev >= \
+			       AR_SREV_REVISION_9285_12)))
+
+#define AR_SREV_9287(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287))
+#define AR_SREV_9287_10_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9287))
+#define AR_SREV_9287_10(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_10))
+#define AR_SREV_9287_11(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_11))
+#define AR_SREV_9287_11_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_11)))
+#define AR_SREV_9287_12(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9287_12))
+#define AR_SREV_9287_12_OR_LATER(_ah) \
+	(((_ah)->hw_version.macVersion > AR_SREV_VERSION_9287) || \
+	 (((_ah)->hw_version.macVersion == AR_SREV_VERSION_9287) && \
+	  ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9287_12)))
+#define AR_SREV_9271(_ah) \
+    (((_ah))->hw_version.macVersion == AR_SREV_VERSION_9271)
+#define AR_SREV_9271_10(_ah) \
+    (AR_SREV_9271(_ah) && \
+     ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_10))
+#define AR_SREV_9271_11(_ah) \
+    (AR_SREV_9271(_ah) && \
+     ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_11))
+
+#define AR_RADIO_SREV_MAJOR                   0xf0
+#define AR_RAD5133_SREV_MAJOR                 0xc0
+#define AR_RAD2133_SREV_MAJOR                 0xd0
+#define AR_RAD5122_SREV_MAJOR                 0xe0
+#define AR_RAD2122_SREV_MAJOR                 0xf0
+
+#define AR_AHB_MODE                           0x4024
+#define AR_AHB_EXACT_WR_EN                    0x00000000
+#define AR_AHB_BUF_WR_EN                      0x00000001
+#define AR_AHB_EXACT_RD_EN                    0x00000000
+#define AR_AHB_CACHELINE_RD_EN                0x00000002
+#define AR_AHB_PREFETCH_RD_EN                 0x00000004
+#define AR_AHB_PAGE_SIZE_1K                   0x00000000
+#define AR_AHB_PAGE_SIZE_2K                   0x00000008
+#define AR_AHB_PAGE_SIZE_4K                   0x00000010
+#define AR_AHB_CUSTOM_BURST_EN                0x000000C0
+#define AR_AHB_CUSTOM_BURST_EN_S              6
+#define AR_AHB_CUSTOM_BURST_ASYNC_FIFO_VAL    3
+
+#define AR_INTR_RTC_IRQ                       0x00000001
+#define AR_INTR_MAC_IRQ                       0x00000002
+#define AR_INTR_EEP_PROT_ACCESS               0x00000004
+#define AR_INTR_MAC_AWAKE                     0x00020000
+#define AR_INTR_MAC_ASLEEP                    0x00040000
+#define AR_INTR_SPURIOUS                      0xFFFFFFFF
+
+
+#define AR_INTR_SYNC_CAUSE_CLR                0x4028
+
+#define AR_INTR_SYNC_CAUSE                    0x4028
+
+#define AR_INTR_SYNC_ENABLE                   0x402c
+#define AR_INTR_SYNC_ENABLE_GPIO              0xFFFC0000
+#define AR_INTR_SYNC_ENABLE_GPIO_S            18
+
+enum {
+	AR_INTR_SYNC_RTC_IRQ = 0x00000001,
+	AR_INTR_SYNC_MAC_IRQ = 0x00000002,
+	AR_INTR_SYNC_EEPROM_ILLEGAL_ACCESS = 0x00000004,
+	AR_INTR_SYNC_APB_TIMEOUT = 0x00000008,
+	AR_INTR_SYNC_PCI_MODE_CONFLICT = 0x00000010,
+	AR_INTR_SYNC_HOST1_FATAL = 0x00000020,
+	AR_INTR_SYNC_HOST1_PERR = 0x00000040,
+	AR_INTR_SYNC_TRCV_FIFO_PERR = 0x00000080,
+	AR_INTR_SYNC_RADM_CPL_EP = 0x00000100,
+	AR_INTR_SYNC_RADM_CPL_DLLP_ABORT = 0x00000200,
+	AR_INTR_SYNC_RADM_CPL_TLP_ABORT = 0x00000400,
+	AR_INTR_SYNC_RADM_CPL_ECRC_ERR = 0x00000800,
+	AR_INTR_SYNC_RADM_CPL_TIMEOUT = 0x00001000,
+	AR_INTR_SYNC_LOCAL_TIMEOUT = 0x00002000,
+	AR_INTR_SYNC_PM_ACCESS = 0x00004000,
+	AR_INTR_SYNC_MAC_AWAKE = 0x00008000,
+	AR_INTR_SYNC_MAC_ASLEEP = 0x00010000,
+	AR_INTR_SYNC_MAC_SLEEP_ACCESS = 0x00020000,
+	AR_INTR_SYNC_ALL = 0x0003FFFF,
+
+
+	AR_INTR_SYNC_DEFAULT = (AR_INTR_SYNC_HOST1_FATAL |
+				AR_INTR_SYNC_HOST1_PERR |
+				AR_INTR_SYNC_RADM_CPL_EP |
+				AR_INTR_SYNC_RADM_CPL_DLLP_ABORT |
+				AR_INTR_SYNC_RADM_CPL_TLP_ABORT |
+				AR_INTR_SYNC_RADM_CPL_ECRC_ERR |
+				AR_INTR_SYNC_RADM_CPL_TIMEOUT |
+				AR_INTR_SYNC_LOCAL_TIMEOUT |
+				AR_INTR_SYNC_MAC_SLEEP_ACCESS),
+
+	AR_INTR_SYNC_SPURIOUS = 0xFFFFFFFF,
+
+};
+
+#define AR_INTR_ASYNC_MASK                       0x4030
+#define AR_INTR_ASYNC_MASK_GPIO                  0xFFFC0000
+#define AR_INTR_ASYNC_MASK_GPIO_S                18
+
+#define AR_INTR_SYNC_MASK                        0x4034
+#define AR_INTR_SYNC_MASK_GPIO                   0xFFFC0000
+#define AR_INTR_SYNC_MASK_GPIO_S                 18
+
+#define AR_INTR_ASYNC_CAUSE_CLR                  0x4038
+#define AR_INTR_ASYNC_CAUSE                      0x4038
+
+#define AR_INTR_ASYNC_ENABLE                     0x403c
+#define AR_INTR_ASYNC_ENABLE_GPIO                0xFFFC0000
+#define AR_INTR_ASYNC_ENABLE_GPIO_S              18
+
+#define AR_PCIE_SERDES                           0x4040
+#define AR_PCIE_SERDES2                          0x4044
+#define AR_PCIE_PM_CTRL                          0x4014
+#define AR_PCIE_PM_CTRL_ENA                      0x00080000
+
+#define AR_NUM_GPIO                              14
+#define AR928X_NUM_GPIO                          10
+#define AR9285_NUM_GPIO                          12
+#define AR9287_NUM_GPIO                          11
+
+#define AR_GPIO_IN_OUT                           0x4048
+#define AR_GPIO_IN_VAL                           0x0FFFC000
+#define AR_GPIO_IN_VAL_S                         14
+#define AR928X_GPIO_IN_VAL                       0x000FFC00
+#define AR928X_GPIO_IN_VAL_S                     10
+#define AR9285_GPIO_IN_VAL                       0x00FFF000
+#define AR9285_GPIO_IN_VAL_S                     12
+#define AR9287_GPIO_IN_VAL                       0x003FF800
+#define AR9287_GPIO_IN_VAL_S                     11
+
+#define AR_GPIO_OE_OUT                           0x404c
+#define AR_GPIO_OE_OUT_DRV                       0x3
+#define AR_GPIO_OE_OUT_DRV_NO                    0x0
+#define AR_GPIO_OE_OUT_DRV_LOW                   0x1
+#define AR_GPIO_OE_OUT_DRV_HI                    0x2
+#define AR_GPIO_OE_OUT_DRV_ALL                   0x3
+
+#define AR_GPIO_INTR_POL                         0x4050
+#define AR_GPIO_INTR_POL_VAL                     0x00001FFF
+#define AR_GPIO_INTR_POL_VAL_S                   0
+
+#define AR_GPIO_INPUT_EN_VAL                     0x4054
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_DEF     0x00000004
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_S       2
+#define AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_DEF    0x00000008
+#define AR_GPIO_INPUT_EN_VAL_BT_FREQUENCY_S      3
+#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_DEF       0x00000010
+#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_S         4
+#define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF        0x00000080
+#define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF_S      7
+#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB        0x00001000
+#define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB_S      12
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB      0x00001000
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB_S    1
+#define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB         0x00008000
+#define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB_S       15
+#define AR_GPIO_RTC_RESET_OVERRIDE_ENABLE        0x00010000
+#define AR_GPIO_JTAG_DISABLE                     0x00020000
+
+#define AR_GPIO_INPUT_MUX1                       0x4058
+#define AR_GPIO_INPUT_MUX1_BT_ACTIVE             0x000f0000
+#define AR_GPIO_INPUT_MUX1_BT_ACTIVE_S           16
+#define AR_GPIO_INPUT_MUX1_BT_PRIORITY           0x00000f00
+#define AR_GPIO_INPUT_MUX1_BT_PRIORITY_S         8
+
+#define AR_GPIO_INPUT_MUX2                       0x405c
+#define AR_GPIO_INPUT_MUX2_CLK25                 0x0000000f
+#define AR_GPIO_INPUT_MUX2_CLK25_S               0
+#define AR_GPIO_INPUT_MUX2_RFSILENT              0x000000f0
+#define AR_GPIO_INPUT_MUX2_RFSILENT_S            4
+#define AR_GPIO_INPUT_MUX2_RTC_RESET             0x00000f00
+#define AR_GPIO_INPUT_MUX2_RTC_RESET_S           8
+
+#define AR_GPIO_OUTPUT_MUX1                      0x4060
+#define AR_GPIO_OUTPUT_MUX2                      0x4064
+#define AR_GPIO_OUTPUT_MUX3                      0x4068
+
+#define AR_INPUT_STATE                           0x406c
+
+#define AR_EEPROM_STATUS_DATA                    0x407c
+#define AR_EEPROM_STATUS_DATA_VAL                0x0000ffff
+#define AR_EEPROM_STATUS_DATA_VAL_S              0
+#define AR_EEPROM_STATUS_DATA_BUSY               0x00010000
+#define AR_EEPROM_STATUS_DATA_BUSY_ACCESS        0x00020000
+#define AR_EEPROM_STATUS_DATA_PROT_ACCESS        0x00040000
+#define AR_EEPROM_STATUS_DATA_ABSENT_ACCESS      0x00080000
+
+#define AR_OBS                  0x4080
+
+#define AR_GPIO_PDPU                             0x4088
+
+#define AR_PCIE_MSI                              0x4094
+#define AR_PCIE_MSI_ENABLE                       0x00000001
+
+
+#define AR_RTC_9160_PLL_DIV	0x000003ff
+#define AR_RTC_9160_PLL_DIV_S   0
+#define AR_RTC_9160_PLL_REFDIV  0x00003C00
+#define AR_RTC_9160_PLL_REFDIV_S 10
+#define AR_RTC_9160_PLL_CLKSEL	0x0000C000
+#define AR_RTC_9160_PLL_CLKSEL_S 14
+
+#define AR_RTC_BASE             0x00020000
+#define AR_RTC_RC \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0000) : 0x7000)
+#define AR_RTC_RC_M		0x00000003
+#define AR_RTC_RC_MAC_WARM      0x00000001
+#define AR_RTC_RC_MAC_COLD      0x00000002
+#define AR_RTC_RC_COLD_RESET    0x00000004
+#define AR_RTC_RC_WARM_RESET    0x00000008
+
+#define AR_RTC_PLL_CONTROL \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0014) : 0x7014)
+
+#define AR_RTC_PLL_DIV          0x0000001f
+#define AR_RTC_PLL_DIV_S        0
+#define AR_RTC_PLL_DIV2         0x00000020
+#define AR_RTC_PLL_REFDIV_5     0x000000c0
+#define AR_RTC_PLL_CLKSEL       0x00000300
+#define AR_RTC_PLL_CLKSEL_S     8
+
+#define AR_RTC_RESET \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0040) : 0x7040)
+#define AR_RTC_RESET_EN		(0x00000001)
+
+#define AR_RTC_STATUS \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0044) : 0x7044)
+
+#define AR_RTC_STATUS_M \
+	((AR_SREV_9100(ah)) ? 0x0000003f : 0x0000000f)
+
+#define AR_RTC_PM_STATUS_M      0x0000000f
+
+#define AR_RTC_STATUS_SHUTDOWN  0x00000001
+#define AR_RTC_STATUS_ON        0x00000002
+#define AR_RTC_STATUS_SLEEP     0x00000004
+#define AR_RTC_STATUS_WAKEUP    0x00000008
+
+#define AR_RTC_SLEEP_CLK \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0048) : 0x7048)
+#define AR_RTC_FORCE_DERIVED_CLK    0x2
+
+#define AR_RTC_FORCE_WAKE \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x004c) : 0x704c)
+#define AR_RTC_FORCE_WAKE_EN        0x00000001
+#define AR_RTC_FORCE_WAKE_ON_INT    0x00000002
+
+
+#define AR_RTC_INTR_CAUSE \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0050) : 0x7050)
+
+#define AR_RTC_INTR_ENABLE \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0054) : 0x7054)
+
+#define AR_RTC_INTR_MASK \
+	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0058) : 0x7058)
+
+/* RTC_DERIVED_* - only for AR9100 */
+
+#define AR_RTC_DERIVED_CLK           (AR_RTC_BASE + 0x0038)
+#define AR_RTC_DERIVED_CLK_PERIOD    0x0000fffe
+#define AR_RTC_DERIVED_CLK_PERIOD_S  1
+
+#define	AR_SEQ_MASK	0x8060
+
+#define AR_AN_RF2G1_CH0         0x7810
+#define AR_AN_RF2G1_CH0_OB      0x03800000
+#define AR_AN_RF2G1_CH0_OB_S    23
+#define AR_AN_RF2G1_CH0_DB      0x1C000000
+#define AR_AN_RF2G1_CH0_DB_S    26
+
+#define AR_AN_RF5G1_CH0         0x7818
+#define AR_AN_RF5G1_CH0_OB5     0x00070000
+#define AR_AN_RF5G1_CH0_OB5_S   16
+#define AR_AN_RF5G1_CH0_DB5     0x00380000
+#define AR_AN_RF5G1_CH0_DB5_S   19
+
+#define AR_AN_RF2G1_CH1         0x7834
+#define AR_AN_RF2G1_CH1_OB      0x03800000
+#define AR_AN_RF2G1_CH1_OB_S    23
+#define AR_AN_RF2G1_CH1_DB      0x1C000000
+#define AR_AN_RF2G1_CH1_DB_S    26
+
+#define AR_AN_RF5G1_CH1         0x783C
+#define AR_AN_RF5G1_CH1_OB5     0x00070000
+#define AR_AN_RF5G1_CH1_OB5_S   16
+#define AR_AN_RF5G1_CH1_DB5     0x00380000
+#define AR_AN_RF5G1_CH1_DB5_S   19
+
+#define AR_AN_TOP1                  0x7890
+#define AR_AN_TOP1_DACIPMODE	    0x00040000
+#define AR_AN_TOP1_DACIPMODE_S	    18
+
+#define AR_AN_TOP2                  0x7894
+#define AR_AN_TOP2_XPABIAS_LVL      0xC0000000
+#define AR_AN_TOP2_XPABIAS_LVL_S    30
+#define AR_AN_TOP2_LOCALBIAS        0x00200000
+#define AR_AN_TOP2_LOCALBIAS_S      21
+#define AR_AN_TOP2_PWDCLKIND        0x00400000
+#define AR_AN_TOP2_PWDCLKIND_S      22
+
+#define AR_AN_SYNTH9            0x7868
+#define AR_AN_SYNTH9_REFDIVA    0xf8000000
+#define AR_AN_SYNTH9_REFDIVA_S  27
+
+#define AR9285_AN_RF2G1              0x7820
+#define AR9285_AN_RF2G1_ENPACAL      0x00000800
+#define AR9285_AN_RF2G1_ENPACAL_S    11
+#define AR9285_AN_RF2G1_PDPADRV1     0x02000000
+#define AR9285_AN_RF2G1_PDPADRV1_S   25
+#define AR9285_AN_RF2G1_PDPADRV2     0x01000000
+#define AR9285_AN_RF2G1_PDPADRV2_S   24
+#define AR9285_AN_RF2G1_PDPAOUT      0x00800000
+#define AR9285_AN_RF2G1_PDPAOUT_S    23
+
+
+#define AR9285_AN_RF2G2              0x7824
+#define AR9285_AN_RF2G2_OFFCAL       0x00001000
+#define AR9285_AN_RF2G2_OFFCAL_S     12
+
+#define AR9285_AN_RF2G3             0x7828
+#define AR9285_AN_RF2G3_PDVCCOMP    0x02000000
+#define AR9285_AN_RF2G3_PDVCCOMP_S  25
+#define AR9285_AN_RF2G3_OB_0    0x00E00000
+#define AR9285_AN_RF2G3_OB_0_S    21
+#define AR9285_AN_RF2G3_OB_1    0x001C0000
+#define AR9285_AN_RF2G3_OB_1_S    18
+#define AR9285_AN_RF2G3_OB_2    0x00038000
+#define AR9285_AN_RF2G3_OB_2_S    15
+#define AR9285_AN_RF2G3_OB_3    0x00007000
+#define AR9285_AN_RF2G3_OB_3_S    12
+#define AR9285_AN_RF2G3_OB_4    0x00000E00
+#define AR9285_AN_RF2G3_OB_4_S    9
+
+#define AR9285_AN_RF2G3_DB1_0    0x000001C0
+#define AR9285_AN_RF2G3_DB1_0_S    6
+#define AR9285_AN_RF2G3_DB1_1    0x00000038
+#define AR9285_AN_RF2G3_DB1_1_S    3
+#define AR9285_AN_RF2G3_DB1_2    0x00000007
+#define AR9285_AN_RF2G3_DB1_2_S    0
+#define AR9285_AN_RF2G4         0x782C
+#define AR9285_AN_RF2G4_DB1_3    0xE0000000
+#define AR9285_AN_RF2G4_DB1_3_S    29
+#define AR9285_AN_RF2G4_DB1_4    0x1C000000
+#define AR9285_AN_RF2G4_DB1_4_S    26
+
+#define AR9285_AN_RF2G4_DB2_0    0x03800000
+#define AR9285_AN_RF2G4_DB2_0_S    23
+#define AR9285_AN_RF2G4_DB2_1    0x00700000
+#define AR9285_AN_RF2G4_DB2_1_S    20
+#define AR9285_AN_RF2G4_DB2_2    0x000E0000
+#define AR9285_AN_RF2G4_DB2_2_S    17
+#define AR9285_AN_RF2G4_DB2_3    0x0001C000
+#define AR9285_AN_RF2G4_DB2_3_S    14
+#define AR9285_AN_RF2G4_DB2_4    0x00003800
+#define AR9285_AN_RF2G4_DB2_4_S    11
+
+/* AR9271 : 0x7828, 0x782c different setting from AR9285 */
+#define AR9271_AN_RF2G3_OB_cck		0x001C0000
+#define AR9271_AN_RF2G3_OB_cck_S	18
+#define AR9271_AN_RF2G3_OB_psk		0x00038000
+#define AR9271_AN_RF2G3_OB_psk_S	15
+#define AR9271_AN_RF2G3_OB_qam		0x00007000
+#define AR9271_AN_RF2G3_OB_qam_S	12
+
+#define AR9271_AN_RF2G3_DB_1		0x00E00000
+#define AR9271_AN_RF2G3_DB_1_S		21
+
+#define AR9271_AN_RF2G3_CCOMP		0xFFF
+#define AR9271_AN_RF2G3_CCOMP_S		0
+
+#define AR9271_AN_RF2G4_DB_2		0xE0000000
+#define AR9271_AN_RF2G4_DB_2_S		29
+
+#define AR9285_AN_RF2G6                 0x7834
+#define AR9285_AN_RF2G6_CCOMP           0x00007800
+#define AR9285_AN_RF2G6_CCOMP_S         11
+#define AR9285_AN_RF2G6_OFFS            0x03f00000
+#define AR9285_AN_RF2G6_OFFS_S          20
+
+#define AR9271_AN_RF2G6_OFFS            0x07f00000
+#define AR9271_AN_RF2G6_OFFS_S            20
+
+#define AR9285_AN_RF2G7                 0x7838
+#define AR9285_AN_RF2G7_PWDDB           0x00000002
+#define AR9285_AN_RF2G7_PWDDB_S         1
+#define AR9285_AN_RF2G7_PADRVGN2TAB0    0xE0000000
+#define AR9285_AN_RF2G7_PADRVGN2TAB0_S  29
+
+#define AR9285_AN_RF2G8                  0x783C
+#define AR9285_AN_RF2G8_PADRVGN2TAB0     0x0001C000
+#define AR9285_AN_RF2G8_PADRVGN2TAB0_S   14
+
+
+#define AR9285_AN_RF2G9          0x7840
+#define AR9285_AN_RXTXBB1              0x7854
+#define AR9285_AN_RXTXBB1_PDRXTXBB1    0x00000020
+#define AR9285_AN_RXTXBB1_PDRXTXBB1_S  5
+#define AR9285_AN_RXTXBB1_PDV2I        0x00000080
+#define AR9285_AN_RXTXBB1_PDV2I_S      7
+#define AR9285_AN_RXTXBB1_PDDACIF      0x00000100
+#define AR9285_AN_RXTXBB1_PDDACIF_S    8
+#define AR9285_AN_RXTXBB1_SPARE9       0x00000001
+#define AR9285_AN_RXTXBB1_SPARE9_S     0
+
+#define AR9285_AN_TOP2           0x7868
+
+#define AR9285_AN_TOP3                  0x786c
+#define AR9285_AN_TOP3_XPABIAS_LVL      0x0000000C
+#define AR9285_AN_TOP3_XPABIAS_LVL_S    2
+#define AR9285_AN_TOP3_PWDDAC           0x00800000
+#define AR9285_AN_TOP3_PWDDAC_S    23
+
+#define AR9285_AN_TOP4           0x7870
+#define AR9285_AN_TOP4_DEFAULT   0x10142c00
+
+#define AR9287_AN_RF2G3_CH0             0x7808
+#define AR9287_AN_RF2G3_CH1             0x785c
+#define AR9287_AN_RF2G3_DB1             0xE0000000
+#define AR9287_AN_RF2G3_DB1_S           29
+#define AR9287_AN_RF2G3_DB2             0x1C000000
+#define AR9287_AN_RF2G3_DB2_S           26
+#define AR9287_AN_RF2G3_OB_CCK          0x03800000
+#define AR9287_AN_RF2G3_OB_CCK_S        23
+#define AR9287_AN_RF2G3_OB_PSK          0x00700000
+#define AR9287_AN_RF2G3_OB_PSK_S        20
+#define AR9287_AN_RF2G3_OB_QAM          0x000E0000
+#define AR9287_AN_RF2G3_OB_QAM_S        17
+#define AR9287_AN_RF2G3_OB_PAL_OFF      0x0001C000
+#define AR9287_AN_RF2G3_OB_PAL_OFF_S    14
+
+#define AR9287_AN_TXPC0                 0x7898
+#define AR9287_AN_TXPC0_TXPCMODE        0x0000C000
+#define AR9287_AN_TXPC0_TXPCMODE_S      14
+#define AR9287_AN_TXPC0_TXPCMODE_NORMAL    0
+#define AR9287_AN_TXPC0_TXPCMODE_TEST      1
+#define AR9287_AN_TXPC0_TXPCMODE_TEMPSENSE 2
+#define AR9287_AN_TXPC0_TXPCMODE_ATBTEST   3
+
+#define AR9287_AN_TOP2                  0x78b4
+#define AR9287_AN_TOP2_XPABIAS_LVL      0xC0000000
+#define AR9287_AN_TOP2_XPABIAS_LVL_S    30
+
+/* AR9271 specific stuff */
+#define AR9271_RESET_POWER_DOWN_CONTROL		0x50044
+#define AR9271_RADIO_RF_RST			0x20
+#define AR9271_GATE_MAC_CTL			0x4000
+
+#define AR_STA_ID0                 0x8000
+#define AR_STA_ID1                 0x8004
+#define AR_STA_ID1_SADH_MASK       0x0000FFFF
+#define AR_STA_ID1_STA_AP          0x00010000
+#define AR_STA_ID1_ADHOC           0x00020000
+#define AR_STA_ID1_PWR_SAV         0x00040000
+#define AR_STA_ID1_KSRCHDIS        0x00080000
+#define AR_STA_ID1_PCF             0x00100000
+#define AR_STA_ID1_USE_DEFANT      0x00200000
+#define AR_STA_ID1_DEFANT_UPDATE   0x00400000
+#define AR_STA_ID1_RTS_USE_DEF     0x00800000
+#define AR_STA_ID1_ACKCTS_6MB      0x01000000
+#define AR_STA_ID1_BASE_RATE_11B   0x02000000
+#define AR_STA_ID1_SECTOR_SELF_GEN 0x04000000
+#define AR_STA_ID1_CRPT_MIC_ENABLE 0x08000000
+#define AR_STA_ID1_KSRCH_MODE      0x10000000
+#define AR_STA_ID1_PRESERVE_SEQNUM 0x20000000
+#define AR_STA_ID1_CBCIV_ENDIAN    0x40000000
+#define AR_STA_ID1_MCAST_KSRCH     0x80000000
+
+#define AR_BSS_ID0          0x8008
+#define AR_BSS_ID1          0x800C
+#define AR_BSS_ID1_U16       0x0000FFFF
+#define AR_BSS_ID1_AID       0x07FF0000
+#define AR_BSS_ID1_AID_S     16
+
+#define AR_BCN_RSSI_AVE      0x8010
+#define AR_BCN_RSSI_AVE_MASK 0x00000FFF
+
+#define AR_TIME_OUT         0x8014
+#define AR_TIME_OUT_ACK      0x00003FFF
+#define AR_TIME_OUT_ACK_S    0
+#define AR_TIME_OUT_CTS      0x3FFF0000
+#define AR_TIME_OUT_CTS_S    16
+#define AR_TIME_OUT_ACK_CTS_ASYNC_FIFO_DUR    0x16001D56
+
+#define AR_RSSI_THR          0x8018
+#define AR_RSSI_THR_MASK     0x000000FF
+#define AR_RSSI_THR_BM_THR   0x0000FF00
+#define AR_RSSI_THR_BM_THR_S 8
+#define AR_RSSI_BCN_WEIGHT   0x1F000000
+#define AR_RSSI_BCN_WEIGHT_S 24
+#define AR_RSSI_BCN_RSSI_RST 0x20000000
+
+#define AR_USEC              0x801c
+#define AR_USEC_USEC         0x0000007F
+#define AR_USEC_TX_LAT       0x007FC000
+#define AR_USEC_TX_LAT_S     14
+#define AR_USEC_RX_LAT       0x1F800000
+#define AR_USEC_RX_LAT_S     23
+#define AR_USEC_ASYNC_FIFO_DUR    0x12e00074
+
+#define AR_RESET_TSF        0x8020
+#define AR_RESET_TSF_ONCE   0x01000000
+
+#define AR_MAX_CFP_DUR      0x8038
+#define AR_CFP_VAL          0x0000FFFF
+
+#define AR_RX_FILTER        0x803C
+
+#define AR_MCAST_FIL0       0x8040
+#define AR_MCAST_FIL1       0x8044
+
+#define AR_DIAG_SW                  0x8048
+#define AR_DIAG_CACHE_ACK           0x00000001
+#define AR_DIAG_ACK_DIS             0x00000002
+#define AR_DIAG_CTS_DIS             0x00000004
+#define AR_DIAG_ENCRYPT_DIS         0x00000008
+#define AR_DIAG_DECRYPT_DIS         0x00000010
+#define AR_DIAG_RX_DIS              0x00000020
+#define AR_DIAG_LOOP_BACK           0x00000040
+#define AR_DIAG_CORR_FCS            0x00000080
+#define AR_DIAG_CHAN_INFO           0x00000100
+#define AR_DIAG_SCRAM_SEED          0x0001FE00
+#define AR_DIAG_SCRAM_SEED_S        8
+#define AR_DIAG_FRAME_NV0           0x00020000
+#define AR_DIAG_OBS_PT_SEL1         0x000C0000
+#define AR_DIAG_OBS_PT_SEL1_S       18
+#define AR_DIAG_FORCE_RX_CLEAR      0x00100000
+#define AR_DIAG_IGNORE_VIRT_CS      0x00200000
+#define AR_DIAG_FORCE_CH_IDLE_HIGH  0x00400000
+#define AR_DIAG_EIFS_CTRL_ENA       0x00800000
+#define AR_DIAG_DUAL_CHAIN_INFO     0x01000000
+#define AR_DIAG_RX_ABORT            0x02000000
+#define AR_DIAG_SATURATE_CYCLE_CNT  0x04000000
+#define AR_DIAG_OBS_PT_SEL2         0x08000000
+#define AR_DIAG_RX_CLEAR_CTL_LOW    0x10000000
+#define AR_DIAG_RX_CLEAR_EXT_LOW    0x20000000
+
+#define AR_TSF_L32          0x804c
+#define AR_TSF_U32          0x8050
+
+#define AR_TST_ADDAC        0x8054
+#define AR_DEF_ANTENNA      0x8058
+
+#define AR_AES_MUTE_MASK0       0x805c
+#define AR_AES_MUTE_MASK0_FC    0x0000FFFF
+#define AR_AES_MUTE_MASK0_QOS   0xFFFF0000
+#define AR_AES_MUTE_MASK0_QOS_S 16
+
+#define AR_AES_MUTE_MASK1       0x8060
+#define AR_AES_MUTE_MASK1_SEQ   0x0000FFFF
+#define AR_AES_MUTE_MASK1_FC_MGMT 0xFFFF0000
+#define AR_AES_MUTE_MASK1_FC_MGMT_S 16
+
+#define AR_GATED_CLKS       0x8064
+#define AR_GATED_CLKS_TX    0x00000002
+#define AR_GATED_CLKS_RX    0x00000004
+#define AR_GATED_CLKS_REG   0x00000008
+
+#define AR_OBS_BUS_CTRL     0x8068
+#define AR_OBS_BUS_SEL_1    0x00040000
+#define AR_OBS_BUS_SEL_2    0x00080000
+#define AR_OBS_BUS_SEL_3    0x000C0000
+#define AR_OBS_BUS_SEL_4    0x08040000
+#define AR_OBS_BUS_SEL_5    0x08080000
+
+#define AR_OBS_BUS_1               0x806c
+#define AR_OBS_BUS_1_PCU           0x00000001
+#define AR_OBS_BUS_1_RX_END        0x00000002
+#define AR_OBS_BUS_1_RX_WEP        0x00000004
+#define AR_OBS_BUS_1_RX_BEACON     0x00000008
+#define AR_OBS_BUS_1_RX_FILTER     0x00000010
+#define AR_OBS_BUS_1_TX_HCF        0x00000020
+#define AR_OBS_BUS_1_QUIET_TIME    0x00000040
+#define AR_OBS_BUS_1_CHAN_IDLE     0x00000080
+#define AR_OBS_BUS_1_TX_HOLD       0x00000100
+#define AR_OBS_BUS_1_TX_FRAME      0x00000200
+#define AR_OBS_BUS_1_RX_FRAME      0x00000400
+#define AR_OBS_BUS_1_RX_CLEAR      0x00000800
+#define AR_OBS_BUS_1_WEP_STATE     0x0003F000
+#define AR_OBS_BUS_1_WEP_STATE_S   12
+#define AR_OBS_BUS_1_RX_STATE      0x01F00000
+#define AR_OBS_BUS_1_RX_STATE_S    20
+#define AR_OBS_BUS_1_TX_STATE      0x7E000000
+#define AR_OBS_BUS_1_TX_STATE_S    25
+
+#define AR_LAST_TSTP        0x8080
+#define AR_NAV              0x8084
+#define AR_RTS_OK           0x8088
+#define AR_RTS_FAIL         0x808c
+#define AR_ACK_FAIL         0x8090
+#define AR_FCS_FAIL         0x8094
+#define AR_BEACON_CNT       0x8098
+
+#define AR_SLEEP1               0x80d4
+#define AR_SLEEP1_ASSUME_DTIM   0x00080000
+#define AR_SLEEP1_CAB_TIMEOUT   0xFFE00000
+#define AR_SLEEP1_CAB_TIMEOUT_S 21
+
+#define AR_SLEEP2                   0x80d8
+#define AR_SLEEP2_BEACON_TIMEOUT    0xFFE00000
+#define AR_SLEEP2_BEACON_TIMEOUT_S  21
+
+#define AR_TPC                 0x80e8
+#define AR_TPC_ACK             0x0000003f
+#define AR_TPC_ACK_S           0x00
+#define AR_TPC_CTS             0x00003f00
+#define AR_TPC_CTS_S           0x08
+#define AR_TPC_CHIRP           0x003f0000
+#define AR_TPC_CHIRP_S         0x16
+
+#define AR_TFCNT           0x80ec
+#define AR_RFCNT           0x80f0
+#define AR_RCCNT           0x80f4
+#define AR_CCCNT           0x80f8
+
+#define AR_QUIET1          0x80fc
+#define AR_QUIET1_NEXT_QUIET_S         0
+#define AR_QUIET1_NEXT_QUIET_M         0x0000ffff
+#define AR_QUIET1_QUIET_ENABLE         0x00010000
+#define AR_QUIET1_QUIET_ACK_CTS_ENABLE 0x00020000
+#define AR_QUIET1_QUIET_ACK_CTS_ENABLE_S 17
+#define AR_QUIET2          0x8100
+#define AR_QUIET2_QUIET_PERIOD_S       0
+#define AR_QUIET2_QUIET_PERIOD_M       0x0000ffff
+#define AR_QUIET2_QUIET_DUR_S     16
+#define AR_QUIET2_QUIET_DUR       0xffff0000
+
+#define AR_TSF_PARM        0x8104
+#define AR_TSF_INCREMENT_M     0x000000ff
+#define AR_TSF_INCREMENT_S     0x00
+
+#define AR_QOS_NO_ACK              0x8108
+#define AR_QOS_NO_ACK_TWO_BIT      0x0000000f
+#define AR_QOS_NO_ACK_TWO_BIT_S    0
+#define AR_QOS_NO_ACK_BIT_OFF      0x00000070
+#define AR_QOS_NO_ACK_BIT_OFF_S    4
+#define AR_QOS_NO_ACK_BYTE_OFF     0x00000180
+#define AR_QOS_NO_ACK_BYTE_OFF_S   7
+
+#define AR_PHY_ERR         0x810c
+
+#define AR_PHY_ERR_DCHIRP      0x00000008
+#define AR_PHY_ERR_RADAR       0x00000020
+#define AR_PHY_ERR_OFDM_TIMING 0x00020000
+#define AR_PHY_ERR_CCK_TIMING  0x02000000
+
+#define AR_RXFIFO_CFG          0x8114
+
+
+#define AR_MIC_QOS_CONTROL 0x8118
+#define AR_MIC_QOS_SELECT  0x811c
+
+#define AR_PCU_MISC                0x8120
+#define AR_PCU_FORCE_BSSID_MATCH   0x00000001
+#define AR_PCU_MIC_NEW_LOC_ENA     0x00000004
+#define AR_PCU_TX_ADD_TSF          0x00000008
+#define AR_PCU_CCK_SIFS_MODE       0x00000010
+#define AR_PCU_RX_ANT_UPDT         0x00000800
+#define AR_PCU_TXOP_TBTT_LIMIT_ENA 0x00001000
+#define AR_PCU_MISS_BCN_IN_SLEEP   0x00004000
+#define AR_PCU_BUG_12306_FIX_ENA   0x00020000
+#define AR_PCU_FORCE_QUIET_COLL    0x00040000
+#define AR_PCU_TBTT_PROTECT        0x00200000
+#define AR_PCU_CLEAR_VMF           0x01000000
+#define AR_PCU_CLEAR_BA_VALID      0x04000000
+
+#define AR_PCU_BT_ANT_PREVENT_RX   0x00100000
+#define AR_PCU_BT_ANT_PREVENT_RX_S 20
+
+#define AR_FILT_OFDM           0x8124
+#define AR_FILT_OFDM_COUNT     0x00FFFFFF
+
+#define AR_FILT_CCK            0x8128
+#define AR_FILT_CCK_COUNT      0x00FFFFFF
+
+#define AR_PHY_ERR_1           0x812c
+#define AR_PHY_ERR_1_COUNT     0x00FFFFFF
+#define AR_PHY_ERR_MASK_1      0x8130
+
+#define AR_PHY_ERR_2           0x8134
+#define AR_PHY_ERR_2_COUNT     0x00FFFFFF
+#define AR_PHY_ERR_MASK_2      0x8138
+
+#define AR_PHY_COUNTMAX        (3 << 22)
+#define AR_MIBCNT_INTRMASK     (3 << 22)
+
+#define AR_TSFOOR_THRESHOLD       0x813c
+#define AR_TSFOOR_THRESHOLD_VAL   0x0000FFFF
+
+#define AR_PHY_ERR_EIFS_MASK   8144
+
+#define AR_PHY_ERR_3           0x8168
+#define AR_PHY_ERR_3_COUNT     0x00FFFFFF
+#define AR_PHY_ERR_MASK_3      0x816c
+
+#define AR_BT_COEX_MODE            0x8170
+#define AR_BT_TIME_EXTEND          0x000000ff
+#define AR_BT_TIME_EXTEND_S        0
+#define AR_BT_TXSTATE_EXTEND       0x00000100
+#define AR_BT_TXSTATE_EXTEND_S     8
+#define AR_BT_TX_FRAME_EXTEND      0x00000200
+#define AR_BT_TX_FRAME_EXTEND_S    9
+#define AR_BT_MODE                 0x00000c00
+#define AR_BT_MODE_S               10
+#define AR_BT_QUIET                0x00001000
+#define AR_BT_QUIET_S              12
+#define AR_BT_QCU_THRESH           0x0001e000
+#define AR_BT_QCU_THRESH_S         13
+#define AR_BT_RX_CLEAR_POLARITY    0x00020000
+#define AR_BT_RX_CLEAR_POLARITY_S  17
+#define AR_BT_PRIORITY_TIME        0x00fc0000
+#define AR_BT_PRIORITY_TIME_S      18
+#define AR_BT_FIRST_SLOT_TIME      0xff000000
+#define AR_BT_FIRST_SLOT_TIME_S    24
+
+#define AR_BT_COEX_WEIGHT          0x8174
+#define AR_BT_COEX_WGHT		   0xff55
+#define AR_STOMP_ALL_WLAN_WGHT	   0xffcc
+#define AR_STOMP_LOW_WLAN_WGHT	   0xaaa8
+#define AR_STOMP_NONE_WLAN_WGHT	   0xaa00
+#define AR_BTCOEX_BT_WGHT          0x0000ffff
+#define AR_BTCOEX_BT_WGHT_S        0
+#define AR_BTCOEX_WL_WGHT          0xffff0000
+#define AR_BTCOEX_WL_WGHT_S        16
+
+#define AR_BT_COEX_MODE2           0x817c
+#define AR_BT_BCN_MISS_THRESH      0x000000ff
+#define AR_BT_BCN_MISS_THRESH_S    0
+#define AR_BT_BCN_MISS_CNT         0x0000ff00
+#define AR_BT_BCN_MISS_CNT_S       8
+#define AR_BT_HOLD_RX_CLEAR        0x00010000
+#define AR_BT_HOLD_RX_CLEAR_S      16
+#define AR_BT_DISABLE_BT_ANT       0x00100000
+#define AR_BT_DISABLE_BT_ANT_S     20
+
+#define AR_TXSIFS              0x81d0
+#define AR_TXSIFS_TIME         0x000000FF
+#define AR_TXSIFS_TX_LATENCY   0x00000F00
+#define AR_TXSIFS_TX_LATENCY_S 8
+#define AR_TXSIFS_ACK_SHIFT    0x00007000
+#define AR_TXSIFS_ACK_SHIFT_S  12
+
+#define AR_TXOP_X          0x81ec
+#define AR_TXOP_X_VAL      0x000000FF
+
+
+#define AR_TXOP_0_3    0x81f0
+#define AR_TXOP_4_7    0x81f4
+#define AR_TXOP_8_11   0x81f8
+#define AR_TXOP_12_15  0x81fc
+
+#define AR_NEXT_NDP2_TIMER                  0x8180
+#define AR_FIRST_NDP_TIMER                  7
+#define AR_NDP2_PERIOD                      0x81a0
+#define AR_NDP2_TIMER_MODE                  0x81c0
+#define AR_NEXT_TBTT_TIMER                  0x8200
+#define AR_NEXT_DMA_BEACON_ALERT            0x8204
+#define AR_NEXT_SWBA                        0x8208
+#define AR_NEXT_CFP                         0x8208
+#define AR_NEXT_HCF                         0x820C
+#define AR_NEXT_TIM                         0x8210
+#define AR_NEXT_DTIM                        0x8214
+#define AR_NEXT_QUIET_TIMER                 0x8218
+#define AR_NEXT_NDP_TIMER                   0x821C
+
+#define AR_BEACON_PERIOD                    0x8220
+#define AR_DMA_BEACON_PERIOD                0x8224
+#define AR_SWBA_PERIOD                      0x8228
+#define AR_HCF_PERIOD                       0x822C
+#define AR_TIM_PERIOD                       0x8230
+#define AR_DTIM_PERIOD                      0x8234
+#define AR_QUIET_PERIOD                     0x8238
+#define AR_NDP_PERIOD                       0x823C
+
+#define AR_TIMER_MODE                       0x8240
+#define AR_TBTT_TIMER_EN                    0x00000001
+#define AR_DBA_TIMER_EN                     0x00000002
+#define AR_SWBA_TIMER_EN                    0x00000004
+#define AR_HCF_TIMER_EN                     0x00000008
+#define AR_TIM_TIMER_EN                     0x00000010
+#define AR_DTIM_TIMER_EN                    0x00000020
+#define AR_QUIET_TIMER_EN                   0x00000040
+#define AR_NDP_TIMER_EN                     0x00000080
+#define AR_TIMER_OVERFLOW_INDEX             0x00000700
+#define AR_TIMER_OVERFLOW_INDEX_S           8
+#define AR_TIMER_THRESH                     0xFFFFF000
+#define AR_TIMER_THRESH_S                   12
+
+#define AR_SLP32_MODE                  0x8244
+#define AR_SLP32_HALF_CLK_LATENCY      0x000FFFFF
+#define AR_SLP32_ENA                   0x00100000
+#define AR_SLP32_TSF_WRITE_STATUS      0x00200000
+
+#define AR_SLP32_WAKE              0x8248
+#define AR_SLP32_WAKE_XTL_TIME     0x0000FFFF
+
+#define AR_SLP32_INC               0x824c
+#define AR_SLP32_TST_INC           0x000FFFFF
+
+#define AR_SLP_CNT         0x8250
+#define AR_SLP_CYCLE_CNT   0x8254
+
+#define AR_SLP_MIB_CTRL    0x8258
+#define AR_SLP_MIB_CLEAR   0x00000001
+#define AR_SLP_MIB_PENDING 0x00000002
+
+#define AR_MAC_PCU_LOGIC_ANALYZER               0x8264
+#define AR_MAC_PCU_LOGIC_ANALYZER_DISBUG20768   0x20000000
+
+
+#define AR_2040_MODE                0x8318
+#define AR_2040_JOINED_RX_CLEAR 0x00000001
+
+
+#define AR_EXTRCCNT         0x8328
+
+#define AR_SELFGEN_MASK         0x832c
+
+#define AR_PCU_TXBUF_CTRL               0x8340
+#define AR_PCU_TXBUF_CTRL_SIZE_MASK     0x7FF
+#define AR_PCU_TXBUF_CTRL_USABLE_SIZE   0x700
+#define AR_9285_PCU_TXBUF_CTRL_USABLE_SIZE   0x380
+
+#define AR_PCU_MISC_MODE2               0x8344
+#define AR_PCU_MISC_MODE2_MGMT_CRYPTO_ENABLE           0x00000002
+#define AR_PCU_MISC_MODE2_NO_CRYPTO_FOR_NON_DATA_PKT   0x00000004
+
+#define AR_PCU_MISC_MODE2_RESERVED                     0x00000038
+#define AR_PCU_MISC_MODE2_ADHOC_MCAST_KEYID_ENABLE     0x00000040
+#define AR_PCU_MISC_MODE2_CFP_IGNORE                   0x00000080
+#define AR_PCU_MISC_MODE2_MGMT_QOS                     0x0000FF00
+#define AR_PCU_MISC_MODE2_MGMT_QOS_S                   8
+#define AR_PCU_MISC_MODE2_ENABLE_LOAD_NAV_BEACON_DURATION 0x00010000
+#define AR_PCU_MISC_MODE2_ENABLE_AGGWEP                0x00020000
+#define AR_PCU_MISC_MODE2_HWWAR1                       0x00100000
+#define AR_PCU_MISC_MODE2_HWWAR2                       0x02000000
+#define AR_PCU_MISC_MODE2_RESERVED2                    0xFFFE0000
+
+#define AR_MAC_PCU_ASYNC_FIFO_REG3                     0x8358
+#define AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL        0x00000400
+#define AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET          0x80000000
+
+
+#define AR_AES_MUTE_MASK0       0x805c
+#define AR_AES_MUTE_MASK0_FC    0x0000FFFF
+#define AR_AES_MUTE_MASK0_QOS   0xFFFF0000
+#define AR_AES_MUTE_MASK0_QOS_S 16
+
+#define AR_AES_MUTE_MASK1              0x8060
+#define AR_AES_MUTE_MASK1_SEQ          0x0000FFFF
+#define AR_AES_MUTE_MASK1_SEQ_S        0
+#define AR_AES_MUTE_MASK1_FC_MGMT      0xFFFF0000
+#define AR_AES_MUTE_MASK1_FC_MGMT_S    16
+
+#define AR_RATE_DURATION_0      0x8700
+#define AR_RATE_DURATION_31     0x87CC
+#define AR_RATE_DURATION_32     0x8780
+#define AR_RATE_DURATION(_n)    (AR_RATE_DURATION_0 + ((_n)<<2))
+
+
+#define AR_KEYTABLE_0           0x8800
+#define AR_KEYTABLE(_n)         (AR_KEYTABLE_0 + ((_n)*32))
+#define AR_KEY_CACHE_SIZE       128
+#define AR_RSVD_KEYTABLE_ENTRIES 4
+#define AR_KEY_TYPE             0x00000007
+#define AR_KEYTABLE_TYPE_40     0x00000000
+#define AR_KEYTABLE_TYPE_104    0x00000001
+#define AR_KEYTABLE_TYPE_128    0x00000003
+#define AR_KEYTABLE_TYPE_TKIP   0x00000004
+#define AR_KEYTABLE_TYPE_AES    0x00000005
+#define AR_KEYTABLE_TYPE_CCM    0x00000006
+#define AR_KEYTABLE_TYPE_CLR    0x00000007
+#define AR_KEYTABLE_ANT         0x00000008
+#define AR_KEYTABLE_VALID       0x00008000
+#define AR_KEYTABLE_KEY0(_n)    (AR_KEYTABLE(_n) + 0)
+#define AR_KEYTABLE_KEY1(_n)    (AR_KEYTABLE(_n) + 4)
+#define AR_KEYTABLE_KEY2(_n)    (AR_KEYTABLE(_n) + 8)
+#define AR_KEYTABLE_KEY3(_n)    (AR_KEYTABLE(_n) + 12)
+#define AR_KEYTABLE_KEY4(_n)    (AR_KEYTABLE(_n) + 16)
+#define AR_KEYTABLE_TYPE(_n)    (AR_KEYTABLE(_n) + 20)
+#define AR_KEYTABLE_MAC0(_n)    (AR_KEYTABLE(_n) + 24)
+#define AR_KEYTABLE_MAC1(_n)    (AR_KEYTABLE(_n) + 28)
+
 /*
  * BSSID mask registers. See ath_hw_set_bssid_mask()
  * for detailed documentation about these registers.
  */
-#define AR_BSSMSKL		0x80e0
-#define AR_BSSMSKU		0x80e4
+#define AR_BSSMSKL              0x80e0
+#define AR_BSSMSKU              0x80e4
 
 #endif /* ATH_REGISTERS_H */
-- 
1.6.3.3

