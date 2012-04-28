Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4504 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776Ab2D1B5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 21:57:15 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] brcmfmac: check bus state for status
Date: Fri, 27 Apr 2012 18:56:57 -0700
Message-ID: <1335578219-4224-3-git-send-email-frankyl@broadcom.com> (sfid-20120428_035722_540146_83A36BEB)
In-Reply-To: <1335578219-4224-1-git-send-email-frankyl@broadcom.com>
References: <1335578219-4224-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bus state should be the correct flag for bus status. Use it instead
of result from previous function call for backplane clock switch.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 12d9dc9..46fc16f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3508,7 +3508,7 @@ static int brcmf_sdbrcm_bus_init(struct device *dev)
 			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
 	/* If we didn't come up, turn off backplane clock */
-	if (!ret)
+	if (bus_if->state != BRCMF_BUS_DATA)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 
 exit:
-- 
1.7.9.5


