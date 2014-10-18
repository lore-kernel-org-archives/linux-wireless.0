Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:49131
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbaJRRCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 13:02:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 10/10] ath9k: use a random MAC address if the EEPROM address is invalid
Date: Sat, 18 Oct 2014 19:02:12 +0200
Message-Id: <1413651732-69783-10-git-send-email-nbd@openwrt.org> (sfid-20141018_190236_547917_DFD6197C)
In-Reply-To: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on OpenWrt patch by Gabor Juhos

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 47f410e..ee9fb52 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/bitops.h>
+#include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 
 #include "hw.h"
@@ -446,8 +447,16 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 		common->macaddr[2 * i] = eeval >> 8;
 		common->macaddr[2 * i + 1] = eeval & 0xff;
 	}
-	if (sum == 0 || sum == 0xffff * 3)
-		return -EADDRNOTAVAIL;
+	if (!is_valid_ether_addr(common->macaddr)) {
+		ath_err(common,
+			"eeprom contains invalid mac address: %pM\n",
+			common->macaddr);
+
+		random_ether_addr(common->macaddr);
+		ath_err(common,
+			"random mac address will be used: %pM\n",
+			common->macaddr);
+	}
 
 	return 0;
 }
-- 
2.0.4

