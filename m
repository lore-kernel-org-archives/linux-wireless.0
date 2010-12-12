Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50819 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab0LLNeq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 08:34:46 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 1/7] ath9k_hw: initialize ah->slottime
Date: Sun, 12 Dec 2010 14:34:31 +0100
Message-Id: <1292160877-50618-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(u32) -1 is not particularly useful as a slottime default, so even though
the ath9k_hw default should never get used, it's better to pick something
sane here.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d44f74e..856a76e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -408,7 +408,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 		AR_STA_ID1_CRPT_MIC_ENABLE |
 		AR_STA_ID1_MCAST_KSRCH;
 	ah->enable_32kHz_clock = DONT_USE_32KHZ;
-	ah->slottime = (u32) -1;
+	ah->slottime = 20;
 	ah->globaltxtimeout = (u32) -1;
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 }
-- 
1.7.3.2

