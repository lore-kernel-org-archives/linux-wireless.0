Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:53564 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbZBIERu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 23:17:50 -0500
Date: Mon, 9 Feb 2009 06:17:45 +0200
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH 7/7] ath5k: Don't call reset on config_interface
Message-ID: <20090209041745.GG3168@makis> (sfid-20090209_051752_857855_6833B212)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * We call reset too often and this can result various PHY problems.
  On config_interface we don't need to reset the whole device.

  TODO: Create a function hw_fast_reset that only resets the PCU
  (tx/rx stuff) and not the whole device so that we can use this for
  stuck beacons etc.

  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 685c19c..aa4e726 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2871,7 +2871,7 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&sc->lock);
 	if (sc->vif != vif) {
@@ -2897,9 +2897,7 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		}
 		ath5k_beacon_update(sc, beacon);
 	}
-	mutex_unlock(&sc->lock);
 
-	return ath5k_reset_wake(sc);
 unlock:
 	mutex_unlock(&sc->lock);
 	return ret;
