Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28533 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2I3Dd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 23:33:27 -0400
From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20583.48529.795930.408227@gargle.gargle.HOWL> (sfid-20120930_053353_283111_F2447429)
Date: Sun, 30 Sep 2012 09:03:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Fix BT_OP_SCAN usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BT_OP_SCAN is applicable only for pre-MCI WLAN/BT combo chips
and using it for MCI-based cards is incorrect. Fix this by
cleaning up its usage.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 334c98d..bf4fb7d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -216,8 +216,8 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *) data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	enum ath_stomp_type stomp_type;
 	u32 timer_period;
-	bool is_btscan;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
@@ -228,19 +228,28 @@ static void ath_btcoex_period_timer(unsigned long data)
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 	ath9k_ps_wakeup(sc);
+
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
 		ath_detect_bt_priority(sc);
-	is_btscan = test_bit(BT_OP_SCAN, &btcoex->op_flags);
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
 		ath_mci_ftp_adjust(sc);
 
 	spin_lock_bh(&btcoex->btcoex_lock);
 
-	ath9k_hw_btcoex_bt_stomp(ah, is_btscan ? ATH_BTCOEX_STOMP_ALL :
-			      btcoex->bt_stomp_type);
+	stomp_type = btcoex->bt_stomp_type;
+	timer_period = btcoex->btcoex_no_stomp;
+
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI)) {
+		if (test_bit(BT_OP_SCAN, &btcoex->op_flags)) {
+			stomp_type = ATH_BTCOEX_STOMP_ALL;
+			timer_period = btcoex->btscan_no_stomp;
+		}
+	}
 
+	ath9k_hw_btcoex_bt_stomp(ah, stomp_type);
 	ath9k_hw_btcoex_enable(ah);
+
 	spin_unlock_bh(&btcoex->btcoex_lock);
 
 	/*
@@ -252,17 +261,16 @@ static void ath_btcoex_period_timer(unsigned long data)
 		if (btcoex->hw_timer_enabled)
 			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
 
-		timer_period = is_btscan ? btcoex->btscan_no_stomp :
-					   btcoex->btcoex_no_stomp;
 		ath9k_gen_timer_start(ah, btcoex->no_stomp_timer, timer_period,
 				      timer_period * 10);
 		btcoex->hw_timer_enabled = true;
 	}
 
 	ath9k_ps_restore(sc);
+
 skip_hw_wakeup:
-	timer_period = btcoex->btcoex_period;
-	mod_timer(&btcoex->period_timer, jiffies + msecs_to_jiffies(timer_period));
+	mod_timer(&btcoex->period_timer,
+		  jiffies + msecs_to_jiffies(btcoex->btcoex_period));
 }
 
 /*
@@ -282,7 +290,8 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	spin_lock_bh(&btcoex->btcoex_lock);
 
 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW ||
-	    test_bit(BT_OP_SCAN, &btcoex->op_flags))
+	    (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI) &&
+	     test_bit(BT_OP_SCAN, &btcoex->op_flags)))
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 	 else if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_ALL)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
-- 
1.7.12.1

