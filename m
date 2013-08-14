Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33824 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab3HNDpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:09 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/14] ath9k: Fix RX crypto processing
Date: Wed, 14 Aug 2013 09:11:12 +0530
Message-Id: <1376451682-25862-4-git-send-email-sujith@msujith.org> (sfid-20130814_060909_262575_7C5C001A)
In-Reply-To: <1376451682-25862-1-git-send-email-sujith@msujith.org>
References: <1376451682-25862-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The keymiss events are valid only in the last descriptor
of a packet. Fix this by making sure that we return
early in case of chained descriptors.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f8cc2b3..b04a971 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -785,10 +785,6 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	    !test_bit(rx_stats->rs_keyix, common->ccmp_keymap))
 		rx_stats->rs_status &= ~ATH9K_RXERR_KEYMISS;
 
-	/* Only use error bits from the last fragment */
-	if (rx_stats->rs_more)
-		return true;
-
 	mic_error = is_valid_tkip && !ieee80211_is_ctl(fc) &&
 		!ieee80211_has_morefrags(fc) &&
 		!(le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG) &&
@@ -959,6 +955,10 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		return -EINVAL;
 	}
 
+	/* Only use status info from the last fragment */
+	if (rx_stats->rs_more)
+		return 0;
+
 	/*
 	 * everything but the rate is checked here, the rate check is done
 	 * separately to avoid doing two lookups for a rate for each frame.
@@ -966,10 +966,6 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	if (!ath9k_rx_accept(common, hdr, rx_status, rx_stats, decrypt_error))
 		return -EINVAL;
 
-	/* Only use status info from the last fragment */
-	if (rx_stats->rs_more)
-		return 0;
-
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
 		return -EINVAL;
 
-- 
1.8.3.4

