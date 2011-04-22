Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35961 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1DVGCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 02:02:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 23:02:23 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 3/5] ath9k: optimize the usage of power save wrappers.
Date: Fri, 22 Apr 2011 11:32:10 +0530
Message-ID: <1303452132-5436-3-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
References: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need not wake up the chip even before mutex lock is acquired and also
that it is required only if we are going to drain the txq. So place the
wrappers accordingly and this change is also useful when there are no
pending frames in the txq as we do not wake up the chip unnecessarily.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a8d9009..37b80ac 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2219,9 +2219,7 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	int timeout = 200; /* ms */
 	int i, j;
 
-	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
-
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
 	if (drop)
@@ -2244,15 +2242,15 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 		    goto out;
 	}
 
+	ath9k_ps_wakeup(sc);
 	if (!ath_drain_all_txq(sc, false))
 		ath_reset(sc, false);
-
+	ath9k_ps_restore(sc);
 	ieee80211_wake_queues(hw);
 
 out:
 	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
 	mutex_unlock(&sc->mutex);
-	ath9k_ps_restore(sc);
 }
 
 static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
-- 
1.7.0.4

