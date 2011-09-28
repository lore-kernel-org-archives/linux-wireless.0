Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50158 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1I1OJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 10:09:00 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k_hw: Fix number of GPIO pins for AR9287/9300
Date: Wed, 28 Sep 2011 17:10:34 +0530
Message-ID: <1317210034-8239-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110928_160905_723634_E66A139D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f2de7ee..e2c62ea 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2153,6 +2153,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->num_gpio_pins = AR9271_NUM_GPIO;
 	else if (AR_DEVID_7010(ah))
 		pCap->num_gpio_pins = AR7010_NUM_GPIO;
+	else if (AR_SREV_9300_20_OR_LATER(ah))
+		pCap->num_gpio_pins = AR9300_NUM_GPIO;
+	else if (AR_SREV_9287_11_OR_LATER(ah))
+		pCap->num_gpio_pins = AR9287_NUM_GPIO;
 	else if (AR_SREV_9285_12_OR_LATER(ah))
 		pCap->num_gpio_pins = AR9285_NUM_GPIO;
 	else if (AR_SREV_9280_20_OR_LATER(ah))
-- 
1.7.0.4

