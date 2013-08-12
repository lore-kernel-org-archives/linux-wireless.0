Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53160 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab3HLJpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 05:45:32 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 08/15] ath9k: Fix PHY error processing
Date: Mon, 12 Aug 2013 15:11:35 +0530
Message-Id: <1376300502-2741-9-git-send-email-sujith@msujith.org> (sfid-20130812_114538_275929_05F22CAF)
In-Reply-To: <1376300502-2741-1-git-send-email-sujith@msujith.org>
References: <1376300502-2741-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Parse the PHY error details only for the last fragment
in case descriptors are chained.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 51e7d16..e18adde 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -803,8 +803,6 @@ static bool ath9k_rx_accept(struct ath_common *common,
 			rxs->flag |= RX_FLAG_FAILED_FCS_CRC;
 			mic_error = false;
 		}
-		if (rx_stats->rs_status & ATH9K_RXERR_PHY)
-			return false;
 
 		if ((rx_stats->rs_status & ATH9K_RXERR_DECRYPT) ||
 		    (!is_mc && (rx_stats->rs_status & ATH9K_RXERR_KEYMISS))) {
@@ -1088,6 +1086,18 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	ath9k_process_tsf(rx_stats, rx_status, tsf);
 
 	/*
+	 * Process PHY errors and return so that the packet
+	 * can be dropped.
+	 */
+	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
+		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
+		if (ath_process_fft(sc, hdr, rx_stats, rx_status->mactime))
+			RX_STAT_INC(rx_spectral);
+
+		return -EINVAL;
+	}
+
+	/*
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
 	 */
@@ -1265,15 +1275,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
-		if (rs.rs_status & ATH9K_RXERR_PHY) {
-			ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
-
-			if (ath_process_fft(sc, hdr, &rs, rxs->mactime)) {
-				RX_STAT_INC(rx_spectral);
-				goto requeue_drop_frag;
-			}
-		}
-
 		retval = ath9k_rx_skb_preprocess(sc, hdr, &rs, rxs,
 						 &decrypt_error, tsf);
 		if (retval)
-- 
1.8.3.4

