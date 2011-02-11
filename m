Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62839 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab1BKHBw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 02:01:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 23:01:31 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: make use of slot time macros
Date: Fri, 11 Feb 2011 12:31:44 +0530
Message-ID: <1297407704-4029-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Instead of using raw numbers to assign slot time it would be better to
make use of predefined slot time macros

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f9cf815..7834f75 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -411,7 +411,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 		AR_STA_ID1_CRPT_MIC_ENABLE |
 		AR_STA_ID1_MCAST_KSRCH;
 	ah->enable_32kHz_clock = DONT_USE_32KHZ;
-	ah->slottime = 20;
+	ah->slottime = ATH9K_SLOT_TIME_20;
 	ah->globaltxtimeout = (u32) -1;
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d95a576..96755c4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1926,9 +1926,9 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (bss_conf->use_short_slot)
-			slottime = 9;
+			slottime = ATH9K_SLOT_TIME_9;
 		else
-			slottime = 20;
+			slottime = ATH9K_SLOT_TIME_20;
 		if (vif->type == NL80211_IFTYPE_AP) {
 			/*
 			 * Defer update, so that connected stations can adjust
-- 
1.7.0.4

