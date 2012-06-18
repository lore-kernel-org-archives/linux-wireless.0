Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43191 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2FRNcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 09:32:09 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 4/4] ath9k_hw: fix LNA control on WLAN sleep
Date: Mon, 18 Jun 2012 19:02:40 +0530
Message-ID: <1340026360-18873-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120618_153213_060535_38669F77)
In-Reply-To: <1340026360-18873-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340026360-18873-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When WLAN enter full sleep mode, WLAN HW should send out a LNA_TAKE
message for BT to take control of the shared LNA. Otherwise BT traffic
is completely stopped whenever the wlan interface is moved full sleep
mode.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 867238f..6155837 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1015,9 +1015,14 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 		return;
 
 	if (mci->is_2g) {
-		ar9003_mci_send_2g5g_status(ah, true);
+		if (!force) {
+			ar9003_mci_send_2g5g_status(ah, true);
 
-		REG_SET_BIT(ah, AR_MCI_TX_CTRL,
+			ar9003_mci_send_lna_transfer(ah, true);
+			udelay(5);
+		}
+
+		REG_CLR_BIT(ah, AR_MCI_TX_CTRL,
 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
 		REG_CLR_BIT(ah, AR_PHY_GLB_CONTROL,
 			    AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL);
@@ -1025,6 +1030,11 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
 			ar9003_mci_osla_setup(ah, true);
 	} else {
+		if (!force) {
+			ar9003_mci_send_lna_take(ah, true);
+			udelay(5);
+		}
+
 		REG_SET_BIT(ah, AR_MCI_TX_CTRL,
 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
 		REG_SET_BIT(ah, AR_PHY_GLB_CONTROL,
@@ -1251,6 +1261,9 @@ void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah)
 
 	ath_dbg(common, MCI, "Give LNA and SPDT control to BT\n");
 
+	ar9003_mci_send_lna_take(ah, true);
+	udelay(50);
+
 	REG_SET_BIT(ah, AR_PHY_GLB_CONTROL, AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL);
 	mci->is_2g = false;
 	mci->update_2g5g = true;
-- 
1.7.10.4

