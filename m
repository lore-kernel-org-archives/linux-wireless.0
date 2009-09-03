Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58433 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZICG1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 02:27:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 23:27:17 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19103.25715.131295.357646@gargle.gargle.HOWL>
Date: Thu, 3 Sep 2009 12:08:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Fix RX Filter handling for BAR
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BAR frames have to be sent to mac80211 only if the
current channel is HT. Also, move the macro to
enum ath9k_rx_filter.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    3 ++-
 drivers/net/wireless/ath/ath9k/mac.h  |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c |    3 +++
 drivers/net/wireless/ath/ath9k/reg.h  |    1 -
 5 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 71f27f3..011b14f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3967,7 +3967,8 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 {
 	u32 phybits;
 
-	REG_WRITE(ah, AR_RX_FILTER, (bits & 0xffff) | AR_RX_COMPR_BAR);
+	REG_WRITE(ah, AR_RX_FILTER, bits);
+
 	phybits = 0;
 	if (bits & ATH9K_RX_FILTER_PHYRADAR)
 		phybits |= AR_PHY_ERR_RADAR;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 7b39822..f56e77d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -568,6 +568,7 @@ enum ath9k_rx_filter {
 	ATH9K_RX_FILTER_PROBEREQ = 0x00000080,
 	ATH9K_RX_FILTER_PHYERR = 0x00000100,
 	ATH9K_RX_FILTER_MYBEACON = 0x00000200,
+	ATH9K_RX_FILTER_COMP_BAR = 0x00000400,
 	ATH9K_RX_FILTER_PSPOLL = 0x00004000,
 	ATH9K_RX_FILTER_PHYRADAR = 0x00002000,
 	ATH9K_RX_FILTER_MCAST_BCAST_ALL = 0x00008000,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c2efdf2..b1d189c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2433,7 +2433,7 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 	ath9k_hw_setrxfilter(sc->sc_ah, rfilt);
 	ath9k_ps_restore(sc);
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", sc->rx.rxfilter);
+	DPRINTF(sc, ATH_DBG_CONFIG, "Set HW RX filter: 0x%x\n", rfilt);
 }
 
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 52e62da..ec0abf8 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -423,6 +423,9 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->rx.rxfilter & FIF_PSPOLL)
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
+	if (conf_is_ht(&sc->hw->conf))
+		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
+
 	if (sc->sec_wiphy || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
 		/* TODO: only needed if more than one BSSID is in use in
 		 * station/adhoc mode */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 3ddb243..e5c29eb 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1325,7 +1325,6 @@ enum {
 #define AR_CFP_VAL          0x0000FFFF
 
 #define AR_RX_FILTER        0x803C
-#define AR_RX_COMPR_BAR     0x00000400
 
 #define AR_MCAST_FIL0       0x8040
 #define AR_MCAST_FIL1       0x8044
-- 
1.6.4.2

