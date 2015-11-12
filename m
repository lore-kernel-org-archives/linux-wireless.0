Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54968 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbbKLWA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 17:00:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v5 4/5] mac80211: use Kconfig counters to elide unnecessary code
Date: Thu, 12 Nov 2015 23:00:51 +0100
Message-Id: <1447365652-23716-5-git-send-email-johannes@sipsolutions.net> (sfid-20151112_230111_738916_50FE3439)
In-Reply-To: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are many drivers with different behaviour, but in a lot of
systems only a single driver will ever be built. In that case we
can get rid of code paths that this driver doesn't need and also
optimize the ones that it always takes to not have a check.

To make that possible, make use Kconfig counters to
 (a) the number of times each feature flag was desired
 (b) the number of mac80211 drivers built
and use Kconfig selects to select those flags that any drivers
need to be dynamic (e.g. if they can only determine this flag's
setting at runtime.)

If the dynamic request isn't set then

 if (a) > 0 then it was requested ON by at least one driver
 if (a) < (b) then it was requested OFF by at least one driver

This allows determining whether or not it's safe to elide some
code entirely.

For added safety, add a HW registration time check for it.

With our iwlwifi/mvm driver, this reduces mac80211's code size
by just over 6KB (on x86/64), or about 1%. It's not that much,
but a fair amount of it (just under 1KB) is in the TX/RX/status
paths which are the hottest code in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/Kconfig                  |  20 ++++
 drivers/net/wireless/ath/ar5523/Kconfig       |   2 +
 drivers/net/wireless/ath/ath10k/Kconfig       |   2 +
 drivers/net/wireless/ath/ath9k/Kconfig        |   2 +
 drivers/net/wireless/ath/wcn36xx/Kconfig      |   2 +
 drivers/net/wireless/b43/Kconfig              |   2 +
 drivers/net/wireless/b43legacy/Kconfig        |   2 +
 drivers/net/wireless/brcm80211/Kconfig        |   2 +
 drivers/net/wireless/cw1200/Kconfig           |   2 +
 drivers/net/wireless/iwlegacy/Kconfig         |   4 +
 drivers/net/wireless/iwlwifi/Kconfig          |   4 +
 drivers/net/wireless/mediatek/mt7601u/Kconfig |   2 +
 drivers/net/wireless/p54/Kconfig              |   2 +
 drivers/net/wireless/realtek/rtl818x/Kconfig  |   4 +
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig |   2 +
 drivers/net/wireless/realtek/rtlwifi/Kconfig  |   2 +
 drivers/net/wireless/rsi/Kconfig              |   2 +
 drivers/net/wireless/rt2x00/Kconfig           |   2 +
 drivers/net/wireless/ti/wl1251/Kconfig        |   2 +
 drivers/net/wireless/ti/wl12xx/Kconfig        |   2 +
 drivers/net/wireless/ti/wl18xx/Kconfig        |   2 +
 drivers/staging/vt6655/Kconfig                |   2 +
 drivers/staging/vt6656/Kconfig                |   2 +
 include/net/mac80211.h                        |  36 +++++-
 net/mac80211/Kconfig                          |   9 ++
 net/mac80211/Kconfig.hwflags                  | 160 ++++++++++++++++++++++++++
 net/mac80211/Makefile                         |   3 +-
 net/mac80211/main.c                           |  25 ++++
 28 files changed, 296 insertions(+), 7 deletions(-)
 create mode 100644 net/mac80211/Kconfig.hwflags

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f9f94229bf1b..873b6c7b18b8 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -35,6 +35,8 @@ config PCMCIA_RAYCS
 config LIBERTAS_THINFIRM
 	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select FW_LOADER
 	---help---
 	  A library for Marvell Libertas 8xxx devices using thinfirm.
@@ -109,6 +111,8 @@ config PCMCIA_ATMEL
 config AT76C50X_USB
         tristate "Atmel at76c503/at76c505/at76c505a USB cards"
         depends on MAC80211 && USB
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
         select FW_LOADER
         ---help---
           Enable support for USB Wireless devices using Atmel at76c503,
@@ -217,6 +221,8 @@ config USB_NET_RNDIS_WLAN
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select CRC32
 	select EEPROM_93CX6
 	---help---
