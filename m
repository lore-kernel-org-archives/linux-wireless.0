Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42042 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab2DLUgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 16:36:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/4] ath9k_hw: add support for 8 AP mode interfaces
Date: Thu, 12 Apr 2012 22:35:56 +0200
Message-Id: <1334262958-90777-2-git-send-email-nbd@openwrt.org> (sfid-20120412_223614_757553_170F0344)
In-Reply-To: <1334262958-90777-1-git-send-email-nbd@openwrt.org>
References: <1334262958-90777-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also tweak beacon response times for better stability with the shorter
timer intervals.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0792d87..52142fa 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -369,7 +369,7 @@ struct ath_vif {
  * number of beacon intervals, the game's up.
  */
 #define BSTUCK_THRESH           	9
-#define	ATH_BCBUF               	4
+#define	ATH_BCBUF               	8
 #define ATH_DEFAULT_BINTVAL     	100 /* TU */
 #define ATH_DEFAULT_BMISS_LIMIT 	10
 #define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6fa8128..373cef6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -388,8 +388,8 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 {
 	int i;
 
-	ah->config.dma_beacon_response_time = 2;
-	ah->config.sw_beacon_response_time = 10;
+	ah->config.dma_beacon_response_time = 1;
+	ah->config.sw_beacon_response_time = 6;
 	ah->config.additional_swba_backoff = 0;
 	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
-- 
1.7.3.2

