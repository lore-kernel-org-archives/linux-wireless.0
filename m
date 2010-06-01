Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42268 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab0FAKNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 06:13:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 03:13:50 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.56741.819395.793718@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:45:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/13] ath9k_htc: Fix locking for ps_idle
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ps_idle is protected by the htc_pm_lock mutex.
Use it to protect the variable.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 011d967..5dad5cd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1401,16 +1401,17 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		bool enable_radio = false;
 		bool idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
+		mutex_lock(&priv->htc_pm_lock);
 		if (!idle && priv->ps_idle)
 			enable_radio = true;
-
 		priv->ps_idle = idle;
+		mutex_unlock(&priv->htc_pm_lock);
 
 		if (enable_radio) {
-			ath9k_htc_setpower(priv, ATH9K_PM_AWAKE);
-			ath9k_htc_radio_enable(hw);
 			ath_print(common, ATH_DBG_CONFIG,
 				  "not-idle: enabling radio\n");
+			ath9k_htc_setpower(priv, ATH9K_PM_AWAKE);
+			ath9k_htc_radio_enable(hw);
 		}
 	}
 
@@ -1453,14 +1454,21 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if ((changed & IEEE80211_CONF_CHANGE_IDLE) && priv->ps_idle) {
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		mutex_lock(&priv->htc_pm_lock);
+		if (!priv->ps_idle) {
+			mutex_unlock(&priv->htc_pm_lock);
+			goto out;
+		}
+		mutex_unlock(&priv->htc_pm_lock);
+
 		ath_print(common, ATH_DBG_CONFIG,
 			  "idle: disabling radio\n");
 		ath9k_htc_radio_disable(hw);
 	}
 
+out:
 	mutex_unlock(&priv->mutex);
-
 	return 0;
 }
 
-- 
1.7.1

