Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:36341 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3C0Pqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 11:46:48 -0400
Received: by mail-ia0-f171.google.com with SMTP id z13so7493649iaz.16
        for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2013 08:46:47 -0700 (PDT)
MIME-Version: 1.0
From: Robert Shade <robert.shade@gmail.com>
Date: Wed, 27 Mar 2013 11:46:27 -0400
Message-ID: <CAMgrJ3YmYsNHknVM3gO_0pewGPHDjS1jrNn_8CwJyJcpw+7+yA@mail.gmail.com> (sfid-20130327_164651_605758_DE72DD9E)
Subject: [PATCH v2] Show actual timeout value in failed calibration messages.
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The messages are currently hard coding "1ms", which does not match
the actual timeout being used.

Signed-off-by: Robert Shade <robert.shade@gmail.com>
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
