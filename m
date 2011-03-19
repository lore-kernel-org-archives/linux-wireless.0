Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52439 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1CSMzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 08:55:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 5/7] ath9k_hw: enable a BlockAck related fixup specific to AR9100
Date: Sat, 19 Mar 2011 13:55:41 +0100
Message-Id: <1300539343-75509-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300539343-75509-4-git-send-email-nbd@openwrt.org>
References: <1300539343-75509-1-git-send-email-nbd@openwrt.org>
 <1300539343-75509-2-git-send-email-nbd@openwrt.org>
 <1300539343-75509-3-git-send-email-nbd@openwrt.org>
 <1300539343-75509-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes interop issues with aggregation in combination with multi-BSSID

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    2 ++
 drivers/net/wireless/ath/ath9k/reg.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b170c45..175c36f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -410,6 +410,8 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->sta_id1_defaults =
 		AR_STA_ID1_CRPT_MIC_ENABLE |
 		AR_STA_ID1_MCAST_KSRCH;
+	if (AR_SREV_9100(ah))
+		ah->sta_id1_defaults |= AR_STA_ID1_AR9100_BA_FIX;
 	ah->enable_32kHz_clock = DONT_USE_32KHZ;
 	ah->slottime = 20;
 	ah->globaltxtimeout = (u32) -1;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 8fa8acf..693d543 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1396,6 +1396,7 @@ enum {
 #define AR_STA_ID1_PCF             0x00100000
 #define AR_STA_ID1_USE_DEFANT      0x00200000
 #define AR_STA_ID1_DEFANT_UPDATE   0x00400000
+#define AR_STA_ID1_AR9100_BA_FIX   0x00400000
 #define AR_STA_ID1_RTS_USE_DEF     0x00800000
 #define AR_STA_ID1_ACKCTS_6MB      0x01000000
 #define AR_STA_ID1_BASE_RATE_11B   0x02000000
-- 
1.7.3.2

