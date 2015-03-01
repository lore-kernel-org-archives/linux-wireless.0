Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36419 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbCAGUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 01:20:23 -0500
Received: from [117.199.133.19] (port=11028 helo=sujith-pixel.localdomain)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YRxEk-002K5A-HM
	for linux-wireless@vger.kernel.org; Sun, 01 Mar 2015 01:20:22 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] ath9k: Fix issues in the main btcoex timer
Date: Sun,  1 Mar 2015 11:53:49 +0530
Message-Id: <1425191029-13667-7-git-send-email-sujith@msujith.org> (sfid-20150301_072032_314165_6C3016F3)
In-Reply-To: <1425191029-13667-1-git-send-email-sujith@msujith.org>
References: <1425191029-13667-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* ath9k_mci_update_rssi() is required only for
  cards that use MCI scheme. Make sure that it
  is not called for 3-wire cards.

* Call ath9k_ps_wakeup() early since register
  accesses are made in ath9k_mci_update_rssi().

* Fix usage of btcoex_lock to handle no_stomp_timer.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 6e22d80..86d46c1 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -202,17 +202,16 @@ static void ath_btcoex_period_timer(unsigned long data)
 	}
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
-	ath9k_mci_update_rssi(sc);
-
 	ath9k_ps_wakeup(sc);
+	spin_lock_bh(&btcoex->btcoex_lock);
 
-	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
-		ath_detect_bt_priority(sc);
-
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
+		ath9k_mci_update_rssi(sc);
 		ath_mci_ftp_adjust(sc);
+	}
 
-	spin_lock_bh(&btcoex->btcoex_lock);
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+		ath_detect_bt_priority(sc);
 
 	stomp_type = btcoex->bt_stomp_type;
 	timer_period = btcoex->btcoex_no_stomp;
@@ -252,9 +251,6 @@ static void ath_btcoex_no_stomp_timer(unsigned long arg)
 	struct ath_softc *sc = (struct ath_softc *)arg;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_btcoex *btcoex = &sc->btcoex;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	ath_dbg(common, BTCOEX, "no stomp timer running\n");
 
 	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&btcoex->btcoex_lock);
-- 
2.3.0

