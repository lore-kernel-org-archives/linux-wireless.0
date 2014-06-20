Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32599 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbaFTRQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 13:16:57 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k: Fix build error in ath_reset_internal
Date: Fri, 20 Jun 2014 22:47:49 +0530
Message-ID: <1403284669-5254-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140620_191701_908561_28176A11)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath9k/main.c:299 ath_reset_internal()
error: we previously assumed 'hchan' could be null (see line 293)

Cc: Felix Fietkau <nbd@openwrt.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cf21652..83cb39e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -314,11 +314,9 @@ int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 	if (!ath_prepare_reset(sc))
 		fastcc = false;
 
-	if (hchan) {
-		spin_lock_bh(&sc->chan_lock);
-		sc->cur_chandef = sc->cur_chan->chandef;
-		spin_unlock_bh(&sc->chan_lock);
-	}
+	spin_lock_bh(&sc->chan_lock);
+	sc->cur_chandef = sc->cur_chan->chandef;
+	spin_unlock_bh(&sc->chan_lock);
 
 	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
 		hchan->channel, IS_CHAN_HT40(hchan), fastcc);
-- 
2.0.0

