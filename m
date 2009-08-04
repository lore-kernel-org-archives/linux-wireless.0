Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43803 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752319AbZHDXwJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 19:52:09 -0400
Message-ID: <4A78C9A7.2050401@gmx.de>
Date: Wed, 05 Aug 2009 01:52:07 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH v3] ath5k: fix missing output in monitor mode after	ifconfig
 up
References: <4A74C2B6.3070407@gmx.de> <20090802032019.GA25339@hash.localnet> <4A754562.8000107@gmx.de> <20090804154153.GB4995@tuxdriver.com>
In-Reply-To: <20090804154153.GB4995@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Let ath5k_chan_set() always call ath5k_reset().
This fixes the bug that we don't
get any packets in monitor mode after:

ifconfig wlan0 down
iwconfig wlan0 mode monitor channel 1
ifconfig wlan0 up

but they arrive after

iwconfig wlan0 channel 2

Signed-off-by: Joerg Albert <jal2@gmx.de>
---

Same version as [PATCH v2] but with correct whitespaces (hopefully).

 drivers/net/wireless/ath/ath5k/base.c |   35 ++++++++++++++------------------
 1 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3a1c156..5d50285 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1071,10 +1071,9 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
 }
 
 /*
- * Set/change channels.  If the channel is really being changed,
- * it's done by reseting the chip.  To accomplish this we must
- * first cleanup any pending DMA, then restart stuff after a la
- * ath5k_init.
+ * Set/change channels. We always reset the chip.
+ * To accomplish this we must first cleanup any pending DMA,
+ * then restart stuff after a la  ath5k_init.
  *
  * Called with sc->lock.
  */
@@ -1084,19 +1083,13 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
 		sc->curchan->center_freq, chan->center_freq);
 
-	if (chan->center_freq != sc->curchan->center_freq ||
-		chan->hw_value != sc->curchan->hw_value) {
-
-		/*
-		 * To switch channels clear any pending DMA operations;
-		 * wait long enough for the RX fifo to drain, reset the
-		 * hardware at the new frequency, and then re-enable
-		 * the relevant bits of the h/w.
-		 */
-		return ath5k_reset(sc, chan);
-	}
-
-	return 0;
+	/*
+	 * To switch channels clear any pending DMA operations;
+	 * wait long enough for the RX fifo to drain, reset the
+	 * hardware at the new frequency, and then re-enable
+	 * the relevant bits of the h/w.
+	 */
+	return ath5k_reset(sc, chan);
 }
 
 static void
@@ -2811,9 +2804,11 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 
 	mutex_lock(&sc->lock);
 
-	ret = ath5k_chan_set(sc, conf->channel);
-	if (ret < 0)
-		goto unlock;
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		ret = ath5k_chan_set(sc, conf->channel);
+		if (ret < 0)
+			goto unlock;
+	}
 
 	if ((changed & IEEE80211_CONF_CHANGE_POWER) &&
 	(sc->power_level != conf->power_level)) {
-- 
1.6.0.4



