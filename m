Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55317 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3FCDwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jun 2013 23:52:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] ath9k: Return early for invalid rates
Date: Mon,  3 Jun 2013 09:19:23 +0530
Message-Id: <1370231369-16241-1-git-send-email-sujith@msujith.org> (sfid-20130603_055222_133958_B10117FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Process and update the internal RSSI average, which
is used by ANI, after verifying that the received
frame has valid rate information.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b4b758d..865e043 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -955,11 +955,11 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	if (rx_stats->rs_more)
 		return 0;
 
-	ath9k_process_rssi(common, hw, hdr, rx_stats);
-
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
 		return -EINVAL;
 
+	ath9k_process_rssi(common, hw, hdr, rx_stats);
+
 	rx_status->band = hw->conf.chandef.chan->band;
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->signal = ah->noise + rx_stats->rs_rssi;
-- 
1.8.3

