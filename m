Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2101 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761092AbZFKCXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:23:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: enable hardware LEDs
Date: Wed, 10 Jun 2009 22:22:21 -0400
Message-Id: <1244686941-29223-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244686941-29223-1-git-send-email-me@bobcopeland.com>
References: <1244686941-29223-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cardbus and some PCI cards use hardware LEDs rather than software GPIOs.
Program them with the proper blink patterns when idle, scanning or
associated.  Fixes http://bugzilla.kernel.org/show_bug.cgi?id=13288.

Tested-by: Frans Pop <elendil@planet.nl>
Tested-by: Mark Hindley <mark@hindley.org.uk>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/attach.c |    3 +++
 drivers/net/wireless/ath/ath5k/base.c   |   20 ++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index c41ef58..9a84d94 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -319,6 +319,9 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	ath5k_hw_rfgain_opt_init(ah);
 
+	/* turn on HW LEDs */
+	ath5k_hw_set_ledstate(ah, AR5K_LED_INIT);
+
 	return ah;
 err_free:
 	kfree(ah);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 55f7de0..1861d3b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -248,6 +248,8 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif,
 		struct ieee80211_bss_conf *bss_conf,
 		u32 changes);
+static void ath5k_sw_scan_start(struct ieee80211_hw *hw);
+static void ath5k_sw_scan_complete(struct ieee80211_hw *hw);
 
 static const struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
@@ -265,6 +267,8 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.set_tsf 	= ath5k_set_tsf,
 	.reset_tsf 	= ath5k_reset_tsf,
 	.bss_info_changed = ath5k_bss_info_changed,
+	.sw_scan_start	= ath5k_sw_scan_start,
+	.sw_scan_complete = ath5k_sw_scan_complete,
 };
 
 /*
@@ -3162,6 +3166,8 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		sc->assoc = bss_conf->assoc;
 		if (sc->opmode == NL80211_IFTYPE_STATION)
 			set_beacon_filter(hw, sc->assoc);
+		ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
+			AR5K_LED_ASSOC : AR5K_LED_INIT);
 	}
 
 	if (changes & BSS_CHANGED_BEACON &&
@@ -3174,3 +3180,17 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
  unlock:
 	mutex_unlock(&sc->lock);
 }
+
+static void ath5k_sw_scan_start(struct ieee80211_hw *hw)
+{
+	struct ath5k_softc *sc = hw->priv;
+	if (!sc->assoc)
+		ath5k_hw_set_ledstate(sc->ah, AR5K_LED_SCAN);
+}
+
+static void ath5k_sw_scan_complete(struct ieee80211_hw *hw)
+{
+	struct ath5k_softc *sc = hw->priv;
+	ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
+		AR5K_LED_ASSOC : AR5K_LED_INIT);
+}
-- 
1.6.0.6


