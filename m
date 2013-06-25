Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46671 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3FYU5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 16:57:37 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>, stable@vger.kernel.org,
	#@arrakis.dune.hu, 3.10@arrakis.dune.hu
Subject: [PATCH] rt2x00: rt2800lib: fix default TX power check for RT55xx
Date: Tue, 25 Jun 2013 22:57:29 +0200
Message-Id: <1372193849-21630-1-git-send-email-juhosg@openwrt.org> (sfid-20130625_225741_906996_EAD4B110)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code writes the default_power2 value into the TX field
of the RFCSR50 register, however the condition in the if
statement uses default_power1. Due to this, wrong TX power
value might be written into the register.

Use the correct value in the condition to fix the issue.

Compile tested only.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: stable@vger.kernel.org # 3.10
---
John,

This is for 3.11. Even though the original code is introduced in
3.10-rc2 phase, but it is already too late to fix it in 3.10.

-Gabor
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 25f7dbe..1f80ea5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2392,7 +2392,7 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
-	if (info->default_power1 > power_bound)
+	if (info->default_power2 > power_bound)
 		rt2x00_set_field8(&rfcsr, RFCSR50_TX, power_bound);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR50_TX, info->default_power2);
-- 
1.7.10

