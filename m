Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19321 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1JGLsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 07:48:32 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 10/14] ath9k_hw: Update normal/min noise floor value for AR9480
Date: Fri, 7 Oct 2011 17:17:15 +0530
Message-ID: <1317988039-28632-10-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111007_134834_511568_D035BFF1)
In-Reply-To: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
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

