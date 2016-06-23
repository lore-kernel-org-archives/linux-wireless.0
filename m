Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36141 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbcFWRpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 13:45:53 -0400
Received: by mail-wm0-f65.google.com with SMTP id c82so12822565wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 10:45:52 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name, chunkeey@googlemail.com, mark.rutland@arm.com,
	robh+dt@kernel.org,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 2/2] ath9k: parse the device configuration from an OF node
Date: Thu, 23 Jun 2016 19:45:36 +0200
Message-Id: <20160623174536.5967-3-martin.blumenstingl@googlemail.com> (sfid-20160623_194557_464153_79F2EF92)
In-Reply-To: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
References: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to configure ath9k based devices using
devicetree. That makes some out-of-tree "convert devicetree to
ath9k_platform_data glue"-code obsolete.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
changes in v1 -> v2:
- use vendor prefix "qca" instead of "ath"
- use of_device_is_available instead of simply checking if "np" is NULL
- removed code which read some properties twice

 drivers/net/wireless/ath/ath9k/init.c | 61 +++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a0f4a52..2b5e3db 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -20,6 +20,8 @@
 #include <linux/slab.h>
 #include <linux/ath9k_platform.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_net.h>
 #include <linux/relay.h>
 #include <net/ieee80211_radiotap.h>
 
@@ -555,6 +557,61 @@ static int ath9k_init_platform(struct ath_softc *sc)
 	return 0;
 }
 
+static int ath9k_of_init(struct ath_softc *sc)
+{
+	struct device_node *np = sc->dev->of_node;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	const char *mac, *eeprom_name;
+	int led_pin, ret;
+	u32 gpio_data;
+
+	if (!of_device_is_available(np))
+		return 0;
+
+	ath_dbg(common, CONFIG, "parsing configuration from OF node\n");
+
+	if (!of_property_read_u32(np, "qca,led-pin", &led_pin))
+		ah->led_pin = led_pin;
+
+	if (!of_property_read_u32(np, "qca,gpio-mask", &gpio_data))
+		ah->gpio_mask = gpio_data;
+
+	if (!of_property_read_u32(np, "qca,gpio-val", &gpio_data))
+		ah->gpio_val = gpio_data;
+
+	if (of_property_read_bool(np, "qca,clk-25mhz"))
+		ah->is_clk_25mhz = true;
+
+	if (of_property_read_bool(np, "qca,led-active-high"))
+		ah->config.led_active_high = true;
+
+	if (of_property_read_bool(np, "qca,disable-2ghz"))
+		ah->disable_2ghz = true;
+
+	if (of_property_read_bool(np, "qca,disable-5ghz"))
+		ah->disable_5ghz = true;
+
+	if (of_property_read_bool(np, "qca,check-eeprom-endianness"))
+		ah->ah_flags &= ~AH_NO_EEP_SWAP;
+	else
+		ah->ah_flags |= AH_NO_EEP_SWAP;
+
+	if (!of_property_read_string(np, "qca,eeprom-name", &eeprom_name)) {
+		ret = ath9k_eeprom_request(sc, eeprom_name);
+		if (ret)
+			return ret;
+	}
+
+	mac = of_get_mac_address(np);
+	if (mac)
+		ether_addr_copy(common->macaddr, mac);
+
+	ah->ah_flags &= ~AH_USE_EEPROM;
+
+	return 0;
+}
+
 static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 			    const struct ath_bus_ops *bus_ops)
 {
@@ -611,6 +668,10 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		return ret;
 
+	ret = ath9k_of_init(sc);
+	if (ret)
+		return ret;
+
 	if (ath9k_led_active_high != -1)
 		ah->config.led_active_high = ath9k_led_active_high == 1;
 
-- 
2.9.0

