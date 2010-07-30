Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42331 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760334Ab0G3TCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 15:02:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 4/4] ath9k_hw: fix analog shift register writes on AR9003
Date: Fri, 30 Jul 2010 21:02:12 +0200
Message-Id: <1280516532-42721-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1280516532-42721-3-git-send-email-nbd@openwrt.org>
References: <1280516532-42721-1-git-send-email-nbd@openwrt.org>
 <1280516532-42721-2-git-send-email-nbd@openwrt.org>
 <1280516532-42721-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Writes to the analog shift registers, which are issues by the initval
programming function, require a 100 usec delay (similar to AR9002,
but in a different register range).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index a753a43..a491854 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -542,7 +542,11 @@ static void ar9003_hw_prog_ini(struct ath_hw *ah,
 		u32 reg = INI_RA(iniArr, i, 0);
 		u32 val = INI_RA(iniArr, i, column);
 
-		REG_WRITE(ah, reg, val);
+		if (reg >= 0x16000 && reg < 0x17000)
+			ath9k_hw_analog_shift_regwrite(ah, reg, val);
+		else
+			REG_WRITE(ah, reg, val);
+
 		DO_DELAY(regWrites);
 	}
 }
-- 
1.6.4.2

