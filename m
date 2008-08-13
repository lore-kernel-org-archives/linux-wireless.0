Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40326 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYHMWsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 18:48:47 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2008 15:48:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <mcgrof@gmail.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] zd1211rw: make use of new regulatory_hint()
Date: Wed, 13 Aug 2008 15:48:42 -0700
Message-ID: <1218667722-1832-3-git-send-email-lrodriguez@atheros.com> (sfid-20080814_004851_267894_33C80870)
In-Reply-To: <1218667722-1832-2-git-send-email-lrodriguez@atheros.com>
References: <1218667722-1832-1-git-send-email-lrodriguez@atheros.com>
 <1218667722-1832-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans up zd1211rw's own regulatory work, and makes use of
the new cfg80211 regulatory_hint().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/zd1211rw/Makefile       |    2 +-
 drivers/net/wireless/zd1211rw/zd_chip.c      |    1 -
 drivers/net/wireless/zd1211rw/zd_ieee80211.c |  100 --------------------------
 drivers/net/wireless/zd1211rw/zd_ieee80211.h |   95 ------------------------
 drivers/net/wireless/zd1211rw/zd_mac.c       |   40 +++++++++-
 drivers/net/wireless/zd1211rw/zd_mac.h       |   65 ++++++++++++++++-
 drivers/net/wireless/zd1211rw/zd_rf.c        |    2 +-
 7 files changed, 102 insertions(+), 203 deletions(-)
 delete mode 100644 drivers/net/wireless/zd1211rw/zd_ieee80211.c
 delete mode 100644 drivers/net/wireless/zd1211rw/zd_ieee80211.h

diff --git a/drivers/net/wireless/zd1211rw/Makefile b/drivers/net/wireless/zd1211rw/Makefile
index cc36126..1907eaf 100644
--- a/drivers/net/wireless/zd1211rw/Makefile
+++ b/drivers/net/wireless/zd1211rw/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_ZD1211RW) += zd1211rw.o
 
-zd1211rw-objs := zd_chip.o zd_ieee80211.o zd_mac.o \
+zd1211rw-objs := zd_chip.o zd_mac.o \
 		zd_rf_al2230.o zd_rf_rf2959.o \
 		zd_rf_al7230b.o zd_rf_uw2453.o \
 		zd_rf.o zd_usb.o
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 0acb5c3..e0ac58b 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -28,7 +28,6 @@
 
 #include "zd_def.h"
 #include "zd_chip.h"
-#include "zd_ieee80211.h"
 #include "zd_mac.h"
 #include "zd_rf.h"
 
