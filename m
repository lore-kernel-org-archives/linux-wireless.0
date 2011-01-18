Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4695 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1ARNGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 08:06:25 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, br1@einfach.org
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: fix locking in tx_complete_poll_work
Date: Tue, 18 Jan 2011 08:06:43 -0500
Message-Id: <1295356003-1425-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k_reset must be called with sc->lock.  Since the tx queue
watchdog runs in a workqueue and accesses sc, it's appropriate
to just take the lock over the whole function.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 019a74d..09ae4ef 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2294,6 +2294,8 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 	int i;
 	bool needreset = false;
 
+	mutex_lock(&sc->lock);
+
 	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++) {
 		if (sc->txqs[i].setup) {
 			txq = &sc->txqs[i];
@@ -2321,6 +2323,8 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 		ath5k_reset(sc, NULL, true);
 	}
 
+	mutex_unlock(&sc->lock);
+
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
 		msecs_to_jiffies(ATH5K_TX_COMPLETE_POLL_INT));
 }
-- 
1.7.1.1


