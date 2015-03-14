Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56582 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbbCNFyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 01:54:21 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 07/11] ath9k: Disable AIC by default
Date: Sat, 14 Mar 2015 11:27:53 +0530
Message-Id: <1426312677-2064-8-git-send-email-sujith@msujith.org> (sfid-20150314_065438_621559_11710EEA)
In-Reply-To: <1426312677-2064-1-git-send-email-sujith@msujith.org>
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since various MCI messages need to be
handled, along with driver-level support
in upper layers, disable AIC for now.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 6 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.c b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
index 51ecc9b..7bdbc7a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
@@ -40,6 +40,12 @@ static bool ar9003_hw_is_aic_enabled(struct ath_hw *ah)
 {
 	struct ath9k_hw_mci *mci_hw = &ah->btcoex_hw.mci;
 
+	/*
+	 * Disable AIC for now, until we have all the
+	 * HW code and the driver-layer support ready.
+	 */
+	return false;
+
 	if (mci_hw->config & ATH_MCI_CONFIG_DISABLE_AIC)
 		return false;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 20bb5b9..6fa98e5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1364,7 +1364,8 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type)
 		mci->need_flush_btinfo = false;
 		break;
 	case MCI_STATE_AIC_CAL_SINGLE:
-		value = ar9003_aic_calibration_single(ah);
+		if (ath9k_hw_is_aic_enabled(ah))
+			value = ar9003_aic_calibration_single(ah);
 		break;
 	default:
 		break;
-- 
2.3.1

