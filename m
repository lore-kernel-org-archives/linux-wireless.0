Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59121 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbaAFLk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:40:58 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 10/15] brcmfmac: only disable clock when brcmf_sdio_bus_init() fails
Date: Mon, 6 Jan 2014 12:40:45 +0100
Message-ID: <1389008450-28529-11-git-send-email-arend@broadcom.com> (sfid-20140106_124132_042511_98AF233A)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The condition to disable the clock at the end of brcmf_sdio_bus_init()
was wrong as the bus state is updated by the calling function. Hence,
the clock was always disabled after brcmf_sdio_bus_init() which was
not the intended behaviour.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 124f5e8..2bf4757 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3630,7 +3630,7 @@ static int brcmf_sdio_bus_init(struct device *dev)
 	}
 
 	/* If we didn't come up, turn off backplane clock */
-	if (bus_if->state != BRCMF_BUS_DATA)
+	if (ret != 0)
 		brcmf_sdio_clkctl(bus, CLK_NONE, false);
 
 exit:
-- 
1.7.10.4

