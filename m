Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1855 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab3K2Ksf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 05:48:35 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 7/7] brcmsmac: select CONFIG_BCMA when possible
Date: Fri, 29 Nov 2013 11:48:19 +0100
Message-ID: <1385722099-5102-8-git-send-email-arend@broadcom.com> (sfid-20131129_114902_708388_38550B58)
In-Reply-To: <1385722099-5102-1-git-send-email-arend@broadcom.com>
References: <1385722099-5102-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac relies BCMA functionality to access the device. This
patch selects CONFIG_BCMA when CONFIG_BCMA_POSSIBLE is set. This
way the user does not need to be select BCMA to make the brcmsmac
driver show up in his menuconfig.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index b00a7e9..d9d85e9 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -4,7 +4,8 @@ config BRCMUTIL
 config BRCMSMAC
 	tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
 	depends on MAC80211
-	depends on BCMA
+	depends on BCMA_POSSIBLE
+	select BCMA
 	select BRCMUTIL
 	select FW_LOADER
 	select CRC_CCITT
-- 
1.7.10.4