@@ -246,6 +252,18 @@ source "drivers/net/wireless/realtek/rtl818x/Kconfig"
 config MAC80211_HWSIM
 	tristate "Simulated radio testing tool for mac80211"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	count MAC80211_HW_SUPPORT_FAST_XMIT
+	count MAC80211_HW_CHANCTX_STA_CSA
+	count MAC80211_HW_SUPPORTS_HT_CCK_RATES
+	count MAC80211_HW_QUEUE_CONTROL
+	count MAC80211_HW_WANT_MONITOR_VIF
+	count MAC80211_HW_AMPDU_AGGREGATION
+	count MAC80211_HW_MFP_CAPABLE
+	count MAC80211_HW_SIGNAL_DBM
+	count MAC80211_HW_TDLS_WIDER_BW
+	select MAC80211_HW_NO_AUTO_VIF_DYN
+	select MAC80211_HW_SUPPORTS_RC_TABLE_DYN
 	---help---
 	  This driver is a developer testing tool that can be used to test
 	  IEEE 802.11 networking stack (mac80211) functionality. This is not
@@ -259,6 +277,8 @@ config MAC80211_HWSIM
 config MWL8K
 	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
 	depends on MAC80211 && PCI
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	---help---
 	  This driver supports Marvell TOPDOG 802.11 wireless cards.
 
diff --git a/drivers/net/wireless/ath/ar5523/Kconfig b/drivers/net/wireless/ath/ar5523/Kconfig
index 0d320cc7769b..6534e600429d 100644
--- a/drivers/net/wireless/ath/ar5523/Kconfig
+++ b/drivers/net/wireless/ath/ar5523/Kconfig
@@ -1,6 +1,8 @@
 config AR5523
        tristate "Atheros AR5523 wireless driver support"
        depends on MAC80211 && USB
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
        select ATH_COMMON
        select FW_LOADER
        ---help---
diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 72acb822bb11..814d7d25bf1d 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -1,6 +1,8 @@
 config ATH10K
         tristate "Atheros 802.11ac wireless cards support"
         depends on MAC80211 && HAS_DMA
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select ATH_COMMON
         ---help---
           This module adds support for wireless adapters based on
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index fee0cadb0f5e..26d819208e68 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -20,6 +20,8 @@ config ATH9K_BTCOEX_SUPPORT
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211 && HAS_DMA
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select ATH9K_HW
 	select MAC80211_LEDS
 	select LEDS_CLASS
diff --git a/drivers/net/wireless/ath/wcn36xx/Kconfig b/drivers/net/wireless/ath/wcn36xx/Kconfig
index 591ebaea8265..a977a91021ac 100644
--- a/drivers/net/wireless/ath/wcn36xx/Kconfig
+++ b/drivers/net/wireless/ath/wcn36xx/Kconfig
@@ -1,6 +1,8 @@
 config WCN36XX
 	tristate "Qualcomm Atheros WCN3660/3680 support"
 	depends on MAC80211 && HAS_DMA
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	---help---
 	  This module adds support for wireless adapters based on
 	  Qualcomm Atheros WCN3660 and WCN3680 mobile chipsets.
diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index fba856032ca5..2a1f61774475 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -1,6 +1,8 @@
 config B43
 	tristate "Broadcom 43xx wireless support (mac80211 stack)"
 	depends on (BCMA_POSSIBLE || SSB_POSSIBLE) && MAC80211 && HAS_DMA
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select BCMA if B43_BCMA
 	select SSB if B43_SSB
 	select FW_LOADER
diff --git a/drivers/net/wireless/b43legacy/Kconfig b/drivers/net/wireless/b43legacy/Kconfig
index 1ffa28835c58..8ae74e50ba27 100644
--- a/drivers/net/wireless/b43legacy/Kconfig
+++ b/drivers/net/wireless/b43legacy/Kconfig
@@ -1,6 +1,8 @@
 config B43LEGACY
 	tristate "Broadcom 43xx-legacy wireless support (mac80211 stack)"
 	depends on SSB_POSSIBLE && MAC80211 && HAS_DMA
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select SSB
 	select FW_LOADER
 	---help---
diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index ab42b1fea03c..c63cb95b4191 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -4,6 +4,8 @@ config BRCMUTIL
 config BRCMSMAC
 	tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	depends on BCMA_POSSIBLE
 	select BCMA
 	select NEW_LEDS if BCMA_DRIVER_GPIO
