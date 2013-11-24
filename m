Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:42943 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3KXQ46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 11:56:58 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so1887843eaj.15
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 08:56:57 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	sujith@msujith.org, johannes@sipsolutions.net,
	rmanohar@qca.qualcomm.com
Subject: [PATCH 2/3] ath9k: get tx99_vif pointer in ath9k_tx99_init
Date: Sun, 24 Nov 2013 17:56:50 +0100
Message-Id: <1385312211-3119-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131124_175705_416678_A4452D08)
In-Reply-To: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get vif reference in ath9k_tx99_init() since mac80211 does not run
ath9k_add_interface() for monitor interfaces

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 9 ---------
 drivers/net/wireless/ath/ath9k/tx99.c | 6 ++++++
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3d17398..7cb2ad9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1046,14 +1046,6 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 
-	if (config_enabled(CONFIG_ATH9K_TX99)) {
-		if (sc->nvifs >= 1) {
-			mutex_unlock(&sc->mutex);
-			return -EOPNOTSUPP;
-		}
-		sc->tx99_vif = vif;
-	}
-
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->nvifs++;
 
@@ -1120,7 +1112,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	sc->nvifs--;
-	sc->tx99_vif = NULL;
 
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_remove_slot(sc, vif);
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index c65c37f..c90eca3 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -89,6 +89,8 @@ static void ath9k_tx99_deinit(struct ath_softc *sc)
 	ath9k_ps_wakeup(sc);
 	ath9k_tx99_stop(sc);
 	ath9k_ps_restore(sc);
+
+	sc->tx99_vif = NULL;
 }
 
 static int ath9k_tx99_init(struct ath_softc *sc)
@@ -105,6 +107,10 @@ static int ath9k_tx99_init(struct ath_softc *sc)
 		return -EINVAL;
 	}
 
+	sc->tx99_vif = ieee80211_get_vif_by_addr(hw, hw->wiphy->perm_addr);
+	if (!sc->tx99_vif)
+		return -EINVAL;
+
 	sc->tx99_skb = ath9k_build_tx99_skb(sc);
 	if (!sc->tx99_skb)
 		return -ENOMEM;
-- 
1.8.3.2

