Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51134 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280Ab3D2Jd7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 05:33:59 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MbeUV-1UEOGp1LnR-00J4YA for
 <linux-wireless@vger.kernel.org>; Mon, 29 Apr 2013 11:33:58 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 4/4] ath9k: check for Rx-STBC flag and pass it to ieee80211
Date: Mon, 29 Apr 2013 11:33:44 +0200
Message-Id: <1367228024-17936-5-git-send-email-linux@rempel-privat.de> (sfid-20130429_113406_052424_9C0A3CDA)
In-Reply-To: <1367228024-17936-1-git-send-email-linux@rempel-privat.de>
References: <1367228024-17936-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/mac.c | 3 +++
 drivers/net/wireless/ath/ath9k/mac.h | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index a52081d..b924024 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -593,6 +593,9 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 		(ads.ds_rxstatus3 & AR_GI) ? RX_FLAG_SHORT_GI : 0;
 	rs->flag |=
 		(ads.ds_rxstatus3 & AR_2040) ? RX_FLAG_40MHZ : 0;
+	if (AR_SREV_9280_20_OR_LATER(ah))
+		rs->flag |=
+			(ads.ds_rxstatus3 & AR_STBC) ? RX_FLAG_STBC : 0;
 
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

