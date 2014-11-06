Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58702 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaKFHy6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:58 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 15/21] ath9k_htc: fix rs_datalen conversation
Date: Thu,  6 Nov 2014 08:53:32 +0100
Message-Id: <1415260418-14321-16-git-send-email-linux@rempel-privat.de> (sfid-20141106_085503_807250_56D92828)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some reason it didn't coused obvious problems.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index f0484b1..2622002 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -946,7 +946,7 @@ static inline void convert_htc_flag(struct ath_rx_status *rx_stats,
 static void rx_status_htc_to_ath(struct ath_rx_status *rx_stats,
 				 struct ath_htc_rx_status *rxstatus)
 {
-	rx_stats->rs_datalen	= rxstatus->rs_datalen;
+	rx_stats->rs_datalen	= be16_to_cpu(rxstatus->rs_datalen);
 	rx_stats->rs_status	= rxstatus->rs_status;
 	rx_stats->rs_phyerr	= rxstatus->rs_phyerr;
 	rx_stats->rs_rssi	= rxstatus->rs_rssi;
-- 
1.9.1

