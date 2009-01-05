Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpo-eml02.KPNXCHANGE.COM ([213.75.38.151]:48532 "EHLO
	cpsmtpo-eml02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbZAEVaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 16:30:01 -0500
Message-ID: <49627BCB.4020200@kpnplanet.nl> (sfid-20090105_223010_763654_949E2C91)
Date: Mon, 05 Jan 2009 22:29:47 +0100
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
References: <200901042021.10904.IvDoorn@gmail.com> <20090105200809.GH6834@tesla>
In-Reply-To: <20090105200809.GH6834@tesla>
Content-Type: multipart/mixed;
 boundary="------------030602010101040405020008"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030602010101040405020008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/05/09 21:08, Luis R. Rodriguez wrote:
> On Sun, Jan 04, 2009 at 11:21:10AM -0800, Ivo van Doorn wrote:
>    
>> rt2500pci and rt2500usb contain a special field in the EEPROM
>> which indicates which regulatory domain the card belongs to.
>> This code can easily be translated into a country code which
>> we can send as alpha2 hint for CRDA.
>>
>> Please note that most cards will have 0xffff as EEPROM value,
>> and thus do not provide a regulatory hint through the EEPROM.
>>
>> Signed-off-by: Ivo van Doorn<IvDoorn@gmail.com>
>>      
>
> I believe regulatory_hint() is being called before the ieee80211_register_hw()
> call. This is not a requirement right now but I believe this should be the case
> in the future as we want cfg80211 to keep track a few things for the driver, like
> the regulatory domain it wants in case of conflicts with other drivers. I'm working
> on this right now so just wanted to throw that out there.
>
> Is it possible to move the regulatory_hint() to be used after ieee80211_register_hw()
> is called?
Luis, Ivo,

I do have an RFC patch that handles things in the way that Luis describes, and applies to all the rt2x00 drivers. Find it attached (sorry for attaching; I still haven't found a way to properly inline a patch with Thunderbird).

The things that kept me from submitting it so far are:
1. The conversion to a country code for the a-band EEPROM values is not complete / correct. So far I've been unable to map the possible code described in the EEPROM spec to real country codes.
2. I'm still puzzled how to handle the two different values that the EEPROM has, namely one for the bg band and one for the a band. I've handled it by registering the one associated with the configured band, but that seems to be unlikely to be correct. I still haven't found a better way to handle this.

Especially for 2 I haven't been able to determine how to handle that. The problem isn't there for the bits that Ivo sent, as the rt2500 devices don't support the a band.

---
Gertjan






--------------030602010101040405020008
Content-Type: text/plain;
 name="0001-rt2x00-Provide-regulatory-hint.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-rt2x00-Provide-regulatory-hint.patch"

>From 23b99c8769ad8451368a2e95eabe1beb7fbd2200 Mon Sep 17 00:00:00 2001
From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Date: Mon, 5 Jan 2009 22:12:25 +0100
Subject: [PATCH] rt2x00: Provide regulatory hint.

Properly register the EEPROM region information with the mac80211 regulatory framework.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    6 +++
 drivers/net/wireless/rt2x00/rt2400pci.h |    7 ++++
 drivers/net/wireless/rt2x00/rt2500pci.c |    6 +++
 drivers/net/wireless/rt2x00/rt2500pci.h |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |    6 +++
 drivers/net/wireless/rt2x00/rt2500usb.h |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |    8 ++++
 drivers/net/wireless/rt2x00/rt2800pci.h |    9 +++++
 drivers/net/wireless/rt2x00/rt2800usb.c |    8 ++++
 drivers/net/wireless/rt2x00/rt2800usb.h |    9 +++++
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 +++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   60 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    8 ++++
 drivers/net/wireless/rt2x00/rt73usb.c   |    8 ++++
 14 files changed, 143 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 9c02231..fa98932 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1416,6 +1416,12 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RX_AGCVGC_TUNING))
 		__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
+	/*
+	 * Read the region information.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+	rt2x00dev->region_bg = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index 9aefda4..986e428 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -806,6 +806,13 @@
 #define EEPROM_TXPOWER_2		FIELD16(0xff00)
 
 /*
+ * EEPROM geography.
+ * GEO: Default geography setting for device.
+ */
+#define EEPROM_GEOGRAPHY		0x17
+#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)
+
+/*
  * DMA descriptor defines.
  */
 #define TXD_DESC_SIZE			( 8 * sizeof(__le32) )
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 76f016d..bf6624b 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1577,6 +1577,12 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
+	 * Read the region information.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+	rt2x00dev->region_bg = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+
+	/*
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index e135247..8a69af3 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -1060,7 +1060,7 @@
  * GEO: Default geography setting for device.
  */
 #define EEPROM_GEOGRAPHY		0x12
-#define EEPROM_GEOGRAPHY_GEO		FIELD16(0x0f00)
+#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)
 
 /*
  * EEPROM BBP.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 81400ea..99ba43e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1633,6 +1633,12 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
 	/*
+	 * Read the region information.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+	rt2x00dev->region_bg = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+
+	/*
 	 * Read the RSSI <-> dBm offset information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index e1f714e..634fb32 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -680,7 +680,7 @@
  * GEO: Default geography setting for device.
  */
 #define EEPROM_GEOGRAPHY		0x000d
