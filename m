Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64120 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab1G2MJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:09:24 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH v2 10/13] ath9k_hw: update PMU to improve ripple issue for AR9485
Date: Fri, 29 Jul 2011 17:38:17 +0530
Message-ID: <1311941300-2590-10-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_140927_602321_666F8F9D)
In-Reply-To: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit ebefce3d13f8b5a871337ff7c3821ee140c1ea8a failed
to set proper PMU value to address ripple issue for AR9485.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 9257afd..c1ecb99 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3861,7 +3861,7 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 				}
 			} else {
 				reg_pmu_set = (5 << 1) | (7 << 4) |
-					      (1 << 8) | (2 << 14) |
+					      (2 << 8) | (2 << 14) |
 					      (6 << 17) | (1 << 20) |
 					      (3 << 24) | (1 << 28);
 			}
-- 
1.7.6

