Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23320 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1HZHLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 03:11:54 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k_hw: Fix init mode register regression
Date: Fri, 26 Aug 2011 12:42:11 +0530
Message-ID: <1314342731-13207-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110826_091158_503646_B285E21B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 172805ad46b78717a738ca5c7908c68f0326d3a9
overwirtes additional clock settings of AR9330 to
all AR9300 chips.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 33edb56..2f35aee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -671,7 +671,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 		REG_WRITE_ARRAY(&ah->iniModesAdditional,
 				modesIndex, regWrites);
 
-	if (AR_SREV_9300(ah))
+	if (AR_SREV_9330(ah))
 		REG_WRITE_ARRAY(&ah->iniModesAdditional, 1, regWrites);
 
 	if (AR_SREV_9340(ah) && !ah->is_clk_25mhz)
-- 
1.7.6.1

