Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:34729
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619AbaJYTVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:21:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 01/10] ath9k_hw: make support for PC-OEM cards optional
Date: Sat, 25 Oct 2014 17:19:26 +0200
Message-Id: <1414250375-74121-1-git-send-email-nbd@openwrt.org> (sfid-20141025_212128_447749_444B0FD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The initvals use up quite a bit of space, and PC-OEM support is
typically not needed on embedded systems

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig      |  5 ++++
 drivers/net/wireless/ath/ath9k/Makefile     |  3 ++-
 drivers/net/wireless/ath/ath9k/ar9003_rtt.h | 36 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         | 17 ++++++++++----
 drivers/net/wireless/ath/ath9k/init.c       |  3 +++
 drivers/net/wireless/ath/ath9k/pci.c        |  6 +++++
 drivers/net/wireless/ath/ath9k/reg.h        | 33 +++++++++++++++-----------
 7 files changed, 84 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 896e632..ca101d7 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -148,6 +148,11 @@ config ATH9K_CHANNEL_CONTEXT
 	 for multi-channel concurrency. Enable this if P2P PowerSave support
 	 is required.
 
+config ATH9K_PCOEM
+	bool "Atheros ath9k support for PC OEM cards" if EXPERT
+	depends on ATH9K
+	default y
+
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
        depends on USB && MAC80211
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 73704c1..22b934b 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -32,7 +32,6 @@ ath9k_hw-y:=	\
 		ar5008_phy.o \
 		ar9002_calib.o \
 		ar9003_calib.o \
-		ar9003_rtt.o \
 		calib.o \
 		eeprom.o \
 		eeprom_def.o \
@@ -50,6 +49,8 @@ ath9k_hw-$(CONFIG_ATH9K_WOW) += ar9003_wow.o
 ath9k_hw-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += btcoex.o \
 					   ar9003_mci.o
 
+ath9k_hw-$(CONFIG_ATH9K_PCOEM) += ar9003_rtt.o
+
 ath9k_hw-$(CONFIG_ATH9K_DYNACK) += dynack.o
 
 obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.h b/drivers/net/wireless/ath/ath9k/ar9003_rtt.h
index a43b30d..6290467 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_rtt.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.h
@@ -17,6 +17,7 @@
 #ifndef AR9003_RTT_H
 #define AR9003_RTT_H
 
+#ifdef CONFIG_ATH9K_PCOEM
 void ar9003_hw_rtt_enable(struct ath_hw *ah);
 void ar9003_hw_rtt_disable(struct ath_hw *ah);
 void ar9003_hw_rtt_set_mask(struct ath_hw *ah, u32 rtt_mask);
@@ -25,5 +26,40 @@ void ar9003_hw_rtt_load_hist(struct ath_hw *ah);
 void ar9003_hw_rtt_fill_hist(struct ath_hw *ah);
 void ar9003_hw_rtt_clear_hist(struct ath_hw *ah);
 bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan);
+#else
+static inline void ar9003_hw_rtt_enable(struct ath_hw *ah)
+{
+}
+
+static inline void ar9003_hw_rtt_disable(struct ath_hw *ah)
+{
+}
+
+static inline void ar9003_hw_rtt_set_mask(struct ath_hw *ah, u32 rtt_mask)
+{
+}
+
+static inline bool ar9003_hw_rtt_force_restore(struct ath_hw *ah)
+{
+	return false;
+}
+
+static inline void ar9003_hw_rtt_load_hist(struct ath_hw *ah)
+{
+}
+
+static inline void ar9003_hw_rtt_fill_hist(struct ath_hw *ah)
+{
+}
+
+static inline void ar9003_hw_rtt_clear_hist(struct ath_hw *ah)
+{
+}
+
+static inline bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	return false;
+}
+#endif
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 975074f..7a81f5b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -244,13 +244,20 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_2GHZ			= BIT(11),
 	ATH9K_HW_CAP_5GHZ			= BIT(12),
 	ATH9K_HW_CAP_APM			= BIT(13),
+#ifdef CONFIG_ATH9K_PCOEM
 	ATH9K_HW_CAP_RTT			= BIT(14),
 	ATH9K_HW_CAP_MCI			= BIT(15),
