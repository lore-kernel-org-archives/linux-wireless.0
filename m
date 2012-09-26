Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29743 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab2IZLiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 07:38:09 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3] ath9k: Enable MCI for AR9565
Date: Wed, 26 Sep 2012 17:04:26 +0530
Message-ID: <1348659266-4669-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120926_133814_575151_F35EA773)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |    6 +++---
 drivers/net/wireless/ath/ath9k/gpio.c   |    2 +-
 drivers/net/wireless/ath/ath9k/wow.c    |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index acd4373..4ef610e 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -282,7 +282,7 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 		ath9k_hw_btcoex_enable_2wire(ah);
 		break;
 	case ATH_BTCOEX_CFG_3WIRE:
-		if (AR_SREV_9462(ah)) {
+		if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 			ath9k_hw_btcoex_enable_mci(ah);
 			return;
 		}
@@ -304,7 +304,7 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	int i;
 
 	btcoex_hw->enabled = false;
-	if (AR_SREV_9462(ah)) {
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 		for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
 			REG_WRITE(ah, AR_MCI_COEX_WL_WEIGHTS(i),
@@ -339,7 +339,7 @@ static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
 	const u32 *weight = ar9003_wlan_weights[stomp_type];
 	int i;
 
-	if (AR_SREV_9462(ah)) {
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		if ((stomp_type == ATH_BTCOEX_STOMP_LOW) &&
 		    btcoex->mci.stomp_ftp)
 			stomp_type = ATH_BTCOEX_STOMP_LOW_FTP;
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index bf7d29e..5faa4f7 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -412,7 +412,7 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
 		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_pause(sc);
 		ath9k_hw_btcoex_disable(ah);
-		if (AR_SREV_9462(ah))
+		if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
 			ath_mci_flush_profile(&sc->btcoex.mci);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 44a08eb..a483d51 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -497,7 +497,7 @@ void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
 
 	REG_RMW(ah, AR_PCIE_PM_CTRL, set, clr);
 
-	if (AR_SREV_9462(ah)) {
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		/*
 		 * this is needed to prevent the chip waking up
 		 * the host within 3-4 seconds with certain
-- 
1.7.4.1

