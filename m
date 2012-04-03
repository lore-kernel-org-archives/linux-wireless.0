Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:37780 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab2DCPQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 11:16:03 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	nbd@openwrt.org, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 3/3] ath9k: update to DFS pattern detector interface
Date: Tue,  3 Apr 2012 17:15:51 +0200
Message-Id: <1333466151-6570-4-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120403_171614_807390_489FB29E)
In-Reply-To: <1333466151-6570-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1333466151-6570-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Follow updates in DFS pattern detector interface:
a) use given pulse event structure
b) adapt to boolean return value of add_pulse()

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c |   80 +++++++++++++---------------------
 drivers/net/wireless/ath/ath9k/dfs.h |    8 ++-
 2 files changed, 36 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index f4f56af..92891f5 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -21,17 +21,6 @@
 #include "dfs.h"
 #include "dfs_debug.h"
 
-/*
- * TODO: move into or synchronize this with generic header
- *	 as soon as IF is defined
- */
-struct dfs_radar_pulse {
-	u16 freq;
-	u64 ts;
-	u32 width;
-	u8 rssi;
-};
-
 /* internal struct to pass radar data */
 struct ath_radar_data {
 	u8 pulse_bw_info;
@@ -60,44 +49,44 @@ static u32 dur_to_usecs(struct ath_hw *ah, u32 dur)
 #define EXT_CH_RADAR_FOUND 0x02
 static bool
 ath9k_postprocess_radar_event(struct ath_softc *sc,
-			      struct ath_radar_data *are,
-			      struct dfs_radar_pulse *drp)
+			      struct ath_radar_data *ard,
+			      struct pulse_event *pe)
 {
 	u8 rssi;
 	u16 dur;
 
 	ath_dbg(ath9k_hw_common(sc->sc_ah), DFS,
 		"pulse_bw_info=0x%x, pri,ext len/rssi=(%u/%u, %u/%u)\n",
-		are->pulse_bw_info,
-		are->pulse_length_pri, are->rssi,
-		are->pulse_length_ext, are->ext_rssi);
+		ard->pulse_bw_info,
+		ard->pulse_length_pri, ard->rssi,
+		ard->pulse_length_ext, ard->ext_rssi);
 
 	/*
 	 * Only the last 2 bits of the BW info are relevant, they indicate
 	 * which channel the radar was detected in.
 	 */
-	are->pulse_bw_info &= 0x03;
+	ard->pulse_bw_info &= 0x03;
 
