Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:46719 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbbCJQtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:49:40 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 2/3] ath9k: add DFS support for extension channel
Date: Tue, 10 Mar 2015 17:49:30 +0100
Message-Id: <1426006171-2555-3-git-send-email-zefir.kurtisi@neratec.com> (sfid-20150310_174947_094396_C7AA8FAF)
In-Reply-To: <1426006171-2555-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1426006171-2555-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In HT40 modes, pulse events on primary and extension
channel are processed individually. If valid, a pulse
event will be fed into the detector
* for primary frequency, or
* for extension frequency (+/-20MHz based on HT40-mode)
* or both

With that, a 40MHz radar will result in two individual
radar events.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c | 44 ++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 726271c..e98a9ea 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -126,8 +126,19 @@ ath9k_postprocess_radar_event(struct ath_softc *sc,
 	DFS_STAT_INC(sc, pulses_detected);
 	return true;
 }
-#undef PRI_CH_RADAR_FOUND
-#undef EXT_CH_RADAR_FOUND
+
+static void
+ath9k_dfs_process_radar_pulse(struct ath_softc *sc, struct pulse_event *pe)
+{
+	struct dfs_pattern_detector *pd = sc->dfs_detector;
+	DFS_STAT_INC(sc, pulses_processed);
+	if (pd == NULL)
+		return;
+	if (!pd->add_pulse(pd, pe))
+		return;
+	DFS_STAT_INC(sc, radar_detected);
+	ieee80211_radar_detected(sc->hw);
+}
 
 /*
  * DFS: check PHY-error for radar pulse and feed the detector
@@ -176,18 +187,21 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	ard.pulse_length_pri = vdata_end[-3];
 	pe.freq = ah->curchan->channel;
 	pe.ts = mactime;
-	if (ath9k_postprocess_radar_event(sc, &ard, &pe)) {
-		struct dfs_pattern_detector *pd = sc->dfs_detector;
-		ath_dbg(common, DFS,
-			"ath9k_dfs_process_phyerr: channel=%d, ts=%llu, "
-			"width=%d, rssi=%d, delta_ts=%llu\n",
-			pe.freq, pe.ts, pe.width, pe.rssi,
-			pe.ts - sc->dfs_prev_pulse_ts);
-		sc->dfs_prev_pulse_ts = pe.ts;
-		DFS_STAT_INC(sc, pulses_processed);
-		if (pd != NULL && pd->add_pulse(pd, &pe)) {
-			DFS_STAT_INC(sc, radar_detected);
-			ieee80211_radar_detected(sc->hw);
-		}
+	if (!ath9k_postprocess_radar_event(sc, &ard, &pe))
+		return;
+
+	ath_dbg(common, DFS,
+		"ath9k_dfs_process_phyerr: type=%d, freq=%d, ts=%llu, "
+		"width=%d, rssi=%d, delta_ts=%llu\n",
+		ard.pulse_bw_info, pe.freq, pe.ts, pe.width, pe.rssi,
+		pe.ts - sc->dfs_prev_pulse_ts);
+	sc->dfs_prev_pulse_ts = pe.ts;
+	if (ard.pulse_bw_info & PRI_CH_RADAR_FOUND)
+		ath9k_dfs_process_radar_pulse(sc, &pe);
+	if (ard.pulse_bw_info & EXT_CH_RADAR_FOUND) {
+		pe.freq += IS_CHAN_HT40PLUS(ah->curchan) ? 20 : -20;
+		ath9k_dfs_process_radar_pulse(sc, &pe);
 	}
 }
+#undef PRI_CH_RADAR_FOUND
+#undef EXT_CH_RADAR_FOUND
-- 
1.9.1

