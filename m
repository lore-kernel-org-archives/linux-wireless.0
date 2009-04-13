Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54225 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbZDMQb0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:31:26 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:31:26 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26581.459295.287426@gargle.gargle.HOWL> (sfid-20090413_183129_541286_B23C1AFE)
Date: Mon, 13 Apr 2009 21:57:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/11] ath9k: Remove CHANNEL_CW_INT handling in ath9k_hw_calibrate
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is already handled properly in ath9k_hw_getnf.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 08f6902..a197041 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -871,9 +871,6 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 		ath9k_hw_getnf(ah, chan);
 		ath9k_hw_loadnf(ah, ah->curchan);
 		ath9k_hw_start_nfcal(ah);
-
-		if (chan->channelFlags & CHANNEL_CW_INT)
-			chan->channelFlags &= ~CHANNEL_CW_INT;
 	}
 
 	return iscaldone;
-- 
1.6.2.2

