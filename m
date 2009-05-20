Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35259 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbZETS7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 14:59:11 -0400
Date: Wed, 20 May 2009 21:59:08 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Update Beacon timers based on timestamp from the AP
Message-ID: <20090520185908.GB25436@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs seem to drift away from the expected TBTT (timestamp %
beacon_int_in_usec differs quite a bit from zero) which can result in
us waking up way too early to receive a Beacon frame. In order to work
around this, re-configure the Beacon timers after having received a
Beacon frame from the AP (i.e., when we know the offset between the
expected TBTT and the actual time the AP is sending out the Beacon
frame).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    9 ++++++++-
 drivers/net/wireless/ath/ath9k/recv.c  |    7 +++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/ath9k.h	2009-05-20 21:21:51.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/ath9k.h	2009-05-20 21:26:21.000000000 +0300
@@ -522,6 +522,7 @@ struct ath_rfkill {
 #define SC_OP_WAIT_FOR_CAB      BIT(16)
 #define SC_OP_WAIT_FOR_PSPOLL_DATA BIT(17)
 #define SC_OP_WAIT_FOR_TX_ACK   BIT(18)
+#define SC_OP_BEACON_SYNC       BIT(19)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-05-20 21:25:28.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-05-20 21:26:21.000000000 +0300
@@ -487,7 +487,7 @@ static void ath9k_tasklet(unsigned long 
 		 * the next Beacon.
 		 */
 		DPRINTF(sc, ATH_DBG_PS, "TSFOOR - Sync with next Beacon\n");
-		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
+		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON | SC_OP_BEACON_SYNC;
 	}
 
 	/* re-enable hardware interrupt */
@@ -914,6 +914,13 @@ static void ath9k_bss_assoc_info(struct 
 		if (avp->av_opmode == NL80211_IFTYPE_STATION) {
 			sc->curaid = bss_conf->aid;
 			ath9k_hw_write_associd(sc);
+
+			/*
+			 * Request a re-configuration of Beacon related timers
+			 * on the receipt of the first Beacon frame (i.e.,
+			 * after time sync with the AP).
+			 */
+			sc->sc_flags |= SC_OP_BEACON_SYNC;
 		}
 
 		/* Configure the beacon */
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2009-05-20 21:21:51.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2009-05-20 21:26:21.000000000 +0300
@@ -521,6 +521,13 @@ static void ath_rx_ps_beacon(struct ath_
 	if (memcmp(sc->curbssid, mgmt->bssid, ETH_ALEN) != 0)
 		return; /* not from our current AP */
 
+	if (sc->sc_flags & SC_OP_BEACON_SYNC) {
+		sc->sc_flags &= ~SC_OP_BEACON_SYNC;
+		DPRINTF(sc, ATH_DBG_PS, "Reconfigure Beacon timers based on "
+			"timestamp from the AP\n");
+		ath_beacon_config(sc, NULL);
+	}
+
 	if (!(sc->hw->conf.flags & IEEE80211_CONF_PS)) {
 		/* We are not in PS mode anymore; remain awake */
 		DPRINTF(sc, ATH_DBG_PS, "Not in PS mode anymore, remain "

-- 
Jouni Malinen                                            PGP id EFC895FA
