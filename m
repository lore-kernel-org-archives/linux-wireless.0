Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:48906 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760573AbYBANg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 08:36:58 -0500
Date: Fri, 1 Feb 2008 08:36:56 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	bruno@thinktube.com, jirislaby@gmail.com,
	johannes@sipsolutions.net, mickflemm@gmail.com
Subject: [PATCH 2/3] ath5k: Port debug.c over to the new band API and enable as build option
Message-ID: <20080201133656.GG28995@ruslug.rutgers.edu> (sfid-20080201_133711_249031_7AECB5ED)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch finishes the port and enables debug as an build option.
This was tested on:

Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
RF5112A multiband radio found (0x36)

Note:

For 2 GHz band on the above card I noticed we get negative channel
numbers. Will look into this unless someone beats me to it.

Example out put when loading using:

sudo modprobe ath5k debug=0x00000400

 Band 2 GHz: channels 26, rates 12
  channels:
     1 2412 00c0 0000
     2 2417 00c0 0000
     3 2422 00c0 0000
     4 2427 00c0 0000
     5 2432 00c0 0000
     6 2437 00c0 0000
     7 2442 00c0 0000
     8 2447 00c0 0000
     9 2452 00c0 0000
    10 2457 00c0 0000
    11 2462 00c0 0000
    12 2467 00c0 0000
    13 2472 00c0 0000
    14 2484 00c0 0000
   -498 2512 00c0 0000
   -494 2532 00c0 0000
   -490 2552 00c0 0000
   -486 2572 00c0 0000
   -482 2592 00c0 0000
   -478 2612 00c0 0000
   -474 2632 00c0 0000
   -470 2652 00c0 0000
   -466 2672 00c0 0000
   -462 2692 00c0 0000
   -458 2712 00c0 0000
   -454 2732 00c0 0000
 Band 5 GHz: channels 194, rates 8
  channels:
    27 5135 0140 0000
    28 5140 0140 0000
[... etc ]
   219 6095 0140 0000
   220 6100 0140 0000
  rates:
     60 000b 0000 0000
     90 000f 0000 0000
    120 000a 0000 0000
    180 000e 0000 0000
    240 0009 0000 0000
    360 000d 0000 0000
    480 0008 0000 0000
    540 000c 0000 0000

Changes to base.[ch]
Changes-licensed-under: 3-clause-BSD

Changes to debug.[ch]
Changes-licensed-under: GPL

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/Kconfig |   22 +++++++++++++-
 drivers/net/wireless/ath5k/base.c  |    2 +-
 drivers/net/wireless/ath5k/base.h  |    4 +-
 drivers/net/wireless/ath5k/debug.c |   55 +++++++++++++++++++++++------------
 drivers/net/wireless/ath5k/debug.h |   19 ++++--------
 5 files changed, 66 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath5k/Kconfig b/drivers/net/wireless/ath5k/Kconfig
index 55f0c09..31d570e 100644
--- a/drivers/net/wireless/ath5k/Kconfig
+++ b/drivers/net/wireless/ath5k/Kconfig
@@ -1,4 +1,3 @@
-
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
@@ -15,3 +14,24 @@ config ATH5K
 
 	  If you choose to build a module, it'll be called ath5k. Say M if
 	  unsure.
+
+config ATH5K_DEBUG
+	bool "Atheros 5xxx debugging"
+	depends on ATH5K
+	---help---
+	  Atheros 5xxx debugging messages.
+
+	  Say Y, if and you will get debug options for ath5k.
+	  To use this, you need to mount debugfs:
+	  
+	  mkdir /debug/
+	  mount -t debugfs debug /debug/
+	  
+	  You will get access to files under:
+	  /debug/ath5k/phy0/
+	  
+	  To enable debug, pass the debug level to the debug module
+	  parameter. For example:
+	  
+	  modprobe ath5k debug=0x00000400
+	  
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 1e7eeec..9f2c30b 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -990,7 +990,7 @@ ath5k_getchannels(struct ieee80211_hw *hw)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
 	}
 
