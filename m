Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:59731 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbXKSPTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 10:19:33 -0500
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw: port to mac80211
Message-Id: <20071119150029.9C0659D4B4F@zog.reactivated.net> (sfid-20071119_151942_925640_D9F933A3)
Date: Mon, 19 Nov 2007 15:00:29 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems to be working smoothly now. Let's not hold back the mac80211
transition any further. This patch ports the existing driver from softmac
to mac80211.

Many thanks to everyone who helped out with the porting efforts.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/zd1211rw/Kconfig        |    7 +-
 drivers/net/wireless/zd1211rw/Makefile       |    3 +-
 drivers/net/wireless/zd1211rw/zd_chip.c      |  121 +--
 drivers/net/wireless/zd1211rw/zd_chip.h      |   55 +-
 drivers/net/wireless/zd1211rw/zd_ieee80211.c |  191 +---
 drivers/net/wireless/zd1211rw/zd_ieee80211.h |   29 +-
 drivers/net/wireless/zd1211rw/zd_mac.c       | 1530 ++++++++++----------------
 drivers/net/wireless/zd1211rw/zd_mac.h       |  112 +-
 drivers/net/wireless/zd1211rw/zd_netdev.c    |  264 -----
 drivers/net/wireless/zd1211rw/zd_netdev.h    |   45 -
 drivers/net/wireless/zd1211rw/zd_usb.c       |  282 ++++--
 drivers/net/wireless/zd1211rw/zd_usb.h       |   31 +-
 12 files changed, 1008 insertions(+), 1662 deletions(-)
 delete mode 100644 drivers/net/wireless/zd1211rw/zd_netdev.c
 delete mode 100644 drivers/net/wireless/zd1211rw/zd_netdev.h

diff --git a/drivers/net/wireless/zd1211rw/Kconfig b/drivers/net/wireless/zd1211rw/Kconfig
index d1ab24a..74b31ea 100644
--- a/drivers/net/wireless/zd1211rw/Kconfig
+++ b/drivers/net/wireless/zd1211rw/Kconfig
@@ -1,14 +1,13 @@
 config ZD1211RW
 	tristate "ZyDAS ZD1211/ZD1211B USB-wireless support"
-	depends on USB && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
-	select WIRELESS_EXT
+	depends on USB && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
 	---help---
 	  This is an experimental driver for the ZyDAS ZD1211/ZD1211B wireless
 	  chip, present in many USB-wireless adapters.
 
-	  Device firmware is required alongside this driver. You can download the
-	  firmware distribution from http://zd1211.ath.cx/get-firmware
+	  Device firmware is required alongside this driver. You can download
+	  the firmware distribution from http://zd1211.ath.cx/get-firmware
 
 config ZD1211RW_DEBUG
 	bool "ZyDAS ZD1211 debugging"
diff --git a/drivers/net/wireless/zd1211rw/Makefile b/drivers/net/wireless/zd1211rw/Makefile
index 7a2f2a9..cc36126 100644
--- a/drivers/net/wireless/zd1211rw/Makefile
+++ b/drivers/net/wireless/zd1211rw/Makefile
@@ -1,7 +1,6 @@
 obj-$(CONFIG_ZD1211RW) += zd1211rw.o
 
-zd1211rw-objs := zd_chip.o zd_ieee80211.o \
-		zd_mac.o zd_netdev.o \
+zd1211rw-objs := zd_chip.o zd_ieee80211.o zd_mac.o \
 		zd_rf_al2230.o zd_rf_rf2959.o \
 		zd_rf_al7230b.o zd_rf_uw2453.o \
 		zd_rf.o zd_usb.o
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index f831b68..ef9527c 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -30,12 +30,12 @@
 #include "zd_rf.h"
 
 void zd_chip_init(struct zd_chip *chip,
-	         struct net_device *netdev,
+	         struct ieee80211_hw *hw,
 		 struct usb_interface *intf)
 {
 	memset(chip, 0, sizeof(*chip));
 	mutex_init(&chip->mutex);
-	zd_usb_init(&chip->usb, netdev, intf);
+	zd_usb_init(&chip->usb, hw, intf);
 	zd_rf_init(&chip->rf);
 }
 
@@ -50,7 +50,7 @@ void zd_chip_clear(struct zd_chip *chip)
 
 static int scnprint_mac_oui(struct zd_chip *chip, char *buffer, size_t size)
 {
-	u8 *addr = zd_usb_to_netdev(&chip->usb)->dev_addr;
+	u8 *addr = zd_mac_get_perm_addr(zd_chip_to_mac(chip));
 	return scnprintf(buffer, size, "%02x-%02x-%02x",
 		         addr[0], addr[1], addr[2]);
 }
@@ -378,15 +378,18 @@ int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
 	};
 	DECLARE_MAC_BUF(mac);
 
-	reqs[0].value = (mac_addr[3] << 24)
-		      | (mac_addr[2] << 16)
-		      | (mac_addr[1] <<  8)
-		      |  mac_addr[0];
-	reqs[1].value = (mac_addr[5] <<  8)
-		      |  mac_addr[4];
-
-	dev_dbg_f(zd_chip_dev(chip),
-		"mac addr %s\n", print_mac(mac, mac_addr));
+	if (mac_addr) {
+		reqs[0].value = (mac_addr[3] << 24)
+			      | (mac_addr[2] << 16)
+			      | (mac_addr[1] <<  8)
+			      |  mac_addr[0];
+		reqs[1].value = (mac_addr[5] <<  8)
+			      |  mac_addr[4];
+		dev_dbg_f(zd_chip_dev(chip),
+			"mac addr %s\n", print_mac(mac, mac_addr));
+	} else {
+		dev_dbg_f(zd_chip_dev(chip), "set NULL mac\n");
+	}
 
 	mutex_lock(&chip->mutex);
 	r = zd_iowrite32a_locked(chip, reqs, ARRAY_SIZE(reqs));
@@ -980,7 +983,7 @@ static int print_fw_version(struct zd_chip *chip)
 	return 0;
 }
 
-static int set_mandatory_rates(struct zd_chip *chip, enum ieee80211_std std)
+static int set_mandatory_rates(struct zd_chip *chip, int mode)
 {
 	u32 rates;
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
@@ -988,11 +991,11 @@ static int set_mandatory_rates(struct zd_chip *chip, enum ieee80211_std std)
 	 * that the device is supporting. Until further notice we should try
 	 * to support 802.11g also for full speed USB.
 	 */
-	switch (std) {
-	case IEEE80211B:
+	switch (mode) {
+	case MODE_IEEE80211B:
 		rates = CR_RATE_1M|CR_RATE_2M|CR_RATE_5_5M|CR_RATE_11M;
 		break;
-	case IEEE80211G:
+	case MODE_IEEE80211G:
 		rates = CR_RATE_1M|CR_RATE_2M|CR_RATE_5_5M|CR_RATE_11M|
 			CR_RATE_6M|CR_RATE_12M|CR_RATE_24M;
 		break;
@@ -1003,24 +1006,17 @@ static int set_mandatory_rates(struct zd_chip *chip, enum ieee80211_std std)
 }
 
 int zd_chip_set_rts_cts_rate_locked(struct zd_chip *chip,
-	u8 rts_rate, int preamble)
+				    int preamble)
 {
-	int rts_mod = ZD_RX_CCK;
 	u32 value = 0;
 
-	/* Modulation bit */
-	if (ZD_MODULATION_TYPE(rts_rate) == ZD_OFDM)
-		rts_mod = ZD_RX_OFDM;
-
-	dev_dbg_f(zd_chip_dev(chip), "rts_rate=%x preamble=%x\n",
-		rts_rate, preamble);
-
-	value |= ZD_PURE_RATE(rts_rate) << RTSCTS_SH_RTS_RATE;
-	value |= rts_mod << RTSCTS_SH_RTS_MOD_TYPE;
+	dev_dbg_f(zd_chip_dev(chip), "preamble=%x\n", preamble);
 	value |= preamble << RTSCTS_SH_RTS_PMB_TYPE;
 	value |= preamble << RTSCTS_SH_CTS_PMB_TYPE;
 
-	/* We always send 11M self-CTS messages, like the vendor driver. */
+	/* We always send 11M RTS/self-CTS messages, like the vendor driver. */
+	value |= ZD_PURE_RATE(ZD_CCK_RATE_11M) << RTSCTS_SH_RTS_RATE;
+	value |= ZD_RX_CCK << RTSCTS_SH_RTS_MOD_TYPE;
 	value |= ZD_PURE_RATE(ZD_CCK_RATE_11M) << RTSCTS_SH_CTS_RATE;
 	value |= ZD_RX_CCK << RTSCTS_SH_CTS_MOD_TYPE;
 
@@ -1109,7 +1105,7 @@ int zd_chip_init_hw(struct zd_chip *chip)
 	 * It might be discussed, whether we should suppport pure b mode for
 	 * full speed USB.
 	 */
-	r = set_mandatory_rates(chip, IEEE80211G);
+	r = set_mandatory_rates(chip, MODE_IEEE80211G);
 	if (r)
 		goto out;
 	/* Disabling interrupts is certainly a smart thing here.
@@ -1320,12 +1316,17 @@ out:
 	return r;
 }
 
-int zd_chip_set_basic_rates_locked(struct zd_chip *chip, u16 cr_rates)
+int zd_chip_set_basic_rates(struct zd_chip *chip, u16 cr_rates)
 {
-	ZD_ASSERT((cr_rates & ~(CR_RATES_80211B | CR_RATES_80211G)) == 0);
-	dev_dbg_f(zd_chip_dev(chip), "%x\n", cr_rates);
+	int r;
+
+	if (cr_rates & ~(CR_RATES_80211B|CR_RATES_80211G))
+		return -EINVAL;
 
-	return zd_iowrite32_locked(chip, cr_rates, CR_BASIC_RATE_TBL);
+	mutex_lock(&chip->mutex);
+	r = zd_iowrite32_locked(chip, cr_rates, CR_BASIC_RATE_TBL);
+	mutex_unlock(&chip->mutex);
+	return r;
 }
 
 static int ofdm_qual_db(u8 status_quality, u8 zd_rate, unsigned int size)
@@ -1468,56 +1469,44 @@ u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
 {
 	return (status->frame_status&ZD_RX_OFDM) ?
 		ofdm_qual_percent(status->signal_quality_ofdm,
-					  zd_rate_from_ofdm_plcp_header(rx_frame),
+				  zd_rate_from_ofdm_plcp_header(rx_frame),
 			          size) :
 		cck_qual_percent(status->signal_quality_cck);
 }
 
-u8 zd_rx_strength_percent(u8 rssi)
-{
-	int r = (rssi*100) / 41;
-	if (r > 100)
-		r = 100;
-	return (u8) r;
-}
-
-u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status)
+/**
+ * zd_rx_rate - report zd-rate
+ * @rx_frame - received frame
+ * @rx_status - rx_status as given by the device
+ *
+ * This function converts the rate as encoded in the received packet to the
+ * zd-rate, we are using on other places in the driver.
+ */
+u8 zd_rx_rate(const void *rx_frame, const struct rx_status *status)
 {
-	static const u16 ofdm_rates[] = {
-		[ZD_OFDM_PLCP_RATE_6M]  = 60,
-		[ZD_OFDM_PLCP_RATE_9M]  = 90,
-		[ZD_OFDM_PLCP_RATE_12M] = 120,
-		[ZD_OFDM_PLCP_RATE_18M] = 180,
-		[ZD_OFDM_PLCP_RATE_24M] = 240,
-		[ZD_OFDM_PLCP_RATE_36M] = 360,
-		[ZD_OFDM_PLCP_RATE_48M] = 480,
-		[ZD_OFDM_PLCP_RATE_54M] = 540,
-	};
-	u16 rate;
+	u8 zd_rate;
 	if (status->frame_status & ZD_RX_OFDM) {
-		/* Deals with PLCP OFDM rate (not zd_rates) */
-		u8 ofdm_rate = zd_ofdm_plcp_header_rate(rx_frame);
-		rate = ofdm_rates[ofdm_rate & 0xf];
+		zd_rate = zd_rate_from_ofdm_plcp_header(rx_frame);
 	} else {
 		switch (zd_cck_plcp_header_signal(rx_frame)) {
 		case ZD_CCK_PLCP_SIGNAL_1M:
-			rate = 10;
+			zd_rate = ZD_CCK_RATE_1M;
 			break;
 		case ZD_CCK_PLCP_SIGNAL_2M:
-			rate = 20;
+			zd_rate = ZD_CCK_RATE_2M;
 			break;
 		case ZD_CCK_PLCP_SIGNAL_5M5:
-			rate = 55;
+			zd_rate = ZD_CCK_RATE_5_5M;
 			break;
 		case ZD_CCK_PLCP_SIGNAL_11M:
-			rate = 110;
+			zd_rate = ZD_CCK_RATE_11M;
 			break;
 		default:
-			rate = 0;
+			zd_rate = 0;
 		}
 	}
 
-	return rate;
+	return zd_rate;
 }
 
 int zd_chip_switch_radio_on(struct zd_chip *chip)
@@ -1557,20 +1546,22 @@ void zd_chip_disable_int(struct zd_chip *chip)
 	mutex_unlock(&chip->mutex);
 }
 
-int zd_chip_enable_rx(struct zd_chip *chip)
+int zd_chip_enable_rxtx(struct zd_chip *chip)
 {
 	int r;
 
 	mutex_lock(&chip->mutex);
+	zd_usb_enable_tx(&chip->usb);
 	r = zd_usb_enable_rx(&chip->usb);
 	mutex_unlock(&chip->mutex);
 	return r;
 }
 
-void zd_chip_disable_rx(struct zd_chip *chip)
+void zd_chip_disable_rxtx(struct zd_chip *chip)
 {
 	mutex_lock(&chip->mutex);
 	zd_usb_disable_rx(&chip->usb);
+	zd_usb_disable_tx(&chip->usb);
 	mutex_unlock(&chip->mutex);
 }
 
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index 8009b70..a88a569 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -433,9 +433,10 @@ enum {
 #define CR_GROUP_HASH_P2		CTL_REG(0x0628)
 
 #define CR_RX_TIMEOUT			CTL_REG(0x062C)
+
 /* Basic rates supported by the BSS. When producing ACK or CTS messages, the
  * device will use a rate in this table that is less than or equal to the rate
- * of the incoming frame which prompted the response */
+ * of the incoming frame which prompted the response. */
 #define CR_BASIC_RATE_TBL		CTL_REG(0x0630)
 #define CR_RATE_1M	(1 <<  0)	/* 802.11b */
 #define CR_RATE_2M	(1 <<  1)	/* 802.11b */
@@ -509,14 +510,37 @@ enum {
 #define CR_UNDERRUN_CNT			CTL_REG(0x0688)
 
 #define CR_RX_FILTER			CTL_REG(0x068c)
+#define RX_FILTER_ASSOC_REQUEST		(1 <<  0)
 #define RX_FILTER_ASSOC_RESPONSE	(1 <<  1)
+#define RX_FILTER_REASSOC_REQUEST	(1 <<  2)
 #define RX_FILTER_REASSOC_RESPONSE	(1 <<  3)
+#define RX_FILTER_PROBE_REQUEST		(1 <<  4)
 #define RX_FILTER_PROBE_RESPONSE	(1 <<  5)
+/* bits 6 and 7 reserved */
 #define RX_FILTER_BEACON		(1 <<  8)
+#define RX_FILTER_ATIM			(1 <<  9)
 #define RX_FILTER_DISASSOC		(1 << 10)
 #define RX_FILTER_AUTH			(1 << 11)
-#define AP_RX_FILTER			0x0400feff
-#define STA_RX_FILTER			0x0000ffff
+#define RX_FILTER_DEAUTH		(1 << 12)
+#define RX_FILTER_PSPOLL		(1 << 26)
+#define RX_FILTER_RTS			(1 << 27)
+#define RX_FILTER_CTS			(1 << 28)
+#define RX_FILTER_ACK			(1 << 29)
+#define RX_FILTER_CFEND			(1 << 30)
+#define RX_FILTER_CFACK			(1 << 31)
+
+/* Enable bits for all frames you are interested in. */
+#define STA_RX_FILTER	(RX_FILTER_ASSOC_REQUEST | RX_FILTER_ASSOC_RESPONSE | \
+	RX_FILTER_REASSOC_REQUEST | RX_FILTER_REASSOC_RESPONSE | \
+	RX_FILTER_PROBE_REQUEST | RX_FILTER_PROBE_RESPONSE | \
+	(0x3 << 6) /* vendor driver sets these reserved bits */ | \
+	RX_FILTER_BEACON | RX_FILTER_ATIM | RX_FILTER_DISASSOC | \
+	RX_FILTER_AUTH | RX_FILTER_DEAUTH | \
+	(0x7 << 13) /* vendor driver sets these reserved bits */ | \
+	RX_FILTER_PSPOLL | RX_FILTER_ACK) /* 0x2400ffff */
+
+#define RX_FILTER_CTRL (RX_FILTER_RTS | RX_FILTER_CTS | \
+	RX_FILTER_CFEND | RX_FILTER_CFACK)
 
 /* Monitor mode sets filter to 0xfffff */
 
@@ -730,7 +754,7 @@ static inline struct zd_chip *zd_rf_to_chip(struct zd_rf *rf)
 #define zd_chip_dev(chip) (&(chip)->usb.intf->dev)
 
 void zd_chip_init(struct zd_chip *chip,
-	         struct net_device *netdev,
+	         struct ieee80211_hw *hw,
 	         struct usb_interface *intf);
 void zd_chip_clear(struct zd_chip *chip);
 int zd_chip_read_mac_addr_fw(struct zd_chip *chip, u8 *addr);
@@ -835,14 +859,12 @@ int zd_chip_switch_radio_on(struct zd_chip *chip);
 int zd_chip_switch_radio_off(struct zd_chip *chip);
 int zd_chip_enable_int(struct zd_chip *chip);
 void zd_chip_disable_int(struct zd_chip *chip);
-int zd_chip_enable_rx(struct zd_chip *chip);
-void zd_chip_disable_rx(struct zd_chip *chip);
+int zd_chip_enable_rxtx(struct zd_chip *chip);
+void zd_chip_disable_rxtx(struct zd_chip *chip);
 int zd_chip_enable_hwint(struct zd_chip *chip);
 int zd_chip_disable_hwint(struct zd_chip *chip);
 int zd_chip_generic_patch_6m_band(struct zd_chip *chip, int channel);
-
-int zd_chip_set_rts_cts_rate_locked(struct zd_chip *chip,
-	u8 rts_rate, int preamble);
+int zd_chip_set_rts_cts_rate_locked(struct zd_chip *chip, int preamble);
 
 static inline int zd_get_encryption_type(struct zd_chip *chip, u32 *type)
 {
@@ -859,17 +881,7 @@ static inline int zd_chip_get_basic_rates(struct zd_chip *chip, u16 *cr_rates)
 	return zd_ioread16(chip, CR_BASIC_RATE_TBL, cr_rates);
 }
 
-int zd_chip_set_basic_rates_locked(struct zd_chip *chip, u16 cr_rates);
-
-static inline int zd_chip_set_basic_rates(struct zd_chip *chip, u16 cr_rates)
-{
-	int r;
-
-	mutex_lock(&chip->mutex);
-	r = zd_chip_set_basic_rates_locked(chip, cr_rates);
-	mutex_unlock(&chip->mutex);
-	return r;
-}
+int zd_chip_set_basic_rates(struct zd_chip *chip, u16 cr_rates);
 
 int zd_chip_lock_phy_regs(struct zd_chip *chip);
 int zd_chip_unlock_phy_regs(struct zd_chip *chip);
@@ -893,9 +905,8 @@ struct rx_status;
 
 u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
 	               const struct rx_status *status);
