Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44940 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2JOINg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 04:13:36 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 10/12] ath9k_hw: Set default MCI config for AR9565
Date: Mon, 15 Oct 2012 13:25:36 +0530
Message-ID: <1350287738-18687-11-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_101340_921227_2326321E)
In-Reply-To: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 05d9be5..c90e9bc 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -195,7 +195,7 @@ void ath9k_hw_btcoex_init_mci(struct ath_hw *ah)
 	ah->btcoex_hw.mci.need_flush_btinfo = false;
 	ah->btcoex_hw.mci.wlan_cal_seq = 0;
 	ah->btcoex_hw.mci.wlan_cal_done = 0;
-	ah->btcoex_hw.mci.config = 0x2201;
+	ah->btcoex_hw.mci.config = (AR_SREV_9462(ah)) ? 0x2201 : 0xa4c1;
 }
 EXPORT_SYMBOL(ath9k_hw_btcoex_init_mci);
 
-- 
1.7.12.2

