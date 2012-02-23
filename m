Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41076 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab2BWK2X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 05:28:23 -0500
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: fix PHY error accounting in debugfs
Date: Thu, 23 Feb 2012 11:28:07 +0100
Message-Id: <1329992887-4442-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120223_112826_771524_6D653452)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_phyerr are defined as index but have been treated as bitmask
(with an outdated mask used) for counting PHY errors in debugfs.
---
 drivers/net/wireless/ath/ath9k/debug.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 68d972b..3be5b83 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1049,8 +1049,6 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 #define RX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].rs\
 			[sc->debug.rsidx].c)
 
-	u32 phyerr;
-
 	RX_STAT_INC(rx_pkts_all);
 	sc->debug.stats.rxstats.rx_bytes_all += rs->rs_datalen;
 
@@ -1068,9 +1066,11 @@ void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 		RX_STAT_INC(decrypt_busy_err);
 
 	if (rs->rs_status & ATH9K_RXERR_PHY) {
+		u32 phyerr;
 		RX_STAT_INC(phy_err);
-		phyerr = rs->rs_phyerr & 0x24;
-		RX_PHY_ERR_INC(phyerr);
+		phyerr = rs->rs_phyerr;
+		if (phyerr < ATH9K_PHYERR_MAX)
+			RX_PHY_ERR_INC(phyerr);
 	}
 
 	sc->debug.stats.rxstats.rs_rssi_ctl0 = rs->rs_rssi_ctl0;
-- 
1.7.4.1

