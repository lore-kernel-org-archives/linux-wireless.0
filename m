Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5768 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1I3GBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 02:01:52 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k_hw: Fix number of GPIO pins for AR9287/9300
Date: Fri, 30 Sep 2011 11:31:27 +0530
Message-ID: <1317362488-4816-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110930_080156_918411_87556AFC)
In-Reply-To: <1317362488-4816-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1317362488-4816-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

this patch fixes the assumption of maximum number of GPIO pins present
in AR9287/AR9300. this fix is essential as we might encounter some
functionality issues involved in accessing the status of GPIO pins which
are all incorrectly assumed to be not within the range of max_num_gpio
of AR9300/AR9287 chipsets

Cc: stable@kernel.org
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

