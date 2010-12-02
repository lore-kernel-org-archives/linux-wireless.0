Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59160 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0LBLMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:12:13 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:11:58 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 12/27] ath9k_hw: Find chansel of AR_PHY_65NM_CH0_SYNTH7 from an array for AR9485
Date: Thu, 2 Dec 2010 03:06:56 -0800
Message-ID: <1291288031-3409-13-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index b34a9e9..136e64a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -25,6 +25,24 @@ static const int cycpwrThr1_table[] =
 /* level:  0   1   2   3   4   5   6   7   8  */
 	{ -6, -4, -2,  0,  2,  4,  6,  8 };     /* lvl 0-7, default 3 */
 
+/* Chansel table used by ar9485 */
+static const u32 ar9003_chansel_xtal_40M[] = {
+	0xa0ccbe,
+	0xa12213,
+	0xa17769,
+	0xa1ccbe,
+	0xa22213,
+	0xa27769,
+	0xa2ccbe,
+	0xa32213,
+	0xa37769,
+	0xa3ccbe,
+	0xa42213,
+	0xa47769,
+	0xa4ccbe,
+	0xa5998b,
+};
+
 /*
  * register values to turn OFDM weak signal detection OFF
  */
@@ -75,7 +93,12 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	freq = centers.synth_center;
 
 	if (freq < 4800) {     /* 2 GHz, fractional mode */
-		channelSel = CHANSEL_2G(freq);
+		if (AR_SREV_9485(ah)) {
+			int ichan = ieee80211_frequency_to_channel(freq);
+
+			channelSel = ar9003_chansel_xtal_40M[ichan - 1];
+		} else
+			channelSel = CHANSEL_2G(freq);
 		/* Set to 2G mode */
 		bMode = 1;
 	} else {
-- 
1.7.0.4