diff --git a/drivers/net/wireless/zd1211rw/zd_ieee80211.c b/drivers/net/wireless/zd1211rw/zd_ieee80211.c
deleted file mode 100644
index d8dc41e..0000000
--- a/drivers/net/wireless/zd1211rw/zd_ieee80211.c
+++ /dev/null
@@ -1,100 +0,0 @@
-/* ZD1211 USB-WLAN driver for Linux
- *
- * Copyright (C) 2005-2007 Ulrich Kunitz <kune@deine-taler.de>
- * Copyright (C) 2006-2007 Daniel Drake <dsd@gentoo.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-/*
- * In the long term, we'll probably find a better way of handling regulatory
- * requirements outside of the driver.
- */
-
-#include <linux/kernel.h>
-#include <net/mac80211.h>
-
-#include "zd_ieee80211.h"
-#include "zd_mac.h"
-
-struct channel_range {
-	u8 regdomain;
-	u8 start;
-	u8 end; /* exclusive (channel must be less than end) */
-};
-
-static const struct channel_range channel_ranges[] = {
-	{ ZD_REGDOMAIN_FCC,		1, 12 },
-	{ ZD_REGDOMAIN_IC,		1, 12 },
-	{ ZD_REGDOMAIN_ETSI,		1, 14 },
-	{ ZD_REGDOMAIN_JAPAN,		1, 14 },
-	{ ZD_REGDOMAIN_SPAIN,		1, 14 },
-	{ ZD_REGDOMAIN_FRANCE,		1, 14 },
-
-	/* Japan originally only had channel 14 available (see CHNL_ID 0x40 in
-	 * 802.11). However, in 2001 the range was extended to include channels
-	 * 1-13. The ZyDAS devices still use the old region code but are
-	 * designed to allow the extra channel access in Japan. */
-	{ ZD_REGDOMAIN_JAPAN_ADD,	1, 15 },
-};
-
-static const struct channel_range *zd_channel_range(u8 regdomain)
-{
-	int i;
-	for (i = 0; i < ARRAY_SIZE(channel_ranges); i++) {
-		const struct channel_range *range = &channel_ranges[i];
-		if (range->regdomain == regdomain)
-			return range;
-	}
-	return NULL;
-}
-
-#define CHAN_TO_IDX(chan) ((chan) - 1)
-
-static void unmask_bg_channels(struct ieee80211_hw *hw,
-	const struct channel_range *range,
-	struct ieee80211_supported_band *sband)
-{
-	u8 channel;
-
-	for (channel = range->start; channel < range->end; channel++) {
-		struct ieee80211_channel *chan =
-			&sband->channels[CHAN_TO_IDX(channel)];
-		chan->flags = 0;
-	}
-}
-
-void zd_geo_init(struct ieee80211_hw *hw, u8 regdomain)
-{
-	struct zd_mac *mac = zd_hw_mac(hw);
-	const struct channel_range *range;
-
-	dev_dbg(zd_mac_dev(mac), "regdomain %#02x\n", regdomain);
-
-	range = zd_channel_range(regdomain);
-	if (!range) {
-		/* The vendor driver overrides the regulatory domain and
-		 * allowed channel registers and unconditionally restricts
-		 * available channels to 1-11 everywhere. Match their
-		 * questionable behaviour only for regdomains which we don't
-		 * recognise. */
-		dev_warn(zd_mac_dev(mac), "Unrecognised regulatory domain: "
-			"%#02x. Defaulting to FCC.\n", regdomain);
-		range = zd_channel_range(ZD_REGDOMAIN_FCC);
-	}
-
-	unmask_bg_channels(hw, range, &mac->band);
-}
-
diff --git a/drivers/net/wireless/zd1211rw/zd_ieee80211.h b/drivers/net/wireless/zd1211rw/zd_ieee80211.h
deleted file mode 100644
index 26b79f1..0000000
--- a/drivers/net/wireless/zd1211rw/zd_ieee80211.h
+++ /dev/null
@@ -1,95 +0,0 @@
-/* ZD1211 USB-WLAN driver for Linux
- *
- * Copyright (C) 2005-2007 Ulrich Kunitz <kune@deine-taler.de>
- * Copyright (C) 2006-2007 Daniel Drake <dsd@gentoo.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- */
-
-#ifndef _ZD_IEEE80211_H
-#define _ZD_IEEE80211_H
-
-#include <net/mac80211.h>
-
-/* Additional definitions from the standards.
- */
-
-#define ZD_REGDOMAIN_FCC	0x10
-#define ZD_REGDOMAIN_IC		0x20
-#define ZD_REGDOMAIN_ETSI	0x30
-#define ZD_REGDOMAIN_SPAIN	0x31
-#define ZD_REGDOMAIN_FRANCE	0x32
-#define ZD_REGDOMAIN_JAPAN_ADD	0x40
-#define ZD_REGDOMAIN_JAPAN	0x41
-
-enum {
-	MIN_CHANNEL24 = 1,
-	MAX_CHANNEL24 = 14,
-};
-
-void zd_geo_init(struct ieee80211_hw *hw, u8 regdomain);
-
-#define ZD_PLCP_SERVICE_LENGTH_EXTENSION 0x80
-
-struct ofdm_plcp_header {
-	u8 prefix[3];
-	__le16 service;
-} __attribute__((packed));
-
-static inline u8 zd_ofdm_plcp_header_rate(const struct ofdm_plcp_header *header)
-{
-	return header->prefix[0] & 0xf;
-}
-
-/* The following defines give the encoding of the 4-bit rate field in the
- * OFDM (802.11a/802.11g) PLCP header. Notify that these values are used to
- * define the zd-rate values for OFDM.
- *
- * See the struct zd_ctrlset definition in zd_mac.h.
- */
-#define ZD_OFDM_PLCP_RATE_6M	0xb
-#define ZD_OFDM_PLCP_RATE_9M	0xf
-#define ZD_OFDM_PLCP_RATE_12M	0xa
-#define ZD_OFDM_PLCP_RATE_18M	0xe
-#define ZD_OFDM_PLCP_RATE_24M	0x9
-#define ZD_OFDM_PLCP_RATE_36M	0xd
-#define ZD_OFDM_PLCP_RATE_48M	0x8
-#define ZD_OFDM_PLCP_RATE_54M	0xc
-
-struct cck_plcp_header {
-	u8 signal;
-	u8 service;
-	__le16 length;
-	__le16 crc16;
-} __attribute__((packed));
-
-static inline u8 zd_cck_plcp_header_signal(const struct cck_plcp_header *header)
-{
-	return header->signal;
-}
-
-/* These defines give the encodings of the signal field in the 802.11b PLCP
- * header. The signal field gives the bit rate of the following packet. Even
- * if technically wrong we use CCK here also for the 1 MBit/s and 2 MBit/s
- * rate to stay consistent with Zydas and our use of the term.
- *
- * Notify that these values are *not* used in the zd-rates.
- */
-#define ZD_CCK_PLCP_SIGNAL_1M	0x0a
-#define ZD_CCK_PLCP_SIGNAL_2M	0x14
-#define ZD_CCK_PLCP_SIGNAL_5M5	0x37
-#define ZD_CCK_PLCP_SIGNAL_11M	0x6e
-
-#endif /* _ZD_IEEE80211_H */
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 4d7b98b..63ee066 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2005-2007 Ulrich Kunitz <kune@deine-taler.de>
  * Copyright (C) 2006-2007 Daniel Drake <dsd@gentoo.org>
  * Copyright (C) 2006-2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright (c) 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ * Copyright (C) 2007-2008 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -29,9 +29,23 @@
 #include "zd_def.h"
 #include "zd_chip.h"
 #include "zd_mac.h"
