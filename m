Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:55591 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbaEUKlv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 06:41:51 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, jim.epost@gmail.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: fix build error with disabled debug
Date: Wed, 21 May 2014 12:40:35 +0200
Message-Id: <1400668835-22335-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20140521_124203_248943_5C2BC411)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DFS pulse interval printing is only available
when CONFIG_ATH9K_DEBUGFS is set.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 5049bec..e0c740d 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -178,12 +178,14 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	pe.ts = mactime;
 	if (ath9k_postprocess_radar_event(sc, &ard, &pe)) {
 		struct dfs_pattern_detector *pd = sc->dfs_detector;
+#ifdef CONFIG_ATH9K_DEBUGFS
 		ath_dbg(common, DFS,
 			"ath9k_dfs_process_phyerr: channel=%d, ts=%llu, "
 			"width=%d, rssi=%d, delta_ts=%llu\n",
 			pe.freq, pe.ts, pe.width, pe.rssi,
 			pe.ts - sc->debug.stats.dfs_stats.last_ts);
 		sc->debug.stats.dfs_stats.last_ts = pe.ts;
+#endif
 		DFS_STAT_INC(sc, pulses_processed);
 		if (pd != NULL && pd->add_pulse(pd, &pe)) {
 			DFS_STAT_INC(sc, radar_detected);
-- 
1.9.1

