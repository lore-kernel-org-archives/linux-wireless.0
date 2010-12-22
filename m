Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38133 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab0LVNr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 08:47:59 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 05:47:43 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Stable Kernel <stable@kernel.org>
Subject: [PATCH v2 1/2] ath9k_hw: Fix incorrect macversion and macrev checks
Date: Wed, 22 Dec 2010 19:17:17 +0530
Message-ID: <1293025638-3255-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are few places where we are checking for macversion and revsions
before RTC is powered ON. However we are reading the macversion and
revisions only after RTC is powered ON and so both macversion and
revisions are actully zero and this leads to incorrect srev checks.

fix this by reading the macversion and revisisons even before we start
using them. There is no reason why should we delay reading this info
until RTC is powered on as this is just a register information.

Cc: Stable Kernel <stable@kernel.org>
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
v2 -- fixed reading revisions unnecessarily during every reset.

 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4b51ed4..0a0ba80 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -491,6 +491,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (ah->hw_version.devid == AR5416_AR9100_DEVID)
 		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 
+	ath9k_hw_read_revisions(ah);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_err(common, "Couldn't reset chip\n");
 		return -EIO;
@@ -1078,8 +1080,6 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 		return false;
 	}
 
-	ath9k_hw_read_revisions(ah);
-
 	return ath9k_hw_set_reset(ah, ATH9K_RESET_WARM);
 }
 
-- 
1.7.3.4