-#define EEPROM_GEOGRAPHY_GEO		FIELD16(0x0f00)
+#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)
 
 /*
  * EEPROM BBP.
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 1e21d5d..dab08a3 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -2227,6 +2227,14 @@ static int rt2800pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 
 	/*
+	 * Read region information.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+
+	rt2x00dev->region_bg = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+	rt2x00dev->region_a = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO_A);
+
+	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
 #ifdef CONFIG_RT2X00_LIB_RFKILL
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.h b/drivers/net/wireless/rt2x00/rt2800pci.h
index b19d019..31b0459 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -1551,6 +1551,15 @@ struct hw_key_entry {
 #define EEPROM_NIC_BW40M_A		FIELD16(0x0200)
 
 /*
+ * EEPROM geography.
+ * GEO_A: Default geographical setting for 5GHz band
+ * GEO: Default geographical setting.
+ */
+#define EEPROM_GEOGRAPHY		0x001c
+#define EEPROM_GEOGRAPHY_GEO_A		FIELD16(0x00ff)
+#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)
+
+/*
  * EEPROM frequency
  */
 #define	EEPROM_FREQ			0x001d
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6bd252f..e365af2 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2014,6 +2014,14 @@ static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 
 	/*
+	 * Read region information.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+
+	rt2x00dev->region_bg = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+	rt2x00dev->region_a = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO_A);
+
+	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
 #ifdef CONFIG_RT2X00_LIB_RFKILL
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h b/drivers/net/wireless/rt2x00/rt2800usb.h
index c4c195a..d10d15a 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -1554,6 +1554,15 @@ struct hw_key_entry {
 #define EEPROM_NIC_BW40M_A		FIELD16(0x0200)
 
 /*
+ * EEPROM geography.
+ * GEO_A: Default geographical setting for 5GHz band
+ * GEO: Default geographical setting.
+ */
+#define EEPROM_GEOGRAPHY		0x001c
+#define EEPROM_GEOGRAPHY_GEO_A		FIELD16(0x00ff)
+#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)
+
+/*
  * EEPROM frequency
  */
 #define	EEPROM_FREQ			0x001d
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 60a0e9e..36e4923 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -695,6 +695,12 @@ struct rt2x00_dev {
 	struct antenna_setup default_ant;
 
 	/*
+	 * EEPROM region information;
+	 */
+	u16 region_bg;
+	u16 region_a;
+
+	/*
 	 * Register pointers
 	 * csr.base: CSR base register address. (PCI)
 	 * csr.cache: CSR cache for usb_control_msg. (USB)
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index cc25c83..a3f46a6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -29,6 +29,54 @@
 #include "rt2x00.h"
 #include "rt2x00lib.h"
 
+enum {
+	RT2X00_REGION_FCC = 0,
+	RT2X00_REGION_IC = 1,
+	RT2X00_REGION_ETSI = 2,
+	RT2X00_REGION_SPAIN = 3,
+	RT2X00_REGION_FRANCE = 4,
+	RT2X00_REGION_MKK = 5,
+	RT2X00_REGION_MKK1 = 6,
+	RT2X00_REGION_ISRAEL = 7,
+};
+
+static inline char *rt2x00_region2alpha(u16 region)
+{
+	char *alpha2;
+
+	switch (region) {
+	case RT2X00_REGION_FCC:
+		alpha2 = "US";
+		break;
+	case RT2X00_REGION_IC:
+		alpha2 = "CA";
+		break;
+	case RT2X00_REGION_ETSI:
+		alpha2 = "DE";
+		break;
+	case RT2X00_REGION_SPAIN:
+		alpha2 = "ES";
+		break;
+	case RT2X00_REGION_FRANCE:
+		alpha2 = "FR";
+		break;
+	case RT2X00_REGION_MKK:
+		alpha2 = "JP";
+		break;
+	case RT2X00_REGION_MKK1:
+		alpha2 = "JP";
+		break;
+	case RT2X00_REGION_ISRAEL:
+		alpha2 = "IL";
+		break;
+	default:
+		alpha2 = NULL;
+		break;
+	}
+
+	return alpha2;
+}
+
 /*
  * Radio control handlers.
  */
@@ -735,6 +783,7 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	char *alpha2;
 
 	if (test_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags))
 		return 0;
@@ -758,6 +807,17 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->intf_sta_count = 0;
 	rt2x00dev->intf_associated = 0;
 
+	/*
+	 * Register the EEPROM region codes with mac80211.
+	 */
+	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
+		alpha2 = rt2x00_region2alpha(rt2x00dev->region_a);
+	else
+		alpha2 = rt2x00_region2alpha(rt2x00dev->region_bg);
+
+	if (alpha2)
+		regulatory_hint(rt2x00dev->hw->wiphy, alpha2);
+
 	set_bit(DEVICE_STATE_STARTED, &rt2x00dev->flags);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f1150a7..b770ee2 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2371,6 +2371,14 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 
 	/*
+	 * Read region information.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+
+	rt2x00dev->region_bg = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+	rt2x00dev->region_a = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO_A);
+
+	/*
 	 * When working with a RF2529 chip without double antenna
 	 * the antenna settings should be gathered from the NIC
 	 * eeprom word.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 891554e..10c8613 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1891,6 +1891,14 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
+	 * Read region information.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_GEOGRAPHY, &eeprom);
+
+	rt2x00dev->region_bg = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO);
+	rt2x00dev->region_a = rt2x00_get_field16(eeprom, EEPROM_GEOGRAPHY_GEO_A);
+
+	/*
 	 * Store led settings, for correct led behaviour.
 	 */
 #ifdef CONFIG_RT2X00_LIB_LEDS
-- 
1.6.1


--------------030602010101040405020008--