-u8 zd_rx_strength_percent(u8 rssi);
 
-u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status);
+u8 zd_rx_rate(const void *rx_frame, const struct rx_status *status);
 
 struct zd_mc_hash {
 	u32 low;
diff --git a/drivers/net/wireless/zd1211rw/zd_ieee80211.c b/drivers/net/wireless/zd1211rw/zd_ieee80211.c
index 189160e..77cfe5e 100644
--- a/drivers/net/wireless/zd1211rw/zd_ieee80211.c
+++ b/drivers/net/wireless/zd1211rw/zd_ieee80211.c
@@ -16,178 +16,85 @@
  */
 
 /*
- * A lot of this code is generic and should be moved into the upper layers
- * at some point.
+ * In the long term, we'll probably find a better way of handling regulatory
+ * requirements outside of the driver.
  */
 
-#include <linux/errno.h>
-#include <linux/wireless.h>
 #include <linux/kernel.h>
-#include <net/ieee80211.h>
+#include <net/mac80211.h>
 
-#include "zd_def.h"
 #include "zd_ieee80211.h"
 #include "zd_mac.h"
 
+struct channel_range {
+	u8 regdomain;
+	u8 start;
+	u8 end; /* exclusive (channel must be less than end) */
+};
+
 static const struct channel_range channel_ranges[] = {
-	[0]			 = { 0,  0},
-	[ZD_REGDOMAIN_FCC]	 = { 1, 12},
-	[ZD_REGDOMAIN_IC]	 = { 1, 12},
-	[ZD_REGDOMAIN_ETSI]	 = { 1, 14},
-	[ZD_REGDOMAIN_JAPAN]	 = { 1, 14},
-	[ZD_REGDOMAIN_SPAIN]	 = { 1, 14},
-	[ZD_REGDOMAIN_FRANCE]	 = { 1, 14},
+	{ ZD_REGDOMAIN_FCC,		1, 12 },
+	{ ZD_REGDOMAIN_IC,		1, 12 },
+	{ ZD_REGDOMAIN_ETSI,		1, 14 },
+	{ ZD_REGDOMAIN_JAPAN,		1, 14 },
+	{ ZD_REGDOMAIN_SPAIN,		1, 14 },
+	{ ZD_REGDOMAIN_FRANCE,		1, 14 },
 
 	/* Japan originally only had channel 14 available (see CHNL_ID 0x40 in
 	 * 802.11). However, in 2001 the range was extended to include channels
 	 * 1-13. The ZyDAS devices still use the old region code but are
 	 * designed to allow the extra channel access in Japan. */
-	[ZD_REGDOMAIN_JAPAN_ADD] = { 1, 15},
+	{ ZD_REGDOMAIN_JAPAN_ADD,	1, 15 },
 };
 
-const struct channel_range *zd_channel_range(u8 regdomain)
-{
-	if (regdomain >= ARRAY_SIZE(channel_ranges))
-		regdomain = 0;
-	return &channel_ranges[regdomain];
-}
-
-int zd_regdomain_supports_channel(u8 regdomain, u8 channel)
-{
-	const struct channel_range *range = zd_channel_range(regdomain);
-	return range->start <= channel && channel < range->end;
-}
-
-int zd_regdomain_supported(u8 regdomain)
+static const struct channel_range *zd_channel_range(u8 regdomain)
 {
-	const struct channel_range *range = zd_channel_range(regdomain);
-	return range->start != 0;
-}
-
-/* Stores channel frequencies in MHz. */
-static const u16 channel_frequencies[] = {
-	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447,
-	2452, 2457, 2462, 2467, 2472, 2484,
-};
-
-#define NUM_CHANNELS ARRAY_SIZE(channel_frequencies)
-
-static int compute_freq(struct iw_freq *freq, u32 mhz, u32 hz)
-{
-	u32 factor;
-
-	freq->e = 0;
-	if (mhz >= 1000000000U) {
-		pr_debug("zd1211 mhz %u to large\n", mhz);
-		freq->m = 0;
-		return -EINVAL;
-	}
-
-	factor = 1000;
-	while (mhz >= factor) {
-
-		freq->e += 1;
-		factor *= 10;
-	}
-
-	factor /= 1000U;
-	freq->m = mhz * (1000000U/factor) + hz/factor;
-
-	return 0;
-}
-
-int zd_channel_to_freq(struct iw_freq *freq, u8 channel)
-{
-	if (channel > NUM_CHANNELS) {
-		freq->m = 0;
-		freq->e = 0;
-		return -EINVAL;
-	}
-	if (!channel) {
-		freq->m = 0;
-		freq->e = 0;
-		return -EINVAL;
+	int i;
+	for (i = 0; i < ARRAY_SIZE(channel_ranges); i++) {
+		const struct channel_range *range = &channel_ranges[i];
+		if (range->regdomain == regdomain)
+			return range;
 	}
-	return compute_freq(freq, channel_frequencies[channel-1], 0);
+	return NULL;
 }
 
-static int freq_to_mhz(const struct iw_freq *freq)
-{
-	u32 factor;
-	int e;
-
-	/* Such high frequencies are not supported. */
-	if (freq->e > 6)
-		return -EINVAL;
-
-	factor = 1;
-	for (e = freq->e; e > 0; --e) {
-		factor *= 10;
-	}
-	factor = 1000000U / factor;
-
-	if (freq->m % factor) {
-		return -EINVAL;
-	}
-
-	return freq->m / factor;
-}
+#define CHAN_TO_IDX(chan) ((chan) - 1)
 
-int zd_find_channel(u8 *channel, const struct iw_freq *freq)
+static void unmask_bg_channels(struct ieee80211_hw *hw,
+	const struct channel_range *range,
+	struct ieee80211_hw_mode *mode)
 {
-	int i, r;
-	u32 mhz;
-
-	if (freq->m < 1000) {
-		if (freq->m  > NUM_CHANNELS || freq->m == 0)
-			return -EINVAL;
-		*channel = freq->m;
-		return 1;
-	}
-
-	r = freq_to_mhz(freq);
-	if (r < 0)
-		return r;
-	mhz = r;
+	u8 channel;
 
-	for (i = 0; i < NUM_CHANNELS; i++) {
-		if (mhz == channel_frequencies[i]) {
-			*channel = i+1;
-			return 1;
-		}
+	for (channel = range->start; channel < range->end; channel++) {
+		struct ieee80211_channel *chan =
+			&mode->channels[CHAN_TO_IDX(channel)];
+		chan->flag |= IEEE80211_CHAN_W_SCAN |
+			IEEE80211_CHAN_W_ACTIVE_SCAN |
+			IEEE80211_CHAN_W_IBSS;
 	}
-
-	return -EINVAL;
 }
 
-int zd_geo_init(struct ieee80211_device *ieee, u8 regdomain)
+void zd_geo_init(struct ieee80211_hw *hw, u8 regdomain)
 {
-	struct ieee80211_geo geo;
+	struct zd_mac *mac = zd_hw_mac(hw);
 	const struct channel_range *range;
-	int i;
-	u8 channel;
 
-	dev_dbg(zd_mac_dev(zd_netdev_mac(ieee->dev)),
-		"regdomain %#04x\n", regdomain);
+	dev_dbg(zd_mac_dev(mac), "regdomain %#02x\n", regdomain);
 
 	range = zd_channel_range(regdomain);
-	if (range->start == 0) {
-		dev_err(zd_mac_dev(zd_netdev_mac(ieee->dev)),
-			"zd1211 regdomain %#04x not supported\n",
-			regdomain);
-		return -EINVAL;
+	if (!range) {
+		/* The vendor driver overrides the regulatory domain and
+		 * allowed channel registers and unconditionally restricts
+		 * available channels to 1-11 everywhere. Match their
+		 * questionable behaviour only for regdomains which we don't
+		 * recognise. */
+		dev_warn(zd_mac_dev(mac), "Unrecognised regulatory domain: "
+			"%#02x. Defaulting to FCC.\n", regdomain);
+		range = zd_channel_range(ZD_REGDOMAIN_FCC);
 	}
 
-	memset(&geo, 0, sizeof(geo));
-
-	for (i = 0, channel = range->start; channel < range->end; channel++) {
-		struct ieee80211_channel *chan = &geo.bg[i++];
-		chan->freq = channel_frequencies[channel - 1];
-		chan->channel = channel;
-	}
-
-	geo.bg_channels = i;
-	memcpy(geo.name, "XX ", 4);
-	ieee80211_set_geo(ieee, &geo);
-	return 0;
+	unmask_bg_channels(hw, range, &mac->modes[0]);
+	unmask_bg_channels(hw, range, &mac->modes[1]);
 }
+
diff --git a/drivers/net/wireless/zd1211rw/zd_ieee80211.h b/drivers/net/wireless/zd1211rw/zd_ieee80211.h
index fbf6491..98b87cf 100644
--- a/drivers/net/wireless/zd1211rw/zd_ieee80211.h
+++ b/drivers/net/wireless/zd1211rw/zd_ieee80211.h
@@ -1,7 +1,7 @@
 #ifndef _ZD_IEEE80211_H
 #define _ZD_IEEE80211_H
 
-#include <net/ieee80211.h>
+#include <net/mac80211.h>
 
 /* Additional definitions from the standards.
  */
@@ -19,22 +19,7 @@ enum {
 	MAX_CHANNEL24 = 14,
 };
 
-struct channel_range {
-	u8 start;
-	u8 end; /* exclusive (channel must be less than end) */
-};
-
-struct iw_freq;
-
-int zd_geo_init(struct ieee80211_device *ieee, u8 regdomain);
-
-const struct channel_range *zd_channel_range(u8 regdomain);
-int zd_regdomain_supports_channel(u8 regdomain, u8 channel);
-int zd_regdomain_supported(u8 regdomain);
-
-/* for 2.4 GHz band */
-int zd_channel_to_freq(struct iw_freq *freq, u8 channel);
-int zd_find_channel(u8 *channel, const struct iw_freq *freq);
+void zd_geo_init(struct ieee80211_hw *hw, u8 regdomain);
 
 #define ZD_PLCP_SERVICE_LENGTH_EXTENSION 0x80
 
@@ -54,8 +39,8 @@ static inline u8 zd_ofdm_plcp_header_rate(const struct ofdm_plcp_header *header)
  *
  * See the struct zd_ctrlset definition in zd_mac.h.
  */
-#define ZD_OFDM_PLCP_RATE_6M		0xb
-#define ZD_OFDM_PLCP_RATE_9M		0xf
+#define ZD_OFDM_PLCP_RATE_6M	0xb
+#define ZD_OFDM_PLCP_RATE_9M	0xf
 #define ZD_OFDM_PLCP_RATE_12M	0xa
 #define ZD_OFDM_PLCP_RATE_18M	0xe
 #define ZD_OFDM_PLCP_RATE_24M	0x9
@@ -87,10 +72,4 @@ static inline u8 zd_cck_plcp_header_signal(const struct cck_plcp_header *header)
 #define ZD_CCK_PLCP_SIGNAL_5M5	0x37
 #define ZD_CCK_PLCP_SIGNAL_11M	0x6e
 
-enum ieee80211_std {
-	IEEE80211B = 0x01,
-	IEEE80211A = 0x02,
-	IEEE80211G = 0x04,
-};
-
 #endif /* _ZD_IEEE80211_H */
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index a903645..aaffd08 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1,5 +1,7 @@
 /* zd_mac.c
  *
+ * Copyright (c) 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -17,7 +19,6 @@
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
 #include <linux/usb.h>
 #include <linux/jiffies.h>
 #include <net/ieee80211_radiotap.h>
@@ -26,81 +27,105 @@
 #include "zd_chip.h"
 #include "zd_mac.h"
 #include "zd_ieee80211.h"
-#include "zd_netdev.h"
 #include "zd_rf.h"
 
-static void ieee_init(struct ieee80211_device *ieee);
-static void softmac_init(struct ieee80211softmac_device *sm);
-static void set_rts_cts_work(struct work_struct *work);
-static void set_basic_rates_work(struct work_struct *work);
+/* This table contains the hardware specific values for the modulation rates. */
+static const struct ieee80211_rate zd_rates[] = {
+	{ .rate = 10,
+	  .val = ZD_CCK_RATE_1M,
+	  .flags = IEEE80211_RATE_CCK },
+	{ .rate = 20,
+	  .val = ZD_CCK_RATE_2M,
+	  .val2 = ZD_CCK_RATE_2M | ZD_CCK_PREA_SHORT,
+	  .flags = IEEE80211_RATE_CCK_2 },
+	{ .rate = 55,
+	  .val = ZD_CCK_RATE_5_5M,
+	  .val2 = ZD_CCK_RATE_5_5M | ZD_CCK_PREA_SHORT,
+	  .flags = IEEE80211_RATE_CCK_2 },
+	{ .rate = 110,
+	  .val = ZD_CCK_RATE_11M,
+	  .val2 = ZD_CCK_RATE_11M | ZD_CCK_PREA_SHORT,
+	  .flags = IEEE80211_RATE_CCK_2 },
+	{ .rate = 60,
+	  .val = ZD_OFDM_RATE_6M,
+	  .flags = IEEE80211_RATE_OFDM },
+	{ .rate = 90,
+	  .val = ZD_OFDM_RATE_9M,
+	  .flags = IEEE80211_RATE_OFDM },
+	{ .rate = 120,
+	  .val = ZD_OFDM_RATE_12M,
+	  .flags = IEEE80211_RATE_OFDM },
+	{ .rate = 180,
+	  .val = ZD_OFDM_RATE_18M,
+	  .flags = IEEE80211_RATE_OFDM },
+	{ .rate = 240,
+	  .val = ZD_OFDM_RATE_24M,
+	  .flags = IEEE80211_RATE_OFDM },
+	{ .rate = 360,
+	  .val = ZD_OFDM_RATE_36M,
+	  .flags = IEEE80211_RATE_OFDM },
+	{ .rate = 480,
+	  .val = ZD_OFDM_RATE_48M,
+	  .flags = IEEE80211_RATE_OFDM },
+	{ .rate = 540,
+	  .val = ZD_OFDM_RATE_54M,
+	  .flags = IEEE80211_RATE_OFDM },
+};
+
+static const struct ieee80211_channel zd_channels[] = {
+	{ .chan = 1,
+	  .freq = 2412},
+	{ .chan = 2,
+	  .freq = 2417},
+	{ .chan = 3,
+	  .freq = 2422},
+	{ .chan = 4,
+	  .freq = 2427},
+	{ .chan = 5,
+	  .freq = 2432},
+	{ .chan = 6,
+	  .freq = 2437},
+	{ .chan = 7,
+	  .freq = 2442},
+	{ .chan = 8,
+	  .freq = 2447},
+	{ .chan = 9,
+	  .freq = 2452},
+	{ .chan = 10,
+	  .freq = 2457},
+	{ .chan = 11,
+	  .freq = 2462},
+	{ .chan = 12,
+	  .freq = 2467},
+	{ .chan = 13,
+	  .freq = 2472},
+	{ .chan = 14,
+	  .freq = 2484}
+};
 
 static void housekeeping_init(struct zd_mac *mac);
 static void housekeeping_enable(struct zd_mac *mac);
 static void housekeeping_disable(struct zd_mac *mac);
 
-static void set_multicast_hash_handler(struct work_struct *work);
-
-static void do_rx(unsigned long mac_ptr);
-
-int zd_mac_init(struct zd_mac *mac,
-	        struct net_device *netdev,
-	        struct usb_interface *intf)
-{
-	struct ieee80211_device *ieee = zd_netdev_ieee80211(netdev);
-
-	memset(mac, 0, sizeof(*mac));
-	spin_lock_init(&mac->lock);
-	mac->netdev = netdev;
-	INIT_DELAYED_WORK(&mac->set_rts_cts_work, set_rts_cts_work);
-	INIT_DELAYED_WORK(&mac->set_basic_rates_work, set_basic_rates_work);
-
-	skb_queue_head_init(&mac->rx_queue);
-	tasklet_init(&mac->rx_tasklet, do_rx, (unsigned long)mac);
-	tasklet_disable(&mac->rx_tasklet);
-
-	ieee_init(ieee);
-	softmac_init(ieee80211_priv(netdev));
-	zd_chip_init(&mac->chip, netdev, intf);
-	housekeeping_init(mac);
-	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
-	return 0;
-}
-
-static int reset_channel(struct zd_mac *mac)
-{
-	int r;
-	unsigned long flags;
-	const struct channel_range *range;
-
-	spin_lock_irqsave(&mac->lock, flags);
-	range = zd_channel_range(mac->regdomain);
-	if (!range->start) {
-		r = -EINVAL;
-		goto out;
-	}
-	mac->requested_channel = range->start;
-	r = 0;
-out:
-	spin_unlock_irqrestore(&mac->lock, flags);
-	return r;
-}
-
-int zd_mac_preinit_hw(struct zd_mac *mac)
+int zd_mac_preinit_hw(struct ieee80211_hw *hw)
 {
 	int r;
 	u8 addr[ETH_ALEN];
+	struct zd_mac *mac = zd_hw_mac(hw);
 
 	r = zd_chip_read_mac_addr_fw(&mac->chip, addr);
 	if (r)
 		return r;
 
-	memcpy(mac->netdev->dev_addr, addr, ETH_ALEN);
+	SET_IEEE80211_PERM_ADDR(hw, addr);
+
 	return 0;
 }
 
-int zd_mac_init_hw(struct zd_mac *mac)
+int zd_mac_init_hw(struct ieee80211_hw *hw)
 {
 	int r;
+	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
 	u8 default_regdomain;
 
@@ -116,22 +141,9 @@ int zd_mac_init_hw(struct zd_mac *mac)
 	r = zd_read_regdomain(chip, &default_regdomain);
 	if (r)
 		goto disable_int;
-	if (!zd_regdomain_supported(default_regdomain)) {
-		/* The vendor driver overrides the regulatory domain and
-		 * allowed channel registers and unconditionally restricts
-		 * available channels to 1-11 everywhere. Match their
-		 * questionable behaviour only for regdomains which we don't
-		 * recognise. */
-		dev_warn(zd_mac_dev(mac),  "Unrecognised regulatory domain: "
-			"%#04x. Defaulting to FCC.\n", default_regdomain);
-		default_regdomain = ZD_REGDOMAIN_FCC;
-	}
 	spin_lock_irq(&mac->lock);
 	mac->regdomain = mac->default_regdomain = default_regdomain;
 	spin_unlock_irq(&mac->lock);
-	r = reset_channel(mac);
-	if (r)
-		goto disable_int;
 
 	/* We must inform the device that we are doing encryption/decryption in
 	 * software at the moment. */
@@ -139,9 +151,7 @@ int zd_mac_init_hw(struct zd_mac *mac)
 	if (r)
 		goto disable_int;
 
-	r = zd_geo_init(zd_mac_to_ieee80211(mac), mac->regdomain);
-	if (r)
-		goto disable_int;
+	zd_geo_init(hw, mac->regdomain);
 
 	r = 0;
 disable_int:
@@ -153,8 +163,6 @@ out:
 void zd_mac_clear(struct zd_mac *mac)
 {
 	flush_workqueue(zd_workqueue);
-	skb_queue_purge(&mac->rx_queue);
-	tasklet_kill(&mac->rx_tasklet);
 	zd_chip_clear(&mac->chip);
 	ZD_ASSERT(!spin_is_locked(&mac->lock));
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
@@ -162,34 +170,27 @@ void zd_mac_clear(struct zd_mac *mac)
 
 static int set_rx_filter(struct zd_mac *mac)
 {
-	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-	u32 filter = (ieee->iw_mode == IW_MODE_MONITOR) ? ~0 : STA_RX_FILTER;
-	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
-}
+	unsigned long flags;
+	u32 filter = STA_RX_FILTER;
 
-static int set_sniffer(struct zd_mac *mac)
-{
-	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-	return zd_iowrite32(&mac->chip, CR_SNIFFER_ON,
-		ieee->iw_mode == IW_MODE_MONITOR ? 1 : 0);
-	return 0;
+	spin_lock_irqsave(&mac->lock, flags);
+	if (mac->pass_ctrl)
+		filter |= RX_FILTER_CTRL;
+	spin_unlock_irqrestore(&mac->lock, flags);
+
+	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
 static int set_mc_hash(struct zd_mac *mac)
 {
 	struct zd_mc_hash hash;
-	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-
 	zd_mc_clear(&hash);
-	if (ieee->iw_mode == IW_MODE_MONITOR)
-		zd_mc_add_all(&hash);
-
 	return zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-int zd_mac_open(struct net_device *netdev)
+static int zd_op_start(struct ieee80211_hw *hw)
 {
-	struct zd_mac *mac = zd_netdev_mac(netdev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
 	struct zd_usb *usb = &chip->usb;
 	int r;
@@ -200,46 +201,33 @@ int zd_mac_open(struct net_device *netdev)
 			goto out;
 	}
 
-	tasklet_enable(&mac->rx_tasklet);
-
 	r = zd_chip_enable_int(chip);
 	if (r < 0)
 		goto out;
 
-	r = zd_write_mac_addr(chip, netdev->dev_addr);
-	if (r)
-		goto disable_int;
-
 	r = zd_chip_set_basic_rates(chip, CR_RATES_80211B | CR_RATES_80211G);
 	if (r < 0)
 		goto disable_int;
 	r = set_rx_filter(mac);
 	if (r)
 		goto disable_int;
-	r = set_sniffer(mac);
-	if (r)
-		goto disable_int;
 	r = set_mc_hash(mac);
 	if (r)
 		goto disable_int;
 	r = zd_chip_switch_radio_on(chip);
 	if (r < 0)
 		goto disable_int;
-	r = zd_chip_set_channel(chip, mac->requested_channel);
-	if (r < 0)
-		goto disable_radio;
-	r = zd_chip_enable_rx(chip);
+	r = zd_chip_enable_rxtx(chip);
 	if (r < 0)
 		goto disable_radio;
 	r = zd_chip_enable_hwint(chip);
 	if (r < 0)
-		goto disable_rx;
+		goto disable_rxtx;
 
 	housekeeping_enable(mac);
-	ieee80211softmac_start(netdev);
 	return 0;
-disable_rx:
-	zd_chip_disable_rx(chip);
+disable_rxtx:
+	zd_chip_disable_rxtx(chip);
 disable_radio:
 	zd_chip_switch_radio_off(chip);
 disable_int:
@@ -248,494 +236,190 @@ out:
 	return r;
 }
 
-int zd_mac_stop(struct net_device *netdev)
+/**
+ * clear_tx_skb_control_block - clears the control block of tx skbuffs
+ * @skb: a &struct sk_buff pointer
+ *
+ * This clears the control block of skbuff buffers, which were transmitted to
+ * the device. Notify that the function is not thread-safe, so prevent
+ * multiple calls.
+ */
+static void clear_tx_skb_control_block(struct sk_buff *skb)
+{
+	struct zd_tx_skb_control_block *cb =
+		(struct zd_tx_skb_control_block *)skb->cb;
+
+	kfree(cb->control);
+	cb->control = NULL;
+}
+
+/**
+ * kfree_tx_skb - frees a tx skbuff
+ * @skb: a &struct sk_buff pointer
+ *
+ * Frees the tx skbuff. Frees also the allocated control structure in the
+ * control block if necessary.
+ */
+static void kfree_tx_skb(struct sk_buff *skb)
 {
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-	struct zd_chip *chip = &mac->chip;
+	clear_tx_skb_control_block(skb);
+	dev_kfree_skb_any(skb);
+}
 
-	netif_stop_queue(netdev);
+static void zd_op_stop(struct ieee80211_hw *hw)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+	struct zd_chip *chip = &mac->chip;
+	struct sk_buff *skb;
+	struct sk_buff_head *ack_wait_queue = &mac->ack_wait_queue;
 
-	/*
-	 * The order here deliberately is a little different from the open()
+	/* The order here deliberately is a little different from the open()
 	 * method, since we need to make sure there is no opportunity for RX
-	 * frames to be processed by softmac after we have stopped it.
+	 * frames to be processed by mac80211 after we have stopped it.
 	 */
 
-	zd_chip_disable_rx(chip);
-	skb_queue_purge(&mac->rx_queue);
-	tasklet_disable(&mac->rx_tasklet);
+	zd_chip_disable_rxtx(chip);
 	housekeeping_disable(mac);
-	ieee80211softmac_stop(netdev);
-
-	/* Ensure no work items are running or queued from this point */
-	cancel_delayed_work(&mac->set_rts_cts_work);
-	cancel_delayed_work(&mac->set_basic_rates_work);
 	flush_workqueue(zd_workqueue);
-	mac->updating_rts_rate = 0;
-	mac->updating_basic_rates = 0;
 
 	zd_chip_disable_hwint(chip);
 	zd_chip_switch_radio_off(chip);
 	zd_chip_disable_int(chip);
 
-	return 0;
-}
-
-int zd_mac_set_mac_address(struct net_device *netdev, void *p)
-{
-	int r;
-	unsigned long flags;
-	struct sockaddr *addr = p;
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-	struct zd_chip *chip = &mac->chip;
-	DECLARE_MAC_BUF(mac2);
 
-	if (!is_valid_ether_addr(addr->sa_data))
-		return -EADDRNOTAVAIL;
-
-	dev_dbg_f(zd_mac_dev(mac),
-		  "Setting MAC to %s\n", print_mac(mac2, addr->sa_data));
-
-	if (netdev->flags & IFF_UP) {
-		r = zd_write_mac_addr(chip, addr->sa_data);
-		if (r)
-			return r;
-	}
-
-	spin_lock_irqsave(&mac->lock, flags);
-	memcpy(netdev->dev_addr, addr->sa_data, ETH_ALEN);
-	spin_unlock_irqrestore(&mac->lock, flags);
-
-	return 0;
-}
-
-static void set_multicast_hash_handler(struct work_struct *work)
-{
-	struct zd_mac *mac = container_of(work, struct zd_mac,
-					  set_multicast_hash_work);
-	struct zd_mc_hash hash;
-
-	spin_lock_irq(&mac->lock);
-	hash = mac->multicast_hash;
-	spin_unlock_irq(&mac->lock);
-
-	zd_chip_set_multicast_hash(&mac->chip, &hash);
-}
-
-void zd_mac_set_multicast_list(struct net_device *dev)
-{
-	struct zd_mac *mac = zd_netdev_mac(dev);
-	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-	struct zd_mc_hash hash;
-	struct dev_mc_list *mc;
-	unsigned long flags;
-	DECLARE_MAC_BUF(mac2);
-
-	if (dev->flags & (IFF_PROMISC|IFF_ALLMULTI) ||
-			ieee->iw_mode == IW_MODE_MONITOR) {
-		zd_mc_add_all(&hash);
-	} else {
-		zd_mc_clear(&hash);
-		for (mc = dev->mc_list; mc; mc = mc->next) {
-			dev_dbg_f(zd_mac_dev(mac), "mc addr %s\n",
-				  print_mac(mac2, mc->dmi_addr));
-			zd_mc_add_addr(&hash, mc->dmi_addr);
-		}
-	}
-
-	spin_lock_irqsave(&mac->lock, flags);
-	mac->multicast_hash = hash;
-	spin_unlock_irqrestore(&mac->lock, flags);
-	queue_work(zd_workqueue, &mac->set_multicast_hash_work);
+	while ((skb = skb_dequeue(ack_wait_queue)))
+		kfree_tx_skb(skb);
 }
 
-int zd_mac_set_regdomain(struct zd_mac *mac, u8 regdomain)
-{
-	int r;
-	u8 channel;
-
-	ZD_ASSERT(!irqs_disabled());
-	spin_lock_irq(&mac->lock);
-	if (regdomain == 0) {
-		regdomain = mac->default_regdomain;
-	}
-	if (!zd_regdomain_supported(regdomain)) {
-		spin_unlock_irq(&mac->lock);
-		return -EINVAL;
-	}
-	mac->regdomain = regdomain;
-	channel = mac->requested_channel;
-	spin_unlock_irq(&mac->lock);
-
-	r = zd_geo_init(zd_mac_to_ieee80211(mac), regdomain);
-	if (r)
-		return r;
-	if (!zd_regdomain_supports_channel(regdomain, channel)) {
-		r = reset_channel(mac);
-		if (r)
-			return r;
-	}
+/**
+ * init_tx_skb_control_block - initializes skb control block
+ * @skb: a &sk_buff pointer
+ * @dev: pointer to the mac80221 device
+ * @control: mac80211 tx control applying for the frame in @skb
+ *
+ * Initializes the control block of the skbuff to be transmitted.
+ */
+static int init_tx_skb_control_block(struct sk_buff *skb,
+				     struct ieee80211_hw *hw,
+	                             struct ieee80211_tx_control *control)
+{
+	struct zd_tx_skb_control_block *cb =
+		(struct zd_tx_skb_control_block *)skb->cb;
+
+	ZD_ASSERT(sizeof(*cb) <= sizeof(skb->cb));
+	memset(cb, 0, sizeof(*cb));
+	cb->hw= hw;
+	cb->control = kmalloc(sizeof(*control), GFP_ATOMIC);
+	if (cb->control == NULL)
+		return -ENOMEM;
+	memcpy(cb->control, control, sizeof(*control));
 
 	return 0;
 }
 
-u8 zd_mac_get_regdomain(struct zd_mac *mac)
-{
-	unsigned long flags;
-	u8 regdomain;
-
-	spin_lock_irqsave(&mac->lock, flags);
-	regdomain = mac->regdomain;
-	spin_unlock_irqrestore(&mac->lock, flags);
-	return regdomain;
-}
-
-/* Fallback to lowest rate, if rate is unknown. */
-static u8 rate_to_zd_rate(u8 rate)
-{
-	switch (rate) {
-	case IEEE80211_CCK_RATE_2MB:
-		return ZD_CCK_RATE_2M;
-	case IEEE80211_CCK_RATE_5MB:
-		return ZD_CCK_RATE_5_5M;
-	case IEEE80211_CCK_RATE_11MB:
-		return ZD_CCK_RATE_11M;
-	case IEEE80211_OFDM_RATE_6MB:
-		return ZD_OFDM_RATE_6M;
-	case IEEE80211_OFDM_RATE_9MB:
-		return ZD_OFDM_RATE_9M;
-	case IEEE80211_OFDM_RATE_12MB:
-		return ZD_OFDM_RATE_12M;
-	case IEEE80211_OFDM_RATE_18MB:
-		return ZD_OFDM_RATE_18M;
-	case IEEE80211_OFDM_RATE_24MB:
-		return ZD_OFDM_RATE_24M;
-	case IEEE80211_OFDM_RATE_36MB:
-		return ZD_OFDM_RATE_36M;
-	case IEEE80211_OFDM_RATE_48MB:
-		return ZD_OFDM_RATE_48M;
-	case IEEE80211_OFDM_RATE_54MB:
-		return ZD_OFDM_RATE_54M;
-	}
-	return ZD_CCK_RATE_1M;
-}
-
-static u16 rate_to_cr_rate(u8 rate)
-{
-	switch (rate) {
-	case IEEE80211_CCK_RATE_2MB:
-		return CR_RATE_1M;
-	case IEEE80211_CCK_RATE_5MB:
-		return CR_RATE_5_5M;
-	case IEEE80211_CCK_RATE_11MB:
-		return CR_RATE_11M;
-	case IEEE80211_OFDM_RATE_6MB:
-		return CR_RATE_6M;
-	case IEEE80211_OFDM_RATE_9MB:
-		return CR_RATE_9M;
-	case IEEE80211_OFDM_RATE_12MB:
-		return CR_RATE_12M;
-	case IEEE80211_OFDM_RATE_18MB:
-		return CR_RATE_18M;
-	case IEEE80211_OFDM_RATE_24MB:
-		return CR_RATE_24M;
-	case IEEE80211_OFDM_RATE_36MB:
-		return CR_RATE_36M;
-	case IEEE80211_OFDM_RATE_48MB:
-		return CR_RATE_48M;
-	case IEEE80211_OFDM_RATE_54MB:
-		return CR_RATE_54M;
-	}
-	return CR_RATE_1M;
-}
-
-static void try_enable_tx(struct zd_mac *mac)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&mac->lock, flags);
-	if (mac->updating_rts_rate == 0 && mac->updating_basic_rates == 0)
-		netif_wake_queue(mac->netdev);
-	spin_unlock_irqrestore(&mac->lock, flags);
-}
-
-static void set_rts_cts_work(struct work_struct *work)
+/**
+ * tx_status - reports tx status of a packet if required
+ * @hw - a &struct ieee80211_hw pointer
+ * @skb - a sk-buffer
+ * @status - the tx status of the packet without control information
+ * @success - True for successfull transmission of the frame
+ *
+ * This information calls ieee80211_tx_status_irqsafe() if required by the
+ * control information. It copies the control information into the status
+ * information.
+ *
+ * If no status information has been requested, the skb is freed.
+ */
+static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
+	              struct ieee80211_tx_status *status,
+		      bool success)
 {
-	struct zd_mac *mac =
-		container_of(work, struct zd_mac, set_rts_cts_work.work);
-	unsigned long flags;
-	u8 rts_rate;
-	unsigned int short_preamble;
-
-	mutex_lock(&mac->chip.mutex);
-
-	spin_lock_irqsave(&mac->lock, flags);
-	mac->updating_rts_rate = 0;
-	rts_rate = mac->rts_rate;
-	short_preamble = mac->short_preamble;
-	spin_unlock_irqrestore(&mac->lock, flags);
-
-	zd_chip_set_rts_cts_rate_locked(&mac->chip, rts_rate, short_preamble);
-	mutex_unlock(&mac->chip.mutex);
+	struct zd_tx_skb_control_block *cb = (struct zd_tx_skb_control_block *)
+		skb->cb;
 
-	try_enable_tx(mac);
+	ZD_ASSERT(cb->control != NULL);
+	memcpy(&status->control, cb->control, sizeof(status->control));
+	if (!success)
+		status->excessive_retries = 1;
+	clear_tx_skb_control_block(skb);
+	ieee80211_tx_status_irqsafe(hw, skb, status);
 }
 
-static void set_basic_rates_work(struct work_struct *work)
+/**
+ * zd_mac_tx_failed - callback for failed frames
+ * @dev: the mac80211 wireless device
+ *
+ * This function is called if a frame couldn't be succesfully be
+ * transferred. The first frame from the tx queue, will be selected and
+ * reported as error to the upper layers.
+ */
+void zd_mac_tx_failed(struct ieee80211_hw *hw)
 {
-	struct zd_mac *mac =
-		container_of(work, struct zd_mac, set_basic_rates_work.work);
-	unsigned long flags;
-	u16 basic_rates;
-
-	mutex_lock(&mac->chip.mutex);
-
-	spin_lock_irqsave(&mac->lock, flags);
-	mac->updating_basic_rates = 0;
-	basic_rates = mac->basic_rates;
-	spin_unlock_irqrestore(&mac->lock, flags);
-
-	zd_chip_set_basic_rates_locked(&mac->chip, basic_rates);
-	mutex_unlock(&mac->chip.mutex);
+	struct sk_buff_head *q = &zd_hw_mac(hw)->ack_wait_queue;
+	struct sk_buff *skb;
+	struct ieee80211_tx_status status = {{0}};
 
-	try_enable_tx(mac);
+	skb = skb_dequeue(q);
+	if (skb == NULL)
+		return;
+	tx_status(hw, skb, &status, 0);
 }
 
-static void bssinfo_change(struct net_device *netdev, u32 changes)
-{
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-	struct ieee80211softmac_device *softmac = ieee80211_priv(netdev);
-	struct ieee80211softmac_bss_info *bssinfo = &softmac->bssinfo;
-	int need_set_rts_cts = 0;
-	int need_set_rates = 0;
-	u16 basic_rates;
-	unsigned long flags;
-
-	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
-
-	if (changes & IEEE80211SOFTMAC_BSSINFOCHG_SHORT_PREAMBLE) {
-		spin_lock_irqsave(&mac->lock, flags);
-		mac->short_preamble = bssinfo->short_preamble;
-		spin_unlock_irqrestore(&mac->lock, flags);
-		need_set_rts_cts = 1;
-	}
-
-	if (changes & IEEE80211SOFTMAC_BSSINFOCHG_RATES) {
-		/* Set RTS rate to highest available basic rate */
-		u8 hi_rate = ieee80211softmac_highest_supported_rate(softmac,
-			&bssinfo->supported_rates, 1);
-		hi_rate = rate_to_zd_rate(hi_rate);
-
-		spin_lock_irqsave(&mac->lock, flags);
-		if (hi_rate != mac->rts_rate) {
-			mac->rts_rate = hi_rate;
-			need_set_rts_cts = 1;
-		}
-		spin_unlock_irqrestore(&mac->lock, flags);
-
-		/* Set basic rates */
-		need_set_rates = 1;
-		if (bssinfo->supported_rates.count == 0) {
-			/* Allow the device to be flexible */
-			basic_rates = CR_RATES_80211B | CR_RATES_80211G;
+/**
+ * zd_mac_tx_to_dev - callback for USB layer
+ * @skb: a &sk_buff pointer
+ * @error: error value, 0 if transmission successful
+ *
+ * Informs the MAC layer that the frame has successfully transferred to the
+ * device. If an ACK is required and the transfer to the device has been
+ * successful, the packets are put on the @ack_wait_queue with
+ * the control set removed.
+ */
+void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
+{
+	struct zd_tx_skb_control_block *cb =
+		(struct zd_tx_skb_control_block *)skb->cb;
+	struct ieee80211_hw *hw = cb->hw;
+
+	if (likely(cb->control)) {
+		skb_pull(skb, sizeof(struct zd_ctrlset));
+		if (unlikely(error ||
+		    (cb->control->flags & IEEE80211_TXCTL_NO_ACK)))
+		{
+			struct ieee80211_tx_status status = {{0}};
+			tx_status(hw, skb, &status, !error);
 		} else {
-			int i = 0;
-			basic_rates = 0;
+			struct sk_buff_head *q =
+				&zd_hw_mac(hw)->ack_wait_queue;
 
-			for (i = 0; i < bssinfo->supported_rates.count; i++) {
-				u16 rate = bssinfo->supported_rates.rates[i];
-				if ((rate & IEEE80211_BASIC_RATE_MASK) == 0)
-					continue;
-
-				rate &= ~IEEE80211_BASIC_RATE_MASK;
-				basic_rates |= rate_to_cr_rate(rate);
-			}
+			skb_queue_tail(q, skb);
+			while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS)
+				zd_mac_tx_failed(hw);
 		}
-		spin_lock_irqsave(&mac->lock, flags);
-		mac->basic_rates = basic_rates;
-		spin_unlock_irqrestore(&mac->lock, flags);
-	}
-
-	/* Schedule any changes we made above */
-
-	spin_lock_irqsave(&mac->lock, flags);
-	if (need_set_rts_cts && !mac->updating_rts_rate) {
-		mac->updating_rts_rate = 1;
-		netif_stop_queue(mac->netdev);
-		queue_delayed_work(zd_workqueue, &mac->set_rts_cts_work, 0);
-	}
-	if (need_set_rates && !mac->updating_basic_rates) {
-		mac->updating_basic_rates = 1;
-		netif_stop_queue(mac->netdev);
-		queue_delayed_work(zd_workqueue, &mac->set_basic_rates_work,
-				   0);
-	}
-	spin_unlock_irqrestore(&mac->lock, flags);
-}
-
-static void set_channel(struct net_device *netdev, u8 channel)
-{
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-
-	dev_dbg_f(zd_mac_dev(mac), "channel %d\n", channel);
-
-	zd_chip_set_channel(&mac->chip, channel);
-}
-
-int zd_mac_request_channel(struct zd_mac *mac, u8 channel)
-{
-	unsigned long lock_flags;
-	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-
-	if (ieee->iw_mode == IW_MODE_INFRA)
-		return -EPERM;
-
-	spin_lock_irqsave(&mac->lock, lock_flags);
-	if (!zd_regdomain_supports_channel(mac->regdomain, channel)) {
-		spin_unlock_irqrestore(&mac->lock, lock_flags);
-		return -EINVAL;
-	}
-	mac->requested_channel = channel;
-	spin_unlock_irqrestore(&mac->lock, lock_flags);
-	if (netif_running(mac->netdev))
-		return zd_chip_set_channel(&mac->chip, channel);
-	else
-		return 0;
-}
-
-u8 zd_mac_get_channel(struct zd_mac *mac)
-{
-	u8 channel = zd_chip_get_channel(&mac->chip);
-
-	dev_dbg_f(zd_mac_dev(mac), "channel %u\n", channel);
-	return channel;
-}
-
-int zd_mac_set_mode(struct zd_mac *mac, u32 mode)
-{
-	struct ieee80211_device *ieee;
-
-	switch (mode) {
-	case IW_MODE_AUTO:
-	case IW_MODE_ADHOC:
-	case IW_MODE_INFRA:
-		mac->netdev->type = ARPHRD_ETHER;
-		break;
-	case IW_MODE_MONITOR:
-		mac->netdev->type = ARPHRD_IEEE80211_RADIOTAP;
-		break;
-	default:
-		dev_dbg_f(zd_mac_dev(mac), "wrong mode %u\n", mode);
-		return -EINVAL;
-	}
-
-	ieee = zd_mac_to_ieee80211(mac);
-	ZD_ASSERT(!irqs_disabled());
-	spin_lock_irq(&ieee->lock);
-	ieee->iw_mode = mode;
-	spin_unlock_irq(&ieee->lock);
-
-	if (netif_running(mac->netdev)) {
-		int r = set_rx_filter(mac);
-		if (r)
-			return r;
-		return set_sniffer(mac);
-	}
-
-	return 0;
-}
-
-int zd_mac_get_mode(struct zd_mac *mac, u32 *mode)
-{
-	unsigned long flags;
-	struct ieee80211_device *ieee;
-
-	ieee = zd_mac_to_ieee80211(mac);
-	spin_lock_irqsave(&ieee->lock, flags);
-	*mode = ieee->iw_mode;
-	spin_unlock_irqrestore(&ieee->lock, flags);
-	return 0;
-}
-
-int zd_mac_get_range(struct zd_mac *mac, struct iw_range *range)
-{
-	int i;
-	const struct channel_range *channel_range;
-	u8 regdomain;
-
-	memset(range, 0, sizeof(*range));
-
-	/* FIXME: Not so important and depends on the mode. For 802.11g
-	 * usually this value is used. It seems to be that Bit/s number is
-	 * given here.
-	 */
-	range->throughput = 27 * 1000 * 1000;
-
-	range->max_qual.qual = 100;
-	range->max_qual.level = 100;
-
-	/* FIXME: Needs still to be tuned. */
-	range->avg_qual.qual = 71;
-	range->avg_qual.level = 80;
-
-	/* FIXME: depends on standard? */
-	range->min_rts = 256;
-	range->max_rts = 2346;
-
-	range->min_frag = MIN_FRAG_THRESHOLD;
-	range->max_frag = MAX_FRAG_THRESHOLD;
-
-	range->max_encoding_tokens = WEP_KEYS;
-	range->num_encoding_sizes = 2;
-	range->encoding_size[0] = 5;
-	range->encoding_size[1] = WEP_KEY_LEN;
-
-	range->we_version_compiled = WIRELESS_EXT;
-	range->we_version_source = 20;
-
-	range->enc_capa = IW_ENC_CAPA_WPA |  IW_ENC_CAPA_WPA2 |
-			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
-
-	ZD_ASSERT(!irqs_disabled());
-	spin_lock_irq(&mac->lock);
-	regdomain = mac->regdomain;
-	spin_unlock_irq(&mac->lock);
-	channel_range = zd_channel_range(regdomain);
-
-	range->num_channels = channel_range->end - channel_range->start;
-	range->old_num_channels = range->num_channels;
-	range->num_frequency = range->num_channels;
-	range->old_num_frequency = range->num_frequency;
-
-	for (i = 0; i < range->num_frequency; i++) {
-		struct iw_freq *freq = &range->freq[i];
-		freq->i = channel_range->start + i;
-		zd_channel_to_freq(freq, freq->i);
+	} else {
+		kfree_tx_skb(skb);
 	}
-
-	return 0;
 }
 
 static int zd_calc_tx_length_us(u8 *service, u8 zd_rate, u16 tx_length)
 {
 	/* ZD_PURE_RATE() must be used to remove the modulation type flag of
-	 * the zd-rate values. */
+	 * the zd-rate values.
+	 */
 	static const u8 rate_divisor[] = {
-		[ZD_PURE_RATE(ZD_CCK_RATE_1M)]		=  1,
-		[ZD_PURE_RATE(ZD_CCK_RATE_2M)]		=  2,
-
-		/* bits must be doubled */
-		[ZD_PURE_RATE(ZD_CCK_RATE_5_5M)]	= 11,
-
-		[ZD_PURE_RATE(ZD_CCK_RATE_11M)]		= 11,
-		[ZD_PURE_RATE(ZD_OFDM_RATE_6M)]		=  6,
-		[ZD_PURE_RATE(ZD_OFDM_RATE_9M)]		=  9,
-		[ZD_PURE_RATE(ZD_OFDM_RATE_12M)]	= 12,
-		[ZD_PURE_RATE(ZD_OFDM_RATE_18M)]	= 18,
-		[ZD_PURE_RATE(ZD_OFDM_RATE_24M)]	= 24,
-		[ZD_PURE_RATE(ZD_OFDM_RATE_36M)]	= 36,
-		[ZD_PURE_RATE(ZD_OFDM_RATE_48M)]	= 48,
-		[ZD_PURE_RATE(ZD_OFDM_RATE_54M)]	= 54,
+		[ZD_PURE_RATE(ZD_CCK_RATE_1M)]   =  1,
+		[ZD_PURE_RATE(ZD_CCK_RATE_2M)]	 =  2,
+		/* Bits must be doubled. */
+		[ZD_PURE_RATE(ZD_CCK_RATE_5_5M)] = 11,
+		[ZD_PURE_RATE(ZD_CCK_RATE_11M)]	 = 11,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_6M)]  =  6,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_9M)]  =  9,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_12M)] = 12,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_18M)] = 18,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_24M)] = 24,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_36M)] = 36,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_48M)] = 48,
+		[ZD_PURE_RATE(ZD_OFDM_RATE_54M)] = 54,
 	};
 
 	u32 bits = (u32)tx_length * 8;
