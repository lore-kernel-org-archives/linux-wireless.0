Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43480 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab0H0Glz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 02:41:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 26 Aug 2010 23:41:50 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: Enable ANI in associated state only
Date: Fri, 27 Aug 2010 12:09:00 +0530
Message-ID: <1282891140-4170-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While scanning, ANI is triggered unnecessarily where sta is in
unassociated state. And cancelling ani work in ath9k_htc_stop
is not required.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5e318cb..f467207 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1239,7 +1239,6 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 
 	/* Cancel all the running timers/work .. */
 	cancel_work_sync(&priv->ps_work);
-	cancel_delayed_work_sync(&priv->ath9k_ani_work);
 	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
 	ath9k_led_stop_brightness(priv);
 
@@ -1787,7 +1786,8 @@ static void ath9k_htc_sw_scan_start(struct ieee80211_hw *hw)
 	priv->op_flags |= OP_SCANNING;
 	spin_unlock_bh(&priv->beacon_lock);
 	cancel_work_sync(&priv->ps_work);
-	cancel_delayed_work_sync(&priv->ath9k_ani_work);
+	if (priv->op_flags & OP_ASSOCIATED)
+		cancel_delayed_work_sync(&priv->ath9k_ani_work);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -1801,9 +1801,10 @@ static void ath9k_htc_sw_scan_complete(struct ieee80211_hw *hw)
 	priv->op_flags &= ~OP_SCANNING;
 	spin_unlock_bh(&priv->beacon_lock);
 	priv->op_flags |= OP_FULL_RESET;
-	if (priv->op_flags & OP_ASSOCIATED)
+	if (priv->op_flags & OP_ASSOCIATED) {
 		ath9k_htc_beacon_config(priv, priv->vif);
-	ath_start_ani(priv);
+		ath_start_ani(priv);
+	}
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 }
-- 
1.7.2.2

