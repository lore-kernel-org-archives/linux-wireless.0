Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21397 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2HMPXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 11:23:25 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 1/3] ath9k: cleanup add_iterface/change_interface
Date: Mon, 13 Aug 2012 20:51:18 +0530
Message-ID: <1344871278-6499-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120813_172338_722082_D81777ED)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

All these checks will be handled by cfg80211 based on
the interface combination advertized. For instance
we support 8 beacon while we advertize maximum 8
beaconing interface in the interface combination
support, also cfg80211 will take care of not allowing
us to add an interface that is not supported by the
driver, so as if the change_interface changes the
old interface to a beaconing interface where we had
reached the maximum number of beacoing interface

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   41 +-------------------------------
 1 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a22df74..b0ee05a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -983,35 +983,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int ret = 0;
 
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
-	switch (vif->type) {
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_WDS:
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_MESH_POINT:
-		break;
-	default:
-		ath_err(common, "Interface type %d not yet supported\n",
-			vif->type);
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (ath9k_uses_beacons(vif->type)) {
-		if (sc->nbcnvifs >= ATH_BCBUF) {
-			ath_err(common, "Not enough beacon buffers when adding"
-				" new interface of type: %i\n",
-				vif->type);
-			ret = -ENOBUFS;
-			goto out;
-		}
-	}
-
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 
 	sc->nvifs++;
@@ -1020,10 +995,9 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
 
-out:
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
-	return ret;
+	return 0;
 }
 
 static int ath9k_change_interface(struct ieee80211_hw *hw,
@@ -1033,22 +1007,12 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	int ret = 0;
 
 	ath_dbg(common, CONFIG, "Change Interface\n");
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
 
-	if (ath9k_uses_beacons(new_type) &&
-	    !ath9k_uses_beacons(vif->type)) {
-		if (sc->nbcnvifs >= ATH_BCBUF) {
-			ath_err(common, "No beacon slot available\n");
-			ret = -ENOBUFS;
-			goto out;
-		}
-	}
-
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_remove_slot(sc, vif);
 
@@ -1059,10 +1023,9 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
 
-out:
 	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
-	return ret;
+	return 0;
 }
 
 static void ath9k_remove_interface(struct ieee80211_hw *hw,
-- 
1.7.0.4

