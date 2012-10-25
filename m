Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3957 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2JYLl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 07:41:29 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@vger.kernel.org>, Paul Stewart <pstew@chromium.org>
Subject: [PATCH] ath9k_hw: Enable hw PLL power save for AR9462
Date: Thu, 25 Oct 2012 17:11:31 +0530
Message-ID: <1351165291-8219-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121025_134133_226829_B8AC2729)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reduced the power consumption to half in full and network sleep.

Cc: stable@vger.kernel.org
Cc: Paul Stewart <pstew@chromium.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 1a36fa2..0a6b7a3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -219,10 +219,10 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 
 		/* Awake -> Sleep Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9462_pciephy_pll_on_clkreq_disable_L1_2p0);
+			       ar9462_pciephy_clkreq_disable_L1_2p0);
 		/* Sleep -> Awake Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-			       ar9462_pciephy_pll_on_clkreq_disable_L1_2p0);
+			       ar9462_pciephy_clkreq_disable_L1_2p0);
 
 		/* Fast clock modal settings */
 		INIT_INI_ARRAY(&ah->iniModesFastClock,
-- 
1.8.0

