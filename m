Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35675 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756855AbcJPU7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Oct 2016 16:59:48 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        robh+dt@kernel.org
Cc: mcgrof@do-not-panic.com, mark.rutland@arm.com,
        kvalo@codeaurora.org, chunkeey@googlemail.com,
        arend.vanspriel@broadcom.com, julian.calaby@gmail.com,
        bjorn@mork.no, linux@rempel-privat.de, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v8 3/3] ath9k: parse the device configuration from an OF node
Date: Sun, 16 Oct 2016 22:59:07 +0200
Message-Id: <20161016205907.19927-4-martin.blumenstingl@googlemail.com> (sfid-20161016_225958_553500_F4A97007)
In-Reply-To: <20161016205907.19927-1-martin.blumenstingl@googlemail.com>
References: <20161002214743.2263-1-martin.blumenstingl@googlemail.com>
 <20161016205907.19927-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows setting the MAC address and specifying that the firmware
will be requested from userspace (because there might not be a hardware
EEPROM connected to the chip) for ath9k based PCI devices using
the device tree.

There is some out-of-tree code to "convert devicetree to
ath9k_platform_data" (for example in OpenWrt and LEDE) which becomes
obsolete with this patch.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 42 +++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index cfa3fe8..b7c8ff9 100644
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
 
@@ -555,6 +557,42 @@ static int ath9k_init_platform(struct ath_softc *sc)
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
+	ah->ah_flags |= AH_NO_EEP_SWAP;
+
+	return 0;
+}
+
 static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 			    const struct ath_bus_ops *bus_ops)
 {
@@ -611,6 +649,10 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		return ret;
 
+	ret = ath9k_of_init(sc);
+	if (ret)
+		return ret;
+
 	if (ath9k_led_active_high != -1)
 		ah->config.led_active_high = ath9k_led_active_high == 1;
 
-- 
2.10.0
