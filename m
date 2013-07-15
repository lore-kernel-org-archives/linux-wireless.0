Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53953 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3GOFhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 01:37:17 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k_hw: Fix multicast search for AR9002 family
Date: Mon, 15 Jul 2013 11:03:57 +0530
Message-Id: <1373866437-13655-1-git-send-email-sujith@msujith.org> (sfid-20130715_073731_717047_2FE229DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The multicast search bit is disabled for the AR9003
family, but this is required for AR9002 too. Fix this in
the INI override routine.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index d1acfe9..1576d58 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -610,7 +610,15 @@ static void ar5008_hw_override_ini(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		val = REG_READ(ah, AR_PCU_MISC_MODE2);
+		/*
+		 * For AR9280 and above, there is a new feature that allows
+		 * Multicast search based on both MAC Address and Key ID.
+		 * By default, this feature is enabled. But since the driver
+		 * is not using this feature, we switch it off; otherwise
+		 * multicast search based on MAC addr only will fail.
+		 */
+		val = REG_READ(ah, AR_PCU_MISC_MODE2) &
+			(~AR_ADHOC_MCAST_KEYID_ENABLE);
 
 		if (!AR_SREV_9271(ah))
 			val &= ~AR_PCU_MISC_MODE2_HWWAR1;
-- 
1.8.3.2

