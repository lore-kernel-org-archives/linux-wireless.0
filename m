Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58598 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2BMGV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 01:21:29 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20280.44003.603490.847317@gargle.gargle.HOWL> (sfid-20120213_072132_249485_13EF0634)
Date: Mon, 13 Feb 2012 11:51:23 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 6/7] ath9k: Fix phyerr debug statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Validate the phyerr value against the max. size of the
statistics array properly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5a838fc..228c181 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -987,8 +987,6 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 #define RX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].rs\
 			[sc->debug.rsidx].c)
 
-	u32 phyerr;
-
 	RX_STAT_INC(rx_pkts_all);
 	sc->debug.stats.rxstats.rx_bytes_all += rs->rs_datalen;
 
@@ -1007,8 +1005,8 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 
 	if (rs->rs_status & ATH9K_RXERR_PHY) {
 		RX_STAT_INC(phy_err);
-		phyerr = rs->rs_phyerr & 0x24;
-		RX_PHY_ERR_INC(phyerr);
+		if (rs->rs_phyerr < ATH9K_PHYERR_MAX)
+			RX_PHY_ERR_INC(rs->rs_phyerr);
 	}
 
 	sc->debug.stats.rxstats.rs_rssi_ctl0 = rs->rs_rssi_ctl0;
-- 
1.7.9

