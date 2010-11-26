Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44582 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0KZRzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 12:55:01 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 09:54:47 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH 1/3] ath9k: Disable SWBA interrupt on remove_interface
Date: Fri, 26 Nov 2010 23:24:31 +0530
Message-ID: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

while removing beaconing mode interface, SWBA interrupt
was never disabled when there are no other beaconing interfaces.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 50bdb5d..6298603 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1436,6 +1436,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = aphy->sc;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	bool bs_valid = false;
 	int i;
 
 	ath_print(common, ATH_DBG_CONFIG, "Detach Interface\n");
@@ -1464,7 +1465,15 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 			       "slot\n", __func__);
 			sc->beacon.bslot[i] = NULL;
 			sc->beacon.bslot_aphy[i] = NULL;
-		}
+		} else if (sc->beacon.bslot[i])
+			bs_valid = true;
+	}
+	if (!bs_valid && (sc->sc_ah->imask & ATH9K_INT_SWBA)) {
+		/* Disable SWBA interrupt */
+		sc->sc_ah->imask &= ~ATH9K_INT_SWBA;
+		ath9k_ps_wakeup(sc);
+		ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_ah->imask);
+		ath9k_ps_restore(sc);
 	}
 
 	sc->nvifs--;
-- 
1.7.3.2