-#include "zd_ieee80211.h"
 #include "zd_rf.h"
 
+struct zd_reg_alpha2_map {
+	u32 reg;
+	char alpha2[2];
+};
+
+static struct zd_reg_alpha2_map reg_alpha2_map[] = {
+	{ ZD_REGDOMAIN_FCC, "US" },
+	{ ZD_REGDOMAIN_IC, "CA" },
+	{ ZD_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
+	{ ZD_REGDOMAIN_JAPAN, "JP" },
+	{ ZD_REGDOMAIN_JAPAN_ADD, "JP" },
+	{ ZD_REGDOMAIN_SPAIN, "ES" },
+	{ ZD_REGDOMAIN_FRANCE, "FR" },
+};
+
 /* This table contains the hardware specific values for the modulation rates. */
 static const struct ieee80211_rate zd_rates[] = {
 	{ .bitrate = 10,
@@ -95,6 +109,21 @@ static void housekeeping_init(struct zd_mac *mac);
 static void housekeeping_enable(struct zd_mac *mac);
 static void housekeeping_disable(struct zd_mac *mac);
 
+static int zd_reg2alpha2(u8 regdomain, char *alpha2)
+{
+	unsigned int i;
+	struct zd_reg_alpha2_map *reg_map;
+	for (i = 0; i < ARRAY_SIZE(reg_alpha2_map); i++) {
+		reg_map = &reg_alpha2_map[i];
+		if (regdomain == reg_map->reg) {
+			alpha2[0] = reg_map->alpha2[0];
+			alpha2[1] = reg_map->alpha2[1];
+			return 0;
+		}
+	}
+	return 1;
+}
+
 int zd_mac_preinit_hw(struct ieee80211_hw *hw)
 {
 	int r;
@@ -115,6 +144,7 @@ int zd_mac_init_hw(struct ieee80211_hw *hw)
 	int r;
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
+	char alpha2[2];
 	u8 default_regdomain;
 
 	r = zd_chip_enable_int(chip);
@@ -139,7 +169,9 @@ int zd_mac_init_hw(struct ieee80211_hw *hw)
 	if (r)
 		goto disable_int;
 
-	zd_geo_init(hw, mac->regdomain);
+	r = zd_reg2alpha2(mac->regdomain, alpha2);
+	if (!r)
+		regulatory_hint(hw->wiphy, alpha2, NULL);
 
 	r = 0;
 disable_int:
@@ -753,7 +785,7 @@ static int zd_op_config_interface(struct ieee80211_hw *hw,
 	return 0;
 }
 
-void zd_process_intr(struct work_struct *work)
+static void zd_process_intr(struct work_struct *work)
 {
 	u16 int_status;
 	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index 18c1d56..4c05d3e 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -25,7 +25,6 @@
 #include <net/mac80211.h>
 
 #include "zd_chip.h"
-#include "zd_ieee80211.h"
 
 struct zd_ctrlset {
 	u8     modulation;
@@ -187,6 +186,70 @@ struct zd_mac {
 	unsigned int pass_ctrl:1;
 };
 
+#define ZD_REGDOMAIN_FCC	0x10
+#define ZD_REGDOMAIN_IC		0x20
+#define ZD_REGDOMAIN_ETSI	0x30
+#define ZD_REGDOMAIN_SPAIN	0x31
+#define ZD_REGDOMAIN_FRANCE	0x32
+#define ZD_REGDOMAIN_JAPAN_ADD	0x40
+#define ZD_REGDOMAIN_JAPAN	0x41
+
+enum {
+	MIN_CHANNEL24 = 1,
+	MAX_CHANNEL24 = 14,
+};
+
+#define ZD_PLCP_SERVICE_LENGTH_EXTENSION 0x80
+
+struct ofdm_plcp_header {
+	u8 prefix[3];
+	__le16 service;
+} __attribute__((packed));
+
+static inline u8 zd_ofdm_plcp_header_rate(const struct ofdm_plcp_header *header)
+{
+	return header->prefix[0] & 0xf;
+}
+
+/* The following defines give the encoding of the 4-bit rate field in the
+ * OFDM (802.11a/802.11g) PLCP header. Notify that these values are used to
+ * define the zd-rate values for OFDM.
+ *
+ * See the struct zd_ctrlset definition in zd_mac.h.
+ */
+#define ZD_OFDM_PLCP_RATE_6M	0xb
+#define ZD_OFDM_PLCP_RATE_9M	0xf
+#define ZD_OFDM_PLCP_RATE_12M	0xa
+#define ZD_OFDM_PLCP_RATE_18M	0xe
+#define ZD_OFDM_PLCP_RATE_24M	0x9
+#define ZD_OFDM_PLCP_RATE_36M	0xd
+#define ZD_OFDM_PLCP_RATE_48M	0x8
+#define ZD_OFDM_PLCP_RATE_54M	0xc
+
+struct cck_plcp_header {
+	u8 signal;
+	u8 service;
+	__le16 length;
+	__le16 crc16;
+} __attribute__((packed));
+
+static inline u8 zd_cck_plcp_header_signal(const struct cck_plcp_header *header)
+{
+	return header->signal;
+}
+
+/* These defines give the encodings of the signal field in the 802.11b PLCP
+ * header. The signal field gives the bit rate of the following packet. Even
+ * if technically wrong we use CCK here also for the 1 MBit/s and 2 MBit/s
+ * rate to stay consistent with Zydas and our use of the term.
+ *
+ * Notify that these values are *not* used in the zd-rates.
+ */
+#define ZD_CCK_PLCP_SIGNAL_1M	0x0a
+#define ZD_CCK_PLCP_SIGNAL_2M	0x14
+#define ZD_CCK_PLCP_SIGNAL_5M5	0x37
+#define ZD_CCK_PLCP_SIGNAL_11M	0x6e
+
 static inline struct zd_mac *zd_hw_mac(struct ieee80211_hw *hw)
 {
 	return hw->priv;
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.c b/drivers/net/wireless/zd1211rw/zd_rf.c
index ec41293..7207bfd 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf.c
@@ -23,7 +23,7 @@
 
 #include "zd_def.h"
 #include "zd_rf.h"
-#include "zd_ieee80211.h"
+#include "zd_mac.h"
 #include "zd_chip.h"
 
 static const char * const rfs[] = {
-- 
1.5.6.rc2.15.g457bb.dirty

