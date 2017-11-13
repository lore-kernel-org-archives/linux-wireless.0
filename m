Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52151 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755517AbdKMUgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:03 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 02/10] brcmfmac: Register sizes on hardware are not dependent on compiler types
Date: Mon, 13 Nov 2017 21:35:39 +0100
Message-Id: <1510605347-7629-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213625_015948_E5D83AF5)
In-Reply-To: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

The 4 IO functions in this patch are incorrect as they use compiler types
to determine how many bytes to send to the hardware.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index a8976a76..25b5e9b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -264,7 +264,7 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 	func = sdiodev->func[fn];
 
 	switch (regsz) {
-	case sizeof(u8):
+	case 1:
 		if (write) {
 			if (fn)
 				sdio_writeb(func, *(u8 *)data, addr, &ret);
@@ -278,13 +278,13 @@ static int brcmf_sdiod_request_data(struct brcmf_sdio_dev *sdiodev, u8 fn,
 				*(u8 *)data = sdio_f0_readb(func, addr, &ret);
 		}
 		break;
-	case sizeof(u16):
+	case 2:
 		if (write)
 			sdio_writew(func, *(u16 *)data, addr, &ret);
 		else
 			*(u16 *)data = sdio_readw(func, addr, &ret);
 		break;
-	case sizeof(u32):
+	case 4:
 		if (write)
 			sdio_writel(func, *(u32 *)data, addr, &ret);
 		else
@@ -368,7 +368,7 @@ static int brcmf_sdiod_regrw_helper(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	for (i = 0; i < 3; i++) {
 		err = brcmf_sdiod_regrw_helper(sdiodev,
 					       SBSDIO_FUNC1_SBADDRLOW + i,
-					       sizeof(u8), &addr[i], true);
+					       1, &addr[i], true);
 		if (err) {
 			brcmf_err("failed at addr: 0x%0x\n",
 				  SBSDIO_FUNC1_SBADDRLOW + i);
@@ -407,7 +407,7 @@ u8 brcmf_sdiod_regrb(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, 1, &data,
 					  false);
 	brcmf_dbg(SDIO, "data:0x%02x\n", data);
 
@@ -423,10 +423,10 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_addrprep(sdiodev, sizeof(data), &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
 	if (retval)
 		goto done;
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, 4, &data,
 					  false);
 	brcmf_dbg(SDIO, "data:0x%08x\n", data);
 
@@ -443,7 +443,7 @@ void brcmf_sdiod_regwb(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%02x\n", addr, data);
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, 1, &data,
 					  true);
 	if (ret)
 		*ret = retval;
@@ -455,10 +455,10 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	retval = brcmf_sdiod_addrprep(sdiodev, sizeof(data), &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
 	if (retval)
 		goto done;
-	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, sizeof(data), &data,
+	retval = brcmf_sdiod_regrw_helper(sdiodev, addr, 4, &data,
 					  true);
 
 done:
@@ -876,7 +876,7 @@ int brcmf_sdiod_abort(struct brcmf_sdio_dev *sdiodev, uint fn)
 
 	/* issue abort cmd52 command through F0 */
 	brcmf_sdiod_request_data(sdiodev, SDIO_FUNC_0, SDIO_CCCR_ABORT,
-				 sizeof(t_func), &t_func, true);
+				 1, &t_func, true);
 
 	brcmf_dbg(SDIO, "Exit\n");
 	return 0;
-- 
1.9.1
