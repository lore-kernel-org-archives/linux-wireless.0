Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab0DOVjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 10/97] ath9k_hw: skip PLL initialization on AR9003 on Power-On-Reset
Date: Thu, 15 Apr 2010 17:38:15 -0400
Message-Id: <1271367582-992-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not required for the AR9003 family.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 060451f..dd37e90 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2065,7 +2065,8 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 					   ATH9K_RESET_POWER_ON) != true) {
 				return false;
 			}
-			ath9k_hw_init_pll(ah, NULL);
+			if (!AR_SREV_9300_20_OR_LATER(ah))
+				ath9k_hw_init_pll(ah, NULL);
 		}
 		if (AR_SREV_9100(ah))
 			REG_SET_BIT(ah, AR_RTC_RESET,
-- 
1.6.3.3

