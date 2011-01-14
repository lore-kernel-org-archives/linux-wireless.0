Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43264 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1ANTcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 14:32:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 11:31:50 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: preserve caldata history buffer across scanning
Date: Sat, 15 Jan 2011 01:01:22 +0530
Message-ID: <1295033482-12257-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

caldata's channel info is never filled with operating channel
info which is causing the operating channel's noise floor
history buffer is reset to default nf during channel change.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index b68a1ac..b4a92a4 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -382,9 +382,8 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 	s16 default_nf;
 	int i, j;
 
-	if (!ah->caldata)
-		return;
-
+	ah->caldata->channel = chan->channel;
+	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
-- 
1.7.3.5

