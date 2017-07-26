Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49594 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbdGZUqu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:46:50 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 10/34] brcmfmac: Rename bcmerror to err
Date: Wed, 26 Jul 2017 21:25:33 +0100
Message-Id: <20170726202557.15632-11-ian@mnementh.co.uk> (sfid-20170726_230043_169906_FD9EC74D)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trivial cleanup of nasty variable name

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 049086f6db97..9d5716d0ad73 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -745,7 +745,7 @@ int
 brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		  u8 *data, uint size)
 {
-	int bcmerror = 0;
+	int err = 0;
 	struct sk_buff *pkt;
 	u32 sdaddr;
 	uint dsize;
@@ -770,8 +770,8 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	/* Do the transfer(s) */
 	while (size) {
 		/* Set the backplane window to include the start address */
-		bcmerror = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
-		if (bcmerror)
+		err = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
+		if (err)
 			break;
 
 		brcmf_dbg(SDIO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
@@ -784,9 +784,9 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		skb_put(pkt, dsize);
 		if (write)
 			memcpy(pkt->data, data, dsize);
-		bcmerror = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_1, write,
-					      sdaddr, pkt);
-		if (bcmerror) {
+		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_1, write, sdaddr,
+					 pkt);
+		if (err) {
 			brcmf_err("membytes transfer failed\n");
 			break;
 		}
@@ -813,7 +813,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	sdio_release_host(sdiodev->func[1]);
 
-	return bcmerror;
+	return err;
 }
 
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, u8 fn)
-- 
2.11.0
