Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:58150 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933834AbdGSTLE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:11:04 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 10/34] brcmfmac: Rename bcmerror to err
Date: Wed, 19 Jul 2017 20:07:58 +0100
Message-Id: <20170719190822.10857-11-ian@mnementh.co.uk> (sfid-20170719_211108_424985_6345CB72)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trivial cleanup of nasty variable name

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 7dd6af689ac8..f97b2234044f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -747,7 +747,7 @@ int
 brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		  u8 *data, uint size)
 {
-	int bcmerror = 0;
+	int err = 0;
 	struct sk_buff *pkt;
 	u32 sdaddr;
 	uint dsize;
@@ -772,8 +772,8 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 	/* Do the transfer(s) */
 	while (size) {
 		/* Set the backplane window to include the start address */
-		bcmerror = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
-		if (bcmerror)
+		err = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
+		if (err)
 			break;
 
 		brcmf_dbg(SDIO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
@@ -786,9 +786,9 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		skb_put(pkt, dsize);
 		if (write)
 			memcpy(pkt->data, data, dsize);
-		bcmerror = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_1, write,
+		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_1, write,
 					      sdaddr, pkt);
-		if (bcmerror) {
+		if (err) {
 			brcmf_err("membytes transfer failed\n");
 			break;
 		}
@@ -815,7 +815,7 @@ brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 
 	sdio_release_host(sdiodev->func[1]);
 
-	return bcmerror;
+	return err;
 }
 
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, u8 fn)
-- 
2.11.0
