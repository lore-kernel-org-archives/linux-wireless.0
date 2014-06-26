Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63486 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbaFZLXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 07:23:49 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/3] ath9k: Cache beacon config after association
Date: Thu, 26 Jun 2014 16:54:40 +0530
Message-ID: <1403781882-468-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140626_132353_926905_59AB1ACC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon configurations are not cached properly after the station
associates with AP. Not handling BEACON_INFO, is failing to update
dtim period and also it is causing below warning message.

WARNING: CPU: 1 PID: 0 at drivers/net/wireless/ath/ath9k/recv.c:548
ath_rx_tasklet+0xc89/0xca0 [ath9k]()
 Call Trace:
  [<c14669c9>] dump_stack+0x48/0x69
  [<c104f1a2>] warn_slowpath_common+0x82/0xa0
  [<fd38c2f9>] ? ath_rx_tasklet+0xc89/0xca0 [ath9k]
  [<fd38c2f9>] ? ath_rx_tasklet+0xc89/0xca0 [ath9k]

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f5727c7..e6ac8d2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1787,7 +1787,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
-	    (changed & BSS_CHANGED_BEACON_INT)) {
+	    (changed & BSS_CHANGED_BEACON_INT) ||
+	    (changed & BSS_CHANGED_BEACON_INFO)) {
 		if (changed & BSS_CHANGED_BEACON_ENABLED)
 			ath9k_calculate_summary_state(sc, avp->chanctx);
 		ath9k_beacon_config(sc, vif, changed);
-- 
2.0.0

