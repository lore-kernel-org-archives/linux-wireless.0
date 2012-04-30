Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3447 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab2D3SnR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 14:43:17 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 3.4] brcmfmac: fix a double spin_unlock_irqrestore issue
 in dpc
Date: Mon, 30 Apr 2012 11:43:07 -0700
Message-ID: <1335811387-20541-1-git-send-email-frankyl@broadcom.com> (sfid-20120430_204320_942505_AD63B385)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dpc_tl_lock is not acquired in the error handle code for bus down.
But it's unlocked using spin_unlock_irqrestore after finishing task
list walk down. Grab the lock before breaking the loop to avoid a
double unlock.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index eb3829b..e2b34e1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2637,6 +2637,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 				/* after stopping the bus, exit thread */
 				brcmf_sdbrcm_bus_stop(bus->sdiodev->dev);
 				bus->dpc_tsk = NULL;
+				spin_lock_irqsave(&bus->dpc_tl_lock, flags);
 				break;
 			}
 
-- 
1.7.9.5


