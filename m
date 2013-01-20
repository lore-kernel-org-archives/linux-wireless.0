Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43082 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab3ATUzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 15:55:32 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	stable@vger.kernel.org
Subject: [PATCH 3.8 1/3] ath9k_hw: fix calibration issues on chainmask that don't include chain 0
Date: Sun, 20 Jan 2013 21:55:20 +0100
Message-Id: <1358715322-46447-1-git-send-email-nbd@openwrt.org> (sfid-20130120_215540_743019_B9C023F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   | 2 +-
 drivers/net/wireless/ath/ath9k/hw.h           | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 8b0d8dc..56317b0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -976,6 +976,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
+
 	if (rtt) {
 		if (!ar9003_hw_rtt_restore(ah, chan))
 			run_rtt_cal = true;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ce19c09..8290edd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -586,7 +586,7 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
 	ath9k_hw_synth_delay(ah, chan, synthDelay);
 }
 
-static void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 {
 	switch (rx) {
 	case 0x5:
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7f1a8e9..9d26fc5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1066,6 +1066,7 @@ void ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain);
 int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
 bool ar9003_is_paprd_enabled(struct ath_hw *ah);
+void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
 
 /* Hardware family op attach helpers */
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah);
-- 
1.8.0.2

