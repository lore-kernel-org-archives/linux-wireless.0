Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59859 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2GAOXW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 10:23:22 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v3 5/5] ath9k_hw: fix AR9462 2g5g switch on full reset
Date: Sun, 1 Jul 2012 19:53:55 +0530
Message-ID: <1341152635-4840-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120701_162325_275227_8CDDCF9E)
In-Reply-To: <1341152635-4840-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1341152635-4840-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On full reset, mci reset will put LNA update on 2G mode. And
Whenever 2g5g_switch is forced at the end of full reset, lna
update should not be skipped. Not doing so, is affecting WLAN
rx and causing beacon loss when BTCOEX is enabled on AR9462.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 6155837..9a34fca 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1015,12 +1015,9 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 		return;
 
 	if (mci->is_2g) {
-		if (!force) {
-			ar9003_mci_send_2g5g_status(ah, true);
-
-			ar9003_mci_send_lna_transfer(ah, true);
-			udelay(5);
-		}
+		ar9003_mci_send_2g5g_status(ah, true);
+		ar9003_mci_send_lna_transfer(ah, true);
+		udelay(5);
 
 		REG_CLR_BIT(ah, AR_MCI_TX_CTRL,
 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
@@ -1030,10 +1027,8 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
 			ar9003_mci_osla_setup(ah, true);
 	} else {
-		if (!force) {
-			ar9003_mci_send_lna_take(ah, true);
-			udelay(5);
-		}
+		ar9003_mci_send_lna_take(ah, true);
+		udelay(5);
 
 		REG_SET_BIT(ah, AR_MCI_TX_CTRL,
 			    AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
@@ -1041,8 +1036,7 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 			    AR_BTCOEX_CTRL_BT_OWN_SPDT_CTRL);
 
 		ar9003_mci_osla_setup(ah, false);
-		if (!force)
-			ar9003_mci_send_2g5g_status(ah, true);
+		ar9003_mci_send_2g5g_status(ah, true);
 	}
 }
 
-- 
1.7.11.1

