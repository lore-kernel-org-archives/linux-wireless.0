Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:59125 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbbBFKbI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 05:31:08 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Kim <dekim@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] brcmfmac: use msecs_to_jiffies for time conversion
Date: Fri,  6 Feb 2015 05:26:45 -0500
Message-Id: <1423218405-17624-1-git-send-email-hofrat@osadl.org> (sfid-20150206_113133_611578_797EFFA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is only an API consolidation and should make things more readable
it replaces var * HZ / 1000 by msecs_to_jiffies(var).

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was only compile tested with x86_64_defconfig + CONFIG_BRCMFMAC=m,
CONFIG_MMC=m, CONFIG_BRCMFMAC_SDIO=y

Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)

 drivers/net/wireless/brcm80211/brcmfmac/sdio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 5e9d208..4f9469b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -3972,7 +3972,7 @@ brcmf_sdio_watchdog(unsigned long data)
 		/* Reschedule the watchdog */
 		if (bus->wd_timer_valid)
 			mod_timer(&bus->timer,
-				  jiffies + BRCMF_WD_POLL_MS * HZ / 1000);
+				  jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS));
 	}
 }
 
@@ -4291,13 +4291,13 @@ void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 			   dynamically changed or in the first instance
 			 */
 			bus->timer.expires =
-				jiffies + BRCMF_WD_POLL_MS * HZ / 1000;
+				jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS);
 			add_timer(&bus->timer);
 
 		} else {
 			/* Re arm the timer, at last watchdog period */
 			mod_timer(&bus->timer,
-				jiffies + BRCMF_WD_POLL_MS * HZ / 1000);
+				jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS));
 		}
 
 		bus->wd_timer_valid = true;
-- 
1.7.10.4

