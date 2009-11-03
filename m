Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbZKCDH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 22:07:57 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [RFT 1/9] ath9k: fix listening to idle requests
Date: Mon,  2 Nov 2009 22:07:53 -0500
Message-Id: <1257217681-27180-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
References: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The way idle configuration detection was implemented as
busted due to the fact that it assumed the ath9k virtual wiphy,
the aphy, would be marked as inactive if it was not used but
it turns out an aphy is always active if its the only wiphy
present. We need to distinguish between aphy activity and
idleness so we now add an idle bool for the aphy and mark
it as such based on the passed IEEE80211_CONF_CHANGE_IDLE
from mac80211.

Previous to all_wiphys_idle would never be true when using
only one device so we never really were using
IEEE80211_CONF_CHANGE_IDLE -- we never turned the radio
off or on upon IEEE80211_CONF_CHANGE_IDLE changes as radio
changes depended on all_wiphys_idle being true either to
turn the radio on or off. Since it was always false for
one device this code was doing nothing.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Reported-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    2 +
 drivers/net/wireless/ath/ath9k/main.c    |   33 +++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/virtual.c |   17 ++++++++++++--
 3 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 13dd020..da53578 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -620,6 +620,7 @@ struct ath_wiphy {
 		ATH_WIPHY_PAUSED,
 		ATH_WIPHY_SCAN,
 	} state;
+	bool idle;
 	int chan_idx;
 	int chan_is_ht;
 };
@@ -691,6 +692,7 @@ void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
 bool ath9k_wiphy_scanning(struct ath_softc *sc);
 void ath9k_wiphy_work(struct work_struct *work);
 bool ath9k_all_wiphys_idle(struct ath_softc *sc);
+void ath9k_set_wiphy_idle(struct ath_wiphy *aphy, bool idle);
 
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9fefc51..bdce0ab 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2688,22 +2688,37 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ath_hw *ah = sc->sc_ah;
-	bool all_wiphys_idle = false, disable_radio = false;
+	bool disable_radio;
 
 	mutex_lock(&sc->mutex);
 
-	/* Leave this as the first check */
+	/*
+	 * Leave this as the first check because we need to turn on the
+	 * radio if it was disabled before prior to processing the rest
+	 * of the changes. Likewise we must only disable the radio towards
+	 * the end.
+	 */
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		bool enable_radio;
+		bool all_wiphys_idle;
+		bool idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
 		spin_lock_bh(&sc->wiphy_lock);
 		all_wiphys_idle =  ath9k_all_wiphys_idle(sc);
+		ath9k_set_wiphy_idle(aphy, idle);
+
+		if (!idle && all_wiphys_idle)
+			enable_radio = true;
+
+		/*
+		 * After we unlock here its possible another wiphy
+		 * can be re-renabled so to account for that we will
+		 * only disable the radio toward the end of this routine
+		 * if by then all wiphys are still idle.
+		 */
 		spin_unlock_bh(&sc->wiphy_lock);
 
-		if (conf->flags & IEEE80211_CONF_IDLE){
-			if (all_wiphys_idle)
-				disable_radio = true;
-		}
-		else if (all_wiphys_idle) {
+		if (enable_radio) {
 			ath_radio_enable(sc);
 			ath_print(common, ATH_DBG_CONFIG,
 				  "not-idle: enabling radio\n");
@@ -2779,6 +2794,10 @@ skip_chan_change:
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->config.txpowlimit = 2 * conf->power_level;
 
+	spin_lock_bh(&sc->wiphy_lock);
+	disable_radio = ath9k_all_wiphys_idle(sc);
+	spin_unlock_bh(&sc->wiphy_lock);
+
 	if (disable_radio) {
 		ath_print(common, ATH_DBG_CONFIG, "idle: disabling radio\n");
 		ath_radio_disable(sc);
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index bc7d173..e6a50f3 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -668,15 +668,26 @@ void ath9k_wiphy_set_scheduler(struct ath_softc *sc, unsigned int msec_int)
 bool ath9k_all_wiphys_idle(struct ath_softc *sc)
 {
 	unsigned int i;
-	if (sc->pri_wiphy->state != ATH_WIPHY_INACTIVE) {
+	if (!sc->pri_wiphy->idle)
 		return false;
-	}
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
 		if (!aphy)
 			continue;
-		if (aphy->state != ATH_WIPHY_INACTIVE)
+		if (!aphy->idle)
 			return false;
 	}
 	return true;
 }
+
+/* caller must hold wiphy_lock */
+void ath9k_set_wiphy_idle(struct ath_wiphy *aphy, bool idle)
+{
+	struct ath_softc *sc = aphy->sc;
+
+	aphy->idle = idle;
+	ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_CONFIG,
+		  "Marking %s as %s\n",
+		  wiphy_name(aphy->hw->wiphy),
+		  idle ? "idle" : "not-idle");
+}
-- 
1.6.5.2.143.g8cc62

