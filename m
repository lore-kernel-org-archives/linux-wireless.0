Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 25/97] ath9k_hw: prevent reset control register zeroing on AR9003 reset
Date: Wed, 14 Apr 2010 23:29:39 -0400
Message-Id: <1271302251-9075-26-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

Also, no need for the udelay(2) on AR9003 hardware.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index bf7a85f..f695437 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1386,9 +1386,11 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 		REG_WRITE(ah, AR_RC, AR_RC_AHB);
 
 	REG_WRITE(ah, AR_RTC_RESET, 0);
-	udelay(2);
 
-	if (!AR_SREV_9100(ah))
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		udelay(2);
+
+	if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 		REG_WRITE(ah, AR_RC, 0);
 
 	REG_WRITE(ah, AR_RTC_RESET, 1);
-- 
1.6.3.3

