Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2815 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758346Ab2D1B5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2012 21:57:11 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] brcmfmac: stop releasing sdio host in irq handler
Date: Fri, 27 Apr 2012 18:56:56 -0700
Message-ID: <1335578219-4224-2-git-send-email-frankyl@broadcom.com> (sfid-20120428_035715_123378_D48B80EA)
In-Reply-To: <1335578219-4224-1-git-send-email-frankyl@broadcom.com>
References: <1335578219-4224-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmf_sdbrcm_isr doesn't access to the dongle through SDIO bus.
Stop releasing and claiming host in irq handler to eliminate
any potential risk.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index e925290..ea35020 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -45,11 +45,7 @@ static void brcmf_sdioh_irqhandler(struct sdio_func *func)
 
 	brcmf_dbg(TRACE, "***IRQHandler\n");
 
-	sdio_release_host(func);
-
 	brcmf_sdbrcm_isr(sdiodev->bus);
-
-	sdio_claim_host(func);
 }
 
 /* dummy handler for SDIO function 2 interrupt */
-- 
1.7.9.5


