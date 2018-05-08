Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35182 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754296AbeEHIGo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 04:06:44 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: ath: ath9k: Fix a possible data race in ath_chanctx_set_next
Date: Tue,  8 May 2018 16:06:36 +0800
Message-Id: <20180508080636.13827-1-baijiaju1990@gmail.com> (sfid-20180508_100709_725453_E448AF8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The write operation to "sc->next_chan" is protected by
the lock on line 1287, but the read operation to
this data on line 1262 is not protected by the lock.
Thus, there may exist a data race for "sc->next_chan".

To fix this data race, the read operation to "sc->next_chan" 
should be also protected by the lock.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 1b05b5d7a038..ed3cd5523481 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1257,12 +1257,12 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 			"Stopping current chanctx: %d\n",
 			sc->cur_chan->chandef.center_freq1);
 		sc->cur_chan->stopped = true;
-		spin_unlock_bh(&sc->chan_lock);
 
 		if (sc->next_chan == &sc->offchannel.chan) {
 			getrawmonotonic(&ts);
 			measure_time = true;
 		}
+		spin_unlock_bh(&sc->chan_lock);
 
 		ath9k_chanctx_stop_queues(sc, sc->cur_chan);
 		queues_stopped = true;
-- 
2.17.0
