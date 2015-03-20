Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53965 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbbCTMkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:40:22 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 04/18] ath9k: ar9271_hw_pa_cal: use RMW buffer
Date: Fri, 20 Mar 2015 13:38:44 +0100
Message-Id: <1426855138-6121-5-git-send-email-linux@rempel-privat.de> (sfid-20150320_134027_353233_D603BBDE)
In-Reply-To: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 8d24a73..62a2314 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -436,13 +436,14 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 		{ AR9285_AN_RF2G2, 0 },
 		{ AR9285_AN_TOP2, 0 },
 		{ AR9285_AN_RF2G8, 0 },
-		{ AR9285_AN_RF2G7, 0 } ,
-		{ AR9285_AN_RF2G3, 0 } ,
+		{ AR9285_AN_RF2G7, 0 },
+		{ AR9285_AN_RF2G3, 0 },
 	};
 
 	for (i = 0; i < ARRAY_SIZE(regList); i++)
 		regList[i][1] = REG_READ(ah, regList[i][0]);
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	/* 7834, b1=0 */
 	REG_CLR_BIT(ah, AR9285_AN_RF2G6, 1 << 0);
 	/* 9808, b27=1 */
@@ -476,6 +477,7 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
 	/* 7828, b0-11, ccom=fff */
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9271_AN_RF2G3_CCOMP, 0xfff);
+	REG_RMW_BUFFER_FLUSH(ah);
 
 	/* Set:
 	 * localmode=1,bmode=1,bmoderxtx=1,synthon=1,
@@ -514,10 +516,12 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 	}
 
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	/* 7834, b1=1 */
 	REG_SET_BIT(ah, AR9285_AN_RF2G6, 1 << 0);
 	/* 9808, b27=0 */
 	REG_CLR_BIT(ah, 0x9808, 1 << 27);
+	REG_RMW_BUFFER_FLUSH(ah);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 	for (i = 0; i < ARRAY_SIZE(regList); i++)
-- 
1.9.1

