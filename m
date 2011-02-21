Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab1BULhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 06:37:19 -0500
Received: by iyb26 with SMTP id 26so620061iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 03:37:18 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19810.20072.555575.712274@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 17:07:12 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k_hw: Fix power on reset
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Commit "ath9k_hw: add an extra delay when reseting AR_RTC_RESET"
added an extra udelay to the reset routine. As the required
delay is already present, remove this.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f9cf815..9a34381 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1100,7 +1100,6 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 		REG_WRITE(ah, AR_RC, AR_RC_AHB);
 
 	REG_WRITE(ah, AR_RTC_RESET, 0);
-	udelay(2);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
-- 
1.7.4.1

