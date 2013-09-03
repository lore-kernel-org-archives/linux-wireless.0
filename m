Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4011 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab3ICMqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 08:46:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>
Subject: [PATCH] brcmfmac: fix bus interface selection in Kconfig
Date: Tue, 3 Sep 2013 14:46:09 +0200
Message-ID: <1378212369-17166-1-git-send-email-arend@broadcom.com> (sfid-20130903_144626_430457_55A1488F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kernel configuration for the driver could result in
compilation issues as reported by Randy Dunlap. His results
are show below:

"on x86_64:

when
CONFIG_MMC=m
CONFIG_BRCMUTIL=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y

This bool kconfig symbol:

config BRCMFMAC_SDIO
	bool "SDIO bus interface support for FullMAC driver"
	depends on MMC

allows BRCMFMAC_SDIO to be y even when MMC=m.

Is there a reasonable solution to this?

This causes many build errors:

drivers/built-in.o: In function `brcmf_sdio_assert_info':
dhd_sdio.c:(.text+0x39609b): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x3960d9): undefined reference to `sdio_release_host'
drivers/built-in.o: In function `brcmf_sdio_readframes':
dhd_sdio.c:(.text+0x396a62): undefined reference to `sdio_claim_host'
dhd_sdio.c:(.text+0x396a9b): undefined reference to `sdio_release_host'
..."

This patch adds the appropriate logic in Kconfig to resolve
these issues. The solution was provided by Hauke Mehrtens.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi John,

Probably the merge window has already been started after the surpirse release
of 3.11, but this one was reported by Randy Dunlap on linux-next tree and
earlier today by Fenguang Wu. Maybe good to take it in the wireless-next tree.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index fc8a0fa..b00a7e9 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -28,7 +28,7 @@ config BRCMFMAC
 
 config BRCMFMAC_SDIO
 	bool "SDIO bus interface support for FullMAC driver"
-	depends on MMC
+	depends on (MMC = y || MMC = BRCMFMAC)
 	depends on BRCMFMAC
 	select FW_LOADER
 	default y
@@ -39,7 +39,7 @@ config BRCMFMAC_SDIO
 
 config BRCMFMAC_USB
 	bool "USB bus interface support for FullMAC driver"
-	depends on USB
+	depends on (USB = y || USB = BRCMFMAC)
 	depends on BRCMFMAC
 	select FW_LOADER
 	---help---
-- 
1.7.10.4


