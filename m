Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6407 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbaAFLk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:59 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/15] brcmfmac: enable watchdog when bus initialization is complete
Date: Mon, 6 Jan 2014 12:40:44 +0100
Message-ID: <1389008450-28529-10-git-send-email-arend@broadcom.com> (sfid-20140106_124132_687592_88ECA832)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change condition in brcmf_sdio_wd_timer() function to program
watchdog only when in BRCMF_BUS_DATA state. This avoids watchdog
being active during initialization. During initialization the
SDIO save&restore capability is determined which affect the
bus sleep mechanism used in watchdog thread.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index ae5f040..124f5e8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -4105,7 +4105,7 @@ void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 	}
 
 	/* don't start the wd until fw is loaded */
-	if (bus->sdiodev->bus_if->state == BRCMF_BUS_DOWN)
+	if (bus->sdiodev->bus_if->state != BRCMF_BUS_DATA)
 		return;
 
 	if (wdtick) {
-- 
1.7.10.4

