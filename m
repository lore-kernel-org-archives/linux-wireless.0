Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3562 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1J2Ja1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 05:30:27 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linux-wireless@vger.kernel.org
cc: "Julia Lawall" <julia@diku.dk>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Julian Calaby" <julian.calaby@gmail.com>
Subject: [PATCH] brcm80211: smac: eliminate a null pointer dereference
 in dma.c
Date: Sat, 29 Oct 2011 11:30:15 +0200
Message-ID: <1319880615-3000-1-git-send-email-arend@broadcom.com> (sfid-20111029_113030_856482_0107CF00)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Though it's unlikely, di may be null, so we can't dereference
di->dma.dmactrlflags until we've checked it.

Move this de-reference after the check, and adjust the error
message to not require de-referencing di.

This is based upon Julia's original patch:
<1319846297-2985-2-git-send-email-julia@diku.dk>

Reported-by: Julia Lawall <julia@diku.dk>
Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index ae541fb..e286fb4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -358,13 +358,14 @@ static uint nrxdactive(struct dma_info *di, uint h, uint t)
 
 static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 {
-	uint dmactrlflags = di->dma.dmactrlflags;
+	uint dmactrlflags;
 
 	if (di == NULL) {
-		DMA_ERROR(("%s: _dma_ctrlflags: NULL dma handle\n", di->name));
+		DMA_ERROR(("_dma_ctrlflags: NULL dma handle\n"));
 		return 0;
 	}
 
+	dmactrlflags = di->dma.dmactrlflags;
 	dmactrlflags &= ~mask;
 	dmactrlflags |= flags;
 
-- 
1.7.4.1


