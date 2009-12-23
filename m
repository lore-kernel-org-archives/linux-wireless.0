Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63412 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbZLWIfg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 03:35:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 00:35:36 -0800
From: vasanth <vasanth@atheros.com>
To: <greg@kroah.com>, <stable@kernel.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 2/2] ath9k_hw: Fix AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB and its shift value in 0x4054
Date: Wed, 23 Dec 2009 13:54:36 +0530
Message-ID: <1261556676-6081-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1261556676-6081-1-git-send-email-vasanth@atheros.com>
References: <1261556676-6081-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit c37919bfe0a5c1bee9a31701a31e05a2f8840936 upstream

The bit value of AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB is wrong, it should
be 0x400 and the number of bits to be right shifted is 10. Having this
wrong value in 0x4054 sometimes affects bt quality on btcoex environment.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index d83b77f..c0d7e65 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -969,10 +969,10 @@ enum {
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

