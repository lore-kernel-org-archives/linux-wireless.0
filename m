Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:10259 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab1A0JP6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 04:15:58 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 01:15:38 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: [PATCH 5/5] ath9k_hw: Update PMU setting to improve ripple issue for AR9485.
Date: Thu, 27 Jan 2011 14:45:11 +0530
Message-ID: <1296119711-4024-5-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1296119711-4024-4-git-send-email-vnatarajan@atheros.com>
References: <1296119711-4024-1-git-send-email-vnatarajan@atheros.com>
 <1296119711-4024-2-git-send-email-vnatarajan@atheros.com>
 <1296119711-4024-3-git-send-email-vnatarajan@atheros.com>
 <1296119711-4024-4-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change from the systems team to update PMU setting for AR9485
version of chipsets.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index a256556..4a92718 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3673,7 +3673,7 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 				return;
 
 			reg_pmu_set = (5 << 1) | (7 << 4) | (1 << 8) |
-				      (7 << 14) | (6 << 17) | (1 << 20) |
+				      (2 << 14) | (6 << 17) | (1 << 20) |
 				      (3 << 24) | (1 << 28);
 
 			REG_WRITE(ah, AR_PHY_PMU1, reg_pmu_set);
-- 
1.6.3.3

