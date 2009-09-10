Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZIJHKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 03:10:16 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/7] ath9k: avoid usage of ath9k_hw_setpower() on hw.c
Date: Thu, 10 Sep 2009 03:10:15 -0400
Message-Id: <1252566619-30390-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
References: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_setpower() is a core driver helper with locking
protection. Locking protection should be left to the driver
core, not the hw code. Hardware code no longer contends for
locking when it needs to wake up the chip or put it to sleep.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index bba8cc2..c85c80d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -919,7 +919,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE)) {
+	if (!ath9k_hw_setpower_nolock(ah, ATH9K_PM_AWAKE)) {
 		DPRINTF(ah, ATH_DBG_FATAL, "Couldn't wakeup chip\n");
 		return -EIO;
 	}
@@ -1234,7 +1234,7 @@ void ath9k_hw_detach(struct ath_hw *ah)
 		ath9k_hw_ani_disable(ah);
 
 	ath9k_hw_rf_free(ah);
-	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
+	ath9k_hw_setpower_nolock(ah, ATH9K_PM_FULL_SLEEP);
 	kfree(ah);
 	ah = NULL;
 }
@@ -1791,7 +1791,7 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
 		return false;
 
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
+	if (!ath9k_hw_setpower_nolock(ah, ATH9K_PM_AWAKE))
 		return false;
 
 	ah->chip_fullsleep = false;
@@ -2345,7 +2345,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ah->txchainmask = sc->tx_chainmask;
 	ah->rxchainmask = sc->rx_chainmask;
 
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
+	if (!ath9k_hw_setpower_nolock(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
 	if (curchan)
@@ -3958,7 +3958,7 @@ bool ath9k_hw_phy_disable(struct ath_hw *ah)
 
 bool ath9k_hw_disable(struct ath_hw *ah)
 {
-	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
+	if (!ath9k_hw_setpower_nolock(ah, ATH9K_PM_AWAKE))
 		return false;
 
 	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD);
-- 
1.6.3.3

