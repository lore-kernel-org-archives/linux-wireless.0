Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43434 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab1DGRH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 13:07:28 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2.6.39] ath9k: fix missing ath9k_ps_wakeup/ath9k_ps_restore calls
Date: Thu,  7 Apr 2011 19:07:17 +0200
Message-Id: <1302196037-27378-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These missing chip wakeups mainly cause crashes on AR5416 cards in MIPS
boards, but have also been reported to cause radio stability issues on
AR9285.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6a41302..802a910 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1376,7 +1376,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 	ath9k_calculate_iter_data(hw, vif, &iter_data);
 
-	ath9k_ps_wakeup(sc);
 	/* Set BSSID mask. */
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
 	ath_hw_setbssidmask(common);
@@ -1411,7 +1410,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	}
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
-	ath9k_ps_restore(sc);
 
 	/* Set up ANI */
 	if ((iter_data.naps + iter_data.nadhocs) > 0) {
@@ -1457,6 +1455,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	int ret = 0;
 
+	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
 	switch (vif->type) {
@@ -1503,6 +1502,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	ath9k_do_vif_add_setup(hw, vif);
 out:
 	mutex_unlock(&sc->mutex);
+	ath9k_ps_restore(sc);
 	return ret;
 }
 
@@ -1517,6 +1517,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Change Interface\n");
 	mutex_lock(&sc->mutex);
+	ath9k_ps_wakeup(sc);
 
 	/* See if new interface type is valid. */
 	if ((new_type == NL80211_IFTYPE_ADHOC) &&
@@ -1546,6 +1547,7 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 
 	ath9k_do_vif_add_setup(hw, vif);
 out:
+	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
 	return ret;
 }
@@ -1558,6 +1560,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	ath_dbg(common, ATH_DBG_CONFIG, "Detach Interface\n");
 
+	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
 	sc->nvifs--;
@@ -1569,6 +1572,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_calculate_summary_state(hw, NULL);
 
 	mutex_unlock(&sc->mutex);
+	ath9k_ps_restore(sc);
 }
 
 static void ath9k_enable_ps(struct ath_softc *sc)
@@ -1809,6 +1813,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	txq = sc->tx.txq_map[queue];
 
+	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
 	memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
@@ -1832,6 +1837,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			ath_beaconq_config(sc);
 
 	mutex_unlock(&sc->mutex);
+	ath9k_ps_restore(sc);
 
 	return ret;
 }
@@ -1908,6 +1914,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	int slottime;
 	int error;
 
+	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
 	if (changed & BSS_CHANGED_BSSID) {
@@ -2008,6 +2015,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	mutex_unlock(&sc->mutex);
+	ath9k_ps_restore(sc);
 }
 
 static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
-- 
1.7.3.2

