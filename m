Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49563 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248Ab0J0MzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 08:55:13 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 05:55:02 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: Avoid HW opmode overridden on monitor mode changes
Date: Wed, 27 Oct 2010 18:31:15 +0530
Message-ID: <1288184475-13889-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HW opmode is blindly set to monitor type on monitor mode
change notification. This overrides the opmode when one of the
interfaces is still running as non-monitor iftype. So the monitoring
information needs to be maintained seperately.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   14 ++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++----
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cc13ee1..c3a4904 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -952,9 +952,12 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_MONITOR:
 		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_KSRCH_MODE);
 		break;
+	default:
+		if (ah->is_monitoring)
+			REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_KSRCH_MODE);
+		break;
 	}
 }
 
@@ -1634,7 +1637,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 
 	switch (ah->opmode) {
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_MONITOR:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(next_beacon));
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, 0xffff);
 		REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
@@ -1663,6 +1665,14 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
 	default:
+		if (ah->is_monitoring) {
+			REG_WRITE(ah, AR_NEXT_TBTT_TIMER,
+					TU_TO_USEC(next_beacon));
+			REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT, 0xffff);
+			REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
+			flags |= AR_TBTT_TIMER_EN;
+			break;
+		}
 		ath_print(ath9k_hw_common(ah), ATH_DBG_BEACON,
 			  "%s: unsupported opmode: %d\n",
 			  __func__, ah->opmode);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d032939..d47d1b4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -622,6 +622,7 @@ struct ath_hw {
 
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
+	bool is_monitoring;
 	bool need_an_top2_fixup;
 	u16 tx_trig_level;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c6ec800..9341833 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1192,6 +1192,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		ah->imask |= ATH9K_INT_CST;
 
 	sc->sc_flags &= ~SC_OP_INVALID;
+	sc->sc_ah->is_monitoring = false;
 
 	/* Disable BMISS interrupt when we're not associated */
 	ah->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
@@ -1466,8 +1467,7 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	if (vif->type == NL80211_IFTYPE_AP    ||
-	    vif->type == NL80211_IFTYPE_ADHOC ||
-	    vif->type == NL80211_IFTYPE_MONITOR) {
+	    vif->type == NL80211_IFTYPE_ADHOC) {
 		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
 	}
@@ -1617,8 +1617,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
 		if (conf->flags & IEEE80211_CONF_MONITOR) {
 			ath_print(common, ATH_DBG_CONFIG,
-				  "HW opmode set to Monitor mode\n");
-			sc->sc_ah->opmode = NL80211_IFTYPE_MONITOR;
+				  "Monitor mode is enabled\n");
+			sc->sc_ah->is_monitoring = true;
+		} else {
+			ath_print(common, ATH_DBG_CONFIG,
+				  "Monitor mode is disabled\n");
+			sc->sc_ah->is_monitoring = false;
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index fe73fc5..ef66f55 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -443,7 +443,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	 */
 	if (((sc->sc_ah->opmode != NL80211_IFTYPE_AP) &&
 	     (sc->rx.rxfilter & FIF_PROMISC_IN_BSS)) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_MONITOR))
+	    (sc->sc_ah->is_monitoring))
 		rfilt |= ATH9K_RX_FILTER_PROM;
 
 	if (sc->rx.rxfilter & FIF_CONTROL)
@@ -898,7 +898,7 @@ static bool ath9k_rx_accept(struct ath_common *common,
 		 * decryption and MIC failures. For monitor mode,
 		 * we also ignore the CRC error.
 		 */
-		if (ah->opmode == NL80211_IFTYPE_MONITOR) {
+		if (ah->is_monitoring) {
 			if (rx_stats->rs_status &
 			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
 			      ATH9K_RXERR_CRC))
-- 
1.7.3.2

