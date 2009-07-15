Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbZGOAW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:22:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: disable radio when all devices are marked idle
Date: Tue, 14 Jul 2009 20:22:53 -0400
Message-Id: <1247617373-20507-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This uses the new configuration changes indicated up by
mac80211 when all interfaces are marked idle. We need to do
a little more work as we have our own set of virtual
wiphys within ath9k.

Only when all virtual wiphys are inactive do we allow an idle
state change for a wiphy to trigger disabling the radio.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c    |   24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/virtual.c |   17 +++++++++++++++++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2723385..efa185a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -709,6 +709,7 @@ void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
 				  struct ath_wiphy *selected);
 bool ath9k_wiphy_scanning(struct ath_softc *sc);
 void ath9k_wiphy_work(struct work_struct *work);
+bool ath9k_all_wiphys_idle(struct ath_softc *sc);
 
 void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val);
 unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 84c0fed..2528571 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2281,9 +2281,28 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_softc *sc = aphy->sc;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct ath_hw *ah = sc->sc_ah;
+	bool all_wiphys_idle = false, disable_radio = false;
 
 	mutex_lock(&sc->mutex);
 
+	/* Leave this as the first check */
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+
+		spin_lock_bh(&sc->wiphy_lock);
+		all_wiphys_idle =  ath9k_all_wiphys_idle(sc);
+		spin_unlock_bh(&sc->wiphy_lock);
+
+		if (conf->flags & IEEE80211_CONF_IDLE){
+			if (all_wiphys_idle)
+				disable_radio = true;
+		}
+		else if (all_wiphys_idle) {
+			ath_radio_enable(sc);
+			DPRINTF(sc, ATH_DBG_CONFIG,
+				"not-idle: enabling radio\n");
+		}
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
 			if (!(ah->caps.hw_caps &
@@ -2351,6 +2370,11 @@ skip_chan_change:
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->config.txpowlimit = 2 * conf->power_level;
 
+	if (disable_radio) {
+		DPRINTF(sc, ATH_DBG_CONFIG, "idle: disabling radio\n");
+		ath_radio_disable(sc);
+	}
+
 	mutex_unlock(&sc->mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 1ff429b..e1d419e 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -660,3 +660,20 @@ void ath9k_wiphy_set_scheduler(struct ath_softc *sc, unsigned int msec_int)
 		queue_delayed_work(sc->hw->workqueue, &sc->wiphy_work,
 				   sc->wiphy_scheduler_int);
 }
+
+/* caller must hold wiphy_lock */
+bool ath9k_all_wiphys_idle(struct ath_softc *sc)
+{
+	unsigned int i;
+	if (sc->pri_wiphy->state != ATH_WIPHY_INACTIVE) {
+		return false;
+	}
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		struct ath_wiphy *aphy = sc->sec_wiphy[i];
+		if (!aphy)
+			continue;
+		if (aphy->state != ATH_WIPHY_INACTIVE)
+			return false;
+	}
+	return true;
+}
-- 
1.6.0.6

