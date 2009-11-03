Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757610AbZKCDH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 22:07:57 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [RFT 5/9] ath9k: pass the ieee80211_hw on radio enable/disable
Date: Mon,  2 Nov 2009 22:07:57 -0500
Message-Id: <1257217681-27180-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
References: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use the ieee80211_hw for radio enable/disable but the wrong
structure hw was being used in consideration for virtual wiphys
as each virtual wiphy has its own ieee80211_hw struct.

Just pass the hw struct to ensure we use the right one. This should
fix the hw used and passed for radio enable/disable. This includes
the stoping / starting of the software TX queues so mac80211 doesn't
send us data for a specific virtual wiphy. ath9k already takes care
of pausing virtual wiphys and stopping the respective queues on its
own, but this should handle the idle mac80211 conf calls as well.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    5 +++--
 drivers/net/wireless/ath/ath9k/main.c    |   18 +++++++++---------
 drivers/net/wireless/ath/ath9k/virtual.c |    5 +++--
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index da53578..59ce7ec 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -655,8 +655,9 @@ void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 void ath_update_chainmask(struct ath_softc *sc, int is_ht);
 int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan);
-void ath_radio_enable(struct ath_softc *sc);
-void ath_radio_disable(struct ath_softc *sc);
+
+void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw);
+void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
 
 #ifdef CONFIG_PCI
 int ath_pci_init(void);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bdce0ab..11aaa7d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1200,11 +1200,11 @@ fail:
 	ath_deinit_leds(sc);
 }
 
-void ath_radio_enable(struct ath_softc *sc)
+void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *channel = sc->hw->conf.channel;
+	struct ieee80211_channel *channel = hw->conf.channel;
 	int r;
 
 	ath9k_ps_wakeup(sc);
@@ -1241,18 +1241,18 @@ void ath_radio_enable(struct ath_softc *sc)
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
 	ath9k_hw_set_gpio(ah, ah->led_pin, 0);
 
-	ieee80211_wake_queues(sc->hw);
+	ieee80211_wake_queues(hw);
 	ath9k_ps_restore(sc);
 }
 
-void ath_radio_disable(struct ath_softc *sc)
+void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ieee80211_channel *channel = sc->hw->conf.channel;
+	struct ieee80211_channel *channel = hw->conf.channel;
 	int r;
 
 	ath9k_ps_wakeup(sc);
-	ieee80211_stop_queues(sc->hw);
+	ieee80211_stop_queues(hw);
 
 	/* Disable LED */
 	ath9k_hw_set_gpio(ah, ah->led_pin, 1);
@@ -1266,7 +1266,7 @@ void ath_radio_disable(struct ath_softc *sc)
 	ath_flushrecv(sc);		/* flush recv queue */
 
 	if (!ah->curchan)
-		ah->curchan = ath_get_curchannel(sc, sc->hw);
+		ah->curchan = ath_get_curchannel(sc, hw);
 
 	spin_lock_bh(&sc->sc_resetlock);
 	r = ath9k_hw_reset(ah, ah->curchan, false);
@@ -2719,7 +2719,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		spin_unlock_bh(&sc->wiphy_lock);
 
 		if (enable_radio) {
-			ath_radio_enable(sc);
+			ath_radio_enable(sc, hw);
 			ath_print(common, ATH_DBG_CONFIG,
 				  "not-idle: enabling radio\n");
 		}
@@ -2800,7 +2800,7 @@ skip_chan_change:
 
 	if (disable_radio) {
 		ath_print(common, ATH_DBG_CONFIG, "idle: disabling radio\n");
-		ath_radio_disable(sc);
+		ath_radio_disable(sc, hw);
 	}
 
 	mutex_unlock(&sc->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 7678c4a..69a871b 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -526,8 +526,9 @@ int ath9k_wiphy_select(struct ath_wiphy *aphy)
 			 * frame being completed)
 			 */
 			spin_unlock_bh(&sc->wiphy_lock);
-			ath_radio_disable(sc);
-			ath_radio_enable(sc);
+			ath_radio_disable(sc, aphy->hw);
+			ath_radio_enable(sc, aphy->hw);
+			/* Only the primary wiphy hw is used for queuing work */
 			ieee80211_queue_work(aphy->sc->hw,
 				   &aphy->sc->chan_work);
 			return -EBUSY; /* previous select still in progress */
-- 
1.6.5.2.143.g8cc62

