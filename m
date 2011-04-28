Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61082 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147Ab1D1KCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 06:02:04 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 03:01:37 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH] ath9k: Fix drain txq failure in flush
Date: Thu, 28 Apr 2011 15:31:57 +0530
Message-ID: <1303984917-12340-1-git-send-email-rmanoharan@atheros.com> (sfid-20110428_120209_418957_C88B8023)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While draining the txq in flush, the buffers can be
added into the tx queue by tx_tasklet which leads to
unneccesary chip reset.

This issue was originially found with AR9382 and
running heavy uplink udp traffic with higher bandwidth
and doing frequent bgscan.

Cc: stable@kernel.org
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c3dbf26..efdafd2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2261,6 +2261,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	struct ath_softc *sc = hw->priv;
 	int timeout = 200; /* ms */
 	int i, j;
+	bool drain_txq;
 
 	mutex_lock(&sc->mutex);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
@@ -2286,7 +2287,10 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	}
 
 	ath9k_ps_wakeup(sc);
-	if (!ath_drain_all_txq(sc, false))
+	spin_lock_bh(&sc->sc_pcu_lock);
+	drain_txq = ath_drain_all_txq(sc, false);
+	spin_unlock_bh(&sc->sc_pcu_lock);
+	if (!drain_txq)
 		ath_reset(sc, false);
 	ath9k_ps_restore(sc);
 	ieee80211_wake_queues(hw);
-- 
1.7.5

