Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42408 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab0LKXve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 18:51:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 7/8] ath9k_hw: remove ah->beacon_interval
Date: Sun, 12 Dec 2010 00:51:13 +0100
Message-Id: <1292111474-70939-7-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292111474-70939-6-git-send-email-nbd@openwrt.org>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
 <1292111474-70939-2-git-send-email-nbd@openwrt.org>
 <1292111474-70939-3-git-send-email-nbd@openwrt.org>
 <1292111474-70939-4-git-send-email-nbd@openwrt.org>
 <1292111474-70939-5-git-send-email-nbd@openwrt.org>
 <1292111474-70939-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ---
 drivers/net/wireless/ath/ath9k/hw.h |    1 -
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 06028e3..d44f74e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -407,7 +407,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->sta_id1_defaults =
 		AR_STA_ID1_CRPT_MIC_ENABLE |
 		AR_STA_ID1_MCAST_KSRCH;
-	ah->beacon_interval = 100;
 	ah->enable_32kHz_clock = DONT_USE_32KHZ;
 	ah->slottime = (u32) -1;
 	ah->globaltxtimeout = (u32) -1;
@@ -1628,8 +1627,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 {
 	int flags = 0;
 
-	ah->beacon_interval = beacon_period;
-
 	ENABLE_REGWRITE_BUFFER(ah);
 
 	switch (ah->opmode) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e99b395..0db0ef6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -764,7 +764,6 @@ struct ath_hw {
 	u8 txpower_limit;
 	int16_t txpower_indexoffset;
 	int coverage_class;
-	u32 beacon_interval;
 	u32 slottime;
 	u32 globaltxtimeout;
 
-- 
1.7.3.2

