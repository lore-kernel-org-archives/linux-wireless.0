Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29285 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2F2GjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 02:39:22 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 4/5] ath9k: fix power consumption on network sleep when BTCOEX is enabled
Date: Fri, 29 Jun 2012 12:10:08 +0530
Message-ID: <1340952009-12223-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120629_083925_278602_15DC54AB)
In-Reply-To: <1340952009-12223-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340952009-12223-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip is waken up for every 45ms in btcoex timer cycle to
for sharing the radio between BT and WLAN. Whenever the wlan
interface is in network sleep mode, do not schedule hw timers.
This could reduce power consumption on idle associated state.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 9ae6a4d..c17168e 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -194,6 +194,16 @@ static void ath_btcoex_period_timer(unsigned long data)
 	struct ath_mci_profile *mci = &btcoex->mci;
 	u32 timer_period;
 	bool is_btscan;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->sc_pm_lock, flags);
+	if (sc->sc_ah->power_mode == ATH9K_PM_NETWORK_SLEEP) {
+		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+		if (btcoex->hw_timer_enabled)
+			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
+		goto skip_hw_wakeup;
+	}
+	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
 	ath9k_ps_wakeup(sc);
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
@@ -232,6 +242,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	}
 
 	ath9k_ps_restore(sc);
+skip_hw_wakeup:
 	timer_period = btcoex->btcoex_period;
 	mod_timer(&btcoex->period_timer, jiffies + msecs_to_jiffies(timer_period));
 }
-- 
1.7.11.1

