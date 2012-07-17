Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41159 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2GQLsQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 07:48:16 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20485.20636.11008.266065@gargle.gargle.HOWL> (sfid-20120717_134819_384774_45F3AB70)
Date: Tue, 17 Jul 2012 17:16:36 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/12] ath9k: Reconfigure VIF state properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an interface in AP or P2P-GO mode is removed,
check whether a station interface is already present and
reconfigure the beacon timers etc. properly if it's
associated.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 55c9095..6a44c95 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -19,6 +19,9 @@
 #include "ath9k.h"
 #include "btcoex.h"
 
+static void ath9k_set_assoc_state(struct ath_softc *sc,
+				  struct ieee80211_vif *vif);
+
 u8 ath9k_parse_mpdudensity(u8 mpdudensity)
 {
 	/*
@@ -878,6 +881,18 @@ static void ath9k_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	}
 }
 
+static void ath9k_sta_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct ath_softc *sc = data;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (avp->primary_sta_vif)
+		ath9k_set_assoc_state(sc, vif);
+}
+
 /* Called with sc->mutex held. */
 void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
@@ -911,6 +926,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_vif_iter_data iter_data;
+	enum nl80211_iftype old_opmode = ah->opmode;
 
 	ath9k_calculate_iter_data(hw, vif, &iter_data);
 
@@ -941,6 +957,17 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 		ah->imask &= ~ATH9K_INT_TSFOOR;
 
 	ath9k_hw_set_interrupts(ah);
+
+	/*
+	 * If we are changing the opmode to STATION,
+	 * a beacon sync needs to be done.
+	 */
+	if (ah->opmode == NL80211_IFTYPE_STATION &&
+	    old_opmode == NL80211_IFTYPE_AP &&
+	    test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+		ieee80211_iterate_active_interfaces_atomic(sc->hw,
+						   ath9k_sta_vif_iter, sc);
+	}
 }
 
 static int ath9k_add_interface(struct ieee80211_hw *hw,
-- 
1.7.11.2

