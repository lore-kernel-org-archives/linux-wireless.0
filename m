Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62083 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbaARMyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 07:54:43 -0500
Received: from ultralex.lan ([93.218.86.193]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0LcWSI-1Velab0g46-00jtEv for
 <linux-wireless@vger.kernel.org>; Sat, 18 Jan 2014 13:54:41 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 3/5] ath9k_htc: use ath_is_mybeacon
Date: Sat, 18 Jan 2014 13:54:17 +0100
Message-Id: <1390049659-27021-4-git-send-email-linux@rempel-privat.de> (sfid-20140118_135455_445728_8D1915F2)
In-Reply-To: <1390049659-27021-1-git-send-email-linux@rempel-privat.de>
References: <1390049659-27021-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index b41e008..12e0f32 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1075,9 +1075,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 
 	last_rssi = priv->rx.last_rssi;
 
-	if (ieee80211_is_beacon(hdr->frame_control) &&
-	    !is_zero_ether_addr(common->curbssid) &&
-	    ether_addr_equal_64bits(hdr->addr3, common->curbssid)) {
+	if (ath_is_mybeacon(common, hdr)) {
 		s8 rssi = rxbuf->rxstatus.rs_rssi;
 
 		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-- 
1.8.5.2

