Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33517 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751967AbcJBWvL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Oct 2016 18:51:11 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, frowand.list@gmail.com,
        devicetree@vger.kernel.org, nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k-devel@lists.ath9k.org, kvalo@codeaurora.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC 3/3] ath9k: add OF configuration to disable the 2.4GHz or 5GHz band
Date: Mon,  3 Oct 2016 00:50:59 +0200
Message-Id: <20161002225059.16757-4-martin.blumenstingl@googlemail.com> (sfid-20161003_005114_235027_5225086A)
In-Reply-To: <20161002225059.16757-1-martin.blumenstingl@googlemail.com>
References: <20161002225059.16757-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices are shipped with EEPROMs where a band is enabled which is
not supported by the actual hardware. Allow disabling the affected
bands using the new generic IEEE 802.11 bindings.

This is the OF equivalent to using ath9k_platform_data's disable_2ghz
and disable_5ghz attributes.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt | 2 ++
 drivers/net/wireless/ath/ath9k/init.c                        | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
index 9b58ede..042319a 100644
--- a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
@@ -18,6 +18,8 @@ Optional properties:
 			kernel firmware loader).
 - mac-address: See ethernet.txt in the parent directory
 - local-mac-address: See ethernet.txt in the parent directory
+- disable-ieee80211-2ghz: See ieee80211.txt in the current directory
+- disable-ieee80211-5ghz: See ieee80211.txt in the current directory
 
 
 In this example, the node is defined as child node of the PCI controller:
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b7c8ff9..8b3f906 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -21,6 +21,7 @@
 #include <linux/ath9k_platform.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_ieee80211.h>
 #include <linux/of_net.h>
 #include <linux/relay.h>
 #include <net/ieee80211_radiotap.h>
@@ -572,6 +573,9 @@ static int ath9k_of_init(struct ath_softc *sc)
 
 	ath_dbg(common, CONFIG, "parsing configuration from OF node\n");
 
+	ah->disable_2ghz = of_ieee80211_is_2ghz_disabled(np);
+	ah->disable_5ghz = of_ieee80211_is_5ghz_disabled(np);
+
 	if (of_property_read_bool(np, "qca,no-eeprom")) {
 		/* ath9k-eeprom-<bus>-<id>.bin */
 		scnprintf(eeprom_name, sizeof(eeprom_name),
-- 
2.10.0
