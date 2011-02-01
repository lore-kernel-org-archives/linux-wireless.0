Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51236 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab1BAOft (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 09:35:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 06:35:29 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: wakeup hw before stopping beacon queue
Date: Tue, 1 Feb 2011 20:04:52 +0530
Message-ID: <1296570892-7074-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1296570892-7074-1-git-send-email-rmanoharan@atheros.com>
References: <1296570892-7074-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before stopping beacon queue ensure that hw is in AWAKE state.
No doing so, causes failure to stop tx dma error message.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c9925e9..bfc70c1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1411,6 +1411,7 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 
 	if (ath9k_uses_beacons(vif->type)) {
 		int error;
+		ath9k_ps_wakeup(sc);
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		/* This may fail because upper levels do not have beacons
 		 * properly configured yet.  That's OK, we assume it
@@ -1423,6 +1424,7 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 			ath9k_reclaim_beacon(sc, vif);
 		else
 			ath_beacon_config(sc, vif);
+		ath9k_ps_restore(sc);
 	}
 }
 
-- 
1.7.4

