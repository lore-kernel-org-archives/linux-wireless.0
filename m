Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52636 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab3D0JrQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 05:47:16 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	greearb@candelatech.com
Subject: [PATCH] ath9k: fix key allocation error handling for powersave keys
Date: Sat, 27 Apr 2013 11:47:01 +0200
Message-Id: <1367056021-38929-1-git-send-email-nbd@openwrt.org> (sfid-20130427_114720_320970_283B6CAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If no keycache slots are available, ath_key_config can return -ENOSPC.
If the key index is not checked for errors, it can lead to logspam that
looks like this: "ath: wiphy0: keyreset: keycache entry 228 out of range"
This can cause follow-up errors if the invalid keycache index gets
used for tx.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6963862..c4fc3d1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1332,6 +1332,7 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 	struct ieee80211_key_conf ps_key = { };
+	int key;
 
 	ath_node_attach(sc, sta, vif);
 
@@ -1339,7 +1340,9 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	    vif->type != NL80211_IFTYPE_AP_VLAN)
 		return 0;
 
-	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
+	key = ath_key_config(common, vif, sta, &ps_key);
+	if (key > 0)
+		an->ps_key = key;
 
 	return 0;
 }
@@ -1356,6 +1359,7 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
 	    return;
 
 	ath_key_delete(common, &ps_key);
+	an->ps_key = 0;
 }
 
 static int ath9k_sta_remove(struct ieee80211_hw *hw,
-- 
1.8.0.2

