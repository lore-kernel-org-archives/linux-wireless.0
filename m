Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2998 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2DSNnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:43:16 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k_hw: remove ATH_BTCOEX_CFG_MCI
Date: Thu, 19 Apr 2012 19:13:52 +0530
Message-ID: <1334843032-14544-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120419_154319_892516_FEDFB5A2)
In-Reply-To: <1334843032-14544-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1334843032-14544-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9462 uses modified version of 3-Wire hw scheme for btcoex.
MCI itself is not a separate hw scheme but it aids to manage
multiple bt profiles. In ar9462, bt priority traffic is identified
by the number of bt profile types instead of gpio. So that this
patch removes MCI hw scheme.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   14 +++++++-------
 drivers/net/wireless/ath/ath9k/btcoex.h |    1 -
 drivers/net/wireless/ath/ath9k/gpio.c   |   21 ++++++++++-----------
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index ec32719..1ca6da8 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -108,9 +108,7 @@ void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah)
 		return;
 	}
 
-	if (AR_SREV_9462(ah)) {
-		btcoex_hw->scheme = ATH_BTCOEX_CFG_MCI;
-	} else if (AR_SREV_9300_20_OR_LATER(ah)) {
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
 		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9300;
 		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9300;
@@ -284,11 +282,12 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 		ath9k_hw_btcoex_enable_2wire(ah);
 		break;
 	case ATH_BTCOEX_CFG_3WIRE:
+		if (AR_SREV_9462(ah)) {
+			ath9k_hw_btcoex_enable_mci(ah);
+			return;
+		}
 		ath9k_hw_btcoex_enable_3wire(ah);
 		break;
-	case ATH_BTCOEX_CFG_MCI:
-		ath9k_hw_btcoex_enable_mci(ah);
-		return;
 	}
 
 	REG_RMW(ah, AR_GPIO_PDPU,
@@ -305,11 +304,12 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	int i;
 
 	btcoex_hw->enabled = false;
-	if (btcoex_hw->scheme == ATH_BTCOEX_CFG_MCI) {
+	if (AR_SREV_9462(ah)) {
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 		for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
 			REG_WRITE(ah, AR_MCI_COEX_WL_WEIGHTS(i),
 				  btcoex_hw->wlan_weight[i]);
+		return;
 	}
 	ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
 
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 8f93aef..3a1e1cf 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -51,7 +51,6 @@ enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_NONE,
 	ATH_BTCOEX_CFG_2WIRE,
 	ATH_BTCOEX_CFG_3WIRE,
-	ATH_BTCOEX_CFG_MCI,
 };
 
 struct ath9k_hw_mci {
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index dd10f4a..281a9af 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -365,7 +365,7 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
 		ath9k_hw_btcoex_disable(ah);
 		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
-		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_MCI)
+		if (AR_SREV_9462(ah))
 			ath_mci_flush_profile(&sc->btcoex.mci);
 	}
 }
@@ -376,7 +376,7 @@ void ath9k_deinit_btcoex(struct ath_softc *sc)
 	    ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
 
-	if (ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_MCI)
+	if (AR_SREV_9462(sc->sc_ah))
 		ath_mci_cleanup(sc);
 }
 
@@ -402,17 +402,16 @@ int ath9k_init_btcoex(struct ath_softc *sc)
 		txq = sc->tx.txq_map[WME_AC_BE];
 		ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
 		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-		break;
-	case ATH_BTCOEX_CFG_MCI:
-		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-		sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
-		INIT_LIST_HEAD(&sc->btcoex.mci.info);
+		if (AR_SREV_9462(ah)) {
+			sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
+			INIT_LIST_HEAD(&sc->btcoex.mci.info);
 
-		r = ath_mci_setup(sc);
-		if (r)
-			return r;
+			r = ath_mci_setup(sc);
+			if (r)
+				return r;
 
-		ath9k_hw_btcoex_init_mci(ah);
+			ath9k_hw_btcoex_init_mci(ah);
+		}
 
 		break;
 	default:
-- 
1.7.10

