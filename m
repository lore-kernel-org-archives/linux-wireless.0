Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60899 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab3FCH6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 03:58:19 -0400
Received: from mailout-de.gmx.net ([10.1.76.32]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MQsuO-1UpPxU069e-00UMDH for
 <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 09:58:18 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v4 2/2] ath9k: check for Rx-STBC flag and pass it to ieee80211
Date: Mon,  3 Jun 2013 09:57:59 +0200
Message-Id: <1370246279-6536-3-git-send-email-linux@rempel-privat.de> (sfid-20130603_095825_362696_7E2273A6)
In-Reply-To: <1370246279-6536-1-git-send-email-linux@rempel-privat.de>
References: <1370246279-6536-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch make use of STBC flag in DMA RX descriptor.
Only devices after ar9280 can provide this information.

If card support it we will set HAVE_STBC flag, to show
clint programm thet STBC is supported but not received.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/init.c | 10 ++++++++--
 drivers/net/wireless/ath/ath9k/mac.c  |  5 +++++
 drivers/net/wireless/ath/ath9k/mac.h  |  3 ++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index aba4151..b9c97d4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -21,6 +21,7 @@
 #include <linux/ath9k_platform.h>
 #include <linux/module.h>
 #include <linux/relay.h>
+#include <net/ieee80211_radiotap.h>
 
 #include "ath9k.h"
 
@@ -769,8 +770,13 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		IEEE80211_HW_SUPPORTS_RC_TABLE;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
-		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
+		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+
+		if (AR_SREV_9280_20_OR_LATER(ah))
+			hw->radiotap_mcs_details |=
+				IEEE80211_RADIOTAP_MCS_HAVE_STBC;
+	}
 
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || ath9k_modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
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

