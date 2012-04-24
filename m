Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24524 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2DXEx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 00:53:57 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20374.12736.687313.945112@gargle.gargle.HOWL> (sfid-20120424_065401_849785_74DDA996)
Date: Tue, 24 Apr 2012 10:23:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix IDLE Powersave
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* PS_WAIT_FOR_TX_ACK is used in network-sleep mode and checking
  it for handling IDLE transitions is incorrect. Fix this.

* RX PCU/DMA engines have to be stopped before setting the chip into
  full-sleep mode - otherwise the chip becomes mute.

* Make things a bit clear by checking explicitly for network-sleep
  mode in the tx() routine and add a couple of debug statements
  to aid PS debugging.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   43 ++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e4bc14b..dfa78e8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -113,21 +113,25 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	enum ath9k_power_mode mode;
 	unsigned long flags;
+	bool reset;
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
-	if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
+	if (sc->ps_idle) {
+		ath9k_hw_setrxabort(sc->sc_ah, 1);
+		ath9k_hw_stopdmarecv(sc->sc_ah, &reset);
 		mode = ATH9K_PM_FULL_SLEEP;
-	else if (sc->ps_enabled &&
-		 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
-			      PS_WAIT_FOR_CAB |
-			      PS_WAIT_FOR_PSPOLL_DATA |
-			      PS_WAIT_FOR_TX_ACK)))
+	} else if (sc->ps_enabled &&
+		   !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
+				     PS_WAIT_FOR_CAB |
+				     PS_WAIT_FOR_PSPOLL_DATA |
+				     PS_WAIT_FOR_TX_ACK))) {
 		mode = ATH9K_PM_NETWORK_SLEEP;
-	else
+	} else {
 		goto unlock;
+	}
 
 	spin_lock(&common->cc_lock);
 	ath_hw_cycle_counters_update(common);
@@ -1100,14 +1104,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 	}
 
-	/*
-	 * Cannot tx while the hardware is in full sleep, it first needs a full
-	 * chip reset to recover from that
-	 */
-	if (unlikely(sc->sc_ah->power_mode == ATH9K_PM_FULL_SLEEP))
-		goto exit;
-
-	if (unlikely(sc->sc_ah->power_mode != ATH9K_PM_AWAKE)) {
+	if (unlikely(sc->sc_ah->power_mode == ATH9K_PM_NETWORK_SLEEP)) {
 		/*
 		 * We are using PS-Poll and mac80211 can request TX while in
 		 * power save mode. Need to wake up hardware for the TX to be
@@ -1126,12 +1123,21 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 		/*
 		 * The actual restore operation will happen only after
-		 * the sc_flags bit is cleared. We are just dropping
+		 * the ps_flags bit is cleared. We are just dropping
 		 * the ps_usecount here.
 		 */
 		ath9k_ps_restore(sc);
 	}
 
+	/*
+	 * Cannot tx while the hardware is in full sleep, it first needs a full
+	 * chip reset to recover from that
+	 */
+	if (unlikely(sc->sc_ah->power_mode == ATH9K_PM_FULL_SLEEP)) {
+		ath_err(common, "TX while HW is in FULL_SLEEP mode\n");
+		goto exit;
+	}
+
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
 	txctl.txq = sc->tx.txq_map[skb_get_queue_mapping(skb)];
 
@@ -1528,6 +1534,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 static void ath9k_enable_ps(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	sc->ps_enabled = true;
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
@@ -1537,11 +1544,13 @@ static void ath9k_enable_ps(struct ath_softc *sc)
 		}
 		ath9k_hw_setrxabort(ah, 1);
 	}
+	ath_dbg(common, PS, "PowerSave enabled\n");
 }
 
 static void ath9k_disable_ps(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 
 	sc->ps_enabled = false;
 	ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
@@ -1556,7 +1565,7 @@ static void ath9k_disable_ps(struct ath_softc *sc)
 			ath9k_hw_set_interrupts(ah);
 		}
 	}
-
+	ath_dbg(common, PS, "PowerSave disabled\n");
 }
 
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
-- 
1.7.10

