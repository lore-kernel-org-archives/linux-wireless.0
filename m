Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40725 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1DZKkR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 06:40:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 03:39:50 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath9k: Use ps wrappers for btcoex logic.
Date: Tue, 26 Apr 2011 10:39:55 +0530
Message-ID: <1303794595-4031-4-git-send-email-vnatarajan@atheros.com> (sfid-20110426_124021_110677_95A5131F)
In-Reply-To: <1303794595-4031-3-git-send-email-vnatarajan@atheros.com>
References: <1303794595-4031-1-git-send-email-vnatarajan@atheros.com>
 <1303794595-4031-2-git-send-email-vnatarajan@atheros.com>
 <1303794595-4031-3-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ps wrappers before accessing hw registers in btcoex.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 3a4ddd1..0349b3a 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -179,6 +179,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 	u32 timer_period;
 	bool is_btscan;
 
+	ath9k_ps_wakeup(sc);
 	ath_detect_bt_priority(sc);
 
 	is_btscan = sc->sc_flags & SC_OP_BT_SCAN;
@@ -201,6 +202,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 		btcoex->hw_timer_enabled = true;
 	}
 
+	ath9k_ps_restore(sc);
 	mod_timer(&btcoex->period_timer, jiffies +
 				  msecs_to_jiffies(ATH_BTCOEX_DEF_BT_PERIOD));
 }
@@ -220,6 +222,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	ath_dbg(common, ATH_DBG_BTCOEX,
 		"no stomp timer running\n");
 
+	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&btcoex->btcoex_lock);
 
 	if (btcoex->bt_stomp_type == ATH_BTCOEX_STOMP_LOW || is_btscan)
@@ -228,6 +231,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_LOW);
 
 	spin_unlock_bh(&btcoex->btcoex_lock);
+	ath9k_ps_restore(sc);
 }
 
 int ath_init_btcoex_timer(struct ath_softc *sc)
-- 
1.7.1

