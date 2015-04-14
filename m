Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:56584 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbbDNSLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 14:11:13 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/10] brcmfmac: process interrupt regardless sdiod state
Date: Tue, 14 Apr 2015 20:10:29 +0200
Message-ID: <1429035033-14076-7-git-send-email-arend@broadcom.com> (sfid-20150414_203417_575562_C34DE8A4)
In-Reply-To: <1429035033-14076-1-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the sdio bus state is not ready to process we abort the
interrupt service routine. This is not wanted as it keeps the
interrupt source active. Better clear the interrupt source.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index cbdda54..bf7a8b1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -3555,10 +3555,6 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 		return;
 	}
 
-	if (bus->sdiodev->state != BRCMF_SDIOD_DATA) {
-		brcmf_err("bus is down. we have nothing to do\n");
-		return;
-	}
 	/* Count the interrupt call */
 	bus->sdcnt.intrcount++;
 	if (in_interrupt())
-- 
1.9.1

