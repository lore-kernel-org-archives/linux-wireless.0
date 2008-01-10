Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:31002 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751069AbYAJGG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 01:06:26 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/1] ath5k: remove duplicate bssid variable
Date: Thu, 10 Jan 2008 15:06:29 +0900
Message-Id: <1199945189-22180-1-git-send-email-bruno@thinktube.com> (sfid-20080110_060634_597894_FB5FB09B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct ath5k_hw included two different variables for caching the bssid. remove
one of them.

drivers/net/wireless/ath5k/ath5k.h:     Changes-licensed-under: ISC
drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
drivers/net/wireless/ath5k/hw.c:        Changes-licensed-under: ISC

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/ath5k.h |    8 ++++----
 drivers/net/wireless/ath5k/base.c  |    4 ++--
 drivers/net/wireless/ath5k/hw.c    |    7 +++----
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 52787ea..878609f 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -951,10 +951,6 @@ struct ath5k_hw {
 	enum ieee80211_if_types	ah_op_mode;
 	enum ath5k_power_mode	ah_power_mode;
 	struct ieee80211_channel ah_current_channel;
-	/* Current BSSID we are trying to assoc to / creating, this
-	 * comes from ieee80211_if_conf. This is passed by mac80211 on
-	 * config_interface() */
-	u8			bssid[ETH_ALEN];
 	bool			ah_turbo;
 	bool			ah_calibration;
 	bool			ah_running;
@@ -991,6 +987,10 @@ struct ath5k_hw {
 	bool			ah_ant_diversity;
 
 	u8			ah_sta_id[ETH_ALEN];
+
+	/* Current BSSID we are trying to assoc to / creating.
+	 * This is passed by mac80211 on config_interface() and cached here for
+	 * use in resets */
 	u8			ah_bssid[ETH_ALEN];
 
 	u32			ah_gpio[AR5K_MAX_GPIO];
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index f9744cd..742616a 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2567,10 +2567,10 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 	if (conf->bssid) {
 		/* Cache for later use during resets */
-		memcpy(ah->bssid, conf->bssid, ETH_ALEN);
+		memcpy(ah->ah_bssid, conf->bssid, ETH_ALEN);
 		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
 		 * a clean way of letting us retrieve this yet. */
-		ath5k_hw_set_associd(ah, ah->bssid, 0);
+		ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
 	}
 	mutex_unlock(&sc->lock);
 
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 64ab950..eb00818 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -262,8 +262,8 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	ath5k_hw_set_lladdr(ah, mac);
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
-	memset(ah->bssid, 0xff, ETH_ALEN);
-	ath5k_hw_set_associd(ah, ah->bssid, 0);
+	memset(ah->ah_bssid, 0xff, ETH_ALEN);
+	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
 	ath5k_hw_set_opmode(ah);
 
 	ath5k_hw_set_rfgain_opt(ah);
@@ -869,7 +869,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	 * Misc
 	 */
 	/* XXX: add ah->aid once mac80211 gives this to us */
-	ath5k_hw_set_associd(ah, ah->bssid, 0);
+	ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
 
 	ath5k_hw_set_opmode(ah);
 	/*PISR/SISR Not available on 5210*/
@@ -2289,7 +2289,6 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	ath5k_hw_reg_write(ah, low_id, AR5K_BSS_ID0);
 	ath5k_hw_reg_write(ah, high_id | ((assoc_id & 0x3fff) <<
 				AR5K_BSS_ID1_AID_S), AR5K_BSS_ID1);
-	memcpy(&ah->ah_bssid, bssid, ETH_ALEN);
 
 	if (assoc_id == 0) {
 		ath5k_hw_disable_pspoll(ah);
-- 
1.5.3.4

