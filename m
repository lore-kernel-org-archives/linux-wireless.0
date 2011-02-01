Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61209 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab1BARgZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 12:36:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 09:36:05 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: reserve a beacon slot on beaconing vif addition
Date: Tue, 1 Feb 2011 23:05:36 +0530
Message-ID: <1296581736-3361-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beaconing vif addition is based on max beacon slot
available. So it is better to reserve a beacon slot
on interface addition and let it be configured properly
on bss_info change.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bfc70c1..41b34fc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1420,9 +1420,7 @@ static void ath9k_do_vif_add_setup(struct ieee80211_hw *hw,
 		 * there.
 		 */
 		error = ath_beacon_alloc(sc, vif);
-		if (error)
-			ath9k_reclaim_beacon(sc, vif);
-		else
+		if (!error)
 			ath_beacon_config(sc, vif);
 		ath9k_ps_restore(sc);
 	}
-- 
1.7.4

