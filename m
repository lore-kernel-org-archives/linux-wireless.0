Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:42417 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754321AbeFRPMM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 11:12:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] zd1211rw: stop using deprecated get_seconds()
Date: Mon, 18 Jun 2018 17:11:15 +0200
Message-Id: <20180618151142.1214422-2-arnd@arndb.de> (sfid-20180618_171439_283063_83F0A68A)
In-Reply-To: <20180618151142.1214422-1-arnd@arndb.de>
References: <20180618151142.1214422-1-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The get_seconds() function is deprecated because of the y2038 overflow.
In zd1211rw we don't even care about the absolute value, so this is
not a problem, but it's equally trivial to change to the non-deprecated
ktime_get_seconds().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/zydas/zd1211rw/zd_chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_chip.c b/drivers/net/wireless/zydas/zd1211rw/zd_chip.c
index 07b94eda9604..dd6a86b899eb 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_chip.c
@@ -1341,7 +1341,7 @@ int zd_chip_control_leds(struct zd_chip *chip, enum led_status status)
 	case ZD_LED_SCANNING:
 		ioreqs[0].value = FW_LINK_OFF;
 		ioreqs[1].value = v[1] & ~other_led;
-		if (get_seconds() % 3 == 0) {
+		if ((u32)ktime_get_seconds() % 3 == 0) {
 			ioreqs[1].value &= ~chip->link_led;
 		} else {
 			ioreqs[1].value |= chip->link_led;
-- 
2.9.0
