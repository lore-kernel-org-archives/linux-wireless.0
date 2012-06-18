Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24495 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2FRHnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:43:43 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<stable@vger.kernel.org>,
	Rolf Offermanns <rolf.offermanns@gmx.net>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
Date: Mon, 18 Jun 2012 13:13:30 +0530
Message-ID: <1340005410-11256-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120618_094347_579331_B0256110)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

"ath9k: Fix softlockup in AR9485" with commit id
64bc1239c790e051ff677e023435d770d2ffa174 fixed the reported
issue, yet its better to avoid the possible infinite loop
in ar9003_get_pll_sqsum_dvc by having a timeout as suggested
by ath9k maintainers.
http://www.spinics.net/lists/linux-wireless/msg92126.html.
Based on my testing PLL's locking measurement is done in
~200us (2 iterations).

Cc: stable@vger.kernel.org
Cc: Rolf Offermanns <rolf.offermanns@gmx.net>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 784baee..a42c26f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -773,13 +773,25 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 
 u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+	int i = 0;
+
 	REG_CLR_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
 	udelay(100);
 	REG_SET_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
 
-	while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0)
+	while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0) {
+
 		udelay(100);
 
+		if (WARN_ON_ONCE(i >= 100)) {
+			ath_err(common, "PLL4 meaurement not done\n");
+			break;
+		}
+
+		i++;
+	}
+
 	return (REG_READ(ah, PLL3) & SQSUM_DVC_MASK) >> 3;
 }
 EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);
-- 
1.7.0.4

