Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60274 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932699AbdHVLpl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:41 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 10/30] brcmfmac: Rename bcmerror to err
Date: Tue, 22 Aug 2017 12:25:30 +0100
Message-Id: <20170822112550.60311-11-ian@mnementh.co.uk> (sfid-20170822_134545_491473_F954C398)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trivial cleanup of nasty variable name

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 6669e28279d9..834aa3e358ce 100644
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
