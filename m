Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21387 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbZFXN1I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 09:27:08 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 06:27:11 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 4/7] ath9k: remove unnecessary STATION mode check.
Date: Wed, 24 Jun 2009 18:56:39 +0530
Message-ID: <1245850002-26351-5-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1245850002-26351-4-git-send-email-senthilkumar@atheros.com>
References: <1245850002-26351-1-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-2-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-3-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-4-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unncessary STATION mode check in ath9k_bss_assoc_info() as
it is called only for STATION mode.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 66d2190..a977f80 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -921,24 +921,21 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *bss_conf)
 {
-	struct ath_vif *avp = (void *)vif->drv_priv;
 
 	if (bss_conf->assoc) {
 		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info ASSOC %d, bssid: %pM\n",
 			bss_conf->aid, sc->curbssid);
 
 		/* New association, store aid */
-		if (avp->av_opmode == NL80211_IFTYPE_STATION) {
-			sc->curaid = bss_conf->aid;
-			ath9k_hw_write_associd(sc);
+		sc->curaid = bss_conf->aid;
+		ath9k_hw_write_associd(sc);
 
-			/*
-			 * Request a re-configuration of Beacon related timers
-			 * on the receipt of the first Beacon frame (i.e.,
-			 * after time sync with the AP).
-			 */
-			sc->sc_flags |= SC_OP_BEACON_SYNC;
-		}
+		/*
+		 * Request a re-configuration of Beacon related timers
+		 * on the receipt of the first Beacon frame (i.e.,
+		 * after time sync with the AP).
+		 */
+		sc->sc_flags |= SC_OP_BEACON_SYNC;
 
 		/* Configure the beacon */
 		ath_beacon_config(sc, vif);
-- 
1.6.0.4

