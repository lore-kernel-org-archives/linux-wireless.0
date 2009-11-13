Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30005 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbZKMJMj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 04:12:39 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 01:12:45 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/2] ath9k_hw: Fix AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB and its shift value in 0x4054
Date: Fri, 13 Nov 2009 14:32:40 +0530
Message-ID: <1258102960-22768-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1258102960-22768-1-git-send-email-vasanth@atheros.com>
References: <1258102960-22768-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bit value of AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB is wrong, it should
be 0x400 and the number of bits to be right shifted is 10. Having this
wrong value in 0x4054 sometimes affects bt quality on btcoex environment.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 061e12c..49ec25f 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -971,10 +971,10 @@ enum {
 #define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_S         4
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF        0x00000080
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF_S      7
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB      0x00000400
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB_S    10
 #define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB        0x00001000
 #define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB_S      12
-#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB      0x00001000
-#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB_S    1
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB         0x00008000
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB_S       15
 #define AR_GPIO_RTC_RESET_OVERRIDE_ENABLE        0x00010000
-- 
1.5.5.1

