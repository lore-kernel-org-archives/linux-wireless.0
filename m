Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33751 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaABEli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jan 2014 23:41:38 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix regulatory compliance
Date: Thu,  2 Jan 2014 10:06:35 +0530
Message-Id: <1388637395-24963-1-git-send-email-sujith@msujith.org> (sfid-20140102_054140_819272_D408F797)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The maximum permissible values for noise floor in ETSI
and Japan domains have been updated with new EU
regulations for CCA detection. Adjust the values in the
driver accordingly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 5076715..fd090b1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -338,9 +338,8 @@
 #define AR_PHY_CCA_NOM_VAL_9300_5GHZ          -115
 #define AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ     -125
 #define AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ     -125
-#define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -95
-#define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -100
-
+#define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -60
+#define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -60
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_FCC_2GHZ -95
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_FCC_5GHZ -100
 
-- 
1.8.5.2

