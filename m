Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:55486
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753295AbbFURrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2015 13:47:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k_hw: fix device ID check for AR956x
Date: Sun, 21 Jun 2015 19:47:46 +0200
Message-Id: <1434908866-99327-1-git-send-email-nbd@openwrt.org> (sfid-20150621_194823_577967_49497318)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of the missing return, the macVersion value was being
overwritten with an invalid register read

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5e15e8e..a31a680 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -279,6 +279,7 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 		return;
 	case AR9300_DEVID_QCA956X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9561;
+		return;
 	}
 
 	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
-- 
2.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
