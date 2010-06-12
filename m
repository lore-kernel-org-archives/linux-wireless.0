Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab0FLEeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 09/24] ath9k_hw: reduce delay on programming INI on AR9003
Date: Sat, 12 Jun 2010 00:33:47 -0400
Message-Id: <1276317242-15540-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All AR9003 devices are PCI-E only, the extra delay here
is not required and only reduces the delay for loading
the initial register values by at least 14ms.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index d5e6b08..27feb08 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -543,15 +543,6 @@ static void ar9003_hw_prog_ini(struct ath_hw *ah,
 		u32 val = INI_RA(iniArr, i, column);
 
 		REG_WRITE(ah, reg, val);
-
-		/*
-		 * Determine if this is a shift register value, and insert the
-		 * configured delay if so.
-		 */
-		if (reg >= 0x16000 && reg < 0x17000
-		    && ah->config.analog_shiftreg)
-			udelay(100);
-
 		DO_DELAY(regWrites);
 	}
 }
-- 
1.6.3.3

