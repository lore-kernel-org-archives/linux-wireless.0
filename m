Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2501 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab3KFWHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 17:07:33 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 7/7] brcmsmac: select CONFIG_BCMA when possible
Date: Wed, 6 Nov 2013 23:07:22 +0100
Message-ID: <1383775642-647-8-git-send-email-arend@broadcom.com> (sfid-20131106_230745_734901_CB2E46AC)
In-Reply-To: <1383775642-647-1-git-send-email-arend@broadcom.com>
References: <1383775642-647-1-git-send-email-arend@broadcom.com>
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
 drivers/net/wireless/brcm80211/Kconfig | 3 ++-
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
1.8.1.3


