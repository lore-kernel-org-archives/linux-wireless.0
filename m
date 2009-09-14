Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/11] atheros: move bus ops to ath_common
Date: Mon, 14 Sep 2009 04:37:28 -0400
Message-Id: <1252917448-10744-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the last part to make ath9k hw code core driver agnostic.
I believe ath9k_htc can now use use the hw code unmodified.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h               |   10 ++++++++++
 drivers/net/wireless/ath/ath9k/Makefile      |    3 +--
 drivers/net/wireless/ath/ath9k/ahb.c         |   14 ++++++++------
 drivers/net/wireless/ath/ath9k/ath9k.h       |   19 ++++++-------------
 drivers/net/wireless/ath/ath9k/eeprom.c      |    8 +++-----
 drivers/net/wireless/ath/ath9k/eeprom.h      |    3 ++-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    7 ++++---
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |    5 +++--
 drivers/net/wireless/ath/ath9k/main.c        |   20 +++++++++++++-------
 drivers/net/wireless/ath/ath9k/pci.c         |   21 ++++++++++++++-------
 11 files changed, 66 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 38ca68e..e0341fe 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -45,6 +45,15 @@ struct ath_ops {
         void (*write)(void *, u32 val, u32 reg_offset);
 };
 
+struct ath_common;
+
+struct ath_bus_ops {
+	void		(*read_cachesize)(struct ath_common *common, int *csz);
+	void		(*cleanup)(struct ath_common *common);
+	bool		(*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
+	void		(*bt_coex_prep)(struct ath_common *common);
+};
+
 struct ath_common {
 	void *ah;
 	struct ieee80211_hw *hw;
@@ -61,6 +70,7 @@ struct ath_common {
 
 	struct ath_regulatory regulatory;
 	const struct ath_ops *ops;
+	const struct ath_bus_ops *bus_ops;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 2f21c67..f3221af 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -1,5 +1,5 @@
-ATH9K_HW_FIX +=	eeprom.o
 ATH9K_HW +=	hw.o \
+		eeprom.o \
 		eeprom_def.o \
 		eeprom_4k.o \
 		eeprom_9287.o \
@@ -10,7 +10,6 @@ ATH9K_HW +=	hw.o \
 		mac.o \
 
 ath9k-y +=	$(ATH9K_HW) \
-		$(ATH9K_HW_FIX) \
 		beacon.o \
 		main.o \
 		recv.o \
diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 095973e..33c9e81 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -22,25 +22,28 @@
 #include "ath9k.h"
 
 /* return bus cachesize in 4B word units */
-static void ath_ahb_read_cachesize(struct ath_softc *sc, int *csz)
+static void ath_ahb_read_cachesize(struct ath_common *common, int *csz)
 {
 	*csz = L1_CACHE_BYTES >> 2;
 }
 
-static void ath_ahb_cleanup(struct ath_softc *sc)
+static void ath_ahb_cleanup(struct ath_common *common)
 {
+	struct ath_hw *ah = (struct ath_hw *) common->ah;
+	struct ath_softc *sc = ah->ah_sc;
 	iounmap(sc->mem);
 }
 
-static bool ath_ahb_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
+static bool ath_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
+	struct ath_hw *ah = (struct ath_hw *) common->ah;
 	struct ath_softc *sc = ah->ah_sc;
 	struct platform_device *pdev = to_platform_device(sc->dev);
 	struct ath9k_platform_data *pdata;
 
 	pdata = (struct ath9k_platform_data *) pdev->dev.platform_data;
 	if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+		ath_print(common, ATH_DBG_FATAL,
 			  "%s: flash read failed, offset %08x "
 			  "is out of range\n",
 			  __func__, off);
@@ -117,10 +120,9 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
-	sc->bus_ops = &ath_ahb_bus_ops;
 	sc->irq = irq;
 
-	ret = ath_init_device(AR5416_AR9100_DEVID, sc, 0x0);
+	ret = ath_init_device(AR5416_AR9100_DEVID, sc, 0x0, &ath_ahb_bus_ops);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto err_free_hw;
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8768e60..14ff38d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -537,13 +537,6 @@ struct ath_led {
 #define SC_OP_BEACON_SYNC       BIT(19)
 #define SC_OP_BT_PRIORITY_DETECTED BIT(21)
 
-struct ath_bus_ops {
-	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
-	void		(*cleanup)(struct ath_softc *sc);
-	bool		(*eeprom_read)(struct ath_hw *ah, u32 off, u16 *data);
-	void		(*bt_coex_prep)(struct ath_softc *sc);
-};
-
 struct ath_wiphy;
 
 struct ath_softc {
@@ -613,7 +606,6 @@ struct ath_softc {
 #ifdef CONFIG_ATH9K_DEBUG
 	struct ath9k_debug debug;
 #endif
-	struct ath_bus_ops *bus_ops;
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
 	struct ath_btcoex btcoex;
@@ -638,21 +630,22 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
 
-static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
+static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 {
-	sc->bus_ops->read_cachesize(sc, csz);
+	common->bus_ops->read_cachesize(common, csz);
 }
 
-static inline void ath_bus_cleanup(struct ath_softc *sc)
+static inline void ath_bus_cleanup(struct ath_common *common)
 {
-	sc->bus_ops->cleanup(sc);
+	common->bus_ops->cleanup(common);
 }
 
 extern struct ieee80211_ops ath9k_ops;
 
 irqreturn_t ath_isr(int irq, void *dev);
 void ath_cleanup(struct ath_softc *sc);
-int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid);
+int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
+		    const struct ath_bus_ops *bus_ops);
 void ath_detach(struct ath_softc *sc);
 const char *ath_mac_bb_name(u32 mac_bb_version);
 const char *ath_rf_name(u16 rf_version);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index b6e52d0..dacaae9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include "ath9k.h"
+#include "hw.h"
 
 static inline u16 ath9k_hw_fbin2freq(u8 fbin, bool is2GHz)
 {
@@ -83,11 +83,9 @@ bool ath9k_hw_get_lower_upper_index(u8 target, u8 *pList, u16 listSize,
 	return false;
 }
 
-bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data)
+bool ath9k_hw_nvram_read(struct ath_common *common, u32 off, u16 *data)
 {
-	struct ath_softc *sc = ah->ah_sc;
-
-	return sc->bus_ops->eeprom_read(ah, off, data);
+	return common->bus_ops->eeprom_read(common, off, data);
 }
 
 void ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 4fe33f7..8463ba0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -17,6 +17,7 @@
 #ifndef EEPROM_H
 #define EEPROM_H
 
+#include "../ath.h"
 #include <net/cfg80211.h>
 
 #define AH_USE_EEPROM   0x1
@@ -684,7 +685,7 @@ int16_t ath9k_hw_interpolate(u16 target, u16 srcLeft, u16 srcRight,
 			     int16_t targetRight);
 bool ath9k_hw_get_lower_upper_index(u8 target, u8 *pList, u16 listSize,
 				    u16 *indexL, u16 *indexR);
-bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data);
+bool ath9k_hw_nvram_read(struct ath_common *common, u32 off, u16 *data);
 void ath9k_hw_fill_vpd_table(u8 pwrMin, u8 pwrMax, u8 *pPwrList,
 			     u8 *pVpdList, u16 numIntercepts,
 			     u8 *pRetVpdList);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index c2ac85c..2a27b1d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -41,7 +41,7 @@ static bool ath9k_hw_4k_fill_eeprom(struct ath_hw *ah)
 	}
 
 	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
-		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
+		if (!ath9k_hw_nvram_read(common, addr + eep_start_loc, eep_data)) {
 			ath_print(common, ATH_DBG_EEPROM,
 				  "Unable to read eeprom region \n");
 			return false;
@@ -66,7 +66,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 
 
 	if (!ath9k_hw_use_flash(ah)) {
-		if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET,
+		if (!ath9k_hw_nvram_read(common, AR5416_EEPROM_MAGIC_OFFSET,
 					 &magic)) {
 			ath_print(common, ATH_DBG_FATAL,
 				  "Reading Magic # failed\n");
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 839eed8..839d05a 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -41,7 +41,8 @@ static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 
 	for (addr = 0; addr < sizeof(struct ar9287_eeprom) / sizeof(u16);
 			addr++)	{
-		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
+		if (!ath9k_hw_nvram_read(common,
+					 addr + eep_start_loc, eep_data)) {
 			ath_print(common, ATH_DBG_EEPROM,
 				  "Unable to read eeprom region \n");
 			return false;
@@ -61,8 +62,8 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!ath9k_hw_use_flash(ah)) {
-		if (!ath9k_hw_nvram_read
-		    (ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+		if (!ath9k_hw_nvram_read(common,
+					 AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
 			ath_print(common, ATH_DBG_FATAL,
 				  "Reading Magic # failed\n");
 			return false;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 50d733c..828a922 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -89,11 +89,12 @@ static int ath9k_hw_def_get_eeprom_rev(struct ath_hw *ah)
 static bool ath9k_hw_def_fill_eeprom(struct ath_hw *ah)
 {
 #define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(u16))
+	struct ath_common *common = ath9k_hw_common(ah);
 	u16 *eep_data = (u16 *)&ah->eeprom.def;
 	int addr, ar5416_eep_start_loc = 0x100;
 
 	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
-		if (!ath9k_hw_nvram_read(ah, addr + ar5416_eep_start_loc,
+		if (!ath9k_hw_nvram_read(common, addr + ar5416_eep_start_loc,
 					 eep_data)) {
 			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
 				  "Unable to read eeprom region\n");
@@ -115,7 +116,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 	bool need_swap = false;
 	int i, addr, size;
 
-	if (!ath9k_hw_nvram_read(ah, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+	if (!ath9k_hw_nvram_read(common, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
 		ath_print(common, ATH_DBG_FATAL, "Reading Magic # failed\n");
 		return false;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e38baed..588ee89 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1316,9 +1316,12 @@ static void ath_start_rfkill_poll(struct ath_softc *sc)
 
 void ath_cleanup(struct ath_softc *sc)
 {
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
 	ath_detach(sc);
 	free_irq(sc->irq, sc);
-	ath_bus_cleanup(sc);
+	ath_bus_cleanup(common);
 	kfree(sc->sec_wiphy);
 	ieee80211_free_hw(sc->hw);
 }
@@ -1591,7 +1594,8 @@ static struct ath_ops ath9k_common_ops = {
  * to allow the separation between hardware specific
  * variables (now in ath_hw) and driver specific variables.
  */
-static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
+static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
+			  const struct ath_bus_ops *bus_ops)
 {
 	struct ath_hw *ah = NULL;
 	struct ath_common *common;
@@ -1625,6 +1629,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 
 	common = ath9k_hw_common(ah);
 	common->ops = &ath9k_common_ops;
+	common->bus_ops = bus_ops;
 	common->ah = ah;
 	common->hw = sc->hw;
 
@@ -1632,7 +1637,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	 * Cache line size is used to size and align various
 	 * structures used to communicate with the hardware.
 	 */
-	ath_read_cachesize(sc, &csz);
+	ath_read_cachesize(common, &csz);
 	/* XXX assert csz is non-zero */
 	common->cachelsz = csz << 2;	/* convert to bytes */
 
@@ -1880,7 +1885,8 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 }
 
 /* Device driver core initialization */
-int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid)
+int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
+		    const struct ath_bus_ops *bus_ops)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_common *common;
@@ -1890,7 +1896,7 @@ int ath_init_device(u16 devid, struct ath_softc *sc, u16 subsysid)
 
 	dev_dbg(sc->dev, "Attach ATH hw\n");
 
-	error = ath_init_softc(devid, sc, subsysid);
+	error = ath_init_softc(devid, sc, subsysid, bus_ops);
 	if (error != 0)
 		return error;
 
@@ -2341,8 +2347,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 					   AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(ah);
 
-		if (sc->bus_ops->bt_coex_prep)
-			sc->bus_ops->bt_coex_prep(sc);
+		if (common->bus_ops->bt_coex_prep)
+			common->bus_ops->bt_coex_prep(common);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_resume(sc);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index f59d224..a1001ff 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -31,8 +31,10 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 };
 
 /* return bus cachesize in 4B word units */
-static void ath_pci_read_cachesize(struct ath_softc *sc, int *csz)
+static void ath_pci_read_cachesize(struct ath_common *common, int *csz)
 {
+	struct ath_hw *ah = (struct ath_hw *) common->ah;
+	struct ath_softc *sc = ah->ah_sc;
 	u8 u8tmp;
 
 	pci_read_config_byte(to_pci_dev(sc->dev), PCI_CACHE_LINE_SIZE, &u8tmp);
@@ -48,8 +50,10 @@ static void ath_pci_read_cachesize(struct ath_softc *sc, int *csz)
 		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
 }
 
-static void ath_pci_cleanup(struct ath_softc *sc)
+static void ath_pci_cleanup(struct ath_common *common)
 {
+	struct ath_hw *ah = (struct ath_hw *) common->ah;
+	struct ath_softc *sc = ah->ah_sc;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 
 	pci_iounmap(pdev, sc->mem);
@@ -57,8 +61,10 @@ static void ath_pci_cleanup(struct ath_softc *sc)
 	pci_release_region(pdev, 0);
 }
 
-static bool ath_pci_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
+static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
+	struct ath_hw *ah = (struct ath_hw *) common->ah;
+
 	(void)REG_READ(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
 
 	if (!ath9k_hw_wait(ah,
@@ -78,8 +84,10 @@ static bool ath_pci_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
 /*
  * Bluetooth coexistance requires disabling ASPM.
  */
-static void ath_pci_bt_coex_prep(struct ath_softc *sc)
+static void ath_pci_bt_coex_prep(struct ath_common *common)
 {
+	struct ath_hw *ah = (struct ath_hw *) common->ah;
+	struct ath_softc *sc = ah->ah_sc;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 	u8 aspm;
 
@@ -91,7 +99,7 @@ static void ath_pci_bt_coex_prep(struct ath_softc *sc)
 	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
 }
 
-static struct ath_bus_ops ath_pci_bus_ops = {
+const static struct ath_bus_ops ath_pci_bus_ops = {
 	.read_cachesize = ath_pci_read_cachesize,
 	.cleanup = ath_pci_cleanup,
 	.eeprom_read = ath_pci_eeprom_read,
@@ -194,10 +202,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
-	sc->bus_ops = &ath_pci_bus_ops;
 
 	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsysid);
-	ret = ath_init_device(id->device, sc, subsysid);
+	ret = ath_init_device(id->device, sc, subsysid, &ath_pci_bus_ops);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize device\n");
 		goto bad3;
-- 
1.6.3.3

