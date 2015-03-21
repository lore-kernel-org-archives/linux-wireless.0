Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64229 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbbCUIrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 04:47:36 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 07/18] ath9k: ar9271_hw_pa_cal: use REG_READ_ARRAY
Date: Sat, 21 Mar 2015 09:47:10 +0100
Message-Id: <1426927641-18474-8-git-send-email-linux@rempel-privat.de> (sfid-20150321_094756_732834_5FE8473E)
In-Reply-To: <1426927641-18474-1-git-send-email-linux@rempel-privat.de>
References: <1426927641-18474-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

insted of reading each register separatly
and waste 4ms on each operation, we can
use one shot read.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 62a2314..50fcd34 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -440,8 +440,7 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 		{ AR9285_AN_RF2G3, 0 },
 	};
 
-	for (i = 0; i < ARRAY_SIZE(regList); i++)
-		regList[i][1] = REG_READ(ah, regList[i][0]);
+	REG_READ_ARRAY(ah, regList, ARRAY_SIZE(regList));
 
 	ENABLE_REG_RMW_BUFFER(ah);
 	/* 7834, b1=0 */
-- 
1.9.1

