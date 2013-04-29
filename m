Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:46408 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3D2JGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 05:06:19 -0400
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux@rempel-privat.de,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 2/2] ath9k: Add STBC flag to rx status
Date: Mon, 29 Apr 2013 11:04:19 +0200
Message-Id: <1367226260-26755-3-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20130429_110624_859019_A0B98B88)
In-Reply-To: <1367226260-26755-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1367226260-26755-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass RX flag to mac80211 layer when STBC stream has been received.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    1 +
 drivers/net/wireless/ath/ath9k/mac.c        |    2 ++
 drivers/net/wireless/ath/ath9k/mac.h        |    1 +
 drivers/net/wireless/ath/ath9k/recv.c       |    2 ++
 4 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 2570ccc..3318a5f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -592,6 +592,7 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	rxs->rs_antenna = (MS(rxsp->status4, AR_RxAntenna) & 0x7);
 	rxs->rs_flags  = (rxsp->status4 & AR_GI) ? ATH9K_RX_GI : 0;
 	rxs->rs_flags  |= (rxsp->status4 & AR_2040) ? ATH9K_RX_2040 : 0;
+	rxs->rs_flags |= (rxsp->status4 & AR_RxStbc) ? ATH9K_RX_STBC : 0;
 
         rxs->rs_hw_upload_data = (rxsp->status2 & AR_HwUploadData) ? 1 : 0;
 	rxs->rs_not_sounding = (rxsp->status4 & AR_RxNotSounding) ? 1 : 0;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 498fee0..288361d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -590,6 +590,8 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		(ads.ds_rxstatus3 & AR_GI) ? ATH9K_RX_GI : 0;
 	rs->rs_flags |=
 		(ads.ds_rxstatus3 & AR_2040) ? ATH9K_RX_2040 : 0;
+	rs->rs_flags |=
+		(ads.ds_rxstatus3 & AR_RxStbc) ? ATH9K_RX_STBC : 0;
 
 	if (ads.ds_rxstatus8 & AR_PreDelimCRCErr)
 		rs->rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index da5ab6e..a2d17f4 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -199,6 +199,7 @@ struct ath_htc_rx_status {
 #define ATH9K_RX_DELIM_CRC_PRE    0x10
 #define ATH9K_RX_DELIM_CRC_POST   0x20
 #define ATH9K_RX_DECRYPT_BUSY     0x40
+#define ATH9K_RX_STBC             0x80
 
 #define ATH9K_RXKEYIX_INVALID	((u8)-1)
 #define ATH9K_TXKEYIX_INVALID	((u8)-1)
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 8be2b5d..f442c1e 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -872,6 +872,8 @@ static int ath9k_process_rate(struct ath_common *common,
 			rxs->flag |= RX_FLAG_40MHZ;
 		if (rx_stats->rs_flags & ATH9K_RX_GI)
 			rxs->flag |= RX_FLAG_SHORT_GI;
+		if (rx_stats->rs_flags & ATH9K_RX_STBC)
+			rxs->flag |= RX_FLAG_STBC;
 		rxs->rate_idx = rx_stats->rs_rate & 0x7f;
 		return 0;
 	}
-- 
1.7.10.4

