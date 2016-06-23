Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33647 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbcFWO5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 10:57:44 -0400
Received: by mail-wm0-f66.google.com with SMTP id r201so11649795wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 07:57:43 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5/6] ath9k: move all ath9k_platform_data initialization into one function
Date: Thu, 23 Jun 2016 16:57:13 +0200
Message-Id: <20160623145714.20576-6-martin.blumenstingl@googlemail.com> (sfid-20160623_165746_655114_38243ECE)
In-Reply-To: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
References: <20160623145714.20576-1-martin.blumenstingl@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes, this simply makes the code easier to understand
because all initialization based on ath9k_platform_data is now within
one function.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 49 ++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 384929d..a0f4a52 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -512,15 +512,31 @@ static void ath9k_eeprom_release(struct ath_softc *sc)
 	release_firmware(sc->sc_ah->eeprom_blob);
 }
 
-static int ath9k_init_soc_platform(struct ath_softc *sc)
+static int ath9k_init_platform(struct ath_softc *sc)
 {
 	struct ath9k_platform_data *pdata = sc->dev->platform_data;
 	struct ath_hw *ah = sc->sc_ah;
-	int ret = 0;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int ret;
 
 	if (!pdata)
 		return 0;
 
+	if (!pdata->use_eeprom) {
+		ah->ah_flags &= ~AH_USE_EEPROM;
+		ah->gpio_mask = pdata->gpio_mask;
+		ah->gpio_val = pdata->gpio_val;
+		ah->led_pin = pdata->led_pin;
+		ah->is_clk_25mhz = pdata->is_clk_25mhz;
+		ah->get_mac_revision = pdata->get_mac_revision;
+		ah->external_reset = pdata->external_reset;
+		ah->disable_2ghz = pdata->disable_2ghz;
+		ah->disable_5ghz = pdata->disable_5ghz;
+
+		if (!pdata->endian_check)
+			ah->ah_flags |= AH_NO_EEP_SWAP;
+	}
+
 	if (pdata->eeprom_name) {
 		ret = ath9k_eeprom_request(sc, pdata->eeprom_name);
 		if (ret)
@@ -533,13 +549,15 @@ static int ath9k_init_soc_platform(struct ath_softc *sc)
 	if (pdata->tx_gain_buffalo)
 		ah->config.tx_gain_buffalo = true;
 
-	return ret;
+	if (pdata->macaddr)
+		ether_addr_copy(common->macaddr, pdata->macaddr);
+
+	return 0;
 }
 
 static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 			    const struct ath_bus_ops *bus_ops)
 {
-	struct ath9k_platform_data *pdata = sc->dev->platform_data;
 	struct ath_hw *ah = NULL;
 	struct ath9k_hw_capabilities *pCap;
 	struct ath_common *common;
@@ -553,6 +571,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ah->dev = sc->dev;
 	ah->hw = sc->hw;
 	ah->hw_version.devid = devid;
+	ah->ah_flags |= AH_USE_EEPROM;
+	ah->led_pin = -1;
 	ah->reg_ops.read = ath9k_ioread32;
 	ah->reg_ops.multi_read = ath9k_multi_ioread32;
 	ah->reg_ops.write = ath9k_iowrite32;
@@ -572,22 +592,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (!ath9k_is_chanctx_enabled())
 		sc->cur_chan->hw_queue_base = 0;
 
-	if (!pdata || pdata->use_eeprom) {
-		ah->ah_flags |= AH_USE_EEPROM;
-		sc->sc_ah->led_pin = -1;
-	} else {
-		sc->sc_ah->gpio_mask = pdata->gpio_mask;
-		sc->sc_ah->gpio_val = pdata->gpio_val;
-		sc->sc_ah->led_pin = pdata->led_pin;
-		ah->is_clk_25mhz = pdata->is_clk_25mhz;
-		ah->get_mac_revision = pdata->get_mac_revision;
-		ah->external_reset = pdata->external_reset;
-		ah->disable_2ghz = pdata->disable_2ghz;
-		ah->disable_5ghz = pdata->disable_5ghz;
-		if (!pdata->endian_check)
-			ah->ah_flags |= AH_NO_EEP_SWAP;
-	}
-
 	common->ops = &ah->reg_ops;
 	common->bus_ops = bus_ops;
 	common->ps_ops = &ath9k_ps_ops;
@@ -603,7 +607,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	 */
 	ath9k_init_pcoem_platform(sc);
 
-	ret = ath9k_init_soc_platform(sc);
+	ret = ath9k_init_platform(sc);
 	if (ret)
 		return ret;
 
@@ -649,9 +653,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (ret)
 		goto err_hw;
 
-	if (pdata && pdata->macaddr)
-		memcpy(common->macaddr, pdata->macaddr, ETH_ALEN);
-
 	ret = ath9k_init_queues(sc);
 	if (ret)
 		goto err_queues;
-- 
2.9.0