diff --git a/drivers/net/wireless/cw1200/Kconfig b/drivers/net/wireless/cw1200/Kconfig
index 0880742eab17..06bf2fa61db0 100644
--- a/drivers/net/wireless/cw1200/Kconfig
+++ b/drivers/net/wireless/cw1200/Kconfig
@@ -1,6 +1,8 @@
 config CW1200
 	tristate "CW1200 WLAN support"
 	depends on MAC80211 && CFG80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	help
 	  This is a driver for the ST-E CW1100 & CW1200 WLAN chipsets.
 	  This option just enables the driver core, see below for
diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
index fb919727b8bb..67f8f03f421c 100644
--- a/drivers/net/wireless/iwlegacy/Kconfig
+++ b/drivers/net/wireless/iwlegacy/Kconfig
@@ -9,6 +9,8 @@ config IWLEGACY
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN (iwl4965)"
 	depends on PCI && MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select IWLEGACY
 	---help---
 	  This option enables support for
@@ -37,6 +39,8 @@ config IWL4965
 config IWL3945
 	tristate "Intel PRO/Wireless 3945ABG/BG Network Connection (iwl3945)"
 	depends on PCI && MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select IWLEGACY
 	---help---
 	  Select to build the driver supporting the:
diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 6e949df399d6..3fbee1ec1d33 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -54,6 +54,8 @@ config IWLWIFI_LEDS
 config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
 	default IWLWIFI
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	help
 	  This is the driver that supports the DVM firmware. The list
 	  of the devices that use this firmware is available here:
@@ -62,6 +64,8 @@ config IWLDVM
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
 	select WANT_DEV_COREDUMP
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	help
 	  This is the driver that supports the MVM firmware. The list
 	  of the devices that use this firmware is available here:
diff --git a/drivers/net/wireless/mediatek/mt7601u/Kconfig b/drivers/net/wireless/mediatek/mt7601u/Kconfig
index f46bed92796b..31781e2a7a11 100644
--- a/drivers/net/wireless/mediatek/mt7601u/Kconfig
+++ b/drivers/net/wireless/mediatek/mt7601u/Kconfig
@@ -1,6 +1,8 @@
 config MT7601U
 	tristate "MediaTek MT7601U (USB) support"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	depends on USB
 	---help---
 	  This adds support for MT7601U-based wireless USB dongles.
diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index cdafb8c73e82..0a60e2b5e0b1 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -1,6 +1,8 @@
 config P54_COMMON
 	tristate "Softmac Prism54 support"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select FW_LOADER
 	select CRC_CCITT
 	---help---
diff --git a/drivers/net/wireless/realtek/rtl818x/Kconfig b/drivers/net/wireless/realtek/rtl818x/Kconfig
index 1ce1d55f0010..e17dad1ad531 100644
--- a/drivers/net/wireless/realtek/rtl818x/Kconfig
+++ b/drivers/net/wireless/realtek/rtl818x/Kconfig
@@ -4,6 +4,8 @@
 config RTL8180
 	tristate "Realtek 8180/8185/8187SE PCI support"
 	depends on MAC80211 && PCI
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8180, RTL8185 and RTL8187SE based cards.
@@ -60,6 +62,8 @@ config RTL8180
 config RTL8187
 	tristate "Realtek 8187 and 8187B USB support"
 	depends on MAC80211 && USB
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8187 and RTL8187B based cards.
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
index dd4d626aecbc..c1a1d89ad6aa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
+++ b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
@@ -4,6 +4,8 @@
 config RTL8XXXU
 	tristate "RTL8723AU/RTL8188[CR]U/RTL819[12]CU (mac80211) support"
 	depends on MAC80211 && USB
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	---help---
 	  This is an alternative driver for various Realtek RTL8XXX
 	  parts written to utilize the Linux mac80211 stack.
diff --git a/drivers/net/wireless/realtek/rtlwifi/Kconfig b/drivers/net/wireless/realtek/rtlwifi/Kconfig
index 73067cac289c..bfd079c0205c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/Kconfig
+++ b/drivers/net/wireless/realtek/rtlwifi/Kconfig
@@ -1,6 +1,8 @@
 menuconfig RTL_CARDS
 	tristate "Realtek rtlwifi family of devices"
 	depends on MAC80211 && (PCI || USB)
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	default y
 	---help---
 	  This option will enable support for the Realtek mac80211-based
