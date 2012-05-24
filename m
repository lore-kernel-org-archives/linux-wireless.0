Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55684 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2EXEEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:04:40 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45849.2540.598464@gargle.gargle.HOWL> (sfid-20120524_060445_121804_75B8069A)
Date: Thu, 24 May 2012 09:33:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 17/22] ath9k_hw: fix BT RF performance
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

When software rfkill is triggered, before put the chip in reset
state, give LNA and SPDT control to BT to make sure BT can have
good RF performance.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c         |    3 +++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 854dff6..8b09a82 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1391,3 +1391,19 @@ u32 ar9003_mci_state(struct ath_hw *ah, u32 state_type, u32 *p_data)
 	return value;
 }
 EXPORT_SYMBOL(ar9003_mci_state);
+
+void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+
+	ath_dbg(common, MCI, "Give LNA and SPDT control to BT\n");
+
+	REG_SET_BIT(ah, AR_PHY_GLB_CONTROL, AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL);
+	mci->is_2g = false;
+	mci->update_2g5g = true;
+	ar9003_mci_send_2g5g_status(ah, true);
+
+	/* Force another 2g5g update at next scanning */
+	mci->update_2g5g = true;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 652ab8c..f4a6a44 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -266,6 +266,7 @@ void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 void ar9003_mci_cleanup(struct ath_hw *ah);
 void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 			      u32 *rx_msg_intr);
+void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah);
 
 /*
  * These functions are used by ath9k_hw.
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 53c5dea..9e8fef2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2734,6 +2734,9 @@ EXPORT_SYMBOL(ath9k_hw_setrxfilter);
 
 bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
+	if (ath9k_hw_mci_is_enabled(ah))
+		ar9003_mci_bt_gain_ctrl(ah);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
 		return false;
 
-- 
1.7.10.2