@@ -764,34 +448,10 @@ static int zd_calc_tx_length_us(u8 *service, u8 zd_rate, u16 tx_length)
 	return bits/divisor;
 }
 
-static void cs_set_modulation(struct zd_mac *mac, struct zd_ctrlset *cs,
-	                      struct ieee80211_hdr_4addr *hdr)
-{
-	struct ieee80211softmac_device *softmac = ieee80211_priv(mac->netdev);
-	u16 ftype = WLAN_FC_GET_TYPE(le16_to_cpu(hdr->frame_ctl));
-	u8 rate;
-	int is_mgt = (ftype == IEEE80211_FTYPE_MGMT) != 0;
-	int is_multicast = is_multicast_ether_addr(hdr->addr1);
-	int short_preamble = ieee80211softmac_short_preamble_ok(softmac,
-		is_multicast, is_mgt);
-
-	rate = ieee80211softmac_suggest_txrate(softmac, is_multicast, is_mgt);
-	cs->modulation = rate_to_zd_rate(rate);
-
-	/* Set short preamble bit when appropriate */
-	if (short_preamble && ZD_MODULATION_TYPE(cs->modulation) == ZD_CCK
-	    && cs->modulation != ZD_CCK_RATE_1M)
-		cs->modulation |= ZD_CCK_PREA_SHORT;
-}
-
 static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