diff --git a/drivers/net/wireless/rsi/Kconfig b/drivers/net/wireless/rsi/Kconfig
index 35245f994c10..f206b1e38ca6 100644
--- a/drivers/net/wireless/rsi/Kconfig
+++ b/drivers/net/wireless/rsi/Kconfig
@@ -1,6 +1,8 @@
 config RSI_91X
 	tristate "Redpine Signals Inc 91x WLAN driver support"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	---help---
 	  This option enabes support for RSI 1x1 devices.
 	  Select M (recommended), if you have a RSI 1x1 wireless module.
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index de62f5dcb62f..90f9efc0cc49 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -1,6 +1,8 @@
 menuconfig RT2X00
 	tristate "Ralink driver support"
 	depends on MAC80211 && HAS_DMA
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	---help---
 	  This will enable the support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
diff --git a/drivers/net/wireless/ti/wl1251/Kconfig b/drivers/net/wireless/ti/wl1251/Kconfig
index 477a206c098e..dc6309d22e26 100644
--- a/drivers/net/wireless/ti/wl1251/Kconfig
+++ b/drivers/net/wireless/ti/wl1251/Kconfig
@@ -1,6 +1,8 @@
 menuconfig WL1251
 	tristate "TI wl1251 driver support"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select FW_LOADER
 	select CRC7
 	---help---
diff --git a/drivers/net/wireless/ti/wl12xx/Kconfig b/drivers/net/wireless/ti/wl12xx/Kconfig
index c2183594655a..48eb701e647d 100644
--- a/drivers/net/wireless/ti/wl12xx/Kconfig
+++ b/drivers/net/wireless/ti/wl12xx/Kconfig
@@ -1,6 +1,8 @@
 config WL12XX
        tristate "TI wl12xx support"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
        select WLCORE
        ---help---
 	  This module adds support for wireless adapters based on TI wl1271,
diff --git a/drivers/net/wireless/ti/wl18xx/Kconfig b/drivers/net/wireless/ti/wl18xx/Kconfig
index 1cfdb2548821..6670f41ab0b0 100644
--- a/drivers/net/wireless/ti/wl18xx/Kconfig
+++ b/drivers/net/wireless/ti/wl18xx/Kconfig
@@ -1,6 +1,8 @@
 config WL18XX
 	tristate "TI wl18xx support"
 	depends on MAC80211
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select WLCORE
 	---help---
 	  This module adds support for wireless adapters based on TI
diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
index 77cfc708c516..dfc0bfef6222 100644
--- a/drivers/staging/vt6655/Kconfig
+++ b/drivers/staging/vt6655/Kconfig
@@ -1,6 +1,8 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
    depends on PCI && MAC80211 && m
+   count MAC80211_NUM_DRIVERS
+   select MAC80211_DRIVER_NO_HWFLAGS
    ---help---
    This is a vendor-written driver for VIA VT6655.
 
diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
index b602ef175d55..f6c2811fed21 100644
--- a/drivers/staging/vt6656/Kconfig
+++ b/drivers/staging/vt6656/Kconfig
@@ -1,6 +1,8 @@
 config VT6656
 	tristate "VIA Technologies VT6656 support"
 	depends on MAC80211 && USB && WLAN && m
+	count MAC80211_NUM_DRIVERS
+	select MAC80211_DRIVER_NO_HWFLAGS
 	select FW_LOADER
 	---help---
 	This is a vendor-written driver for VIA VT6656.
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2345d3d43300..485d4a728163 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2040,12 +2040,36 @@ struct ieee80211_hw {
 	int txq_ac_max_pending;
 };
 
