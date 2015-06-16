Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:58170 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758AbbFPJqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 05:46:55 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: poh@qca.qualcomm.com, ath9k-devel@venema.h4ckr.net,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: DFS - consider ext_channel pulses only in HT40 mode
Date: Tue, 16 Jun 2015 11:46:42 +0200
Message-Id: <1434448002-4409-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20150616_114728_929855_1CA4A468)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip reports radar pulses on extension channel
even if operating in HT20 mode. This patch adds a
sanity check for HT40 mode before it feeds pulses
on extension channel to the pattern detector.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index e98a9ea..5025a4e 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -198,7 +198,8 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	sc->dfs_prev_pulse_ts = pe.ts;
 	if (ard.pulse_bw_info & PRI_CH_RADAR_FOUND)
 		ath9k_dfs_process_radar_pulse(sc, &pe);
-	if (ard.pulse_bw_info & EXT_CH_RADAR_FOUND) {
+	if (IS_CHAN_HT40(ah->curchan) &&
+	    ard.pulse_bw_info & EXT_CH_RADAR_FOUND) {
 		pe.freq += IS_CHAN_HT40PLUS(ah->curchan) ? 20 : -20;
 		ath9k_dfs_process_radar_pulse(sc, &pe);
 	}
-- 
1.9.1

