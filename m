Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f176.google.com ([209.85.210.176]:55527 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3CXSZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 14:25:22 -0400
Received: by mail-ia0-f176.google.com with SMTP id i1so4897762iaa.21
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 11:25:22 -0700 (PDT)
MIME-Version: 1.0
From: Robert Shade <robert.shade@gmail.com>
Date: Sun, 24 Mar 2013 14:25:02 -0400
Message-ID: <CAMgrJ3YYZuR2oN9p4jMXvEd22aU+O69Bv-M5uOEO-FUZkdf_MA@mail.gmail.com> (sfid-20130324_192527_089540_DE66AD2C)
Subject: [PATCH] ath9k: Show actual timeout value in failed calibration messages.
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The messages are currently hard coding "1ms", which does not match
the actual timeout being used.
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    9 ++++++---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index c55e5bb..9f58974 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -731,7 +731,8 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah,
struct ath9k_channel *chan)
 		if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
 				  AR_PHY_AGC_CONTROL_CAL, 0, AH_WAIT_TIMEOUT)) {
 			ath_dbg(common, CALIBRATE,
-				"offset calibration failed to complete in 1ms; noisy environment?\n");
+				"offset calibration failed to complete in %d ms; noisy environment?\n",
+				AH_WAIT_TIMEOUT / 1000);
 			return false;
 		}
 		REG_CLR_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
@@ -745,7 +746,8 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah,
struct ath9k_channel *chan)
 	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
 			  0, AH_WAIT_TIMEOUT)) {
 		ath_dbg(common, CALIBRATE,
-			"offset calibration failed to complete in 1ms; noisy environment?\n");
+			"offset calibration failed to complete in %d ms; noisy environment?\n",
+			AH_WAIT_TIMEOUT / 1000);
 		return false;
 	}

@@ -841,7 +843,8 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah,
struct ath9k_channel *chan)
 				   AR_PHY_AGC_CONTROL_CAL,
 				   0, AH_WAIT_TIMEOUT)) {
 			ath_dbg(common, CALIBRATE,
-				"offset calibration failed to complete in 1ms; noisy environment?\n");
+				"offset calibration failed to complete in %d ms; noisy environment?\n",
+				AH_WAIT_TIMEOUT / 1000);
 			return false;
 		}

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index f76c3ca..639ba7d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1126,7 +1126,8 @@ skip_tx_iqcal:
 			ar9003_hw_rtt_disable(ah);

 		ath_dbg(common, CALIBRATE,
-			"offset calibration failed to complete in 1ms; noisy environment?\n");
+			"offset calibration failed to complete in %d ms; noisy environment?\n",
+			AH_WAIT_TIMEOUT / 1000);
 		return false;
 	}

-- 
1.7.1