-static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
-				       enum ieee80211_hw_flags flg)
-{
-	return test_bit(flg, hw->flags);
-}
-#define ieee80211_hw_check(hw, flg)	_ieee80211_hw_check(hw, IEEE80211_HW_##flg)
+enum hwflags_states {
+#define __DEFINE_HWFLAG(_flg, _dyn, _on, _off)				\
+	HWFLAGS_STATE_##_flg = -1 + (!(_dyn)) * (((_on) ^ (_off)) * (1 + (_on))),
+#define DEFINE_HWFLAG(_flg)						\
+	__DEFINE_HWFLAG(_flg,						\
+			IS_ENABLED(CONFIG_MAC80211_HW_##_flg##_DYN),	\
+			CONFIG_MAC80211_HW_##_flg > 0,			\
+			CONFIG_MAC80211_HW_##_flg < CONFIG_MAC80211_NUM_DRIVERS)
+#include <net/mac80211-hwflags.h>
+#undef DEFINE_HWFLAG
+};
+
+bool _____optimisation_missing(void);
+
+#define ieee80211_hw_check(hw, flg)					\
+({									\
+	enum ieee80211_hw_flags flag = IEEE80211_HW_##flg;		\
+	bool result;							\
+									\
+	if (HWFLAGS_STATE_##flg == -1)					\
+		result = test_bit(flag, (hw)->flags);			\
+	else if (HWFLAGS_STATE_##flg == 1)				\
+		result = true;						\
+	else if (HWFLAGS_STATE_##flg == 0)				\
+		result = false;						\
+	else								\
+		result = _____optimisation_missing();			\
+									\
+	result;								\
+})
 
 static inline void _ieee80211_hw_set(struct ieee80211_hw *hw,
 				     enum ieee80211_hw_flags flg)
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 3891cbd2adea..5760dc91f468 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -11,6 +11,13 @@ config MAC80211
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
 
+config MAC80211_NUM_DRIVERS
+	int
+	depends on MAC80211
+
+config MAC80211_DRIVER_NO_HWFLAGS
+	bool
+
 comment "CFG80211 needs to be enabled for MAC80211"
 	depends on CFG80211=n
 
@@ -318,3 +325,5 @@ config MAC80211_STA_HASH_MAX_SIZE
 	  connect more stations than the number selected here.)
 
 	  If unsure, leave the default of 0.
+
+source "net/mac80211/Kconfig.hwflags"
diff --git a/net/mac80211/Kconfig.hwflags b/net/mac80211/Kconfig.hwflags
new file mode 100644
index 000000000000..43beeab9a1d8
--- /dev/null
+++ b/net/mac80211/Kconfig.hwflags
@@ -0,0 +1,160 @@
+config MAC80211_HW_HAS_RATE_CONTROL
+	int
+	default 0
+config MAC80211_HW_HAS_RATE_CONTROL_DYN
+	bool
+config MAC80211_HW_RX_INCLUDES_FCS
+	int
+	default 0
+config MAC80211_HW_RX_INCLUDES_FCS_DYN
+	bool
+config MAC80211_HW_HOST_BROADCAST_PS_BUFFERING
+	int
+	default 0
+config MAC80211_HW_HOST_BROADCAST_PS_BUFFERING_DYN
+	bool
+config MAC80211_HW_SIGNAL_UNSPEC
+	int
+	default 0
+config MAC80211_HW_SIGNAL_UNSPEC_DYN
+	bool
+config MAC80211_HW_SIGNAL_DBM
+	int
+	default 0
+config MAC80211_HW_SIGNAL_DBM_DYN
+	bool
+config MAC80211_HW_NEED_DTIM_BEFORE_ASSOC
+	int
+	default 0
+config MAC80211_HW_NEED_DTIM_BEFORE_ASSOC_DYN
+	bool
+config MAC80211_HW_SPECTRUM_MGMT
+	int
+	default 0
+config MAC80211_HW_SPECTRUM_MGMT_DYN
+	bool
+config MAC80211_HW_AMPDU_AGGREGATION
+	int
+	default 0
+config MAC80211_HW_AMPDU_AGGREGATION_DYN
+	bool
+config MAC80211_HW_SUPPORTS_PS
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_PS_DYN
+	bool
+config MAC80211_HW_PS_NULLFUNC_STACK
+	int
+	default 0
+config MAC80211_HW_PS_NULLFUNC_STACK_DYN
+	bool
+config MAC80211_HW_SUPPORTS_DYNAMIC_PS
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_DYNAMIC_PS_DYN
+	bool
+config MAC80211_HW_MFP_CAPABLE
+	int
+	default 0
+config MAC80211_HW_MFP_CAPABLE_DYN
+	bool
+config MAC80211_HW_WANT_MONITOR_VIF
+	int
+	default 0
+config MAC80211_HW_WANT_MONITOR_VIF_DYN
+	bool
+config MAC80211_HW_NO_AUTO_VIF
+	int
+	default 0
+config MAC80211_HW_NO_AUTO_VIF_DYN
+	bool
+config MAC80211_HW_SW_CRYPTO_CONTROL
+	int
+	default 0
+config MAC80211_HW_SW_CRYPTO_CONTROL_DYN
+	bool
+config MAC80211_HW_SUPPORT_FAST_XMIT
+	int
+	default 0
+config MAC80211_HW_SUPPORT_FAST_XMIT_DYN
+	bool
+config MAC80211_HW_REPORTS_TX_ACK_STATUS
+	int
+	default 0
+config MAC80211_HW_REPORTS_TX_ACK_STATUS_DYN
+	bool
+config MAC80211_HW_CONNECTION_MONITOR
+	int
+	default 0
+config MAC80211_HW_CONNECTION_MONITOR_DYN
+	bool
+config MAC80211_HW_QUEUE_CONTROL
+	int
+	default 0
+config MAC80211_HW_QUEUE_CONTROL_DYN
+	bool
+config MAC80211_HW_SUPPORTS_PER_STA_GTK
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_PER_STA_GTK_DYN
+	bool
+config MAC80211_HW_AP_LINK_PS
+	int
+	default 0
+config MAC80211_HW_AP_LINK_PS_DYN
+	bool
+config MAC80211_HW_TX_AMPDU_SETUP_IN_HW
+	int
+	default 0
+config MAC80211_HW_TX_AMPDU_SETUP_IN_HW_DYN
+	bool
+config MAC80211_HW_SUPPORTS_RC_TABLE
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_RC_TABLE_DYN
+	bool
+config MAC80211_HW_P2P_DEV_ADDR_FOR_INTF
+	int
+	default 0
+config MAC80211_HW_P2P_DEV_ADDR_FOR_INTF_DYN
+	bool
+config MAC80211_HW_TIMING_BEACON_ONLY
+	int
+	default 0
+config MAC80211_HW_TIMING_BEACON_ONLY_DYN
+	bool
+config MAC80211_HW_SUPPORTS_HT_CCK_RATES
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_HT_CCK_RATES_DYN
+	bool
+config MAC80211_HW_CHANCTX_STA_CSA
+	int
+	default 0
+config MAC80211_HW_CHANCTX_STA_CSA_DYN
+	bool
+config MAC80211_HW_SUPPORTS_CLONED_SKBS
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_CLONED_SKBS_DYN
+	bool
+config MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS
+	int
+	default 0
+config MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS_DYN
+	bool
+config MAC80211_HW_TDLS_WIDER_BW
+	int
+	default 0
+config MAC80211_HW_TDLS_WIDER_BW_DYN
+	bool
+config MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU_DYN
+	bool
+config MAC80211_HW_BEACON_TX_STATUS
+	int
+	default 0
+config MAC80211_HW_BEACON_TX_STATUS_DYN
+	bool
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index f9137a8341f4..eeff93b5f1c6 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -30,7 +30,8 @@ mac80211-y := \
 	chan.o \
 	trace.o mlme.o \
 	tdls.o \
-	ocb.o
+	ocb.o \
+	hwflags.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 858f6b1cb149..d70b9f1feb52 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -789,6 +789,28 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 	return 0;
 }
 
+static s8 hwflags_state[] = {
+#define DEFINE_HWFLAG(_flg)	\
+	[IEEE80211_HW_##_flg] = HWFLAGS_STATE_##_flg,
+#include <net/mac80211-hwflags.h>
+#undef DEFINE_HWFLAG
+};
+
+static int ieee80211_hwflags_check(unsigned long *flags)
+{
+	unsigned int flg;
+
+	for (flg = 0; flg < NUM_IEEE80211_HW_FLAGS; flg++) {
+		if (hwflags_state[flg] == -1)
+			continue;
+		if (WARN(hwflags_state[flg] != !!test_bit(flg, flags),
+			 "hw flag %d doesn't match Kconfig\n", flg))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -799,6 +821,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	netdev_features_t feature_whitelist;
 	struct cfg80211_chan_def dflt_chandef = {};
 
+	if (ieee80211_hwflags_check(local->hw.flags))
+		return -EINVAL;
+
 	if (ieee80211_hw_check(hw, QUEUE_CONTROL) &&
 	    (local->hw.offchannel_tx_hw_queue == IEEE80211_INVAL_HW_QUEUE ||
 	     local->hw.offchannel_tx_hw_queue >= local->hw.queues))
-- 
2.6.2

