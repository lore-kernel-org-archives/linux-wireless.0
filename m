Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39760 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbCAGUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 01:20:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/6] ath9k: Fix MCI scheme initialization
Date: Sun,  1 Mar 2015 11:53:46 +0530
Message-Id: <1425191029-13667-4-git-send-email-sujith@msujith.org> (sfid-20150301_072030_255532_84218FDC)
In-Reply-To: <1425191029-13667-1-git-send-email-sujith@msujith.org>
References: <1425191029-13667-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Commit "ath9k_hw: remove ATH_BTCOEX_CFG_MCI" removed
MCI as a separate coex scheme, but we need it to
avoid fiddling with GPIO registers during
ath9k_init_btcoex() that are meant only for 3-wire
cards.

Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 40 ++++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/btcoex.h |  1 +
 drivers/net/wireless/ath/ath9k/gpio.c   | 23 ++++++++++---------
 3 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 3dfc2c7..78e892e 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -103,7 +103,9 @@ void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah)
 		return;
 	}
 
-	if (AR_SREV_9300_20_OR_LATER(ah)) {
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
+		btcoex_hw->scheme = ATH_BTCOEX_CFG_MCI;
+	} else if (AR_SREV_9300_20_OR_LATER(ah)) {
 		btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
 		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9300;
 		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9300;
@@ -307,6 +309,18 @@ static void ath9k_hw_btcoex_enable_mci(struct ath_hw *ah)
 	btcoex->enabled = true;
 }
 
+static void ath9k_hw_btcoex_disable_mci(struct ath_hw *ah)
+{
+	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
+	int i;
+
+	ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
+
+	for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
+		REG_WRITE(ah, AR_MCI_COEX_WL_WEIGHTS(i),
+			  btcoex_hw->wlan_weight[i]);
+}
+
 void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
@@ -318,17 +332,18 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 		ath9k_hw_btcoex_enable_2wire(ah);
 		break;
 	case ATH_BTCOEX_CFG_3WIRE:
-		if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
-			ath9k_hw_btcoex_enable_mci(ah);
-			return;
-		}
 		ath9k_hw_btcoex_enable_3wire(ah);
 		break;
+	case ATH_BTCOEX_CFG_MCI:
+		ath9k_hw_btcoex_enable_mci(ah);
+		break;
 	}
 
-	REG_RMW(ah, AR_GPIO_PDPU,
-		(0x2 << (btcoex_hw->btactive_gpio * 2)),
-		(0x3 << (btcoex_hw->btactive_gpio * 2)));
+	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_MCI) {
+		REG_RMW(ah, AR_GPIO_PDPU,
+			(0x2 << (btcoex_hw->btactive_gpio * 2)),
+			(0x3 << (btcoex_hw->btactive_gpio * 2)));
+	}
 
 	ah->btcoex_hw.enabled = true;
 }
@@ -340,13 +355,12 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	int i;
 
 	btcoex_hw->enabled = false;
-	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
-		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
-		for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
-			REG_WRITE(ah, AR_MCI_COEX_WL_WEIGHTS(i),
-				  btcoex_hw->wlan_weight[i]);
+
+	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_MCI) {
+		ath9k_hw_btcoex_disable_mci(ah);
 		return;
 	}
+
 	ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
 
 	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index 6de26ea..5fe62ff 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -58,6 +58,7 @@ enum ath_btcoex_scheme {
 	ATH_BTCOEX_CFG_NONE,
 	ATH_BTCOEX_CFG_2WIRE,
 	ATH_BTCOEX_CFG_3WIRE,
+	ATH_BTCOEX_CFG_MCI,
 };
 
 struct ath9k_hw_mci {
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 257ffce..b4a0612 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -280,6 +280,7 @@ static void ath_init_btcoex_timer(struct ath_softc *sc)
 		btcoex->btcoex_period / 100;
 	btcoex->btscan_no_stomp = (100 - ATH_BTCOEX_BTSCAN_DUTY_CYCLE) *
 				   btcoex->btcoex_period / 100;
+	btcoex->bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 
 	setup_timer(&btcoex->period_timer, ath_btcoex_period_timer,
 			(unsigned long) sc);
@@ -408,19 +409,19 @@ int ath9k_init_btcoex(struct ath_softc *sc)
 	case ATH_BTCOEX_CFG_3WIRE:
 		ath9k_hw_btcoex_init_3wire(sc->sc_ah);
 		ath_init_btcoex_timer(sc);
-
 		txq = sc->tx.txq_map[IEEE80211_AC_BE];
 		ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
-		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-		if (ath9k_hw_mci_is_enabled(ah)) {
-			sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
-			INIT_LIST_HEAD(&sc->btcoex.mci.info);
-			ath9k_hw_btcoex_init_mci(ah);
-
-			r = ath_mci_setup(sc);
-			if (r)
-				return r;
-		}
+		break;
+	case ATH_BTCOEX_CFG_MCI:
+		ath_init_btcoex_timer(sc);
+
+		sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
+		INIT_LIST_HEAD(&sc->btcoex.mci.info);
+		ath9k_hw_btcoex_init_mci(ah);
+
+		r = ath_mci_setup(sc);
+		if (r)
+			return r;
 
 		break;
 	default:
-- 
2.3.0