-	ATH9K_HW_CAP_DFS			= BIT(16),
-	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(17),
-	ATH9K_HW_CAP_PAPRD			= BIT(18),
-	ATH9K_HW_CAP_FCC_BAND_SWITCH		= BIT(19),
-	ATH9K_HW_CAP_BT_ANT_DIV			= BIT(20),
+	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(16),
+	ATH9K_HW_CAP_BT_ANT_DIV			= BIT(17),
+#else
+	ATH9K_HW_CAP_RTT			= 0,
+	ATH9K_HW_CAP_MCI			= 0,
+	ATH9K_HW_WOW_DEVICE_CAPABLE		= 0,
+	ATH9K_HW_CAP_BT_ANT_DIV			= 0,
+#endif
+	ATH9K_HW_CAP_DFS			= BIT(18),
+	ATH9K_HW_CAP_PAPRD			= BIT(19),
+	ATH9K_HW_CAP_FCC_BAND_SWITCH		= BIT(20),
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 3bd0304..0d80011 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -362,6 +362,9 @@ static void ath9k_init_pcoem_platform(struct ath_softc *sc)
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	if (!IS_ENABLED(CONFIG_ATH9K_PCOEM))
+		return;
+
 	if (common->bus_ops->ath_bus_type != ATH_PCI)
 		return;
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c018dea..e3f60d5 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -30,6 +30,7 @@ static const struct pci_device_id ath_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
 
+#ifdef CONFIG_ATH9K_PCOEM
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x002A,
 			 PCI_VENDOR_ID_AZWAVE,
@@ -82,6 +83,7 @@ static const struct pci_device_id ath_pci_id_table[] = {
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2C37),
 	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+#endif
 
 	{ PCI_VDEVICE(ATHEROS, 0x002B) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x002C) }, /* PCI-E 802.11n bonded out */
@@ -102,6 +104,7 @@ static const struct pci_device_id ath_pci_id_table[] = {
 
 	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
 
+#ifdef CONFIG_ATH9K_PCOEM
 	/* PCI-E CUS198 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0032,
@@ -294,10 +297,12 @@ static const struct pci_device_id ath_pci_id_table[] = {
 			 PCI_VENDOR_ID_ASUSTEK,
 			 0x850D),
 	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+#endif
 
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 
+#ifdef CONFIG_ATH9K_PCOEM
 	/* PCI-E CUS217 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0034,
@@ -657,6 +662,7 @@ static const struct pci_device_id ath_pci_id_table[] = {
 	/* PCI-E AR9565 (WB335) */
 	{ PCI_VDEVICE(ATHEROS, 0x0036),
 	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+#endif
 
 	{ 0 }
 };
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 2a938f4..1c0b1c1 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -892,10 +892,21 @@
 	(AR_SREV_9330((_ah)) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9330_12))
 
+#ifdef CONFIG_ATH9K_PCOEM
+#define AR_SREV_9462(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462))
 #define AR_SREV_9485(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485))
+#define AR_SREV_9565(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
+#else
+#define AR_SREV_9462(_ah) 0
+#define AR_SREV_9485(_ah) 0
+#define AR_SREV_9565(_ah) 0
+#endif
+
 #define AR_SREV_9485_11_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9485) && \
+	(AR_SREV_9485(_ah) && \
 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9485_11))
 #define AR_SREV_9485_OR_LATER(_ah) \
 	(((_ah)->hw_version.macVersion >= AR_SREV_VERSION_9485))
@@ -915,34 +926,30 @@
     (AR_SREV_9285_12_OR_LATER(_ah) && \
      ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
 
-#define AR_SREV_9462(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462))
 #define AR_SREV_9462_20(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	(AR_SREV_9462(_ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_20))
 #define AR_SREV_9462_21(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	(AR_SREV_9462(_ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9462_21))
 #define AR_SREV_9462_20_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	(AR_SREV_9462(_ah) && \
 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
 #define AR_SREV_9462_21_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
+	(AR_SREV_9462(_ah) && \
 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_21))
 
-#define AR_SREV_9565(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565))
 #define AR_SREV_9565_10(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
+	(AR_SREV_9565(_ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9565_10))
 #define AR_SREV_9565_101(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
+	(AR_SREV_9565(_ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9565_101))
 #define AR_SREV_9565_11(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
+	(AR_SREV_9565(_ah) && \
 	 ((_ah)->hw_version.macRev == AR_SREV_REVISION_9565_11))
 #define AR_SREV_9565_11_OR_LATER(_ah) \
-	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9565) && \
+	(AR_SREV_9565(_ah) && \
 	 ((_ah)->hw_version.macRev >= AR_SREV_REVISION_9565_11))
 
 #define AR_SREV_9550(_ah) \
-- 
2.1.2

