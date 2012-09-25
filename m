Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32823 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2IYIWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 04:22:22 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Enable MCI for Aphrodite
Date: Tue, 25 Sep 2012 13:48:40 +0530
Message-ID: <1348561120-3276-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120925_102231_722342_DF88ACC5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |   19 +++++++++++++++----
 drivers/net/wireless/ath/ath9k/gpio.c   |    2 +-
 drivers/net/wireless/ath/ath9k/wow.c    |    2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index acd4373..88c4927 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -51,6 +51,14 @@ static const u32 ar9462_wlan_weights[ATH_BTCOEX_STOMP_MAX]
 	{ 0x01017d01, 0x013b0101, 0x3b3b0101, 0x3b3b013b }, /* STOMP_LOW_FTP */
 };
 
+static const u32 ar9565_wlan_weights[ATH_BTCOEX_STOMP_MAX]
+				    [AR9300_NUM_WLAN_WEIGHTS] = {
+	{ 0x01017d01, 0x7d7d7d01, 0x7d7d7d01, 0x7d7d7d7d }, /* STOMP_ALL */
+	{ 0x01017d01, 0x3b3b3b01, 0x3b3b3b01, 0x3b3b3b3b }, /* STOMP_LOW */
+	{ 0x01017d01, 0x01010101, 0x01010101, 0x01010101 }, /* STOMP_NONE */
+	{ 0x01017d01, 0x013b0101, 0x3b3b0101, 0x3b3b013b }, /* STOMP_LOW_FTP */
+};
+
 void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 {
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
@@ -282,7 +290,7 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 		ath9k_hw_btcoex_enable_2wire(ah);
 		break;
 	case ATH_BTCOEX_CFG_3WIRE:
-		if (AR_SREV_9462(ah)) {
+		if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 			ath9k_hw_btcoex_enable_mci(ah);
 			return;
 		}
@@ -304,7 +312,7 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	int i;
 
 	btcoex_hw->enabled = false;
-	if (AR_SREV_9462(ah)) {
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		ath9k_hw_btcoex_bt_stomp(ah, ATH_BTCOEX_STOMP_NONE);
 		for (i = 0; i < AR9300_NUM_BT_WEIGHTS; i++)
 			REG_WRITE(ah, AR_MCI_COEX_WL_WEIGHTS(i),
@@ -339,11 +347,14 @@ static void ar9003_btcoex_bt_stomp(struct ath_hw *ah,
 	const u32 *weight = ar9003_wlan_weights[stomp_type];
 	int i;
 
-	if (AR_SREV_9462(ah)) {
+	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		if ((stomp_type == ATH_BTCOEX_STOMP_LOW) &&
 		    btcoex->mci.stomp_ftp)
 			stomp_type = ATH_BTCOEX_STOMP_LOW_FTP;
-		weight = ar9462_wlan_weights[stomp_type];
+		if (AR_SREV_9565(ah))
+			weight = ar9565_wlan_weights[stomp_type];
+		else
+			weight = ar9462_wlan_weights[stomp_type];
 	}
 
 	for (i = 0; i < AR9300_NUM_WLAN_WEIGHTS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 45f2422..83a204d 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -402,7 +402,7 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
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

