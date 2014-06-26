Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18412 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbaFZLXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 07:23:55 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/3] ath9k: Increase max listen interval
Date: Thu, 26 Jun 2014 16:54:41 +0530
Message-ID: <1403781882-468-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140626_132358_697786_58A61309)
In-Reply-To: <1403781882-468-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1403781882-468-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Earlier the listen interval is used to decide switching between
operating and off-channels during bgscan and to improve throughput,
the listen interval is reduced to 1. After optimiztion in scan
state machine, listen period is not used for decision making and
hence reverting it back to original value.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 79fdab6..39419ea 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -797,7 +797,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	/* last queue for offchannel */
 	hw->offchannel_tx_hw_queue = hw->queues - 1;
 	hw->max_rates = 4;
-	hw->max_listen_interval = 1;
+	hw->max_listen_interval = 10;
 	hw->max_rate_tries = 10;
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vif);
-- 
2.0.0

