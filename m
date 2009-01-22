Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4876 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZAVNof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:44:35 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/6] ath5k: fix locking in ath5k_config
Date: Thu, 22 Jan 2009 08:44:16 -0500
Message-Id: <1232631861-6028-2-git-send-email-me@bobcopeland.com> (sfid-20090122_144441_820910_161A4CBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_config updates the software context without taking sc->lock.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 747b496..1e1222c 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1021,6 +1021,8 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
  * it's done by reseting the chip.  To accomplish this we must
  * first cleanup any pending DMA, then restart stuff after a la
  * ath5k_init.
+ *
+ * Called with sc->lock.
  */
 static int
 ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
@@ -2825,11 +2827,17 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
+	int ret;
+
+	mutex_lock(&sc->lock);
 
 	sc->bintval = conf->beacon_int;
 	sc->power_level = conf->power_level;
 
-	return ath5k_chan_set(sc, conf->channel);
+	ret = ath5k_chan_set(sc, conf->channel);
+
+	mutex_unlock(&sc->lock);
+	return ret;
 }
 
 static int
-- 
1.6.0.6


