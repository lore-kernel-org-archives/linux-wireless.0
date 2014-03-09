Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37953 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaCIKDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 06:03:12 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k: fix ready time of the multicast buffer queue
Date: Sun,  9 Mar 2014 11:02:54 +0100
Message-Id: <1394359374-37177-1-git-send-email-nbd@openwrt.org> (sfid-20140309_110315_416209_859A7C07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qi->tqi_readyTime is written directly to registers that expect
microseconds as unit instead of TU.
When setting the CABQ ready time, cur_conf->beacon_interval is in TU, so
convert it to microseconds before passing it to ath9k_hw.

This should hopefully fix some Tx DMA issues with buffered multicast
frames in AP mode.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fafacfe..3e7966b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1699,7 +1699,7 @@ int ath_cabq_update(struct ath_softc *sc)
 
 	ath9k_hw_get_txq_props(sc->sc_ah, qnum, &qi);
 
-	qi.tqi_readyTime = (cur_conf->beacon_interval *
+	qi.tqi_readyTime = (TU_TO_USEC(cur_conf->beacon_interval) *
 			    ATH_CABQ_READY_TIME) / 100;
 	ath_txq_update(sc, qnum, &qi);
 
-- 
1.8.3.4 (Apple Git-47)

