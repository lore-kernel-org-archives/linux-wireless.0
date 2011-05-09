Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51774 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1EINlm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 09:41:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 06:41:13 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/4] ath9k_hw: Change DCU backoff thresh for AR9340
Date: Mon, 9 May 2011 19:11:27 +0530
Message-ID: <1304948489-14585-2-git-send-email-rmanoharan@atheros.com> (sfid-20110509_154148_783448_100BA90F)
In-Reply-To: <1304948489-14585-1-git-send-email-rmanoharan@atheros.com>
References: <1304948489-14585-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By changing DCU backoff threshold for AR9340 to 1, helps to
reduce rx overrurns seen while running bidirectional traffic.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 9cf7a7d..bd6d2b9 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -430,8 +430,13 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		  SM(qi->tqi_shretry, AR_D_RETRY_LIMIT_FR_SH));
 
 	REG_WRITE(ah, AR_QMISC(q), AR_Q_MISC_DCU_EARLY_TERM_REQ);
-	REG_WRITE(ah, AR_DMISC(q),
-		  AR_D_MISC_CW_BKOFF_EN | AR_D_MISC_FRAG_WAIT_EN | 0x2);
+
+	if (AR_SREV_9340(ah))
+		REG_WRITE(ah, AR_DMISC(q),
+			  AR_D_MISC_CW_BKOFF_EN | AR_D_MISC_FRAG_WAIT_EN | 0x1);
+	else
+		REG_WRITE(ah, AR_DMISC(q),
+			  AR_D_MISC_CW_BKOFF_EN | AR_D_MISC_FRAG_WAIT_EN | 0x2);
 
 	if (qi->tqi_cbrPeriod) {
 		REG_WRITE(ah, AR_QCBRCFG(q),
-- 
1.7.5.1

