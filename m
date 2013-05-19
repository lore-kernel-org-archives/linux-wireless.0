Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63932 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab3ESHjQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 03:39:16 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Mev0Z-1UpL220Ter-00OXe6 for
 <linux-wireless@vger.kernel.org>; Sun, 19 May 2013 09:39:15 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 3/3] ath9k: check for Rx-STBC flag and pass it to ieee80211
Date: Sun, 19 May 2013 09:38:56 +0200
Message-Id: <1368949136-6079-4-git-send-email-linux@rempel-privat.de> (sfid-20130519_093927_083371_57673299)
In-Reply-To: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>
References: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/mac.c | 5 +++++
 drivers/net/wireless/ath/ath9k/mac.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index a52081d..d055e38 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -593,6 +593,11 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		(ads.ds_rxstatus3 & AR_GI) ? RX_FLAG_SHORT_GI : 0;
 	rs->flag |=
 		(ads.ds_rxstatus3 & AR_2040) ? RX_FLAG_40MHZ : 0;
+	if (AR_SREV_9280_20_OR_LATER(ah))
+		rs->flag |=
+			(ads.ds_rxstatus3 & AR_STBC) ?
+				/* we can only Nss=1 STBC */
+				(1 << RX_FLAG_STBC_SHIFT) : 0;
 
 	if (ads.ds_rxstatus8 & AR_PreDelimCRCErr)
 		rs->rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 3f1e775..b02dfce 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -534,7 +534,8 @@ struct ar5416_desc {
 #define AR_2040             0x00000002
 #define AR_Parallel40       0x00000004
 #define AR_Parallel40_S     2
-#define AR_RxStatusRsvd30   0x000000f8
+#define AR_STBC             0x00000008 /* on ar9280 and later */
+#define AR_RxStatusRsvd30   0x000000f0
 #define AR_RxAntenna	    0xffffff00
 #define AR_RxAntenna_S	    8
 
-- 
1.8.1.2

