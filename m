Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59830 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3LTPS7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 10:18:59 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k_hw: fix gentimer callback without overflow handler
Date: Fri, 20 Dec 2013 16:18:45 +0100
Message-Id: <1387552725-39279-1-git-send-email-nbd@openwrt.org> (sfid-20131220_161903_846495_5BA000C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a gentimer has both the trigger and the overflow bits set, only
mask out the trigger bit if an overflow handler is present.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a4b1ae0..160be02 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3084,14 +3084,14 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 	trigger_mask &= timer_table->timer_mask;
 	thresh_mask &= timer_table->timer_mask;
 
-	trigger_mask &= ~thresh_mask;
-
 	for_each_set_bit(index, &thresh_mask, ARRAY_SIZE(timer_table->timers)) {
 		timer = timer_table->timers[index];
 		if (!timer)
 		    continue;
 		if (!timer->overflow)
 		    continue;
+
+		trigger_mask &= ~BIT(index);
 		timer->overflow(timer->arg);
 	}
 
-- 
1.8.3.4 (Apple Git-47)

