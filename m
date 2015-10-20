Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:61422 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbbJTWsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/19] staging/wilc1000: use NO_SECURITY instead of NO_ENCRYPT
Date: Wed, 21 Oct 2015 00:47:24 +0200
Message-Id: <1445381258-1455986-6-git-send-email-arnd@arndb.de> (sfid-20151021_005138_094972_8920EAD5)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The linux_wlan.c file uses a set of enums from wilc_wlan_if.h,
with the exception of the NO_ENCRYPT that comes from
wilc_wfi_cfgoperations.h. The two sets of enums clearly have
the same intention but are defined a bit different.

To prepare to clean up the ones in wilc_wfi_cfgoperations.h, this
first changes over the only other user.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 50477d70eb24..d3cc255cd91b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -701,7 +701,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto _fail_;
 
-	c_val[0] = NO_ENCRYPT; /* NO_ENCRYPT, 0x79 */
+	c_val[0] = NO_SECURITY; /* NO_ENCRYPT, 0x79 */
 	if (!wilc_wlan_cfg_set(0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
-- 
2.1.0.rc2

