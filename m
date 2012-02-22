Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6752 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab2BVHLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:11:10 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38149.93097.116880@gargle.gargle.HOWL> (sfid-20120222_081118_316157_B918B4AE)
Date: Wed, 22 Feb 2012 12:41:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 11/26] ath9k_hw: Handle MCI power state using a helper
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |   17 ++---------------
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 1a01788e..a87d4ca1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -365,6 +365,23 @@ static void ar9003_mci_prep_interface(struct ath_hw *ah)
 	REG_WRITE(ah, AR_MCI_INTERRUPT_EN, saved_mci_int_en);
 }
 
+void ar9003_mci_set_full_sleep(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+
+	if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) &&
+	    (mci->bt_state != MCI_BT_SLEEP) &&
+	    !mci->halted_bt_gpm) {
+		ath_dbg(common, MCI,
+			"MCI halt BT GPM (full_sleep)\n");
+		ar9003_mci_send_coex_halt_bt_gpm(ah, true, true);
+	}
+
+	mci->ready = false;
+	REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
+}
+
 void ar9003_mci_disable_interrupt(struct ath_hw *ah)
 {
 	if (!ATH9K_HW_CAP_MCI)
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f4b121f..406ffd0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2076,7 +2076,6 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	int status = true, setChip = true;
 	static const char *modes[] = {
 		"AWAKE",
@@ -2100,20 +2099,8 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 
 		break;
 	case ATH9K_PM_FULL_SLEEP:
-
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI) {
-			if (ar9003_mci_state(ah, MCI_STATE_ENABLE, NULL) &&
-				(mci->bt_state != MCI_BT_SLEEP) &&
-				!mci->halted_bt_gpm) {
-				ath_dbg(common, MCI,
-					"MCI halt BT GPM (full_sleep)\n");
-				ar9003_mci_send_coex_halt_bt_gpm(ah,
-								 true, true);
-			}
-
-			mci->ready = false;
-			REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
-		}
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+			ar9003_mci_set_full_sleep(ah);
 
 		ath9k_set_power_sleep(ah, setChip);
 		ah->chip_fullsleep = true;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a81c4e7..6460af5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1218,6 +1218,7 @@ void ar9003_mci_send_coex_halt_bt_gpm(struct ath_hw *ah, bool halt,
 u32 ar9003_mci_wait_for_gpm(struct ath_hw *ah, u8 gpm_type,
 			    u8 gpm_opcode, int time_out);
 void ar9003_mci_2g5g_changed(struct ath_hw *ah, bool is_2g);
+void ar9003_mci_set_full_sleep(struct ath_hw *ah);
 void ar9003_mci_disable_interrupt(struct ath_hw *ah);
 void ar9003_mci_enable_interrupt(struct ath_hw *ah);
 void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done);
-- 
1.7.9.1

