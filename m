Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12162 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2AGPgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 10:36:12 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<m.sujith@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: fix a comment
Date: Sat, 7 Jan 2012 21:06:02 +0530
Message-ID: <1325950562-6169-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120107_163632_633619_A0E33735)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

also remove an unused macro and a function declaration

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h      |    1 -
 drivers/net/wireless/ath/ath9k/calib.h      |    1 -
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2589b38..2b0bfb8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -46,7 +46,7 @@ static const int m2ThreshExt_off = 127;
  * @chan:
  *
  * This is the function to change channel on single-chip devices, that is
- * all devices after ar9280.
+ * for AR9300 family of chipsets.
  *
  * This function takes the channel value in MHz and sets
  * hardware channel value. Assumes writes have been enabled to analog bus.
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b30e9fc..171ccf7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -679,7 +679,6 @@ void ath9k_deinit_device(struct ath_softc *sc);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath9k_reload_chainmask_settings(struct ath_softc *sc);
 
-void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
 bool ath9k_uses_beacons(int type);
 
 #ifdef CONFIG_ATH9K_PCI
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 05b9dbf..3b33996 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -19,7 +19,6 @@
 
 #include "hw.h"
 
-#define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
 #define NUM_NF_READINGS       6
-- 
1.7.0.4

