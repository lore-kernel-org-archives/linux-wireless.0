Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:20797 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaCTJSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 05:18:12 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/4] brcmfmac: reinit watchdog completion after handling watchdog
Date: Thu, 20 Mar 2014 10:18:01 +0100
Message-ID: <1395307083-31523-3-git-send-email-arend@broadcom.com> (sfid-20140320_101830_353644_F8EF0A09)
In-Reply-To: <1395307083-31523-1-git-send-email-arend@broadcom.com>
References: <1395307083-31523-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The watchdog thread waits on completion that is set from a timer. As
the completion is count based this could mean that on a busy system
the watchdog is handled multiple times with a very short interval.
This is not the intended behaviour. After handling the watchdog it
should wait for the next timer expiry. This is accomplished by
reinitializing the completion.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 859eddd..47a6f39 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3994,6 +3994,7 @@ brcmf_sdio_watchdog_thread(void *data)
 			brcmf_sdio_bus_watchdog(bus);
 			/* Count the tick for reference */
 			bus->sdcnt.tickcnt++;
+			reinit_completion(&bus->watchdog_wait);
 		} else
 			break;
 	}
-- 
1.7.9.5

