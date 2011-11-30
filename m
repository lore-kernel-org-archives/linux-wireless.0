Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64182 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab1K3FQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 00:16:17 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Russell Hu <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 12/17] ath9k_hw: MCI related changes in chip management
Date: Wed, 30 Nov 2011 10:41:24 +0530
Message-ID: <1322629889-19961-13-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111130_061621_809338_07BFB9A7)
In-Reply-To: <1322629889-19961-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1322629889-19961-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

send halt BT GPM if the chip is in network sleep and BT state
is awake

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   24 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/reg.h |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 662ab7e..ba5734a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1933,6 +1933,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	int status = true, setChip = true;
 	static const char *modes[] = {
 		"AWAKE",
@@ -1950,12 +1951,35 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	switch (mode) {
 	case ATH9K_PM_AWAKE:
 		status = ath9k_hw_set_power_awake(ah, setChip);
+
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+			REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
+
 		break;
 	case ATH9K_PM_FULL_SLEEP:
+
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
+			if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) &&
+				(mci->bt_state != MCI_BT_SLEEP) &&
+				!mci->halted_bt_gpm) {
+				ath_dbg(common, ATH_DBG_MCI, "MCI halt BT GPM"
+						"(full_sleep)");
+				ar9003_mci_send_coex_halt_bt_gpm(ah,
+								 true, true);
+			}
+
+			mci->ready = false;
+			REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
+		}
+
 		ath9k_set_power_sleep(ah, setChip);
 		ah->chip_fullsleep = true;
 		break;
 	case ATH9K_PM_NETWORK_SLEEP:
+
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+			REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
+
 		ath9k_set_power_network_sleep(ah, setChip);
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index ba3672f..6e2f188 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1279,6 +1279,8 @@ enum {
 #define AR_RTC_INTR_MASK \
 	((AR_SREV_9100(ah)) ? (AR_RTC_BASE + 0x0058) : 0x7058)
 
+#define AR_RTC_KEEP_AWAKE	0x7034
+
 /* RTC_DERIVED_* - only for AR9100 */
 
 #define AR_RTC_DERIVED_CLK \
-- 
1.7.0.4

