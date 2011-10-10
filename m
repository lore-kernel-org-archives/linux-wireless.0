Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1JJFvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 01:51:44 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 09/13] ath9k_hw: Update normal/min noise floor value for AR9480
Date: Mon, 10 Oct 2011 11:21:14 +0530
Message-ID: <1318225878-7283-9-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111010_075149_786734_A07AAE1D)
In-Reply-To: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To improve sensitivity for AR9480, the normal and minimum
noise floor values of both bands are updated.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index ef90ab7..64e9bea 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -325,10 +325,10 @@
 
 #define AR_PHY_RX_OCGAIN        (AR_AGC_BASE + 0x200)
 
-#define AR_PHY_CCA_NOM_VAL_9300_2GHZ          -110
-#define AR_PHY_CCA_NOM_VAL_9300_5GHZ          -115
-#define AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ     -125
-#define AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ     -125
+#define AR_PHY_CCA_NOM_VAL_9300_2GHZ          (AR_SREV_9480(ah) ? -127 : -110)
+#define AR_PHY_CCA_NOM_VAL_9300_5GHZ          (AR_SREV_9480(ah) ? -127 : -115)
+#define AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ     (AR_SREV_9480(ah) ? -127 : -125)
+#define AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ     (AR_SREV_9480(ah) ? -127 : -125)
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -95
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -100
 
-- 
1.7.7

