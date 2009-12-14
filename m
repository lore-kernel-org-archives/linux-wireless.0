Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33638 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753AbZLNLCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 06:02:03 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 03:02:03 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19238.7128.326339.839066@gargle.gargle.HOWL>
Date: Mon, 14 Dec 2009 16:34:56 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/6 v2] ath9k: Stop ANI when doing a reset
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MIB counters are disabled when doing a chip reset.
Since ANI depends on the MIB registers for its operation, relying
on the contents of said registers during HW reset results in sub-optimal
performance.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
v2: Updated commit log.

 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c487434..9e68c1a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1973,6 +1973,9 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	struct ieee80211_hw *hw = sc->hw;
 	int r;
 
+	/* Stop ANI */
+	del_timer_sync(&common->ani.timer);
+
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, retry_tx);
 	ath_stoprecv(sc);
@@ -2014,6 +2017,9 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		}
 	}
 
+	/* Start ANI */
+	ath_start_ani(common);
+
 	return r;
 }
 
-- 
1.6.5.6

