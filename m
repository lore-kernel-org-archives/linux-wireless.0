Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33966 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab2LJNDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 08:03:30 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH] ath9k_hw: Fix signal strength / channel noise reporting
Date: Mon, 10 Dec 2012 14:03:17 +0100
Message-Id: <1355144597-43886-1-git-send-email-nbd@openwrt.org> (sfid-20121210_140334_258786_CA37730B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While AR_PHY_CCA_NOM_VAL_* does contain the expected internal noise floor
for a chip measured in clean air, it refers to the lowest expected reading.

Depending on the frequency, this measurement can vary by about 6db, thus
causing a higher reported channel noise and signal strength.

Factor in the 6db offset when converting internal noisefloor to channel noise.

This patch makes the reported values more accurate for all chips without
affecting NF calibration behavior.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/calib.c | 1 +
 drivers/net/wireless/ath/ath9k/calib.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index f3448a0..1e85085 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -69,6 +69,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	if (chan && chan->noisefloor) {
 		s8 delta = chan->noisefloor -
+			   ATH9K_NF_CAL_NOISE_THRESH -
 			   ath9k_hw_get_default_nf(ah, chan);
 		if (delta > 0)
 			noise += delta;
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 1060c19..60dcb6c 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -21,6 +21,9 @@
 
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
+/* Internal noise floor can vary by about 6db depending on the frequency */
+#define ATH9K_NF_CAL_NOISE_THRESH		6
+
 #define NUM_NF_READINGS       6
 #define ATH9K_NF_CAL_HIST_MAX 5
 
-- 
1.7.12.2

