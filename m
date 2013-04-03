Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38720 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760726Ab3DCQbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:31:50 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, siwu@hrz.tu-chemnitz.de,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 3/3] ath9k: add support for DFS master mode
Date: Wed,  3 Apr 2013 18:31:31 +0200
Message-Id: <1365006691-16705-4-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_183156_506519_443857C1)
In-Reply-To: <1365006691-16705-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1365006691-16705-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are the remaining knobs in ath9k to support DFS:
* mark AR9280 and AR9580 as DFS tested
* synchronize DFS regulatory domain to reg notifyer
* set required RX filter flags for radar detection
* process radar PHY errors at DFS detector
* notify DFS master on radar detection

DFS support requires CONFIG_ATH9K_DFS_CERTIFIED to be set.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c  |    4 +---
 drivers/net/wireless/ath/ath9k/hw.c   |    3 +++
 drivers/net/wireless/ath/ath9k/init.c |    4 ++++
 drivers/net/wireless/ath/ath9k/main.c |   25 +++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/recv.c |    7 +++++++
 5 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index ecc8179..508f8b3 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -193,9 +193,7 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 		DFS_STAT_INC(sc, pulses_processed);
 		if (pd != NULL && pd->add_pulse(pd, &pe)) {
 			DFS_STAT_INC(sc, radar_detected);
-			/*
-			 * TODO: forward radar event to DFS management layer
-			 */
+			ieee80211_radar_detected(sc->hw);
 		}
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4fa2bb1..3473a79 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2380,8 +2380,11 @@ static bool ath9k_hw_dfs_tested(struct ath_hw *ah)
 {
 
 	switch (ah->hw_version.macVersion) {
+	/* for temporary testing DFS with 9280 */
+	case AR_SREV_VERSION_9280:
 	/* AR9580 will likely be our first target to get testing on */
 	case AR_SREV_VERSION_9580:
+		return true;
 	default:
 		return false;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 385c59a..3be2eb0 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -319,6 +319,10 @@ static void ath9k_reg_notifier(struct wiphy *wiphy,
 		ath9k_ps_wakeup(sc);
 		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit, false);
 		sc->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
+		/* synchronize DFS detector if regulatory domain changed */
+		if (sc->dfs_detector != NULL)
+			sc->dfs_detector->set_dfs_domain(sc->dfs_detector,
+							 request->dfs_region);
 		ath9k_ps_restore(sc);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 24650fd4..2d25148 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1245,10 +1245,27 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		if (old_pos >= 0)
 			ath_update_survey_nf(sc, old_pos);
 
-		/* perform spectral scan if requested. */
-		if (sc->scanning && sc->spectral_mode == SPECTRAL_CHANSCAN)
-			ath9k_spectral_scan_trigger(hw);
-
+		/*
+		 * Enable radar pulse detection if on a DFS channel. Spectral
+		 * scanning and radar detection can not be used concurrently.
+		 */
+		if (hw->conf.radar_enabled) {
+			u32 rxfilter;
+
+			/* set HW specific DFS configuration */
+			ath9k_hw_set_radar_params(ah);
+			rxfilter = ath9k_hw_getrxfilter(ah);
+			rxfilter |= ATH9K_RX_FILTER_PHYRADAR |
+				    ATH9K_RX_FILTER_PHYERR;
+			ath9k_hw_setrxfilter(ah, rxfilter);
+			ath_dbg(common, DFS, "DFS enabled at freq %d\n",
+				curchan->center_freq);
+		} else {
+			/* perform spectral scan if requested. */
+			if (sc->scanning &&
+			    sc->spectral_mode == SPECTRAL_CHANSCAN)
+				ath9k_spectral_scan_trigger(hw);
+		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ee156e5..ee7ca5a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -381,6 +381,10 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	rfilt = ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
 		| ATH9K_RX_FILTER_MCAST;
 
+	/* if operating on a DFS channel, enable radar pulse detection */
+	if (sc->hw->conf.radar_enabled)
+		rfilt |= ATH9K_RX_FILTER_PHYRADAR | ATH9K_RX_FILTER_PHYERR;
+
 	if (sc->rx.rxfilter & FIF_PROBE_REQ)
 		rfilt |= ATH9K_RX_FILTER_PROBEREQ;
 
@@ -1228,6 +1232,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+		if (rs.rs_phyerr == ATH9K_PHYERR_RADAR)
+			ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
+
 		if (rs.rs_status & ATH9K_RXERR_PHY) {
 			if (ath_process_fft(sc, hdr, &rs, rxs->mactime)) {
 				RX_STAT_INC(rx_spectral);
-- 
1.7.4.1

