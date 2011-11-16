Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44530 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab1KPMIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:08:54 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/4] ath9k: always issue a full hw reset after waking up from full-sleep mode
Date: Wed, 16 Nov 2011 13:08:40 +0100
Message-Id: <1321445323-71774-1-git-send-email-nbd@openwrt.org> (sfid-20111116_130858_956594_9ABD2E0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After waking up from full sleep, registers are accessible, but rx/tx
typically fails. A fast channel change will not recover from this, so
ensure that a full-sleep -> wake transition is always followed by a full
reset.

The reason why this hasn't created any serious problems yet is that it's
hidden by the (wrong) behavior of enabling/disabling the radio when the
wiphy idle state changes.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++--
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e43c41c..734e854 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -118,7 +118,7 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	if (--sc->ps_usecount != 0)
 		goto unlock;
 
-	if (sc->ps_idle)
+	if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
 		mode = ATH9K_PM_FULL_SLEEP;
 	else if (sc->ps_enabled &&
 		 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
@@ -332,7 +332,8 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 		hchan = ah->curchan;
 	}
 
-	if (fastcc && !ath9k_hw_check_alive(ah))
+	if (fastcc && (ah->chip_fullsleep ||
+	    !ath9k_hw_check_alive(ah)))
 		fastcc = false;
 
 	if (!ath_prepare_reset(sc, retry_tx, flush))
@@ -1176,6 +1177,13 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 	}
 
+	/*
+	 * Cannot tx while the hardware is in full sleep, it first needs a full
+	 * chip reset to recover from that
+	 */
+	if (unlikely(sc->sc_ah->power_mode == ATH9K_PM_FULL_SLEEP))
+		goto exit;
+
 	if (unlikely(sc->sc_ah->power_mode != ATH9K_PM_AWAKE)) {
 		/*
 		 * We are using PS-Poll and mac80211 can request TX while in
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 55d077e..363bf33 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1955,7 +1955,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		skb_pull(skb, padsize);
 	}
 
-	if (sc->ps_flags & PS_WAIT_FOR_TX_ACK) {
+	if ((sc->ps_flags & PS_WAIT_FOR_TX_ACK) && !txq->axq_depth) {
 		sc->ps_flags &= ~PS_WAIT_FOR_TX_ACK;
 		ath_dbg(common, ATH_DBG_PS,
 			"Going back to sleep after having received TX status (0x%lx)\n",
-- 
1.7.3.2

