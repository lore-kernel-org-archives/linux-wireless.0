Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12898 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZIIKEY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 06:04:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 03:04:28 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 4/4] ath9k: Initialize the priority gpio for BT coex 3-wire
Date: Wed, 9 Sep 2009 15:25:52 +0530
Message-ID: <1252490152-19284-4-git-send-email-vasanth@atheros.com>
In-Reply-To: <1252490152-19284-3-git-send-email-vasanth@atheros.com>
References: <1252490152-19284-1-git-send-email-vasanth@atheros.com>
 <1252490152-19284-2-git-send-email-vasanth@atheros.com>
 <1252490152-19284-3-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, a stupid mistake in the original patch which adds coex 3-wire
support. Bluetooth priority gpio needs to be gpio 7.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c     |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
index f1baf66..297b027 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.h
+++ b/drivers/net/wireless/ath/ath9k/btcoex.h
@@ -19,6 +19,7 @@
 
 #define ATH_WLANACTIVE_GPIO	5
 #define ATH_BTACTIVE_GPIO	6
+#define ATH_BTPRIORITY_GPIO	7
 
 #define ATH_BTCOEX_DEF_BT_PERIOD  45
 #define ATH_BTCOEX_DEF_DUTY_CYCLE 55
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c39693b..b6c6cca 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3691,10 +3691,12 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		btcoex_info->btactive_gpio = ATH_BTACTIVE_GPIO;
 		btcoex_info->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
 
-		if (AR_SREV_9285(ah))
+		if (AR_SREV_9285(ah)) {
 			btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_3WIRE;
-		else
+			btcoex_info->btpriority_gpio = ATH_BTPRIORITY_GPIO;
+		} else {
 			btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_2WIRE;
+		}
 	} else {
 		btcoex_info->btcoex_scheme = ATH_BTCOEX_CFG_NONE;
 	}
-- 
1.5.5.1

