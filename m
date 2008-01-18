Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:2859 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758079AbYARMvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:51:35 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 4/4] ath5k: beacon interval is in TU
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Fri, 18 Jan 2008 21:51:40 +0900
Message-ID: <20080118125140.6342.95789.stgit@one> (sfid-20080118_125137_692136_62B7522F)
In-Reply-To: <20080118125018.6342.94435.stgit@one>
References: <20080118125018.6342.94435.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the beacon interval is passed by mac80211 in TU already, so we can directly use
it without conversion. also update the comments about TU (1 TU is defined by
802.11 as 1024usec).

drivers/net/wireless/ath5k/ath5k.h:     Changes-licensed-under: ISC
drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
drivers/net/wireless/ath5k/base.h:      Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/ath5k.h |    4 ++--
 drivers/net/wireless/ath5k/base.c  |    4 ++--
 drivers/net/wireless/ath5k/base.h  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 878609f..c79066b 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -486,8 +486,8 @@ struct ath5k_beacon_state {
  * TSF to TU conversion:
  *
  * TSF is a 64bit value in usec (microseconds).
- * TU is a 32bit value in roughly msec (milliseconds): usec / 1024
- * (1000ms equals 976 TU)
+ * TU is a 32bit value and defined by IEEE802.11 (page 6) as "A measurement of
+ * time equal to 1024 usec", so it's roughly milliseconds (usec / 1024).
  */
 #define TSF_TO_TU(_tsf) (u32)((_tsf) >> 10)
 
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index bb1745f..784b359 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2550,7 +2550,7 @@ ath5k_config(struct ieee80211_hw *hw,
 {
 	struct ath5k_softc *sc = hw->priv;
 
-	sc->bintval = conf->beacon_int * 1000 / 1024;
+	sc->bintval = conf->beacon_int;
 	ath5k_setcurmode(sc, conf->phymode);
 
 	return ath5k_chan_set(sc, conf->chan);
@@ -2566,7 +2566,7 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	/* Set to a reasonable value. Note that this will
 	 * be set to mac80211's value at ath5k_config(). */
-	sc->bintval = 1000 * 1000 / 1024;
+	sc->bintval = 1000;
 	mutex_lock(&sc->lock);
 	if (sc->vif != vif) {
 		ret = -EIO;
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 7ba2223..20c9469 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -164,7 +164,7 @@ struct ath5k_softc {
 	struct ath5k_buf	*bbuf;		/* beacon buffer */
 	unsigned int		bhalq,		/* SW q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
-				bintval,	/* beacon interval */
+				bintval,	/* beacon interval in TU */
 				bsent;
 
 	struct timer_list	calib_tim;	/* calibration timer */

