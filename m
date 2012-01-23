Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:32883 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab2AWOsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 09:48:05 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 2/2] ath9k: Add STBC flag to rx status Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Date: Mon, 23 Jan 2012 15:44:50 +0100
Message-Id: <1327329890-9512-3-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20120123_154810_487294_DEAFC402)
In-Reply-To: <1327329890-9512-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1327329890-9512-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    1 +
 drivers/net/wireless/ath/ath9k/mac.c        |    2 ++
 drivers/net/wireless/ath/ath9k/mac.h        |    4 +++-
 drivers/net/wireless/ath/ath9k/recv.c       |    2 ++
 4 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 09b8c9d..f270854 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -503,6 +503,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	rxs->rs_antenna = (MS(rxsp->status4, AR_RxAntenna) & 0x7);
 	rxs->rs_flags  = (rxsp->status4 & AR_GI) ? ATH9K_RX_GI : 0;
 	rxs->rs_flags  |= (rxsp->status4 & AR_2040) ? ATH9K_RX_2040 : 0;
+	rxs->rs_flags |= (rxsp->status4 & AR_RxSTBC) ? ATH9K_RX_STBC : 0;
 
 	rxs->evm0 = rxsp->status6;
 	rxs->evm1 = rxsp->status7;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index e196aba..83171b6 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -593,6 +593,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		(ads.ds_rxstatus3 & AR_GI) ? ATH9K_RX_GI : 0;
 	rs->rs_flags |=
 		(ads.ds_rxstatus3 & AR_2040) ? ATH9K_RX_2040 : 0;
+	rs->rs_flags |=
+		(ads.ds_rxstatus3 & AR_RxSTBC) ? ATH9K_RX_STBC : 0;
 
 	if (ads.ds_rxstatus8 & AR_PreDelimCRCErr)
 		rs->rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 11dbd14..d0fda0e 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -191,6 +191,7 @@ struct ath_htc_rx_status {
 #define ATH9K_RX_DELIM_CRC_PRE    0x10
 #define ATH9K_RX_DELIM_CRC_POST   0x20
 #define ATH9K_RX_DECRYPT_BUSY     0x40
+#define ATH9K_RX_STBC             0x80
 
 #define ATH9K_RXKEYIX_INVALID	((u8)-1)
 #define ATH9K_TXKEYIX_INVALID	((u8)-1)
@@ -531,7 +532,8 @@ struct ar5416_desc {
 #define AR_2040             0x00000002
 #define AR_Parallel40       0x00000004
 #define AR_Parallel40_S     2
-#define AR_RxStatusRsvd30   0x000000f8
+#define AR_RxSTBC           0x00000008
+#define AR_RxStatusRsvd30   0x000000f0
 #define AR_RxAntenna	    0xffffff00
 #define AR_RxAntenna_S	    8
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0e666fb..ee94cfd 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -911,6 +911,8 @@ static int ath9k_process_rate(struct ath_common *common,
 			rxs->flag |= RX_FLAG_40MHZ;
 		if (rx_stats->rs_flags & ATH9K_RX_GI)
 			rxs->flag |= RX_FLAG_SHORT_GI;
+		if (rx_stats->rs_flags & ATH9K_RX_STBC)
+			rxs->flag |= RX_FLAG_STBC;
 		rxs->rate_idx = rx_stats->rs_rate & 0x7f;
 		return 0;
 	}
-- 
1.7.4.1

