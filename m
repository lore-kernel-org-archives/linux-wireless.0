Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44641 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbcAOBYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 20:24:36 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 3/5] ath9k: do not reset while BB panic(0x4000409) on ar9561
Date: Fri, 15 Jan 2016 09:23:27 +0800
Message-Id: <1452821009-1156-4-git-send-email-miaoqing@codeaurora.org> (sfid-20160115_022456_089896_27067D87)
In-Reply-To: <1452821009-1156-1-git-send-email-miaoqing@codeaurora.org>
References: <1452821009-1156-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

BB panic(0x4000409) observed while AP enabling/disabling
bursting.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 201425e..abd9646 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -2071,7 +2071,8 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
  *             to be disabled.
  *
  * 0x04000409: Packet stuck on receive.
- *             Full chip reset is required for all chips except AR9340.
+ *             Full chip reset is required for all chips except
+ *	       AR9340, AR9531 and AR9561.
  */
 
 /*
@@ -2100,7 +2101,7 @@ bool ar9003_hw_bb_watchdog_check(struct ath_hw *ah)
 	case 0x04000b09:
 		return true;
 	case 0x04000409:
-		if (AR_SREV_9340(ah) || AR_SREV_9531(ah))
+		if (AR_SREV_9340(ah) || AR_SREV_9531(ah) || AR_SREV_9561(ah))
 			return false;
 		else
 			return true;
-- 
1.9.1