-	                   struct ieee80211_hdr_4addr *header)
+	                   struct ieee80211_hdr *header, u32 flags)
 {
-	struct ieee80211softmac_device *softmac = ieee80211_priv(mac->netdev);
-	unsigned int tx_length = le16_to_cpu(cs->tx_length);
-	u16 fctl = le16_to_cpu(header->frame_ctl);
-	u16 ftype = WLAN_FC_GET_TYPE(fctl);
-	u16 stype = WLAN_FC_GET_STYPE(fctl);
+	u16 fctl = le16_to_cpu(header->frame_control);
 
 	/*
 	 * CONTROL TODO:
@@ -802,7 +462,7 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 	cs->control = 0;
 
 	/* First fragment */
-	if (WLAN_GET_SEQ_FRAG(le16_to_cpu(header->seq_ctl)) == 0)
+	if (flags & IEEE80211_TXCTL_FIRST_FRAGMENT)
 		cs->control |= ZD_CS_NEED_RANDOM_BACKOFF;
 
 	/* Multicast */
@@ -810,54 +470,37 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 		cs->control |= ZD_CS_MULTICAST;
 
 	/* PS-POLL */
-	if (ftype == IEEE80211_FTYPE_CTL && stype == IEEE80211_STYPE_PSPOLL)
+	if ((fctl & (IEEE80211_FCTL_FTYPE|IEEE80211_FCTL_STYPE)) ==
+	    (IEEE80211_FTYPE_CTL|IEEE80211_STYPE_PSPOLL))
 		cs->control |= ZD_CS_PS_POLL_FRAME;
 
-	/* Unicast data frames over the threshold should have RTS */
-	if (!is_multicast_ether_addr(header->addr1) &&
-	    	ftype != IEEE80211_FTYPE_MGMT &&
-		    tx_length > zd_netdev_ieee80211(mac->netdev)->rts)
+	if (flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		cs->control |= ZD_CS_RTS;
 
-	/* Use CTS-to-self protection if required */
-	if (ZD_MODULATION_TYPE(cs->modulation) == ZD_OFDM &&
-			ieee80211softmac_protection_needed(softmac)) {
-		/* FIXME: avoid sending RTS *and* self-CTS, is that correct? */
-		cs->control &= ~ZD_CS_RTS;
+	if (flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		cs->control |= ZD_CS_SELF_CTS;
-	}
 
 	/* FIXME: Management frame? */
 }
 
 static int fill_ctrlset(struct zd_mac *mac,
-	                struct ieee80211_txb *txb,
-			int frag_num)
+			struct sk_buff *skb,
+			struct ieee80211_tx_control *control)
 {
 	int r;
-	struct sk_buff *skb = txb->fragments[frag_num];
-	struct ieee80211_hdr_4addr *hdr =
-		(struct ieee80211_hdr_4addr *) skb->data;
-	unsigned int frag_len = skb->len + IEEE80211_FCS_LEN;
-	unsigned int next_frag_len;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	unsigned int frag_len = skb->len + FCS_LEN;
 	unsigned int packet_length;
 	struct zd_ctrlset *cs = (struct zd_ctrlset *)
 		skb_push(skb, sizeof(struct zd_ctrlset));
 
-	if (frag_num+1  < txb->nr_frags) {
-		next_frag_len = txb->fragments[frag_num+1]->len +
-			        IEEE80211_FCS_LEN;
-	} else {
-		next_frag_len = 0;
-	}
 	ZD_ASSERT(frag_len <= 0xffff);
-	ZD_ASSERT(next_frag_len <= 0xffff);
 
-	cs_set_modulation(mac, cs, hdr);
+	cs->modulation = control->tx_rate;
 
 	cs->tx_length = cpu_to_le16(frag_len);
 
-	cs_set_control(mac, cs, hdr);
+	cs_set_control(mac, cs, hdr, control->flags);
 
 	packet_length = frag_len + sizeof(struct zd_ctrlset) + 10;
 	ZD_ASSERT(packet_length <= 0xffff);
@@ -886,413 +529,399 @@ static int fill_ctrlset(struct zd_mac *mac,
 	if (r < 0)
 		return r;
 	cs->current_length = cpu_to_le16(r);
-
-	if (next_frag_len == 0) {
-		cs->next_frame_length = 0;
-	} else {
-		r = zd_calc_tx_length_us(NULL, ZD_RATE(cs->modulation),
-			                 next_frag_len);
-		if (r < 0)
-			return r;
-		cs->next_frame_length = cpu_to_le16(r);
-	}
+	cs->next_frame_length = 0;
 
 	return 0;
 }
 
-static int zd_mac_tx(struct zd_mac *mac, struct ieee80211_txb *txb, int pri)
+/**
+ * zd_op_tx - transmits a network frame to the device
+ *
+ * @dev: mac80211 hardware device
+ * @skb: socket buffer
+ * @control: the control structure
+ *
+ * This function transmit an IEEE 802.11 network frame to the device. The
+ * control block of the skbuff will be initialized. If necessary the incoming
+ * mac80211 queues will be stopped.
+ */
+static int zd_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		     struct ieee80211_tx_control *control)
 {
-	int i, r;
-	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
+	struct zd_mac *mac = zd_hw_mac(hw);
+	int r;
 
-	for (i = 0; i < txb->nr_frags; i++) {
-		struct sk_buff *skb = txb->fragments[i];
+	r = fill_ctrlset(mac, skb, control);
+	if (r)
+		return r;
 
-		r = fill_ctrlset(mac, txb, i);
-		if (r) {
-			ieee->stats.tx_dropped++;
-			return r;
-		}
-		r = zd_usb_tx(&mac->chip.usb, skb->data, skb->len);
-		if (r) {
-			ieee->stats.tx_dropped++;
-			return r;
-		}
+	r = init_tx_skb_control_block(skb, hw, control);
+	if (r)
+		return r;
+	r = zd_usb_tx(&mac->chip.usb, skb);
+	if (r) {
+		clear_tx_skb_control_block(skb);
+		return r;
 	}
-
-	/* FIXME: shouldn't this be handled by the upper layers? */
-	mac->netdev->trans_start = jiffies;
-
-	ieee80211_txb_free(txb);
 	return 0;
 }
 
-struct zd_rt_hdr {
-	struct ieee80211_radiotap_header rt_hdr;
-	u8  rt_flags;
-	u8  rt_rate;
-	u16 rt_channel;
-	u16 rt_chbitmask;
-} __attribute__((packed));
-
-static void fill_rt_header(void *buffer, struct zd_mac *mac,
-	                   const struct ieee80211_rx_stats *stats,
-			   const struct rx_status *status)
-{
-	struct zd_rt_hdr *hdr = buffer;
-
-	hdr->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
-	hdr->rt_hdr.it_pad = 0;
-	hdr->rt_hdr.it_len = cpu_to_le16(sizeof(struct zd_rt_hdr));
-	hdr->rt_hdr.it_present = cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-		                 (1 << IEEE80211_RADIOTAP_CHANNEL) |
-				 (1 << IEEE80211_RADIOTAP_RATE));
-
-	hdr->rt_flags = 0;
-	if (status->decryption_type & (ZD_RX_WEP64|ZD_RX_WEP128|ZD_RX_WEP256))
-		hdr->rt_flags |= IEEE80211_RADIOTAP_F_WEP;
-
-	hdr->rt_rate = stats->rate / 5;
-
-	/* FIXME: 802.11a */
-	hdr->rt_channel = cpu_to_le16(ieee80211chan2mhz(
-		                             _zd_chip_get_channel(&mac->chip)));
-	hdr->rt_chbitmask = cpu_to_le16(IEEE80211_CHAN_2GHZ |
-		((status->frame_status & ZD_RX_FRAME_MODULATION_MASK) ==
-		ZD_RX_OFDM ? IEEE80211_CHAN_OFDM : IEEE80211_CHAN_CCK));
-}
-
-/* Returns 1 if the data packet is for us and 0 otherwise. */
-static int is_data_packet_for_us(struct ieee80211_device *ieee,
-	                         struct ieee80211_hdr_4addr *hdr)
-{
-	struct net_device *netdev = ieee->dev;
-	u16 fc = le16_to_cpu(hdr->frame_ctl);
-
-	ZD_ASSERT(WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA);
-
-	switch (ieee->iw_mode) {
-	case IW_MODE_ADHOC:
-		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) != 0 ||
-		    compare_ether_addr(hdr->addr3, ieee->bssid) != 0)
-			return 0;
-		break;
-	case IW_MODE_AUTO:
-	case IW_MODE_INFRA:
-		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) !=
-		    IEEE80211_FCTL_FROMDS ||
-		    compare_ether_addr(hdr->addr2, ieee->bssid) != 0)
-			return 0;
-		break;
-	default:
-		ZD_ASSERT(ieee->iw_mode != IW_MODE_MONITOR);
-		return 0;
-	}
-
-	return compare_ether_addr(hdr->addr1, netdev->dev_addr) == 0 ||
-	       (is_multicast_ether_addr(hdr->addr1) &&
-		compare_ether_addr(hdr->addr3, netdev->dev_addr) != 0) ||
-	       (netdev->flags & IFF_PROMISC);
-}
-
-/* Filters received packets. The function returns 1 if the packet should be
- * forwarded to ieee80211_rx(). If the packet should be ignored the function
- * returns 0. If an invalid packet is found the function returns -EINVAL.
+/**
+ * filter_ack - filters incoming packets for acknowledgements
+ * @dev: the mac80211 device
+ * @rx_hdr: received header
+ * @stats: the status for the received packet
  *
- * The function calls ieee80211_rx_mgt() directly.
+ * This functions looks for ACK packets and tries to match them with the
+ * frames in the tx queue. If a match is found the frame will be dequeued and
+ * the upper layers is informed about the successful transmission. If
+ * mac80211 queues have been stopped and the number of frames still to be
+ * transmitted is low the queues will be opened again.
  *
- * It has been based on ieee80211_rx_any.
+ * Returns 1 if the frame was an ACK, 0 if it was ignored.
  */
