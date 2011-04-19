Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57271 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab1DSN7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:38 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 06:59:12 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 16/22] ath9k_hw: Enable byte Tx/Rx data swap for AR9340
Date: Tue, 19 Apr 2011 19:29:14 +0530
Message-ID: <1303221560-25139-17-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 08e0aa9..9df2fe8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1533,7 +1533,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 				REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
 		}
 #ifdef __BIG_ENDIAN
-                else
+		else if (AR_SREV_9340(ah))
+			REG_RMW(ah, AR_CFG, AR_CFG_SWRB | AR_CFG_SWTB, 0);
+		else
 			REG_WRITE(ah, AR_CFG, AR_CFG_SWTD | AR_CFG_SWRD);
 #endif
 	}
-- 
1.7.0.4