-/* FIXME:	ath5k_debug_dump_modes(sc, modes); */
+	ath5k_debug_dump_bands(sc);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index bbe7a54..3a97558 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -108,9 +108,9 @@ struct ath5k_softc {
 	u8			g_rates;
 	u8			xr_rates;
 
-#if ATH5K_DEBUG
+#ifdef CONFIG_ATH5K_DEBUG
 	struct ath5k_dbg_info	debug;		/* debug info */
-#endif
+#endif /* CONFIG_ATH5K_DEBUG */
 
 	struct ath5k_buf	*bufptr;	/* allocated buffer ptr */
 	struct ath5k_desc	*desc;		/* TX/RX descriptors */
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index bb581ef..05bf4fb 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -65,7 +65,7 @@ static unsigned int ath5k_debug;
 module_param_named(debug, ath5k_debug, uint, 0);
 
 
-#if ATH5K_DEBUG
+#ifdef CONFIG_ATH5K_DEBUG
 
 #include <linux/seq_file.h>
 #include "reg.h"
@@ -340,7 +340,7 @@ static struct {
 	{ ATH5K_DEBUG_LED,	"led",		"LED mamagement" },
 	{ ATH5K_DEBUG_DUMP_RX,	"dumprx",	"print received skb content" },
 	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
-	{ ATH5K_DEBUG_DUMPMODES, "dumpmodes",	"dump modes" },
+	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
 	{ ATH5K_DEBUG_TRACE,	"trace",	"trace function calls" },
 	{ ATH5K_DEBUG_ANY,	"all",		"show all debug levels" },
 };
@@ -452,30 +452,47 @@ ath5k_debug_finish_device(struct ath5k_softc *sc)
 /* functions used in other places */
 
 void
-ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode *modes)
+ath5k_debug_dump_bands(struct ath5k_softc *sc)
 {
-	unsigned int m, i;
+	unsigned int b, i;
 
-	if (likely(!(sc->debug.level & ATH5K_DEBUG_DUMPMODES)))
+	if (likely(!(sc->debug.level & ATH5K_DEBUG_DUMPBANDS)))
 		return;
 
-	for (m = 0; m < NUM_DRIVER_MODES; m++) {
-		printk(KERN_DEBUG "Mode %u: channels %d, rates %d\n", m,
-				modes[m].num_channels, modes[m].num_rates);
+	BUG_ON(!sc->sbands);
+
+	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
+		struct ieee80211_supported_band *band = &sc->sbands[b];
+		char bname[5];
+		switch (band->band) {
+		case IEEE80211_BAND_2GHZ:
+			strcpy(bname, "2 GHz");
+			break;
+		case IEEE80211_BAND_5GHZ:
+			strcpy(bname, "5 GHz");
+			break;
+		default:
+			printk(KERN_DEBUG "Band not supported: %d\n",
+				band->band);
+			return;
+		}
+		printk(KERN_DEBUG "Band %s: channels %d, rates %d\n", bname,
+				band->n_channels, band->n_bitrates);
 		printk(KERN_DEBUG " channels:\n");
-		for (i = 0; i < modes[m].num_channels; i++)
+		for (i = 0; i < band->n_channels; i++)
 			printk(KERN_DEBUG "  %3d %d %.4x %.4x\n",
-					modes[m].channels[i].chan,
-					modes[m].channels[i].freq,
-					modes[m].channels[i].val,
-					modes[m].channels[i].flag);
+					ieee80211_frequency_to_channel(
+						band->channels[i].center_freq),
+					band->channels[i].center_freq,
+					band->channels[i].hw_value,
+					band->channels[i].flags);
 		printk(KERN_DEBUG " rates:\n");
-		for (i = 0; i < modes[m].num_rates; i++)
+		for (i = 0; i < band->n_bitrates; i++)
 			printk(KERN_DEBUG "  %4d %.4x %.4x %.4x\n",
-					modes[m].rates[i].rate,
-					modes[m].rates[i].val,
-					modes[m].rates[i].flags,
-					modes[m].rates[i].val2);
+					band->bitrates[i].bitrate,
+					band->bitrates[i].hw_value,
+					band->bitrates[i].flags,
+					band->bitrates[i].hw_value_short);
 	}
 }
 
@@ -548,4 +565,4 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc,
 		!done ? ' ' : (ds->ds_txstat.ts_status == 0) ? '*' : '!');
 }
 
-#endif /* if ATH5K_DEBUG */
+#endif /* ifdef CONFIG_ATH5K_DEBUG */
diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
index c4fd8c4..16fbb6f 100644
--- a/drivers/net/wireless/ath5k/debug.h
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -61,11 +61,6 @@
 #ifndef _ATH5K_DEBUG_H
 #define _ATH5K_DEBUG_H
 
-/* set this to 1 for debugging output */
-#ifndef ATH5K_DEBUG
-#define ATH5K_DEBUG	0
-#endif
-
 struct ath5k_softc;
 struct ath5k_hw;
 struct ieee80211_hw_mode;
@@ -96,7 +91,7 @@ struct ath5k_dbg_info {
  * @ATH5K_DEBUG_LED: led management
  * @ATH5K_DEBUG_DUMP_RX: print received skb content
  * @ATH5K_DEBUG_DUMP_TX: print transmit skb content
- * @ATH5K_DEBUG_DUMPMODES: dump modes
+ * @ATH5K_DEBUG_DUMPBANDS: dump bands
  * @ATH5K_DEBUG_TRACE: trace function calls
  * @ATH5K_DEBUG_ANY: show at any debug level
  *
@@ -118,12 +113,12 @@ enum ath5k_debug_level {
 	ATH5K_DEBUG_LED		= 0x00000080,
 	ATH5K_DEBUG_DUMP_RX	= 0x00000100,
 	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
-	ATH5K_DEBUG_DUMPMODES	= 0x00000400,
+	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
 	ATH5K_DEBUG_TRACE	= 0x00001000,
 	ATH5K_DEBUG_ANY		= 0xffffffff
 };
 
-#if ATH5K_DEBUG
+#ifdef CONFIG_ATH5K_DEBUG
 
 #define ATH5K_TRACE(_sc) do { \
 	if (unlikely((_sc)->debug.level & ATH5K_DEBUG_TRACE)) \
@@ -158,8 +153,7 @@ void
 ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah);
 
 void
-ath5k_debug_dump_modes(struct ath5k_softc *sc,
-			struct ieee80211_hw_mode *modes);
+ath5k_debug_dump_bands(struct ath5k_softc *sc);
 
 void
 ath5k_debug_dump_skb(struct ath5k_softc *sc,
@@ -196,8 +190,7 @@ static inline void
 ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah) {}
 
 static inline void
-ath5k_debug_dump_modes(struct ath5k_softc *sc,
-			struct ieee80211_hw_mode *modes) {}
+ath5k_debug_dump_bands(struct ath5k_softc *sc) {}
 
 static inline void
 ath5k_debug_dump_skb(struct ath5k_softc *sc,
@@ -207,6 +200,6 @@ static inline void
 ath5k_debug_printtxbuf(struct ath5k_softc *sc,
 			struct ath5k_buf *bf, int done) {}
 
-#endif /* if ATH5K_DEBUG */
+#endif /* ifdef CONFIG_ATH5K_DEBUG */
 
 #endif /* ifndef _ATH5K_DEBUG_H */
-- 
1.5.3.7

