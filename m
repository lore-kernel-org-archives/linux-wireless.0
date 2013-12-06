Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46434 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3LFLDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:03:50 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/16] ath9k: Use a separate TX gain table for WZR-HP-G450H
Date: Fri,  6 Dec 2013 16:28:45 +0530
Message-Id: <1386327534-31105-8-git-send-email-sujith@msujith.org> (sfid-20131206_120356_841826_2BA0D32D)
In-Reply-To: <1386327534-31105-1-git-send-email-sujith@msujith.org>
References: <1386327534-31105-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The Buffalo device WZR-HP-G450H uses the index 3 for TX gain,
which is set to the high_power table currently. Later variants
of the router use the same index, but instead refer to the
low_ob_db gain table. This is not handled in the driver since
there is no way to distinguish board revisions and the high_power
table is used (incorrectly) for the newer variants.

By default, devices based on AR9300 using the TX gain index 3 have
to use the high_power table. To make sure that WZR-HP-G450H is not
broken when the high_power table is updated, use a separate array
based on information obtained from the platform data.

The current situation where only the original variant of WZR-HP-G450H
works properly stays unchanged.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 .../wireless/ath/ath9k/ar9003_buffalo_initvals.h   | 126 +++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  12 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   1 +
 drivers/net/wireless/ath/ath9k/init.c              |  36 ++++--
 include/linux/ath9k_platform.h                     |   2 +
 5 files changed, 165 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_buffalo_initvals.h

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_buffalo_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_buffalo_initvals.h
new file mode 100644
index 0000000..59cf738
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9003_buffalo_initvals.h
@@ -0,0 +1,126 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros Inc.
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
+#ifndef INITVALS_9003_BUFFALO_H
+#define INITVALS_9003_BUFFALO_H
+
+static const u32 ar9300Modes_high_power_tx_gain_table_buffalo[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x0000a2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
+	{0x0000a2e0, 0x0000f800, 0x0000f800, 0x03ccc584, 0x03ccc584},
+	{0x0000a2e4, 0x03ff0000, 0x03ff0000, 0x03f0f800, 0x03f0f800},
+	{0x0000a2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
+	{0x0000a410, 0x000050d8, 0x000050d8, 0x000050d9, 0x000050d9},
+	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
+	{0x0000a504, 0x04002222, 0x04002222, 0x04000002, 0x04000002},
+	{0x0000a508, 0x09002421, 0x09002421, 0x08000004, 0x08000004},
+	{0x0000a50c, 0x0d002621, 0x0d002621, 0x0b000200, 0x0b000200},
+	{0x0000a510, 0x13004620, 0x13004620, 0x0f000202, 0x0f000202},
+	{0x0000a514, 0x19004a20, 0x19004a20, 0x11000400, 0x11000400},
+	{0x0000a518, 0x1d004e20, 0x1d004e20, 0x15000402, 0x15000402},
+	{0x0000a51c, 0x21005420, 0x21005420, 0x19000404, 0x19000404},
+	{0x0000a520, 0x26005e20, 0x26005e20, 0x1b000603, 0x1b000603},
+	{0x0000a524, 0x2b005e40, 0x2b005e40, 0x1f000a02, 0x1f000a02},
+	{0x0000a528, 0x2f005e42, 0x2f005e42, 0x23000a04, 0x23000a04},
+	{0x0000a52c, 0x33005e44, 0x33005e44, 0x26000a20, 0x26000a20},
+	{0x0000a530, 0x38005e65, 0x38005e65, 0x2a000e20, 0x2a000e20},
+	{0x0000a534, 0x3c005e69, 0x3c005e69, 0x2e000e22, 0x2e000e22},
+	{0x0000a538, 0x40005e6b, 0x40005e6b, 0x31000e24, 0x31000e24},
+	{0x0000a53c, 0x44005e6d, 0x44005e6d, 0x34001640, 0x34001640},
+	{0x0000a540, 0x49005e72, 0x49005e72, 0x38001660, 0x38001660},
+	{0x0000a544, 0x4e005eb2, 0x4e005eb2, 0x3b001861, 0x3b001861},
+	{0x0000a548, 0x53005f12, 0x53005f12, 0x3e001a81, 0x3e001a81},
+	{0x0000a54c, 0x59025eb2, 0x59025eb2, 0x42001a83, 0x42001a83},
+	{0x0000a550, 0x5e025f12, 0x5e025f12, 0x44001c84, 0x44001c84},
+	{0x0000a554, 0x61027f12, 0x61027f12, 0x48001ce3, 0x48001ce3},
+	{0x0000a558, 0x6702bf12, 0x6702bf12, 0x4c001ce5, 0x4c001ce5},
+	{0x0000a55c, 0x6b02bf14, 0x6b02bf14, 0x50001ce9, 0x50001ce9},
+	{0x0000a560, 0x6f02bf16, 0x6f02bf16, 0x54001ceb, 0x54001ceb},
+	{0x0000a564, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a568, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a56c, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a570, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a574, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a578, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a57c, 0x6f02bf16, 0x6f02bf16, 0x56001eec, 0x56001eec},
+	{0x0000a580, 0x00802220, 0x00802220, 0x00800000, 0x00800000},
+	{0x0000a584, 0x04802222, 0x04802222, 0x04800002, 0x04800002},
+	{0x0000a588, 0x09802421, 0x09802421, 0x08800004, 0x08800004},
+	{0x0000a58c, 0x0d802621, 0x0d802621, 0x0b800200, 0x0b800200},
+	{0x0000a590, 0x13804620, 0x13804620, 0x0f800202, 0x0f800202},
+	{0x0000a594, 0x19804a20, 0x19804a20, 0x11800400, 0x11800400},
+	{0x0000a598, 0x1d804e20, 0x1d804e20, 0x15800402, 0x15800402},
+	{0x0000a59c, 0x21805420, 0x21805420, 0x19800404, 0x19800404},
+	{0x0000a5a0, 0x26805e20, 0x26805e20, 0x1b800603, 0x1b800603},
+	{0x0000a5a4, 0x2b805e40, 0x2b805e40, 0x1f800a02, 0x1f800a02},
+	{0x0000a5a8, 0x2f805e42, 0x2f805e42, 0x23800a04, 0x23800a04},
+	{0x0000a5ac, 0x33805e44, 0x33805e44, 0x26800a20, 0x26800a20},
+	{0x0000a5b0, 0x38805e65, 0x38805e65, 0x2a800e20, 0x2a800e20},
+	{0x0000a5b4, 0x3c805e69, 0x3c805e69, 0x2e800e22, 0x2e800e22},
+	{0x0000a5b8, 0x40805e6b, 0x40805e6b, 0x31800e24, 0x31800e24},
+	{0x0000a5bc, 0x44805e6d, 0x44805e6d, 0x34801640, 0x34801640},
+	{0x0000a5c0, 0x49805e72, 0x49805e72, 0x38801660, 0x38801660},
+	{0x0000a5c4, 0x4e805eb2, 0x4e805eb2, 0x3b801861, 0x3b801861},
+	{0x0000a5c8, 0x53805f12, 0x53805f12, 0x3e801a81, 0x3e801a81},
+	{0x0000a5cc, 0x59825eb2, 0x59825eb2, 0x42801a83, 0x42801a83},
+	{0x0000a5d0, 0x5e825f12, 0x5e825f12, 0x44801c84, 0x44801c84},
+	{0x0000a5d4, 0x61827f12, 0x61827f12, 0x48801ce3, 0x48801ce3},
+	{0x0000a5d8, 0x6782bf12, 0x6782bf12, 0x4c801ce5, 0x4c801ce5},
+	{0x0000a5dc, 0x6b82bf14, 0x6b82bf14, 0x50801ce9, 0x50801ce9},
+	{0x0000a5e0, 0x6f82bf16, 0x6f82bf16, 0x54801ceb, 0x54801ceb},
+	{0x0000a5e4, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5e8, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5ec, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5f0, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5f4, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5f8, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a5fc, 0x6f82bf16, 0x6f82bf16, 0x56801eec, 0x56801eec},
+	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a60c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0000a610, 0x00804000, 0x00804000, 0x00000000, 0x00000000},
+	{0x0000a614, 0x00804201, 0x00804201, 0x01404000, 0x01404000},
+	{0x0000a618, 0x0280c802, 0x0280c802, 0x01404501, 0x01404501},
+	{0x0000a61c, 0x0280ca03, 0x0280ca03, 0x02008501, 0x02008501},
+	{0x0000a620, 0x04c15104, 0x04c15104, 0x0280ca03, 0x0280ca03},
+	{0x0000a624, 0x04c15305, 0x04c15305, 0x03010c04, 0x03010c04},
+	{0x0000a628, 0x04c15305, 0x04c15305, 0x04014c04, 0x04014c04},
+	{0x0000a62c, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a630, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a634, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a638, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000a63c, 0x04c15305, 0x04c15305, 0x04015005, 0x04015005},
+	{0x0000b2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
+	{0x0000b2e0, 0x0000f800, 0x0000f800, 0x03ccc584, 0x03ccc584},
+	{0x0000b2e4, 0x03ff0000, 0x03ff0000, 0x03f0f800, 0x03f0f800},
+	{0x0000b2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
+	{0x0000c2dc, 0x0380c7fc, 0x0380c7fc, 0x03aaa352, 0x03aaa352},
+	{0x0000c2e0, 0x0000f800, 0x0000f800, 0x03ccc584, 0x03ccc584},
+	{0x0000c2e4, 0x03ff0000, 0x03ff0000, 0x03f0f800, 0x03f0f800},
+	{0x0000c2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
+	{0x00016044, 0x012492d4, 0x012492d4, 0x012492d4, 0x012492d4},
+	{0x00016048, 0x66480001, 0x66480001, 0x66480001, 0x66480001},
+	{0x00016068, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c},
+	{0x00016444, 0x012492d4, 0x012492d4, 0x012492d4, 0x012492d4},
+	{0x00016448, 0x66480001, 0x66480001, 0x66480001, 0x66480001},
+	{0x00016468, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c},
+	{0x00016844, 0x012492d4, 0x012492d4, 0x012492d4, 0x012492d4},
+	{0x00016848, 0x66480001, 0x66480001, 0x66480001, 0x66480001},
+	{0x00016868, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c, 0x6db6db6c},
+};
+
+#endif /* INITVALS_9003_BUFFALO_H */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 4e8ae4a..29613eb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -17,6 +17,7 @@
 #include "hw.h"
 #include "ar9003_mac.h"
 #include "ar9003_2p2_initvals.h"
+#include "ar9003_buffalo_initvals.h"
 #include "ar9485_initvals.h"
 #include "ar9340_initvals.h"
 #include "ar9330_1p1_initvals.h"
@@ -592,9 +593,14 @@ static void ar9003_tx_gain_table_mode3(struct ath_hw *ah)
 	else if (AR_SREV_9565(ah))
 		INIT_INI_ARRAY(&ah->iniModesTxGain,
 			       ar9565_1p0_modes_high_power_tx_gain_table);
-	else
-		INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9300Modes_high_power_tx_gain_table_2p2);
+	else {
+		if (ah->config.tx_gain_buffalo)
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9300Modes_high_power_tx_gain_table_buffalo);
+		else
+			INIT_INI_ARRAY(&ah->iniModesTxGain,
+				       ar9300Modes_high_power_tx_gain_table_2p2);
+	}
 }
 
 static void ar9003_tx_gain_table_mode4(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7490047..b1ff546 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -316,6 +316,7 @@ struct ath9k_ops_config {
 	bool xatten_margin_cfg;
 	bool alt_mingainidx;
 	bool no_pll_pwrsave;
+	bool tx_gain_buffalo;
 };
 
 enum ath9k_int {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 8f4c167..998335c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -554,7 +554,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	sc->spec_config.fft_period = 0xF;
 }
 
-static void ath9k_init_platform(struct ath_softc *sc)
+static void ath9k_init_pcoem_platform(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
@@ -664,6 +664,27 @@ static void ath9k_eeprom_release(struct ath_softc *sc)
 	release_firmware(sc->sc_ah->eeprom_blob);
 }
 
+static int ath9k_init_soc_platform(struct ath_softc *sc)
+{
+	struct ath9k_platform_data *pdata = sc->dev->platform_data;
+	struct ath_hw *ah = sc->sc_ah;
+	int ret = 0;
+
+	if (!pdata)
+		return 0;
+
+	if (pdata->eeprom_name) {
+		ret = ath9k_eeprom_request(sc, pdata->eeprom_name);
+		if (ret)
+			return ret;
+	}
+
+	if (pdata->tx_gain_buffalo)
+		ah->config.tx_gain_buffalo = true;
+
+	return ret;
+}
+
 static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 			    const struct ath_bus_ops *bus_ops)
 {
@@ -717,7 +738,11 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	/*
 	 * Platform quirks.
 	 */
-	ath9k_init_platform(sc);
+	ath9k_init_pcoem_platform(sc);
+
+	ret = ath9k_init_soc_platform(sc);
+	if (ret)
+		return ret;
 
 	/*
 	 * Enable WLAN/BT RX Antenna diversity only when:
@@ -731,7 +756,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 		common->bt_ant_diversity = 1;
 
 	spin_lock_init(&common->cc_lock);
-
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
@@ -753,12 +777,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath_read_cachesize(common, &csz);
 	common->cachelsz = csz << 2; /* convert to bytes */
 
-	if (pdata && pdata->eeprom_name) {
-		ret = ath9k_eeprom_request(sc, pdata->eeprom_name);
-		if (ret)
-			return ret;
-	}
-
 	/* Initializes the hardware for all supported chipsets */
 	ret = ath9k_hw_init(ah);
 	if (ret)
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index fcdd81b..8598f8e 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -32,6 +32,8 @@ struct ath9k_platform_data {
 	u32 gpio_val;
 
 	bool is_clk_25mhz;
+	bool tx_gain_buffalo;
+
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
 };
-- 
1.8.4.2

