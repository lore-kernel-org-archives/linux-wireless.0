Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:47986 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932263AbeBSXOd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 18:14:33 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 7/8] brcmfmac: change log level for some low-level sdio functions
Date: Tue, 20 Feb 2018 00:14:24 +0100
Message-Id: <1519082065-10128-8-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180220_001451_005772_63C47B01)
In-Reply-To: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reducing the number of trace level messages in sdio code giving
them sdio log level instead.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index aa82336..b94ef3c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1706,7 +1706,7 @@ static int brcmf_sdio_dcmd_resp_wake(struct brcmf_sdio *bus)
 	u8 *buf = NULL, *rbuf;
 	int sdret;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 	if (bus->rxblen)
 		buf = vzalloc(bus->rxblen);
 	if (!buf)
@@ -1809,7 +1809,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 	struct brcmf_sdio_hdrinfo *rd = &bus->cur_read, rd_new;
 	u8 head_read = 0;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Not finished unless we encounter no more frames indication */
 	bus->rxpending = true;
@@ -2344,7 +2344,7 @@ static int brcmf_sdio_tx_ctrlframe(struct brcmf_sdio *bus, u8 *frame, u16 len)
 	struct brcmf_sdio_hdrinfo hd_info = {0};
 	int ret;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	/* Back the pointer to make room for bus header */
 	frame -= bus->tx_hdrlen;
@@ -2520,7 +2520,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	uint framecnt;			/* Temporary counter of tx/rx frames */
 	int err = 0;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(SDIO, "Enter\n");
 
 	sdio_claim_host(bus->sdiodev->func1);
 
@@ -2605,7 +2605,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 
 	/* Would be active due to wake-wlan in gSPI */
 	if (intstatus & I_CHIPACTIVE) {
-		brcmf_dbg(INFO, "Dongle reports CHIPACTIVE\n");
+		brcmf_dbg(SDIO, "Dongle reports CHIPACTIVE\n");
 		intstatus &= ~I_CHIPACTIVE;
 	}
 
-- 
1.9.1
