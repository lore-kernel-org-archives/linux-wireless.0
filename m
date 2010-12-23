Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59325 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab0LWPhI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 10:37:08 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 07:36:52 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/1] ath9k: spin_lock_bh is not required within tasklet context.
Date: Thu, 23 Dec 2010 21:06:57 +0530
Message-ID: <1293118617-1687-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disabling BH is not required while running from a tasklet context
and so replace spin_lock_bh with just spin_lock.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8a1691d..86bb85a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -599,7 +599,7 @@ void ath9k_tasklet(unsigned long data)
 		return;
 	}
 
-	spin_lock_bh(&sc->sc_pcu_lock);
+	spin_lock(&sc->sc_pcu_lock);
 
 	if (!ath9k_hw_check_alive(ah))
 		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
@@ -643,7 +643,7 @@ void ath9k_tasklet(unsigned long data)
 	/* re-enable hardware interrupt */
 	ath9k_hw_enable_interrupts(ah);
 
-	spin_unlock_bh(&sc->sc_pcu_lock);
+	spin_unlock(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
 }
 
-- 
1.7.3.4

