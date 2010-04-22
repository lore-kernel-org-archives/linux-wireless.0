Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43127 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723Ab0DVDnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 23:43:53 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 21 Apr 2010 20:43:53 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19407.50655.42188.99474@gargle.gargle.HOWL>
Date: Thu, 22 Apr 2010 09:13:27 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/9] ath9k_htc: Cancel running timers before disabling HW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ec7bcc8..9c9f3e0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1178,6 +1178,13 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 		return;
 	}
 
+	/* Cancel all the running timers/work .. */
+	cancel_work_sync(&priv->ps_work);
+	cancel_delayed_work_sync(&priv->ath9k_ani_work);
+	cancel_delayed_work_sync(&priv->ath9k_aggr_work);
+	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
+	ath9k_led_stop_brightness(priv);
+
 	ath9k_htc_ps_wakeup(priv);
 	htc_stop(priv->htc);
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
@@ -1189,11 +1196,6 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	ath9k_htc_ps_restore(priv);
 	ath9k_htc_setpower(priv, ATH9K_PM_FULL_SLEEP);
 
-	cancel_work_sync(&priv->ps_work);
-	cancel_delayed_work_sync(&priv->ath9k_ani_work);
-	cancel_delayed_work_sync(&priv->ath9k_aggr_work);
-	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
-	ath9k_led_stop_brightness(priv);
 	skb_queue_purge(&priv->tx_queue);
 
 	/* Remove monitor interface here */
-- 
1.7.0.5

