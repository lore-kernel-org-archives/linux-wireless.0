Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54422 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1KLOFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 09:05:55 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/3] ath9k: Remove enabling btcoex from stomp type change
Date: Sat, 12 Nov 2011 19:35:46 +0530
Message-ID: <1321106748-13014-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111112_150606_534901_5905F1D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes btcoex_enable from stomp type change and let
it be called from callee functions that makes the code can be
reusable for MCI changes.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c       |    4 ----
 drivers/net/wireless/ath/ath9k/gpio.c         |    2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |    2 ++
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 0122639..f525e91 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -269,8 +269,6 @@ static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
 				"Invalid Stomptype\n");
 		break;
 	}
-
-	ath9k_hw_btcoex_enable(ah);
 }
 
 /*
@@ -302,7 +300,5 @@ void ath9k_hw_btcoex_bt_stomp(struct ath_hw *ah,
 				"Invalid Stomptype\n");
 		break;
 	}
-
-	ath9k_hw_btcoex_enable(ah);
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_bt_stomp);
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 2c279dc..e4ae08e 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -198,6 +198,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	ath9k_hw_btcoex_bt_stomp(ah, is_btscan ? ATH_BTCOEX_STOMP_ALL :
 			      btcoex->bt_stomp_type);
 
+	ath9k_hw_btcoex_enable(ah);
 	spin_unlock_bh(&btcoex->btcoex_lock);
 
 	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
@@ -240,6 +241,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
 
+	ath9k_hw_btcoex_enable(ah);
 	spin_unlock_bh(&btcoex->btcoex_lock);
 	ath9k_ps_restore(sc);
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index e3a02eb..ce606b6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -80,6 +80,7 @@ static void ath_btcoex_period_work(struct work_struct *work)
 	ath9k_hw_btcoex_bt_stomp(priv->ah, is_btscan ? ATH_BTCOEX_STOMP_ALL :
 			btcoex->bt_stomp_type);
 
+	ath9k_hw_btcoex_enable(priv->ah);
 	timer_period = is_btscan ? btcoex->btscan_no_stomp :
 		btcoex->btcoex_no_stomp;
 	ieee80211_queue_delayed_work(priv->hw, &priv->duty_cycle_work,
@@ -108,6 +109,7 @@ static void ath_btcoex_duty_cycle_work(struct work_struct *work)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 	else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
+	ath9k_hw_btcoex_enable(priv->ah);
 }
 
 void ath_htc_init_btcoex_work(struct ath9k_htc_priv *priv)
-- 
1.7.7.3

