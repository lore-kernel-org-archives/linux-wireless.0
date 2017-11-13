Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52159 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755523AbdKMUgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:03 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 10/10] brcmfmac: Rename bcmerror to err
Date: Mon, 13 Nov 2017 21:35:47 +0100
Message-Id: <1510605347-7629-11-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213623_997444_E91DE654)
In-Reply-To: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

Trivial cleanup of nasty variable name

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9a3f903..30ab0aa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -746,7 +746,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 brcmf_sdiod_ramrw(struct brcmf_sdio_dev *sdiodev, bool write, u32 address,
 		  u8 *data, uint size)
 {
-	int bcmerror = 0;
+	int err = 0;
 	struct sk_buff *pkt;
 	u32 sdaddr;
 	uint dsize;
@@ -771,8 +771,8 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 	/* Do the transfer(s) */
 	while (size) {
 		/* Set the backplane window to include the start address */
-		bcmerror = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
-		if (bcmerror)
+		err = brcmf_sdiod_set_sbaddr_window(sdiodev, address);
+		if (err)
 			break;
 
 		brcmf_dbg(SDIO, "%s %d bytes at offset 0x%08x in window 0x%08x\n",
@@ -785,9 +785,9 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
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
@@ -814,7 +814,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	sdio_release_host(sdiodev->func[1]);
 
-	return bcmerror;
+	return err;
 }
 
 int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, u8 fn)
-- 
1.9.1
