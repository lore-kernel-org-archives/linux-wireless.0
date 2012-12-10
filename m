Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37552 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab2LJOa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 09:30:56 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 4/4] ath9k: allow to load EEPROM content via firmware API
Date: Mon, 10 Dec 2012 15:30:28 +0100
Message-Id: <1355149828-7394-4-git-send-email-juhosg@openwrt.org> (sfid-20121210_153101_949583_0AA66E44)
In-Reply-To: <1355149828-7394-1-git-send-email-juhosg@openwrt.org>
References: <1355149828-7394-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The calibration data for devices w/o a separate
EEPROM chip can be specified via the 'eeprom_data'
field of 'ath9k_platform_data'. The 'eeprom_data'
is usually filled from board specific setup
functions. It is easy if the EEPROM data is mapped
to the memory, but it can be complicated if it is
stored elsewhere.

The patch adds support for loading of the EEPROM
data via the firmware API to avoid this limitation.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |   19 +++++++++-
 drivers/net/wireless/ath/ath9k/hw.h     |    3 ++
 drivers/net/wireless/ath/ath9k/init.c   |   60 ++++++++++++++++++++++++++++++-
 include/linux/ath9k_platform.h          |    2 ++
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index eb9ac5e..971d770 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -113,12 +113,29 @@ void ath9k_hw_usb_gen_fill_eeprom(struct ath_hw *ah, u16 *eep_data,
 	}
 }
 
+static bool ath9k_hw_nvram_read_blob(struct ath_hw *ah, u32 off,
+				     u16 *data)
+{
+	u16 *blob_data;
+
+	if (off * sizeof(u16) > ah->eeprom_blob->size)
+		return false;
+
+	blob_data = (u16 *)ah->eeprom_blob->data;
+	*data =  blob_data[off];
+	return true;
+}
+
 bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool ret;
 
-	ret = common->bus_ops->eeprom_read(common, off, data);
+	if (ah->eeprom_blob)
+		ret = ath9k_hw_nvram_read_blob(ah, off, data);
+	else
+		ret = common->bus_ops->eeprom_read(common, off, data);
+
 	if (!ret)
 		ath_dbg(common, EEPROM,
 			"unable to read eeprom region at offset %u\n", off);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3636dab..b4edf4f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/firmware.h>
 
 #include "mac.h"
 #include "ani.h"
@@ -920,6 +921,8 @@ struct ath_hw {
 	bool is_clk_25mhz;
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
+
+	const struct firmware *eeprom_blob;
 };
 
 struct ath_bus_ops {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 80cae53..27703a5 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -23,6 +23,11 @@
 
 #include "ath9k.h"
 
+struct ath9k_eeprom_ctx {
+	struct completion complete;
+	struct ath_hw *ah;
+};
+
 static char *dev_info = "ath9k";
 
 MODULE_AUTHOR("Atheros Communications");
@@ -506,6 +511,51 @@ static void ath9k_init_misc(struct ath_softc *sc)
 		sc->ant_comb.count = ATH_ANT_DIV_COMB_INIT_COUNT;
 }
 
+static void ath9k_eeprom_request_cb(const struct firmware *eeprom_blob,
+				    void *ctx)
+{
+	struct ath9k_eeprom_ctx *ec = ctx;
+
+	if (eeprom_blob)
+		ec->ah->eeprom_blob = eeprom_blob;
+
+	complete(&ec->complete);
+}
+
+static int ath9k_eeprom_request(struct ath_softc *sc, const char *name)
+{
+	struct ath9k_eeprom_ctx ec;
+	struct ath_hw *ah = ah = sc->sc_ah;
+	int err;
+
+	/* try to load the EEPROM content asynchronously */
+	init_completion(&ec.complete);
+	ec.ah = sc->sc_ah;
+
+	err = request_firmware_nowait(THIS_MODULE, 1, name, sc->dev, GFP_KERNEL,
+				      &ec, ath9k_eeprom_request_cb);
+	if (err < 0) {
+		ath_err(ath9k_hw_common(ah),
+			"EEPROM request failed\n");
+		return err;
+	}
+
+	wait_for_completion(&ec.complete);
+
+	if (!ah->eeprom_blob) {
+		ath_err(ath9k_hw_common(ah),
+			"Unable to load EEPROM file %s\n", name);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void ath9k_eeprom_release(struct ath_softc *sc)
+{
+	release_firmware(sc->sc_ah->eeprom_blob);
+}
+
 static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 			    const struct ath_bus_ops *bus_ops)
 {
@@ -583,6 +633,12 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath_read_cachesize(common, &csz);
 	common->cachelsz = csz << 2; /* convert to bytes */
 
+	if (pdata->eeprom_name) {
+		ret = ath9k_eeprom_request(sc, pdata->eeprom_name);
+		if (ret)
+			goto err_eeprom;
+	}
+
 	/* Initializes the hardware for all supported chipsets */
 	ret = ath9k_hw_init(ah);
 	if (ret)
@@ -619,7 +675,8 @@ err_btcoex:
 err_queues:
 	ath9k_hw_deinit(ah);
 err_hw:
-
+	ath9k_eeprom_release(sc);
+err_eeprom:
 	kfree(ah);
 	sc->sc_ah = NULL;
 
@@ -882,6 +939,7 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 	if (sc->dfs_detector != NULL)
 		sc->dfs_detector->exit(sc->dfs_detector);
 
+	ath9k_eeprom_release(sc);
 	kfree(sc->sc_ah);
 	sc->sc_ah = NULL;
 }
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index 6e3f54f..fcdd81b 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -22,6 +22,8 @@
 #define ATH9K_PLAT_EEP_MAX_WORDS	2048
 
 struct ath9k_platform_data {
+	const char *eeprom_name;
+
 	u16 eeprom_data[ATH9K_PLAT_EEP_MAX_WORDS];
 	u8 *macaddr;
 
-- 
1.7.10

