Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34836 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbcGIX2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 19:28:55 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Cc: mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, kvalo@codeaurora.org,
	chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
	julian.calaby@gmail.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 3/3] ath9k: parse the device configuration from an OF node
Date: Sun, 10 Jul 2016 01:28:34 +0200
Message-Id: <20160709232834.31654-4-martin.blumenstingl@googlemail.com> (sfid-20160710_012900_623440_B5076F78)
In-Reply-To: <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <20160709232834.31654-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to configure ath9k based devices using
devicetree. That makes some out-of-tree "convert devicetree to
ath9k_platform_data glue"-code obsolete.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 55 +++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index edc74fc..9dd7ed5 100644
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
 
@@ -555,6 +557,55 @@ static int ath9k_init_platform(struct ath_softc *sc)
 	return 0;
 }
 
+static int ath9k_of_init(struct ath_softc *sc)
+{
+	struct device_node *np = sc->dev->of_node;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	enum ath_bus_type bus_type = common->bus_ops->ath_bus_type;
+	const char *mac;
+	char eeprom_name[100];
+	int ret;
+
+	if (!of_device_is_available(np))
+		return 0;
+
+	ath_dbg(common, CONFIG, "parsing configuration from OF node\n");
+
+	if (of_property_read_bool(np, "qca,clk-25mhz"))
+		ah->is_clk_25mhz = true;
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
+	if (of_property_read_bool(np, "qca,no-eeprom")) {
+		/* ath9k-eeprom-<bus>-<id>.bin */
+		scnprintf(eeprom_name, sizeof(eeprom_name),
+			  "ath9k-eeprom-%s-%s.bin",
+			  ath_bus_type_to_string(bus_type), dev_name(ah->dev));
+
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
@@ -611,6 +662,10 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
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

