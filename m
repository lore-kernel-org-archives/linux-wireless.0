Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41487 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166Ab3EWKVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 06:21:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.10 2/3] ath9k_hw: fix host interface reset on AR934x
Date: Thu, 23 May 2013 12:20:55 +0200
Message-Id: <1369304456-74526-2-git-send-email-nbd@openwrt.org> (sfid-20130523_122112_793209_C6A1C692)
In-Reply-To: <1369304456-74526-1-git-send-email-nbd@openwrt.org>
References: <1369304456-74526-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a local bus timeout has been detected, the host interface needs to be
reset to clear the errors. AR934x uses a different synchronous interrupt
bit to indicate this, so the check needs to be fixed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 10 +++++++---
 drivers/net/wireless/ath/ath9k/reg.h |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a263ccc..40331f4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1306,9 +1306,13 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 			AR_RTC_RC_COLD_RESET | AR_RTC_RC_WARM_RESET;
 	} else {
 		tmpReg = REG_READ(ah, AR_INTR_SYNC_CAUSE);
-		if (tmpReg &
-		    (AR_INTR_SYNC_LOCAL_TIMEOUT |
-		     AR_INTR_SYNC_RADM_CPL_TIMEOUT)) {
+		if (AR_SREV_9340(ah))
+			tmpReg &= AR9340_INTR_SYNC_LOCAL_TIMEOUT;
+		else
+			tmpReg &= AR_INTR_SYNC_LOCAL_TIMEOUT |
+				  AR_INTR_SYNC_RADM_CPL_TIMEOUT;
+
+		if (tmpReg) {
 			u32 val;
 			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 5c4ab50..9c056a8 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1007,6 +1007,8 @@ enum {
 				AR_INTR_SYNC_LOCAL_TIMEOUT |
 				AR_INTR_SYNC_MAC_SLEEP_ACCESS),
 
+	AR9340_INTR_SYNC_LOCAL_TIMEOUT = 0x00000010,
+
 	AR_INTR_SYNC_SPURIOUS = 0xFFFFFFFF,
 
 };
-- 
1.8.0.2

