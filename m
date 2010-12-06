Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36088 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0LFMbE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 07:31:04 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 04:30:49 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V3 12/27] ath9k_hw: Find chansel of AR_PHY_65NM_CH0_SYNTH7 for AR9485
Date: Mon, 6 Dec 2010 04:27:45 -0800
Message-ID: <1291638480-8950-13-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291638480-8950-1-git-send-email-vasanth@atheros.com>
References: <1291638480-8950-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    5 ++++-
 drivers/net/wireless/ath/ath9k/phy.h        |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index b34a9e9..ae30d98 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -75,7 +75,10 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	freq = centers.synth_center;
 
 	if (freq < 4800) {     /* 2 GHz, fractional mode */
-		channelSel = CHANSEL_2G(freq);
+		if (AR_SREV_9485(ah))
+			channelSel = CHANSEL_2G_9485(freq);
+		else
+			channelSel = CHANSEL_2G(freq);
 		/* Set to 2G mode */
 		bMode = 1;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 17969af..5e3d749 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -19,6 +19,7 @@
 
 #define CHANSEL_DIV		15
 #define CHANSEL_2G(_freq)	(((_freq) * 0x10000) / CHANSEL_DIV)
+#define CHANSEL_2G_9485(_freq)	((((_freq) * 0x10000) - 215) / CHANSEL_DIV)
 #define CHANSEL_5G(_freq)	(((_freq) * 0x8000) / CHANSEL_DIV)
 
 #define AR_PHY_BASE     0x9800
-- 
1.7.0.4

