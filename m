Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58911 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbaAOQHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:07:43 -0500
Received: from ultralex.lan ([93.218.75.192]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0Le5XQ-1VZaqG30aS-00puaQ for
 <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 17:07:42 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 2/5] ath9k: use ath_is_mybeacon
Date: Wed, 15 Jan 2014 17:07:15 +0100
Message-Id: <1389802038-6688-3-git-send-email-linux@rempel-privat.de> (sfid-20140115_170746_012257_A821337C)
In-Reply-To: <1389802038-6688-1-git-send-email-linux@rempel-privat.de>
References: <1389802038-6688-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will also change behavior of rx_beacons statistic.
Instead of collecting all received beacons, it will collect only
ours. This, IMO make more sense, since for troubleshooting we will
need to know count of our beacons, or both.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/recv.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 5bf3243..a0ebdd0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -969,21 +969,6 @@ static void ath9k_process_tsf(struct ath_rx_status *rs,
 		rxs->mactime += 0x100000000ULL;
 }
 
-static bool ath9k_is_mybeacon(struct ath_softc *sc, struct ieee80211_hdr *hdr)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (ieee80211_is_beacon(hdr->frame_control)) {
-		RX_STAT_INC(rx_beacons);
-		if (!is_zero_ether_addr(common->curbssid) &&
-		    ether_addr_equal_64bits(hdr->addr3, common->curbssid))
-			return true;
-	}
-
-	return false;
-}
-
 /*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
@@ -1071,7 +1056,10 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 		goto exit;
 	}
 
-	rx_stats->is_mybeacon = ath9k_is_mybeacon(sc, hdr);
+	if (ath_is_mybeacon(common, hdr)) {
+		RX_STAT_INC(rx_beacons);
+		rx_stats->is_mybeacon = true;
+	}
 
 	/*
 	 * This shouldn't happen, but have a safety check anyway.
-- 
1.8.5.2

