Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29297 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2F2Gjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 02:39:31 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 5/5] ath9k_hw: fix AR9462 2g5g switch on full reset
Date: Fri, 29 Jun 2012 12:10:09 +0530
Message-ID: <1340952009-12223-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120629_083934_449941_6936B7CB)
In-Reply-To: <1340952009-12223-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340952009-12223-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On full reset, mci reset will put LNA update on 2G mode. And
Whenever 2g5g_switch is forced at the end of full reset, lna
update should not be skipped. Whenever 2g5g switch is enforced,
WLAN need not to wait for the completion of MCI messages. Not
doing so, is affecting WLAN rx and causing beacon loss when
BTCOEX is enabled on AR9462.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 6155837..2daa4c1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1010,17 +1010,15 @@ static void ar9003_mci_queue_unsent_gpm(struct ath_hw *ah, u8 header,
 void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 {
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+	bool wait_done = (mci->update_2g5g || !force);
 
 	if (!mci->update_2g5g && !force)
 		return;
 
 	if (mci->is_2g) {
-		if (!force) {
-			ar9003_mci_send_2g5g_status(ah, true);
-
-			ar9003_mci_send_lna_transfer(ah, true);
-			udelay(5);
-		}
+		ar9003_mci_send_2g5g_status(ah, wait_done);
+		ar9003_mci_send_lna_transfer(ah, wait_done);
+		udelay(5);
 
 		REG_CLR_BIT(ah, AR_MCI_TX_CTRL,
 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
@@ -1030,10 +1028,8 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
 			ar9003_mci_osla_setup(ah, true);
 	} else {
-		if (!force) {
-			ar9003_mci_send_lna_take(ah, true);
-			udelay(5);
-		}
+		ar9003_mci_send_lna_take(ah, wait_done);
+		udelay(5);
 
 		REG_SET_BIT(ah, AR_MCI_TX_CTRL,
 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
@@ -1041,8 +1037,7 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 			    AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL);
 
 		ar9003_mci_osla_setup(ah, false);
-		if (!force)
-			ar9003_mci_send_2g5g_status(ah, true);
+		ar9003_mci_send_2g5g_status(ah, wait_done);
 	}
 }
 
-- 
1.7.11.1

