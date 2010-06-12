Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41847 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0FLPWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 11:22:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 6/7] ath9k/ath9k_htc: remove redundand checks for dual-stream tx support
Date: Sat, 12 Jun 2010 17:22:33 +0200
Message-Id: <1276356154-66545-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1276356154-66545-5-git-send-email-nbd@openwrt.org>
References: <1276356154-66545-1-git-send-email-nbd@openwrt.org>
 <1276356154-66545-2-git-send-email-nbd@openwrt.org>
 <1276356154-66545-3-git-send-email-nbd@openwrt.org>
 <1276356154-66545-4-git-send-email-nbd@openwrt.org>
 <1276356154-66545-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 already masks the HT sta capabilities based on hardware support

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    7 ++-----
 drivers/net/wireless/ath/ath9k/rc.c           |    7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 312ff1b..c0aafa7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -362,11 +362,8 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 		trate->rates.ht_rates.rs_nrates = j;
 
 		caps = WLAN_RC_HT_FLAG;
-		if (priv->ah->caps.tx_chainmask != 1 &&
-		    ath9k_hw_getcapability(priv->ah, ATH9K_CAP_DS, 0, NULL)) {
-			if (sta->ht_cap.mcs.rx_mask[1])
-				caps |= WLAN_RC_DS_FLAG;
-		}
+		if (sta->ht_cap.mcs.rx_mask[1])
+			caps |= WLAN_RC_DS_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			caps |= WLAN_RC_40_FLAG;
 		if (conf_is_ht40(&priv->hw->conf) &&
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 02b6052..600ee0b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1203,11 +1203,8 @@ static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
 
 	if (sta->ht_cap.ht_supported) {
 		caps = WLAN_RC_HT_FLAG;
-		if (sc->sc_ah->caps.tx_chainmask != 1 &&
-		    ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_DS, 0, NULL)) {
-			if (sta->ht_cap.mcs.rx_mask[1])
-				caps |= WLAN_RC_DS_FLAG;
-		}
+		if (sta->ht_cap.mcs.rx_mask[1])
+			caps |= WLAN_RC_DS_FLAG;
 		if (is_cw40)
 			caps |= WLAN_RC_40_FLAG;
 		if (is_sgi)
-- 
1.6.4.2

