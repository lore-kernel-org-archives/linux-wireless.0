Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25005 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab2ILN35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 09:29:57 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 2/6] ath9k_hw: fix ar9462 selfgen chainmask
Date: Wed, 12 Sep 2012 18:59:20 +0530
Message-ID: <1347456564-8222-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120912_153000_487710_32E2BB8B)
In-Reply-To: <1347456564-8222-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1347456564-8222-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the 9462 is operating in 2G mode and MCI is enabled then
reduce the selfgen chain mask to chain 1. Otherwise poor performance
was reported at short range at Rx side when COEX is enabled.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 1 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index b2e39e8..f6eb43e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1027,6 +1027,7 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 
 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
 			ar9003_mci_osla_setup(ah, true);
+		REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
 	} else {
 		ar9003_mci_send_lna_take(ah, true);
 		udelay(5);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 0d800c6..158b50d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -605,9 +605,6 @@ static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
 		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
-	else if (AR_SREV_9462(ah))
-		/* xxx only when MCI support is enabled */
-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
 	else
 		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
 
-- 
1.7.12

