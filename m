Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36566 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab0ASTvh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 14:51:37 -0500
Message-ID: <4B560D44.4080500@openwrt.org>
Date: Tue, 19 Jan 2010 20:51:32 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix beacon slot/buffer leak
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cleaning up beacon buffers and slots, ath9k currently checks if
sc->ah->opmode is set to a beacon related mode before cleaning up
buffers.
An unfortunate ordering of interface up/down commands can lead to
sc->ah->opmode being set to monitor mode, while there are AP interfaces
present on the same wiphy.
Always cleaning up beacon buffers if present fixes this issue.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1471,10 +1471,10 @@ static void ath9k_remove_interface(struc
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
 		ath9k_ps_wakeup(sc);
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-		ath_beacon_return(sc, avp);
 		ath9k_ps_restore(sc);
 	}
 
+	ath_beacon_return(sc, avp);
 	sc->sc_flags &= ~SC_OP_BEACONS;
 
 	for (i = 0; i < ARRAY_SIZE(sc->beacon.bslot); i++) {

