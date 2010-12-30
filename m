Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63489 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0L3Nic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 08:38:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 05:38:15 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k: fix beacon restart on channel change
Date: Thu, 30 Dec 2010 19:07:44 +0530
Message-ID: <1293716264-4516-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restart the beacon timers only if the beacon
was already configured. Otherwise beacons timers
are restarted unnecessarily in unassociated state too.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8a1691d..fe09963 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -285,7 +285,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
-		ath_beacon_config(sc, NULL);
+		if (sc->sc_flags & SC_OP_BEACONS)
+			ath_beacon_config(sc, NULL);
 		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 		ath_start_ani(common);
 	}
-- 
1.7.3.4

