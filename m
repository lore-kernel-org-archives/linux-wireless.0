Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38134 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab0LVNsG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 08:48:06 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 05:47:50 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Stable Kernel <stable@kernel.org>
Subject: [PATCH v2 2/2] ath9k_hw: read and backup AR_WA register value even before chip reset on.
Date: Wed, 22 Dec 2010 19:17:18 +0530
Message-ID: <1293025638-3255-2-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1293025638-3255-1-git-send-email-senthilkumar@atheros.com>
References: <1293025638-3255-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to read and backup AR_WA register value permanently and reading
this after the chip is awakened results in this register being zeroed out.

This seems to fix the ASPM with L1 enabled issue that we have observed.
The laptop becomes very slow and hangs mostly with ASPM L1 enabled without
this fix.

Cc: Stable Kernel <stable@kernel.org>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0a0ba80..e3cec2b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -493,6 +493,15 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_read_revisions(ah);
 
+	/*
+	 * Read back AR_WA into a permanent copy and set bits 14 and 17.
+	 * We need to do this to avoid RMW of this register. We cannot
+	 * read the reg when chip is asleep.
+	 */
+	ah->WARegVal = REG_READ(ah, AR_WA);
+	ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
+			 AR_WA_ASPM_TIMER_BASED_DISABLE);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_err(common, "Couldn't reset chip\n");
 		return -EIO;
@@ -561,14 +570,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_init_mode_regs(ah);
 
-	/*
-	 * Read back AR_WA into a permanent copy and set bits 14 and 17.
-	 * We need to do this to avoid RMW of this register. We cannot
-	 * read the reg when chip is asleep.
-	 */
-	ah->WARegVal = REG_READ(ah, AR_WA);
-	ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
-			 AR_WA_ASPM_TIMER_BASED_DISABLE);
 
 	if (ah->is_pciexpress)
 		ath9k_hw_configpcipowersave(ah, 0, 0);
-- 
1.7.3.4

