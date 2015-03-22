Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62458 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbbCVSbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 14:31:47 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3 10/18] ath9k: write buffer related optimisation in ar5008_hw_set_channel_regs
Date: Sun, 22 Mar 2015 19:29:55 +0100
Message-Id: <1427049003-8443-11-git-send-email-linux@rempel-privat.de> (sfid-20150322_193417_213303_BF579229)
In-Reply-To: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
References: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index f273427..6c23d27 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -681,12 +681,13 @@ static void ar5008_hw_set_channel_regs(struct ath_hw *ah,
 			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
 
 	}
+	ENABLE_REGWRITE_BUFFER(ah);
 	REG_WRITE(ah, AR_PHY_TURBO, phymode);
 
+	/* This function do only REG_WRITE, so
+	 * we can include it to REGWRITE_BUFFER. */
 	ath9k_hw_set11nmac2040(ah, chan);
 
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
 	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
 
-- 
1.9.1

