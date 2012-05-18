Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60228 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946073Ab2EROHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 10:07:20 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 06/10] ath9k_hw: fix BT RF performance
Date: Fri, 18 May 2012 19:37:29 +0530
Message-ID: <1337350053-15491-6-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120518_160725_367693_A2DA610B)
In-Reply-To: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 4ebe4a2..e31461b 100644
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
index 53c5dea..245dec5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2734,6 +2734,9 @@ EXPORT_SYMBOL(ath9k_hw_setrxfilter);
 
 bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
+	if (AR_SREV_9462(ah))
+		ar9003_mci_bt_gain_ctrl(ah);
+
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
 		return false;
 
-- 
1.7.10.2

