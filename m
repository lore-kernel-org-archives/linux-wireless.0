Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33627 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2FHRig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:38:36 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 5/9] ath9k_hw: fix incorrect LNA register settings
Date: Fri, 8 Jun 2012 23:09:04 +0530
Message-ID: <1339177148-21672-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120608_193840_396388_885A2792)
In-Reply-To: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a full reset, mci_reset will put LNA update to the setting
for 2G mode. Those registers need to be forced to update when
the channel is in 5G.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   24 +++++++++---------------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c         |    2 +-
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 96a8a5f..5097ed8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1013,38 +1013,32 @@ static void ar9003_mci_queue_unsent_gpm(struct ath_hw *ah, u8 header,
 	}
 }
 
-void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done)
+void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 
-	if (!mci->update_2g5g)
+	if (!mci->update_2g5g && !force)
 		return;
 
 	if (mci->is_2g) {
 		ar9003_mci_send_2g5g_status(ah, true);
-		ar9003_mci_send_lna_transfer(ah, true);
-		udelay(5);
 
-		REG_CLR_BIT(ah, AR_MCI_TX_CTRL,
+		REG_SET_BIT(ah, AR_MCI_TX_CTRL,
 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
 		REG_CLR_BIT(ah, AR_PHY_GLB_CONTROL,
 			    AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL);
 
 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
-			REG_SET_BIT(ah, AR_BTCOEX_CTRL,
-				    AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
+			ar9003_mci_osla_setup(ah, true);
 	} else {
-		ar9003_mci_send_lna_take(ah, true);
-		udelay(5);
-
 		REG_SET_BIT(ah, AR_MCI_TX_CTRL,
 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
 		REG_SET_BIT(ah, AR_PHY_GLB_CONTROL,
 			    AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL);
-		REG_CLR_BIT(ah, AR_BTCOEX_CTRL,
-			    AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
 
-		ar9003_mci_send_2g5g_status(ah, true);
+		ar9003_mci_osla_setup(ah, false);
+		if (!force)
+			ar9003_mci_send_2g5g_status(ah, true);
 	}
 }
 
@@ -1313,7 +1307,7 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 		if (mci->unhalt_bt_gpm)
 			ar9003_mci_send_coex_halt_bt_gpm(ah, false, true);
 
-		ar9003_mci_2g5g_switch(ah, true);
+		ar9003_mci_2g5g_switch(ah, false);
 		break;
 	case MCI_STATE_SET_BT_CAL_START:
 		mci->bt_state = MCI_BT_CAL_START;
@@ -1394,7 +1388,7 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 		mci->query_bt = true;
 		mci->need_flush_btinfo = true;
 		ar9003_mci_send_coex_wlan_channels(ah, true);
-		ar9003_mci_2g5g_switch(ah, true);
+		ar9003_mci_2g5g_switch(ah, false);
 		break;
 	case MCI_STATE_NEED_FTP_STOMP:
 		value = !(mci->config & ATH_MCI_CONFIG_DISABLE_FTP_STOMP);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index b36c885..8ab082e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -278,7 +278,7 @@ void ar9003_mci_stop_bt(struct ath_hw *ah, bool save_fullsleep);
 void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable);
 void ar9003_mci_init_cal_done(struct ath_hw *ah);
 void ar9003_mci_set_full_sleep(struct ath_hw *ah);
-void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool wait_done);
+void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force);
 void ar9003_mci_check_bt(struct ath_hw *ah);
 bool ar9003_mci_start_reset(struct ath_hw *ah, struct ath9k_channel *chan);
 int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e3ccb45..c3bb4a3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1711,7 +1711,7 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	ath9k_hw_start_nfcal(ah, true);
 
 	if (ath9k_hw_mci_is_enabled(ah))
-		ar9003_mci_2g5g_switch(ah, true);
+		ar9003_mci_2g5g_switch(ah, false);
 
 	if (AR_SREV_9271(ah))
 		ar9002_hw_load_ani_reg(ah, chan);
-- 
1.7.10.3

