Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57909 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab0AHEtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 23:49:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 20:49:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19270.48449.16627.61097@gargle.gargle.HOWL>
Date: Fri, 8 Jan 2010 10:36:09 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] ath9k: Fix queue handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX queues have to be stopped during an
internal reset. Not handling this would result
in packet loss - fix this.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 974de20..1f7222a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -944,6 +944,8 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	/* Stop ANI */
 	del_timer_sync(&common->ani.timer);
 
+	ieee80211_stop_queues(hw);
+
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, retry_tx);
 	ath_stoprecv(sc);
@@ -985,6 +987,8 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		}
 	}
 
+	ieee80211_wake_queues(hw);
+
 	/* Start ANI */
 	ath_start_ani(common);
 
-- 
1.6.6

