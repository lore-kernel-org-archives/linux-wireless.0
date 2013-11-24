Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48197 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab3KXVED (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 16:04:03 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmsmac: remove dependency on CRC8 and CRC_CCITT
Date: Sun, 24 Nov 2013 22:03:41 +0100
Message-Id: <1385327021-26851-1-git-send-email-hauke@hauke-m.de> (sfid-20131124_220407_349810_D695C0A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no code in brcmsmac that uses a function from CRC8 or
CRC_CCITT any more. Building brcmsmac with these two disabled works
without any problems. This was probably only used by the bus code which
was replaced by bcma some time ago.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index b00a7e9..ce0add3 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -7,8 +7,6 @@ config BRCMSMAC
 	depends on BCMA
 	select BRCMUTIL
 	select FW_LOADER
-	select CRC_CCITT
-	select CRC8
 	select CORDIC
 	---help---
 	  This module adds support for PCIe wireless adapters based on Broadcom
-- 
1.7.10.4