-static int filter_rx(struct ieee80211_device *ieee,
-	             const u8 *buffer, unsigned int length,
-		     struct ieee80211_rx_stats *stats)
+static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
+		      struct ieee80211_rx_status *stats)
 {
-	struct ieee80211_hdr_4addr *hdr;
-	u16 fc;
-
-	if (ieee->iw_mode == IW_MODE_MONITOR)
-		return 1;
-
-	hdr = (struct ieee80211_hdr_4addr *)buffer;
-	fc = le16_to_cpu(hdr->frame_ctl);
-	if ((fc & IEEE80211_FCTL_VERS) != 0)
-		return -EINVAL;
+	u16 fc = le16_to_cpu(rx_hdr->frame_control);
+	struct sk_buff *skb;
+	struct sk_buff_head *q;
+	unsigned long flags;
 
-	switch (WLAN_FC_GET_TYPE(fc)) {
-	case IEEE80211_FTYPE_MGMT:
-		if (length < sizeof(struct ieee80211_hdr_3addr))
-			return -EINVAL;
-		ieee80211_rx_mgt(ieee, hdr, stats);
+	if ((fc & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) !=
+	    (IEEE80211_FTYPE_CTL | IEEE80211_STYPE_ACK))
 		return 0;
-	case IEEE80211_FTYPE_CTL:
-		return 0;
-	case IEEE80211_FTYPE_DATA:
-		/* Ignore invalid short buffers */
-		if (length < sizeof(struct ieee80211_hdr_3addr))
-			return -EINVAL;
-		return is_data_packet_for_us(ieee, hdr);
-	}
 
-	return -EINVAL;
+	q = &zd_hw_mac(hw)->ack_wait_queue;
+	spin_lock_irqsave(&q->lock, flags);
+	for (skb = q->next; skb != (struct sk_buff *)q; skb = skb->next) {
+		struct ieee80211_hdr *tx_hdr;
+
+		tx_hdr = (struct ieee80211_hdr *)skb->data;
+		if (likely(!compare_ether_addr(tx_hdr->addr2, rx_hdr->addr1)))
+		{
+			struct ieee80211_tx_status status = {{0}};
+			status.flags = IEEE80211_TX_STATUS_ACK;
+			status.ack_signal = stats->ssi;
+			__skb_unlink(skb, q);
+			tx_status(hw, skb, &status, 1);
+			goto out;
+		}
+	}
+out:
+	spin_unlock_irqrestore(&q->lock, flags);
+	return 1;
 }
 
-static void update_qual_rssi(struct zd_mac *mac,
-			     const u8 *buffer, unsigned int length,
-			     u8 qual_percent, u8 rssi_percent)
+int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 {
-	unsigned long flags;
-	struct ieee80211_hdr_3addr *hdr;
-	int i;
+	struct zd_mac *mac = zd_hw_mac(hw);
+	struct ieee80211_rx_status stats;
+	const struct rx_status *status;
+	struct sk_buff *skb;
+	int bad_frame = 0;
 
-	hdr = (struct ieee80211_hdr_3addr *)buffer;
-	if (length < offsetof(struct ieee80211_hdr_3addr, addr3))
-		return;
-	if (compare_ether_addr(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid) != 0)
-		return;
+	if (length < ZD_PLCP_HEADER_SIZE + 10 /* IEEE80211_1ADDR_LEN */ +
+	             FCS_LEN + sizeof(struct rx_status))
+		return -EINVAL;
 
-	spin_lock_irqsave(&mac->lock, flags);
-	i = mac->stats_count % ZD_MAC_STATS_BUFFER_SIZE;
-	mac->qual_buffer[i] = qual_percent;
-	mac->rssi_buffer[i] = rssi_percent;
-	mac->stats_count++;
-	spin_unlock_irqrestore(&mac->lock, flags);
-}
+	memset(&stats, 0, sizeof(stats));
 
