Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4308 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1IBOA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/12] staging: brcm80211: remove 'default n' from
 Kconfig
Date: Fri, 2 Sep 2011 16:00:32 +0200
Message-ID: <1314972039-27098-6-git-send-email-rvossen@broadcom.com> (sfid-20110902_160104_596222_E60D976B)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Kconfig options are by default not selected so adding the
statement 'default n' to the option is not needed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index 59e9c85..f51e0f1 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -1,10 +1,8 @@
 config BRCMUTIL
 	tristate
-	default n
 
 config BRCMSMAC
 	tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
-	default n
 	depends on PCI
 	depends on WLAN && MAC80211
 	depends on BCMA=n
@@ -20,7 +18,6 @@ config BRCMSMAC
 
 config BRCMFMAC
 	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
-	default n
 	depends on MMC
 	depends on WLAN && CFG80211
 	select BRCMUTIL
@@ -33,7 +30,6 @@ config BRCMFMAC
 
 config BRCMDBG
 	bool "Broadcom driver debug functions"
-	default n
 	depends on BRCMSMAC || BRCMFMAC
 	---help---
 	  Selecting this enables additional code for debug purposes.
-- 
1.7.4.1


