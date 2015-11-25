Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20307 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbKYKcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:32:51 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/11] brcmfmac: no retries on rxglom superframe errors
Date: Wed, 25 Nov 2015 11:32:40 +0100
Message-ID: <1448447567-12189-5-git-send-email-arend@broadcom.com> (sfid-20151125_113313_999426_C722E842)
In-Reply-To: <1448447567-12189-1-git-send-email-arend@broadcom.com>
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Aborting the current read attempt on the superframe also removes the
packet from the pipeline. Retries should not be attempted on the next
packet since it would not be a superframe(either a superframe descriptor
or other data packet) and should not be handled by brcmf_sdio_rxglom

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 30 ++++++----------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 7e74ac3..bf3c281 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -460,7 +460,6 @@ struct brcmf_sdio {
 
 	struct sk_buff *glomd;	/* Packet containing glomming descriptor */
 	struct sk_buff_head glom; /* Packet list for glommed superframe */
-	uint glomerr;		/* Glom packet read errors */
 
 	u8 *rxbuf;		/* Buffer for receiving control packets */
 	uint rxblen;		/* Allocated length of rxbuf */
@@ -1654,20 +1653,15 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->sdcnt.f2rxdata++;
 
-		/* On failure, kill the superframe, allow a couple retries */
+		/* On failure, kill the superframe */
 		if (errcode < 0) {
 			brcmf_err("glom read of %d bytes failed: %d\n",
 				  dlen, errcode);
 
 			sdio_claim_host(bus->sdiodev->func[1]);
-			if (bus->glomerr++ < 3) {
-				brcmf_sdio_rxfail(bus, true, true);
-			} else {
-				bus->glomerr = 0;
-				brcmf_sdio_rxfail(bus, true, false);
-				bus->sdcnt.rxglomfail++;
-				brcmf_sdio_free_glom(bus);
-			}
+			brcmf_sdio_rxfail(bus, true, false);
+			bus->sdcnt.rxglomfail++;
+			brcmf_sdio_free_glom(bus);
 			sdio_release_host(bus->sdiodev->func[1]);
 			return 0;
 		}
@@ -1708,19 +1702,11 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 		}
 
 		if (errcode) {
-			/* Terminate frame on error, request
-				 a couple retries */
+			/* Terminate frame on error */
 			sdio_claim_host(bus->sdiodev->func[1]);
-			if (bus->glomerr++ < 3) {
-				/* Restore superframe header space */
-				skb_push(pfirst, sfdoff);
-				brcmf_sdio_rxfail(bus, true, true);
-			} else {
-				bus->glomerr = 0;
-				brcmf_sdio_rxfail(bus, true, false);
-				bus->sdcnt.rxglomfail++;
-				brcmf_sdio_free_glom(bus);
-			}
+			brcmf_sdio_rxfail(bus, true, false);
+			bus->sdcnt.rxglomfail++;
+			brcmf_sdio_free_glom(bus);
 			sdio_release_host(bus->sdiodev->func[1]);
 			bus->cur_read.len = 0;
 			return 0;
-- 
1.9.1

