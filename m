Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54745 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaCAURN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:13 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 13/23] ath9k: move ath9k_beacon_config_sta to common-beacon
Date: Sat,  1 Mar 2014 21:15:56 +0100
Message-Id: <1393704966-13985-14-git-send-email-linux@rempel-privat.de> (sfid-20140301_214709_758525_49E468FA)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/Makefile        |   3 +-
 drivers/net/wireless/ath/ath9k/beacon.c        |  80 +---------------
 drivers/net/wireless/ath/ath9k/common-beacon.c | 126 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-beacon.h |  21 +++++
 drivers/net/wireless/ath/ath9k/common.h        |   1 +
 5 files changed, 153 insertions(+), 78 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common-beacon.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-beacon.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index b58fe99..8e1c7b0 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -52,7 +52,8 @@ obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
 
 obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
 ath9k_common-y:=	common.o \
-			common-init.o
+			common-init.o \
+			common-beacon.o
 
 ath9k_htc-y +=	htc_hst.o \
 		hif_usb.o \
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6372671..9333fa1 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -505,87 +505,13 @@ static void ath9k_beacon_config_ap(struct ath_softc *sc,
 	ath9k_beacon_init(sc, nexttbtt, intval, false);
 }
 
-/*
- * This sets up the beacon timers according to the timestamp of the last
- * received beacon and the current TSF, configures PCF and DTIM
- * handling, programs the sleep registers so the hardware will wakeup in
- * time to receive beacons, and configures the beacon miss handling so
- * we'll receive a BMISS interrupt when we stop seeing beacons from the AP
- * we've associated with.
- */
-static void ath9k_beacon_config_sta(struct ath_softc *sc,
+static void ath9k_beacon_config_sta(struct ath_hw *ah,
 				    struct ath_beacon_config *conf)
 {
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_beacon_state bs;
-	int dtim_intval;
-	u32 nexttbtt = 0, intval;
-	u64 tsf;
 
-	/* No need to configure beacon if we are not associated */
-	if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
-		ath_dbg(common, BEACON,
-			"STA is not yet associated..skipping beacon config\n");
+	if (ath9k_cmn_beacon_config_sta(ah, conf, &bs) == -EPERM)
 		return;
-	}
-
-	memset(&bs, 0, sizeof(bs));
-	intval = conf->beacon_interval;
-
-	/*
-	 * Setup dtim parameters according to
-	 * last beacon we received (which may be none).
-	 */
-	dtim_intval = intval * conf->dtim_period;
-
-	/*
-	 * Pull nexttbtt forward to reflect the current
-	 * TSF and calculate dtim state for the result.
-	 */
-	tsf = ath9k_hw_gettsf64(ah);
-	nexttbtt = ath9k_get_next_tbtt(sc, tsf, intval);
-
-	bs.bs_intval = TU_TO_USEC(intval);
-	bs.bs_dtimperiod = conf->dtim_period * bs.bs_intval;
-	bs.bs_nexttbtt = nexttbtt;
-	bs.bs_nextdtim = nexttbtt;
-	if (conf->dtim_period > 1)
-		bs.bs_nextdtim = ath9k_get_next_tbtt(sc, tsf, dtim_intval);
-
-	/*
-	 * Calculate the number of consecutive beacons to miss* before taking
-	 * a BMISS interrupt. The configuration is specified in TU so we only
-	 * need calculate based	on the beacon interval.  Note that we clamp the
-	 * result to at most 15 beacons.
-	 */
-	bs.bs_bmissthreshold = DIV_ROUND_UP(conf->bmiss_timeout, intval);
-	if (bs.bs_bmissthreshold > 15)
-		bs.bs_bmissthreshold = 15;
-	else if (bs.bs_bmissthreshold <= 0)
-		bs.bs_bmissthreshold = 1;
-
-	/*
-	 * Calculate sleep duration. The configuration is given in ms.
-	 * We ensure a multiple of the beacon period is used. Also, if the sleep
-	 * duration is greater than the DTIM period then it makes senses
-	 * to make it a multiple of that.
-	 *
-	 * XXX fixed at 100ms
-	 */
-
-	bs.bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
-						 intval));
-	if (bs.bs_sleepduration > bs.bs_dtimperiod)
-		bs.bs_sleepduration = bs.bs_dtimperiod;
-
-	/* TSF out of range threshold fixed at 1 second */
-	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
-
-	ath_dbg(common, BEACON, "bmiss: %u sleep: %u\n",
-		bs.bs_bmissthreshold, bs.bs_sleepduration);
-
-	/* Set the computed STA beacon timers */
 
 	ath9k_hw_disable_interrupts(ah);
 	ath9k_hw_set_sta_beacon_timers(ah, &bs);
@@ -777,7 +703,7 @@ void ath9k_set_beacon(struct ath_softc *sc)
 		ath9k_beacon_config_adhoc(sc, cur_conf);
 		break;
 	case NL80211_IFTYPE_STATION:
-		ath9k_beacon_config_sta(sc, cur_conf);
+		ath9k_beacon_config_sta(sc->sc_ah, cur_conf);
 		break;
 	default:
 		ath_dbg(common, CONFIG, "Unsupported beaconing mode\n");
diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.c b/drivers/net/wireless/ath/ath9k/common-beacon.c
new file mode 100644
index 0000000..35cc9fd
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.c
@@ -0,0 +1,126 @@
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "common.h"
+
+#define FUDGE 2
+
+/* Calculate the modulo of a 64 bit TSF snapshot with a TU divisor */
+static u32 ath9k_mod_tsf64_tu(u64 tsf, u32 div_tu)
+{
+	u32 tsf_mod, tsf_hi, tsf_lo, mod_hi, mod_lo;
+
+	tsf_mod = tsf & (BIT(10) - 1);
+	tsf_hi = tsf >> 32;
+	tsf_lo = ((u32) tsf) >> 10;
+
+	mod_hi = tsf_hi % div_tu;
+	mod_lo = ((mod_hi << 22) + tsf_lo) % div_tu;
+
+	return (mod_lo << 10) | tsf_mod;
+}
+
+static u32 ath9k_get_next_tbtt(struct ath_hw *ah, u64 tsf,
+			       unsigned int interval)
+{
+	unsigned int offset;
+
+	tsf += TU_TO_USEC(FUDGE + ah->config.sw_beacon_response_time);
+	offset = ath9k_mod_tsf64_tu(tsf, interval);
+
+	return (u32) tsf + TU_TO_USEC(interval) - offset;
+}
+
+/*
+ * This sets up the beacon timers according to the timestamp of the last
+ * received beacon and the current TSF, configures PCF and DTIM
+ * handling, programs the sleep registers so the hardware will wakeup in
+ * time to receive beacons, and configures the beacon miss handling so
+ * we'll receive a BMISS interrupt when we stop seeing beacons from the AP
+ * we've associated with.
+ */
+int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
+				 struct ath_beacon_config *conf,
+				 struct ath9k_beacon_state *bs)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int dtim_intval;
+	u64 tsf;
+
+	/* No need to configure beacon if we are not associated */
+	if (!test_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags)) {
+		ath_dbg(common, BEACON,
+			"STA is not yet associated..skipping beacon config\n");
+		return -EPERM;
+	}
+
+	memset(bs, 0, sizeof(*bs));
+	conf->intval = conf->beacon_interval;
+
+	/*
+	 * Setup dtim parameters according to
+	 * last beacon we received (which may be none).
+	 */
+	dtim_intval = conf->intval * conf->dtim_period;
+
+	/*
+	 * Pull nexttbtt forward to reflect the current
+	 * TSF and calculate dtim state for the result.
+	 */
+	tsf = ath9k_hw_gettsf64(ah);
+	conf->nexttbtt = ath9k_get_next_tbtt(ah, tsf, conf->intval);
+
+	bs->bs_intval = TU_TO_USEC(conf->intval);
+	bs->bs_dtimperiod = conf->dtim_period * bs->bs_intval;
+	bs->bs_nexttbtt = conf->nexttbtt;
+	bs->bs_nextdtim = conf->nexttbtt;
+	if (conf->dtim_period > 1)
+		bs->bs_nextdtim = ath9k_get_next_tbtt(ah, tsf, dtim_intval);
+
+	/*
+	 * Calculate the number of consecutive beacons to miss* before taking
+	 * a BMISS interrupt. The configuration is specified in TU so we only
+	 * need calculate based	on the beacon interval.  Note that we clamp the
+	 * result to at most 15 beacons.
+	 */
+	bs->bs_bmissthreshold = DIV_ROUND_UP(conf->bmiss_timeout, conf->intval);
+	if (bs->bs_bmissthreshold > 15)
+		bs->bs_bmissthreshold = 15;
+	else if (bs->bs_bmissthreshold <= 0)
+		bs->bs_bmissthreshold = 1;
+
+	/*
+	 * Calculate sleep duration. The configuration is given in ms.
+	 * We ensure a multiple of the beacon period is used. Also, if the sleep
+	 * duration is greater than the DTIM period then it makes senses
+	 * to make it a multiple of that.
+	 *
+	 * XXX fixed at 100ms
+	 */
+
+	bs->bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
+						 conf->intval));
+	if (bs->bs_sleepduration > bs->bs_dtimperiod)
+		bs->bs_sleepduration = bs->bs_dtimperiod;
+
+	/* TSF out of range threshold fixed at 1 second */
+	bs->bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
+
+	ath_dbg(common, BEACON, "bmiss: %u sleep: %u\n",
+		bs->bs_bmissthreshold, bs->bs_sleepduration);
+	return 0;
+}
+EXPORT_SYMBOL(ath9k_cmn_beacon_config_sta);
diff --git a/drivers/net/wireless/ath/ath9k/common-beacon.h b/drivers/net/wireless/ath/ath9k/common-beacon.h
new file mode 100644
index 0000000..51cbcb5
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/common-beacon.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (c) 2009-2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+struct ath_beacon_config;
+
+int ath9k_cmn_beacon_config_sta(struct ath_hw *ah,
+				struct ath_beacon_config *conf,
+				struct ath9k_beacon_state *bs);
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index eccc718..ca38116 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -22,6 +22,7 @@
 #include "hw-ops.h"
 
 #include "common-init.h"
+#include "common-beacon.h"
 
 /* Common header for Atheros 802.11n base driver cores */
 
-- 
1.9.0

