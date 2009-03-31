Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759418AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/9] ath5k: use regulatory infrastructure
Date: Mon, 30 Mar 2009 22:30:31 -0400
Message-Id: <1238466635-23280-6-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043050_259410_BC6A3BD4)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Make ath5k select the ath module and add in the hooks to make the
eeprom regulatory hint and reg notifier take effect.

Changes to attach.c
Changes-licensed-under: ISC

Changes to base.c
Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/Kconfig |    1 +
 drivers/net/wireless/ath5k/ath5k.h |    5 +++--
 drivers/net/wireless/ath5k/base.c  |   20 ++++++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/Kconfig b/drivers/net/wireless/ath5k/Kconfig
index 75383a5..509b6f9 100644
--- a/drivers/net/wireless/ath5k/Kconfig
+++ b/drivers/net/wireless/ath5k/Kconfig
@@ -1,6 +1,7 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 0b616e7..48c18d1 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -27,6 +27,8 @@
 #include <linux/types.h>
 #include <net/mac80211.h>
 
+#include "../ath/regd.h"
+
 /* RX/TX descriptor hw structs
  * TODO: Driver part should only see sw structs */
 #include "desc.h"
@@ -1039,8 +1041,6 @@ struct ath5k_hw {
 	bool			ah_5ghz;
 	bool			ah_2ghz;
 
-#define ah_regdomain		ah_capabilities.cap_regdomain.reg_current
-#define ah_regdomain_hw		ah_capabilities.cap_regdomain.reg_hw
 #define ah_modes		ah_capabilities.cap_mode
 #define ah_ee_version		ah_capabilities.cap_eeprom.ee_version
 
@@ -1065,6 +1065,7 @@ struct ath5k_hw {
 	u32			ah_gpio[AR5K_MAX_GPIO];
 	int			ah_gpio_npins;
 
+	struct ath_regulatory	ah_regulatory;
 	struct ath5k_capabilities ah_capabilities;
 
 	struct ath5k_txq_info	ah_txq[AR5K_NUM_TX_QUEUES];
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index dd669ce..3f7de22 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -709,6 +709,15 @@ err_no_irq:
 * Driver Initialization *
 \***********************/
 
+static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ath5k_softc *sc = hw->priv;
+	struct ath_regulatory *reg = &sc->ah->ah_regulatory;
+
+	return ath_reg_notifier_apply(wiphy, request, reg);
+}
+
 static int
 ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 {
@@ -797,12 +806,23 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	memset(sc->bssidmask, 0xff, ETH_ALEN);
 	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
 
+	ah->ah_regulatory.current_rd =
+		ah->ah_capabilities.cap_eeprom.ee_regdomain;
+	ret = ath_regd_init(&ah->ah_regulatory, hw->wiphy, ath5k_reg_notifier);
+	if (ret) {
+		ATH5K_ERR(sc, "can't initialize regulatory system\n");
+		goto err_queues;
+	}
+
 	ret = ieee80211_register_hw(hw);
 	if (ret) {
 		ATH5K_ERR(sc, "can't register ieee80211 hw\n");
 		goto err_queues;
 	}
 
+	if (!ath_is_world_regd(&sc->ah->ah_regulatory))
+		regulatory_hint(hw->wiphy, sc->ah->ah_regulatory.alpha2);
+
 	ath5k_init_leds(sc);
 
 	return 0;
-- 
1.6.0.6

