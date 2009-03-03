Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40012 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435AbZCCEur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:50:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 20:50:46 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.46645.574808.942575@gargle.gargle.HOWL> (sfid-20090303_055052_241684_FB365B9F)
Date: Tue, 3 Mar 2009 10:16:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/7] ath9k: Use new scan notifiers from mac80211
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only use case for this right now is ANI calibration,
but more might come up in the future.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath9k/main.c  |   22 +++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 6481ea4..b60ad8d 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -559,6 +559,7 @@ struct ath_rfkill {
 #define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
 #define SC_OP_WAIT_FOR_BEACON	BIT(14)
 #define SC_OP_LED_ON		BIT(15)
+#define SC_OP_SCANNING		BIT(16)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
@@ -681,4 +682,5 @@ static inline void ath9k_ps_restore(struct ath_softc *sc)
 			ath9k_hw_setpower(sc->sc_ah,
 					  sc->sc_ah->restore_mode);
 }
+
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index fef2303..5f409b1 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -327,7 +327,7 @@ static void ath_ani_calibrate(unsigned long data)
 	* don't calibrate when we're scanning.
 	* we are most likely not on our home channel.
 	*/
-	if (sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC)
+	if (sc->sc_flags & SC_OP_SCANNING)
 		goto set_timer;
 
 	/* Long calibration runs independently of short calibration. */
@@ -2614,6 +2614,24 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+
+	mutex_lock(&sc->mutex);
+	sc->sc_flags |= SC_OP_SCANNING;
+	mutex_unlock(&sc->mutex);
+}
+
+static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+
+	mutex_lock(&sc->mutex);
+	sc->sc_flags &= ~SC_OP_SCANNING;
+	mutex_unlock(&sc->mutex);
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2631,6 +2649,8 @@ struct ieee80211_ops ath9k_ops = {
 	.set_tsf 	    = ath9k_set_tsf,
 	.reset_tsf 	    = ath9k_reset_tsf,
 	.ampdu_action       = ath9k_ampdu_action,
+	.sw_scan_start      = ath9k_sw_scan_start,
+	.sw_scan_complete   = ath9k_sw_scan_complete,
 };
 
 static struct {
-- 
1.6.1

