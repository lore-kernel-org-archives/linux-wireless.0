Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:55570
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752561AbaI0VA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 17:00:29 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/2] ath9k: use ah->get_mac_revision for all SoC devices if available
Date: Sat, 27 Sep 2014 22:49:43 +0200
Message-Id: <1411850984-65861-1-git-send-email-nbd@openwrt.org> (sfid-20140927_230032_850235_CE3E1882)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is needed for AR934x as well

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3aed729..cf0128e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -222,31 +222,28 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 {
 	u32 val;
 
+	if (ah->get_mac_revision)
+		ah->hw_version.macRev = ah->get_mac_revision();
+
 	switch (ah->hw_version.devid) {
 	case AR5416_AR9100_DEVID:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9100;
 		break;
 	case AR9300_DEVID_AR9330:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9330;
-		if (ah->get_mac_revision) {
-			ah->hw_version.macRev = ah->get_mac_revision();
-		} else {
+		if (!ah->get_mac_revision) {
 			val = REG_READ(ah, AR_SREV);
 			ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
 		}
 		return;
 	case AR9300_DEVID_AR9340:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9340;
-		val = REG_READ(ah, AR_SREV);
-		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
 		return;
 	case AR9300_DEVID_QCA955X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9550;
 		return;
 	case AR9300_DEVID_AR953X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9531;
-		if (ah->get_mac_revision)
-			ah->hw_version.macRev = ah->get_mac_revision();
 		return;
 	}
 
-- 
2.0.4

