Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47259 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab0JGPW7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 11:22:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 08:22:51 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_hw: Fix hw reset failure with HTC driver
Date: Thu, 7 Oct 2010 20:58:39 +0530
Message-ID: <1286465319-6285-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commit removed DISABLE_REGWRITE_BUFFER ops. The unnecessary
REGWRITE_BUFFER_FLUSH was not removed properly which is causing failure on
hw reset.

Author: Felix Fietkau <nbd@openwrt.org>
Date:   Tue Oct 5 12:03:42 2010 +0200

    ath9k_hw: clean up register write buffering

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index e578459..8c13479 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -491,8 +491,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	REG_WRITE(ah, AR_DMISC(q),
 		  AR_D_MISC_CW_BKOFF_EN | AR_D_MISC_FRAG_WAIT_EN | 0x2);
 
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	if (qi->tqi_cbrPeriod) {
 		REG_WRITE(ah, AR_QCBRCFG(q),
 			  SM(qi->tqi_cbrPeriod, AR_Q_CBRCFG_INTERVAL) |
@@ -508,8 +506,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			  AR_Q_RDYTIMECFG_EN);
 	}
 
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	REG_WRITE(ah, AR_DCHNTIME(q),
 		  SM(qi->tqi_burstTime, AR_D_CHNTIME_DUR) |
 		  (qi->tqi_burstTime ? AR_D_CHNTIME_EN : 0));
-- 
1.7.3.1

