Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:64572 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbKPOF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:05:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/19] staging/wilc1000: use NO_SECURITY instead of NO_ENCRYPT
Date: Mon, 16 Nov 2015 15:04:56 +0100
Message-Id: <1447682710-2908925-6-git-send-email-arnd@arndb.de> (sfid-20151116_150732_669494_67EC6450)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
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
index f1e70b225deb..040caa0d0d0b 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -643,7 +643,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_ni
 	if (!wilc_wlan_cfg_set(0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto _fail_;
 
-	c_val[0] = NO_ENCRYPT;
+	c_val[0] = NO_SECURITY; /* NO_ENCRYPT, 0x79 */
 	if (!wilc_wlan_cfg_set(0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
-- 
2.1.0.rc2

