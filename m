Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61764 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2F3GHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 02:07:49 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 3/5] ath9k: fix fullsleep power consumption when BTCOEX is enabled
Date: Sat, 30 Jun 2012 11:38:47 +0530
Message-ID: <1341036529-10823-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120630_080752_452157_302E4C52)
In-Reply-To: <1341036529-10823-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1341036529-10823-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As soon as the interface brought up, btcoex timer starts running
eventhough the interface is in idle state and WLAN chip is moved
to full sleep mode. There is no point in running btcoex timer when
the wlan interface is in sleep mode and also it might consumes
more power on WLAN idle unassociated state. So lets stop the
btcoex when wlan is idle state.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e4e73f0..6ce0128 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -666,8 +666,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-	ath9k_start_btcoex(sc);
-
 	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
 		common->bus_ops->extn_synch_en(common);
 
@@ -774,8 +772,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* Ensure HW is awake when we try to shut it down. */
 	ath9k_ps_wakeup(sc);
 
-	ath9k_stop_btcoex(sc);
-
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	/* prevent tasklets to enable interrupts once we disable them */
@@ -1139,14 +1135,17 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
 		sc->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
-		if (sc->ps_idle)
+		if (sc->ps_idle) {
 			ath_cancel_work(sc);
-		else
+			ath9k_stop_btcoex(sc);
+		} else {
+			ath9k_start_btcoex(sc);
 			/*
 			 * The chip needs a reset to properly wake up from
 			 * full sleep
 			 */
 			reset_channel = ah->chip_fullsleep;
+		}
 	}
 
 	/*
-- 
1.7.11.1

