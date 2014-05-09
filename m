Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:10172 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaEIN3c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 09:29:32 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: non-functional: calculate DFS pulse interval per-wiphy
Date: Fri,  9 May 2014 15:19:42 +0200
Message-Id: <1399641582-17367-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20140509_152935_736271_9CFFABC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Systems with multiple DFS channel detectors need to track
timestamp of previous pulse per instance to display the
correct pulse interval.

Since the interval value is used for debug printing only,
this is a non-functional modification.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c       | 6 +++---
 drivers/net/wireless/ath/ath9k/dfs_debug.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 857bb28..5049bec 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -178,12 +178,12 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	pe.ts = mactime;
 	if (ath9k_postprocess_radar_event(sc, &ard, &pe)) {
 		struct dfs_pattern_detector *pd = sc->dfs_detector;
-		static u64 last_ts;
 		ath_dbg(common, DFS,
 			"ath9k_dfs_process_phyerr: channel=%d, ts=%llu, "
 			"width=%d, rssi=%d, delta_ts=%llu\n",
-			pe.freq, pe.ts, pe.width, pe.rssi, pe.ts-last_ts);
-		last_ts = pe.ts;
+			pe.freq, pe.ts, pe.width, pe.rssi,
+			pe.ts - sc->debug.stats.dfs_stats.last_ts);
+		sc->debug.stats.dfs_stats.last_ts = pe.ts;
 		DFS_STAT_INC(sc, pulses_processed);
 		if (pd != NULL && pd->add_pulse(pd, &pe)) {
 			DFS_STAT_INC(sc, radar_detected);
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.h b/drivers/net/wireless/ath/ath9k/dfs_debug.h
index 7936c91..d948686 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.h
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.h
@@ -51,6 +51,7 @@ struct ath_dfs_stats {
 	/* pattern detection stats */
 	u32 pulses_processed;
 	u32 radar_detected;
+	u64 last_ts;
 };
 
 #if defined(CONFIG_ATH9K_DFS_DEBUGFS)
-- 
1.8.3.2

