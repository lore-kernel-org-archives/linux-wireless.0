Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52104 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755502AbdKMUgC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:02 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 05/10] brcmfmac: Remove dead IO code
Date: Mon, 13 Nov 2017 21:35:42 +0100
Message-Id: <1510605347-7629-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213608_085631_8CE0F5A3)
In-Reply-To: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

The value passed to brcmf_sdiod_addrprep() is *always* 4
remove this parameter and the unused code to handle it.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 1ea42c3..ad81ea4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -425,7 +425,7 @@ static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
 }
 
 static int
-brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, uint width, u32 *addr)
+brcmf_sdiod_addrprep(struct brcmf_sdio_dev *sdiodev, u32 *addr)
 {
 	uint bar0 = *addr & ~SBSDIO_SB_OFT_ADDR_MASK;
 	int err = 0;
@@ -439,9 +439,7 @@ static int brcmf_sdiod_reg_read(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	}
 
 	*addr &= SBSDIO_SB_OFT_ADDR_MASK;
-
-	if (width == 4)
-		*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
+	*addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
 
 	return 0;
 }
@@ -467,7 +465,7 @@ u32 brcmf_sdiod_regrl(struct brcmf_sdio_dev *sdiodev, u32 addr, int *ret)
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x\n", addr);
-	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (retval)
 		goto done;
 
@@ -500,7 +498,7 @@ void brcmf_sdiod_regwl(struct brcmf_sdio_dev *sdiodev, u32 addr,
 	int retval;
 
 	brcmf_dbg(SDIO, "addr:0x%08x, data:0x%08x\n", addr, data);
-	retval = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	retval = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (retval)
 		goto done;
 
@@ -736,7 +734,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		goto done;
 
@@ -757,7 +755,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
 		  addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		goto done;
 
@@ -801,7 +799,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 	memcpy(mypkt->data, buf, nbytes);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 
 	if (!err)
 		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, true, addr,
@@ -821,7 +819,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
 
-	err = brcmf_sdiod_addrprep(sdiodev, 4, &addr);
+	err = brcmf_sdiod_addrprep(sdiodev, &addr);
 	if (err)
 		return err;
 
-- 
1.9.1
