Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38719 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271Ab0JOSDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 14:03:39 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 5/6] ath9k: remove a redundant call to ath9k_hw_gettsf32
Date: Fri, 15 Oct 2010 20:03:32 +0200
Message-Id: <1287165813-94331-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287165813-94331-4-git-send-email-nbd@openwrt.org>
References: <1287165813-94331-1-git-send-email-nbd@openwrt.org>
 <1287165813-94331-2-git-send-email-nbd@openwrt.org>
 <1287165813-94331-3-git-send-email-nbd@openwrt.org>
 <1287165813-94331-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the timer_next argument to ath9k_gen_timer_start is behind the tsf value,
tsf + timer_period is used, which is what ath_btcoex_period_timer was setting
it to.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index db9c6fe..6a1a482 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -310,10 +310,8 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 		timer_period = is_btscan ? btcoex->btscan_no_stomp :
 					   btcoex->btcoex_no_stomp;
-		ath9k_gen_timer_start(ah,
-				      btcoex->no_stomp_timer,
-				      (ath9k_hw_gettsf32(ah) +
-				       timer_period), timer_period * 10);
+		ath9k_gen_timer_start(ah, btcoex->no_stomp_timer, 0,
+				      timer_period * 10);
 		btcoex->hw_timer_enabled = true;
 	}
 
-- 
1.7.2.2

