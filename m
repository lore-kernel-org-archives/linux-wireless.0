Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39140 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbYHZCmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 22:42:13 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18611.27933.5301.874156@localhost.localdomain> (sfid-20080826_044215_879204_FCD42046)
Date: Tue, 26 Aug 2008 08:10:29 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/4] ath9k: Remove more dead code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |    5 -----
 drivers/net/wireless/ath9k/beacon.c |   25 -------------------------
 drivers/net/wireless/ath9k/hw.h     |    4 ----
 drivers/net/wireless/ath9k/main.c   |    5 -----
 4 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 020b97f..28b8d84 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -628,11 +628,6 @@ struct ath9k_country_entry {
 				 (IEEE80211_WEP_IVLEN +		\
 				  IEEE80211_WEP_KIDLEN +	\
 				  IEEE80211_WEP_CRCLEN))
-#define IEEE80211_MAX_LEN       (2300 + FCS_LEN +		\
-				 (IEEE80211_WEP_IVLEN +		\
-				  IEEE80211_WEP_KIDLEN +	\
-				  IEEE80211_WEP_CRCLEN))
-
 #define MAX_RATE_POWER 63
 
 enum ath9k_power_mode {
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index fdbabc1..c43fd58 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -454,31 +454,6 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 }
 
 /*
- *  Reclaim beacon resources and return buffer to the pool.
- *
- *  This function will free any wbuf frames that are still attached to the
- *  beacon buffers in the ATH object.  Note that this does not de-allocate
- *  any wbuf objects that are in the transmit queue and have not yet returned
- *  to the ATH object.
-*/
-
-void ath_beacon_free(struct ath_softc *sc)
-{
-	struct ath_buf *bf;
-
-	list_for_each_entry(bf, &sc->sc_bbuf, list) {
-		if (bf->bf_mpdu != NULL) {
-			struct sk_buff *skb = (struct sk_buff *) bf->bf_mpdu;
-			pci_unmap_single(sc->pdev, bf->bf_dmacontext,
-					 skb_end_pointer(skb) - skb->head,
-					 PCI_DMA_TODEVICE);
-			dev_kfree_skb_any(skb);
-			bf->bf_mpdu = NULL;
-		}
-	}
-}
-
-/*
  * Tasklet for Sending Beacons
  *
  * Transmit one or more beacon frames at SWBA.  Dynamic updates to the frame
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 5cb3912..2113818 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -825,10 +825,6 @@ struct ath_hal_5416 {
 #define COEF_SCALE_S                24
 #define HT40_CHANNEL_CENTER_SHIFT   10
 
-#define ar5416CheckOpMode(_opmode)					\
-	((_opmode == ATH9K_M_STA) || (_opmode == ATH9K_M_IBSS) ||	\
-	 (_opmode == ATH9K_M_HOSTAP) || (_opmode == ATH9K_M_MONITOR))
-
 #define AR5416_EEPROM_MAGIC_OFFSET  0x0
 
 #define AR5416_EEPROM_S             2
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 996bb9c..dc45eef 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1167,11 +1167,6 @@ int ath_rx_subframe(struct ath_node *an,
 	return 0;
 }
 
-enum ath9k_ht_macmode ath_cwm_macmode(struct ath_softc *sc)
-{
-	return sc->sc_ht_info.tx_chan_width;
-}
-
 /********************************/
 /*	 LED functions		*/
 /********************************/
-- 
1.6.0

