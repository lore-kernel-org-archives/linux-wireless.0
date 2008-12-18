Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29940 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbYLRGNi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 01:13:38 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 22:13:38 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18761.59720.741872.108661@gargle.gargle.HOWL> (sfid-20081218_071345_704626_3CD29CEB)
Date: Thu, 18 Dec 2008 11:40:16 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Protect config() callback with a mutex
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix the timeout issues seen when using wpa_supplicant.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    1 +
 drivers/net/wireless/ath9k/main.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index e38f033..4ca2aed 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -701,6 +701,7 @@ struct ath_softc {
 	struct ath_hal *sc_ah;
 	void __iomem *mem;
 	spinlock_t sc_resetlock;
+	struct mutex mutex;
 
 	u8 sc_curbssid[ETH_ALEN];
 	u8 sc_myaddr[ETH_ALEN];
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 1759d9b..1afb284 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1326,6 +1326,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 		printk(KERN_ERR "Unable to create debugfs files\n");
 
 	spin_lock_init(&sc->sc_resetlock);
+	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath9k_beacon_tasklet,
 		     (unsigned long)sc);
@@ -2135,6 +2136,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 
+	mutex_lock(&sc->mutex);
 	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
 		       IEEE80211_CONF_CHANGE_HT)) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
@@ -2147,6 +2149,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		if (pos == -1) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n",
 				curchan->center_freq);
+			mutex_unlock(&sc->mutex);
 			return -EINVAL;
 		}
 
@@ -2167,6 +2170,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
+			mutex_unlock(&sc->mutex);
 			return -EINVAL;
 		}
 
@@ -2176,6 +2180,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->sc_config.txpowlimit = 2 * conf->power_level;
 
+	mutex_unlock(&sc->mutex);
 	return 0;
 }
 
-- 
1.6.0.3

