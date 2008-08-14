Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54831 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYHNIJn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 04:09:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 01:09:43 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18595.58762.207662.812005@localhost.localdomain> (sfid-20080814_100946_485217_607F96BE)
Date: Thu, 14 Aug 2008 13:28:02 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 5/6] ath9k: Use definition from ieee80211.h
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, Max RX-ampdu and mpdu-density are ath9k specific.
Rename appropriately.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 605599e..2b3b11b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -22,8 +22,6 @@
 #define ATH_PCI_VERSION "0.1"
 
 #define IEEE80211_HTCAP_MAXRXAMPDU_FACTOR	13
-#define IEEE80211_ACTION_CAT_HT			7
-#define IEEE80211_ACTION_HT_TXCHWIDTH		0
 
 static char *dev_info = "ath9k";
 
@@ -220,11 +218,8 @@ static void ath_key_delete(struct ath_softc *sc, struct ieee80211_key_conf *key)
 
 static void setup_ht_cap(struct ieee80211_ht_info *ht_info)
 {
-/* Until mac80211 includes these fields */
-
-#define IEEE80211_HT_CAP_DSSSCCK40 0x1000
-#define	IEEE80211_HT_CAP_MAXRXAMPDU_65536 0x3   /* 2 ^ 16 */
-#define	IEEE80211_HT_CAP_MPDUDENSITY_8 0x6     	/* 8 usec */
+#define	ATH9K_HT_CAP_MAXRXAMPDU_65536 0x3	/* 2 ^ 16 */
+#define	ATH9K_HT_CAP_MPDUDENSITY_8 0x6		/* 8 usec */
 
 	ht_info->ht_supported = 1;
 	ht_info->cap = (u16)IEEE80211_HT_CAP_SUP_WIDTH
@@ -232,8 +227,8 @@ static void setup_ht_cap(struct ieee80211_ht_info *ht_info)
 			|(u16)IEEE80211_HT_CAP_SGI_40
 			|(u16)IEEE80211_HT_CAP_DSSSCCK40;
 
-	ht_info->ampdu_factor = IEEE80211_HT_CAP_MAXRXAMPDU_65536;
-	ht_info->ampdu_density = IEEE80211_HT_CAP_MPDUDENSITY_8;
+	ht_info->ampdu_factor = ATH9K_HT_CAP_MAXRXAMPDU_65536;
+	ht_info->ampdu_density = ATH9K_HT_CAP_MPDUDENSITY_8;
 	/* setup supported mcs set */
 	memset(ht_info->supp_mcs_set, 0, 16);
 	ht_info->supp_mcs_set[0] = 0xff;
-- 
1.5.6.5