-	switch (are->pulse_bw_info) {
+	switch (ard->pulse_bw_info) {
 	case PRI_CH_RADAR_FOUND:
 		/* radar in ctrl channel */
-		dur = are->pulse_length_pri;
+		dur = ard->pulse_length_pri;
 		DFS_STAT_INC(sc, pri_phy_errors);
 		/*
 		 * cannot use ctrl channel RSSI
 		 * if extension channel is stronger
 		 */
-		rssi = (are->ext_rssi >= (are->rssi + 3)) ? 0 : are->rssi;
+		rssi = (ard->ext_rssi >= (ard->rssi + 3)) ? 0 : ard->rssi;
 		break;
 	case EXT_CH_RADAR_FOUND:
 		/* radar in extension channel */
-		dur = are->pulse_length_ext;
+		dur = ard->pulse_length_ext;
 		DFS_STAT_INC(sc, ext_phy_errors);
 		/*
 		 * cannot use extension channel RSSI
 		 * if control channel is stronger
 		 */
-		rssi = (are->rssi >= (are->ext_rssi + 12)) ? 0 : are->ext_rssi;
+		rssi = (ard->rssi >= (ard->ext_rssi + 12)) ? 0 : ard->ext_rssi;
 		break;
 	case (PRI_CH_RADAR_FOUND | EXT_CH_RADAR_FOUND):
 		/*
@@ -107,14 +96,14 @@ ath9k_postprocess_radar_event(struct ath_softc *sc,
 		 * Radiated testing, when pulse is on DC, different pri and
 		 * ext durations are reported, so take the larger of the two
 		 */
-		if (are->pulse_length_ext >= are->pulse_length_pri)
-			dur = are->pulse_length_ext;
+		if (ard->pulse_length_ext >= ard->pulse_length_pri)
+			dur = ard->pulse_length_ext;
 		else
-			dur = are->pulse_length_pri;
+			dur = ard->pulse_length_pri;
 		DFS_STAT_INC(sc, dc_phy_errors);
 
 		/* when both are present use stronger one */
-		rssi = (are->rssi < are->ext_rssi) ? are->ext_rssi : are->rssi;
+		rssi = (ard->rssi < ard->ext_rssi) ? ard->ext_rssi : ard->rssi;
 		break;
 	default:
 		/*
@@ -137,8 +126,8 @@ ath9k_postprocess_radar_event(struct ath_softc *sc,
 	 */
 
 	/* convert duration to usecs */
-	drp->width = dur_to_usecs(sc->sc_ah, dur);
-	drp->rssi = rssi;
+	pe->width = dur_to_usecs(sc->sc_ah, dur);
+	pe->rssi = rssi;
 
 	DFS_STAT_INC(sc, pulses_detected);
 	return true;
@@ -155,12 +144,12 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	struct ath_radar_data ard;
 	u16 datalen;
 	char *vdata_end;
-	struct dfs_radar_pulse drp;
+	struct pulse_event pe;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if ((!(rs->rs_phyerr != ATH9K_PHYERR_RADAR)) &&
-	    (!(rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT))) {
+	if ((rs->rs_phyerr != ATH9K_PHYERR_RADAR) &&
+	    (rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT)) {
 		ath_dbg(common, DFS,
 			"Error: rs_phyer=0x%x not a radar error\n",
 			rs->rs_phyerr);
@@ -189,27 +178,20 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	ard.pulse_bw_info = vdata_end[-1];
 	ard.pulse_length_ext = vdata_end[-2];
 	ard.pulse_length_pri = vdata_end[-3];
-
-	ath_dbg(common, DFS,
-		"bw_info=%d, length_pri=%d, length_ext=%d, "
-		"rssi_pri=%d, rssi_ext=%d\n",
-		ard.pulse_bw_info, ard.pulse_length_pri, ard.pulse_length_ext,
-		ard.rssi, ard.ext_rssi);
-
-	drp.freq = ah->curchan->channel;
-	drp.ts = mactime;
-	if (ath9k_postprocess_radar_event(sc, &ard, &drp)) {
+	pe.freq = ah->curchan->channel;
+	pe.ts = mactime;
+	if (ath9k_postprocess_radar_event(sc, &ard, &pe)) {
+		struct dfs_pattern_detector *pd = sc->dfs_detector;
 		static u64 last_ts;
 		ath_dbg(common, DFS,
 			"ath9k_dfs_process_phyerr: channel=%d, ts=%llu, "
 			"width=%d, rssi=%d, delta_ts=%llu\n",
-			drp.freq, drp.ts, drp.width, drp.rssi, drp.ts-last_ts);
-		last_ts = drp.ts;
-		/*
-		 * TODO: forward pulse to pattern detector
-		 *
-		 * ieee80211_add_radar_pulse(drp.freq, drp.ts,
-		 *                           drp.width, drp.rssi);
-		 */
+			pe.freq, pe.ts, pe.width, pe.rssi, pe.ts-last_ts);
+		last_ts = pe.ts;
+		if (pd != NULL && pd->add_pulse(pd, &pe)) {
+			/*
+			 * TODO: forward radar event to DFS management layer
+			 */
+		}
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/dfs.h b/drivers/net/wireless/ath/ath9k/dfs.h
index c241285..3c839f0 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.h
+++ b/drivers/net/wireless/ath/ath9k/dfs.h
@@ -17,6 +17,7 @@
 
 #ifndef ATH9K_DFS_H
 #define ATH9K_DFS_H
+#include "dfs_pattern_detector.h"
 
 #if defined(CONFIG_ATH9K_DFS_CERTIFIED)
 /**
@@ -31,13 +32,14 @@
  *
  * The radar information provided as raw payload data is validated and
  * filtered for false pulses. Events passing all tests are forwarded to
- * the upper layer for pattern detection.
+ * the DFS detector for pattern detection.
  */
 void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 			      struct ath_rx_status *rs, u64 mactime);
 #else
-static inline void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
-					    struct ath_rx_status *rs, u64 mactime) { }
+static inline void
+ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
+			 struct ath_rx_status *rs, u64 mactime) { }
 #endif
 
 #endif /* ATH9K_DFS_H */
-- 
1.7.4.1

