Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11713 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2JOIMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 04:12:39 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Subject: [PATCH 04/12] ath9k: turn off RXIQ calibration while re-calibrating radio
Date: Mon, 15 Oct 2012 13:25:30 +0530
Message-ID: <1350287738-18687-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_101243_993060_1829BC8D)
In-Reply-To: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bala Shanmugam <bkamatch@qca.qualcomm.com>

TXIQ and RXIQ share the same data path to upload the measurement
result, we should turn off RXIQ calibration while re-calibrating radio

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 6 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index b2b9941..c46d8f1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -750,6 +750,9 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	mci_hw->bt_state = MCI_BT_AWAKE;
 
+	REG_CLR_BIT(ah, AR_PHY_TIMING4,
+		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
+
 	if (caldata) {
 		caldata->done_txiqcal_once = false;
 		caldata->done_txclcal_once = false;
@@ -759,6 +762,9 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
 
+	REG_SET_BIT(ah, AR_PHY_TIMING4,
+		    1 << AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT);
+
 exit:
 	ar9003_mci_enable_interrupt(ah);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 9a48e3d..8f58523 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -32,6 +32,7 @@
 #define AR_PHY_SPUR_REG     (AR_CHAN_BASE + 0x1c)
 #define AR_PHY_RX_IQCAL_CORR_B0    (AR_CHAN_BASE + 0xdc)
 #define AR_PHY_TX_IQCAL_CONTROL_3  (AR_CHAN_BASE + 0xb0)
+#define AR_PHY_TIMING_CONTROL4_DO_GAIN_DC_IQ_CAL_SHIFT 16
 
 #define AR_PHY_TIMING11_SPUR_FREQ_SD    0x3FF00000
 #define AR_PHY_TIMING11_SPUR_FREQ_SD_S  20
-- 
1.7.12.2

