Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13095 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab1DHLg2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 07:36:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 04:36:02 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: Fix kernel panic on module unload
Date: Fri, 8 Apr 2011 17:06:25 +0530
Message-ID: <1302262585-4126-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: configure beacons based on hw opmode" introduced
a regression which leads to kernel panic. Failed to stop ani timer
during the driver unload while any of the beaconing vif is running.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index eccb0ec..b56f69e 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -320,6 +320,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp)
 	if (avp->av_bcbuf != NULL) {
 		struct ath_buf *bf;
 
+		avp->is_bslot_active = false;
 		if (avp->av_bslot != -1) {
 			sc->beacon.bslot[avp->av_bslot] = NULL;
 			sc->nbcnvifs--;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ba1c9a6..ed41664 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1375,6 +1375,9 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	if ((iter_data.naps + iter_data.nadhocs) > 0) {
 		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
+	} else {
+		sc->sc_flags &= ~SC_OP_ANI_RUN;
+		del_timer_sync(&common->ani.timer);
 	}
 }
 
-- 
1.7.4.4