-static int fill_rx_stats(struct ieee80211_rx_stats *stats,
-	                 const struct rx_status **pstatus,
-		         struct zd_mac *mac,
-			 const u8 *buffer, unsigned int length)
-{
-	const struct rx_status *status;
+	/* Note about pass_failed_fcs and pass_ctrl access below:
+	 * mac locking intentionally omitted here, as this is the only unlocked
+	 * reader and the only writer is configure_filter. Plus, if there were
+	 * any races accessing these variables, it wouldn't really matter.
+	 * If mac80211 ever provides a way for us to access filter flags
+	 * from outside configure_filter, we could improve on this. Also, this
+	 * situation may change once we implement some kind of DMA-into-skb
+	 * RX path. */
 
-	*pstatus = status = (struct rx_status *)
+	/* Caller has to ensure that length >= sizeof(struct rx_status). */
+	status = (struct rx_status *)
 		(buffer + (length - sizeof(struct rx_status)));
 	if (status->frame_status & ZD_RX_ERROR) {
-		struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-		ieee->stats.rx_errors++;
-		if (status->frame_status & ZD_RX_TIMEOUT_ERROR)
-			ieee->stats.rx_missed_errors++;
-		else if (status->frame_status & ZD_RX_FIFO_OVERRUN_ERROR)
-			ieee->stats.rx_fifo_errors++;
-		else if (status->frame_status & ZD_RX_DECRYPTION_ERROR)
-			ieee->ieee_stats.rx_discards_undecryptable++;
-		else if (status->frame_status & ZD_RX_CRC32_ERROR) {
-			ieee->stats.rx_crc_errors++;
-			ieee->ieee_stats.rx_fcs_errors++;
+		if (mac->pass_failed_fcs &&
+				(status->frame_status & ZD_RX_CRC32_ERROR)) {
+			stats.flag |= RX_FLAG_FAILED_FCS_CRC;
+			bad_frame = 1;
+		} else {
+			return -EINVAL;
 		}
-		else if (status->frame_status & ZD_RX_CRC16_ERROR)
-			ieee->stats.rx_crc_errors++;
-		return -EINVAL;
 	}
 
-	memset(stats, 0, sizeof(struct ieee80211_rx_stats));
-	stats->len = length - (ZD_PLCP_HEADER_SIZE + IEEE80211_FCS_LEN +
-		               + sizeof(struct rx_status));
-	/* FIXME: 802.11a */
-	stats->freq = IEEE80211_24GHZ_BAND;
-	stats->received_channel = _zd_chip_get_channel(&mac->chip);
-	stats->rssi = zd_rx_strength_percent(status->signal_strength);
-	stats->signal = zd_rx_qual_percent(buffer,
+	stats.channel = _zd_chip_get_channel(&mac->chip);
+	stats.freq = zd_channels[stats.channel - 1].freq;
+	stats.phymode = MODE_IEEE80211G;
+	stats.ssi = status->signal_strength;
+	stats.signal = zd_rx_qual_percent(buffer,
 		                          length - sizeof(struct rx_status),
 		                          status);
-	stats->mask = IEEE80211_STATMASK_RSSI | IEEE80211_STATMASK_SIGNAL;
-	stats->rate = zd_rx_rate(buffer, status);
-	if (stats->rate)
-		stats->mask |= IEEE80211_STATMASK_RATE;
+	stats.rate = zd_rx_rate(buffer, status);
+
+	length -= ZD_PLCP_HEADER_SIZE + sizeof(struct rx_status);
+	buffer += ZD_PLCP_HEADER_SIZE;
+
+	/* Except for bad frames, filter each frame to see if it is an ACK, in
+	 * which case our internal TX tracking is updated. Normally we then
+	 * bail here as there's no need to pass ACKs on up to the stack, but
+	 * there is also the case where the stack has requested us to pass
+	 * control frames on up (pass_ctrl) which we must consider. */
+	if (!bad_frame &&
+			filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats)
+			&& !mac->pass_ctrl)
+		return 0;
 
+	skb = dev_alloc_skb(length);
+	if (skb == NULL)
+		return -ENOMEM;
+	memcpy(skb_put(skb, length), buffer, length);
+
+	ieee80211_rx_irqsafe(hw, skb, &stats);
 	return 0;
 }
 
-static void zd_mac_rx(struct zd_mac *mac, struct sk_buff *skb)
+static int zd_op_add_interface(struct ieee80211_hw *hw,
+				struct ieee80211_if_init_conf *conf)
 {
-	int r;
-	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-	struct ieee80211_rx_stats stats;
-	const struct rx_status *status;
+	struct zd_mac *mac = zd_hw_mac(hw);
 
-	if (skb->len < ZD_PLCP_HEADER_SIZE + IEEE80211_1ADDR_LEN +
-	               IEEE80211_FCS_LEN + sizeof(struct rx_status))
-	{
-		ieee->stats.rx_errors++;
-		ieee->stats.rx_length_errors++;
-		goto free_skb;
-	}
+	/* using IEEE80211_IF_TYPE_INVALID to indicate no mode selected */
+	if (mac->type != IEEE80211_IF_TYPE_INVALID)
+		return -EOPNOTSUPP;
 
-	r = fill_rx_stats(&stats, &status, mac, skb->data, skb->len);
-	if (r) {
-		/* Only packets with rx errors are included here.
-		 * The error stats have already been set in fill_rx_stats.
-		 */
-		goto free_skb;
+	switch (conf->type) {
+	case IEEE80211_IF_TYPE_MNTR:
+	case IEEE80211_IF_TYPE_STA:
+		mac->type = conf->type;
+		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 
-	__skb_pull(skb, ZD_PLCP_HEADER_SIZE);
-	__skb_trim(skb, skb->len -
-		        (IEEE80211_FCS_LEN + sizeof(struct rx_status)));
-
-	update_qual_rssi(mac, skb->data, skb->len, stats.signal,
-		         status->signal_strength);
-
-	r = filter_rx(ieee, skb->data, skb->len, &stats);
-	if (r <= 0) {
-		if (r < 0) {
-			ieee->stats.rx_errors++;
-			dev_dbg_f(zd_mac_dev(mac), "Error in packet.\n");
-		}
-		goto free_skb;
-	}
+	return zd_write_mac_addr(&mac->chip, conf->mac_addr);
+}
 
-	if (ieee->iw_mode == IW_MODE_MONITOR)
-		fill_rt_header(skb_push(skb, sizeof(struct zd_rt_hdr)), mac,
-			       &stats, status);
+static void zd_op_remove_interface(struct ieee80211_hw *hw,
+				    struct ieee80211_if_init_conf *conf)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+	mac->type = IEEE80211_IF_TYPE_INVALID;
+	zd_write_mac_addr(&mac->chip, NULL);
+}
 
-	r = ieee80211_rx(ieee, skb, &stats);
-	if (r)
-		return;
-free_skb:
-	/* We are always in a soft irq. */
-	dev_kfree_skb(skb);
+static int zd_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+	return zd_chip_set_channel(&mac->chip, conf->channel);
 }
 
-static void do_rx(unsigned long mac_ptr)
+static int zd_op_config_interface(struct ieee80211_hw *hw, int if_id,
+				   struct ieee80211_if_conf *conf)
 {
-	struct zd_mac *mac = (struct zd_mac *)mac_ptr;
-	struct sk_buff *skb;
+	struct zd_mac *mac = zd_hw_mac(hw);
 
-	while ((skb = skb_dequeue(&mac->rx_queue)) != NULL)
-		zd_mac_rx(mac, skb);
+	spin_lock_irq(&mac->lock);
+	mac->associated = is_valid_ether_addr(conf->bssid);
+	spin_unlock_irq(&mac->lock);
+
+	/* TODO: do hardware bssid filtering */
+	return 0;
 }
 
-int zd_mac_rx_irq(struct zd_mac *mac, const u8 *buffer, unsigned int length)
+static void set_multicast_hash_handler(struct work_struct *work)
 {
-	struct sk_buff *skb;
+	struct zd_mac *mac =
+		container_of(work, struct zd_mac, set_multicast_hash_work);
+	struct zd_mc_hash hash;
 
-	skb = dev_alloc_skb(sizeof(struct zd_rt_hdr) + length);
-	if (!skb) {
-		struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-		dev_warn(zd_mac_dev(mac), "Could not allocate skb.\n");
-		ieee->stats.rx_dropped++;
-		return -ENOMEM;
-	}
-	skb_reserve(skb, sizeof(struct zd_rt_hdr));
-	memcpy(__skb_put(skb, length), buffer, length);
-	skb_queue_tail(&mac->rx_queue, skb);
-	tasklet_schedule(&mac->rx_tasklet);
-	return 0;
+	spin_lock_irq(&mac->lock);
+	hash = mac->multicast_hash;
+	spin_unlock_irq(&mac->lock);
+
+	zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-static int netdev_tx(struct ieee80211_txb *txb, struct net_device *netdev,
-		     int pri)
+static void set_rx_filter_handler(struct work_struct *work)
 {
-	return zd_mac_tx(zd_netdev_mac(netdev), txb, pri);
+	struct zd_mac *mac =
+		container_of(work, struct zd_mac, set_rx_filter_work);
+	int r;
+
+	dev_dbg_f(zd_mac_dev(mac), "\n");
+	r = set_rx_filter(mac);
+	if (r)
+		dev_err(zd_mac_dev(mac), "set_rx_filter_handler error %d\n", r);
 }
 
-static void set_security(struct net_device *netdev,
-			 struct ieee80211_security *sec)
+#define SUPPORTED_FIF_FLAGS \
+	(FIF_PROMISC_IN_BSS | FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
+	FIF_OTHER_BSS)
+static void zd_op_configure_filter(struct ieee80211_hw *hw,
+			unsigned int changed_flags,
+			unsigned int *new_flags,
+			int mc_count, struct dev_mc_list *mclist)
 {
-	struct ieee80211_device *ieee = zd_netdev_ieee80211(netdev);
-	struct ieee80211_security *secinfo = &ieee->sec;
-	int keyidx;
-
-	dev_dbg_f(zd_mac_dev(zd_netdev_mac(netdev)), "\n");
-
-	for (keyidx = 0; keyidx<WEP_KEYS; keyidx++)
-		if (sec->flags & (1<<keyidx)) {
-			secinfo->encode_alg[keyidx] = sec->encode_alg[keyidx];
-			secinfo->key_sizes[keyidx] = sec->key_sizes[keyidx];
-			memcpy(secinfo->keys[keyidx], sec->keys[keyidx],
-			       SCM_KEY_LEN);
-		}
+	struct zd_mc_hash hash;
+	struct zd_mac *mac = zd_hw_mac(hw);
+	unsigned long flags;
+	int i;
 
-	if (sec->flags & SEC_ACTIVE_KEY) {
-		secinfo->active_key = sec->active_key;
-		dev_dbg_f(zd_mac_dev(zd_netdev_mac(netdev)),
-			"   .active_key = %d\n", sec->active_key);
-	}
-	if (sec->flags & SEC_UNICAST_GROUP) {
-		secinfo->unicast_uses_group = sec->unicast_uses_group;
-		dev_dbg_f(zd_mac_dev(zd_netdev_mac(netdev)),
-			"   .unicast_uses_group = %d\n",
-			sec->unicast_uses_group);
-	}
-	if (sec->flags & SEC_LEVEL) {
-		secinfo->level = sec->level;
-		dev_dbg_f(zd_mac_dev(zd_netdev_mac(netdev)),
-			"   .level = %d\n", sec->level);
-	}
-	if (sec->flags & SEC_ENABLED) {
-		secinfo->enabled = sec->enabled;
-		dev_dbg_f(zd_mac_dev(zd_netdev_mac(netdev)),
-			"   .enabled = %d\n", sec->enabled);
-	}
-	if (sec->flags & SEC_ENCRYPT) {
-		secinfo->encrypt = sec->encrypt;
-		dev_dbg_f(zd_mac_dev(zd_netdev_mac(netdev)),
-			"   .encrypt = %d\n", sec->encrypt);
-	}
-	if (sec->flags & SEC_AUTH_MODE) {
-		secinfo->auth_mode = sec->auth_mode;
-		dev_dbg_f(zd_mac_dev(zd_netdev_mac(netdev)),
-			"   .auth_mode = %d\n", sec->auth_mode);
+	/* Only deal with supported flags */
+	changed_flags &= SUPPORTED_FIF_FLAGS;
+	*new_flags &= SUPPORTED_FIF_FLAGS;
+
+	/* changed_flags is always populated but this driver
+	 * doesn't support all FIF flags so its possible we don't
+	 * need to do anything */
+	if (!changed_flags)
+		return;
+
+	if (*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)) {
+		zd_mc_add_all(&hash);
+	} else {
+		DECLARE_MAC_BUF(macbuf);
+
+		zd_mc_clear(&hash);
+		for (i = 0; i < mc_count; i++) {
+			if (!mclist)
+				break;
+			dev_dbg_f(zd_mac_dev(mac), "mc addr %s\n",
+				  print_mac(macbuf, mclist->dmi_addr));
+			zd_mc_add_addr(&hash, mclist->dmi_addr);
+			mclist = mclist->next;
+		}
 	}
+
+	spin_lock_irqsave(&mac->lock, flags);
+	mac->pass_failed_fcs = !!(*new_flags & FIF_FCSFAIL);
+	mac->pass_ctrl = !!(*new_flags & FIF_CONTROL);
+	mac->multicast_hash = hash;
+	spin_unlock_irqrestore(&mac->lock, flags);
+	queue_work(zd_workqueue, &mac->set_multicast_hash_work);
+
+	if (changed_flags & FIF_CONTROL)
+		queue_work(zd_workqueue, &mac->set_rx_filter_work);
+
+	/* no handling required for FIF_OTHER_BSS as we don't currently
+	 * do BSSID filtering */
+	/* FIXME: in future it would be nice to enable the probe response
+	 * filter (so that the driver doesn't see them) until
+	 * FIF_BCN_PRBRESP_PROMISC is set. however due to atomicity here, we'd
+	 * have to schedule work to enable prbresp reception, which might
+	 * happen too late. For now we'll just listen and forward them all the
+	 * time. */
 }
 
-static void ieee_init(struct ieee80211_device *ieee)
+static void set_rts_cts_work(struct work_struct *work)
 {
-	ieee->mode = IEEE_B | IEEE_G;
-	ieee->freq_band = IEEE80211_24GHZ_BAND;
-	ieee->modulation = IEEE80211_OFDM_MODULATION | IEEE80211_CCK_MODULATION;
-	ieee->tx_headroom = sizeof(struct zd_ctrlset);
-	ieee->set_security = set_security;
-	ieee->hard_start_xmit = netdev_tx;
-
-	/* Software encryption/decryption for now */
-	ieee->host_build_iv = 0;
-	ieee->host_encrypt = 1;
-	ieee->host_decrypt = 1;
-
-	/* FIXME: default to managed mode, until ieee80211 and zd1211rw can
-	 * correctly support AUTO */
-	ieee->iw_mode = IW_MODE_INFRA;
+	struct zd_mac *mac =
+		container_of(work, struct zd_mac, set_rts_cts_work);
+	unsigned long flags;
+	unsigned int short_preamble;
+
+	mutex_lock(&mac->chip.mutex);
+
+	spin_lock_irqsave(&mac->lock, flags);
+	mac->updating_rts_rate = 0;
+	short_preamble = mac->short_preamble;
+	spin_unlock_irqrestore(&mac->lock, flags);
+
+	zd_chip_set_rts_cts_rate_locked(&mac->chip, short_preamble);
+	mutex_unlock(&mac->chip.mutex);
 }
 
-static void softmac_init(struct ieee80211softmac_device *sm)
+static void zd_op_erp_ie_changed(struct ieee80211_hw *hw, u8 changes,
+				 int cts_protection, int preamble)
 {
-	sm->set_channel = set_channel;
-	sm->bssinfo_change = bssinfo_change;
+	struct zd_mac *mac = zd_hw_mac(hw);
+	unsigned long flags;
+
+	dev_dbg_f(zd_mac_dev(mac), "changes: %x\n", changes);
+
+	if (changes & IEEE80211_ERP_CHANGE_PREAMBLE) {
+		spin_lock_irqsave(&mac->lock, flags);
+		mac->short_preamble = !preamble;
+		if (!mac->updating_rts_rate) {
+			mac->updating_rts_rate = 1;
+			/* FIXME: should disable TX here, until work has
+			 * completed and RTS_CTS reg is updated */
+			queue_work(zd_workqueue, &mac->set_rts_cts_work);
+		}
+		spin_unlock_irqrestore(&mac->lock, flags);
+	}
 }
 
-struct iw_statistics *zd_mac_get_wireless_stats(struct net_device *ndev)
+static const struct ieee80211_ops zd_ops = {
+	.tx			= zd_op_tx,
+	.start			= zd_op_start,
+	.stop			= zd_op_stop,
+	.add_interface		= zd_op_add_interface,
+	.remove_interface	= zd_op_remove_interface,
+	.config			= zd_op_config,
+	.config_interface	= zd_op_config_interface,
+	.configure_filter	= zd_op_configure_filter,
+	.erp_ie_changed		= zd_op_erp_ie_changed,
+};
+
+struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 {
-	struct zd_mac *mac = zd_netdev_mac(ndev);
-	struct iw_statistics *iw_stats = &mac->iw_stats;
-	unsigned int i, count, qual_total, rssi_total;
+	struct zd_mac *mac;
+	struct ieee80211_hw *hw;
+	int i;
 
-	memset(iw_stats, 0, sizeof(struct iw_statistics));
-	/* We are not setting the status, because ieee->state is not updated
-	 * at all and this driver doesn't track authentication state.
-	 */
-	spin_lock_irq(&mac->lock);
-	count = mac->stats_count < ZD_MAC_STATS_BUFFER_SIZE ?
-		mac->stats_count : ZD_MAC_STATS_BUFFER_SIZE;
-	qual_total = rssi_total = 0;
-	for (i = 0; i < count; i++) {
-		qual_total += mac->qual_buffer[i];
-		rssi_total += mac->rssi_buffer[i];
+	hw = ieee80211_alloc_hw(sizeof(struct zd_mac), &zd_ops);
+	if (!hw) {
+		dev_dbg_f(&intf->dev, "out of memory\n");
+		return NULL;
 	}
-	spin_unlock_irq(&mac->lock);
-	iw_stats->qual.updated = IW_QUAL_NOISE_INVALID;
-	if (count > 0) {
-		iw_stats->qual.qual = qual_total / count;
-		iw_stats->qual.level = rssi_total / count;
-		iw_stats->qual.updated |=
-			IW_QUAL_QUAL_UPDATED|IW_QUAL_LEVEL_UPDATED;
-	} else {
-		iw_stats->qual.updated |=
-			IW_QUAL_QUAL_INVALID|IW_QUAL_LEVEL_INVALID;
+
+	mac = zd_hw_mac(hw);
+
+	memset(mac, 0, sizeof(*mac));
+	spin_lock_init(&mac->lock);
+	mac->hw = hw;
+
+	mac->type = IEEE80211_IF_TYPE_INVALID;
+
+	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
+	memcpy(mac->rates, zd_rates, sizeof(zd_rates));
+	mac->modes[0].mode = MODE_IEEE80211G;
+	mac->modes[0].num_rates = ARRAY_SIZE(zd_rates);
+	mac->modes[0].rates = mac->rates;
+	mac->modes[0].num_channels = ARRAY_SIZE(zd_channels);
+	mac->modes[0].channels = mac->channels;
+	mac->modes[1].mode = MODE_IEEE80211B;
+	mac->modes[1].num_rates = 4;
+	mac->modes[1].rates = mac->rates;
+	mac->modes[1].num_channels = ARRAY_SIZE(zd_channels);
+	mac->modes[1].channels = mac->channels;
+
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+		     IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
+	hw->max_rssi = 100;
+	hw->max_signal = 100;
+
+	hw->queues = 1;
+	hw->extra_tx_headroom = sizeof(struct zd_ctrlset);
+
+	skb_queue_head_init(&mac->ack_wait_queue);
+
+	for (i = 0; i < 2; i++) {
+		if (ieee80211_register_hwmode(hw, &mac->modes[i])) {
+			dev_dbg_f(&intf->dev, "cannot register hwmode\n");
+			ieee80211_free_hw(hw);
+			return NULL;
+		}
 	}
-	/* TODO: update counter */
-	return iw_stats;
+
+	zd_chip_init(&mac->chip, hw, intf);
+	housekeeping_init(mac);
+	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
+	INIT_WORK(&mac->set_rts_cts_work, set_rts_cts_work);
+	INIT_WORK(&mac->set_rx_filter_work, set_rx_filter_handler);
+
+	SET_IEEE80211_DEV(hw, &intf->dev);
+	return hw;
 }
 
 #define LINK_LED_WORK_DELAY HZ
@@ -1302,18 +931,17 @@ static void link_led_handler(struct work_struct *work)
 	struct zd_mac *mac =
 		container_of(work, struct zd_mac, housekeeping.link_led_work.work);
 	struct zd_chip *chip = &mac->chip;
-	struct ieee80211softmac_device *sm = ieee80211_priv(mac->netdev);
 	int is_associated;
 	int r;
 
 	spin_lock_irq(&mac->lock);
-	is_associated = sm->associnfo.associated != 0;
+	is_associated = mac->associated;
 	spin_unlock_irq(&mac->lock);
 
 	r = zd_chip_control_leds(chip,
 		                 is_associated ? LED_ASSOCIATED : LED_SCANNING);
 	if (r)
-		dev_err(zd_mac_dev(mac), "zd_chip_control_leds error %d\n", r);
+		dev_dbg_f(zd_mac_dev(mac), "zd_chip_control_leds error %d\n", r);
 
 	queue_delayed_work(zd_workqueue, &mac->housekeeping.link_led_work,
 		           LINK_LED_WORK_DELAY);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index 1b15bde..ed5417c 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -18,14 +18,11 @@
 #ifndef _ZD_MAC_H
 #define _ZD_MAC_H
 
-#include <linux/wireless.h>
 #include <linux/kernel.h>
-#include <linux/workqueue.h>
-#include <net/ieee80211.h>
-#include <net/ieee80211softmac.h>
+#include <net/mac80211.h>
 
 #include "zd_chip.h"
-#include "zd_netdev.h"
+#include "zd_ieee80211.h"
 
 struct zd_ctrlset {
 	u8     modulation;
@@ -57,7 +54,7 @@ struct zd_ctrlset {
 /* The two possible modulation types. Notify that 802.11b doesn't use the CCK
  * codeing for the 1 and 2 MBit/s rate. We stay with the term here to remain
  * consistent with uses the term at other places.
-  */
+ */
 #define ZD_CCK                  0x00
 #define ZD_OFDM                 0x10
 
@@ -141,58 +138,68 @@ struct rx_status {
 #define ZD_RX_CRC16_ERROR		0x40
 #define ZD_RX_ERROR			0x80
 
+enum mac_flags {
+	MAC_FIXED_CHANNEL = 0x01,
+};
+
 struct housekeeping {
 	struct delayed_work link_led_work;
 };
 
+/**
+ * struct zd_tx_skb_control_block - control block for tx skbuffs
+ * @control: &struct ieee80211_tx_control pointer
+ * @context: context pointer
+ *
+ * This structure is used to fill the cb field in an &sk_buff to transmit.
+ * The control field is NULL, if there is no requirement from the mac80211
+ * stack to report about the packet ACK. This is the case if the flag
+ * IEEE80211_TXCTL_NO_ACK is not set in &struct ieee80211_tx_control.
+ */
+struct zd_tx_skb_control_block {
+	struct ieee80211_tx_control *control;
+	struct ieee80211_hw *hw;
+	void *context;
+};
+
 #define ZD_MAC_STATS_BUFFER_SIZE 16
 
+#define ZD_MAC_MAX_ACK_WAITERS 10
+
 struct zd_mac {
 	struct zd_chip chip;
 	spinlock_t lock;
-	struct net_device *netdev;
-
-	/* Unlocked reading possible */
-	struct iw_statistics iw_stats;
-
+	struct ieee80211_hw *hw;
 	struct housekeeping housekeeping;
 	struct work_struct set_multicast_hash_work;
+	struct work_struct set_rts_cts_work;
+	struct work_struct set_rx_filter_work;
 	struct zd_mc_hash multicast_hash;
-	struct delayed_work set_rts_cts_work;
-	struct delayed_work set_basic_rates_work;
-
-	struct tasklet_struct rx_tasklet;
-	struct sk_buff_head rx_queue;
-
-	unsigned int stats_count;
-	u8 qual_buffer[ZD_MAC_STATS_BUFFER_SIZE];
-	u8 rssi_buffer[ZD_MAC_STATS_BUFFER_SIZE];
 	u8 regdomain;
 	u8 default_regdomain;
-	u8 requested_channel;
-
-	/* A bitpattern of cr_rates */
-	u16 basic_rates;
-
-	/* A zd_rate */
-	u8 rts_rate;
+	int type;
+	int associated;
+	struct sk_buff_head ack_wait_queue;
+	struct ieee80211_channel channels[14];
+	struct ieee80211_rate rates[12];
+	struct ieee80211_hw_mode modes[2];
 
 	/* Short preamble (used for RTS/CTS) */
 	unsigned int short_preamble:1;
 
 	/* flags to indicate update in progress */
 	unsigned int updating_rts_rate:1;
-	unsigned int updating_basic_rates:1;
-};
 
-static inline struct ieee80211_device *zd_mac_to_ieee80211(struct zd_mac *mac)
-{
-	return zd_netdev_ieee80211(mac->netdev);
-}
+	/* whether to pass frames with CRC errors to stack */
+	unsigned int pass_failed_fcs:1;
 
-static inline struct zd_mac *zd_netdev_mac(struct net_device *netdev)
+	/* whether to pass control frames to stack */
+	unsigned int pass_ctrl:1;
+};
+
+static inline struct zd_mac *zd_hw_mac(struct ieee80211_hw *hw)
 {
-	return ieee80211softmac_priv(netdev);
+	return hw->priv;
 }
 
 static inline struct zd_mac *zd_chip_to_mac(struct zd_chip *chip)
@@ -205,35 +212,22 @@ static inline struct zd_mac *zd_usb_to_mac(struct zd_usb *usb)
 	return zd_chip_to_mac(zd_usb_to_chip(usb));
 }
 
+static inline u8 *zd_mac_get_perm_addr(struct zd_mac *mac)
+{
+	return mac->hw->wiphy->perm_addr;
+}
+
 #define zd_mac_dev(mac) (zd_chip_dev(&(mac)->chip))
 
-int zd_mac_init(struct zd_mac *mac,
-                struct net_device *netdev,
-		struct usb_interface *intf);
+struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf);
 void zd_mac_clear(struct zd_mac *mac);
 
-int zd_mac_preinit_hw(struct zd_mac *mac);
-int zd_mac_init_hw(struct zd_mac *mac);
-
-int zd_mac_open(struct net_device *netdev);
-int zd_mac_stop(struct net_device *netdev);
-int zd_mac_set_mac_address(struct net_device *dev, void *p);
-void zd_mac_set_multicast_list(struct net_device *netdev);
-
-int zd_mac_rx_irq(struct zd_mac *mac, const u8 *buffer, unsigned int length);
-
-int zd_mac_set_regdomain(struct zd_mac *zd_mac, u8 regdomain);
-u8 zd_mac_get_regdomain(struct zd_mac *zd_mac);
-
-int zd_mac_request_channel(struct zd_mac *mac, u8 channel);
-u8 zd_mac_get_channel(struct zd_mac *mac);
-
-int zd_mac_set_mode(struct zd_mac *mac, u32 mode);
-int zd_mac_get_mode(struct zd_mac *mac, u32 *mode);
-
-int zd_mac_get_range(struct zd_mac *mac, struct iw_range *range);
+int zd_mac_preinit_hw(struct ieee80211_hw *hw);
+int zd_mac_init_hw(struct ieee80211_hw *hw);
 
-struct iw_statistics *zd_mac_get_wireless_stats(struct net_device *ndev);
+int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length);
+void zd_mac_tx_failed(struct ieee80211_hw *hw);
+void zd_mac_tx_to_dev(struct sk_buff *skb, int error);
 
 #ifdef DEBUG
 void zd_dump_rx_status(const struct rx_status *status);
diff --git a/drivers/net/wireless/zd1211rw/zd_netdev.c b/drivers/net/wireless/zd1211rw/zd_netdev.c
deleted file mode 100644
index 047cab3..0000000
--- a/drivers/net/wireless/zd1211rw/zd_netdev.c
+++ /dev/null
@@ -1,264 +0,0 @@
-/* zd_netdev.c
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
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/skbuff.h>
-#include <net/ieee80211.h>
-#include <net/ieee80211softmac.h>
-#include <net/ieee80211softmac_wx.h>
-#include <net/iw_handler.h>
-
-#include "zd_def.h"
-#include "zd_netdev.h"
-#include "zd_mac.h"
-#include "zd_ieee80211.h"
-
-/* Region 0 means reset regdomain to default. */
-static int zd_set_regdomain(struct net_device *netdev,
-	                    struct iw_request_info *info,
-			    union iwreq_data *req, char *extra)
-{
-	const u8 *regdomain = (u8 *)req;
-	return zd_mac_set_regdomain(zd_netdev_mac(netdev), *regdomain);
-}
-
-static int zd_get_regdomain(struct net_device *netdev,
-	                    struct iw_request_info *info,
-			    union iwreq_data *req, char *extra)
-{
-	u8 *regdomain = (u8 *)req;
-	if (!regdomain)
-		return -EINVAL;
-	*regdomain = zd_mac_get_regdomain(zd_netdev_mac(netdev));
-	return 0;
-}
-
-static const struct iw_priv_args zd_priv_args[] = {
-	{
-		.cmd = ZD_PRIV_SET_REGDOMAIN,
-		.set_args = IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | 1,
-		.name = "set_regdomain",
-	},
-	{
-		.cmd = ZD_PRIV_GET_REGDOMAIN,
-		.get_args = IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | 1,
-		.name = "get_regdomain",
-	},
-};
-
-#define PRIV_OFFSET(x) [(x)-SIOCIWFIRSTPRIV]
-
-static const iw_handler zd_priv_handler[] = {
-	PRIV_OFFSET(ZD_PRIV_SET_REGDOMAIN) = zd_set_regdomain,
-	PRIV_OFFSET(ZD_PRIV_GET_REGDOMAIN) = zd_get_regdomain,
-};
-
-static int iw_get_name(struct net_device *netdev,
-	               struct iw_request_info *info,
-		       union iwreq_data *req, char *extra)
-{
-	/* FIXME: check whether 802.11a will also supported */
-	strlcpy(req->name, "IEEE 802.11b/g", IFNAMSIZ);
-	return 0;
-}
-
-static int iw_get_nick(struct net_device *netdev,
-	               struct iw_request_info *info,
-		       union iwreq_data *req, char *extra)
-{
-	strcpy(extra, "zd1211");
-	req->data.length = strlen(extra);
-	req->data.flags = 1;
-	return 0;
-}
-
-static int iw_set_freq(struct net_device *netdev,
-	               struct iw_request_info *info,
-		       union iwreq_data *req, char *extra)
-{
-	int r;
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-	struct iw_freq *freq = &req->freq;
-	u8 channel;
-
-	r = zd_find_channel(&channel, freq);
-	if (r < 0)
-		return r;
-	r = zd_mac_request_channel(mac, channel);
-	return r;
-}
-
-static int iw_get_freq(struct net_device *netdev,
-	           struct iw_request_info *info,
-		   union iwreq_data *req, char *extra)
-{
-	struct zd_mac *mac = zd_netdev_mac(netdev);
-	struct iw_freq *freq = &req->freq;
-
-	return zd_channel_to_freq(freq, zd_mac_get_channel(mac));
-}
-
-static int iw_set_mode(struct net_device *netdev,
-	               struct iw_request_info *info,
-		       union iwreq_data *req, char *extra)
-{
-	return zd_mac_set_mode(zd_netdev_mac(netdev), req->mode);
-}
-
-static int iw_get_mode(struct net_device *netdev,
-	               struct iw_request_info *info,
-		       union iwreq_data *req, char *extra)
-{
-	return zd_mac_get_mode(zd_netdev_mac(netdev), &req->mode);
-}
-
-static int iw_get_range(struct net_device *netdev,
-	               struct iw_request_info *info,
-		       union iwreq_data *req, char *extra)
-{
-	struct iw_range *range = (struct iw_range *)extra;
-
-	dev_dbg_f(zd_mac_dev(zd_netdev_mac(netdev)), "\n");
-	req->data.length = sizeof(*range);
-	return zd_mac_get_range(zd_netdev_mac(netdev), range);
-}
-
-static int iw_set_encode(struct net_device *netdev,
-			 struct iw_request_info *info,
-			 union iwreq_data *data,
-			 char *extra)
-{
-	return ieee80211_wx_set_encode(zd_netdev_ieee80211(netdev), info,
-		data, extra);
-}
-
-static int iw_get_encode(struct net_device *netdev,
-			 struct iw_request_info *info,
-			 union iwreq_data *data,
-			 char *extra)
-{
-	return ieee80211_wx_get_encode(zd_netdev_ieee80211(netdev), info,
-		data, extra);
-}
-
-static int iw_set_encodeext(struct net_device *netdev,
-			 struct iw_request_info *info,
-			 union iwreq_data *data,
-			 char *extra)
-{
-	return ieee80211_wx_set_encodeext(zd_netdev_ieee80211(netdev), info,
-		data, extra);
-}
-
-static int iw_get_encodeext(struct net_device *netdev,
-			 struct iw_request_info *info,
-			 union iwreq_data *data,
-			 char *extra)
-{
-	return ieee80211_wx_get_encodeext(zd_netdev_ieee80211(netdev), info,
-		data, extra);
-}
-
-#define WX(x) [(x)-SIOCIWFIRST]
-
-static const iw_handler zd_standard_iw_handlers[] = {
-	WX(SIOCGIWNAME)		= iw_get_name,
-	WX(SIOCGIWNICKN)	= iw_get_nick,
-	WX(SIOCSIWFREQ)		= iw_set_freq,
-	WX(SIOCGIWFREQ)		= iw_get_freq,
-	WX(SIOCSIWMODE)		= iw_set_mode,
-	WX(SIOCGIWMODE)		= iw_get_mode,
-	WX(SIOCGIWRANGE)	= iw_get_range,
-	WX(SIOCSIWENCODE)	= iw_set_encode,
-	WX(SIOCGIWENCODE)	= iw_get_encode,
-	WX(SIOCSIWENCODEEXT)	= iw_set_encodeext,
-	WX(SIOCGIWENCODEEXT)	= iw_get_encodeext,
-	WX(SIOCSIWAUTH)		= ieee80211_wx_set_auth,
-	WX(SIOCGIWAUTH)		= ieee80211_wx_get_auth,
-	WX(SIOCSIWSCAN)		= ieee80211softmac_wx_trigger_scan,
-	WX(SIOCGIWSCAN)		= ieee80211softmac_wx_get_scan_results,
-	WX(SIOCSIWESSID)	= ieee80211softmac_wx_set_essid,
-	WX(SIOCGIWESSID)	= ieee80211softmac_wx_get_essid,
-	WX(SIOCSIWAP)		= ieee80211softmac_wx_set_wap,
-	WX(SIOCGIWAP)		= ieee80211softmac_wx_get_wap,
-	WX(SIOCSIWRATE)		= ieee80211softmac_wx_set_rate,
-	WX(SIOCGIWRATE)		= ieee80211softmac_wx_get_rate,
-	WX(SIOCSIWGENIE)	= ieee80211softmac_wx_set_genie,
-	WX(SIOCGIWGENIE)	= ieee80211softmac_wx_get_genie,
-	WX(SIOCSIWMLME)		= ieee80211softmac_wx_set_mlme,
-};
-
-static const struct iw_handler_def iw_handler_def = {
-	.standard		= zd_standard_iw_handlers,
-	.num_standard		= ARRAY_SIZE(zd_standard_iw_handlers),
-	.private		= zd_priv_handler,
-	.num_private		= ARRAY_SIZE(zd_priv_handler),
-	.private_args		= zd_priv_args,
-	.num_private_args	= ARRAY_SIZE(zd_priv_args),
-	.get_wireless_stats	= zd_mac_get_wireless_stats,
-};
-
-struct net_device *zd_netdev_alloc(struct usb_interface *intf)
-{
-	int r;
-	struct net_device *netdev;
-	struct zd_mac *mac;
-
-	netdev = alloc_ieee80211softmac(sizeof(struct zd_mac));
-	if (!netdev) {
-		dev_dbg_f(&intf->dev, "out of memory\n");
-		return NULL;
-	}
-
-	mac = zd_netdev_mac(netdev);
-	r = zd_mac_init(mac, netdev, intf);
-	if (r) {
-		usb_set_intfdata(intf, NULL);
-		free_ieee80211(netdev);
-		return NULL;
-	}
-
-	SET_NETDEV_DEV(netdev, &intf->dev);
-
-	dev_dbg_f(&intf->dev, "netdev->flags %#06hx\n", netdev->flags);
-	dev_dbg_f(&intf->dev, "netdev->features %#010lx\n", netdev->features);
-
-	netdev->open = zd_mac_open;
-	netdev->stop = zd_mac_stop;
-	/* netdev->get_stats = */
-	netdev->set_multicast_list = zd_mac_set_multicast_list;
-	netdev->set_mac_address = zd_mac_set_mac_address;
-	netdev->wireless_handlers = &iw_handler_def;
-	/* netdev->ethtool_ops = */
-
-	return netdev;
-}
-
-void zd_netdev_free(struct net_device *netdev)
-{
-	if (!netdev)
-		return;
-
-	zd_mac_clear(zd_netdev_mac(netdev));
-	free_ieee80211(netdev);
-}
-
-void zd_netdev_disconnect(struct net_device *netdev)
-{
-	unregister_netdev(netdev);
-}
diff --git a/drivers/net/wireless/zd1211rw/zd_netdev.h b/drivers/net/wireless/zd1211rw/zd_netdev.h
deleted file mode 100644
index 374a957..0000000
--- a/drivers/net/wireless/zd1211rw/zd_netdev.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* zd_netdev.h: Header for net device related functions.
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
-#ifndef _ZD_NETDEV_H
-#define _ZD_NETDEV_H
-
-#include <linux/usb.h>
-#include <linux/netdevice.h>
-#include <net/ieee80211.h>
-
-#define ZD_PRIV_SET_REGDOMAIN (SIOCIWFIRSTPRIV)
-#define ZD_PRIV_GET_REGDOMAIN (SIOCIWFIRSTPRIV+1)
-
-static inline struct ieee80211_device *zd_netdev_ieee80211(
-	struct net_device *ndev)
-{
-	return netdev_priv(ndev);
-}
-
-static inline struct net_device *zd_ieee80211_to_netdev(
-	struct ieee80211_device *ieee)
-{
-	return ieee->dev;
-}
-
-struct net_device *zd_netdev_alloc(struct usb_interface *intf);
-void zd_netdev_free(struct net_device *netdev);
-
-void zd_netdev_disconnect(struct net_device *netdev);
-
-#endif /* _ZD_NETDEV_H */
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index c755b69..3429576 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -17,18 +17,16 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
 #include <linux/usb.h>
 #include <linux/workqueue.h>
-#include <net/ieee80211.h>
+#include <net/mac80211.h>
 #include <asm/unaligned.h>
 
 #include "zd_def.h"
-#include "zd_netdev.h"
 #include "zd_mac.h"
 #include "zd_usb.h"
 
@@ -353,18 +351,6 @@ out:
 	spin_unlock(&intr->lock);
 }
 
-static inline void handle_retry_failed_int(struct urb *urb)
-{
-	struct zd_usb *usb = urb->context;
-	struct zd_mac *mac = zd_usb_to_mac(usb);
-	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-
-	ieee->stats.tx_errors++;
-	ieee->ieee_stats.tx_retry_limit_exceeded++;
-	dev_dbg_f(urb_dev(urb), "retry failed interrupt\n");
-}
-
-
 static void int_urb_complete(struct urb *urb)
 {
 	int r;
@@ -400,7 +386,7 @@ static void int_urb_complete(struct urb *urb)
 		handle_regs_int(urb);
 		break;
 	case USB_INT_ID_RETRY_FAILED:
-		handle_retry_failed_int(urb);
+		zd_mac_tx_failed(zd_usb_to_hw(urb->context));
 		break;
 	default:
 		dev_dbg_f(urb_dev(urb), "error: urb %p unknown id %x\n", urb,
@@ -530,14 +516,10 @@ static void handle_rx_packet(struct zd_usb *usb, const u8 *buffer,
 			     unsigned int length)
 {
 	int i;
-	struct zd_mac *mac = zd_usb_to_mac(usb);
 	const struct rx_length_info *length_info;
 
 	if (length < sizeof(struct rx_length_info)) {
 		/* It's not a complete packet anyhow. */
-		struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-		ieee->stats.rx_errors++;
-		ieee->stats.rx_length_errors++;
 		return;
 	}
 	length_info = (struct rx_length_info *)
@@ -561,13 +543,13 @@ static void handle_rx_packet(struct zd_usb *usb, const u8 *buffer,
 			n = l+k;
 			if (n > length)
 				return;
-			zd_mac_rx_irq(mac, buffer+l, k);
+			zd_mac_rx(zd_usb_to_hw(usb), buffer+l, k);
 			if (i >= 2)
 				return;
 			l = (n+3) & ~3;
 		}
 	} else {
-		zd_mac_rx_irq(mac, buffer, length);
+		zd_mac_rx(zd_usb_to_hw(usb), buffer, length);
 	}
 }
 
@@ -629,7 +611,7 @@ resubmit:
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
 
-static struct urb *alloc_urb(struct zd_usb *usb)
+static struct urb *alloc_rx_urb(struct zd_usb *usb)
 {
 	struct usb_device *udev = zd_usb_to_usbdev(usb);
 	struct urb *urb;
@@ -653,7 +635,7 @@ static struct urb *alloc_urb(struct zd_usb *usb)
 	return urb;
 }
 
-static void free_urb(struct urb *urb)
+static void free_rx_urb(struct urb *urb)
 {
 	if (!urb)
 		return;
@@ -671,11 +653,11 @@ int zd_usb_enable_rx(struct zd_usb *usb)
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
 	r = -ENOMEM;
-	urbs = kcalloc(URBS_COUNT, sizeof(struct urb *), GFP_KERNEL);
+	urbs = kcalloc(RX_URBS_COUNT, sizeof(struct urb *), GFP_KERNEL);
 	if (!urbs)
 		goto error;
-	for (i = 0; i < URBS_COUNT; i++) {
-		urbs[i] = alloc_urb(usb);
+	for (i = 0; i < RX_URBS_COUNT; i++) {
+		urbs[i] = alloc_rx_urb(usb);
 		if (!urbs[i])
 			goto error;
 	}
@@ -688,10 +670,10 @@ int zd_usb_enable_rx(struct zd_usb *usb)
 		goto error;
 	}
 	rx->urbs = urbs;
-	rx->urbs_count = URBS_COUNT;
+	rx->urbs_count = RX_URBS_COUNT;
 	spin_unlock_irq(&rx->lock);
 
-	for (i = 0; i < URBS_COUNT; i++) {
+	for (i = 0; i < RX_URBS_COUNT; i++) {
 		r = usb_submit_urb(urbs[i], GFP_KERNEL);
 		if (r)
 			goto error_submit;
@@ -699,7 +681,7 @@ int zd_usb_enable_rx(struct zd_usb *usb)
 
 	return 0;
 error_submit:
-	for (i = 0; i < URBS_COUNT; i++) {
+	for (i = 0; i < RX_URBS_COUNT; i++) {
 		usb_kill_urb(urbs[i]);
 	}
 	spin_lock_irq(&rx->lock);
@@ -708,8 +690,8 @@ error_submit:
 	spin_unlock_irq(&rx->lock);
 error:
 	if (urbs) {
-		for (i = 0; i < URBS_COUNT; i++)
-			free_urb(urbs[i]);
+		for (i = 0; i < RX_URBS_COUNT; i++)
+			free_rx_urb(urbs[i]);
 	}
 	return r;
 }
@@ -731,7 +713,7 @@ void zd_usb_disable_rx(struct zd_usb *usb)
 
 	for (i = 0; i < count; i++) {
 		usb_kill_urb(urbs[i]);
-		free_urb(urbs[i]);
+		free_rx_urb(urbs[i]);
 	}
 	kfree(urbs);
 
@@ -741,9 +723,142 @@ void zd_usb_disable_rx(struct zd_usb *usb)
 	spin_unlock_irqrestore(&rx->lock, flags);
 }
 
+/**
+ * zd_usb_disable_tx - disable transmission
+ * @usb: the zd1211rw-private USB structure
+ *
+ * Frees all URBs in the free list and marks the transmission as disabled.
+ */
+void zd_usb_disable_tx(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+	struct list_head *pos, *n;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	list_for_each_safe(pos, n, &tx->free_urb_list) {
+		list_del(pos);
+		usb_free_urb(list_entry(pos, struct urb, urb_list));
+	}
+	tx->enabled = 0;
+	tx->submitted_urbs = 0;
+	/* The stopped state is ignored, relying on ieee80211_wake_queues()
+	 * in a potentionally following zd_usb_enable_tx().
+	 */
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+/**
+ * zd_usb_enable_tx - enables transmission
+ * @usb: a &struct zd_usb pointer
+ *
+ * This function enables transmission and prepares the &zd_usb_tx data
+ * structure.
+ */
+void zd_usb_enable_tx(struct zd_usb *usb)
+{
+	unsigned long flags;
+	struct zd_usb_tx *tx = &usb->tx;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	tx->enabled = 1;
+	tx->submitted_urbs = 0;
+	ieee80211_wake_queues(zd_usb_to_hw(usb));
+	tx->stopped = 0;
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+/**
+ * alloc_tx_urb - provides an tx URB
+ * @usb: a &struct zd_usb pointer
+ *
+ * Allocates a new URB. If possible takes the urb from the free list in
+ * usb->tx.
+ */
+static struct urb *alloc_tx_urb(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+	struct list_head *entry;
+	struct urb *urb;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	if (list_empty(&tx->free_urb_list)) {
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
+		goto out;
+	}
+	entry = tx->free_urb_list.next;
+	list_del(entry);
+	urb = list_entry(entry, struct urb, urb_list);
+out:
+	spin_unlock_irqrestore(&tx->lock, flags);
+	return urb;
+}
+
+/**
+ * free_tx_urb - frees a used tx URB
+ * @usb: a &struct zd_usb pointer
+ * @urb: URB to be freed
+ *
+ * Frees the the transmission URB, which means to put it on the free URB
+ * list.
+ */
+static void free_tx_urb(struct zd_usb *usb, struct urb *urb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	if (!tx->enabled) {
+		usb_free_urb(urb);
+		goto out;
+	}
+	list_add(&urb->urb_list, &tx->free_urb_list);
+out:
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static void tx_dec_submitted_urbs(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	--tx->submitted_urbs;
+	if (tx->stopped && tx->submitted_urbs <= ZD_USB_TX_LOW) {
+		ieee80211_wake_queues(zd_usb_to_hw(usb));
+		tx->stopped = 0;
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static void tx_inc_submitted_urbs(struct zd_usb *usb)
+{
+	struct zd_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	++tx->submitted_urbs;
+	if (!tx->stopped && tx->submitted_urbs > ZD_USB_TX_HIGH) {
+		ieee80211_stop_queues(zd_usb_to_hw(usb));
+		tx->stopped = 1;
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+/**
+ * tx_urb_complete - completes the execution of an URB
+ * @urb: a URB
+ *
+ * This function is called if the URB has been transferred to a device or an
+ * error has happened.
+ */
 static void tx_urb_complete(struct urb *urb)
 {
 	int r;
+	struct sk_buff *skb;
+	struct zd_tx_skb_control_block *cb;
+	struct zd_usb *usb;
 
 	switch (urb->status) {
 	case 0:
@@ -761,9 +876,12 @@ static void tx_urb_complete(struct urb *urb)
 		goto resubmit;
 	}
 free_urb:
-	usb_buffer_free(urb->dev, urb->transfer_buffer_length,
-		        urb->transfer_buffer, urb->transfer_dma);
-	usb_free_urb(urb);
+	skb = (struct sk_buff *)urb->context;
+	zd_mac_tx_to_dev(skb, urb->status);
+	cb = (struct zd_tx_skb_control_block *)skb->cb;
+	usb = &zd_hw_mac(cb->hw)->chip.usb;
+	free_tx_urb(usb, urb);
+	tx_dec_submitted_urbs(usb);
 	return;
 resubmit:
 	r = usb_submit_urb(urb, GFP_ATOMIC);
@@ -773,43 +891,40 @@ resubmit:
 	}
 }
 
-/* Puts the frame on the USB endpoint. It doesn't wait for
- * completion. The frame must contain the control set.
+/**
+ * zd_usb_tx: initiates transfer of a frame of the device
+ *
+ * @usb: the zd1211rw-private USB structure
+ * @skb: a &struct sk_buff pointer
+ *
+ * This function tranmits a frame to the device. It doesn't wait for
+ * completion. The frame must contain the control set and have all the
+ * control set information available.
+ *
+ * The function returns 0 if the transfer has been successfully initiated.
  */
-int zd_usb_tx(struct zd_usb *usb, const u8 *frame, unsigned int length)
+int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb)
 {
 	int r;
 	struct usb_device *udev = zd_usb_to_usbdev(usb);
 	struct urb *urb;
-	void *buffer;
 
-	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	urb = alloc_tx_urb(usb);
 	if (!urb) {
 		r = -ENOMEM;
 		goto out;
 	}
 
-	buffer = usb_buffer_alloc(zd_usb_to_usbdev(usb), length, GFP_ATOMIC,
-		                  &urb->transfer_dma);
-	if (!buffer) {
-		r = -ENOMEM;
-		goto error_free_urb;
-	}
-	memcpy(buffer, frame, length);
-
 	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
-		          buffer, length, tx_urb_complete, NULL);
-	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+		          skb->data, skb->len, tx_urb_complete, skb);
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
 	if (r)
 		goto error;
+	tx_inc_submitted_urbs(usb);
 	return 0;
 error:
-	usb_buffer_free(zd_usb_to_usbdev(usb), length, buffer,
-		        urb->transfer_dma);
-error_free_urb:
-	usb_free_urb(urb);
+	free_tx_urb(usb, urb);
 out:
 	return r;
 }
@@ -838,16 +953,20 @@ static inline void init_usb_rx(struct zd_usb *usb)
 
 static inline void init_usb_tx(struct zd_usb *usb)
 {
-	/* FIXME: at this point we will allocate a fixed number of urb's for
-	 * use in a cyclic scheme */
+	struct zd_usb_tx *tx = &usb->tx;
+	spin_lock_init(&tx->lock);
+	tx->enabled = 0;
+	tx->stopped = 0;
+	INIT_LIST_HEAD(&tx->free_urb_list);
+	tx->submitted_urbs = 0;
 }
 
-void zd_usb_init(struct zd_usb *usb, struct net_device *netdev,
+void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *hw,
 	         struct usb_interface *intf)
 {
 	memset(usb, 0, sizeof(*usb));
 	usb->intf = usb_get_intf(intf);
-	usb_set_intfdata(usb->intf, netdev);
+	usb_set_intfdata(usb->intf, hw);
 	init_usb_interrupt(usb);
 	init_usb_tx(usb);
 	init_usb_rx(usb);
@@ -973,7 +1092,7 @@ int zd_usb_init_hw(struct zd_usb *usb)
 		return r;
 	}
 
-	r = zd_mac_init_hw(mac);
+	r = zd_mac_init_hw(mac->hw);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 		         "couldn't initialize mac. Error number %d\n", r);
@@ -987,9 +1106,9 @@ int zd_usb_init_hw(struct zd_usb *usb)
 static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	int r;
-	struct zd_usb *usb;
 	struct usb_device *udev = interface_to_usbdev(intf);
-	struct net_device *netdev = NULL;
+	struct zd_usb *usb;
+	struct ieee80211_hw *hw = NULL;
 
 	print_id(udev);
 
@@ -1007,57 +1126,65 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto error;
 	}
 
-	usb_reset_device(interface_to_usbdev(intf));
+	r = usb_reset_device(udev);
+	if (r) {
+		dev_err(&intf->dev,
+			"couldn't reset usb device. Error number %d\n", r);
+		goto error;
+	}
 
-	netdev = zd_netdev_alloc(intf);
-	if (netdev == NULL) {
+	hw = zd_mac_alloc_hw(intf);
+	if (hw == NULL) {
 		r = -ENOMEM;
 		goto error;
 	}
 
-	usb = &zd_netdev_mac(netdev)->chip.usb;
+	usb = &zd_hw_mac(hw)->chip.usb;
 	usb->is_zd1211b = (id->driver_info == DEVICE_ZD1211B) != 0;
 
-	r = zd_mac_preinit_hw(zd_netdev_mac(netdev));
+	r = zd_mac_preinit_hw(hw);
 	if (r) {
 		dev_dbg_f(&intf->dev,
 		         "couldn't initialize mac. Error number %d\n", r);
 		goto error;
 	}
 
-	r = register_netdev(netdev);
+	r = ieee80211_register_hw(hw);
 	if (r) {
 		dev_dbg_f(&intf->dev,
-			 "couldn't register netdev. Error number %d\n", r);
+			 "couldn't register device. Error number %d\n", r);
 		goto error;
 	}
 
 	dev_dbg_f(&intf->dev, "successful\n");
-	dev_info(&intf->dev,"%s\n", netdev->name);
+	dev_info(&intf->dev, "%s\n", wiphy_name(hw->wiphy));
 	return 0;
 error:
 	usb_reset_device(interface_to_usbdev(intf));
-	zd_netdev_free(netdev);
+	if (hw) {
+		zd_mac_clear(zd_hw_mac(hw));
+		ieee80211_free_hw(hw);
+	}
 	return r;
 }
 
 static void disconnect(struct usb_interface *intf)
 {
-	struct net_device *netdev = zd_intf_to_netdev(intf);
+	struct ieee80211_hw *hw = zd_intf_to_hw(intf);
 	struct zd_mac *mac;
 	struct zd_usb *usb;
 
 	/* Either something really bad happened, or we're just dealing with
 	 * a DEVICE_INSTALLER. */
-	if (netdev == NULL)
+	if (hw == NULL)
 		return;
 
-	mac = zd_netdev_mac(netdev);
+	mac = zd_hw_mac(hw);
 	usb = &mac->chip.usb;
 
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
-	zd_netdev_disconnect(netdev);
+	ieee80211_unregister_hw(hw);
 
 	/* Just in case something has gone wrong! */
 	zd_usb_disable_rx(usb);
@@ -1070,12 +1197,13 @@ static void disconnect(struct usb_interface *intf)
 	 */
 	usb_reset_device(interface_to_usbdev(intf));
 
-	zd_netdev_free(netdev);
+	zd_mac_clear(mac);
+	ieee80211_free_hw(hw);
 	dev_dbg(&intf->dev, "disconnected\n");
 }
 
 static struct usb_driver driver = {
-	.name		= "zd1211rw",
+	.name		= KBUILD_MODNAME,
 	.id_table	= usb_ids,
 	.probe		= probe,
 	.disconnect	= disconnect,
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 961a7a1..42159fc 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -26,6 +26,9 @@
 
 #include "zd_def.h"
 
+#define ZD_USB_TX_HIGH  5
+#define ZD_USB_TX_LOW   2
+
 enum devicetype {
 	DEVICE_ZD1211  = 0,
 	DEVICE_ZD1211B = 1,
@@ -165,7 +168,7 @@ static inline struct usb_int_regs *get_read_regs(struct zd_usb_interrupt *intr)
 	return (struct usb_int_regs *)intr->read_regs.buffer;
 }
 
-#define URBS_COUNT 5
+#define RX_URBS_COUNT 5
 
 struct zd_usb_rx {
 	spinlock_t lock;
@@ -176,8 +179,21 @@ struct zd_usb_rx {
 	int urbs_count;
 };
 
+/**
+ * struct zd_usb_tx - structure used for transmitting frames
+ * @lock: lock for transmission
+ * @free_urb_list: list of free URBs, contains all the URBs, which can be used
+ * @submitted_urbs: atomic integer that counts the URBs having sent to the
+ *	device, which haven't been completed
+ * @enabled: enabled flag, indicates whether tx is enabled
+ * @stopped: indicates whether higher level tx queues are stopped
+ */
 struct zd_usb_tx {
 	spinlock_t lock;
+	struct list_head free_urb_list;
+	int submitted_urbs;
+	int enabled;
+	int stopped;
 };
 
 /* Contains the usb parts. The structure doesn't require a lock because intf
@@ -198,17 +214,17 @@ static inline struct usb_device *zd_usb_to_usbdev(struct zd_usb *usb)
 	return interface_to_usbdev(usb->intf);
 }
 
-static inline struct net_device *zd_intf_to_netdev(struct usb_interface *intf)
+static inline struct ieee80211_hw *zd_intf_to_hw(struct usb_interface *intf)
 {
 	return usb_get_intfdata(intf);
 }
 
-static inline struct net_device *zd_usb_to_netdev(struct zd_usb *usb)
+static inline struct ieee80211_hw *zd_usb_to_hw(struct zd_usb *usb)
 {
-	return zd_intf_to_netdev(usb->intf);
+	return zd_intf_to_hw(usb->intf);
 }
 
-void zd_usb_init(struct zd_usb *usb, struct net_device *netdev,
+void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *hw,
 	         struct usb_interface *intf);
 int zd_usb_init_hw(struct zd_usb *usb);
 void zd_usb_clear(struct zd_usb *usb);
@@ -221,7 +237,10 @@ void zd_usb_disable_int(struct zd_usb *usb);
 int zd_usb_enable_rx(struct zd_usb *usb);
 void zd_usb_disable_rx(struct zd_usb *usb);
 
-int zd_usb_tx(struct zd_usb *usb, const u8 *frame, unsigned int length);
+void zd_usb_enable_tx(struct zd_usb *usb);
+void zd_usb_disable_tx(struct zd_usb *usb);
+
+int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb);
 
 int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 	         const zd_addr_t *addresses, unsigned int count);
-- 
1.5.3.4

