Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42881 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893Ab1CWRhj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 13:37:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 10:37:15 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 2/2] ath9k: Fix TX queue stuck issue.
Date: Wed, 23 Mar 2011 23:07:22 +0530
Message-ID: <1300901842-3350-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1300901842-3350-1-git-send-email-senthilkumar@atheros.com>
References: <1300901842-3350-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 86271e460a66003dc1f4cbfd845adafb790b7587 introduced a
regression that caused mac80211 queues in stopped state.

ath_drain_all_txq is called in driver flush which would reset
the stopped flag and the mac80211 queues were never started
after that. iperf traffic is completely stalled due to this issue.

Restart the mac80211 queues in driver flush only if the txqs were
drained.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 115f162..5248257 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2160,6 +2160,8 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	if (!ath_drain_all_txq(sc, false))
 		ath_reset(sc, false);
 
+	ieee80211_wake_queues(hw);
+
 out:
 	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
 	mutex_unlock(&sc->mutex);
-- 
1.7.3.4

