Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21617 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760149AbZIQDyT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:54:19 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:54:23 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.45808.620985.302306@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:24:24 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/12] ath9k: Set default noise floor value for AR9287
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vivek Natarajan <vnatarajan@atheros.com>

The default noise floor was never initialized for
AR9287.This patch helps in reporting the correct
RSSI for this version of chipset.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    2 ++
 drivers/net/wireless/ath/ath9k/calib.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 3234995..439f2c7 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -697,6 +697,8 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah)
 		noise_floor = AR_PHY_CCA_MAX_AR9280_GOOD_VALUE;
 	else if (AR_SREV_9285(ah))
 		noise_floor = AR_PHY_CCA_MAX_AR9285_GOOD_VALUE;
+	else if (AR_SREV_9287(ah))
+		noise_floor = AR_PHY_CCA_MAX_AR9287_GOOD_VALUE;
 	else
 		noise_floor = AR_PHY_CCA_MAX_AR5416_GOOD_VALUE;
 
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 019bcbb..9028ab1 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -28,6 +28,7 @@ extern const struct ath9k_percal_data adc_init_dc_cal;
 #define AR_PHY_CCA_MAX_AR5416_GOOD_VALUE	-85
 #define AR_PHY_CCA_MAX_AR9280_GOOD_VALUE	-112
 #define AR_PHY_CCA_MAX_AR9285_GOOD_VALUE	-118
+#define AR_PHY_CCA_MAX_AR9287_GOOD_VALUE	-118
 #define AR_PHY_CCA_MAX_HIGH_VALUE      		-62
 #define AR_PHY_CCA_MIN_BAD_VALUE       		-140
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
-- 
1.6.4.3

