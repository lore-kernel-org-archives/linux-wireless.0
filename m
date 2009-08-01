Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39229 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752177AbZHAWda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 18:33:30 -0400
Message-ID: <4A74C2B6.3070407@gmx.de>
Date: Sun, 02 Aug 2009 00:33:26 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: fix missing output in monitor mode after ifconfig
 up
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let ath5k_chan_set() call ath5k_reset() if ath5k_config() was told
that the channel changed. This fixes the bug that we don't
get any packets in monitor mode after:

ifconfig wlan0 down
iwconfig wlan0 mode monitor channel 1
ifconfig wlan0 up

but they arrive after

iwconfig wlan0 channel 2

Signed-off-by: Joerg Albert <jal2@gmx.de>
---
  drivers/net/wireless/ath/ath5k/base.c |   17 +++++++++--------
  1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3a1c156..09ca89c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -289,7 +289,8 @@ static unsigned int ath5k_copy_channels(struct ath5k_hw *ah,
                                 unsigned int max);
  static int     ath5k_setup_bands(struct ieee80211_hw *hw);
  static int     ath5k_chan_set(struct ath5k_softc *sc,
-                               struct ieee80211_channel *chan);
+                              struct ieee80211_channel *chan,
+                              int chan_changed);
  static void    ath5k_setcurmode(struct ath5k_softc *sc,
                                 unsigned int mode);
  static void    ath5k_mode_setup(struct ath5k_softc *sc);
@@ -1079,14 +1080,13 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
   * Called with sc->lock.
   */
  static int
-ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
+ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan,
+              int chan_changed)
  {
-       ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
-               sc->curchan->center_freq, chan->center_freq);
-
-       if (chan->center_freq != sc->curchan->center_freq ||
-               chan->hw_value != sc->curchan->hw_value) {
+       ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz) chan_changed %x\n",
+                 sc->curchan->center_freq, chan->center_freq, chan_changed);

+       if (chan_changed) {
                 /*
                  * To switch channels clear any pending DMA operations;
                  * wait long enough for the RX fifo to drain, reset the
@@ -2811,7 +2811,8 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)

         mutex_lock(&sc->lock);

-       ret = ath5k_chan_set(sc, conf->channel);
+       ret = ath5k_chan_set(sc, conf->channel,
+                            changed & IEEE80211_CONF_CHANGE_CHANNEL);
         if (ret < 0)
                 goto unlock;

-- 
1.6.0.4

