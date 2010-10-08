Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56427 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab0JHQnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 12:43:45 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath5k:  Adjust opmode when interfaces are removed.
Date: Fri,  8 Oct 2010 09:43:30 -0700
Message-Id: <1286556210-29643-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1286556210-29643-1-git-send-email-greearb@candelatech.com>
References: <1286556210-29643-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, if there is an AP and a STATION, and AP
is removed, the NIC will not revert back to STATION mode.

Reported-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 dad7265... 813425d... M	drivers/net/wireless/ath/ath5k/base.c
 drivers/net/wireless/ath/ath5k/base.c |   40 +++++++++++++++++++++++++-------
 1 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index dad7265..813425d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -62,6 +62,7 @@
 #include "reg.h"
 #include "debug.h"
 #include "ani.h"
+#include "../debug.h"
 
 static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
@@ -517,12 +518,14 @@ struct ath_vif_iter_data {
 	bool		need_set_hw_addr;
 	bool		found_active;
 	bool		any_assoc;
+	enum nl80211_iftype opmode;
 };
 
 static void ath_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct ath_vif_iter_data *iter_data = data;
 	int i;
+	struct ath5k_vif *avf = (void *)vif->drv_priv;
 
 	if (iter_data->hw_macaddr)
 		for (i = 0; i < ETH_ALEN; i++)
@@ -539,13 +542,29 @@ static void ath_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 			iter_data->need_set_hw_addr = false;
 
 	if (!iter_data->any_assoc) {
-		struct ath5k_vif *avf = (void *)vif->drv_priv;
 		if (avf->assoc)
 			iter_data->any_assoc = true;
 	}
+
+	if (avf->opmode == NL80211_IFTYPE_AP)
+		iter_data->opmode = NL80211_IFTYPE_AP;
+	else
+		if (iter_data->opmode == NL80211_IFTYPE_UNSPECIFIED)
+			iter_data->opmode = avf->opmode;
 }
 
-void ath5k_update_bssid_mask(struct ath5k_softc *sc, struct ieee80211_vif *vif)
+static void ath_do_set_opmode(struct ath5k_softc *sc)
+{
+	struct ath5k_hw *ah = sc->ah;
+	ath5k_hw_set_opmode(ah, sc->opmode);
+	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
+		  sc->opmode,
+		  ath_opmode_to_string(sc->opmode) ?
+		  ath_opmode_to_string(sc->opmode) : "UKNOWN");
+}
+
+void ath5k_update_bssid_mask(struct ath5k_softc *sc, struct ieee80211_vif *vif,
+			     bool update_opmode)
 {
 	struct ath_common *common = ath5k_hw_common(sc->ah);
 	struct ath_vif_iter_data iter_data;
@@ -558,6 +577,7 @@ void ath5k_update_bssid_mask(struct ath5k_softc *sc, struct ieee80211_vif *vif)
 	memset(&iter_data.mask, 0xff, ETH_ALEN);
 	iter_data.found_active = false;
 	iter_data.need_set_hw_addr = true;
+	iter_data.opmode = NL80211_IFTYPE_UNSPECIFIED;
 
 	if (vif)
 		ath_vif_iter(&iter_data, vif->addr, vif);
@@ -567,6 +587,11 @@ void ath5k_update_bssid_mask(struct ath5k_softc *sc, struct ieee80211_vif *vif)
 						   &iter_data);
 	memcpy(sc->bssidmask, iter_data.mask, ETH_ALEN);
 
+	if (update_opmode && sc->opmode != iter_data.opmode) {
+		sc->opmode = iter_data.opmode;
+		ath_do_set_opmode(sc);
+	}
+
 	if (iter_data.need_set_hw_addr && iter_data.found_active)
 		ath5k_hw_set_lladdr(sc->ah, iter_data.active_mac);
 
@@ -584,12 +609,9 @@ ath5k_mode_setup(struct ath5k_softc *sc, struct ieee80211_vif *vif)
 	ath5k_hw_set_rx_filter(ah, rfilt);
 
 	if (ath5k_hw_hasbssidmask(ah))
-		ath5k_update_bssid_mask(sc, vif);
-
-	/* configure operational mode */
-	ath5k_hw_set_opmode(ah, sc->opmode);
+		ath5k_update_bssid_mask(sc, vif, false);
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d\n", sc->opmode);
+	ath_do_set_opmode(sc);
 	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "RX filter 0x%x\n", rfilt);
 }
 
@@ -2688,7 +2710,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	SET_IEEE80211_PERM_ADDR(hw, mac);
 	memcpy(&sc->lladdr, mac, ETH_ALEN);
 	/* All MAC address bits matter for ACKs */
-	ath5k_update_bssid_mask(sc, NULL);
+	ath5k_update_bssid_mask(sc, NULL, false);
 
 	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
 	ret = ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier);
@@ -2905,7 +2927,7 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 	else if (avf->opmode == NL80211_IFTYPE_ADHOC)
 		sc->num_adhoc_vifs--;
 
-	ath5k_update_bssid_mask(sc, NULL);
+	ath5k_update_bssid_mask(sc, NULL, true);
 	mutex_unlock(&sc->lock);
 }
 
-- 
1.7.2.2

