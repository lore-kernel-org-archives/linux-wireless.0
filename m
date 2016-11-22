Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:14361 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932263AbcKVLFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 06:05:16 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, michal.kazior@tieto.com,
        benjamin@sipsolutions.net
Subject: [PATCH] ath9k: feed only active spectral / dfs-detector
Date: Tue, 22 Nov 2016 12:05:09 +0100
Message-Id: <1479812709-18875-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20161122_120519_934773_86BB8052)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radar pulse and spectral scan reports are provided by the HW
with the ATH9K_RXERR_PHY flag set. Those are forwarded to
the dfs-detector and spectral module for further processing.

For some older chips, the pre-conditions checked in those
modules are ambiguous, since ATH9K_PHYERR_RADAR is used to
tag both types. As a result, spectral frames are fed into
the dfs-detector and vice versa.

This could lead to a false radar detection on a non-DFS
channel (which is uncritical), but more relevant it causes
useless CPU load for processing invalid frames.

This commit ensures that the dfs-detector and spectral
collector are only fed when they are active.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6697342..48f8af1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -867,10 +867,21 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * can be dropped.
 	 */
 	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
-		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
-		if (ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats, rx_status->mactime))
+		/*
+		 * DFS and spectral are mutually exclusive
+		 *
+		 * Since some chips use PHYERR_RADAR as indication for both, we
+		 * need to double check which feature is enabled to prevent
+		 * feeding spectral or dfs-detector with wrong frames.
+		 */
+		if (hw->conf.radar_enabled) {
+			ath9k_dfs_process_phyerr(sc, hdr, rx_stats,
+						 rx_status->mactime);
+		} else if (sc->spec_priv.spectral_mode != SPECTRAL_DISABLED &&
+			   ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats,
+					       rx_status->mactime)) {
 			RX_STAT_INC(rx_spectral);
-
+		}
 		return -EINVAL;
 	}
 
-- 
2.7.4
