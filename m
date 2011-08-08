Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3251 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab1HHN7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 81/82] staging: brcm80211: remove target platform
 limitations for drivers
Date: Mon, 8 Aug 2011 15:59:05 +0200
Message-ID: <1312811946-16713-82-git-send-email-arend@broadcom.com> (sfid-20110808_160035_723547_88C6090B)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several issue have been reported building the driver on big endian
systems. Following commits were done on driver Kconfig:

d462039 Staging: brcm80211: disable drivers except for X86 or MIPS platforms
15e5201 Staging: brcm80211: disable drivers for PPC platforms

These problems have been resolved so the added 'depends' lines in
the Kconfig have been removed.

Compile tested it for following architectures:
little endian
	x86
	x86_64
	arm
	mips
big endian
	ppc64
	sparc64
	mips

Reported-by: David S. Miller <davem@davemloft.net>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Greg Kroah-Hartman <gregkh@suse.de>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index 379cf16..f4cf9b2 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -7,7 +7,6 @@ config BRCMSMAC
 	default n
 	depends on PCI
 	depends on WLAN && MAC80211
-	depends on X86 || MIPS
 	select BRCMUTIL
 	select FW_LOADER
 	select CRC_CCITT
@@ -21,7 +20,6 @@ config BRCMFMAC
 	default n
 	depends on MMC
 	depends on WLAN && CFG80211
-	depends on X86 || MIPS
 	select BRCMUTIL
 	select FW_LOADER
 	select WIRELESS_EXT
-- 
1.7.4.1


