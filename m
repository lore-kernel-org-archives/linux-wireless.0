Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65532 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351Ab2CORfM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 13:35:12 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH] ath9k: reduce listen time period
Date: Thu, 15 Mar 2012 23:05:28 +0530
Message-ID: <1331832928-3178-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120315_183548_835468_46F23100)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we have downlink traffic alone and the station is going thru
bgscan, the client is out of operating channel for around 1000ms which
is too long. The mac80211 decides when to switch back to oper channel
based on tx queue, bad latency and listen time. As the station does not
have tx traffic, the bgscan can easily affect downlink throughput. By
reducing the listen time, it helps the associated AP to retain the
downstream rate.

Cc: Paul Stewart <pstew@google.com>
Tested-by: Gary Morain <gmorain@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index aa80e0f..4c46c6d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -688,7 +688,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;
-	hw->max_listen_interval = 10;
+	hw->max_listen_interval = 1;
 	hw->max_rate_tries = 10;
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vif);
-- 
1.7.9.4

