Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58237 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab1BYMBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 07:01:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 04:00:49 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k_hw: Fix pcie_serdes setting for AR9485 1.1 version.
Date: Fri, 25 Feb 2011 17:31:01 +0530
Message-ID: <1298635263-4883-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 6fa3c24..7f5de6e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -78,15 +78,15 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		/* Awake Setting */
 
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-				ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1,
-				ARRAY_SIZE(ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1),
+				ar9485_1_1_pcie_phy_clkreq_disable_L1,
+				ARRAY_SIZE(ar9485_1_1_pcie_phy_clkreq_disable_L1),
 				2);
 
 		/* Sleep Setting */
 
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1,
-				ARRAY_SIZE(ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1),
+				ar9485_1_1_pcie_phy_clkreq_disable_L1,
+				ARRAY_SIZE(ar9485_1_1_pcie_phy_clkreq_disable_L1),
 				2);
 	} else if (AR_SREV_9485(ah)) {
 		/* mac */
-- 
1.6.3.3

