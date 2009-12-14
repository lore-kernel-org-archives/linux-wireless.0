Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23159 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZLNJYL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 04:24:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 01:24:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19238.1258.29642.661130@gargle.gargle.HOWL>
Date: Mon, 14 Dec 2009 14:57:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/6] ath9k: Fix TX poll routine
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable the TX hang monitoring routine when doing a scan.
Monitoring for a hung situation is not really necessary during
a scan run.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 310ad5a..3f5b887 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -3127,6 +3127,7 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	ath9k_wiphy_pause_all_forced(sc, aphy);
 	sc->sc_flags |= SC_OP_SCANNING;
 	del_timer_sync(&common->ani.timer);
+	cancel_delayed_work_sync(&sc->tx_complete_work);
 	mutex_unlock(&sc->mutex);
 }
 
@@ -3141,6 +3142,7 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	sc->sc_flags &= ~SC_OP_SCANNING;
 	sc->sc_flags |= SC_OP_FULL_RESET;
 	ath_start_ani(common);
+	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 	ath_beacon_config(sc, NULL);
 	mutex_unlock(&sc->mutex);
 }
-- 
1.6.5.6

